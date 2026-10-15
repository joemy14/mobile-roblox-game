lua
-- Lightweight Test Dummy Spawner (Server Script)

local dummy = Instance.new("Part")
dummy.Name = "TestDummy"
dummy.Size = Vector3.new(4, 6, 2)
dummy.Position = Vector3.new(0, 5, 10)
dummy.Anchored = true
dummy.Color = Color3.fromRGB(200, 200, 200) -- Light Gray
dummy.Parent = workspace

local humanoid = Instance.new("Humanoid")
humanoid.MaxHealth = 1
humanoid.Health = 1
humanoid.Sit = true
humanoid.WalkSpeed = 0
humanoid.Parent = dummy

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Revive Dummy"
prompt.HoldDuration = 3
prompt.RequiresLineOfSight = false
prompt.Parent = dummy

prompt.Triggered:Connect(function()
	humanoid.Health = 50
	humanoid.Sit = false
	humanoid.WalkSpeed = 16
	dummy.Color = Color3.fromRGB(0, 255, 0) -- Bright Green
end)