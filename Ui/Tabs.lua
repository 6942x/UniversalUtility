local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Config = _G.UniversalUtility.Config
local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers
local AntiAFK = _G.UniversalUtility.AntiAFK
local KeySpam = _G.UniversalUtility.KeySpam
local Performance = _G.UniversalUtility.Performance
local ScriptLoader = _G.UniversalUtility.ScriptLoader
local AutoRejoin = _G.UniversalUtility.AutoRejoin
local Debounces = _G.UniversalUtility.Debounces
local KeyCodeMap = _G.UniversalUtility.KeyCodeMap
local KeyCodeNames = _G.UniversalUtility.KeyCodeNames

_G.UniversalUtility.Tabs = {}

local function SetDebounce(key, duration)
    if Debounces[key] then return false end
    Debounces[key] = true
    task.delay(duration or 0.3, function() Debounces[key] = false end)
    return true
end

local tabList = {
    {"Home", "🏠", UDim2.new(0, 5, 0, 5)},
    {"Anti-AFK", "🛡️", UDim2.new(0, 5, 0, 68)},
    {"KeySpam", "⌨️", UDim2.new(0, 5, 0, 131)},
    {"Performance Status", "📊", UDim2.new(0, 5, 0, 194)},
    {"Auto Rejoin", "🔄", UDim2.new(0, 5, 0, 257)},
    {"Script Loader", "💾", UDim2.new(0, 5, 0, 320)},
    {"Settings", "⚙️", UDim2.new(0, 5, 0, 383)}
}

for _, tab in ipairs(tabList) do
    Helpers.CreateTabButton(tab[1], tab[2], tab[3])
end

for _, tab in ipairs(tabList) do
    Helpers.CreateTabContent(tab[1])
end

local HomeContent = UI.TabContents["Home"]
local AntiAFKContent = UI.TabContents["Anti-AFK"]
local KeySpamContent = UI.TabContents["KeySpam"]
local FPSContent = UI.TabContents["Performance Status"]
local RejoinContent = UI.TabContents["Auto Rejoin"]
local LoaderContent = UI.TabContents["Script Loader"]
local SettingsContent = UI.TabContents["Settings"]

local PlayerInfoFrame = Instance.new("Frame", HomeContent)
PlayerInfoFrame.Size = UDim2.new(1, 0, 0, 180)
PlayerInfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
PlayerInfoFrame.BorderSizePixel = 0
PlayerInfoFrame.LayoutOrder = 1
Instance.new("UICorner", PlayerInfoFrame).CornerRadius = UDim.new(0, 10)

local PlayerInfoGradient = Instance.new("UIGradient", PlayerInfoFrame)
PlayerInfoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 47))
}
PlayerInfoGradient.Rotation = 45

local PlayerImage = Instance.new("ImageLabel", PlayerInfoFrame)
PlayerImage.Size = UDim2.new(0, 120, 0, 140)
PlayerImage.Position = UDim2.new(0, 10, 0, 10)
PlayerImage.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
PlayerImage.BorderSizePixel = 0
PlayerImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Instance.new("UICorner", PlayerImage).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", PlayerImage).Color = Color3.fromRGB(100, 150, 255)

local PlayerName = Instance.new("TextLabel", PlayerInfoFrame)
PlayerName.Size = UDim2.new(1, -145, 0, 22)
PlayerName.Position = UDim2.new(0, 140, 0, 10)
PlayerName.BackgroundTransparency = 1
PlayerName.Text = LocalPlayer.Name
PlayerName.Font = Enum.Font.GothamBold
PlayerName.TextSize = 28
PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerName.TextXAlignment = Enum.TextXAlignment.Left

local FPSLabel = Instance.new("TextLabel", PlayerInfoFrame)
FPSLabel.Size = UDim2.new(1, -145, 0, 18)
FPSLabel.Position = UDim2.new(0, 140, 0, 50)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 60"
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextSize = 24
FPSLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left

local PingLabel = Instance.new("TextLabel", PlayerInfoFrame)
PingLabel.Size = UDim2.new(1, -145, 0, 18)
PingLabel.Position = UDim2.new(0, 140, 0, 90)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "Ping: 0 ms"
PingLabel.Font = Enum.Font.Gotham
PingLabel.TextSize = 24
PingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
PingLabel.TextXAlignment = Enum.TextXAlignment.Left

local executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown Executor"

local ExecutorLabel = Instance.new("TextLabel", PlayerInfoFrame)
ExecutorLabel.Size = UDim2.new(1, -145, 0, 18)
ExecutorLabel.Position = UDim2.new(0, 140, 0, 130)
ExecutorLabel.BackgroundTransparency = 1
ExecutorLabel.Text = "Executor: " .. executor
ExecutorLabel.Font = Enum.Font.Gotham
ExecutorLabel.TextSize = 24
ExecutorLabel.TextColor3 = Color3.fromRGB(255, 0, 125)
ExecutorLabel.TextXAlignment = Enum.TextXAlignment.Left

local GameInfoFrame = Instance.new("Frame", HomeContent)
GameInfoFrame.Size = UDim2.new(1, 0, 0, 220)
GameInfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
GameInfoFrame.BorderSizePixel = 0
GameInfoFrame.LayoutOrder = 2
Instance.new("UICorner", GameInfoFrame).CornerRadius = UDim.new(0, 10)

local GameInfoGradient = Instance.new("UIGradient", GameInfoFrame)
GameInfoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 47))
}
GameInfoGradient.Rotation = 135

local GameImage = Instance.new("ImageLabel", GameInfoFrame)
GameImage.Size = UDim2.new(0, 120, 0, 140)
GameImage.Position = UDim2.new(0, 10, 0, 10)
GameImage.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
GameImage.BorderSizePixel = 0
GameImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Instance.new("UICorner", GameImage).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", GameImage).Color = Color3.fromRGB(100, 150, 255)

local GameName = Instance.new("TextLabel", GameInfoFrame)
GameName.Size = UDim2.new(1, -20, 0, 24)
GameName.Position = UDim2.new(0, 55, 0, 10)
GameName.BackgroundTransparency = 1
GameName.Text = "Loading..."
GameName.Font = Enum.Font.GothamBold
GameName.TextScaled = true
GameName.TextColor3 = Color3.fromRGB(255, 255, 255)
GameName.TextXAlignment = Enum.TextXAlignment.Center
GameName.TextWrapped = true

local GameId = Instance.new("TextLabel", GameInfoFrame)
GameId.Size = UDim2.new(1, -20, 0, 16)
GameId.Position = UDim2.new(0, 27.5, 0, 50)
GameId.BackgroundTransparency = 1
GameId.Text = "Game ID: " .. game.PlaceId
GameId.Font = Enum.Font.Gotham
GameId.TextSize = 24
GameId.TextColor3 = Color3.fromRGB(180, 180, 255)
GameId.TextXAlignment = Enum.TextXAlignment.Center

local PlayersInServerLabel = Instance.new("TextLabel", GameInfoFrame)
PlayersInServerLabel.Size = UDim2.new(1, -20, 0, 16)
PlayersInServerLabel.Position = UDim2.new(0, 33.33, 0, 90)
PlayersInServerLabel.BackgroundTransparency = 1
PlayersInServerLabel.Text = "Players in the server: " .. #Players:GetPlayers()
PlayersInServerLabel.Font = Enum.Font.Gotham
PlayersInServerLabel.TextSize = 24
PlayersInServerLabel.TextColor3 = Color3.fromRGB(180, 255, 180)
PlayersInServerLabel.TextXAlignment = Enum.TextXAlignment.Center

local ServerIdLabel = Instance.new("TextLabel", GameInfoFrame)
ServerIdLabel.Size = UDim2.new(1, 0, 0, 18)
ServerIdLabel.Position = UDim2.new(0, 65, 0, 130)
ServerIdLabel.BackgroundTransparency = 1
ServerIdLabel.Text = "Server ID: " .. game.JobId
ServerIdLabel.Font = Enum.Font.Gotham
ServerIdLabel.TextSize = 14
ServerIdLabel.TextColor3 = Color3.fromRGB(255, 180, 180)
ServerIdLabel.TextXAlignment = Enum.TextXAlignment.Center

RunService.Heartbeat:Connect(function()
    PlayersInServerLabel.Text = "Players in the server: " .. #Players:GetPlayers()
end)

UI.PlayerImage = PlayerImage
UI.GameName = GameName
UI.GameImage = GameImage

_G.UniversalUtility.Tabs.CreateAntiAFKTab = function()
    local Container = Instance.new("Frame", AntiAFKContent)
    Container.Size = UDim2.new(1, 0, 0, 380)
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
    Title.Size = UDim2.new(1, -20, 0, 24)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Anti-AFK Methods"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local JumpToggle = Helpers.CreateButton(Container, UDim2.new(0, 140, 0, 36), "Auto Jump: OFF")
    JumpToggle.Position = UDim2.new(0.25, 0, 0, 50)
    
    local ClickToggle = Helpers.CreateButton(Container, UDim2.new(0, 140, 0, 36), "Auto Click: OFF")
    ClickToggle.Position = UDim2.new(0.75, 0, 0, 50)
    
    local ClickTypeLabel = Instance.new("TextLabel", Container)
    ClickTypeLabel.Size = UDim2.new(1, -20, 0, 20)
    ClickTypeLabel.Position = UDim2.new(0, 10, 0, 100)
    ClickTypeLabel.BackgroundTransparency = 1
    ClickTypeLabel.Text = "Click Type:"
    ClickTypeLabel.Font = Enum.Font.Gotham
    ClickTypeLabel.TextSize = 13
    ClickTypeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ClickTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ClickTypeCurrent = Helpers.CreateButton(Container, UDim2.new(0, 85, 0, 30), "Current")
    ClickTypeCurrent.Position = UDim2.new(0.2, 0, 0, 130)
    
    local ClickTypeCenter = Helpers.CreateButton(Container, UDim2.new(0, 85, 0, 30), "Center")
    ClickTypeCenter.Position = UDim2.new(0.5, 0, 0, 130)
    
    local ClickTypeRandom = Helpers.CreateButton(Container, UDim2.new(0, 85, 0, 30), "Random")
    ClickTypeRandom.Position = UDim2.new(0.8, 0, 0, 130)
    
    local JumpDelayFrame, JumpDelaySlider, JumpSliderFill, JumpSliderButton, JumpDelayBox = Helpers.CreateSlider(Container, UDim2.new(1, -20, 0, 50), 5, 30, 10, "Jump Delay (seconds):")
    JumpDelayFrame.Position = UDim2.new(0, 10, 0, 180)
    
    local ClickDelayFrame, ClickDelaySlider, ClickSliderFill, ClickSliderButton, ClickDelayBox = Helpers.CreateSlider(Container, UDim2.new(1, -20, 0, 50), 1, 10, 3, "Click Delay (seconds):")
    ClickDelayFrame.Position = UDim2.new(0, 10, 0, 250)
    
    local Status = Instance.new("TextLabel", Container)
    Status.Size = UDim2.new(1, -20, 0, 50)
    Status.Position = UDim2.new(0, 10, 0, 320)
    Status.BackgroundTransparency = 1
    Status.Text = "Status: All Inactive"
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 16
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

_G.UniversalUtility.Tabs.CreateKeySpamTab = function()
    local Container = Instance.new("Frame", KeySpamContent)
    Container.Size = UDim2.new(1, 0, 0, 280)
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
    Title.Size = UDim2.new(1, -20, 0, 24)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Key Spam Configuration"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local SpamInput = Instance.new("TextBox", Container)
    SpamInput.Size = UDim2.new(1, -20, 0, 40)
    SpamInput.Position = UDim2.new(0, 10, 0, 50)
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
    
    local SpamDelayFrame, SpamDelaySlider, SpamSliderFill, SpamSliderButton, SpamDelayBox = Helpers.CreateSlider(Container, UDim2.new(1, -20, 0, 50), 0.05, 5, 0.1, "Spam Delay (seconds):")
    SpamDelayFrame.Position = UDim2.new(0, 10, 0, 110)
    
    local AutoSpamToggle = Helpers.CreateButton(Container, UDim2.new(0, 120, 0, 36), "OFF")
    AutoSpamToggle.Position = UDim2.new(0.5, 0, 0, 185)
    
    local Status = Instance.new("TextLabel", Container)
    Status.Size = UDim2.new(1, -20, 0, 50)
    Status.Position = UDim2.new(0, 10, 0, 225)
    Status.BackgroundTransparency = 1
    Status.Text = "Status: Inactive"
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 16
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

_G.UniversalUtility.Tabs.CreatePerformanceTab = function()
    local Container = Instance.new("Frame", FPSContent)
    Container.Size = UDim2.new(1, 0, 0, 520)
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
    Title.Size = UDim2.new(1, -20, 0, 24)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Performance Analytics"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local FPSUnlockToggle = Helpers.CreateButton(Container, UDim2.new(0, 160, 0, 36), "FPS Unlock: OFF")
    FPSUnlockToggle.Position = UDim2.new(0.5, 0, 0, 50)
    
    local FPSUnlockStatus = Instance.new("TextLabel", Container)
    FPSUnlockStatus.Size = UDim2.new(1, -20, 0, 24)
    FPSUnlockStatus.Position = UDim2.new(0, 10, 0, 96)
    FPSUnlockStatus.BackgroundTransparency = 1
    FPSUnlockStatus.Text = "Target: 60 FPS"
    FPSUnlockStatus.Font = Enum.Font.Gotham
    FPSUnlockStatus.TextSize = 16
    FPSUnlockStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
    FPSUnlockStatus.TextXAlignment = Enum.TextXAlignment.Center
    
    local FPSValueFrame, FPSSlider, FPSFill, FPSButton, FPSValueBox = Helpers.CreateSlider(Container, UDim2.new(1, -20, 0, 50), 15, 360, 60, "Target FPS:")
    FPSValueFrame.Position = UDim2.new(0, 10, 0, 130)
    
    local FPSStatsFrame = Instance.new("Frame", Container)
    FPSStatsFrame.Size = UDim2.new(1, -20, 0, 45)
    FPSStatsFrame.Position = UDim2.new(0, 10, 0, 190)
    FPSStatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    FPSStatsFrame.BorderSizePixel = 0
    Instance.new("UICorner", FPSStatsFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", FPSStatsFrame).Color = Color3.fromRGB(50, 50, 60)
    
    local CurrentFPSLabel = Instance.new("TextLabel", FPSStatsFrame)
    CurrentFPSLabel.Size = UDim2.new(0.33, 0, 1, 0)
    CurrentFPSLabel.BackgroundTransparency = 1
    CurrentFPSLabel.Text = "Current: 60"
    CurrentFPSLabel.Font = Enum.Font.GothamBold
    CurrentFPSLabel.TextSize = 12
    CurrentFPSLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    CurrentFPSLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local AvgFPSLabel = Instance.new("TextLabel", FPSStatsFrame)
    AvgFPSLabel.Size = UDim2.new(0.33, 0, 1, 0)
    AvgFPSLabel.Position = UDim2.new(0.33, 0, 0, 0)
    AvgFPSLabel.BackgroundTransparency = 1
    AvgFPSLabel.Text = "Average: 60"
    AvgFPSLabel.Font = Enum.Font.GothamBold
    AvgFPSLabel.TextSize = 12
    AvgFPSLabel.TextColor3 = Color3.fromRGB(50, 220, 100)
    AvgFPSLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local MinMaxFPSLabel = Instance.new("TextLabel", FPSStatsFrame)
    MinMaxFPSLabel.Size = UDim2.new(0.34, 0, 1, 0)
    MinMaxFPSLabel.Position = UDim2.new(0.66, 0, 0, 0)
    MinMaxFPSLabel.BackgroundTransparency = 1
    MinMaxFPSLabel.Text = "Min: 60 | Max: 60"
    MinMaxFPSLabel.Font = Enum.Font.GothamBold
    MinMaxFPSLabel.TextSize = 12
    MinMaxFPSLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    MinMaxFPSLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local PingStatsFrame = Instance.new("Frame", Container)
    PingStatsFrame.Size = UDim2.new(1, -20, 0, 45)
    PingStatsFrame.Position = UDim2.new(0, 10, 0, 250)
    PingStatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    PingStatsFrame.BorderSizePixel = 0
    Instance.new("UICorner", PingStatsFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", PingStatsFrame).Color = Color3.fromRGB(50, 50, 60)
    
    local CurrentPingLabel = Instance.new("TextLabel", PingStatsFrame)
    CurrentPingLabel.Size = UDim2.new(0.33, 0, 1, 0)
    CurrentPingLabel.BackgroundTransparency = 1
    CurrentPingLabel.Text = "Current: 0ms"
    CurrentPingLabel.Font = Enum.Font.GothamBold
    CurrentPingLabel.TextSize = 12
    CurrentPingLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    CurrentPingLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local AvgPingLabel = Instance.new("TextLabel", PingStatsFrame)
    AvgPingLabel.Size = UDim2.new(0.33, 0, 1, 0)
    AvgPingLabel.Position = UDim2.new(0.33, 0, 0, 0)
    AvgPingLabel.BackgroundTransparency = 1
    AvgPingLabel.Text = "Average: 0ms"
    AvgPingLabel.Font = Enum.Font.GothamBold
    AvgPingLabel.TextSize = 12
    AvgPingLabel.TextColor3 = Color3.fromRGB(50, 220, 100)
    AvgPingLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local MinMaxPingLabel = Instance.new("TextLabel", PingStatsFrame)
    MinMaxPingLabel.Size = UDim2.new(0.34, 0, 1, 0)
    MinMaxPingLabel.Position = UDim2.new(0.66, 0, 0, 0)
    MinMaxPingLabel.BackgroundTransparency = 1
    MinMaxPingLabel.Text = "Min: 0ms | Max: 0ms"
    MinMaxPingLabel.Font = Enum.Font.GothamBold
    MinMaxPingLabel.TextSize = 12
    MinMaxPingLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    MinMaxPingLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local NetworkStatusFrame = Instance.new("Frame", Container)
    NetworkStatusFrame.Size = UDim2.new(1, -20, 0, 45)
    NetworkStatusFrame.Position = UDim2.new(0, 10, 0, 310)
    NetworkStatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    NetworkStatusFrame.BorderSizePixel = 0
    Instance.new("UICorner", NetworkStatusFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", NetworkStatusFrame).Color = Color3.fromRGB(50, 50, 60)
    
    local NetworkStatusLabel = Instance.new("TextLabel", NetworkStatusFrame)
    NetworkStatusLabel.Size = UDim2.new(0.5, 0, 1, 0)
    NetworkStatusLabel.BackgroundTransparency = 1
    NetworkStatusLabel.Text = "Network Status:"
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
    PerformanceInfo.Size = UDim2.new(1, -20, 0, 135)
    PerformanceInfo.Position = UDim2.new(0, 10, 0, 370)
    PerformanceInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    PerformanceInfo.BorderSizePixel = 0
    PerformanceInfo.Text = "Performance monitoring provides real-time statistics about your game's FPS and network latency.\n\nLocking your FPS into small values may result in a lower memory consumption from Roblox but will also decrease the game quality."
    PerformanceInfo.Font = Enum.Font.Gotham
    PerformanceInfo.TextScaled = true
    PerformanceInfo.TextColor3 = Color3.fromRGB(255, 200, 150)
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

_G.UniversalUtility.Tabs.CreateAutoRejoinTab = function()
    local Container = Instance.new("Frame", RejoinContent)
    Container.Size = UDim2.new(1, 0, 0, 200)
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
    Title.Size = UDim2.new(1, -20, 0, 24)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Auto Rejoin"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local AutoRejoinToggle = Helpers.CreateButton(Container, UDim2.new(0, 180, 0, 40), "Auto Rejoin: OFF")
    AutoRejoinToggle.Position = UDim2.new(0.5, 0, 0, 60)
    
    local Status = Instance.new("TextLabel", Container)
    Status.Size = UDim2.new(1, -20, 0, 70)
    Status.Position = UDim2.new(0, 10, 0, 120)
    Status.BackgroundTransparency = 1
    Status.Text = "Status: Disabled\n\nAutomatically rejoins the game when you get disconnected.\nUseful for preventing AFK kicks."
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 16
    Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.TextWrapped = true
    
    return {
        AutoRejoinToggle = AutoRejoinToggle,
        Status = Status
    }
end

_G.UniversalUtility.Tabs.CreateScriptLoaderTab = function()
    local Container = Instance.new("Frame", LoaderContent)
    Container.Size = UDim2.new(1, 0, 0, 410)
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
    Title.Size = UDim2.new(1, -20, 0, 24)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "Script Loader"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local CodeEditorFrame = Instance.new("Frame", Container)
    CodeEditorFrame.Size = UDim2.new(1, -20, 0, 200)
    CodeEditorFrame.Position = UDim2.new(0, 10, 0, 45)
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
    LineNumbersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
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
    LoadStringScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
    
    local LoadStringBox = Instance.new("TextBox", LoadStringScrollFrame)
    LoadStringBox.Size = UDim2.new(1, -10, 1, 0)
    LoadStringBox.Position = UDim2.new(0, 5, 0, 0)
    LoadStringBox.BackgroundTransparency = 1
    LoadStringBox.Text = Config.SavedCode
    LoadStringBox.PlaceholderText = "Paste your code here..."
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
    ExecuteButton.Position = UDim2.new(0.25, 0, 0, 265)
    
    local AutoLoadButton = Helpers.CreateButton(Container, UDim2.new(0, 140, 0, 36), "Auto Load: OFF")
    AutoLoadButton.Position = UDim2.new(0.75, 0, 0, 265)
    
    local Status = Instance.new("TextLabel", Container)
    Status.Size = UDim2.new(1, -20, 0, 30)
    Status.Position = UDim2.new(0, 10, 0, 320)
    Status.BackgroundTransparency = 1
    Status.Text = "Status: Ready"
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 16
    Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    Status.TextXAlignment = Enum.TextXAlignment.Center
    
    local InfoLabel = Instance.new("TextLabel", Container)
    InfoLabel.Size = UDim2.new(1, -20, 0, 50)
    InfoLabel.Position = UDim2.new(0, 10, 0, 355)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "Auto Load executes your script automatically when you rejoin or teleport.\nThe script will update automatically when you edit it."
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextSize = 12
    InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
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

_G.UniversalUtility.Tabs.CreateSettingsTab = function()
    local Container = Instance.new("Frame", SettingsContent)
    Container.Size = UDim2.new(1, 0, 0, 180)
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
    Title.Size = UDim2.new(1, -20, 0, 24)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "UI Settings"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local KeybindButton = Helpers.CreateButton(Container, UDim2.new(0, 220, 0, 40), "Toggle Keybind: G")
    KeybindButton.Position = UDim2.new(0.5, 0, 0, 60)
    
    local Status = Instance.new("TextLabel", Container)
    Status.Size = UDim2.new(1, -20, 0, 60)
    Status.Position = UDim2.new(0, 10, 0, 115)
    Status.BackgroundTransparency = 1
    Status.Text = "Click the button above to change your Toggle Keybind\n\nPress the keybind at any time to open / close this menu."
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 16
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.TextWrapped = true
    
    return {
        KeybindButton = KeybindButton,
        Status = Status
    }
end

_G.UniversalUtility.Tabs.UIElements = {
    FPSLabel = FPSLabel,
    PingLabel = PingLabel
}

return _G.UniversalUtility.Tabs
