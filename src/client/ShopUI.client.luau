local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shopGui = Instance.new("ScreenGui")
shopGui.Name = "ShopGui"
shopGui.ResetOnSpawn = false
shopGui.Parent = playerGui

local openButton = Instance.new("TextButton")
openButton.Name = "OpenShopButton"
openButton.Text = "OPEN SHOP"
openButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
openButton.TextColor3 = Color3.fromRGB(0, 0, 0)
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 18
openButton.Size = UDim2.new(0, 140, 0, 40)
openButton.Position = UDim2.new(1, -150, 1, -50)
openButton.AnchorPoint = Vector2.new(1, 1)
openButton.Parent = shopGui

local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopFrame"
shopFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
shopFrame.BorderSizePixel = 0
shopFrame.Size = UDim2.new(0, 300, 0, 350)
shopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
shopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
shopFrame.Visible = false
shopFrame.Parent = shopGui

local coinLabel = Instance.new("TextLabel")
coinLabel.Name = "CoinLabel"
coinLabel.Text = "Coins: 0"
coinLabel.BackgroundTransparency = 1
coinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coinLabel.Font = Enum.Font.SourceSansBold
coinLabel.TextSize = 24
coinLabel.Size = UDim2.new(1, -20, 0, 40)
coinLabel.Position = UDim2.new(0, 10, 0, 10)
coinLabel.TextXAlignment = Enum.TextXAlignment.Left
coinLabel.Parent = shopFrame

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.BackgroundTransparency = 1
buttonContainer.Size = UDim2.new(1, -20, 1, -100)
buttonContainer.Position = UDim2.new(0, 10, 0, 60)
buttonContainer.Parent = shopFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
uiListLayout.Parent = buttonContainer

local buyItems = {
	{name = "SpeedBoost", display = "Buy Speed (100)"},
	{name = "ExtraHealth", display = "Buy Health (150)"},
	{name = "Flashlight", display = "Buy Flashlight (200)"}
}

for _, item in ipairs(buyItems) do
	local btn = Instance.new("TextButton")
	btn.Name = item.name .. "Button"
	btn.Text = item.display
	btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.Size = UDim2.new(1, 0, 0, 45)
	btn.Parent = buttonContainer
	
	btn.MouseButton1Click:Connect(function()
		local buyEvent = ReplicatedStorage:FindFirstChild("BuyItemEvent")
		if buyEvent then
			buyEvent:FireServer(item.name)
		end
	end)
end

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "CLOSE"
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Size = UDim2.new(1, -20, 0, 40)
closeButton.Position = UDim2.new(0, 10, 1, -50)
closeButton.AnchorPoint = Vector2.new(0, 1)
closeButton.Parent = shopFrame

local buyEvent = ReplicatedStorage:WaitForChild("BuyItemEvent")
local updateEvent = ReplicatedStorage:WaitForChild("ShopUpdateEvent")

updateEvent.OnClientEvent:Connect(function(newAmount)
	coinLabel.Text = "Coins: " .. tostring(newAmount)
end)

local function updateCoinsFromLeaderstats()
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins and coins:IsA("IntValue") then
			coinLabel.Text = "Coins: " .. tostring(coins.Value)
		end
	end
end

openButton.MouseButton1Click:Connect(function()
	updateCoinsFromLeaderstats()
	shopFrame.Visible = true
	openButton.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
	openButton.Visible = true
end)