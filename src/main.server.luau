local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WelcomeScreen"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(80, 80, 100)
frameStroke.Thickness = 2
frameStroke.Transparency = 0.3
frameStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -40, 0, 60)
titleLabel.Position = UDim2.new(0, 20, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Infected Engkanto: Barangay Defense"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 32
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextWrapped = true
titleLabel.Parent = mainFrame

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Size = UDim2.new(1, -40, 0, 40)
subtitleLabel.Position = UDim2.new(0, 20, 0, 100)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Choose your role and prepare for the horde!"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
subtitleLabel.TextSize = 18
subtitleLabel.Font = Enum.Font.GothamMedium
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
subtitleLabel.TextWrapped = true
subtitleLabel.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 140, 0, 44)
closeButton.Position = UDim2.new(0.5, -70, 1, -70)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = closeButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 100, 100)
buttonStroke.Thickness = 1.5
buttonStroke.Transparency = 0.5
buttonStroke.Parent = closeButton

closeButton.MouseEnter:Connect(function()
	local tween = TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(230, 80, 80)})
	tween:Play()
end)

closeButton.MouseLeave:Connect(function()
	local tween = TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)})
	tween:Play()
end)

closeButton.MouseButton1Click:Connect(function()
	local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -250, 0.5, -170)
	})
	
	local textFadeOut = TweenService:Create(titleLabel, TweenInfo.new(0.2), {TextTransparency = 1})
	local subFadeOut = TweenService:Create(subtitleLabel, TweenInfo.new(0.2), {TextTransparency = 1})
	local btnFadeOut = TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1})
	
	fadeOut:Play()
	textFadeOut:Play()
	subFadeOut:Play()
	btnFadeOut:Play()
	
	fadeOut.Completed:Connect(function()
		screenGui.Enabled = false
	end)
end)

mainFrame.BackgroundTransparency = 1
titleLabel.TextTransparency = 1
subtitleLabel.TextTransparency = 1
closeButton.BackgroundTransparency = 1
closeButton.TextTransparency = 1

local fadeIn = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	BackgroundTransparency = 0.1,
	Position = UDim2.new(0.5, -250, 0.5, -150)
})
local titleFadeIn = TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0})
local subFadeIn = TweenService:Create(subtitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0})
local btnFadeIn = TweenService:Create(closeButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0, TextTransparency = 0})

fadeIn:Play()
titleFadeIn:Play()
subFadeIn:Play()
btnFadeIn:Play()