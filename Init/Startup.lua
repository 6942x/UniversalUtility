local TweenService = game:GetService("TweenService")

local Config = _G.UniversalUtility.Config
local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers
local Handlers = _G.UniversalUtility.Handlers
local Performance = _G.UniversalUtility.Performance
local Tabs = _G.UniversalUtility.Tabs
local AntiAFK = _G.UniversalUtility.AntiAFK
local KeySpam = _G.UniversalUtility.KeySpam
local ScriptLoader = _G.UniversalUtility.ScriptLoader
local AutoRejoin = _G.UniversalUtility.AutoRejoin
local Interactions = _G.UniversalUtility.Interactions
local KeyCodeMap = _G.UniversalUtility.KeyCodeMap
local KeyCodeNames = _G.UniversalUtility.KeyCodeNames

_G.UniversalUtility.Startup = {}

local AntiAFKElements = Handlers.AntiAFKElements
local KeySpamElements = Handlers.KeySpamElements
local PerformanceElements = Handlers.PerformanceElements
local RejoinElements = Handlers.RejoinElements
local LoaderElements = Handlers.LoaderElements
local SettingsElements = Handlers.SettingsElements

Performance.StartMonitoring({
    FPSLabel = Tabs.UIElements.FPSLabel,
    PingLabel = Tabs.UIElements.PingLabel,
    FPSStats = PerformanceElements.FPSStats,
    PingStats = PerformanceElements.PingStats
})

UI.LoadPlayerInfo()

Helpers.UpdateLineNumbers(LoaderElements.LoadStringBox, LoaderElements.LineNumbers, LoaderElements.LoadStringScrollFrame, LoaderElements.LineNumbersScrollFrame)

local configLoaded = _G.UniversalUtility.LoadConfig()

if configLoaded then
    local keyName = KeyCodeNames[Config.Keybind] or Config.Keybind.Name
    SettingsElements.KeybindButton.Text = "Toggle Keybind: " .. keyName
    KeySpamElements.SpamInput.Text = Config.SpamKey
    LoaderElements.LoadStringBox.Text = Config.SavedCode
    
    Handlers.UpdateJumpSlider((Config.JumpDelay - 5) / 25)
    Handlers.UpdateClickSlider((Config.ClickDelay - 1) / 9)
    Handlers.UpdateSpamSlider((Config.SpamDelay - 0.05) / 4.95)
    Handlers.UpdateFPSSlider((Config.TargetFPS - 15) / 345)
    Handlers.UpdateClickTypeButtons()
    
    if Config.AutoLoadEnabled then
        LoaderElements.AutoLoadButton.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
        LoaderElements.AutoLoadButton.Text = "Auto Load: ON"
    else
        LoaderElements.AutoLoadButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        LoaderElements.AutoLoadButton.Text = "Auto Load: OFF"
    end
    
    if Config.AutoRejoinEnabled then
        RejoinElements.AutoRejoinToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
        RejoinElements.AutoRejoinToggle.Text = "Auto Rejoin: ON"
        RejoinElements.Status.Text = "Status: Enabled\n\nAutomatically rejoins the game when you get disconnected.\nUseful for preventing AFK kicks."
        RejoinElements.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        AutoRejoin.Setup()
    end
    
    if Config.FPSUnlockEnabled and Performance.FPS_SUPPORTED then
        PerformanceElements.FPSUnlockToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
        PerformanceElements.FPSUnlockToggle.Text = "FPS Unlock: ON"
        PerformanceElements.FPSUnlockStatus.TextColor3 = Color3.fromRGB(50, 220, 100)
        PerformanceElements.FPSUnlockStatus.Text = "Your target: " .. Config.TargetFPS .. " FPS"
        Performance.SetTargetFPS(Config.TargetFPS)
    end
    
    if Config.JumpEnabled then
        AntiAFKElements.JumpToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
        AntiAFKElements.JumpToggle.Text = "Auto Jump: ON"
        task.wait(0.1)
        AntiAFK.StartJumpThread()
    else
        AntiAFKElements.JumpToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        AntiAFKElements.JumpToggle.Text = "Auto Jump: OFF"
    end
    
    if Config.ClickEnabled then
        AntiAFKElements.ClickToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
        AntiAFKElements.ClickToggle.Text = "Auto Click: ON"
        task.wait(0.1)
        AntiAFK.StartClickThread()
    else
        AntiAFKElements.ClickToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        AntiAFKElements.ClickToggle.Text = "Auto Click: OFF"
    end
    
    if Config.AutoSpamEnabled then
        local keyCode = KeyCodeMap[Config.SpamKey]
        if keyCode then
            KeySpamElements.AutoSpamToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            KeySpamElements.AutoSpamToggle.Text = "ON"
            KeySpamElements.Status.Text = "Status: Spamming " .. Config.SpamKey
            KeySpamElements.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
            task.wait(0.1)
            KeySpam.StartSpamThread()
        else
            Config.AutoSpamEnabled = false
            KeySpamElements.AutoSpamToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            KeySpamElements.AutoSpamToggle.Text = "OFF"
            KeySpamElements.Status.Text = "Status: Inactive"
            KeySpamElements.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    else
        KeySpamElements.AutoSpamToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        KeySpamElements.AutoSpamToggle.Text = "OFF"
        KeySpamElements.Status.Text = "Status: Inactive"
        KeySpamElements.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
    
    Handlers.UpdateAntiAFKStatus()
    
    if Config.AutoLoadEnabled then
        local autoLoadCode = ScriptLoader.GetAutoLoadCode()
        if autoLoadCode and autoLoadCode ~= "" then
            task.spawn(function()
                task.wait(0.5)
                local success, message = ScriptLoader.Execute(autoLoadCode)
                if success then
                    LoaderElements.Status.Text = "Status: Auto-loaded successfully"
                    UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                        TextColor3 = Color3.fromRGB(50, 220, 100)
                    })
                else
                    LoaderElements.Status.Text = "Status: Auto-load failed - " .. message
                    UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                        TextColor3 = Color3.fromRGB(220, 50, 50)
                    })
                end
                task.wait(3)
                LoaderElements.Status.Text = "Status: Ready"
                UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                    TextColor3 = Color3.fromRGB(180, 180, 180)
                })
            end)
        end
    end
else
    Handlers.UpdateJumpSlider(0.2)
    Handlers.UpdateClickSlider(0.22)
    Handlers.UpdateSpamSlider(0.01)
    Handlers.UpdateFPSSlider(0.13)
    Handlers.UpdateClickTypeButtons()
    
    AntiAFKElements.JumpToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    AntiAFKElements.JumpToggle.Text = "Auto Jump: OFF"
    AntiAFKElements.ClickToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    AntiAFKElements.ClickToggle.Text = "Auto Click: OFF"
    KeySpamElements.AutoSpamToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    KeySpamElements.AutoSpamToggle.Text = "OFF"
    KeySpamElements.Status.Text = "Status: Inactive"
    KeySpamElements.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    PerformanceElements.FPSUnlockToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    PerformanceElements.FPSUnlockToggle.Text = "FPS Unlock: OFF"
    PerformanceElements.FPSUnlockStatus.Text = "Default FPS"
    PerformanceElements.FPSUnlockStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
    LoaderElements.AutoLoadButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    LoaderElements.AutoLoadButton.Text = "Auto Load: OFF"
    Handlers.UpdateAntiAFKStatus()
end

for name, content in pairs(UI.TabContents) do
    content.Visible = false
end

Config.CurrentTab = nil

UI.ScreenGui.Destroying:Connect(Helpers.CleanupAllThreads)

task.wait(0.1)

UI.MainFrame.Visible = true
UI.MainFrame.Size = UDim2.new(0, 0, 0, 0)

local targetUIPos
if configLoaded and Config.UIPosition then
    targetUIPos = UDim2.new(
        Config.UIPosition.X, -325,
        Config.UIPosition.Y, -250
    )
    UI.MainFrame.Position = UDim2.new(Config.UIPosition.X, 0, Config.UIPosition.Y, 0)
else
    targetUIPos = UDim2.new(0.5, -325, 0.5, -250)
    UI.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end

if configLoaded and Config.ReopenPosition then
    UI.ReopenButton.Position = UDim2.new(
        Config.ReopenPosition.X, -30,
        0, Config.ReopenPosition.Y
    )
else
    UI.ReopenButton.Position = UDim2.new(0.5, -30, 0, 30)
end

UI.ReopenButton.Visible = false

local openTween = UI.PlayTween(UI.MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 650, 0, 500),
    Position = targetUIPos
})

openTween.Completed:Wait()

Interactions.SwitchTab("Home")

_G.UniversalUtility.SaveConfig()

return _G.UniversalUtility.Startup
