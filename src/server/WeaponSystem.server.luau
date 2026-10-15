local tool = Instance.new("Tool")
tool.Name = "Baston"
tool.RequiresHandle = true
tool.Parent = game.StarterPack

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 4, 1)
handle.Color = Color3.fromRGB(163, 162, 165)
handle.Parent = tool

tool.Activated:Connect(function()
	local player = game.Players:GetPlayerFromCharacter(tool.Parent)
	if not player then return end
	
	local character = player.Character
	if not character then return end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	
	for _, child in pairs(workspace:GetChildren()) do
		if child:IsA("Model") and child.Name == "Zombie" then
			local zombieRoot = child:FindFirstChild("HumanoidRootPart")
			if zombieRoot and (zombieRoot.Position - rootPart.Position).Magnitude <= 6 then
				local humanoid = child:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.Health -= 25
					print("Hit Zombie!")
				end
			end
		end
	end
end)

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)