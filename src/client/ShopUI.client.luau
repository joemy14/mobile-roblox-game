local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ShopGui = Instance.new("ScreenGui")
ShopGui.Name = "ShopGui"
ShopGui.ResetOnSpawn = false
ShopGui.Parent = PlayerGui

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 150, 0, 50)
OpenButton.Position = UDim2.new(1, -160, 1, -60)
OpenButton.AnchorPoint = Vector2.new(0, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
OpenButton.Text = "OPEN SHOP"
OpenButton.TextScaled = true
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
OpenButton.Parent = ShopGui

local ShopFrame = Instance.new("Frame")
ShopFrame.Name = "ShopFrame"
ShopFrame.Size = UDim2.new(0, 300, 0, 350)
ShopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ShopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ShopFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ShopFrame.BorderSizePixel = 0
ShopFrame.Visible = false
ShopFrame.Parent = ShopGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ShopFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 15)
UIPadding.PaddingBottom = UDim.new(0, 15)
UIPadding.PaddingLeft = UDim.new(0, 15)
UIPadding.PaddingRight = UDim.new(0, 15)
UIPadding.Parent = ShopFrame

local CoinLabel = Instance.new("TextLabel")
CoinLabel.Name = "CoinLabel"
CoinLabel.Size = UDim2.new(1, 0, 0, 40)
CoinLabel.BackgroundTransparency = 1
CoinLabel.Text = "Coins: 0"
CoinLabel.TextScaled = true
CoinLabel.Font = Enum.Font.SourceSansBold
CoinLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
CoinLabel.TextXAlignment = Enum.TextXAlignment.Center
CoinLabel.LayoutOrder = 1
CoinLabel.Parent = ShopFrame

local BuySpeed = Instance.new("TextButton")
BuySpeed.Name = "BuySpeed"
BuySpeed.Size = UDim2.new(1, 0, 0, 50)
BuySpeed.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BuySpeed.Text = "Buy Speed (100)"
BuySpeed.TextScaled = true
BuySpeed.Font = Enum.Font.SourceSans
BuySpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
BuySpeed.LayoutOrder = 2
BuySpeed.Parent = ShopFrame

local BuyHealth = Instance.new("TextButton")
BuyHealth.Name = "BuyHealth"
BuyHealth.Size = UDim2.new(1, 0, 0, 50)
BuyHealth.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BuyHealth.Text = "Buy Health (150)"
BuyHealth.TextScaled = true
BuyHealth.Font = Enum.Font.SourceSans
BuyHealth.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyHealth.LayoutOrder = 3
BuyHealth.Parent = ShopFrame

local BuyFlashlight = Instance.new("TextButton")
BuyFlashlight.Name = "BuyFlashlight"
BuyFlashlight.Size = UDim2.new(1, 0, 0, 50)
BuyFlashlight.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BuyFlashlight.Text = "Buy Flashlight (200)"
BuyFlashlight.TextScaled = true
BuyFlashlight.Font = Enum.Font.SourceSans
BuyFlashlight.TextColor3 = Color3.fromRGB(255, 255, 255)
BuyFlashlight.LayoutOrder = 4
BuyFlashlight.Parent = ShopFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(1, 0, 0, 50)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "CLOSE"
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.LayoutOrder = 5
CloseButton.Parent = ShopFrame

local BuyItemEvent = ReplicatedStorage:WaitForChild("BuyItemEvent")
local ShopUpdateEvent = ReplicatedStorage:WaitForChild("ShopUpdateEvent")

local function updateCoinLabel(amount)
	CoinLabel.Text = "Coins: " .. tostring(amount)
end

local function tryUpdateCoinsFromLeaderstats()
	local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins and coins:IsA("IntValue") then
			updateCoinLabel(coins.Value)
		end
	end
end

OpenButton.MouseButton1Click:Connect(function()
	ShopFrame.Visible = true
	tryUpdateCoinsFromLeaderstats()
end)

CloseButton.MouseButton1Click:Connect(function()
	ShopFrame.Visible = false
end)

BuySpeed.MouseButton1Click:Connect(function()
	BuyItemEvent:FireServer("SpeedBoost")
end)

BuyHealth.MouseButton1Click:Connect(function()
	BuyItemEvent:FireServer("ExtraHealth")
end)

BuyFlashlight.MouseButton1Click:Connect(function()
	BuyItemEvent:FireServer("Flashlight")
end)

ShopUpdateEvent.OnClientEvent:Connect(function(newAmount)
	updateCoinLabel(newAmount)
end)