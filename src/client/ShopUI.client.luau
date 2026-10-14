local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shopGui = Instance.new("ScreenGui")
shopGui.Name = "ShopGui"
shopGui.ResetOnSpawn = false
shopGui.Parent = playerGui

local openButton = Instance.new("TextButton")
openButton.Name = "OpenShopButton"
openButton.Text = "Open Shop"
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 18
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.TextStrokeTransparency = 0.8
openButton.Size = UDim2.new(0, 160, 0, 50)
openButton.Position = UDim2.new(1, -180, 1, -70)
openButton.AnchorPoint = Vector2.new(0, 0)
openButton.BackgroundColor3 = Color3.new(1, 1, 1)
openButton.BorderSizePixel = 0
openButton.Parent = shopGui

local openGradient = Instance.new("UIGradient")
openGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 255, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 50))
})
openGradient.Rotation = 90
openGradient.Parent = openButton

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0.3, 0)
openCorner.Parent = openButton

local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopFrame"
shopFrame.Size = UDim2.new(0, 300, 0, 400)
shopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
shopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
shopFrame.BackgroundColor3 = Color3.new(1, 1, 1)
shopFrame.BorderSizePixel = 0
shopFrame.Visible = false
shopFrame.Parent = shopGui

local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 30, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 30))
})
frameGradient.Rotation = 90
frameGradient.Parent = shopFrame

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0.2, 0)
frameCorner.Parent = shopFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = shopFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 15)
padding.PaddingBottom = UDim.new(0, 15)
padding.PaddingLeft = UDim.new(0, 15)
padding.PaddingRight = UDim.new(0, 15)
padding.Parent = shopFrame

local coinLabel = Instance.new("TextLabel")
coinLabel.Name = "CoinLabel"
coinLabel.Text = "Coins: 0"
coinLabel.Font = Enum.Font.GothamBold
coinLabel.TextSize = 24
coinLabel.TextColor3 = Color3.new(1, 1, 1)
coinLabel.BackgroundTransparency = 1
coinLabel.Size = UDim2.new(1, 0, 0, 40)
coinLabel.LayoutOrder = 1
coinLabel.Parent = shopFrame

local function createBuyButton(text, layoutOrder, itemName)
	local btn = Instance.new("TextButton")
	btn.Name = itemName .. "Button"
	btn.Text = text
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 20
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Size = UDim2.new(1, 0, 0, 50)
	btn.BackgroundColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0
	btn.LayoutOrder = layoutOrder
	btn.Parent = shopFrame

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 100)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 50))
	})
	grad.Rotation = 90
	grad.Parent = btn

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = btn

	return btn
end

local speedBtn = createBuyButton("Buy Speed (100)", 2, "Speed")
local healthBtn = createBuyButton("Buy Health (150)", 3, "Health")
local flashlightBtn = createBuyButton("Buy Flashlight (200)", 4, "Flashlight")

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "CLOSE"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Size = UDim2.new(1, 0, 0, 50)
closeButton.BackgroundColor3 = Color3.new(1, 1, 1)
closeButton.BorderSizePixel = 0
closeButton.LayoutOrder = 5
closeButton.Parent = shopFrame

local closeGradient = Instance.new("UIGradient")
closeGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 0))
})
closeGradient.Rotation = 90
closeGradient.Parent = closeButton

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.2, 0)
closeCorner.Parent = closeButton

local buyItemEvent = ReplicatedStorage:WaitForChild("BuyItemEvent")
local shopUpdateEvent = ReplicatedStorage:WaitForChild("ShopUpdateEvent")

openButton.MouseButton1Click:Connect(function()
	shopFrame.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
end)

local buttons = {
	[speedBtn] = "Speed",
	[healthBtn] = "Health",
	[flashlightBtn] = "Flashlight"
}

for btn, itemName in pairs(buttons) do
	btn.MouseButton1Click:Connect(function()
		buyItemEvent:FireServer(itemName)
	end)
end

shopUpdateEvent.OnClientEvent:Connect(function(coins)
	coinLabel.Text = "Coins: " .. tostring(coins)
end)