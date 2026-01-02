local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers

local function CreatePerformanceTab()
    local FPSContent = UI.TabContents["Performance Status"]
    
    local Container = Instance.new("Frame", FPSContent)
    Container.Size = UDim2.new(1, 0, 0, 580)
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
    Title.Text = "📊 Performance Monitor"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(100, 255, 150)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Description = Instance.new("TextLabel", Container)
    Description.Size = UDim2.new(1, -20, 0, 16)
    Description.Position = UDim2.new(0, 10, 0, 34)
    Description.BackgroundTransparency = 1
    Description.Text = "Track real-time performance metrics and unlock FPS limits"
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 12
    Description.TextColor3 = Color3.fromRGB(150, 150, 150)
    Description.TextXAlignment = Enum.TextXAlignment.Left
    
    local FPSUnlockToggle = Helpers.CreateButton(Container, UDim2.new(0, 160, 0, 36), "FPS Unlock: OFF")
    FPSUnlockToggle.Position = UDim2.new(0.5, 0, 0, 65)
    
    local FPSUnlockStatus = Instance.new("TextLabel", Container)
    FPSUnlockStatus.Size = UDim2.new(1, -20, 0, 20)
    FPSUnlockStatus.Position = UDim2.new(0, 10, 0, 108)
    FPSUnlockStatus.BackgroundTransparency = 1
    FPSUnlockStatus.Text = "Current Limit: 60 FPS"
    FPSUnlockStatus.Font = Enum.Font.Gotham
    FPSUnlockStatus.TextSize = 13
    FPSUnlockStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
    FPSUnlockStatus.TextXAlignment = Enum.TextXAlignment.Center
    
    local FPSValueFrame, FPSSlider, FPSFill, FPSButton, FPSValueBox = Helpers.CreateSlider(Container, UDim2.new(1, -20, 0, 50), 15, 360, 60, "Target FPS Limit")
    FPSValueFrame.Position = UDim2.new(0, 10, 0, 140)
    
    local Separator1 = Instance.new("Frame", Container)
    Separator1.Size = UDim2.new(1, -20, 0, 1)
    Separator1.Position = UDim2.new(0, 10, 0, 205)
    Separator1.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Separator1.BorderSizePixel = 0
    
    local FPSStatsTitle = Instance.new("TextLabel", Container)
    FPSStatsTitle.Size = UDim2.new(1, -20, 0, 20)
    FPSStatsTitle.Position = UDim2.new(0, 10, 0, 215)
    FPSStatsTitle.BackgroundTransparency = 1
    FPSStatsTitle.Text = "Framerate Statistics"
    FPSStatsTitle.Font = Enum.Font.GothamBold
    FPSStatsTitle.TextSize = 13
    FPSStatsTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    FPSStatsTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local FPSStatsFrame = Instance.new("Frame", Container)
    FPSStatsFrame.Size = UDim2.new(1, -20, 0, 50)
    FPSStatsFrame.Position = UDim2.new(0, 10, 0, 240)
    FPSStatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    FPSStatsFrame.BorderSizePixel = 0
    Instance.new("UICorner", FPSStatsFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", FPSStatsFrame).Color = Color3.fromRGB(50, 50, 60)
    
    local CurrentFPSLabel = Instance.new("TextLabel", FPSStatsFrame)
    CurrentFPSLabel.Size = UDim2.new(0.33, 0, 1, 0)
    CurrentFPSLabel.BackgroundTransparency = 1
    CurrentFPSLabel.Text = "Current: 60"
    CurrentFPSLabel.Font = Enum.Font.GothamBold
    CurrentFPSLabel.TextSize = 13
    CurrentFPSLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    CurrentFPSLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local AvgFPSLabel = Instance.new("TextLabel", FPSStatsFrame)
    AvgFPSLabel.Size = UDim2.new(0.33, 0, 1, 0)
    AvgFPSLabel.Position = UDim2.new(0.33, 0, 0, 0)
    AvgFPSLabel.BackgroundTransparency = 1
    AvgFPSLabel.Text = "Average: 60"
    AvgFPSLabel.Font = Enum.Font.GothamBold
    AvgFPSLabel.TextSize = 13
    AvgFPSLabel.TextColor3 = Color3.fromRGB(50, 220, 100)
    AvgFPSLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local MinMaxFPSLabel = Instance.new("TextLabel", FPSStatsFrame)
    MinMaxFPSLabel.Size = UDim2.new(0.34, 0, 1, 0)
    MinMaxFPSLabel.Position = UDim2.new(0.66, 0, 0, 0)
    MinMaxFPSLabel.BackgroundTransparency = 1
    MinMaxFPSLabel.Text = "Min: 60 | Max: 60"
    MinMaxFPSLabel.Font = Enum.Font.GothamBold
    MinMaxFPSLabel.TextSize = 13
    MinMaxFPSLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    MinMaxFPSLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local Separator2 = Instance.new("Frame", Container)
    Separator2.Size = UDim2.new(1, -20, 0, 1)
    Separator2.Position = UDim2.new(0, 10, 0, 305)
    Separator2.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Separator2.BorderSizePixel = 0
    
    local PingStatsTitle = Instance.new("TextLabel", Container)
    PingStatsTitle.Size = UDim2.new(1, -20, 0, 20)
    PingStatsTitle.Position = UDim2.new(0, 10, 0, 315)
    PingStatsTitle.BackgroundTransparency = 1
    PingStatsTitle.Text = "Network Latency Statistics"
    PingStatsTitle.Font = Enum.Font.GothamBold
    PingStatsTitle.TextSize = 13
    PingStatsTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    PingStatsTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local PingStatsFrame = Instance.new("Frame", Container)
    PingStatsFrame.Size = UDim2.new(1, -20, 0, 50)
    PingStatsFrame.Position = UDim2.new(0, 10, 0, 340)
    PingStatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    PingStatsFrame.BorderSizePixel = 0
    Instance.new("UICorner", PingStatsFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", PingStatsFrame).Color = Color3.fromRGB(50, 50, 60)
    
    local CurrentPingLabel = Instance.new("TextLabel", PingStatsFrame)
    CurrentPingLabel.Size = UDim2.new(0.33, 0, 1, 0)
    CurrentPingLabel.BackgroundTransparency = 1
    CurrentPingLabel.Text = "Current: 0ms"
    CurrentPingLabel.Font = Enum.Font.GothamBold
    CurrentPingLabel.TextSize = 13
    CurrentPingLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    CurrentPingLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local AvgPingLabel = Instance.new("TextLabel", PingStatsFrame)
    AvgPingLabel.Size = UDim2.new(0.33, 0, 1, 0)
    AvgPingLabel.Position = UDim2.new(0.33, 0, 0, 0)
    AvgPingLabel.BackgroundTransparency = 1
    AvgPingLabel.Text = "Average: 0ms"
    AvgPingLabel.Font = Enum.Font.GothamBold
    AvgPingLabel.TextSize = 13
    AvgPingLabel.TextColor3 = Color3.fromRGB(50, 220, 100)
    AvgPingLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local MinMaxPingLabel = Instance.new("TextLabel", PingStatsFrame)
    MinMaxPingLabel.Size = UDim2.new(0.34, 0, 1, 0)
    MinMaxPingLabel.Position = UDim2.new(0.66, 0, 0, 0)
    MinMaxPingLabel.BackgroundTransparency = 1
    MinMaxPingLabel.Text = "Min: 0ms | Max: 0ms"
    MinMaxPingLabel.Font = Enum.Font.GothamBold
    MinMaxPingLabel.TextSize = 13
    MinMaxPingLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    MinMaxPingLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local NetworkStatusFrame = Instance.new("Frame", Container)
    NetworkStatusFrame.Size = UDim2.new(1, -20, 0, 50)
    NetworkStatusFrame.Position = UDim2.new(0, 10, 0, 405)
    NetworkStatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    NetworkStatusFrame.BorderSizePixel = 0
    Instance.new("UICorner", NetworkStatusFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", NetworkStatusFrame).Color = Color3.fromRGB(50, 50, 60)
    
    local NetworkStatusLabel = Instance.new("TextLabel", NetworkStatusFrame)
    NetworkStatusLabel.Size = UDim2.new(0.5, 0, 1, 0)
    NetworkStatusLabel.BackgroundTransparency = 1
    NetworkStatusLabel.Text = "Connection Quality"
    NetworkStatusLabel.Font = Enum.Font.GothamBold
    NetworkStatusLabel.TextSize = 13
    NetworkStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NetworkStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local NetworkQualityLabel = Instance.new("TextLabel", NetworkStatusFrame)
    NetworkQualityLabel.Size = UDim2.new(0.5, 0, 1, 0)
    NetworkQualityLabel.Position = UDim2.new(0.5, 0, 0, 0)
    NetworkQualityLabel.BackgroundTransparency = 1
    NetworkQualityLabel.Text = "Excellent"
    NetworkQualityLabel.Font = Enum.Font.GothamBold
    NetworkQualityLabel.TextSize = 13
    NetworkQualityLabel.TextColor3 = Color3.fromRGB(50, 220, 100)
    NetworkQualityLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local PerformanceInfo = Instance.new("TextLabel", Container)
    PerformanceInfo.Size = UDim2.new(1, -20, 0, 110)
    PerformanceInfo.Position = UDim2.new(0, 10, 0, 465)
    PerformanceInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    PerformanceInfo.BorderSizePixel = 0
    PerformanceInfo.Text = "Performance monitoring tracks your game's framerate and network latency in real-time.\n\nLowering FPS limits reduces memory usage but may affect visual quality. Higher FPS provides smoother gameplay but increases resource consumption.\n\nOptimal FPS depends on your device capabilities and game requirements."
    PerformanceInfo.Font = Enum.Font.Gotham
    PerformanceInfo.TextSize = 12
    PerformanceInfo.TextColor3 = Color3.fromRGB(200, 180, 150)
    PerformanceInfo.TextWrapped = true
    PerformanceInfo.TextXAlignment = Enum.TextXAlignment.Left
    PerformanceInfo.TextYAlignment = Enum.TextYAlignment.Top
    Instance.new("UICorner", PerformanceInfo).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", PerformanceInfo).Color = Color3.fromRGB(50, 50, 60)
    local padding = Instance.new("UIPadding", PerformanceInfo)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    
    return {
        FPSUnlockToggle = FPSUnlockToggle,
        FPSUnlockStatus = FPSUnlockStatus,
        FPSSlider = FPSSlider,
        FPSFill = FPSFill,
        FPSButton = FPSButton,
        FPSValueBox = FPSValueBox,
        FPSStats = {
            Current = CurrentFPSLabel,
            Avg = AvgFPSLabel,
            MinMax = MinMaxFPSLabel
        },
        PingStats = {
            Current = CurrentPingLabel,
            Avg = AvgPingLabel,
            MinMax = MinMaxPingLabel,
            Quality = NetworkQualityLabel
        }
    }
end

return CreatePerformanceTab
