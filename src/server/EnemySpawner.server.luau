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

	local function getNearestRootPart()
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

		return nearestRootPart
	end

	task.spawn(function()
		while enemy.Parent and humanoid.Health > 0 do
			local targetRootPart = getNearestRootPart()
			if targetRootPart then
				humanoid:MoveTo(targetRootPart.Position)
			end
			task.wait(1)
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