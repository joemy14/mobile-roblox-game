local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local shopGui = Instance.new("ScreenGui")
shopGui.Name = "ShopGui"
shopGui.ResetOnSpawn = false
shopGui.Parent = playerGui

local openButton = Instance.new("TextButton")
openButton.Name = "OpenShopButton"
openButton.Text = "OPEN SHOP"
openButton.TextColor3 = Color3.new(0, 0, 0)
openButton.TextSize = 18
openButton.Font = Enum.Font.SourceSansBold
openButton.BackgroundColor3 = Color3.new(1, 1, 0)
openButton.BorderSizePixel = 2
openButton.Size = UDim2.new(0, 140, 0, 40)
openButton.AnchorPoint = Vector2.new(1, 1)
openButton.Position = UDim2.new(1, -10, 1, -10)
openButton.Parent = shopGui

local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopFrame"
shopFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
shopFrame.BorderSizePixel = 2
shopFrame.Size = UDim2.new(0, 300, 0, 350)
shopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
shopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
shopFrame.Visible = false
shopFrame.Parent = shopGui

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 8)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = shopFrame

local coinLabel = Instance.new("TextLabel")
coinLabel.Name = "CoinLabel"
coinLabel.Text = "Coins: Loading..."
coinLabel.TextColor3 = Color3.new(1, 1, 1)
coinLabel.TextSize = 24
coinLabel.Font = Enum.Font.SourceSansBold
coinLabel.BackgroundTransparency = 1
coinLabel.Size = UDim2.new(1, -20, 0, 40)
coinLabel.LayoutOrder = 1
coinLabel.Parent = shopFrame

local buttonData = {
	{Name = "BuySpeedButton", Text = "Buy Speed (100)"},
	{Name = "BuyHealthButton", Text = "Buy Health (150)"},
	{Name = "BuyFlashlightButton", Text = "Buy Flashlight (200)"},
}

for i, data in ipairs(buttonData) do
	local btn = Instance.new("TextButton")
	btn.Name = data.Name
	btn.Text = data.Text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 20
	btn.Font = Enum.Font.SourceSans
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.BorderSizePixel = 1
	btn.Size = UDim2.new(0.9, 0, 0, 50)
	btn.LayoutOrder = i + 1
	btn.Parent = shopFrame
end

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "CLOSE"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.SourceSansBold
closeButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
closeButton.BorderSizePixel = 1
closeButton.Size = UDim2.new(0.9, 0, 0, 50)
closeButton.LayoutOrder = 5
closeButton.Parent = shopFrame

openButton.MouseButton1Click:Connect(function()
	shopFrame.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
end)

local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
local coinsValue = leaderstats and leaderstats:FindFirstChild("Coins")

if coinsValue and coinsValue:IsA("IntValue") then
	coinLabel.Text = "Coins: " .. coinsValue.Value
	coinsValue:GetPropertyChangedSignal("Value"):Connect(function()
		coinLabel.Text = "Coins: " .. coinsValue.Value
	end)
else
	coinLabel.Text = "Coins: 0"
end