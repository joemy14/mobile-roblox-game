-- Server Script for Role Selection System
-- Place this script in ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create the RemoteEvent in ReplicatedStorage
local chooseRoleEvent = Instance.new("RemoteEvent")
chooseRoleEvent.Name = "ChooseRoleEvent"
chooseRoleEvent.Parent = ReplicatedStorage

-- Function to set up leaderstats for a player
local function setupLeaderstats(player: Player)
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
end

-- Handle player joining
Players.PlayerAdded:Connect(function(player: Player)
	setupLeaderstats(player)
end)

-- Listen for role selection from clients
chooseRoleEvent.OnServerEvent:Connect(function(player: Player, roleName: string)
	-- Validate the player has leaderstats and Role value
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		warn("leaderstats not found for " .. player.Name)
		return
	end

	local roleValue = leaderstats:FindFirstChild("Role")
	if not roleValue or not roleValue:IsA("StringValue") then
		warn("Role StringValue not found for " .. player.Name)
		return
	end

	-- Update the role
	roleValue.Value = roleName
	print(string.format("[%s] chose role: [%s]", player.Name, roleName))
end)

print("Role selection system initialized")