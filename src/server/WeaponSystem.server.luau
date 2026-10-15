local tool = Instance.new("Tool")
tool.Name = "Baston"
tool.RequiresHandle = true
tool.Parent = game.StarterPack

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 4, 1)
handle.Color = Color3.fromRGB(163, 162, 165)
handle.Parent = tool

tool.Activated:Connect(function()
	print("Swung Baston!")
end)

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)