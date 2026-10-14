local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LobbyUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.fromScale(0.4, 0.5)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.05, 0)
uiCorner.Parent = frame

local uiAspectRatio = Instance.new("UIAspectRatioConstraint")
uiAspectRatio.AspectRatio = 0.8
uiAspectRatio.DominantAxis = Enum.DominantAxis.Width
uiAspectRatio.Parent = frame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0.05, 0)
uiPadding.PaddingBottom = UDim.new(0.05, 0)
uiPadding.PaddingLeft = UDim.new(0.05, 0)
uiPadding.PaddingRight = UDim.new(0.05, 0)
uiPadding.Parent = frame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0.03, 0)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.fromScale(1, 0.3)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Infected Engkanto"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextWrapped = true
titleLabel.LayoutOrder = 1
titleLabel.Parent = frame

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Size = UDim2.fromScale(1, 0.2)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Choose your role and prepare!"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleLabel.TextScaled = true
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextWrapped = true
subtitleLabel.LayoutOrder = 2
subtitleLabel.Parent = frame

local spacer = Instance.new("Frame")
spacer.Name = "Spacer"
spacer.Size = UDim2.fromScale(1, 0.3)
spacer.BackgroundTransparency = 1
spacer.LayoutOrder = 3
spacer.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.fromScale(0.5, 0.15)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.LayoutOrder = 4
closeButton.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0.2, 0)
buttonCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)