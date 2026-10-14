local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local shopGui = Instance.new("ScreenGui")
shopGui.Name = "ShopGui"
shopGui.ResetOnSpawn = false
shopGui.Parent = PlayerGui

local openButton = Instance.new("TextButton")
openButton.Name = "OpenShopButton"
openButton.Text = "OPEN SHOP"
openButton.TextColor3 = Color3.new(0, 0, 0)
openButton.TextScaled = true
openButton.BackgroundColor3 = Color3.new(1, 1, 0)
openButton.BorderSizePixel = 2
openButton.Size = UDim2.new(0, 140, 0, 50)
openButton.Position = UDim2.new(1, -150, 1, -60)
openButton.AnchorPoint = Vector2.new(1, 1)
openButton.Parent = shopGui

local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopFrame"
shopFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
shopFrame.BorderSizePixel = 2
shopFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
shopFrame.Size = UDim2.new(0, 280, 0, 320)
shopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
shopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
shopFrame.Visible = false
shopFrame.Parent = shopGui

local coinLabel = Instance.new("TextLabel")
coinLabel.Name = "CoinLabel"
coinLabel.Text = "Coins: Loading..."
coinLabel.TextColor3 = Color3.new(1, 1, 1)
coinLabel.TextScaled = true
coinLabel.BackgroundTransparency = 1
coinLabel.Size = UDim2.new(1, -20, 0, 40)
coinLabel.Position = UDim2.new(0, 10, 0, 10)
coinLabel.Parent = shopFrame

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.BackgroundTransparency = 1
buttonContainer.Size = UDim2.new(1, -20, 1, -120)
buttonContainer.Position = UDim2.new(0, 10, 0, 60)
buttonContainer.Parent = shopFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = buttonContainer

local buyItems = {
	{Name = "BuySpeed", Text = "Buy Speed (100)"},
	{Name = "BuyHealth", Text = "Buy Health (150)"},
	{Name = "BuyFlashlight", Text = "Buy Flashlight (200)"}
}

for _, item in ipairs(buyItems) do
	local btn = Instance.new("TextButton")
	btn.Name = item.Name
	btn.Text = item.Text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.BorderSizePixel = 1
	btn.BorderColor3 = Color3.fromRGB(100, 100, 100)
	btn.Size = UDim2.new(1, 0, 0, 50)
	btn.Parent = buttonContainer
end

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "CLOSE"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeButton.BorderSizePixel = 1
closeButton.BorderColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Size = UDim2.new(1, -20, 0, 40)
closeButton.Position = UDim2.new(0, 10, 1, -50)
closeButton.AnchorPoint = Vector2.new(0, 1)
closeButton.Parent = shopFrame

openButton.MouseButton1Click:Connect(function()
	shopFrame.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
end)

task.spawn(function()
	local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
	local coinsValue
	if leaderstats then
		coinsValue = leaderstats:FindFirstChild("Coins")
	end
	
	if coinsValue and coinsValue:IsA("IntValue") then
		coinLabel.Text = "Coins: " .. tostring(coinsValue.Value)
		coinsValue:GetPropertyChangedSignal("Value"):Connect(function()
			coinLabel.Text = "Coins: " .. tostring(coinsValue.Value)
		end)
	else
		coinLabel.Text = "Coins: 0"
	end
end)