local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers

local function CreateAutoRejoinTab()
    local RejoinContent = UI.TabContents["Auto Rejoin"]
    
    local Container = Instance.new("Frame", RejoinContent)
    Container.Size = UDim2.new(1, 0, 0, 250)
    Container.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Container.BorderSizePixel = 0
    Container.LayoutOrder = 1
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 10)
    
    local ContainerGradient = Instance.new("UIGradient", Container)
    ContainerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 47))
    }
    ContainerGradient.Rotation = 90
    
    local Title = Instance.new("TextLabel", Container)
    Title.Size = UDim2.new(1, -20, 0, 26)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = "🔄 Auto Rejoin System"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(150, 200, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Description = Instance.new("TextLabel", Container)
    Description.Size = UDim2.new(1, -20, 0, 16)
    Description.Position = UDim2.new(0, 10, 0, 34)
    Description.BackgroundTransparency = 1
    Description.Text = "Automatically reconnect when disconnected from the server"
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 12
    Description.TextColor3 = Color3.fromRGB(150, 150, 150)
    Description.TextXAlignment = Enum.TextXAlignment.Left
    
    local AutoRejoinToggle = Helpers.CreateButton(Container, UDim2.new(0, 180, 0, 40), "Auto Rejoin: OFF")
    AutoRejoinToggle.Position = UDim2.new(0.5, 0, 0, 75)
    
    local StatusFrame = Instance.new("Frame", Container)
    StatusFrame.Size = UDim2.new(1, -20, 0, 105)
    StatusFrame.Position = UDim2.new(0, 10, 0, 135)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    StatusFrame.BorderSizePixel = 0
    Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", StatusFrame).Color = Color3.fromRGB(50, 50, 60)
    
    local Status = Instance.new("TextLabel", StatusFrame)
    Status.Size = UDim2.new(1, -20, 1, -20)
    Status.Position = UDim2.new(0, 10, 0, 10)
    Status.BackgroundTransparency = 1
    Status.Text = "System Status: Disabled\n\nWhen enabled, this feature will automatically rejoin the current server when you get disconnected due to errors or AFK timeout.\n\nThis helps maintain your session and prevents losing progress."
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12
    Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.TextYAlignment = Enum.TextYAlignment.Top
    Status.TextWrapped = true
    
    return {
        AutoRejoinToggle = AutoRejoinToggle,
        Status = Status
    }
end

return CreateAutoRejoinTab
