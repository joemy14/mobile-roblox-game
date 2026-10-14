-- AIDirectorService (ModuleScript)
-- Place in: ReplicatedStorage/Shared/Modules/AIDirectorService

--!strict
--[[
	AIDirectorService
	Manages the game's pacing "Intensity" meter (0-100) and state machine (REST, BUILD_UP, HORDE).
	Calculates intensity based on aggregate player health and distance traveled.
	Handles "Mercy" mechanic when majority of players are downed.
]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Type Definitions
export type DirectorState = "REST" | "BUILD_UP" | "HORDE"

export type AIDirector = {
	Intensity: number,
	State: DirectorState,
	Update: (self: AIDirector, dt: number) -> (),
	GetState: (self: AIDirector) -> DirectorState,
	GetIntensity: (self: AIDirector) -> number,
	_players: { Player },
	_lastKnownDistance: number,
	_hordeCooldown: number,
}

-- Constants
local INTENSITY_MAX = 100
local INTENSITY_HORDE_THRESHOLD = 85
local INTENSITY_BUILDUP_THRESHOLD = 30
local MERCY_DOWNED_THRESHOLD = 0.5 -- 50%
local HORDE_COOLDOWN_DURATION = 30 -- seconds
local INTENSITY_DECAY_RATE = 2 -- per second during REST
local INTENSITY_GROWTH_RATE = 5 -- per second during BUILD_UP
local DISTANCE_INTENSITY_FACTOR = 0.01 -- Intensity per stud traveled
local HEALTH_INTENSITY_FACTOR = 0.5 -- Intensity per % health missing (avg)

local AIDirectorService = {} :: { new: () -> AIDirector }

-- Helper: Calculate average squad health percentage (0-1)
local function calculateAverageHealth(players: { Player }): number
	local totalHealth = 0
	local totalMaxHealth = 0
	local count = 0

	for _, player in players do
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				totalHealth += humanoid.Health
				totalMaxHealth += humanoid.MaxHealth
				count += 1
			end
		end
	end

	if count == 0 or totalMaxHealth == 0 then
		return 1 -- Assume full health if no valid characters
	end

	return totalHealth / totalMaxHealth
end

-- Helper: Calculate percentage of downed players (0-1)
local function calculateDownedPercentage(players: { Player }): number
	if #players == 0 then return 0 end
	
	local downedCount = 0
	for _, player in players do
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			-- Assuming "Downed" state is Health <= 0 but not dead (or a specific state attribute)
			-- Standard Roblox: Health <= 0 usually means Dead. 
			-- For "Downed" non-lethal logic, we check for an Attribute or low health threshold.
			-- Here we assume an Attribute "IsDowned" is set by damage system.
			if humanoid and (humanoid:GetAttribute("IsDowned") == true or humanoid.Health <= 1) then
				downedCount += 1
			end
		else
			-- No character usually means dead/spawning, count as downed for mercy calc
			downedCount += 1
		end
	end
	
	return downedCount / #players
end

-- Helper: Estimate distance traveled (simplified: distance from spawn/origin)
-- In a real game, this would track path length. Here we use magnitude from world origin (0,0,0) as proxy.
local function calculateAverageDistance(players: { Player }): number
	local totalDist = 0
	local count = 0
	for _, player in players do
		local character = player.Character
		if character then
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if hrp then
				totalDist += hrp.Position.Magnitude
				count += 1
			end
		end
	end
	if count == 0 then return 0 end
	return totalDist / count
end

function AIDirectorService.new(): AIDirector
	local self: AIDirector = {
		Intensity = 0,
		State = "REST",
		_players = Players:GetPlayers(),
		_lastKnownDistance = 0,
		_hordeCooldown = 0,
	}

	-- Public API
	function self:GetState(): DirectorState
		return self.State
	end

	function self:GetIntensity(): number
		return self.Intensity
	end

	function self:Update(dt: number)
		-- 1. Refresh Player List (handle joining/leaving)
		self._players = Players:GetPlayers()
		if #self._players == 0 then
			-- No players, reset to rest
			self.Intensity = math.max(0, self.Intensity - INTENSITY_DECAY_RATE * dt)
			self.State = "REST"
			self._hordeCooldown = math.max(0, self._hordeCooldown - dt)
			return
		end

		-- 2. Handle Horde Cooldown
		if self._hordeCooldown > 0 then
			self._hordeCooldown -= dt
		end

		-- 3. Calculate Metrics
		local avgHealth = calculateAverageHealth(self._players)
		local downedPct = calculateDownedPercentage(self._players)
		local avgDistance = calculateAverageDistance(self._players)

		-- Distance Delta (how much further they moved since last frame)
		local distanceDelta = math.max(0, avgDistance - self._lastKnownDistance)
		self._lastKnownDistance = avgDistance

		-- 4. Mercy Check (Priority Override)
		if downedPct >= MERCY_DOWNED_THRESHOLD then
			if self.State ~= "REST" then
				warn("[AIDirector] Mercy Triggered: >50% players downed. Forcing REST.")
			end
			self.State = "REST"
			self.Intensity = math.max(0, self.Intensity - (INTENSITY_DECAY_RATE * 3) * dt) -- Fast decay
			return
		end

		-- 5. Intensity Calculation
		-- Base intensity grows with distance traveled (progress)
		local distanceIntensity = distanceDelta * DISTANCE_INTENSITY_FACTOR
		-- Intensity grows when squad is hurt (tension)
		local healthMissing = 1 - avgHealth
		local healthIntensity = healthMissing * HEALTH_INTENSITY_FACTOR

		local intensityDelta = (distanceIntensity + healthIntensity) * dt

		-- 6. State Machine Logic
		if self.State == "REST" then
			-- Decay intensity
			self.Intensity = math.max(0, self.Intensity - INTENSITY_DECAY_RATE * dt)
			
			-- Accumulate passive buildup
			self.Intensity += intensityDelta * 0.5 -- Slower buildup at rest
			
			if self.Intensity >= INTENSITY_BUILDUP_THRESHOLD then
				self.State = "BUILD_UP"
				print("[AIDirector] State Change: REST -> BUILD_UP")
			end

		elseif self.State == "BUILD_UP" then
			-- Faster growth
			self.Intensity += intensityDelta * 1.5
			self.Intensity = math.clamp(self.Intensity, 0, INTENSITY_MAX)

			if self.Intensity >= INTENSITY_HORDE_THRESHOLD and self._hordeCooldown <= 0 then
				self.State = "HORDE"
				self._hordeCooldown = HORDE_COOLDOWN_DURATION
				print("[AIDirector] State Change: BUILD_UP -> HORDE (Intensity > 85)")
			elseif self.Intensity < INTENSITY_BUILDUP_THRESHOLD then
				-- Fell back down
				self.State = "REST"
				print("[AIDirector] State Change: BUILD_UP -> REST")
			end

		elseif self.State == "HORDE" then
			-- Maintain high intensity or decay slightly if players are crushing it
			-- Horde state usually lasts a fixed time or until intensity drops via clear.
			-- Here we just hold intensity high and count down cooldown implicitly via state exit.
			self.Intensity = math.clamp(self.Intensity, INTENSITY_HORDE_THRESHOLD, INTENSITY_MAX)
			
			-- Simple Exit Condition: Horde lasts ~20s or intensity manually dropped (not implemented here)
			-- For this test loop, we auto-exit after cooldown starts ticking in next frames if we force it,
			-- but standard design: Horde ends when "Wave Cleared" event fires.
			-- Simulation: Auto drop to BUILD_UP after 15s in Horde for testing.
			if self._hordeCooldown < (HORDE_COOLDOWN_DURATION - 15) then
				self.State = "BUILD_UP"
				self.Intensity = INTENSITY_HORDE_THRESHOLD - 5 -- Drop slightly below threshold
				print("[AIDirector] State Change: HORDE -> BUILD_UP (Simulated Wave Clear)")
			end
		end
	end
	end

	return self
end

return AIDirectorService

-- MainGameLoop (Script)
-- Place in: ServerScriptService/MainGameLoop

--!strict
--[[
	MainGameLoop
	Entry point for the server-side game pacing.
	Initializes AIDirectorService and runs the Update loop on Heartbeat.
	Prints State and Intensity to Server Output for debugging.
]]

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Load Module
local Modules = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules")
local AIDirectorService = require(Modules:WaitForChild("AIDirectorService"))

-- Initialize Director
local director = AIDirectorService.new()

print("[MainGameLoop] AIDirector Initialized. Starting Heartbeat Loop...")

-- Heartbeat Connection
local connection: RBXScriptConnection
connection = RunService.Heartbeat:Connect(function(dt: number)
	-- Update Director
	director:Update(dt)

	-- Debug Print (Throttled to once per second to avoid spam)
	-- Using a simple accumulator
	if not director._debugAccumulator then
		director._debugAccumulator = 0
	end
	
	director._debugAccumulator += dt
	if director._debugAccumulator >= 1.0 then
		director._debugAccumulator = 0
		print(string.format("[AIDirector Debug] State: %s | Intensity: %.1f", director:GetState(), director:GetIntensity()))
	end
end)

-- Cleanup on script destruction (rare for ServerScriptService but good practice)
script.Destroying:Once(function()
	if connection then
		connection:Disconnect()
	end
	print("[MainGameLoop] Stopped.")
end)