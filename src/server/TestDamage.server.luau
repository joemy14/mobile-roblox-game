local part = Instance.new("Part")
part.Name = "DamageBlock"
part.Size = Vector3.new(10, 1, 10)
part.Position = Vector3.new(20, 1, 20)
part.Anchored = true
part.Color = Color3.fromRGB(255, 0, 0)
part.Parent = workspace

part.Touched:Connect(function(hit)
	print("Block touched!")
end)