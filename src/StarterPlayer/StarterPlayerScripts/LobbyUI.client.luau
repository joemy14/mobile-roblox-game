local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LobbyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.4, 0, 0.5, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.05, 0)
UICorner.Parent = MainFrame

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.AspectRatio = 0.8
UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
UIAspectRatioConstraint.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.9, 0, 0.25, 0)
TitleLabel.Position = UDim2.new(0.5, 0, 0.15, 0)
TitleLabel.AnchorPoint = Vector2.new(0.5, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Infected Engkanto"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
TitleLabel.Parent = MainFrame

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "SubtitleLabel"
SubtitleLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
SubtitleLabel.Position = UDim2.new(0.5, 0, 0.4, 0)
SubtitleLabel.AnchorPoint = Vector2.new(0.5, 0)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "Choose your role and prepare!"
SubtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SubtitleLabel.TextScaled = true
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
SubtitleLabel.TextYAlignment = Enum.TextYAlignment.Center
SubtitleLabel.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.4, 0, 0.12, 0)
CloseButton.Position = UDim2.new(0.5, 0, 0.85, 0)
CloseButton.AnchorPoint = Vector2.new(0.5, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0.2, 0)
ButtonCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)