local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local function createBaseplate()
	local baseplate = Workspace:FindFirstChild("LobbyBaseplate")
	if not baseplate then
		baseplate = Instance.new("Part")
		baseplate.Name = "LobbyBaseplate"
		baseplate.Size = Vector3.new(200, 1, 200)
		baseplate.Position = Vector3.new(0, -1, 0)
		baseplate.Anchored = true
		baseplate.Color = Color3.fromRGB(128, 128, 128)
		baseplate.Material = Enum.Material.Concrete
		baseplate.Parent = Workspace
	end
	return baseplate
end

local function createSpawnLocations(baseplate)
	local spawnPositions = {
		Vector3.new(-80, 0.5, -80),
		Vector3.new(80, 0.5, -80),
		Vector3.new(-80, 0.5, 80),
		Vector3.new(80, 0.5, 80)
	}

	for i, pos in ipairs(spawnPositions) do
		local spawnName = "SpawnLocation_" .. i
		if not Workspace:FindFirstChild(spawnName) then
			local spawn = Instance.new("SpawnLocation")
			spawn.Name = spawnName
			spawn.Size = Vector3.new(6, 1, 6)
			spawn.Position = pos
			spawn.Anchored = true
			spawn.Neutral = true
			spawn.AllowTeamChangeOnTouch = false
			spawn.Color = Color3.fromRGB(100, 100, 100)
			spawn.Material = Enum.Material.Concrete
			spawn.Parent = Workspace
		end
	end
end

local function disableFallDamage(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		if humanoid then
			humanoid.TakeDamageOnFall = false
		end
	end)
end

local function createGameStarter()
	if not Workspace:FindFirstChild("GameStarter") then
		local starter = Instance.new("Part")
		starter.Name = "GameStarter"
		starter.Shape = Enum.PartType.Cylinder
		starter.Size = Vector3.new(4, 6, 6)
		starter.Position = Vector3.new(0, 5, -80)
		starter.Anchored = true
		starter.CanCollide = false
		starter.Color = Color3.fromRGB(0, 100, 255)
		starter.Material = Enum.Material.Neon
		starter.Parent = Workspace

		local pointLight = Instance.new("PointLight")
		pointLight.Color = Color3.fromRGB(0, 100, 255)
		pointLight.Range = 15
		pointLight.Brightness = 2
		pointLight.Parent = starter

		starter.Touched:Connect(function(hit)
			local character = hit:FindFirstAncestorOfClass("Model")
			if character then
				local player = Players:GetPlayerFromCharacter(character)
				if player then
					print("Game starting...")
				end
			end
		end)
	end
end

local baseplate = createBaseplate()
createSpawnLocations(baseplate)
createGameStarter()

Players.PlayerAdded:Connect(disableFallDamage)

for _, player in ipairs(Players:GetPlayers()) do
	disableFallDamage(player)
end