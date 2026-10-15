local damageBlock = workspace:FindFirstChild("DamageBlock")
if damageBlock then damageBlock:Destroy() end

local testDummy = workspace:FindFirstChild("TestDummy")
if testDummy then testDummy:Destroy() end

local healBlock = Instance.new("Part")
healBlock.Name = "HealBlock"
healBlock.Color = Color3.fromRGB(0, 0, 255)
healBlock.Position = Vector3.new(10, 1, 10)
healBlock.Size = Vector3.new(10, 1, 10)
healBlock.Anchored = true
healBlock.Parent = workspace

healBlock.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Health = 100
		character:SetAttribute("IsDowned", false)
		humanoid.Sit = false
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
		print("Player healed!")
	end
end)