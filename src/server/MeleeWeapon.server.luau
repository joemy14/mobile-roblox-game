local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	local tool = Instance.new("Tool")
	tool.Name = "Baston"
	tool.RequiresHandle = true
	tool.Parent = player:WaitForChild("StarterPack")

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1, 4, 1)
	handle.Color = Color3.fromRGB(128, 128, 128)
	handle.Anchored = false
	handle.CanCollide = false
	handle.Massless = true
	handle.Parent = tool

	local weld = Instance.new("Weld")
	weld.Part0 = handle
	weld.C0 = CFrame.new(0, -1.5, 0) * CFrame.Angles(math.rad(-90), 0, 0)
	weld.Parent = handle

	tool.Activated:Connect(function()
		local character = player.Character
		if not character then return end
		
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {character}
		params.MaxParts = 10

		local parts = workspace:GetPartBoundsInRadius(hrp.Position, 5, params)
		
		for _, part in parts do
			local model = part:FindFirstAncestor("Zombie")
			if model and model.Name == "Zombie" then
				local humanoid = model:FindFirstChild("Humanoid")
				if humanoid then
					humanoid:TakeDamage(25)
					print("Hit zombie!")
					break
				end
			end
		end
	end)
end)