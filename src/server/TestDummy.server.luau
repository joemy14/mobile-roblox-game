local dummy = Instance.new("Part")
dummy.Name = "TestDummy"
dummy.Size = Vector3.new(4, 6, 2)
dummy.Position = Vector3.new(0, 3, 10)
dummy.Anchored = true
dummy.Color = Color3.fromRGB(200, 200, 200)
dummy.Parent = workspace

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Revive Dummy"
prompt.HoldDuration = 3
prompt.RequiresLineOfSight = false
prompt.Parent = dummy

prompt.Triggered:Connect(function()
	dummy.Color = Color3.fromRGB(0, 255, 0)
end)