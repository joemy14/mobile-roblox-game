local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Name = "TestButton"
button.Size = UDim2.new(0, 300, 0, 100)
button.Position = UDim2.new(0.5, -150, 0.5, -50)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
button.Text = "UI TEST SUCCESS!"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 28
button.Font = Enum.Font.GothamBold
button.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = button

button.MouseButton1Click:Connect(function()
	print("Button clicked!")
end)