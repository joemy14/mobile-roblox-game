local tablePart = Instance.new("Part")
tablePart.Name = "Table"
tablePart.Position = Vector3.new(10, 2, 10)
tablePart.Size = Vector3.new(6, 1, 4)
tablePart.Anchored = true
tablePart.Parent = workspace

local baston = Instance.new("Tool")
baston.Name = "Baston"

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 4, 1)
handle.Color = Color3.fromRGB(139, 69, 19)
handle.Parent = baston

baston.Parent = tablePart

local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Pick up Baston"
prompt.HoldDuration = 0.5
prompt.Parent = baston

prompt.Triggered:Connect(function(player)
	baston.Parent = player.Backpack
	prompt:Destroy()
end)