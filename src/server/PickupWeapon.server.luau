local part = Instance.new("Part")
part.Name = "TestObject"
part.Shape = Enum.PartType.Ball
part.Position = Vector3.new(50, 15, 50)
part.Size = Vector3.new(4, 4, 4)
part.BrickColor = BrickColor.new("Bright yellow")
part.Anchored = false
part.Parent = workspace

local tablePart = Instance.new("Part")
tablePart.Name = "Table"
tablePart.Position = Vector3.new(40, 3, 40)
tablePart.Size = Vector3.new(6, 1, 4)
tablePart.BrickColor = BrickColor.new("Brown")
tablePart.Anchored = true
tablePart.Parent = workspace

local baston = Instance.new("Tool")
baston.Name = "Baston"
baston.Parent = tablePart

baston.Activated:Connect(function()
	local character = baston.Parent
	if character and character:IsA("Model") then
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and obj.Name == "Zombie" then
					local zombieRootPart = obj:FindFirstChild("HumanoidRootPart")
					local zombieHumanoid = obj:FindFirstChild("Humanoid")
					if zombieRootPart and zombieHumanoid then
						local distance = (zombieRootPart.Position - humanoidRootPart.Position).Magnitude
						if distance <= 6 then
							zombieHumanoid:TakeDamage(25)
							print("Hit Zombie!")
						end
					end
				end
			end
		end
	end
end)

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 4, 1)
handle.BrickColor = BrickColor.new("Brown")
handle.Position = Vector3.new(40, 5.5, 40)
handle.Parent = baston

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Pick up Baston"
prompt.HoldDuration = 0.5
prompt.Parent = baston

prompt.Triggered:Connect(function(player)
	baston.Parent = player.Backpack
end)