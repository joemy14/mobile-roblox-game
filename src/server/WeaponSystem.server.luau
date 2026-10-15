game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

game.Players.PlayerAdded:Connect(function(player)
	local tool = Instance.new("Tool")
	tool.Name = "Baston"
	tool.RequiresHandle = true

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1, 4, 1)
	handle.Color = Color3.new(0.6, 0.4, 0.2)
	handle.Parent = tool

	tool.Parent = player.Backpack

	tool.Activated:Connect(function()
		local character = player.Character
		if not character then return end
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if not rootPart then return end

		local nearestZombie, nearestDist = nil, 6
		for _, child in pairs(workspace:GetChildren()) do
			if child:IsA("Model") and child.Name == "Zombie" then
				local zombieRoot = child:FindFirstChild("HumanoidRootPart")
				if zombieRoot then
					local dist = (zombieRoot.Position - rootPart.Position).Magnitude
					if dist <= 6 and dist < nearestDist then
						nearestDist = dist
						nearestZombie = child
					end
				end
			end
		end

		if nearestZombie then
			local humanoid = nearestZombie:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.Health -= 25
				print("Hit Zombie!")
			end
		end
	end)
end)