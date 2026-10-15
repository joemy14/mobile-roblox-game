local CollectionService = game:GetService("CollectionService")

local function setupZombie(zombie)
	if not (zombie:IsA("Model") or zombie:IsA("BasePart")) then return end
	local humanoid = zombie:FindFirstChild("Humanoid") or zombie:WaitForChild("Humanoid", 5)
	if not humanoid then return end
	
	humanoid.HealthChanged:Connect(function(health)
		if health <= 0 then
			local humanoidRootPart = zombie:FindFirstChild("HumanoidRootPart")
			local dropPos = humanoidRootPart and humanoidRootPart.Position or zombie:GetPivot().Position
			zombie:Destroy()
			task.wait(0.5)
			
			local coin = Instance.new("Part")
			coin.Name = "Coin"
			coin.Size = Vector3.new(1, 0.2, 1)
			coin.Position = dropPos + Vector3.new(0, 2, 0)
			coin.Anchored = true
			coin.BrickColor = BrickColor.new("Bright yellow")
			coin.Material = Enum.Material.Neon
			coin.Parent = workspace
			
			local prompt = Instance.new("ProximityPrompt")
			prompt.ActionText = "Collect (+50)"
			prompt.HoldDuration = 0
			prompt.Parent = coin
			
			prompt.Triggered:Connect(function(player)
				local leaderstats = player:FindFirstChild("leaderstats")
				local coins = leaderstats and leaderstats:FindFirstChild("Coins")
				if coins and coins:IsA("IntValue") then coins.Value += 50 end
				coin:Destroy()
			end)
		end
	end)
end

for _, child in workspace:GetChildren() do
	if child.Name == "Zombie" then setupZombie(child) end
end

workspace.ChildAdded:Connect(function(child)
	if child.Name == "Zombie" then setupZombie(child) end
end)