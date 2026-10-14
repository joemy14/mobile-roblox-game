local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoleGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Name = "RoleFrame"
Frame.Size = UDim2.new(0, 200, 0, 280)
Frame.Position = UDim2.new(0.5, -100, 0.5, -140)
Frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -20, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Choose Your Role"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = Frame

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, -20, 1, -60)
ButtonContainer.Position = UDim2.new(0, 10, 0, 50)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonContainer

local roles = {"Red Cross", "Skater", "Tanod", "Old Man"}

for i, roleName in ipairs(roles) do
	local Button = Instance.new("TextButton")
	Button.Name = roleName .. "Button"
	Button.Size = UDim2.new(1, 0, 0, 45)
	Button.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	Button.BorderSizePixel = 0
	Button.Text = roleName
	Button.TextColor3 = Color3.new(0, 0, 0)
	Button.TextSize = 18
	Button.Font = Enum.Font.Gotham
	Button.LayoutOrder = i
	Button.Parent = ButtonContainer

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 6)
	ButtonCorner.Parent = Button

	Button.MouseButton1Click:Connect(function()
		print("Clicked: " .. roleName)
	end)
end