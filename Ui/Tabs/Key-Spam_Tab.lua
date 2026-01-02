local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers
local Config = _G.UniversalUtility.Config

local function CreateKeySpamTab()
    local KeySpamContent = UI.TabContents["KeySpam"]
    
    local Container = Instance.new("Frame", KeySpamContent)
    Container.Size = UDim2.new(1, 0, 0, 320)
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
    Title.Text = "⌨️ Key Spam Controller"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 200, 100)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Description = Instance.new("TextLabel", Container)
    Description.Size = UDim2.new(1, -20, 0, 16)
    Description.Position = UDim2.new(0, 10, 0, 34)
    Description.BackgroundTransparency = 1
    Description.Text = "Automatically spam any keyboard key at custom intervals"
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 12
    Description.TextColor3 = Color3.fromRGB(150, 150, 150)
    Description.TextXAlignment = Enum.TextXAlignment.Left
    
    local InputLabel = Instance.new("TextLabel", Container)
    InputLabel.Size = UDim2.new(1, -20, 0, 18)
    InputLabel.Position = UDim2.new(0, 10, 0, 60)
    InputLabel.BackgroundTransparency = 1
    InputLabel.Text = "Target Key"
    InputLabel.Font = Enum.Font.GothamBold
    InputLabel.TextSize = 13
    InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    InputLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SpamInput = Instance.new("TextBox", Container)
    SpamInput.Size = UDim2.new(1, -20, 0, 40)
    SpamInput.Position = UDim2.new(0, 10, 0, 82)
    SpamInput.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    SpamInput.Text = Config.SpamKey
    SpamInput.PlaceholderText = "Enter key (A-Z, 0-9, F1-F12)"
    SpamInput.Font = Enum.Font.Gotham
    SpamInput.TextSize = 14
    SpamInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpamInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    SpamInput.BorderSizePixel = 0
    SpamInput.ClearTextOnFocus = false
    Instance.new("UICorner", SpamInput).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", SpamInput).Color = Color3.fromRGB(60, 60, 70)
    
    local Separator = Instance.new("Frame", Container)
    Separator.Size = UDim2.new(1, -20, 0, 1)
    Separator.Position = UDim2.new(0, 10, 0, 135)
    Separator.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Separator.BorderSizePixel = 0
    
    local SpamDelayFrame, SpamDelaySlider, SpamSliderFill, SpamSliderButton, SpamDelayBox = Helpers.CreateSlider(Container, UDim2.new(1, -20, 0, 50), 0.05, 5, 0.1, "Spam Interval (seconds)")
    SpamDelayFrame.Position = UDim2.new(0, 10, 0, 150)
    
    local AutoSpamToggle = Helpers.CreateButton(Container, UDim2.new(0, 120, 0, 36), "OFF")
    AutoSpamToggle.Position = UDim2.new(0.5, 0, 0, 220)
    
    local StatusFrame = Instance.new("Frame", Container)
    StatusFrame.Size = UDim2.new(1, -20, 0, 45)
    StatusFrame.Position = UDim2.new(0, 10, 0, 265)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    StatusFrame.BorderSizePixel = 0
    Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 8)
    
    local Status = Instance.new("TextLabel", StatusFrame)
    Status.Size = UDim2.new(1, -10, 1, -10)
    Status.Position = UDim2.new(0, 5, 0, 5)
    Status.BackgroundTransparency = 1
    Status.Text = "System Status: Inactive"
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 14
    Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    Status.TextXAlignment = Enum.TextXAlignment.Center
    
    return {
        SpamInput = SpamInput,
        SpamDelaySlider = SpamDelaySlider,
        SpamSliderFill = SpamSliderFill,
        SpamSliderButton = SpamSliderButton,
        SpamDelayBox = SpamDelayBox,
        AutoSpamToggle = AutoSpamToggle,
        Status = Status
    }
end

return CreateKeySpamTab
