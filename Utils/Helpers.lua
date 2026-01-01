local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

_G.UniversalUtility.Helpers = {}
_G.UniversalUtility.ActiveThreads = {}
_G.UniversalUtility.Debounces = {}
_G.UniversalUtility.ButtonStates = {}

_G.UniversalUtility.KeyCodeNames = {}
_G.UniversalUtility.KeyCodeMap = {}

for i = 65, 90 do
    local char = string.char(i)
    _G.UniversalUtility.KeyCodeNames[Enum.KeyCode[char]] = char
    _G.UniversalUtility.KeyCodeMap[char] = Enum.KeyCode[char]
end

local numNames = {"One","Two","Three","Four","Five","Six","Seven","Eight","Nine"}
for i = 0, 9 do
    local keyName = i == 0 and "Zero" or numNames[i]
    _G.UniversalUtility.KeyCodeNames[Enum.KeyCode[keyName]] = tostring(i)
    _G.UniversalUtility.KeyCodeMap[tostring(i)] = Enum.KeyCode[keyName]
end

for i = 1, 12 do
    _G.UniversalUtility.KeyCodeNames[Enum.KeyCode["F" .. i]] = "F" .. i
    _G.UniversalUtility.KeyCodeMap["F" .. i] = Enum.KeyCode["F" .. i]
end

local specialKeys = {
    LeftControl = "Left Ctrl",
    RightControl = "Right Ctrl",
    LeftShift = "Left Shift",
    RightShift = "Right Shift",
    LeftAlt = "Left Alt",
    RightAlt = "Right Alt",
    Tab = "Tab",
    CapsLock = "Caps Lock",
    Space = "Space",
    Return = "Enter",
    Backspace = "Backspace",
    Delete = "Delete",
    Insert = "Insert",
    Home = "Home",
    End = "End",
    PageUp = "Page Up",
    PageDown = "Page Down"
}

for k, v in pairs(specialKeys) do
    _G.UniversalUtility.KeyCodeNames[Enum.KeyCode[k]] = v
end

function _G.UniversalUtility.Helpers.CreateButton(parent, size, text)
    local TweenPresets = _G.UniversalUtility.UI.TweenPresets
    local button = Instance.new("TextButton", parent)
    button.Size = size
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Position = UDim2.new(0.5, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 0

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)

    local originalSize = size
    
    _G.UniversalUtility.ButtonStates[button] = {
        OriginalSize = originalSize,
        IsHovering = false,
        BaseColor = Color3.fromRGB(45, 45, 52)
    }

    button.MouseEnter:Connect(function()
        _G.UniversalUtility.ButtonStates[button].IsHovering = true
        local currentColor = button.BackgroundColor3
        _G.UniversalUtility.ButtonStates[button].BaseColor = currentColor
        TweenService:Create(button, TweenPresets.Fast, {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 6, originalSize.Y.Scale, originalSize.Y.Offset + 4)
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        _G.UniversalUtility.ButtonStates[button].IsHovering = false
        local baseColor = _G.UniversalUtility.ButtonStates[button].BaseColor
        TweenService:Create(button, TweenPresets.Fast, {
            Size = originalSize,
            BackgroundColor3 = baseColor
        }):Play()
    end)

    button.MouseButton1Down:Connect(function()
        if _G.UniversalUtility.ButtonStates[button].IsHovering then
            TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 4, originalSize.Y.Scale, originalSize.Y.Offset - 3)
            }):Play()
        end
    end)

    button.MouseButton1Up:Connect(function()
        if _G.UniversalUtility.ButtonStates[button].IsHovering then
            TweenService:Create(button, TweenPresets.Fast, {
                Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 6, originalSize.Y.Scale, originalSize.Y.Offset + 4)
            }):Play()
        else
            TweenService:Create(button, TweenPresets.Fast, {
                Size = originalSize
            }):Play()
        end
    end)

    return button
end

function _G.UniversalUtility.Helpers.CreateSlider(parent, size, minValue, maxValue, currentValue, labelText)
    local TweenPresets = _G.UniversalUtility.UI.TweenPresets
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = size
    sliderFrame.BackgroundTransparency = 1

    local valueLabel = Instance.new("TextLabel", sliderFrame)
    valueLabel.Size = UDim2.new(1, 0, 0, 18)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = labelText
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 12
    valueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left

    local slider = Instance.new("Frame", sliderFrame)
    slider.Size = UDim2.new(1, -60, 0, 6)
    slider.Position = UDim2.new(0, 0, 0, 22)
    slider.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    slider.BorderSizePixel = 0

    local sliderCorner = Instance.new("UICorner", slider)
    sliderCorner.CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame", slider)
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0

    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(0, 3)

    local button = Instance.new("TextButton", slider)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""

    local valueBox = Instance.new("TextBox", sliderFrame)
    valueBox.Size = UDim2.new(0, 50, 0, 24)
    valueBox.Position = UDim2.new(1, -50, 0, 16)
    valueBox.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    valueBox.Text = tostring(currentValue)
    valueBox.Font = Enum.Font.Gotham
    valueBox.TextScaled = true
    valueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueBox.ClearTextOnFocus = false

    local valueCorner = Instance.new("UICorner", valueBox)
    valueCorner.CornerRadius = UDim.new(0, 5)

    return sliderFrame, slider, fill, button, valueBox, valueLabel
end

function _G.UniversalUtility.Helpers.UpdateSlider(fill, valueBox, labelElement, value, min, max, format)
    local TweenPresets = _G.UniversalUtility.UI.TweenPresets
    local percentage = (value - min) / (max - min)
    TweenService:Create(fill, TweenPresets.Fast, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
    valueBox.Text = string.format(format, value)
end

function _G.UniversalUtility.Helpers.UpdateLineNumbers(textBox, lineNumbers, scrollFrame, lineScrollFrame)
    local text = textBox.Text
    local lineCount = 1
    for _ in text:gmatch("\n") do
        lineCount = lineCount + 1
    end
    
    local lineNumberText = ""
    for i = 1, lineCount do
        lineNumberText = lineNumberText .. i .. "\n"
    end
    lineNumbers.Text = lineNumberText
    
    local textBounds = TextService:GetTextSize(
        textBox.Text,
        textBox.TextSize,
        textBox.Font,
        Vector2.new(textBox.AbsoluteSize.X - 10, math.huge)
    )
    local newHeight = math.max(200, textBounds.Y + 20)
    textBox.Size = UDim2.new(1, -10, 0, newHeight)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, newHeight)
    lineScrollFrame.CanvasSize = UDim2.new(0, 0, 0, newHeight)
    lineNumbers.Size = UDim2.new(1, -5, 0, newHeight)
end

function _G.UniversalUtility.Helpers.CreateTabButton(name, icon, position)
    local SideNav = _G.UniversalUtility.UI.SideNav
    local TweenPresets = _G.UniversalUtility.UI.TweenPresets
    local Config = _G.UniversalUtility.Config
    
    local btn = Instance.new("TextButton", SideNav)
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(1, -10, 0, 55)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    local iconLabel = Instance.new("TextLabel", btn)
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 24
    iconLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    iconLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local nameLabel = Instance.new("TextLabel", btn)
    nameLabel.Size = UDim2.new(1, -50, 1, 0)
    nameLabel.Position = UDim2.new(0, 45, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    _G.UniversalUtility.UI.TabButtons[name] = {Button = btn, Icon = iconLabel, Label = nameLabel}
    
    btn.MouseEnter:Connect(function()
        if Config.CurrentTab ~= name then
            TweenService:Create(btn, TweenPresets.Fast, {
                BackgroundColor3 = Color3.fromRGB(45, 45, 52)
            }):Play()
            TweenService:Create(iconLabel, TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
            TweenService:Create(nameLabel, TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if Config.CurrentTab ~= name then
            TweenService:Create(btn, TweenPresets.Fast, {
                BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            }):Play()
            TweenService:Create(iconLabel, TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(180, 180, 180)
            }):Play()
            TweenService:Create(nameLabel, TweenPresets.Fast, {
                TextColor3 = Color3.fromRGB(180, 180, 180)
            }):Play()
        end
    end)
    
    return btn
end

function _G.UniversalUtility.Helpers.CreateTabContent(name)
    local ContentFrame = _G.UniversalUtility.UI.ContentFrame
    local scroll = Instance.new("ScrollingFrame", ContentFrame)
    scroll.Name = name .. "Content"
    scroll.Size = UDim2.new(1, -10, 1, -10)
    scroll.Position = UDim2.new(0, 5, 0, 5)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    scroll.ScrollBarImageTransparency = 0.5
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Visible = false
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    
    _G.UniversalUtility.UI.TabContents[name] = scroll
    return scroll
end

function _G.UniversalUtility.Helpers.CleanupAllThreads()
    for threadType, thread in pairs(_G.UniversalUtility.ActiveThreads) do
        if thread then
            if coroutine.status(thread) ~= "dead" then
                task.cancel(thread)
            end
            _G.UniversalUtility.ActiveThreads[threadType] = nil
        end
    end
end

return _G.UniversalUtility.Helpers
