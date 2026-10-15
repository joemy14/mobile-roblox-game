local CollectionService = game:GetService("CollectionService")

workspace.ChildAdded:Connect(function(child)
	if child.Name == "Zombie" and child:IsA("Model") then
		local humanoid = child:WaitForChild("Humanoid", 5)
		if not humanoid then return end
		
		humanoid.HealthChanged:Connect(function(health)
			if health <= 0 then
				local position = child:GetPivot().Position
				child:Destroy()
				
				task.wait(0.5)
				
				local coin = Instance.new("Part")
				coin.Name = "Coin"
				coin.Size = Vector3.new(1, 0.2, 1)
				coin.Position = position + Vector3.new(0, 2, 0)
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
					if coins and coins:IsA("IntValue") then
						coins.Value += 50
					end
					coin:Destroy()
				end)
			end
		end)
	end
end)