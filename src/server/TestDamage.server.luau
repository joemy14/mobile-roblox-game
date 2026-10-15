local part = Instance.new("Part")
part.Name = "DamageBlock"
part.Size = Vector3.new(10, 1, 10)
part.Position = Vector3.new(20, 0, 20)
part.Anchored = true
part.BrickColor = BrickColor.new("Really red")
part.Parent = workspace

part.Touched:Connect(function(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:TakeDamage(100)
			print("Player took damage!")
		end
	end
end)