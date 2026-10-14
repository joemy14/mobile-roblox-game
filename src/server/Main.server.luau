local baseplate = Instance.new("Part")
baseplate.Size = Vector3.new(200, 1, 200)
baseplate.Position = Vector3.new(0, -1, 0)
baseplate.Anchored = true
baseplate.Name = "LobbyBaseplate"
baseplate.Color = Color3.fromRGB(128, 128, 128)
baseplate.Parent = workspace

local spawn1 = Instance.new("SpawnLocation")
spawn1.Size = Vector3.new(6, 1, 6)
spawn1.Position = Vector3.new(-50, 0.5, -50)
spawn1.Anchored = true
spawn1.Parent = workspace

local spawn2 = Instance.new("SpawnLocation")
spawn2.Size = Vector3.new(6, 1, 6)
spawn2.Position = Vector3.new(50, 0.5, -50)
spawn2.Anchored = true
spawn2.Parent = workspace

local spawn3 = Instance.new("SpawnLocation")
spawn3.Size = Vector3.new(6, 1, 6)
spawn3.Position = Vector3.new(-50, 0.5, 50)
spawn3.Anchored = true
spawn3.Parent = workspace

local spawn4 = Instance.new("SpawnLocation")
spawn4.Size = Vector3.new(6, 1, 6)
spawn4.Position = Vector3.new(50, 0.5, 50)
spawn4.Anchored = true
spawn4.Parent = workspace

print("Platform created!")