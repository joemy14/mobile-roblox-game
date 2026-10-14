local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local chooseRoleEvent = ReplicatedStorage:FindFirstChild("ChooseRoleEvent")
if not chooseRoleEvent then
	chooseRoleEvent = Instance.new("RemoteEvent")
	chooseRoleEvent.Name = "ChooseRoleEvent"
	chooseRoleEvent.Parent = ReplicatedStorage
end

Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local roleValue = Instance.new("StringValue")
	roleValue.Name = "Role"
	roleValue.Value = "None"
	roleValue.Parent = leaderstats

	local coinsValue = Instance.new("IntValue")
	coinsValue.Name = "Coins"
	coinsValue.Value = 500
	coinsValue.Parent = leaderstats
end)

chooseRoleEvent.OnServerEvent:Connect(function(player, roleName)
	if typeof(roleName) ~= "string" then return end
	
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local roleValue = leaderstats:FindFirstChild("Role")
	if not roleValue then return end

	roleValue.Value = roleName
	print(player.Name .. " chose " .. roleName)
end)