local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers
local Config = _G.UniversalUtility.Config

local function CreateScriptLoaderTab()
    local LoaderContent = UI.TabContents["Script Loader"]
    
    local Container = Instance.new("Frame", LoaderContent)
    Container.Size = UDim2.new(1, 0, 0, 460)
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
    Title.Text = "💾 Script Executor"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(200, 150, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Description = Instance.new("TextLabel", Container)
    Description.Size = UDim2.new(1, -20, 0, 16)
    Description.Position = UDim2.new(0, 10, 0, 34)
    Description.BackgroundTransparency = 1
    Description.Text = "Execute custom Lua scripts with auto-save and auto-load capabilities"
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 12
    Description.TextColor3 = Color3.fromRGB(150, 150, 150)
    Description.TextXAlignment = Enum.TextXAlignment.Left
    
    local CodeEditorFrame = Instance.new("Frame", Container)
    CodeEditorFrame.Size = UDim2.new(1, -20, 0, 220)
    CodeEditorFrame.Position = UDim2.new(0, 10, 0, 60)
    CodeEditorFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    CodeEditorFrame.BorderSizePixel = 0
    Instance.new("UICorner", CodeEditorFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", CodeEditorFrame).Color = Color3.fromRGB(60, 60, 70)
    
    local LineNumbersScrollFrame = Instance.new("ScrollingFrame", CodeEditorFrame)
    LineNumbersScrollFrame.Size = UDim2.new(0, 40, 1, 0)
    LineNumbersScrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    LineNumbersScrollFrame.BorderSizePixel = 0
    LineNumbersScrollFrame.ScrollBarThickness = 0
    LineNumbersScrollFrame.ScrollingEnabled = false
    LineNumbersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 220)
    Instance.new("UICorner", LineNumbersScrollFrame).CornerRadius = UDim.new(0, 8)
    
    local LineNumbers = Instance.new("TextLabel", LineNumbersScrollFrame)
    LineNumbers.Size = UDim2.new(1, -5, 1, 0)
    LineNumbers.BackgroundTransparency = 1
    LineNumbers.Text = "1"
    LineNumbers.Font = Enum.Font.Code
    LineNumbers.TextSize = 12
    LineNumbers.TextColor3 = Color3.fromRGB(120, 120, 120)
    LineNumbers.TextXAlignment = Enum.TextXAlignment.Right
    LineNumbers.TextYAlignment = Enum.TextYAlignment.Top
    
    local Separator = Instance.new("Frame", CodeEditorFrame)
    Separator.Size = UDim2.new(0, 1, 1, 0)
    Separator.Position = UDim2.new(0, 40, 0, 0)
    Separator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Separator.BorderSizePixel = 0
    
    local LoadStringScrollFrame = Instance.new("ScrollingFrame", CodeEditorFrame)
    LoadStringScrollFrame.Size = UDim2.new(1, -41, 1, 0)
    LoadStringScrollFrame.Position = UDim2.new(0, 41, 0, 0)
    LoadStringScrollFrame.BackgroundTransparency = 1
    LoadStringScrollFrame.BorderSizePixel = 0
    LoadStringScrollFrame.ScrollBarThickness = 4
    LoadStringScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    LoadStringScrollFrame.ScrollBarImageTransparency = 0.5
    LoadStringScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 220)
    
    local LoadStringBox = Instance.new("TextBox", LoadStringScrollFrame)
    LoadStringBox.Size = UDim2.new(1, -10, 1, 0)
    LoadStringBox.Position = UDim2.new(0, 5, 0, 0)
    LoadStringBox.BackgroundTransparency = 1
    LoadStringBox.Text = Config.SavedCode
    LoadStringBox.PlaceholderText = "-- Paste your Lua code here..."
    LoadStringBox.Font = Enum.Font.Code
    LoadStringBox.TextSize = 12
    LoadStringBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadStringBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    LoadStringBox.BorderSizePixel = 0
    LoadStringBox.TextWrapped = true
    LoadStringBox.TextXAlignment = Enum.TextXAlignment.Left
    LoadStringBox.TextYAlignment = Enum.TextYAlignment.Top
    LoadStringBox.MultiLine = true
    LoadStringBox.ClearTextOnFocus = false
    LoadStringBox.TextEditable = true
    
    local ExecuteButton = Helpers.CreateButton(Container, UDim2.new(0, 140, 0, 36), "Execute")
    ExecuteButton.Position = UDim2.new(0.25, 0, 0, 300)
    
    local AutoLoadButton = Helpers.CreateButton(Container, UDim2.new(0, 140, 0, 36), "Auto Load: OFF")
    AutoLoadButton.Position = UDim2.new(0.75, 0, 0, 300)
    
    local StatusFrame = Instance.new("Frame", Container)
    StatusFrame.Size = UDim2.new(1, -20, 0, 40)
    StatusFrame.Position = UDim2.new(0, 10, 0, 350)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    StatusFrame.BorderSizePixel = 0
    Instance.new("UICorner", StatusFrame).CornerRadius = UDim.new(0, 8)
    
    local Status = Instance.new("TextLabel", StatusFrame)
    Status.Size = UDim2.new(1, -10, 1, -10)
    Status.Position = UDim2.new(0, 5, 0, 5)
    Status.BackgroundTransparency = 1
    Status.Text = "System Status: Ready to execute"
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 13
    Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    Status.TextXAlignment = Enum.TextXAlignment.Center
    
    local InfoLabel = Instance.new("TextLabel", Container)
    InfoLabel.Size = UDim2.new(1, -20, 0, 60)
    InfoLabel.Position = UDim2.new(0, 10, 0, 395)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "Your code is automatically saved while typing. Enable Auto Load to execute your script automatically when rejoining or teleporting to a new server.\n\nChanges are saved in real-time."
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextSize = 12
    InfoLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Center
    InfoLabel.TextWrapped = true
    
    return {
        LoadStringBox = LoadStringBox,
        LineNumbers = LineNumbers,
        LoadStringScrollFrame = LoadStringScrollFrame,
        LineNumbersScrollFrame = LineNumbersScrollFrame,
        ExecuteButton = ExecuteButton,
        AutoLoadButton = AutoLoadButton,
        Status = Status
    }
end

return CreateScriptLoaderTab
