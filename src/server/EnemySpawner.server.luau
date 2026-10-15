local function spawnZombie()
	local zombie = Instance.new("Model")
	zombie.Name = "Zombie"
	zombie.Parent = workspace

	local parts = {}

	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(2, 2, 2)
	head.Color = Color3.fromRGB(0, 100, 0)
	head.Anchored = false
	head.CanCollide = true
	head.Parent = zombie
	table.insert(parts, head)

	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2, 2, 1)
	torso.Color = Color3.fromRGB(0, 100, 0)
	torso.Anchored = false
	torso.CanCollide = true
	torso.Parent = zombie
	table.insert(parts, torso)

	local leftArm = Instance.new("Part")
	leftArm.Name = "Left Arm"
	leftArm.Size = Vector3.new(1, 2, 1)
	leftArm.Color = Color3.fromRGB(0, 100, 0)
	leftArm.Anchored = false
	leftArm.CanCollide = true
	leftArm.Parent = zombie
	table.insert(parts, leftArm)

	local rightArm = Instance.new("Part")
	rightArm.Name = "Right Arm"
	rightArm.Size = Vector3.new(1, 2, 1)
	rightArm.Color = Color3.fromRGB(0, 100, 0)
	rightArm.Anchored = false
	rightArm.CanCollide = true
	rightArm.Parent = zombie
	table.insert(parts, rightArm)

	local leftLeg = Instance.new("Part")
	leftLeg.Name = "Left Leg"
	leftLeg.Size = Vector3.new(1, 2, 1)
	leftLeg.Color = Color3.fromRGB(0, 100, 0)
	leftLeg.Anchored = false
	leftLeg.CanCollide = true
	leftLeg.Parent = zombie
	table.insert(parts, leftLeg)

	local rightLeg = Instance.new("Part")
	rightLeg.Name = "Right Leg"
	rightLeg.Size = Vector3.new(1, 2, 1)
	rightLeg.Color = Color3.fromRGB(0, 100, 0)
	rightLeg.Anchored = false
	rightLeg.CanCollide = true
	rightLeg.Parent = zombie
	table.insert(parts, rightLeg)

	local humanoidRootPart = Instance.new("Part")
	humanoidRootPart.Name = "HumanoidRootPart"
	humanoidRootPart.Size = Vector3.new(2, 2, 1)
	humanoidRootPart.Transparency = 1
	humanoidRootPart.CanCollide = false
	humanoidRootPart.Anchored = false
	humanoidRootPart.Parent = zombie
	table.insert(parts, humanoidRootPart)

	for _, part in ipairs(parts) do
		if part ~= humanoidRootPart then
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = humanoidRootPart
			weld.Part1 = part
			weld.Parent = humanoidRootPart
		end
	end

	local humanoid = Instance.new("Humanoid")
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	humanoid.Parent = zombie

	zombie:MoveTo(Vector3.new(-20, 5, 0))

	task.spawn(function()
		while true do
			if not zombie.Parent or humanoid.Health <= 0 then
				break
			end

			local nearestRootPart = nil
			local minDistance = math.huge

			for _, player in ipairs(game.Players:GetPlayers()) do
				local character = player.Character
				if character then
					local rootPart = character:FindFirstChild("HumanoidRootPart")
					if rootPart then
						local distance = (humanoidRootPart.Position - rootPart.Position).Magnitude
						if distance < minDistance then
							minDistance = distance
							nearestRootPart = rootPart
						end
					end
				end
			end

			if nearestRootPart then
				humanoid:MoveTo(nearestRootPart.Position)
				print("Zombie is moving!")
			end

			task.wait(0.5)
		end
	end)

	humanoidRootPart.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		if character then
			local targetHumanoid = character:FindFirstChild("Humanoid")
			if targetHumanoid and targetHumanoid ~= humanoid then
				targetHumanoid:TakeDamage(10)
			end
		end
	end)
end

spawnZombie()