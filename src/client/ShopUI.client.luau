local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local leaderstats = player:WaitForChild("leaderstats")

local buyItemEvent = ReplicatedStorage:WaitForChild("BuyItemEvent")
local shopUpdateEvent = ReplicatedStorage:WaitForChild("ShopUpdateEvent")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShopGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local coinsLabel = Instance.new("TextLabel")
coinsLabel.Name = "CoinsLabel"
coinsLabel.Size = UDim2.new(1, -20, 0, 40)
coinsLabel.Position = UDim2.new(0, 10, 0, 10)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Text = "Coins: 500"
coinsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coinsLabel.TextSize = 24
coinsLabel.Font = Enum.Font.GothamBold
coinsLabel.TextXAlignment = Enum.TextXAlignment.Center
coinsLabel.Parent = frame

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, -20, 1, -60)
buttonContainer.Position = UDim2.new(0, 10, 0, 50)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
uiListLayout.Parent = buttonContainer

local itemMap = {
	["Buy Speed (100)"] = "SpeedBoost",
	["Buy Health (150)"] = "ExtraHealth",
	["Buy Flashlight (200)"] = "Flashlight"
}

local buttonTexts = {"Buy Speed (100)", "Buy Health (150)", "Buy Flashlight (200)"}

for _, text in ipairs(buttonTexts) do
	local button = Instance.new("TextButton")
	button.Name = text
	button.Size = UDim2.new(1, 0, 0, 50)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 18
	button.Font = Enum.Font.Gotham
	button.Parent = buttonContainer

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 6)
	buttonCorner.Parent = button

	button.MouseButton1Click:Connect(function()
		local itemName = itemMap[text]
		if itemName then
			buyItemEvent:FireServer(itemName)
		end
	end)
end

shopUpdateEvent.OnClientEvent:Connect(function(newCoins)
	coinsLabel.Text = "Coins: " .. tostring(newCoins)
end)