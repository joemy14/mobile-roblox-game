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
		Vector3.new(-50, 0, -50),
		Vector3.new(50, 0, -50),
		Vector3.new(-50, 0, 50),
		Vector3.new(50, 0, 50)
	}
	for i, pos in ipairs(spawnPositions) do
		local spawn = Instance.new("SpawnLocation")
		spawn.Name = "LobbySpawn" .. i
		spawn.Size = Vector3.new(10, 1, 10)
		spawn.CFrame = baseplate.CFrame * CFrame.new(pos.X, 0.5, pos.Z)
		spawn.Anchored = true
		spawn.Neutral = true
		spawn.TeamColor = BrickColor.new("White")
		spawn.AllowTeamChangeOnTouch = true
		spawn.Parent = Workspace
	end
end

local function disableFallDamage()
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			local humanoid = character:WaitForChild("Humanoid")
			humanoid.TakeDamageOnFall = false
		end)
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.TakeDamageOnFall = false
			end
		end
	end
end

local function createGameStarter()
	local starter = Instance.new("Part")
	starter.Name = "GameStarter"
	starter.Shape = Enum.PartType.Cylinder
	starter.Size = Vector3.new(5, 10, 10)
	starter.Position = Vector3.new(0, 5, -80)
	starter.Anchored = true
	starter.CanCollide = false
	starter.Material = Enum.Material.Neon
	starter.Color = Color3.fromRGB(0, 100, 255)
	starter.Transparency = 0.2
	starter.Parent = Workspace

	local pointLight = Instance.new("PointLight")
	pointLight.Color = Color3.fromRGB(0, 150, 255)
	pointLight.Brightness = 2
	pointLight.Range = 20
	pointLight.Parent = starter

	starter.Touched:Connect(function(hit)
		local character = hit.Parent
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			print("Game starting...")
		end
	end)
end

local baseplate = createBaseplate()
createSpawnLocations(baseplate)
disableFallDamage()
createGameStarter()