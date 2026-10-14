local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShopGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Button = Instance.new("TextButton")
Button.Name = "OpenShopButton"
Button.Text = "OPEN SHOP"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 18
Button.TextColor3 = Color3.new(0, 0, 0)
Button.BackgroundColor3 = Color3.new(1, 1, 0)
Button.BorderSizePixel = 0
Button.AnchorPoint = Vector2.new(1, 1)
Button.Position = UDim2.new(1, -20, 1, -20)
Button.Size = UDim2.new(0, 140, 0, 50)
Button.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Button

Button.MouseButton1Click:Connect(function()
	print("Shop button clicked!")
end)