local function spawnEnemy()
	local enemy = Instance.new("Part")
	enemy.Name = "Infected"
	enemy.Size = Vector3.new(4, 6, 2)
	enemy.Position = Vector3.new(-20, 3, 0)
	enemy.Color = Color3.fromRGB(255, 0, 0)
	enemy.Anchored = false
	enemy.CanCollide = true
	enemy.Parent = workspace

	local humanoid = Instance.new("Humanoid")
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	humanoid.Parent = enemy

	task.spawn(function()
		while true do
			if not enemy.Parent or humanoid.Health <= 0 then
				break
			end

			local nearestRootPart = nil
			local minDistance = math.huge

			for _, player in ipairs(game.Players:GetPlayers()) do
				local character = player.Character
				if character then
					local rootPart = character:FindFirstChild("HumanoidRootPart")
					if rootPart then
						local distance = (enemy.Position - rootPart.Position).Magnitude
						if distance < minDistance then
							minDistance = distance
							nearestRootPart = rootPart
						end
					end
				end
			end

			if nearestRootPart then
				humanoid:MoveTo(nearestRootPart.Position)
				print("Enemy is moving!")
			end

			task.wait(0.5)
		end
	end)

	enemy.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		if character then
			local targetHumanoid = character:FindFirstChild("Humanoid")
			if targetHumanoid and targetHumanoid ~= humanoid then
				targetHumanoid:TakeDamage(10)
			end
		end
	end)
end

spawnEnemy()