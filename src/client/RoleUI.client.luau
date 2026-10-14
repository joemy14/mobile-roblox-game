local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local chooseRoleEvent = ReplicatedStorage:WaitForChild("ChooseRoleEvent")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RoleGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "RoleFrame"
frame.Size = UDim2.new(0, 250, 0, 320)
frame.Position = UDim2.new(0.5, -125, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Choose Your Role"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = frame

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, -20, 1, -60)
buttonContainer.Position = UDim2.new(0, 10, 0, 50)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = buttonContainer

local roles = {"Red Cross", "Skater", "Tanod", "Old Man"}

for i, roleName in ipairs(roles) do
	local button = Instance.new("TextButton")
	button.Name = roleName .. "Button"
	button.Size = UDim2.new(1, 0, 0, 50)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.BorderSizePixel = 0
	button.Text = roleName
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextScaled = true
	button.Font = Enum.Font.GothamSemibold
	button.LayoutOrder = i
	button.Parent = buttonContainer

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = button

	button.MouseButton1Click:Connect(function()
		chooseRoleEvent:FireServer(roleName)
		screenGui:Destroy()
		print("Role sent to server!")
	end)
end