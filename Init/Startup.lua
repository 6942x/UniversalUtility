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

local HomeElements = Handlers.HomeElements
local AntiAFKElements = Handlers.AntiAFKElements
local KeySpamElements = Handlers.KeySpamElements
local PerformanceElements = Handlers.PerformanceElements
local RejoinElements = Handlers.RejoinElements
local LoaderElements = Handlers.LoaderElements
local SettingsElements = Handlers.SettingsElements

if HomeElements and HomeElements.FPSLabel and HomeElements.PingLabel and PerformanceElements and PerformanceElements.FPSStats and PerformanceElements.PingStats then
    Performance.StartMonitoring({
        FPSLabel = HomeElements.FPSLabel,
        PingLabel = HomeElements.PingLabel,
        FPSStats = PerformanceElements.FPSStats,
        PingStats = PerformanceElements.PingStats
    })
end

UI.LoadPlayerInfo()

if LoaderElements and LoaderElements.LoadStringBox and LoaderElements.LineNumbers and LoaderElements.LoadStringScrollFrame and LoaderElements.LineNumbersScrollFrame then
    Helpers.UpdateLineNumbers(LoaderElements.LoadStringBox, LoaderElements.LineNumbers, LoaderElements.LoadStringScrollFrame, LoaderElements.LineNumbersScrollFrame)
end

local configLoaded = _G.UniversalUtility.LoadConfig()

if configLoaded then
    if SettingsElements and SettingsElements.KeybindButton then
        local keyName = KeyCodeNames[Config.Keybind] or Config.Keybind.Name
        SettingsElements.KeybindButton.Text = "Current Key: " .. keyName
    end
    
    if KeySpamElements and KeySpamElements.SpamInput then
        KeySpamElements.SpamInput.Text = Config.SpamKey
    end
    
    if LoaderElements and LoaderElements.LoadStringBox then
        LoaderElements.LoadStringBox.Text = Config.SavedCode
    end
    
    if Handlers.UpdateJumpSlider then
        Handlers.UpdateJumpSlider((Config.JumpDelay - 5) / 25)
    end
    if Handlers.UpdateClickSlider then
        Handlers.UpdateClickSlider((Config.ClickDelay - 1) / 9)
    end
    if Handlers.UpdateSpamSlider then
        Handlers.UpdateSpamSlider((Config.SpamDelay - 0.05) / 4.95)
    end
    if Handlers.UpdateFPSSlider then
        Handlers.UpdateFPSSlider((Config.TargetFPS - 15) / 345)
    end
    if Handlers.UpdateClickTypeButtons then
        Handlers.UpdateClickTypeButtons()
    end
    
    if LoaderElements and LoaderElements.AutoLoadButton then
        if Config.AutoLoadEnabled then
            LoaderElements.AutoLoadButton.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            LoaderElements.AutoLoadButton.Text = "Auto Load: ON"
        else
            LoaderElements.AutoLoadButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            LoaderElements.AutoLoadButton.Text = "Auto Load: OFF"
        end
    end
    
    if RejoinElements and RejoinElements.AutoRejoinToggle and RejoinElements.Status then
        if Config.AutoRejoinEnabled then
            RejoinElements.AutoRejoinToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            RejoinElements.AutoRejoinToggle.Text = "Auto Rejoin: ON"
            RejoinElements.Status.Text = "System Status: Enabled\n\nWhen enabled, this feature will automatically rejoin the current server when you get disconnected due to errors or AFK timeout.\n\nThis helps maintain your session and prevents losing progress."
            RejoinElements.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
            if AutoRejoin and AutoRejoin.Setup then
                AutoRejoin.Setup()
            end
        end
    end
    
    if PerformanceElements and PerformanceElements.FPSUnlockToggle and PerformanceElements.FPSUnlockStatus then
        if Config.FPSUnlockEnabled and Performance.FPS_SUPPORTED then
            PerformanceElements.FPSUnlockToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            PerformanceElements.FPSUnlockToggle.Text = "FPS Unlock: ON"
            PerformanceElements.FPSUnlockStatus.TextColor3 = Color3.fromRGB(50, 220, 100)
            PerformanceElements.FPSUnlockStatus.Text = "Current Limit: " .. Config.TargetFPS .. " FPS (Custom)"
            if Performance and Performance.SetTargetFPS then
                Performance.SetTargetFPS(Config.TargetFPS)
            end
        end
    end
    
    if AntiAFKElements and AntiAFKElements.JumpToggle then
        if Config.JumpEnabled then
            AntiAFKElements.JumpToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            AntiAFKElements.JumpToggle.Text = "Auto Jump: ON"
            task.wait(0.1)
            if AntiAFK and AntiAFK.StartJumpThread then
                AntiAFK.StartJumpThread()
            end
        else
            AntiAFKElements.JumpToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            AntiAFKElements.JumpToggle.Text = "Auto Jump: OFF"
        end
    end
    
    if AntiAFKElements and AntiAFKElements.ClickToggle then
        if Config.ClickEnabled then
            AntiAFKElements.ClickToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            AntiAFKElements.ClickToggle.Text = "Auto Click: ON"
            task.wait(0.1)
            if AntiAFK and AntiAFK.StartClickThread then
                AntiAFK.StartClickThread()
            end
        else
            AntiAFKElements.ClickToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            AntiAFKElements.ClickToggle.Text = "Auto Click: OFF"
        end
    end
    
    if KeySpamElements and KeySpamElements.AutoSpamToggle and KeySpamElements.Status then
        if Config.AutoSpamEnabled then
            local keyCode = KeyCodeMap[Config.SpamKey]
            if keyCode and KeySpam and KeySpam.StartSpamThread then
                KeySpamElements.AutoSpamToggle.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
                KeySpamElements.AutoSpamToggle.Text = "ON"
                KeySpamElements.Status.Text = "System Status: Spamming " .. Config.SpamKey
                KeySpamElements.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
                task.wait(0.1)
                KeySpam.StartSpamThread()
            else
                Config.AutoSpamEnabled = false
                KeySpamElements.AutoSpamToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
                KeySpamElements.AutoSpamToggle.Text = "OFF"
                KeySpamElements.Status.Text = "System Status: Inactive"
                KeySpamElements.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        else
            KeySpamElements.AutoSpamToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            KeySpamElements.AutoSpamToggle.Text = "OFF"
            KeySpamElements.Status.Text = "System Status: Inactive"
            KeySpamElements.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
    
    if Handlers.UpdateAntiAFKStatus then
        Handlers.UpdateAntiAFKStatus()
    end
    
    if LoaderElements and LoaderElements.Status and Config.AutoLoadEnabled then
        local autoLoadCode = ScriptLoader and ScriptLoader.GetAutoLoadCode and ScriptLoader.GetAutoLoadCode()
        if autoLoadCode and autoLoadCode ~= "" and ScriptLoader and ScriptLoader.Execute then
            task.spawn(function()
                task.wait(0.5)
                local success, message = ScriptLoader.Execute(autoLoadCode)
                if success then
                    LoaderElements.Status.Text = "System Status: Auto-load executed successfully"
                    UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                        TextColor3 = Color3.fromRGB(50, 220, 100)
                    })
                else
                    LoaderElements.Status.Text = "System Status: Auto-load failed - " .. message
                    UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                        TextColor3 = Color3.fromRGB(220, 50, 50)
                    })
                end
                task.wait(3)
                LoaderElements.Status.Text = "System Status: Ready to execute"
                UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                    TextColor3 = Color3.fromRGB(180, 180, 180)
                })
            end)
        end
    end
else
    if Handlers.UpdateJumpSlider then
        Handlers.UpdateJumpSlider(0.2)
    end
    if Handlers.UpdateClickSlider then
        Handlers.UpdateClickSlider(0.22)
    end
    if Handlers.UpdateSpamSlider then
        Handlers.UpdateSpamSlider(0.01)
    end
    if Handlers.UpdateFPSSlider then
        Handlers.UpdateFPSSlider(0.13)
    end
    if Handlers.UpdateClickTypeButtons then
        Handlers.UpdateClickTypeButtons()
    end
    
    if AntiAFKElements then
        if AntiAFKElements.JumpToggle then
            AntiAFKElements.JumpToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            AntiAFKElements.JumpToggle.Text = "Auto Jump: OFF"
        end
        if AntiAFKElements.ClickToggle then
            AntiAFKElements.ClickToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            AntiAFKElements.ClickToggle.Text = "Auto Click: OFF"
        end
    end
    
    if KeySpamElements then
        if KeySpamElements.AutoSpamToggle then
            KeySpamElements.AutoSpamToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            KeySpamElements.AutoSpamToggle.Text = "OFF"
        end
        if KeySpamElements.Status then
            KeySpamElements.Status.Text = "System Status: Inactive"
            KeySpamElements.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
    
    if PerformanceElements then
        if PerformanceElements.FPSUnlockToggle then
            PerformanceElements.FPSUnlockToggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            PerformanceElements.FPSUnlockToggle.Text = "FPS Unlock: OFF"
        end
        if PerformanceElements.FPSUnlockStatus then
            PerformanceElements.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
            PerformanceElements.FPSUnlockStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
    
    if LoaderElements and LoaderElements.AutoLoadButton then
        LoaderElements.AutoLoadButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        LoaderElements.AutoLoadButton.Text = "Auto Load: OFF"
    end
    
    if Handlers.UpdateAntiAFKStatus then
        Handlers.UpdateAntiAFKStatus()
    end
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
