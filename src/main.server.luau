local LobbyBaseplate = Workspace:FindFirstChild("LobbyBaseplate")

if not LobbyBaseplate then
	LobbyBaseplate = Instance.new("Part")
	LobbyBaseplate.Name = "LobbyBaseplate"
	LobbyBaseplate.Size = Vector3.new(200, 1, 200)
	LobbyBaseplate.Position = Vector3.new(0, -1, 0)
	LobbyBaseplate.Anchored = true
	LobbyBaseplate.Color = Color3.fromRGB(128, 128, 128)
	LobbyBaseplate.Parent = Workspace
end

local SpawnLocation = Instance.new("SpawnLocation")
SpawnLocation.Size = Vector3.new(6, 1, 6)
SpawnLocation.Position = Vector3.new(0, 0.5, 0)
SpawnLocation.Anchored = true
SpawnLocation.Neutral = true
SpawnLocation.Parent = Workspace

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEvent = Instance.new("RemoteEvent")
TestEvent.Name = "TestEvent"
TestEvent.Parent = ReplicatedStorage

print("Server started successfully!")