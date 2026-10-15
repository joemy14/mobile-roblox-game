local function createPart(name, position, size, color, shape)
	local part = Instance.new("Part")
	part.Name = name
	part.Position = position
	part.Size = size
	part.Color = color
	part.Anchored = true
	part.Shape = shape or Enum.PartType.Block
	part.Material = Enum.Material.Wood
	part.Parent = workspace
	return part
end

local brown = Color3.fromRGB(120, 80, 50)
local green = Color3.fromRGB(40, 120, 40)

createPart("SariSariCounter", Vector3.new(15, 2, 15), Vector3.new(10, 2, 4), brown)

local cratePositions = {Vector3.new(5, 1, 5), Vector3.new(7, 1, 5), Vector3.new(5, 3, 5)}
for i, pos in ipairs(cratePositions) do
	createPart("Crate"..i, pos, Vector3.new(2, 2, 2), brown)
end

createPart("TreeTrunk", Vector3.new(-15, 4, -15), Vector3.new(3, 8, 3), brown, Enum.PartType.Cylinder)
createPart("TreeLeaves", Vector3.new(-15, 8, -15), Vector3.new(8, 8, 8), green, Enum.PartType.Ball)