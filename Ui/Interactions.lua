local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Config = _G.UniversalUtility.Config
local UI = _G.UniversalUtility.UI
local Debounces = _G.UniversalUtility.Debounces

_G.UniversalUtility.Interactions = {}

local AnimationQueue = {}
local IsAnimating = false

local function SetDebounce(key, duration)
    if Debounces[key] then return false end
    Debounces[key] = true
    task.delay(duration or 0.3, function() Debounces[key] = false end)
    return true
end

local function ProcessAnimationQueue()
    if IsAnimating or #AnimationQueue == 0 then return end
    IsAnimating = true
    
    local animation = table.remove(AnimationQueue, 1)
    animation()
    
    task.wait(0.05)
    IsAnimating = false
    
    if #AnimationQueue > 0 then
        ProcessAnimationQueue()
    end
end

local function QueueAnimation(func)
    table.insert(AnimationQueue, func)
    ProcessAnimationQueue()
end

function _G.UniversalUtility.Interactions.ToggleUI()
    if not SetDebounce("UI", 0.6) then return end
    
    QueueAnimation(function()
        if UI.MainFrame.Visible then
            UI.PlayTween(UI.MainFrame, UI.TweenPresets.BackIn, {
                Size = UDim2.new(0, 0, 0, 0)
            })
            task.wait(0.4)
            UI.MainFrame.Visible = false
            _G.UniversalUtility.SaveConfig()
            UI.ReopenButton.Visible = true
            UI.ReopenButton.Size = UDim2.new(0, 0, 0, 0)
            UI.PlayTween(UI.ReopenButton, UI.TweenPresets.Elastic, {
                Size = UDim2.new(0, 60, 0, 60)
            })
        else
            UI.PlayTween(UI.ReopenButton, UI.TweenPresets.BackIn, {
                Size = UDim2.new(0, 0, 0, 0)
            })
            task.wait(0.3)
            UI.ReopenButton.Visible = false
            _G.UniversalUtility.SaveConfig()
            UI.MainFrame.Visible = true
            UI.MainFrame.Size = UDim2.new(0, 0, 0, 0)
            UI.PlayTween(UI.MainFrame, UI.TweenPresets.Elastic, {
                Size = UDim2.new(0, 650, 0, 500)
            })
        end
    end)
end

function _G.UniversalUtility.Interactions.SwitchTab(tabName)
    if Config.CurrentTab == tabName then
        return
    end
    
    if not SetDebounce("Tab", 0.08) then return end
    
    local previousTab = Config.CurrentTab
    Config.CurrentTab = tabName
    _G.UniversalUtility.SaveConfig()
    
    for name, content in pairs(UI.TabContents) do
        if name == tabName then
            content.Visible = true
            content.Position = UDim2.new(0, 15, 0, 0)
            UI.PlayTween(content, UI.TweenPresets.Smooth, {
                Position = UDim2.new(0, 5, 0, 0)
            })
        else
            content.Visible = false
        end
    end
    
    for name, tabData in pairs(UI.TabButtons) do
        local isActive = (name == tabName)
        
        UI.PlayTween(tabData.Button, UI.TweenPresets.Fast, {
            BackgroundColor3 = isActive and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(35, 35, 42)
        })
        UI.PlayTween(tabData.Icon, UI.TweenPresets.Fast, {
            TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180),
            TextSize = isActive and 20 or 18
        })
        UI.PlayTween(tabData.Label, UI.TweenPresets.Fast, {
            TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        })
    end
end

function _G.UniversalUtility.Interactions.SetupKeybindListener()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Config.Keybind and not Config.IsChangingKeybind then
            _G.UniversalUtility.Interactions.ToggleUI()
        end
    end)
end

function _G.UniversalUtility.Interactions.SetupCloseButton()
    UI.CloseButton.MouseButton1Click:Connect(_G.UniversalUtility.Interactions.ToggleUI)
    
    UI.CloseButton.MouseEnter:Connect(function()
        UI.PlayTween(UI.CloseButton, UI.TweenPresets.Fast, {
            BackgroundColor3 = Color3.fromRGB(240, 70, 70),
            Size = UDim2.new(0, 34, 0, 34),
            Rotation = 90
        })
    end)

    UI.CloseButton.MouseLeave:Connect(function()
        UI.PlayTween(UI.CloseButton, UI.TweenPresets.Fast, {
            BackgroundColor3 = Color3.fromRGB(220, 50, 50),
            Size = UDim2.new(0, 30, 0, 30),
            Rotation = 0
        })
    end)

    UI.CloseButton.MouseButton1Down:Connect(function()
        UI.PlayTween(UI.CloseButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 28, 0, 28)
        })
    end)

    UI.CloseButton.MouseButton1Up:Connect(function()
        UI.PlayTween(UI.CloseButton, UI.TweenPresets.Fast, {
            Size = UDim2.new(0, 30, 0, 30)
        })
    end)
end

function _G.UniversalUtility.Interactions.SetupReopenButton()
    UI.ReopenButton.MouseButton1Click:Connect(function()
        if not UI.ReopenDragMoved then
            _G.UniversalUtility.Interactions.ToggleUI()
        end
    end)
    
    local rotationConnection
    UI.ReopenButton.MouseEnter:Connect(function()
        if not UI.ReopenDragToggle then
            UI.PlayTween(UI.ReopenButton, UI.TweenPresets.Medium, {
                Size = UDim2.new(0, 70, 0, 70)
            })
            
            rotationConnection = RunService.RenderStepped:Connect(function(dt)
                UI.ReopenButton.Rotation = (UI.ReopenButton.Rotation + (dt * 180)) % 360
            end)
        end
    end)

    UI.ReopenButton.MouseLeave:Connect(function()
        if rotationConnection then
            rotationConnection:Disconnect()
            rotationConnection = nil
        end
        
        if not UI.ReopenDragToggle then
            UI.PlayTween(UI.ReopenButton, UI.TweenPresets.Medium, {
                Size = UDim2.new(0, 60, 0, 60),
                Rotation = 0
            })
        end
    end)
    
    UI.ReopenButton.MouseButton1Down:Connect(function()
        if not UI.ReopenDragToggle then
            UI.PlayTween(UI.ReopenButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 55, 0, 55)
            })
        end
    end)

    UI.ReopenButton.MouseButton1Up:Connect(function()
        if not UI.ReopenDragToggle then
            UI.PlayTween(UI.ReopenButton, UI.TweenPresets.Fast, {
                Size = UDim2.new(0, 60, 0, 60)
            })
        end
    end)
end

function _G.UniversalUtility.Interactions.AnimateButtonPress(button, scale)
    scale = scale or 0.95
    local originalSize = button.Size
    
    UI.PlayTween(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(originalSize.X.Scale * scale, originalSize.X.Offset * scale, 
                         originalSize.Y.Scale * scale, originalSize.Y.Offset * scale)
    })
    
    task.wait(0.1)
    
    UI.PlayTween(button, UI.TweenPresets.Back, {
        Size = originalSize
    })
end

function _G.UniversalUtility.Interactions.CreateHoverEffect(button, hoverColor, normalColor)
    normalColor = normalColor or button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        UI.PlayTween(button, UI.TweenPresets.Fast, {
            BackgroundColor3 = hoverColor
        })
    end)
    
    button.MouseLeave:Connect(function()
        UI.PlayTween(button, UI.TweenPresets.Fast, {
            BackgroundColor3 = normalColor
        })
    end)
end

return _G.UniversalUtility.Interactions
