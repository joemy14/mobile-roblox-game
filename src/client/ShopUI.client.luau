local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ShopGui = Instance.new("ScreenGui")
ShopGui.Name = "ShopGui"
ShopGui.ResetOnSpawn = false
ShopGui.Parent = PlayerGui

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenShopButton"
OpenButton.Text = "OPEN SHOP"
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 18
OpenButton.TextColor3 = Color3.new(1, 1, 1)
OpenButton.TextStrokeTransparency = 0.5
OpenButton.Size = UDim2.new(0, 140, 0, 45)
OpenButton.Position = UDim2.new(1, -160, 1, -60)
OpenButton.AnchorPoint = Vector2.new(1, 1)
OpenButton.BackgroundColor3 = Color3.new(1, 1, 1)
OpenButton.BorderSizePixel = 0
OpenButton.AutoButtonColor = true
OpenButton.Visible = true -- Fix 1: Changed from false to true so button is visible
OpenButton.Parent = ShopGui

local OpenGradient = Instance.new("UIGradient")
OpenGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 255, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 50))
}
OpenGradient.Rotation = 90
OpenGradient.Parent = OpenButton

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0.3, 0)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(40, 40, 40)
OpenStroke.Thickness = 2
OpenStroke.Transparency = 0
OpenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
OpenStroke.Parent = OpenButton

local ShopFrame = Instance.new("Frame")
ShopFrame.Name = "ShopFrame"
ShopFrame.Size = UDim2.new(0, 300, 0, 380)
ShopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ShopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ShopFrame.BackgroundColor3 = Color3.new(1, 1, 1)
ShopFrame.BorderSizePixel = 0
ShopFrame.Visible = false
ShopFrame.Active = true
ShopFrame.Draggable = true
ShopFrame.Parent = ShopGui

local FrameGradient = Instance.new("UIGradient")
FrameGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 30, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 30))
}
FrameGradient.Rotation = 45
FrameGradient.Parent = ShopFrame

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0.2, 0)
FrameCorner.Parent = ShopFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ShopFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 15)
UIPadding.PaddingBottom = UDim.new(0, 15)
UIPadding.PaddingLeft = UDim.new(0, 20)
UIPadding.PaddingRight = UDim.new(0, 20)
UIPadding.Parent = ShopFrame

local CoinLabel = Instance.new("TextLabel")
CoinLabel.Name = "CoinLabel"
CoinLabel.Text = "Coins: 0"
CoinLabel.Font = Enum.Font.GothamBold
CoinLabel.TextSize = 24
CoinLabel.TextColor3 = Color3.new(1, 1, 1)
CoinLabel.TextStrokeTransparency = 0.5
CoinLabel.BackgroundTransparency = 1
CoinLabel.Size = UDim2.new(1, 0, 0, 40)
CoinLabel.LayoutOrder = 1
CoinLabel.Parent = ShopFrame

local function createBuyButton(text, layoutOrder)
	local btn = Instance.new("TextButton")
	btn.Name = text:gsub(" ", "") .. "Button"
	btn.Text = text
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.TextStrokeTransparency = 0.8
	btn.Size = UDim2.new(1, 0, 0, 50)
	btn.BackgroundColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true
	btn.LayoutOrder = layoutOrder
	btn.Parent = ShopFrame

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 100)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 50))
	}
	grad.Rotation = 90
	grad.Parent = btn

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = btn

	return btn
end

local SpeedBtn = createBuyButton("Buy Speed (100)", 2)
local HealthBtn = createBuyButton("Buy Health (150)", 3)
local FlashlightBtn = createBuyButton("Buy Flashlight (200)", 4)

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = "CLOSE"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextStrokeTransparency = 0.5
CloseButton.Size = UDim2.new(1, 0, 0, 45)
CloseButton.BackgroundColor3 = Color3.new(1, 1, 1)
CloseButton.BorderSizePixel = 0
CloseButton.AutoButtonColor = true
CloseButton.LayoutOrder = 5
CloseButton.Parent = ShopFrame

local CloseGradient = Instance.new("UIGradient")
CloseGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 40, 40))
}
CloseGradient.Rotation = 90
CloseGradient.Parent = CloseButton

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0.2, 0)
CloseCorner.Parent = CloseButton

local BuyItemEvent = ReplicatedStorage:WaitForChild("BuyItemEvent")
local ShopUpdateEvent = ReplicatedStorage:WaitForChild("ShopUpdateEvent")

local RoleSelectedEvent = ReplicatedStorage:FindFirstChild("RoleSelectedEvent")
if not RoleSelectedEvent then
	warn("RoleSelectedEvent not found in ReplicatedStorage")
	RoleSelectedEvent = Instance.new("BindableEvent")
	RoleSelectedEvent.Name = "RoleSelectedEvent"
end

local function showOpenButton()
	OpenButton.Visible = true
end

OpenButton.MouseButton1Click:Connect(function()
	ShopFrame.Visible = true
	-- Fix 3: Update coin label from leaderstats when shop opens
	local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins then
			CoinLabel.Text = "Coins: " .. tostring(coins.Value)
		end
	end
end)

CloseButton.MouseButton1Click:Connect(function()
	ShopFrame.Visible = false
end)

local buyButtons = {
	[SpeedBtn] = "SpeedBoost",      -- Fix 2: Updated to match server expected name
	[HealthBtn] = "ExtraHealth",    -- Fix 2: Updated to match server expected name
	[FlashlightBtn] = "Flashlight"  -- Fix 2: Already correct, kept as is
}

for button, itemName in pairs(buyButtons) do
	button.MouseButton1Click:Connect(function()
		BuyItemEvent:FireServer(itemName)
	end)
end

ShopUpdateEvent.OnClientEvent:Connect(function(newCoinAmount)
	CoinLabel.Text = "Coins: " .. tostring(newCoinAmount)
end)

if RoleSelectedEvent:IsA("RemoteEvent") then
	RoleSelectedEvent.OnClientEvent:Connect(showOpenButton)
elseif RoleSelectedEvent:IsA("BindableEvent") then
	RoleSelectedEvent.Event:Connect(showOpenButton)
end

task.spawn(function()
	local roleSelected = LocalPlayer:GetAttribute("RoleSelected")
	if roleSelected == true then
		showOpenButton()
	else
		LocalPlayer:GetAttributeChangedSignal("RoleSelected"):Connect(function()
			if LocalPlayer:GetAttribute("RoleSelected") == true then
				showOpenButton()
			end
		end)
	end
end)