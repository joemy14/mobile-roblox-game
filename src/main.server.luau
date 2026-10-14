local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- 1. Create lobby floor: 200x200 studs at (0,0,0), gray color
local lobbyFloor = Instance.new("Part")
lobbyFloor.Name = "LobbyFloor"
lobbyFloor.Size = Vector3.new(200, 1, 200)
lobbyFloor.Position = Vector3.new(0, 0, 0)
lobbyFloor.Anchored = true
lobbyFloor.Color = Color3.fromRGB(128, 128, 128)
lobbyFloor.Material = Enum.Material.Concrete
lobbyFloor.Parent = Workspace

-- 2. Create 4 SpawnLocation objects on the platform
local spawnPositions = {
	Vector3.new(-50, 1, -50),
	Vector3.new(50, 1, -50),
	Vector3.new(-50, 1, 50),
	Vector3.new(50, 1, 50)
}

for i, pos in ipairs(spawnPositions) do
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "LobbySpawn" .. i
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Position = pos
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.AllowTeamChangeOnTouch = true
	spawn.Color = Color3.fromRGB(200, 200, 200)
	spawn.Material = Enum.Material.Neon
	spawn.Parent = Workspace
end

-- 3. Create GameStarter part: glowing blue cylinder at (0, 5, -80)
local gameStarter = Instance.new("Part")
gameStarter.Name = "GameStarter"
gameStarter.Shape = Enum.PartType.Cylinder
gameStarter.Size = Vector3.new(4, 8, 8)
gameStarter.Position = Vector3.new(0, 5, -80)
gameStarter.Anchored = true
gameStarter.Color = Color3.fromRGB(0, 170, 255)
gameStarter.Material = Enum.Material.Neon
gameStarter.CanCollide = false
gameStarter.Parent = Workspace

-- Add PointLight for glow effect
local light = Instance.new("PointLight")
light.Color = Color3.fromRGB(0, 170, 255)
light.Brightness = 2
light.Range = 20
light.Parent = gameStarter

-- Touch event: print when player touches GameStarter
gameStarter.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)
	if player then
		print("Player wants to start game!")
	end
end)

-- 4. Add skybox with daytime sky
local sky = Instance.new("Sky")
sky.SkyboxBk = "rbxasset://sky/sb_back.jpg"
sky.SkyboxDn = "rbxasset://sky/sb_down.jpg"
sky.SkyboxFt = "rbxasset://sky/sb_front.jpg"
sky.SkyboxLf = "rbxasset://sky/sb_left.jpg"
sky.SkyboxRt = "rbxasset://sky/sb_right.jpg"
sky.SkyboxUp = "rbxasset://sky/sb_up.jpg"
sky.SunTextureId = "rbxasset://sky/sun.jpg"
sky.MoonTextureId = "rbxasset://sky/moon.jpg"
sky.SunAngularSize = 10
sky.MoonAngularSize = 10
sky.Parent = Lighting

-- Set time of day to daytime
Lighting.TimeOfDay = "14:00:00"
Lighting.ClockTime = 14
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(138, 138, 138)
Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)

-- 5. Prevent fall damage in lobby
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		if humanoid then
			humanoid.FallDamage = false
		end
	end)
end)

print("Pre-game lobby initialized successfully!")