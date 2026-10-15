local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:FindFirstChild("Humanoid")
		if not humanoid then return end

		humanoid.HealthChanged:Connect(function(health)
			if health <= 0 then
				humanoid.Health = 1
				character:SetAttribute("IsDowned", true)
				print(`[{player.Name}] is DOWNED!`)
			end
		end)
	end)
end)