local part = Instance.new("Part")
part.Name = "DamageBlock"
part.Size = Vector3.new(10, 1, 10)
part.Position = Vector3.new(20, 1, 20)
part.Anchored = true
part.Color = Color3.fromRGB(255, 0, 0)
part.Parent = workspace

local function setupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	
	humanoid.HealthChanged:Connect(function(health)
		if health <= 0 then
			humanoid.Health = 1
			character:SetAttribute("IsDowned", true)
		end
	end)
end

part.Touched:Connect(function(hit)
	print("Block touched!")
	
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	
	if humanoid then
		humanoid:TakeDamage(100)
	end
end)

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(setupCharacter)
end)

for _, player in ipairs(game.Players:GetPlayers()) do
	if player.Character then
		setupCharacter(player.Character)
	end
end