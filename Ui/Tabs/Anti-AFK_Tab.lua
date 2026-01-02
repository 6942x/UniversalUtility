local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers

local function CreateAntiAFKTab()
    local AntiAFKContent = UI.TabContents["Anti-AFK"]
    
    local Container = Instance.new("Frame", AntiAFKContent)
    Container.Size = UDim2.new(1, 0, 0, 400)
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
    Title.Text = "⚡ Anti-AFK System"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(100, 200, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Description = Instance.new("TextLabel", Container)
    Description.Size = UDim2.new(1, -20, 0, 16)
    Description.Position = UDim2.new(0, 10, 0, 34)
    Description.BackgroundTransparency = 1
    Description.Text = "Prevent disconnections by simulating player activity"
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 12
    Description.TextColor3 = Color3.fromRGB(150, 150, 150)
    Description.TextXAlignment = Enum.TextXAlignment.Left
    
    local JumpToggle = Helpers.CreateButton(Container, UDim2.new(0, 140, 0, 36), "Auto Jump: OFF")
    JumpToggle.Position = UDim2.new(0.25, 0, 0, 65)
    
    local ClickToggle = Helpers.CreateButton(Container, UDim2.new(0, 140, 0, 36), "Auto Click: OFF")
    ClickToggle.Position = UDim2.new(0.75, 0, 0, 65)
    
    local Separator1 = Instance.new("Frame", Container)
    Separator1.Size = UDim2.new(1, -20, 0, 1)
    Separator1.Position = UDim2.new(0, 10, 0, 115)
    Separator1.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Separator1.BorderSizePixel = 0
    
    local ClickTypeLabel = Instance.new("TextLabel", Container)
    ClickTypeLabel.Size = UDim2.new(1, -20, 0, 20)
    ClickTypeLabel.Position = UDim2.new(0, 10, 0, 127)
    ClickTypeLabel.BackgroundTransparency = 1
    ClickTypeLabel.Text = "Click Position Mode"
    ClickTypeLabel.Font = Enum.Font.GothamBold
    ClickTypeLabel.TextSize = 13
    ClickTypeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ClickTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ClickTypeCurrent = Helpers.CreateButton(Container, UDim2.new(0, 85, 0, 30), "Current")
    ClickTypeCurrent.Position = UDim2.new(0.2, 0, 0, 155)
    
    local ClickTypeCenter = Helpers.CreateButton(Container, UDim2.new(0, 85, 0, 30), "Center")
    ClickTypeCenter.Position = UDim2.new(0.5, 0, 0, 155)
    
    local ClickTypeRandom = Helpers.CreateButton(Container, UDim2.new(0, 85, 0, 30), "Random")
    ClickTypeRandom.Position = UDim2.new(0.8, 0, 0, 155)
    
    local Separator2 = Instance.new("Frame", Container)
    Separator2.Size = UDim2.new(1, -20, 0, 1)
    Separator2.Position = UDim2.new(0, 10, 0, 198)
    Separator2.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Separator2.BorderSizePixel = 0
    
    local JumpDelayFrame, JumpDelaySlider, JumpSliderFill, JumpSliderButton, JumpDelayBox = Helpers.CreateSlider(Container, UDim2.new(1, -20, 0, 50), 5, 30, 10, "Jump Interval (seconds)")
    JumpDelayFrame.Position = UDim2.new(0, 10, 0, 213)
    
    local ClickDelayFrame, ClickDelaySlider, ClickSliderFill, ClickSliderButton, ClickDelayBox = Helpers.CreateSlider(Container, UDim2.new(1, -20, 0, 50), 1, 10, 3, "Click Interval (seconds)")
    ClickDelayFrame.Position = UDim2.new(0, 10, 0, 280)
    
    local StatusFrame = Instance.new("Frame", Container)
    StatusFrame.Size = UDim2.new(1, -20, 0, 45)
    StatusFrame.Position = UDim2.new(0, 10, 0, 345)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    StatusFrame.BorderSizePixel = 0
    Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 8)
    
    local Status = Instance.new("TextLabel", StatusFrame)
    Status.Size = UDim2.new(1, -10, 1, -10)
    Status.Position = UDim2.new(0, 5, 0, 5)
    Status.BackgroundTransparency = 1
    Status.Text = "System Status: All Features Inactive"
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 14
    Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    Status.TextXAlignment = Enum.TextXAlignment.Center
    
    return {
        JumpToggle = JumpToggle,
        ClickToggle = ClickToggle,
        ClickTypeCurrent = ClickTypeCurrent,
        ClickTypeCenter = ClickTypeCenter,
        ClickTypeRandom = ClickTypeRandom,
        JumpDelaySlider = JumpDelaySlider,
        JumpSliderFill = JumpSliderFill,
        JumpSliderButton = JumpSliderButton,
        JumpDelayBox = JumpDelayBox,
        ClickDelaySlider = ClickDelaySlider,
        ClickSliderFill = ClickSliderFill,
        ClickSliderButton = ClickSliderButton,
        ClickDelayBox = ClickDelayBox,
        Status = Status
    }
end

return CreateAntiAFKTab
