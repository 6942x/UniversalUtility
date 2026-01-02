local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Config = _G.UniversalUtility.Config
local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers
local TabHandler = _G.UniversalUtility.TabHandler
local Interactions = _G.UniversalUtility.Interactions
local AntiAFK = _G.UniversalUtility.AntiAFK
local KeySpam = _G.UniversalUtility.KeySpam
local Performance = _G.UniversalUtility.Performance
local ScriptLoader = _G.UniversalUtility.ScriptLoader
local AutoRejoin = _G.UniversalUtility.AutoRejoin
local Debounces = _G.UniversalUtility.Debounces
local KeyCodeMap = _G.UniversalUtility.KeyCodeMap
local KeyCodeNames = _G.UniversalUtility.KeyCodeNames

_G.UniversalUtility.Handlers = {}

local function SetDebounce(key, duration)
    if Debounces[key] then return false end
    Debounces[key] = true
    task.delay(duration or 0.3, function() Debounces[key] = false end)
    return true
end

TabHandler.Initialize()

local success, loadedTabs = TabHandler.LoadTabModules()
if not success then
    error("Failed to load tab: " .. tostring(loadedTabs))
end

_G.UniversalUtility.Handlers.HomeElements = loadedTabs["Home"]
_G.UniversalUtility.Handlers.AntiAFKElements = loadedTabs["Anti-AFK"]
_G.UniversalUtility.Handlers.KeySpamElements = loadedTabs["KeySpam"]
_G.UniversalUtility.Handlers.PerformanceElements = loadedTabs["Performance Status"]
_G.UniversalUtility.Handlers.RejoinElements = loadedTabs["Auto Rejoin"]
_G.UniversalUtility.Handlers.LoaderElements = loadedTabs["Script Loader"]
_G.UniversalUtility.Handlers.SettingsElements = loadedTabs["Settings"]

local HomeElements = _G.UniversalUtility.Handlers.HomeElements
local AntiAFKElements = _G.UniversalUtility.Handlers.AntiAFKElements
local KeySpamElements = _G.UniversalUtility.Handlers.KeySpamElements
local PerformanceElements = _G.UniversalUtility.Handlers.PerformanceElements
local RejoinElements = _G.UniversalUtility.Handlers.RejoinElements
local LoaderElements = _G.UniversalUtility.Handlers.LoaderElements
local SettingsElements = _G.UniversalUtility.Handlers.SettingsElements

local function UpdateAntiAFKStatus()
    if not AntiAFKElements or not AntiAFKElements.Status then return end
    
    local statusText, statusColor
    if Config.JumpEnabled and Config.ClickEnabled then
        statusText = "Status: Jump & Click Active"
        statusColor = Color3.fromRGB(50, 220, 100)
    elseif Config.JumpEnabled then
        statusText = "Status: Jump Active"
        statusColor = Color3.fromRGB(100, 200, 255)
    elseif Config.ClickEnabled then
        statusText = "Status: Click Active"
        statusColor = Color3.fromRGB(255, 200, 100)
    else
        statusText = "Status: All Inactive"
        statusColor = Color3.fromRGB(180, 180, 180)
    end
    
    UI.PlayTween(AntiAFKElements.Status, UI.TweenPresets.Fast, {
        TextColor3 = statusColor
    })
    AntiAFKElements.Status.Text = statusText
end

local function UpdateClickTypeButtons()
    if not AntiAFKElements then return end
    
    local buttons = {
        Current = AntiAFKElements.ClickTypeCurrent,
        Center = AntiAFKElements.ClickTypeCenter,
        Random = AntiAFKElements.ClickTypeRandom
    }
    
    for type, btn in pairs(buttons) do
        if btn then
            local isActive = (Config.ClickType == type)
            local targetColor = isActive and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(45, 45, 52)
            
            if _G.UniversalUtility.ButtonStates[btn] then
                _G.UniversalUtility.ButtonStates[btn].BaseColor = targetColor
            end

            UI.PlayTween(btn, UI.TweenPresets.Fast, {
                BackgroundColor3 = targetColor
            })
        end
    end
end

local dragging = {jump = false, click = false, spam = false, fps = false}

if AntiAFKElements and AntiAFKElements.JumpSliderButton then
    AntiAFKElements.JumpSliderButton.MouseButton1Down:Connect(function()
        dragging.jump = true
        Interactions.AnimateButtonPress(AntiAFKElements.JumpSliderButton, 0.9)
    end)
end

if AntiAFKElements and AntiAFKElements.ClickSliderButton then
    AntiAFKElements.ClickSliderButton.MouseButton1Down:Connect(function()
        dragging.click = true
        Interactions.AnimateButtonPress(AntiAFKElements.ClickSliderButton, 0.9)
    end)
end

if KeySpamElements and KeySpamElements.SpamSliderButton then
    KeySpamElements.SpamSliderButton.MouseButton1Down:Connect(function()
        dragging.spam = true
        Interactions.AnimateButtonPress(KeySpamElements.SpamSliderButton, 0.9)
    end)
end

if PerformanceElements and PerformanceElements.FPSButton then
    PerformanceElements.FPSButton.MouseButton1Down:Connect(function()
        dragging.fps = true
        Interactions.AnimateButtonPress(PerformanceElements.FPSButton, 0.9)
    end)
end

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging.jump, dragging.click, dragging.spam, dragging.fps = false, false, false, false
    end
end)

local function UpdateJumpSlider(percentage)
    if not AntiAFKElements then return end
    
    Config.JumpDelay = 5 + (percentage * 25)
    Helpers.UpdateSlider(AntiAFKElements.JumpSliderFill, AntiAFKElements.JumpDelayBox, nil, Config.JumpDelay, 5, 30, "%.1f")
    _G.UniversalUtility.SaveConfig()
end

local function UpdateClickSlider(percentage)
    if not AntiAFKElements then return end
    
    Config.ClickDelay = 1 + (percentage * 9)
    Helpers.UpdateSlider(AntiAFKElements.ClickSliderFill, AntiAFKElements.ClickDelayBox, nil, Config.ClickDelay, 1, 10, "%.1f")
    _G.UniversalUtility.SaveConfig()
end

local function UpdateSpamSlider(percentage)
    if not KeySpamElements then return end
    
    Config.SpamDelay = 0.05 + (percentage * 4.95)
    Helpers.UpdateSlider(KeySpamElements.SpamSliderFill, KeySpamElements.SpamDelayBox, nil, Config.SpamDelay, 0.05, 5, "%.2f")
    _G.UniversalUtility.SaveConfig()
end

local function UpdateFPSSlider(percentage)
    if not PerformanceElements then return end
    
    Config.TargetFPS = math.floor(15 + (percentage * 345))
    Helpers.UpdateSlider(PerformanceElements.FPSFill, PerformanceElements.FPSValueBox, nil, Config.TargetFPS, 15, 360, "%d")
    if Config.FPSUnlockEnabled and Performance.FPS_SUPPORTED then
        Performance.SetTargetFPS(Config.TargetFPS)
        PerformanceElements.FPSUnlockStatus.Text = "Your target: " .. Config.TargetFPS .. " FPS"
    end
    _G.UniversalUtility.SaveConfig()
end

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouseX = UserInputService:GetMouseLocation().X
        if dragging.jump and AntiAFKElements and AntiAFKElements.JumpDelaySlider then
            UpdateJumpSlider(math.clamp((mouseX - AntiAFKElements.JumpDelaySlider.AbsolutePosition.X) / AntiAFKElements.JumpDelaySlider.AbsoluteSize.X, 0, 1))
        elseif dragging.click and AntiAFKElements and AntiAFKElements.ClickDelaySlider then
            UpdateClickSlider(math.clamp((mouseX - AntiAFKElements.ClickDelaySlider.AbsolutePosition.X) / AntiAFKElements.ClickDelaySlider.AbsoluteSize.X, 0, 1))
        elseif dragging.spam and KeySpamElements and KeySpamElements.SpamDelaySlider then
            UpdateSpamSlider(math.clamp((mouseX - KeySpamElements.SpamDelaySlider.AbsolutePosition.X) / KeySpamElements.SpamDelaySlider.AbsoluteSize.X, 0, 1))
        elseif dragging.fps and PerformanceElements and PerformanceElements.FPSSlider then
            UpdateFPSSlider(math.clamp((mouseX - PerformanceElements.FPSSlider.AbsolutePosition.X) / PerformanceElements.FPSSlider.AbsoluteSize.X, 0, 1))
        end
    end
end)

if AntiAFKElements and AntiAFKElements.JumpDelayBox then
    AntiAFKElements.JumpDelayBox.FocusLost:Connect(function()
        local value = math.clamp(tonumber(AntiAFKElements.JumpDelayBox.Text) or Config.JumpDelay, 5, 30)
        Config.JumpDelay = value
        UpdateJumpSlider((value - 5) / 25)
    end)
end

if AntiAFKElements and AntiAFKElements.ClickDelayBox then
    AntiAFKElements.ClickDelayBox.FocusLost:Connect(function()
        local value = math.clamp(tonumber(AntiAFKElements.ClickDelayBox.Text) or Config.ClickDelay, 1, 10)
        Config.ClickDelay = value
        UpdateClickSlider((value - 1) / 9)
    end)
end

if KeySpamElements and KeySpamElements.SpamDelayBox then
    KeySpamElements.SpamDelayBox.FocusLost:Connect(function()
        local value = math.clamp(tonumber(KeySpamElements.SpamDelayBox.Text) or Config.SpamDelay, 0.05, 5)
        Config.SpamDelay = value
        UpdateSpamSlider((value - 0.05) / 4.95)
    end)
end

if PerformanceElements and PerformanceElements.FPSValueBox then
    PerformanceElements.FPSValueBox.FocusLost:Connect(function()
        local value = math.clamp(tonumber(PerformanceElements.FPSValueBox.Text) or Config.TargetFPS, 15, 360)
        Config.TargetFPS = value
        UpdateFPSSlider((value - 15) / 345)
    end)
end

if KeySpamElements and KeySpamElements.SpamInput then
    KeySpamElements.SpamInput.FocusLost:Connect(function()
        Config.SpamKey = KeySpamElements.SpamInput.Text:upper()
        _G.UniversalUtility.SaveConfig()
    end)
end

local clickTypeDebounce = false

local function HandleClickTypeChange(newType)
    if clickTypeDebounce or Config.ClickType == newType then return end
    clickTypeDebounce = true
    
    Config.ClickType = newType
    UpdateClickTypeButtons()
    _G.UniversalUtility.SaveConfig()
    
    task.delay(0.1, function()
        clickTypeDebounce = false
    end)
end

if AntiAFKElements and AntiAFKElements.ClickTypeCurrent then
    AntiAFKElements.ClickTypeCurrent.MouseButton1Click:Connect(function()
        HandleClickTypeChange("Current")
        Interactions.AnimateButtonPress(AntiAFKElements.ClickTypeCurrent)
    end)
end

if AntiAFKElements and AntiAFKElements.ClickTypeCenter then
    AntiAFKElements.ClickTypeCenter.MouseButton1Click:Connect(function()
        HandleClickTypeChange("Center")
        Interactions.AnimateButtonPress(AntiAFKElements.ClickTypeCenter)
    end)
end

if AntiAFKElements and AntiAFKElements.ClickTypeRandom then
    AntiAFKElements.ClickTypeRandom.MouseButton1Click:Connect(function()
        HandleClickTypeChange("Random")
        Interactions.AnimateButtonPress(AntiAFKElements.ClickTypeRandom)
    end)
end

if AntiAFKElements and AntiAFKElements.JumpToggle then
    AntiAFKElements.JumpToggle.MouseButton1Click:Connect(function()
        if not SetDebounce("Jump", 0.3) then return end
        Interactions.AnimateButtonPress(AntiAFKElements.JumpToggle)
        
        Config.JumpEnabled = not Config.JumpEnabled
        local targetColor = Config.JumpEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
        if _G.UniversalUtility.ButtonStates[AntiAFKElements.JumpToggle] then
            _G.UniversalUtility.ButtonStates[AntiAFKElements.JumpToggle].BaseColor = targetColor
        end
        
        UI.PlayTween(AntiAFKElements.JumpToggle, UI.TweenPresets.Medium, {
            BackgroundColor3 = targetColor
        })
        
        AntiAFKElements.JumpToggle.Text = "Auto Jump: " .. (Config.JumpEnabled and "ON" or "OFF")
        if Config.JumpEnabled then
            task.wait(0.05)
            AntiAFK.StartJumpThread()
        else
            AntiAFK.StopJumpThread()
        end
        UpdateAntiAFKStatus()
        _G.UniversalUtility.SaveConfig()
    end)
end

if AntiAFKElements and AntiAFKElements.ClickToggle then
    AntiAFKElements.ClickToggle.MouseButton1Click:Connect(function()
        if not SetDebounce("Click", 0.3) then return end
        Interactions.AnimateButtonPress(AntiAFKElements.ClickToggle)
        
        Config.ClickEnabled = not Config.ClickEnabled
        local targetColor = Config.ClickEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
        if _G.UniversalUtility.ButtonStates[AntiAFKElements.ClickToggle] then
            _G.UniversalUtility.ButtonStates[AntiAFKElements.ClickToggle].BaseColor = targetColor
        end
        
        UI.PlayTween(AntiAFKElements.ClickToggle, UI.TweenPresets.Medium, {
            BackgroundColor3 = targetColor
        })
        
        AntiAFKElements.ClickToggle.Text = "Auto Click: " .. (Config.ClickEnabled and "ON" or "OFF")
        if Config.ClickEnabled then
            task.wait(0.05)
            AntiAFK.StartClickThread()
        else
            AntiAFK.StopClickThread()
        end
        UpdateAntiAFKStatus()
        _G.UniversalUtility.SaveConfig()
    end)
end

if KeySpamElements and KeySpamElements.AutoSpamToggle then
    KeySpamElements.AutoSpamToggle.MouseButton1Click:Connect(function()
        if not SetDebounce("Spam", 0.3) then return end
        Interactions.AnimateButtonPress(KeySpamElements.AutoSpamToggle)
        
        Config.AutoSpamEnabled = not Config.AutoSpamEnabled
        if Config.AutoSpamEnabled then
            local keyText = KeySpamElements.SpamInput.Text:upper()
            local keyCode = KeyCodeMap[keyText]
            if not keyCode then
                Config.AutoSpamEnabled = false
                KeySpamElements.Status.Text = "Status: Invalid key"
                UI.PlayTween(KeySpamElements.Status, UI.TweenPresets.Fast, {
                    TextColor3 = Color3.fromRGB(220, 50, 50)
                })
                return
            end
            
            if keyCode == Enum.KeyCode.P or keyCode == Enum.KeyCode.G then
                Config.AutoSpamEnabled = false
                KeySpamElements.Status.Text = "Status: Key reserved"
                UI.PlayTween(KeySpamElements.Status, UI.TweenPresets.Fast, {
                    TextColor3 = Color3.fromRGB(220, 50, 50)
                })
                return
            end
            
            Config.SpamKey = keyText
            local targetColor = Color3.fromRGB(50, 220, 100)
            if _G.UniversalUtility.ButtonStates[KeySpamElements.AutoSpamToggle] then
                _G.UniversalUtility.ButtonStates[KeySpamElements.AutoSpamToggle].BaseColor = targetColor
            end
            
            UI.PlayTween(KeySpamElements.AutoSpamToggle, UI.TweenPresets.Medium, {
                BackgroundColor3 = targetColor
            })
            KeySpamElements.AutoSpamToggle.Text = "ON"
            KeySpamElements.Status.Text = "Status: Spamming " .. keyText
            UI.PlayTween(KeySpamElements.Status, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(50, 220, 100)
            })
            task.wait(0.05)
            
            if KeySpam and KeySpam.StartSpamThread then
                KeySpam.StartSpamThread()
            else
                warn("KeySpam module not loaded!")
            end
        else
            local targetColor = Color3.fromRGB(220, 50, 50)
            if _G.UniversalUtility.ButtonStates[KeySpamElements.AutoSpamToggle] then
                _G.UniversalUtility.ButtonStates[KeySpamElements.AutoSpamToggle].BaseColor = targetColor
            end
            
            UI.PlayTween(KeySpamElements.AutoSpamToggle, UI.TweenPresets.Medium, {
                BackgroundColor3 = targetColor
            })
            KeySpamElements.AutoSpamToggle.Text = "OFF"
            KeySpamElements.Status.Text = "Status: Inactive"
            UI.PlayTween(KeySpamElements.Status, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(180, 180, 180)
            })
            
            if KeySpam and KeySpam.StopSpamThread then
                KeySpam.StopSpamThread()
            else
                warn("KeySpam module not loaded!")
            end
        end
        _G.UniversalUtility.SaveConfig()
    end)
end

if PerformanceElements and PerformanceElements.FPSUnlockToggle then
    PerformanceElements.FPSUnlockToggle.MouseButton1Click:Connect(function()
        if not SetDebounce("FPS", 0.3) then return end
        Interactions.AnimateButtonPress(PerformanceElements.FPSUnlockToggle)
        
        local success, result = Performance.ToggleFPSUnlock()
        
        if not success then
            PerformanceElements.FPSUnlockStatus.Text = result
            UI.PlayTween(PerformanceElements.FPSUnlockStatus, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(220, 50, 50)
            })
            return
        end
        
        local targetColor = result and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
        if _G.UniversalUtility.ButtonStates[PerformanceElements.FPSUnlockToggle] then
            _G.UniversalUtility.ButtonStates[PerformanceElements.FPSUnlockToggle].BaseColor = targetColor
        end
        
        UI.PlayTween(PerformanceElements.FPSUnlockToggle, UI.TweenPresets.Medium, {
            BackgroundColor3 = targetColor
        })
        
        PerformanceElements.FPSUnlockToggle.Text = "FPS Unlock: " .. (result and "ON" or "OFF")
        if result then
            PerformanceElements.FPSUnlockStatus.Text = "Your target: " .. Config.TargetFPS .. " FPS"
            UI.PlayTween(PerformanceElements.FPSUnlockStatus, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(50, 220, 100)
            })
        else
            PerformanceElements.FPSUnlockStatus.Text = "Default FPS"
            UI.PlayTween(PerformanceElements.FPSUnlockStatus, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(180, 180, 180)
            })
        end
    end)
end

if RejoinElements and RejoinElements.AutoRejoinToggle then
    RejoinElements.AutoRejoinToggle.MouseButton1Click:Connect(function()
        if not SetDebounce("Rejoin", 0.3) then return end
        Interactions.AnimateButtonPress(RejoinElements.AutoRejoinToggle)
        
        Config.AutoRejoinEnabled = not Config.AutoRejoinEnabled
        local targetColor = Config.AutoRejoinEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
        if _G.UniversalUtility.ButtonStates[RejoinElements.AutoRejoinToggle] then
            _G.UniversalUtility.ButtonStates[RejoinElements.AutoRejoinToggle].BaseColor = targetColor
        end
        
        UI.PlayTween(RejoinElements.AutoRejoinToggle, UI.TweenPresets.Medium, {
            BackgroundColor3 = targetColor
        })
        
        RejoinElements.AutoRejoinToggle.Text = "Auto Rejoin: " .. (Config.AutoRejoinEnabled and "ON" or "OFF")
        RejoinElements.Status.Text = "Status: " .. (Config.AutoRejoinEnabled and "Enabled" or "Disabled") .. "\n\nAutomatically rejoins the game when you get disconnected.\nUseful for preventing AFK kicks."
        UI.PlayTween(RejoinElements.Status, UI.TweenPresets.Fast, {
            TextColor3 = Config.AutoRejoinEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(180, 180, 180)
        })
        
        if Config.AutoRejoinEnabled then
            AutoRejoin.Setup()
        else
            AutoRejoin.Stop()
        end
        _G.UniversalUtility.SaveConfig()
    end)
end

if LoaderElements and LoaderElements.ExecuteButton then
    LoaderElements.ExecuteButton.MouseButton1Click:Connect(function()
        if not SetDebounce("Execute", 0.5) then return end
        Interactions.AnimateButtonPress(LoaderElements.ExecuteButton)
        
        local code = LoaderElements.LoadStringBox.Text
        
        LoaderElements.Status.Text = "Status: Executing..."
        UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
            TextColor3 = Color3.fromRGB(255, 200, 100)
        })
        UI.PlayTween(LoaderElements.ExecuteButton, UI.TweenPresets.Medium, {
            BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        })
        
        local success, message = ScriptLoader.Execute(code)
        
        if success then
            LoaderElements.Status.Text = "Status: " .. message
            UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(50, 220, 100)
            })
            UI.PlayTween(LoaderElements.ExecuteButton, UI.TweenPresets.Medium, {
                BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            })
        else
            LoaderElements.Status.Text = "Status: " .. message
            UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(220, 50, 50)
            })
            UI.PlayTween(LoaderElements.ExecuteButton, UI.TweenPresets.Medium, {
                BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            })
        end
        
        task.wait(2)
        if LoaderElements.Status.Text:match("Error") or LoaderElements.Status.Text:match("successfully") then
            LoaderElements.Status.Text = "Status: Ready"
            UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(180, 180, 180)
            })
            UI.PlayTween(LoaderElements.ExecuteButton, UI.TweenPresets.Medium, {
                BackgroundColor3 = Color3.fromRGB(45, 45, 52)
            })
        end
    end)
end

if LoaderElements and LoaderElements.AutoLoadButton then
    LoaderElements.AutoLoadButton.MouseButton1Click:Connect(function()
        if not SetDebounce("AutoLoad", 0.3) then return end
        Interactions.AnimateButtonPress(LoaderElements.AutoLoadButton)
        
        Config.AutoLoadEnabled = not Config.AutoLoadEnabled
        local targetColor = Config.AutoLoadEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
        
        if _G.UniversalUtility.ButtonStates[LoaderElements.AutoLoadButton] then
            _G.UniversalUtility.ButtonStates[LoaderElements.AutoLoadButton].BaseColor = targetColor
        end
        
        UI.PlayTween(LoaderElements.AutoLoadButton, UI.TweenPresets.Medium, {
            BackgroundColor3 = targetColor
        })
        
        LoaderElements.AutoLoadButton.Text = "Auto Load: " .. (Config.AutoLoadEnabled and "ON" or "OFF")
        
        local success, message = ScriptLoader.SetAutoLoad(Config.AutoLoadEnabled)
        
        if success then
            LoaderElements.Status.Text = "Status: " .. message
            UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                TextColor3 = Config.AutoLoadEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(180, 180, 180)
            })
        else
            LoaderElements.Status.Text = "Status: " .. message
            UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(220, 50, 50)
            })
        end
        
        task.wait(2)
        if LoaderElements.Status.Text:match("enabled") or LoaderElements.Status.Text:match("disabled") then
            LoaderElements.Status.Text = "Status: Ready"
            UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(180, 180, 180)
            })
        end
    end)
end

local SaveCodeTimer = nil
local SaveCodeDelay = 1.0

if LoaderElements and LoaderElements.LoadStringBox then
    LoaderElements.LoadStringBox:GetPropertyChangedSignal("Text"):Connect(function()
        if SaveCodeTimer then
            task.cancel(SaveCodeTimer)
        end
        
        SaveCodeTimer = task.delay(SaveCodeDelay, function()
            ScriptLoader.SaveCode(LoaderElements.LoadStringBox.Text)
            LoaderElements.Status.Text = "Status: Code auto-saved ✓"
            UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(100, 200, 255)
            })
            task.wait(2)
            if LoaderElements.Status.Text == "Status: Code auto-saved ✓" then
                LoaderElements.Status.Text = "Status: Ready"
                UI.PlayTween(LoaderElements.Status, UI.TweenPresets.Fast, {
                    TextColor3 = Color3.fromRGB(180, 180, 180)
                })
            end
        end)
        
        if LoaderElements.LineNumbers and LoaderElements.LoadStringScrollFrame and LoaderElements.LineNumbersScrollFrame then
            Helpers.UpdateLineNumbers(LoaderElements.LoadStringBox, LoaderElements.LineNumbers, LoaderElements.LoadStringScrollFrame, LoaderElements.LineNumbersScrollFrame)
        end
    end)
end

if LoaderElements and LoaderElements.LoadStringScrollFrame and LoaderElements.LineNumbersScrollFrame then
    LoaderElements.LoadStringScrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        LoaderElements.LineNumbersScrollFrame.CanvasPosition = Vector2.new(0, LoaderElements.LoadStringScrollFrame.CanvasPosition.Y)
    end)
end

if SettingsElements and SettingsElements.KeybindButton then
    SettingsElements.KeybindButton.MouseButton1Click:Connect(function()
        if not SetDebounce("Keybind", 0.5) or Config.IsChangingKeybind then return end
        Interactions.AnimateButtonPress(SettingsElements.KeybindButton)
        Config.IsChangingKeybind = true
        
        SettingsElements.KeybindButton.Text = "Press any key..."
        SettingsElements.Status.Text = "Waiting for input..."
        UI.PlayTween(SettingsElements.Status, UI.TweenPresets.Fast, {
            TextColor3 = Color3.fromRGB(255, 200, 100)
        })
        
        SettingsElements.KeybindButton.Active = false
        
        local connection
        local timeout = task.delay(5, function()
            if connection then
                connection:Disconnect()
                Config.IsChangingKeybind = false
                SettingsElements.KeybindButton.Active = true
                
                SettingsElements.KeybindButton.Text = "Toggle Keybind: " .. (KeyCodeNames[Config.Keybind] or Config.Keybind.Name)
                SettingsElements.Status.Text = "Timeout - Click again to retry"
                UI.PlayTween(SettingsElements.Status, UI.TweenPresets.Fast, {
                    TextColor3 = Color3.fromRGB(255, 100, 100)
                })
                task.wait(2)
                if SettingsElements.Status.Text:match("Timeout") then
                    SettingsElements.Status.Text = "Click the button above to change your Toggle Keybind\n\nPress the keybind at any time to open/close this menu."
                    UI.PlayTween(SettingsElements.Status, UI.TweenPresets.Fast, {
                        TextColor3 = Color3.fromRGB(150, 150, 150)
                    })
                end
            end
        end)
        
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.Keyboard and not gameProcessed then
                task.cancel(timeout)
                
                Config.Keybind = input.KeyCode
                local keyName = KeyCodeNames[input.KeyCode] or input.KeyCode.Name
                SettingsElements.KeybindButton.Text = "Toggle Keybind: " .. keyName
                SettingsElements.Status.Text = "Keybind changed successfully!\n\nPress the keybind at any time to open/close this menu."
                UI.PlayTween(SettingsElements.Status, UI.TweenPresets.Fast, {
                    TextColor3 = Color3.fromRGB(50, 220, 100)
                })
                _G.UniversalUtility.SaveConfig()
                
                SettingsElements.KeybindButton.Active = true
                connection:Disconnect()
                
                task.delay(0.1, function()
                    Config.IsChangingKeybind = false
                end)
                
                task.wait(1.5)
                if SettingsElements.Status.Text:match("successfully") then
                    SettingsElements.Status.Text = "Click the button above to change your Toggle Keybind\n\nPress the keybind at any time to open/close this menu."
                    UI.PlayTween(SettingsElements.Status, UI.TweenPresets.Fast, {
                        TextColor3 = Color3.fromRGB(150, 150, 150)
                    })
                end
            end
        end)
    end)
end

for _, tab in ipairs({{name="Home"},{name="Anti-AFK"},{name="KeySpam"},{name="Performance Status"},{name="Auto Rejoin"},{name="Script Loader"},{name="Settings"}}) do
    local name = tab.name
    if UI.TabButtons[name] and UI.TabButtons[name].Button then
        UI.TabButtons[name].Button.MouseButton1Click:Connect(function()
            Interactions.SwitchTab(name)
        end)
    end
end

Interactions.SetupKeybindListener()
Interactions.SetupCloseButton()
Interactions.SetupReopenButton()

_G.UniversalUtility.Handlers.UpdateJumpSlider = UpdateJumpSlider
_G.UniversalUtility.Handlers.UpdateClickSlider = UpdateClickSlider
_G.UniversalUtility.Handlers.UpdateSpamSlider = UpdateSpamSlider
_G.UniversalUtility.Handlers.UpdateFPSSlider = UpdateFPSSlider
_G.UniversalUtility.Handlers.UpdateAntiAFKStatus = UpdateAntiAFKStatus
_G.UniversalUtility.Handlers.UpdateClickTypeButtons = UpdateClickTypeButtons

return _G.UniversalUtility.Handlers
