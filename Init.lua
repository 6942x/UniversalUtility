local b = game:GetService("HttpService")
local b1 = game:GetService("Players")
local b2 = game:GetService("TweenService")
local b3 = game:GetService("UserInputService")
local b4 = game:GetService("VirtualInputManager")
local b5 = game:GetService("RunService")
local b6 = game:GetService("CoreGui")
local b7 = game:GetService("TeleportService")
local b8 = game:GetService("MarketplaceService")
local b9 = game:GetService("TextService")
local b10 = game:GetService("Stats")

local b11 = b1.LocalPlayer
if not b11 then
    repeat
        b11 = b1.LocalPlayer
        task.wait()
    until b11
end

local b12 = b11.Name
local b13 = b11.UserId
if not b12 or b12 == "" then
    repeat
        b12 = b11.Name
        task.wait()
    until b12 and b12 ~= ""
end

_G.UU = _G.UU or {}

if _G.UU.Loaded then
    if _G.UU.Threads then
        for b14, b15 in pairs(_G.UU.Threads) do
            if b15 and typeof(b15) == "thread" and coroutine.status(b15) ~= "dead" then
                pcall(task.cancel, b15)
            end
            _G.UU.Threads[b14] = nil
        end
    end
    if _G.UU.Connections then
        for b16, b17 in pairs(_G.UU.Connections) do
            pcall(function() b17:Disconnect() end)
        end
        _G.UU.Connections = {}
    end
    if _G.UU.TeleportQueued then
        _G.UU.TeleportQueued = false
    end
    local b18 = b6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
    if b18 then b18:Destroy() end
    _G.UU.Loaded = false
    _G.UU.LoadLock = false
    _G.UU.CFG = nil
    _G.UU.KCN = nil
    _G.UU.KCM = nil
    _G.UU.ButtonStates = nil
    _G.UU.Debounces = nil
    _G.UU.UI = nil
    _G.UU.SaveCFG = nil
elseif _G.UU.LoadLock == true then
    repeat task.wait(0.1) until _G.UU.LoadLock ~= true
    return _G.UU
end

_G.UU.LoadLock = true
_G.UU.Threads = {}
_G.UU.Connections = {}
_G.UU.Debounces = {}
_G.UU.ButtonStates = {}
_G.UU.TeleportQueued = false

local function b19()
    if b3.TouchEnabled and not b3.KeyboardEnabled and not b3.MouseEnabled then
        return "Mobile"
    elseif b3.GamepadEnabled and not b3.KeyboardEnabled then
        return "Console"
    elseif b3.KeyboardEnabled and b3.MouseEnabled then
        return "PC"
    end
    local b20 = b3:GetLastInputType()
    if b20 == Enum.UserInputType.Touch then
        return "Mobile"
    elseif b20 == Enum.UserInputType.Gamepad1 or b20 == Enum.UserInputType.Gamepad2 then
        return "Console"
    end
    return "PC"
end

local b21 = {
    Keybind = Enum.KeyCode.G,
    ClickType = "Current",
    JumpEnabled = false,
    ClickEnabled = false,
    AutoSpamEnabled = false,
    AutoLoadEnabled = false,
    IsChangingKeybind = false,
    FPSUnlockEnabled = false,
    AutoRejoinEnabled = false,
    AutoHideEnabled = false,
    TargetFPS = 60,
    JumpDelay = 10.0,
    ClickDelay = 3.0,
    SpamDelay = 0.1,
    SpamKey = "Q",
    SavedCode = "",
    CurrentTab = "Home",
    UIPosition = { X = 0.5, Y = 0.5 },
    ReopenPosition = { X = 0.5, Y = 30 },
    SavedUIPosition = nil,
    SavedReopenPosition = nil,
}
_G.UU.CFG = b21

local b22 = {}
local b23 = {}

for b24 = 65, 90 do
    local b25 = string.char(b24)
    b22[Enum.KeyCode[b25]] = b25
    b23[b25] = Enum.KeyCode[b25]
end

local b26 = { "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine" }
for b27 = 0, 9 do
    local b28 = b27 == 0 and "Zero" or b26[b27]
    b22[Enum.KeyCode[b28]] = tostring(b27)
    b23[tostring(b27)] = Enum.KeyCode[b28]
end

for b29 = 1, 12 do
    b22[Enum.KeyCode["F" .. b29]] = "F" .. b29
    b23["F" .. b29] = Enum.KeyCode["F" .. b29]
end

local b30 = {
    LeftControl = "Left Ctrl", RightControl = "Right Ctrl",
    LeftShift = "Left Shift", RightShift = "Right Shift",
    LeftAlt = "Left Alt", RightAlt = "Right Alt",
    Tab = "Tab", CapsLock = "Caps Lock",
    Space = "Space", Return = "Enter",
    Backspace = "Backspace", Delete = "Delete",
    Insert = "Insert", Home = "Home",
    End = "End", PageUp = "Page Up",
    PageDown = "Page Down",
}
for b31, b32 in pairs(b30) do
    b22[Enum.KeyCode[b31]] = b32
end

_G.UU.KCN = b22
_G.UU.KCM = b23

local function b33()
    return "UniversalUtilityConfig-" .. b13 .. ".json"
end

local function b34()
    if not writefile then return end
    local b35 = _G.UU.UI and _G.UU.UI.MainFrame
    local b36 = _G.UU.UI and _G.UU.UI.ReopenButton
    if b35 then
        b21.SavedUIPosition = {
            X = b35.Position.X.Offset,
            Y = b35.Position.Y.Offset,
        }
    end
    if b36 then
        b21.SavedReopenPosition = {
            X = b36.Position.X.Offset,
            Y = b36.Position.Y.Offset,
        }
    end
    writefile(b33(), b:JSONEncode({
        UserId = b13,
        Username = b12,
        Keybind = b21.Keybind.Name,
        ClickType = b21.ClickType,
        JumpEnabled = b21.JumpEnabled,
        ClickEnabled = b21.ClickEnabled,
        AutoRejoinEnabled = b21.AutoRejoinEnabled,
        FPSUnlockEnabled = b21.FPSUnlockEnabled,
        AutoSpamEnabled = b21.AutoSpamEnabled,
        AutoLoadEnabled = b21.AutoLoadEnabled,
        AutoHideEnabled = b21.AutoHideEnabled,
        TargetFPS = b21.TargetFPS,
        JumpDelay = b21.JumpDelay,
        ClickDelay = b21.ClickDelay,
        SpamDelay = b21.SpamDelay,
        SpamKey = b21.SpamKey,
        SavedCode = b21.SavedCode,
        CurrentTab = b21.CurrentTab,
        UIPosition = b21.UIPosition,
        ReopenPosition = b21.ReopenPosition,
        SavedUIPosition = b21.SavedUIPosition,
        SavedReopenPosition = b21.SavedReopenPosition,
    }))
end
_G.UU.SaveCFG = b34

local function b37()
    if not (readfile and isfile and isfile(b33())) then return false end
    local b38, b39 = pcall(function() return b:JSONDecode(readfile(b33())) end)
    if not b38 or not b39 or b39.UserId ~= b13 then return false end
    b21.Keybind = Enum.KeyCode[b39.Keybind] or Enum.KeyCode.G
    b21.ClickType = b39.ClickType or "Current"
    b21.JumpEnabled = b39.JumpEnabled or false
    b21.ClickEnabled = b39.ClickEnabled or false
    b21.AutoRejoinEnabled = b39.AutoRejoinEnabled or false
    b21.FPSUnlockEnabled = b39.FPSUnlockEnabled or false
    b21.AutoSpamEnabled = b39.AutoSpamEnabled or false
    b21.AutoLoadEnabled = b39.AutoLoadEnabled or false
    b21.AutoHideEnabled = b39.AutoHideEnabled or false
    b21.TargetFPS = b39.TargetFPS or 60
    b21.JumpDelay = b39.JumpDelay or 10.0
    b21.ClickDelay = b39.ClickDelay or 3.0
    b21.SpamDelay = b39.SpamDelay or 0.1
    b21.SpamKey = b39.SpamKey or "Q"
    b21.SavedCode = b39.SavedCode or ""
    b21.CurrentTab = b39.CurrentTab or "Home"
    b21.UIPosition = b39.UIPosition or { X = 0.5, Y = 0.5 }
    b21.ReopenPosition = b39.ReopenPosition or { X = 0.5, Y = 30 }
    b21.SavedUIPosition = b39.SavedUIPosition or nil
    b21.SavedReopenPosition = b39.SavedReopenPosition or nil
    return true
end

local b40 = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Back = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    BackIn = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    Elastic = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
}

local b41 = {}

local function b42(b43)
    if b41[b43] then
        b41[b43]:Cancel()
        b41[b43] = nil
    end
end

local function b44(b43, b45, b46)
    b42(b43)
    local b47 = b2:Create(b43, b45, b46)
    b41[b43] = b47
    b47:Play()
    b47.Completed:Connect(function(b48)
        if b48 == Enum.TweenStatus.Completed then
            b41[b43] = nil
        end
    end)
    return b47
end

local function b49(b50, b51)
    if _G.UU.Debounces[b50] then return false end
    _G.UU.Debounces[b50] = true
    task.delay(b51 or 0.3, function() _G.UU.Debounces[b50] = false end)
    return true
end

local function b52(b53)
    if _G.UU.Threads[b53] then
        local b54 = _G.UU.Threads[b53]
        _G.UU.Threads[b53] = nil
        if typeof(b54) == "thread" and coroutine.status(b54) ~= "dead" then
            pcall(task.cancel, b54)
        end
    end
end

local function b55()
    return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
end

local b56 = {
    Width = 650, Height = 500,
    SideNavWidth = 180, TopBarHeight = 40,
    FontTitle = 24, FontTab = 13, FontIcon = 24,
    TabButtonHeight = 55, TabButtonGap = 60,
}

local b57 = nil
local b58 = 1

local function b59(b60)
    local b61 = math.min(b60.X / 1920, b60.Y / 1080)
    b61 = math.clamp(b61, 0.75, 1.4)
    return b61
end

local function b62(b63, b64)
    local b65 = Instance.new("UICorner", b63)
    b65.CornerRadius = UDim.new(0, b64 or 8)
    return b65
end

local function b66(b63, b67, b68, b69)
    local b70 = Instance.new("UIGradient", b63)
    b70.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, b67),
        ColorSequenceKeypoint.new(1, b68),
    }
    b70.Rotation = b69 or 90
    return b70
end

local function b71(b63, b72, b73)
    local b74 = Instance.new("TextButton", b63)
    b74.Size = b72
    b74.AnchorPoint = Vector2.new(0.5, 0)
    b74.Position = UDim2.new(0.5, 0, 0, 0)
    b74.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b74.Text = b73
    b74.Font = Enum.Font.GothamBold
    b74.TextSize = 13
    b74.TextColor3 = Color3.fromRGB(255, 255, 255)
    b74.BorderSizePixel = 0
    b74.AutoButtonColor = false
    b62(b74, 8)
    _G.UU.ButtonStates[b74] = { OriginalSize = b72, IsHovering = false, BaseColor = Color3.fromRGB(45, 45, 52) }
    b74.MouseEnter:Connect(function()
        _G.UU.ButtonStates[b74].IsHovering = true
        b2:Create(b74, b40.Fast, { Size = UDim2.new(b72.X.Scale, b72.X.Offset + 6, b72.Y.Scale, b72.Y.Offset + 4) }):Play()
    end)
    b74.MouseLeave:Connect(function()
        _G.UU.ButtonStates[b74].IsHovering = false
        b2:Create(b74, b40.Fast, { Size = b72, BackgroundColor3 = _G.UU.ButtonStates[b74].BaseColor }):Play()
    end)
    b74.MouseButton1Down:Connect(function()
        if _G.UU.ButtonStates[b74].IsHovering then
            b2:Create(b74, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(b72.X.Scale, b72.X.Offset - 4, b72.Y.Scale, b72.Y.Offset - 3)
            }):Play()
        end
    end)
    b74.MouseButton1Up:Connect(function()
        if _G.UU.ButtonStates[b74].IsHovering then
            b2:Create(b74, b40.Fast, { Size = UDim2.new(b72.X.Scale, b72.X.Offset + 6, b72.Y.Scale, b72.Y.Offset + 4) }):Play()
        else
            b2:Create(b74, b40.Fast, { Size = b72 }):Play()
        end
    end)
    return b74
end

local function b75(b63, b72, b76, b77, b78, b79)
    local b80 = Instance.new("Frame", b63)
    b80.Size = b72
    b80.BackgroundTransparency = 1

    local b81 = Instance.new("TextLabel", b80)
    b81.Size = UDim2.new(1, 0, 0, 18)
    b81.BackgroundTransparency = 1
    b81.Text = b79
    b81.Font = Enum.Font.Gotham
    b81.TextSize = 12
    b81.TextColor3 = Color3.fromRGB(180, 180, 180)
    b81.TextXAlignment = Enum.TextXAlignment.Left

    local b82 = Instance.new("Frame", b80)
    b82.Size = UDim2.new(1, -60, 0, 6)
    b82.Position = UDim2.new(0, 0, 0, 22)
    b82.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b82.BorderSizePixel = 0
    b62(b82, 3)

    local b83 = Instance.new("Frame", b82)
    b83.Size = UDim2.new((b78 - b76) / (b77 - b76), 0, 1, 0)
    b83.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    b83.BorderSizePixel = 0
    b62(b83, 3)

    local b84 = Instance.new("TextButton", b82)
    b84.Size = UDim2.new(1, 0, 1, 0)
    b84.BackgroundTransparency = 1
    b84.Text = ""

    local b85 = Instance.new("TextBox", b80)
    b85.Size = UDim2.new(0, 50, 0, 24)
    b85.Position = UDim2.new(1, -50, 0, 16)
    b85.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b85.Text = tostring(b78)
    b85.Font = Enum.Font.Gotham
    b85.TextScaled = true
    b85.TextColor3 = Color3.fromRGB(255, 255, 255)
    b85.ClearTextOnFocus = false
    b85.BorderSizePixel = 0
    b62(b85, 5)

    return b80, b82, b83, b84, b85
end

local function b86(b83, b85, b87, b76, b77, b88)
    local b89 = (b87 - b76) / (b77 - b76)
    b2:Create(b83, b40.Fast, { Size = UDim2.new(b89, 0, 1, 0) }):Play()
    b85.Text = string.format(b88, b87)
end

local function b90(b74, b91)
    b91 = b91 or 0.95
    local b92 = b74.Size
    b44(b74, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(b92.X.Scale * b91, b92.X.Offset * b91, b92.Y.Scale * b91, b92.Y.Offset * b91)
    })
    task.wait(0.1)
    b44(b74, b40.Back, { Size = b92 })
end

local function b93(b94, b95, b96, b97)
    local b98 = b94.Text
    local b99 = 1
    for b100 in b98:gmatch("\n") do b99 = b99 + 1 end
    local b101 = ""
    for b102 = 1, b99 do b101 = b101 .. b102 .. "\n" end
    b95.Text = b101
    local b103 = b9:GetTextSize(b94.Text, b94.TextSize, b94.Font, Vector2.new(b94.AbsoluteSize.X - 10, math.huge))
    local b104 = math.max(200, b103.Y + 20)
    b94.Size = UDim2.new(1, -10, 0, b104)
    b96.CanvasSize = UDim2.new(0, 0, 0, b104)
    b97.CanvasSize = UDim2.new(0, 0, 0, b104)
    b95.Size = UDim2.new(1, -5, 0, b104)
end

local function b105(b63, b106)
    local b107, b108, b109, b110 = false, nil, nil, nil
    b63.InputBegan:Connect(function(b111)
        if b111.UserInputType == Enum.UserInputType.MouseButton1 or b111.UserInputType == Enum.UserInputType.Touch then
            b107 = true
            b108 = b111.Position
            b109 = b63.Position
            if b110 then b110:Disconnect() end
            b110 = b3.InputChanged:Connect(function(b112)
                if (b112.UserInputType == Enum.UserInputType.MouseMovement or b112.UserInputType == Enum.UserInputType.Touch) and b107 then
                    local b113 = b112.Position - b108
                    b63.Position = UDim2.new(b109.X.Scale, b109.X.Offset + b113.X, b109.Y.Scale, b109.Y.Offset + b113.Y)
                end
            end)
            b111.Changed:Connect(function()
                if b111.UserInputState == Enum.UserInputState.End then
                    b107 = false
                    if b110 then b110:Disconnect() b110 = nil end
                    if b106 then b106() end
                end
            end)
        end
    end)
end

local function b114(b63, b72, b115, b73)
    local b116 = Instance.new("Frame", b63)
    b116.Size = b72
    b116.Position = b115
    b116.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b116.BorderSizePixel = 0
    b62(b116, 8)
    Instance.new("UIStroke", b116).Color = Color3.fromRGB(50, 50, 60)
    local b117 = Instance.new("TextLabel", b116)
    b117.Size = UDim2.new(1, -10, 1, -10)
    b117.Position = UDim2.new(0, 5, 0, 5)
    b117.BackgroundTransparency = 1
    b117.Text = b73
    b117.Font = Enum.Font.GothamBold
    b117.TextSize = 14
    b117.TextColor3 = Color3.fromRGB(180, 180, 180)
    b117.TextXAlignment = Enum.TextXAlignment.Center
    b117.TextWrapped = true
    b117.TextYAlignment = Enum.TextYAlignment.Top
    return b116, b117
end

local function b118(b63, b119)
    local b120 = Instance.new("Frame", b63)
    b120.Size = UDim2.new(1, -20, 0, 1)
    b120.Position = UDim2.new(0, 10, 0, b119)
    b120.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b120.BorderSizePixel = 0
    return b120
end

local function b121(b63, b73, b119, b122)
    local b123 = Instance.new("TextLabel", b63)
    b123.Size = UDim2.new(1, -20, 0, 20)
    b123.Position = UDim2.new(0, 10, 0, b119)
    b123.BackgroundTransparency = 1
    b123.Text = b73
    b123.Font = Enum.Font.GothamBold
    b123.TextSize = 13
    b123.TextColor3 = b122 or Color3.fromRGB(200, 200, 200)
    b123.TextXAlignment = Enum.TextXAlignment.Left
    return b123
end

local function b124(b63, b125, b126)
    local b127 = Instance.new("Frame", b63)
    b127.Size = UDim2.new(1, 0, 0, b125)
    b127.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    b127.BorderSizePixel = 0
    b127.LayoutOrder = b126 or 1
    b62(b127, 10)
    b66(b127, Color3.fromRGB(35, 35, 42), Color3.fromRGB(40, 40, 47), 90)
    return b127
end

local b128 = b6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
if b128 then b128:Destroy() end

local b129 = Instance.new("ScreenGui")
b129.Name = "UniversalUtility"
b129.ResetOnSpawn = false
b129.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then
    syn.protect_gui(b129)
    b129.Parent = b6
elseif gethui then
    b129.Parent = gethui()
else
    b129.Parent = b6
end

local b130 = Instance.new("Frame", b129)
b130.Name = "MainFrame"
b130.Size = UDim2.new(0, 0, 0, 0)
b130.Position = UDim2.new(0.5, 0, 0.5, 0)
b130.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
b130.BorderSizePixel = 0
b130.Active = true
b130.ClipsDescendants = true
b130.Visible = false
b62(b130, 16)

b105(b130, b34)

b57 = Instance.new("UIScale", b130)
b57.Scale = 1

local b131 = Instance.new("ImageLabel", b130)
b131.BackgroundTransparency = 1
b131.Position = UDim2.new(0, -15, 0, -15)
b131.Size = UDim2.new(1, 30, 1, 30)
b131.ZIndex = 0
b131.Image = "rbxassetid://6014261993"
b131.ImageColor3 = Color3.fromRGB(0, 0, 0)
b131.ImageTransparency = 0.5
b131.ScaleType = Enum.ScaleType.Slice
b131.SliceCenter = Rect.new(49, 49, 450, 450)

local b132 = Instance.new("Frame", b130)
b132.Size = UDim2.new(1, 0, 0, 40)
b132.Position = UDim2.new(0, 0, 0, 5)
b132.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
b132.BorderSizePixel = 0
b62(b132, 16)
b66(b132, Color3.fromRGB(35, 35, 42), Color3.fromRGB(30, 30, 37), 90)

local b133 = Instance.new("TextLabel", b132)
b133.Size = UDim2.new(1, -80, 1, 0)
b133.Position = UDim2.new(0, 15, 0, 0)
b133.BackgroundTransparency = 1
b133.Text = "⚡ Universal Utility"
b133.Font = Enum.Font.GothamBold
b133.TextSize = 24
b133.TextColor3 = Color3.fromRGB(255, 255, 255)
b133.TextXAlignment = Enum.TextXAlignment.Left

local b134 = Instance.new("ImageButton", b132)
b134.Size = UDim2.new(0, 30, 0, 30)
b134.Position = UDim2.new(1, -12.5, 0.5, 0)
b134.AnchorPoint = Vector2.new(1, 0.5)
b134.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
b134.BorderSizePixel = 0
b134.Image = "rbxassetid://3926305904"
b134.ImageRectOffset = Vector2.new(284, 4)
b134.ImageRectSize = Vector2.new(24, 24)
b134.ImageColor3 = Color3.fromRGB(255, 255, 255)
b62(b134, 8)

local b135 = Instance.new("Frame", b130)
b135.Size = UDim2.new(0, 180, 1, -57)
b135.Position = UDim2.new(0, 2.5, 0, 50)
b135.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
b135.BorderSizePixel = 0
b62(b135, 12)
b66(b135, Color3.fromRGB(30, 30, 35), Color3.fromRGB(25, 25, 30), 90)

local b136 = Instance.new("Frame", b130)
b136.Size = UDim2.new(1, -180, 1, -40)
b136.Position = UDim2.new(0, 180, 0, 50)
b136.BackgroundTransparency = 1
b136.BorderSizePixel = 0
b136.ClipsDescendants = true

local b137 = Instance.new("ImageButton", b129)
b137.Name = "ReopenButton"
b137.Size = UDim2.new(0, 0, 0, 0)
b137.Position = UDim2.new(0.5, 0, 0, 30)
b137.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
b137.BorderSizePixel = 0
b137.Visible = false
b137.ZIndex = 10
b137.Active = true
b137.ImageTransparency = 1
b62(b137, 100)
b66(b137, Color3.fromRGB(100, 150, 255), Color3.fromRGB(80, 130, 235), 45)

local b138 = Instance.new("TextLabel", b137)
b138.Size = UDim2.new(1, 0, 1, 0)
b138.BackgroundTransparency = 1
b138.Text = "⚡"
b138.Font = Enum.Font.GothamBold
b138.TextSize = 24
b138.TextColor3 = Color3.fromRGB(255, 255, 255)
b138.TextTransparency = 1

local b139, b140, b141, b142, b143 = false, nil, nil, nil, false
local b144 = nil

b137.InputBegan:Connect(function(b145)
    if b145.UserInputType == Enum.UserInputType.MouseButton1 or b145.UserInputType == Enum.UserInputType.Touch then
        b139 = true
        b143 = false
        b140 = b145.Position
        b141 = b137.Position
        if b142 then b142:Disconnect() end
        b142 = b3.InputChanged:Connect(function(b146)
            if (b146.UserInputType == Enum.UserInputType.MouseMovement or b146.UserInputType == Enum.UserInputType.Touch) and b139 then
                local b147 = b146.Position - b140
                if math.abs(b147.X) > 5 or math.abs(b147.Y) > 5 then b143 = true end
                b137.Position = UDim2.new(b141.X.Scale, b141.X.Offset + b147.X, 0, b141.Y.Offset + b147.Y)
            end
        end)
        b145.Changed:Connect(function()
            if b145.UserInputState == Enum.UserInputState.End then
                b139 = false
                if b142 then b142:Disconnect() b142 = nil end
                task.wait(0.1)
                if b143 then b34() end
                b143 = false
            end
        end)
    end
end)

local b148 = {}
local b149 = {}
local b150 = {}

_G.UU.UI = {
    ScreenGui = b129,
    MainFrame = b130,
    ContentFrame = b136,
    SideNav = b135,
    CloseButton = b134,
    ReopenButton = b137,
    TabButtons = b148,
    TabContents = b149,
    TweenPresets = b40,
    ActiveTweens = b41,
    PlayTween = b44,
    CancelTween = b42,
    UIScale = b57,
    AllFrames = b150,
}

local function b151(b152, b153, b154)
    local b155 = Instance.new("TextButton", b135)
    b155.Name = b152 .. "Tab"
    b155.Size = UDim2.new(1, -10, 0, 55)
    b155.Position = UDim2.new(0, 5, 0, 5 + ((b154 - 1) * 60))
    b155.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    b155.BorderSizePixel = 0
    b155.Text = ""
    b155.AutoButtonColor = false
    b62(b155, 8)

    local b156 = Instance.new("TextLabel", b155)
    b156.Size = UDim2.new(0, 30, 1, 0)
    b156.Position = UDim2.new(0, 10, 0, 0)
    b156.BackgroundTransparency = 1
    b156.Text = b153
    b156.Font = Enum.Font.GothamBold
    b156.TextSize = 24
    b156.TextColor3 = Color3.fromRGB(180, 180, 180)
    b156.TextXAlignment = Enum.TextXAlignment.Left

    local b157 = Instance.new("TextLabel", b155)
    b157.Size = UDim2.new(1, -50, 1, 0)
    b157.Position = UDim2.new(0, 45, 0, 0)
    b157.BackgroundTransparency = 1
    b157.Text = b152
    b157.Font = Enum.Font.GothamBold
    b157.TextSize = 13
    b157.TextColor3 = Color3.fromRGB(180, 180, 180)
    b157.TextXAlignment = Enum.TextXAlignment.Left

    b148[b152] = { Button = b155, Icon = b156, Label = b157 }
    b150["Tab_" .. b152] = b155

    b155.MouseEnter:Connect(function()
        if b21.CurrentTab ~= b152 then
            b44(b155, b40.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52) })
            b44(b156, b40.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200) })
            b44(b157, b40.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200) })
        end
    end)
    b155.MouseLeave:Connect(function()
        if b21.CurrentTab ~= b152 then
            b44(b155, b40.Fast, { BackgroundColor3 = Color3.fromRGB(35, 35, 42) })
            b44(b156, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
            b44(b157, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        end
    end)
    return b155
end

local function b158(b152)
    local b159 = Instance.new("ScrollingFrame", b136)
    b159.Name = b152 .. "Content"
    b159.Size = UDim2.new(1, -10, 1, -10)
    b159.Position = UDim2.new(0, 5, 0, 5)
    b159.BackgroundTransparency = 1
    b159.BorderSizePixel = 0
    b159.ScrollBarThickness = 4
    b159.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    b159.ScrollBarImageTransparency = 0.5
    b159.CanvasSize = UDim2.new(0, 0, 0, 0)
    b159.Visible = false
    b159.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local b160 = Instance.new("UIListLayout", b159)
    b160.SortOrder = Enum.SortOrder.LayoutOrder
    b160.Padding = UDim.new(0, 10)
    b149[b152] = b159
    b150["Content_" .. b152] = b159
    return b159
end

local b161 = {
    { name = "Home",               icon = "🏠", order = 1 },
    { name = "Anti-AFK",           icon = "⚡", order = 2 },
    { name = "KeySpam",            icon = "⌨️", order = 3 },
    { name = "Performance Status", icon = "📊", order = 4 },
    { name = "Auto Rejoin",        icon = "🔄", order = 5 },
    { name = "Script Loader",      icon = "💾", order = 6 },
    { name = "Settings",           icon = "⚙️", order = 7 },
}

for b162, b163 in ipairs(b161) do
    b151(b163.name, b163.icon, b163.order)
    b158(b163.name)
end

local b164, b165, b166 = {}, {}, {}
local b167, b168, b169, b170 = {}, {}, {}, {}

do
    local b171 = b149["Home"]
    local b172 = b124(b171, 200, 1)
    b150["Home_Card1"] = b172

    local b173 = Instance.new("ImageLabel", b172)
    b173.Size = UDim2.new(0, 120, 0, 140)
    b173.Position = UDim2.new(0, 10, 0, 10)
    b173.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b173.BorderSizePixel = 0
    b173.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    b62(b173, 10)
    Instance.new("UIStroke", b173).Color = Color3.fromRGB(100, 150, 255)

    local b174 = Instance.new("TextLabel", b172)
    b174.Size = UDim2.new(1, -145, 0, 22)
    b174.Position = UDim2.new(0, 140, 0, 10)
    b174.BackgroundTransparency = 1
    b174.Text = b12
    b174.Font = Enum.Font.GothamBold
    b174.TextSize = 28
    b174.TextColor3 = Color3.fromRGB(255, 255, 255)
    b174.TextXAlignment = Enum.TextXAlignment.Left

    local b175 = Instance.new("TextLabel", b172)
    b175.Size = UDim2.new(1, -145, 0, 16)
    b175.Position = UDim2.new(0, 140, 0, 33)
    b175.BackgroundTransparency = 1
    b175.Text = "User ID: " .. b13
    b175.Font = Enum.Font.Gotham
    b175.TextSize = 12
    b175.TextColor3 = Color3.fromRGB(150, 150, 150)
    b175.TextXAlignment = Enum.TextXAlignment.Left

    local b176 = Instance.new("TextLabel", b172)
    b176.Size = UDim2.new(1, -145, 0, 18)
    b176.Position = UDim2.new(0, 140, 0, 55)
    b176.BackgroundTransparency = 1
    b176.Text = "FPS: 60"
    b176.Font = Enum.Font.Gotham
    b176.TextSize = 16
    b176.TextColor3 = Color3.fromRGB(100, 200, 255)
    b176.TextXAlignment = Enum.TextXAlignment.Left

    local b177 = Instance.new("TextLabel", b172)
    b177.Size = UDim2.new(1, -145, 0, 18)
    b177.Position = UDim2.new(0, 140, 0, 70)
    b177.BackgroundTransparency = 1
    b177.Text = "Ping: 0 ms"
    b177.Font = Enum.Font.Gotham
    b177.TextSize = 16
    b177.TextColor3 = Color3.fromRGB(0, 255, 0)
    b177.TextXAlignment = Enum.TextXAlignment.Left

    local b178 = Instance.new("TextLabel", b172)
    b178.Size = UDim2.new(1, -145, 0, 18)
    b178.Position = UDim2.new(0, 140, 0, 90)
    b178.BackgroundTransparency = 1
    b178.Text = "Memory: 0 MB"
    b178.Font = Enum.Font.Gotham
    b178.TextSize = 16
    b178.TextColor3 = Color3.fromRGB(255, 180, 100)
    b178.TextXAlignment = Enum.TextXAlignment.Left

    local b179, b180 = "Unknown", "N/A"
    if identifyexecutor then
        b179, b180 = identifyexecutor()
    elseif getexecutorname then
        b179 = getexecutorname()
    end

    local b181 = Instance.new("TextLabel", b172)
    b181.Size = UDim2.new(1, -145, 0, 18)
    b181.Position = UDim2.new(0, 140, 0, 105)
    b181.BackgroundTransparency = 1
    b181.Text = "Executor: " .. b179 .. " " .. b180
    b181.Font = Enum.Font.Gotham
    b181.TextSize = 16
    b181.TextColor3 = Color3.fromRGB(255, 100, 200)
    b181.TextXAlignment = Enum.TextXAlignment.Left

    local b182 = Instance.new("TextLabel", b172)
    b182.Size = UDim2.new(1, -145, 0, 18)
    b182.Position = UDim2.new(0, 140, 0, 125)
    b182.BackgroundTransparency = 1
    b182.Text = "Device: " .. b19()
    b182.Font = Enum.Font.Gotham
    b182.TextSize = 16
    b182.TextColor3 = Color3.fromRGB(180, 255, 150)
    b182.TextXAlignment = Enum.TextXAlignment.Left

    local b183 = b55()
    local b184 = Instance.new("TextLabel", b172)
    b184.Size = UDim2.new(1, -145, 0, 18)
    b184.Position = UDim2.new(0, 140, 0, 137.5)
    b184.BackgroundTransparency = 1
    b184.Text = string.format("Resolution: %dx%d", b183.X, b183.Y)
    b184.Font = Enum.Font.Gotham
    b184.TextSize = 12
    b184.TextColor3 = Color3.fromRGB(150, 150, 150)
    b184.TextXAlignment = Enum.TextXAlignment.Left

    local b185 = b124(b171, 220, 2)
    b150["Home_Card2"] = b185

    local b186 = Instance.new("ImageLabel", b185)
    b186.Size = UDim2.new(0, 120, 0, 140)
    b186.Position = UDim2.new(0, 10, 0, 10)
    b186.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b186.BorderSizePixel = 0
    b186.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    b62(b186, 10)
    Instance.new("UIStroke", b186).Color = Color3.fromRGB(100, 150, 255)

    local b187 = Instance.new("TextLabel", b185)
    b187.Size = UDim2.new(1, -145, 0, 24)
    b187.Position = UDim2.new(0, 140, 0, 10)
    b187.BackgroundTransparency = 1
    b187.Text = "Loading game info..."
    b187.Font = Enum.Font.GothamBold
    b187.TextSize = 24
    b187.TextColor3 = Color3.fromRGB(255, 255, 255)
    b187.TextXAlignment = Enum.TextXAlignment.Left
    b187.TextWrapped = true

    local b188 = Instance.new("TextLabel", b185)
    b188.Size = UDim2.new(1, -145, 0, 18)
    b188.Position = UDim2.new(0, 140, 0, 50)
    b188.BackgroundTransparency = 1
    b188.Text = "Place ID: " .. game.PlaceId
    b188.Font = Enum.Font.Gotham
    b188.TextSize = 20
    b188.TextColor3 = Color3.fromRGB(150, 180, 255)
    b188.TextXAlignment = Enum.TextXAlignment.Left

    local b189 = Instance.new("TextLabel", b185)
    b189.Size = UDim2.new(1, -145, 0, 18)
    b189.Position = UDim2.new(0, 140, 0, 90)
    b189.BackgroundTransparency = 1
    b189.Text = "Players Connected: " .. #b1:GetPlayers()
    b189.Font = Enum.Font.Gotham
    b189.TextSize = 20
    b189.TextColor3 = Color3.fromRGB(150, 255, 180)
    b189.TextXAlignment = Enum.TextXAlignment.Left

    local b190 = Instance.new("TextLabel", b185)
    b190.Size = UDim2.new(1, -145, 0, 18)
    b190.Position = UDim2.new(0, 140, 0, 130)
    b190.BackgroundTransparency = 1
    b190.Text = "Server JobId: " .. game.JobId
    b190.Font = Enum.Font.Gotham
    b190.TextSize = 12
    b190.TextColor3 = Color3.fromRGB(255, 180, 180)
    b190.TextXAlignment = Enum.TextXAlignment.Left

    local function b191()
        b189.Text = "Players Connected: " .. #b1:GetPlayers()
    end
    table.insert(_G.UU.Connections, b1.PlayerAdded:Connect(b191))
    table.insert(_G.UU.Connections, b1.PlayerRemoving:Connect(b191))

    _G.UU.UI.PlayerImage = b173
    _G.UU.UI.GameName = b187
    _G.UU.UI.GameImage = b186
    _G.UU.UI.ResolutionLabel = b184
    _G.UU.UI.DeviceLabel = b182
    b164.FPSLabel = b176
    b164.PingLabel = b177
    b164.MemoryLabel = b178
end

do
    local b189 = b149["Anti-AFK"]
    local b190 = b124(b189, 400, 1)
    b150["AntiAFK_Card"] = b190

    local b191 = Instance.new("TextLabel", b190)
    b191.Size = UDim2.new(1, -20, 0, 26); b191.Position = UDim2.new(0, 10, 0, 8)
    b191.BackgroundTransparency = 1; b191.Text = "⚡ Anti-AFK System"
    b191.Font = Enum.Font.GothamBold; b191.TextSize = 18
    b191.TextColor3 = Color3.fromRGB(100, 200, 255); b191.TextXAlignment = Enum.TextXAlignment.Left

    local b192 = Instance.new("TextLabel", b190)
    b192.Size = UDim2.new(1, -20, 0, 16); b192.Position = UDim2.new(0, 10, 0, 34)
    b192.BackgroundTransparency = 1; b192.Text = "Prevent disconnections by simulating player activity"
    b192.Font = Enum.Font.Gotham; b192.TextSize = 12
    b192.TextColor3 = Color3.fromRGB(150, 150, 150); b192.TextXAlignment = Enum.TextXAlignment.Left

    local b193 = b71(b190, UDim2.new(0, 140, 0, 36), "Auto Jump: OFF")
    b193.Position = UDim2.new(0.25, 0, 0, 65)
    local b194 = b71(b190, UDim2.new(0, 140, 0, 36), "Auto Click: OFF")
    b194.Position = UDim2.new(0.75, 0, 0, 65)

    b118(b190, 115)
    b121(b190, "Click Position Mode", 127)

    local b195 = b71(b190, UDim2.new(0, 85, 0, 30), "Current")
    b195.Position = UDim2.new(0.2, 0, 0, 155)
    local b196 = b71(b190, UDim2.new(0, 85, 0, 30), "Center")
    b196.Position = UDim2.new(0.5, 0, 0, 155)
    local b197 = b71(b190, UDim2.new(0, 85, 0, 30), "Random")
    b197.Position = UDim2.new(0.8, 0, 0, 155)

    b118(b190, 198)

    local b198, b199, b200, b201, b202 = b75(b190, UDim2.new(1, -20, 0, 50), 5, 30, 10, "Jump Interval (seconds)")
    b198.Position = UDim2.new(0, 10, 0, 213)
    local b203, b204, b205, b206, b207 = b75(b190, UDim2.new(1, -20, 0, 50), 1, 10, 3, "Click Interval (seconds)")
    b203.Position = UDim2.new(0, 10, 0, 280)

    local b208, b209 = b114(b190, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 345), "Status: All Inactive")

    b165 = {
        JumpToggle = b193,
        ClickToggle = b194,
        ClickTypeCurrent = b195,
        ClickTypeCenter = b196,
        ClickTypeRandom = b197,
        JumpDelaySlider = b199,
        JumpSliderFill = b200,
        JumpSliderButton = b201,
        JumpDelayBox = b202,
        ClickDelaySlider = b204,
        ClickSliderFill = b205,
        ClickSliderButton = b206,
        ClickDelayBox = b207,
        Status = b209,
    }
end

do
    local b210 = b149["KeySpam"]
    local b211 = b124(b210, 320, 1)
    b150["KeySpam_Card"] = b211

    local b212 = Instance.new("TextLabel", b211)
    b212.Size = UDim2.new(1, -20, 0, 26); b212.Position = UDim2.new(0, 10, 0, 8)
    b212.BackgroundTransparency = 1; b212.Text = "⌨️ Key Spam Controller"
    b212.Font = Enum.Font.GothamBold; b212.TextSize = 18
    b212.TextColor3 = Color3.fromRGB(255, 200, 100); b212.TextXAlignment = Enum.TextXAlignment.Left

    local b213 = Instance.new("TextLabel", b211)
    b213.Size = UDim2.new(1, -20, 0, 16); b213.Position = UDim2.new(0, 10, 0, 34)
    b213.BackgroundTransparency = 1; b213.Text = "Automatically spam any keyboard key at custom intervals"
    b213.Font = Enum.Font.Gotham; b213.TextSize = 12
    b213.TextColor3 = Color3.fromRGB(150, 150, 150); b213.TextXAlignment = Enum.TextXAlignment.Left

    b121(b211, "Target Key", 60)

    local b214 = Instance.new("TextBox", b211)
    b214.Size = UDim2.new(1, -20, 0, 40)
    b214.Position = UDim2.new(0, 10, 0, 82)
    b214.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b214.Text = b21.SpamKey
    b214.PlaceholderText = "Enter key (A-Z, 0-9, F1-F12)"
    b214.Font = Enum.Font.Gotham
    b214.TextSize = 14
    b214.TextColor3 = Color3.fromRGB(255, 255, 255)
    b214.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    b214.BorderSizePixel = 0
    b214.ClearTextOnFocus = false
    b62(b214, 8)
    Instance.new("UIStroke", b214).Color = Color3.fromRGB(60, 60, 70)

    b118(b211, 135)

    local b215, b216, b217, b218, b219 = b75(b211, UDim2.new(1, -20, 0, 50), 0.05, 5, 0.1, "Spam Interval (seconds)")
    b215.Position = UDim2.new(0, 10, 0, 150)

    local b220 = b71(b211, UDim2.new(0, 120, 0, 36), "OFF")
    b220.Position = UDim2.new(0.5, 0, 0, 220)

    local b221, b222 = b114(b211, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 265), "System Status: Inactive")

    b166 = {
        SpamInput = b214,
        SpamDelaySlider = b216,
        SpamSliderFill = b217,
        SpamSliderButton = b218,
        SpamDelayBox = b219,
        AutoSpamToggle = b220,
        Status = b222,
    }
end

do
    local b223 = b149["Performance Status"]
    local b224 = b124(b223, 640, 1)
    b150["Performance_Card"] = b224

    local b225 = Instance.new("TextLabel", b224)
    b225.Size = UDim2.new(1, -20, 0, 26); b225.Position = UDim2.new(0, 10, 0, 8)
    b225.BackgroundTransparency = 1; b225.Text = "📊 Performance Monitor"
    b225.Font = Enum.Font.GothamBold; b225.TextSize = 18
    b225.TextColor3 = Color3.fromRGB(100, 255, 150); b225.TextXAlignment = Enum.TextXAlignment.Left

    local b226 = Instance.new("TextLabel", b224)
    b226.Size = UDim2.new(1, -20, 0, 16); b226.Position = UDim2.new(0, 10, 0, 34)
    b226.BackgroundTransparency = 1; b226.Text = "Track real-time performance metrics and unlock FPS limits"
    b226.Font = Enum.Font.Gotham; b226.TextSize = 12
    b226.TextColor3 = Color3.fromRGB(150, 150, 150); b226.TextXAlignment = Enum.TextXAlignment.Left

    local b227 = b71(b224, UDim2.new(0, 160, 0, 36), "FPS Unlock: OFF")
    b227.Position = UDim2.new(0.5, 0, 0, 65)

    local b228 = Instance.new("TextLabel", b224)
    b228.Size = UDim2.new(1, -20, 0, 20)
    b228.Position = UDim2.new(0, 10, 0, 108)
    b228.BackgroundTransparency = 1
    b228.Text = "Current Limit: 60 FPS"
    b228.Font = Enum.Font.Gotham
    b228.TextSize = 13
    b228.TextColor3 = Color3.fromRGB(180, 180, 180)
    b228.TextXAlignment = Enum.TextXAlignment.Center

    local b229, b230, b231, b232, b233 = b75(b224, UDim2.new(1, -20, 0, 50), 15, 360, 60, "Target FPS Limit")
    b229.Position = UDim2.new(0, 10, 0, 140)

    b118(b224, 205)
    b121(b224, "Framerate Statistics", 215)

    local b234 = Instance.new("Frame", b224)
    b234.Size = UDim2.new(1, -20, 0, 50)
    b234.Position = UDim2.new(0, 10, 0, 240)
    b234.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b234.BorderSizePixel = 0
    b62(b234, 8)
    Instance.new("UIStroke", b234).Color = Color3.fromRGB(50, 50, 60)

    local function b235(b236, b237, b238, b239)
        local b240 = Instance.new("TextLabel", b236)
        b240.Size = UDim2.new(b237[3], 0, 1, 0)
        b240.Position = UDim2.new(b237[1], 0, 0, 0)
        b240.BackgroundTransparency = 1
        b240.Text = b238
        b240.Font = Enum.Font.GothamBold
        b240.TextSize = 13
        b240.TextColor3 = b239
        b240.TextXAlignment = Enum.TextXAlignment.Center
        return b240
    end

    local b241 = b235(b234, {0, 0, 0.33}, "Current: 60", Color3.fromRGB(100, 200, 255))
    local b242 = b235(b234, {0.33, 0, 0.33}, "Average: 60", Color3.fromRGB(50, 220, 100))
    local b243 = b235(b234, {0.66, 0, 0.34}, "Min: 60 | Max: 60", Color3.fromRGB(255, 200, 100))

    b118(b224, 305)
    b121(b224, "Network Latency Statistics", 315)

    local b244 = Instance.new("Frame", b224)
    b244.Size = UDim2.new(1, -20, 0, 50)
    b244.Position = UDim2.new(0, 10, 0, 340)
    b244.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b244.BorderSizePixel = 0
    b62(b244, 8)
    Instance.new("UIStroke", b244).Color = Color3.fromRGB(50, 50, 60)

    local b245 = b235(b244, {0, 0, 0.33}, "Current: 0ms", Color3.fromRGB(100, 200, 255))
    local b246 = b235(b244, {0.33, 0, 0.33}, "Average: 0ms", Color3.fromRGB(50, 220, 100))
    local b247 = b235(b244, {0.66, 0, 0.34}, "Min: 0ms | Max: 0ms", Color3.fromRGB(255, 200, 100))

    local b248 = Instance.new("Frame", b224)
    b248.Size = UDim2.new(1, -20, 0, 50)
    b248.Position = UDim2.new(0, 10, 0, 405)
    b248.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b248.BorderSizePixel = 0
    b62(b248, 8)
    Instance.new("UIStroke", b248).Color = Color3.fromRGB(50, 50, 60)

    b235(b248, {0, 0, 0.5}, "Connection Quality", Color3.fromRGB(255, 255, 255))
    local b249 = b235(b248, {0.5, 0, 0.5}, "Excellent", Color3.fromRGB(50, 220, 100))

    b118(b224, 465)
    b121(b224, "Memory Usage Statistics", 475)

    local b250 = Instance.new("Frame", b224)
    b250.Size = UDim2.new(1, -20, 0, 50)
    b250.Position = UDim2.new(0, 10, 0, 500)
    b250.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b250.BorderSizePixel = 0
    b62(b250, 8)
    Instance.new("UIStroke", b250).Color = Color3.fromRGB(50, 50, 60)

    local b251 = b235(b250, {0, 0, 0.5}, "Current: 0 MB", Color3.fromRGB(255, 180, 100))
    local b252 = b235(b250, {0.5, 0, 0.5}, "Peak: 0 MB", Color3.fromRGB(255, 150, 50))

    local b253 = Instance.new("TextLabel", b224)
    b253.Size = UDim2.new(1, -20, 0, 60)
    b253.Position = UDim2.new(0, 10, 0, 560)
    b253.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b253.BorderSizePixel = 0
    b253.Text = "Performance monitoring tracks your game's framerate, network latency, and memory usage in real-time.\n\nLowering FPS limits reduces memory usage. Higher FPS provides smoother gameplay but increases resource consumption."
    b253.Font = Enum.Font.Gotham
    b253.TextSize = 12
    b253.TextColor3 = Color3.fromRGB(200, 180, 150)
    b253.TextWrapped = true
    b253.TextXAlignment = Enum.TextXAlignment.Left
    b253.TextYAlignment = Enum.TextYAlignment.Top
    b62(b253, 8)
    Instance.new("UIStroke", b253).Color = Color3.fromRGB(50, 50, 60)
    local b254 = Instance.new("UIPadding", b253)
    b254.PaddingLeft = UDim.new(0, 10); b254.PaddingRight = UDim.new(0, 10)
    b254.PaddingTop = UDim.new(0, 10); b254.PaddingBottom = UDim.new(0, 10)

    b167 = {
        FPSUnlockToggle = b227,
        FPSUnlockStatus = b228,
        FPSSlider = b230,
        FPSFill = b231,
        FPSButton = b232,
        FPSValueBox = b233,
        FPSStats = { Current = b241, Avg = b242, MinMax = b243 },
        PingStats = { Current = b245, Avg = b246, MinMax = b247, Quality = b249 },
        MemoryStats = { Current = b251, Peak = b252 },
    }
end

do
    local b255 = b149["Auto Rejoin"]
    local b256 = b124(b255, 250, 1)
    b150["AutoRejoin_Card"] = b256

    local b257 = Instance.new("TextLabel", b256)
    b257.Size = UDim2.new(1, -20, 0, 26); b257.Position = UDim2.new(0, 10, 0, 8)
    b257.BackgroundTransparency = 1; b257.Text = "🔄 Auto Rejoin System"
    b257.Font = Enum.Font.GothamBold; b257.TextSize = 18
    b257.TextColor3 = Color3.fromRGB(150, 200, 255); b257.TextXAlignment = Enum.TextXAlignment.Left

    local b258 = Instance.new("TextLabel", b256)
    b258.Size = UDim2.new(1, -20, 0, 16); b258.Position = UDim2.new(0, 10, 0, 34)
    b258.BackgroundTransparency = 1; b258.Text = "Automatically reconnect when disconnected from the server"
    b258.Font = Enum.Font.Gotham; b258.TextSize = 12
    b258.TextColor3 = Color3.fromRGB(150, 150, 150); b258.TextXAlignment = Enum.TextXAlignment.Left

    local b259 = b71(b256, UDim2.new(0, 180, 0, 40), "Auto Rejoin: OFF")
    b259.Position = UDim2.new(0.5, 0, 0, 75)

    local b260, b261 = b114(b256, UDim2.new(1, -20, 0, 105), UDim2.new(0, 10, 0, 135),
        "System Status: Disabled\n\nWhen enabled, this feature will automatically rejoin the current server when you get disconnected due to errors or AFK timeout.")

    b168 = { AutoRejoinToggle = b259, Status = b261 }
end

do
    local b262 = b149["Script Loader"]
    local b263 = b124(b262, 460, 1)
    b150["ScriptLoader_Card"] = b263

    local b264 = Instance.new("TextLabel", b263)
    b264.Size = UDim2.new(1, -20, 0, 26); b264.Position = UDim2.new(0, 10, 0, 8)
    b264.BackgroundTransparency = 1; b264.Text = "💾 Script Executor"
    b264.Font = Enum.Font.GothamBold; b264.TextSize = 18
    b264.TextColor3 = Color3.fromRGB(200, 150, 255); b264.TextXAlignment = Enum.TextXAlignment.Left

    local b265 = Instance.new("TextLabel", b263)
    b265.Size = UDim2.new(1, -20, 0, 16); b265.Position = UDim2.new(0, 10, 0, 34)
    b265.BackgroundTransparency = 1; b265.Text = "Execute custom Lua scripts with auto-save and auto-load capabilities"
    b265.Font = Enum.Font.Gotham; b265.TextSize = 12
    b265.TextColor3 = Color3.fromRGB(150, 150, 150); b265.TextXAlignment = Enum.TextXAlignment.Left

    local b266 = Instance.new("Frame", b263)
    b266.Size = UDim2.new(1, -20, 0, 220)
    b266.Position = UDim2.new(0, 10, 0, 60)
    b266.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b266.BorderSizePixel = 0
    b62(b266, 8)
    Instance.new("UIStroke", b266).Color = Color3.fromRGB(60, 60, 70)

    local b267 = Instance.new("ScrollingFrame", b266)
    b267.Size = UDim2.new(0, 40, 1, 0)
    b267.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    b267.BorderSizePixel = 0
    b267.ScrollBarThickness = 0
    b267.ScrollingEnabled = false
    b267.CanvasSize = UDim2.new(0, 0, 0, 220)
    b62(b267, 8)

    local b268 = Instance.new("TextLabel", b267)
    b268.Size = UDim2.new(1, -5, 1, 0)
    b268.BackgroundTransparency = 1
    b268.Text = "1"
    b268.Font = Enum.Font.Code
    b268.TextSize = 12
    b268.TextColor3 = Color3.fromRGB(120, 120, 120)
    b268.TextXAlignment = Enum.TextXAlignment.Right
    b268.TextYAlignment = Enum.TextYAlignment.Top

    local b269 = Instance.new("Frame", b266)
    b269.Size = UDim2.new(0, 1, 1, 0)
    b269.Position = UDim2.new(0, 40, 0, 0)
    b269.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    b269.BorderSizePixel = 0

    local b270 = Instance.new("ScrollingFrame", b266)
    b270.Size = UDim2.new(1, -41, 1, 0)
    b270.Position = UDim2.new(0, 41, 0, 0)
    b270.BackgroundTransparency = 1
    b270.BorderSizePixel = 0
    b270.ScrollBarThickness = 4
    b270.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    b270.ScrollBarImageTransparency = 0.5
    b270.CanvasSize = UDim2.new(0, 0, 0, 220)

    local b271 = Instance.new("TextBox", b270)
    b271.Size = UDim2.new(1, -10, 1, 0)
    b271.Position = UDim2.new(0, 5, 0, 0)
    b271.BackgroundTransparency = 1
    b271.Text = b21.SavedCode
    b271.PlaceholderText = "-- Paste your Lua code here..."
    b271.Font = Enum.Font.Code
    b271.TextSize = 12
    b271.TextColor3 = Color3.fromRGB(255, 255, 255)
    b271.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    b271.BorderSizePixel = 0
    b271.TextWrapped = true
    b271.TextXAlignment = Enum.TextXAlignment.Left
    b271.TextYAlignment = Enum.TextYAlignment.Top
    b271.MultiLine = true
    b271.ClearTextOnFocus = false
    b271.TextEditable = true

    local b272 = b71(b263, UDim2.new(0, 140, 0, 36), "Execute")
    b272.Position = UDim2.new(0.25, 0, 0, 300)
    local b273 = b71(b263, UDim2.new(0, 140, 0, 36), "Auto Load: OFF")
    b273.Position = UDim2.new(0.75, 0, 0, 300)

    local b274, b275 = b114(b263, UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 350), "System Status: Ready to execute")

    local b276 = Instance.new("TextLabel", b263)
    b276.Size = UDim2.new(1, -20, 0, 60)
    b276.Position = UDim2.new(0, 10, 0, 395)
    b276.BackgroundTransparency = 1
    b276.Text = "Your code is automatically saved while typing. Enable Auto Load to execute your script automatically when rejoining.\n\nChanges are saved in real-time."
    b276.Font = Enum.Font.Gotham
    b276.TextSize = 12
    b276.TextColor3 = Color3.fromRGB(130, 130, 130)
    b276.TextXAlignment = Enum.TextXAlignment.Center
    b276.TextWrapped = true

    b169 = {
        LoadStringBox = b271,
        LineNumbers = b268,
        LoadStringScrollFrame = b270,
        LineNumbersScrollFrame = b267,
        ExecuteButton = b272,
        AutoLoadButton = b273,
        Status = b275,
    }
end

do
    local b277 = b149["Settings"]
    local b278 = b124(b277, 230, 1)
    b150["Settings_Card"] = b278

    local b279 = Instance.new("TextLabel", b278)
    b279.Size = UDim2.new(1, -20, 0, 26); b279.Position = UDim2.new(0, 10, 0, 8)
    b279.BackgroundTransparency = 1; b279.Text = "⚙️ UI Configuration"
    b279.Font = Enum.Font.GothamBold; b279.TextSize = 18
    b279.TextColor3 = Color3.fromRGB(255, 180, 100); b279.TextXAlignment = Enum.TextXAlignment.Left

    local b280 = Instance.new("TextLabel", b278)
    b280.Size = UDim2.new(1, -20, 0, 16); b280.Position = UDim2.new(0, 10, 0, 34)
    b280.BackgroundTransparency = 1; b280.Text = "Customize interface preferences and keybinds"
    b280.Font = Enum.Font.Gotham; b280.TextSize = 11
    b280.TextColor3 = Color3.fromRGB(150, 150, 150); b280.TextXAlignment = Enum.TextXAlignment.Left

    b121(b278, "Toggle Keybind", 60)

    local b281 = b22[b21.Keybind] or b21.Keybind.Name
    local b282 = b71(b278, UDim2.new(0, 220, 0, 40), "Current Key: " .. b281)
    b282.Position = UDim2.new(0.5, 0, 0, 90)

    b118(b278, 140)

    local b283 = b71(b278, UDim2.new(0, 220, 0, 40), "Auto Hide UI: OFF")
    b283.Position = UDim2.new(0.5, 0, 0, 155)

    local b284, b285 = b114(b278, UDim2.new(1, -20, 0, 85), UDim2.new(0, 10, 0, 205),
        "Click the keybind button above to change your toggle keybind.\n\nEnable Auto Hide to start with UI hidden on next execution.")

    b170 = {
        KeybindButton = b282,
        AutoHideToggle = b283,
        Status = b285,
    }
end

local b286 = typeof(setfpscap) == "function"
if b286 then
    local b287 = pcall(setfpscap, 60)
    if not b287 then b286 = false end
end

local b288, b289, b290 = {}, {}, 60
local b291, b292, b293 = tick(), 0, 60
local b294 = 0

for b295 = 1, 60 do
    table.insert(b288, 60)
    table.insert(b289, 0)
end

local function b296()
    local b297 = b165
    if not b297.Status then return end
    local b298, b299
    if b21.JumpEnabled and b21.ClickEnabled then
        b298, b299 = "Status: Jump & Click Active", Color3.fromRGB(50, 220, 100)
    elseif b21.JumpEnabled then
        b298, b299 = "Status: Jump Active", Color3.fromRGB(100, 200, 255)
    elseif b21.ClickEnabled then
        b298, b299 = "Status: Click Active", Color3.fromRGB(255, 200, 100)
    else
        b298, b299 = "Status: All Inactive", Color3.fromRGB(180, 180, 180)
    end
    b44(b297.Status, b40.Fast, { TextColor3 = b299 })
    b297.Status.Text = b298
end

local function b300()
    local b301 = {
        Current = b165.ClickTypeCurrent,
        Center = b165.ClickTypeCenter,
        Random = b165.ClickTypeRandom,
    }
    for b302, b303 in pairs(b301) do
        if b303 then
            local b304 = b21.ClickType == b302 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(45, 45, 52)
            if _G.UU.ButtonStates[b303] then _G.UU.ButtonStates[b303].BaseColor = b304 end
            b44(b303, b40.Fast, { BackgroundColor3 = b304 })
        end
    end
end

local function b305()
    b52("Jump")
    _G.UU.Threads.Jump = task.spawn(function()
        while b21.JumpEnabled do
            task.wait(b21.JumpDelay)
            if b21.JumpEnabled and b11.Character then
                local b306 = b11.Character:FindFirstChildOfClass("Humanoid")
                if b306 then b306:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
        _G.UU.Threads.Jump = nil
    end)
end

local function b307()
    b52("Click")
    _G.UU.Threads.Click = task.spawn(function()
        while b21.ClickEnabled do
            task.wait(b21.ClickDelay)
            if b21.ClickEnabled then
                local b308, b309
                if b21.ClickType == "Current" then
                    local b310 = b3:GetMouseLocation()
                    b308, b309 = b310.X, b310.Y
                elseif b21.ClickType == "Center" then
                    local b311 = workspace.CurrentCamera.ViewportSize
                    b308, b309 = b311.X / 2, b311.Y / 2
                else
                    local b312 = workspace.CurrentCamera.ViewportSize
                    b308, b309 = math.random(100, b312.X - 100), math.random(100, b312.Y - 100)
                end
                b4:SendMouseButtonEvent(b308, b309, 0, true, game, 0)
                task.wait(0.05)
                b4:SendMouseButtonEvent(b308, b309, 0, false, game, 0)
            end
        end
        _G.UU.Threads.Click = nil
    end)
end

local function b313()
    b52("Spam")
    local b314 = b21.SpamKey:upper()
    local b315 = b23[b314]
    if not b315 then return end
    _G.UU.Threads.Spam = task.spawn(function()
        while b21.AutoSpamEnabled do
            task.wait(b21.SpamDelay)
            if b21.AutoSpamEnabled then
                b4:SendKeyEvent(true, b315, false, game)
                task.wait(0.05)
                b4:SendKeyEvent(false, b315, false, game)
            end
        end
        _G.UU.Threads.Spam = nil
    end)
end

local b316 = false
local b317 = nil

local function b318()
    if b317 then
        pcall(function() b317:Disconnect() end)
        b317 = nil
    end
    if not b21.AutoRejoinEnabled then return end
    task.spawn(function()
        local b319 = b6:FindFirstChild("RobloxPromptGui")
        if not b319 then
            local b320, b321 = pcall(function() return b6:WaitForChild("RobloxPromptGui", 10) end)
            if not b320 or not b321 then
                if b168.Status then
                    b168.Status.Text = "Status: Enabled (waiting for prompt GUI...)\n\nAutomatically rejoins the game when disconnected."
                end
                return
            end
            b319 = b321
        end
        local b322 = b319:FindFirstChild("promptOverlay")
        if not b322 then
            local b323, b324 = pcall(function() return b319:WaitForChild("promptOverlay", 10) end)
            if not b323 or not b324 then
                if b168.Status then
                    b168.Status.Text = "Status: Enabled (prompt overlay unavailable)\n\nAutomatically rejoins the game when disconnected."
                end
                return
            end
            b322 = b324
        end
        b317 = b322.ChildAdded:Connect(function(b325)
            if b325.Name == "ErrorPrompt" and b21.AutoRejoinEnabled and not b316 then
                b316 = true
                _G.UU.Threads.Rejoin = task.spawn(function()
                    while b21.AutoRejoinEnabled and b316 do
                        b7:Teleport(game.PlaceId, b11)
                        task.wait(2)
                    end
                    _G.UU.Threads.Rejoin = nil
                end)
            end
        end)
    end)
end

local function b326(b327)
    if not b327 or b327 == "" then return false, "Empty script" end
    local b328, b329 = pcall(function()
        local b330, b331 = loadstring(b327)
        if not b330 then error(b331) end
        b330()
    end)
    if b328 then return true, "Executed successfully!" end
    return false, "Error - " .. tostring(b329):sub(1, 50) .. "..."
end

local b332 = { jump = false, click = false, spam = false, fps = false }

local function b333(b334)
    b21.JumpDelay = 5 + (b334 * 25)
    b86(b165.JumpSliderFill, b165.JumpDelayBox, b21.JumpDelay, 5, 30, "%.1f")
    b34()
end

local function b335(b334)
    b21.ClickDelay = 1 + (b334 * 9)
    b86(b165.ClickSliderFill, b165.ClickDelayBox, b21.ClickDelay, 1, 10, "%.1f")
    b34()
end

local function b336(b334)
    b21.SpamDelay = 0.05 + (b334 * 4.95)
    b86(b166.SpamSliderFill, b166.SpamDelayBox, b21.SpamDelay, 0.05, 5, "%.2f")
    b34()
end

local function b337(b334)
    b21.TargetFPS = math.floor(15 + (b334 * 345))
    b86(b167.FPSFill, b167.FPSValueBox, b21.TargetFPS, 15, 360, "%d")
    if b21.FPSUnlockEnabled and b286 then
        pcall(setfpscap, b21.TargetFPS)
        b167.FPSUnlockStatus.Text = "Your target: " .. b21.TargetFPS .. " FPS"
    end
    b34()
end

b165.JumpSliderButton.MouseButton1Down:Connect(function() b332.jump = true; b90(b165.JumpSliderButton, 0.9) end)
b165.ClickSliderButton.MouseButton1Down:Connect(function() b332.click = true; b90(b165.ClickSliderButton, 0.9) end)
b166.SpamSliderButton.MouseButton1Down:Connect(function() b332.spam = true; b90(b166.SpamSliderButton, 0.9) end)
b167.FPSButton.MouseButton1Down:Connect(function() b332.fps = true; b90(b167.FPSButton, 0.9) end)

table.insert(_G.UU.Connections, b3.InputEnded:Connect(function(b338)
    if b338.UserInputType == Enum.UserInputType.MouseButton1 then
        b332.jump = false
        b332.click = false
        b332.spam = false
        b332.fps = false
    end
end))

table.insert(_G.UU.Connections, b3.InputChanged:Connect(function(b338)
    if b338.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local b339 = b3:GetMouseLocation().X
    if b332.jump and b165.JumpDelaySlider then
        b333(math.clamp((b339 - b165.JumpDelaySlider.AbsolutePosition.X) / b165.JumpDelaySlider.AbsoluteSize.X, 0, 1))
    elseif b332.click and b165.ClickDelaySlider then
        b335(math.clamp((b339 - b165.ClickDelaySlider.AbsolutePosition.X) / b165.ClickDelaySlider.AbsoluteSize.X, 0, 1))
    elseif b332.spam and b166.SpamDelaySlider then
        b336(math.clamp((b339 - b166.SpamDelaySlider.AbsolutePosition.X) / b166.SpamDelaySlider.AbsoluteSize.X, 0, 1))
    elseif b332.fps and b167.FPSSlider then
        b337(math.clamp((b339 - b167.FPSSlider.AbsolutePosition.X) / b167.FPSSlider.AbsoluteSize.X, 0, 1))
    end
end))

b165.JumpDelayBox.FocusLost:Connect(function()
    local b334 = math.clamp(tonumber(b165.JumpDelayBox.Text) or b21.JumpDelay, 5, 30)
    b333((b334 - 5) / 25)
end)
b165.ClickDelayBox.FocusLost:Connect(function()
    local b334 = math.clamp(tonumber(b165.ClickDelayBox.Text) or b21.ClickDelay, 1, 10)
    b335((b334 - 1) / 9)
end)
b166.SpamDelayBox.FocusLost:Connect(function()
    local b334 = math.clamp(tonumber(b166.SpamDelayBox.Text) or b21.SpamDelay, 0.05, 5)
    b336((b334 - 0.05) / 4.95)
end)
b167.FPSValueBox.FocusLost:Connect(function()
    local b334 = math.clamp(tonumber(b167.FPSValueBox.Text) or b21.TargetFPS, 15, 360)
    b337((b334 - 15) / 345)
end)
b166.SpamInput.FocusLost:Connect(function()
    b21.SpamKey = b166.SpamInput.Text:upper()
    b34()
end)

local b340 = false
local function b341(b342)
    if b340 or b21.ClickType == b342 then return end
    b340 = true
    b21.ClickType = b342
    b300()
    b34()
    task.delay(0.1, function() b340 = false end)
end

b165.ClickTypeCurrent.MouseButton1Click:Connect(function() b341("Current"); b90(b165.ClickTypeCurrent) end)
b165.ClickTypeCenter.MouseButton1Click:Connect(function() b341("Center"); b90(b165.ClickTypeCenter) end)
b165.ClickTypeRandom.MouseButton1Click:Connect(function() b341("Random"); b90(b165.ClickTypeRandom) end)

b165.JumpToggle.MouseButton1Click:Connect(function()
    if not b49("Jump", 0.3) then return end
    b90(b165.JumpToggle)
    b21.JumpEnabled = not b21.JumpEnabled
    local b304 = b21.JumpEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[b165.JumpToggle] then _G.UU.ButtonStates[b165.JumpToggle].BaseColor = b304 end
    b44(b165.JumpToggle, b40.Medium, { BackgroundColor3 = b304 })
    b165.JumpToggle.Text = "Auto Jump: " .. (b21.JumpEnabled and "ON" or "OFF")
    if b21.JumpEnabled then task.wait(0.05); b305() else b52("Jump") end
    b296(); b34()
end)

b165.ClickToggle.MouseButton1Click:Connect(function()
    if not b49("Click", 0.3) then return end
    b90(b165.ClickToggle)
    b21.ClickEnabled = not b21.ClickEnabled
    local b304 = b21.ClickEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[b165.ClickToggle] then _G.UU.ButtonStates[b165.ClickToggle].BaseColor = b304 end
    b44(b165.ClickToggle, b40.Medium, { BackgroundColor3 = b304 })
    b165.ClickToggle.Text = "Auto Click: " .. (b21.ClickEnabled and "ON" or "OFF")
    if b21.ClickEnabled then task.wait(0.05); b307() else b52("Click") end
    b296(); b34()
end)

b166.AutoSpamToggle.MouseButton1Click:Connect(function()
    if not b49("Spam", 0.3) then return end
    b90(b166.AutoSpamToggle)
    b21.AutoSpamEnabled = not b21.AutoSpamEnabled
    if b21.AutoSpamEnabled then
        local b314 = b166.SpamInput.Text:upper()
        local b315 = b23[b314]
        if not b315 then
            b21.AutoSpamEnabled = false
            b166.Status.Text = "Status: Invalid key"
            b44(b166.Status, b40.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            return
        end
        if b315 == Enum.KeyCode.P or b315 == b21.Keybind then
            b21.AutoSpamEnabled = false
            b166.Status.Text = "Status: Key reserved"
            b44(b166.Status, b40.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            return
        end
        b21.SpamKey = b314
        local b304 = Color3.fromRGB(50, 220, 100)
        if _G.UU.ButtonStates[b166.AutoSpamToggle] then _G.UU.ButtonStates[b166.AutoSpamToggle].BaseColor = b304 end
        b44(b166.AutoSpamToggle, b40.Medium, { BackgroundColor3 = b304 })
        b166.AutoSpamToggle.Text = "ON"
        b166.Status.Text = "Status: Spamming " .. b314
        b44(b166.Status, b40.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        task.wait(0.05); b313()
    else
        local b304 = Color3.fromRGB(220, 50, 50)
        if _G.UU.ButtonStates[b166.AutoSpamToggle] then _G.UU.ButtonStates[b166.AutoSpamToggle].BaseColor = b304 end
        b44(b166.AutoSpamToggle, b40.Medium, { BackgroundColor3 = b304 })
        b166.AutoSpamToggle.Text = "OFF"
        b166.Status.Text = "Status: Inactive"
        b44(b166.Status, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        b52("Spam")
    end
    b34()
end)

b167.FPSUnlockToggle.MouseButton1Click:Connect(function()
    if not b49("FPS", 0.3) then return end
    b90(b167.FPSUnlockToggle)
    if not b286 then
        b167.FPSUnlockStatus.Text = "FPS Unlock not supported"
        b44(b167.FPSUnlockStatus, b40.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
        return
    end
    b21.FPSUnlockEnabled = not b21.FPSUnlockEnabled
    if b21.FPSUnlockEnabled then
        pcall(setfpscap, b21.TargetFPS)
    else
        pcall(setfpscap, 60)
    end
    local b304 = b21.FPSUnlockEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[b167.FPSUnlockToggle] then _G.UU.ButtonStates[b167.FPSUnlockToggle].BaseColor = b304 end
    b44(b167.FPSUnlockToggle, b40.Medium, { BackgroundColor3 = b304 })
    b167.FPSUnlockToggle.Text = "FPS Unlock: " .. (b21.FPSUnlockEnabled and "ON" or "OFF")
    if b21.FPSUnlockEnabled then
        b167.FPSUnlockStatus.Text = "Your target: " .. b21.TargetFPS .. " FPS"
        b44(b167.FPSUnlockStatus, b40.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
    else
        b167.FPSUnlockStatus.Text = "Default FPS"
        b44(b167.FPSUnlockStatus, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    b34()
end)

b168.AutoRejoinToggle.MouseButton1Click:Connect(function()
    if not b49("Rejoin", 0.3) then return end
    b90(b168.AutoRejoinToggle)
    b21.AutoRejoinEnabled = not b21.AutoRejoinEnabled
    local b304 = b21.AutoRejoinEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[b168.AutoRejoinToggle] then _G.UU.ButtonStates[b168.AutoRejoinToggle].BaseColor = b304 end
    b44(b168.AutoRejoinToggle, b40.Medium, { BackgroundColor3 = b304 })
    b168.AutoRejoinToggle.Text = "Auto Rejoin: " .. (b21.AutoRejoinEnabled and "ON" or "OFF")
    if b21.AutoRejoinEnabled then
        b168.Status.Text = "Status: Enabled\n\nAutomatically rejoins the game when you get disconnected.\nUseful for preventing AFK kicks."
        b44(b168.Status, b40.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        b318()
    else
        b316 = false
        b52("Rejoin")
        if b317 then pcall(function() b317:Disconnect() end); b317 = nil end
        b168.Status.Text = "Status: Disabled\n\nWhen enabled, this feature will automatically rejoin the current server when you get disconnected due to errors or AFK timeout."
        b44(b168.Status, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    b34()
end)

b169.ExecuteButton.MouseButton1Click:Connect(function()
    if not b49("Execute", 0.5) then return end
    b90(b169.ExecuteButton)
    local b327 = b169.LoadStringBox.Text
    b169.Status.Text = "Status: Executing..."
    b44(b169.Status, b40.Fast, { TextColor3 = Color3.fromRGB(255, 200, 100) })
    b44(b169.ExecuteButton, b40.Medium, { BackgroundColor3 = Color3.fromRGB(255, 200, 100) })
    local b328, b329 = b326(b327)
    local b343 = b328 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    b169.Status.Text = "Status: " .. b329
    b44(b169.Status, b40.Fast, { TextColor3 = b343 })
    b44(b169.ExecuteButton, b40.Medium, { BackgroundColor3 = b343 })
    task.wait(2)
    if b169.Status.Text:match("Error") or b169.Status.Text:match("successfully") then
        b169.Status.Text = "Status: Ready"
        b44(b169.Status, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        b44(b169.ExecuteButton, b40.Medium, { BackgroundColor3 = Color3.fromRGB(45, 45, 52) })
    end
end)

b169.AutoLoadButton.MouseButton1Click:Connect(function()
    if not b49("AutoLoad", 0.3) then return end
    b90(b169.AutoLoadButton)
    b21.AutoLoadEnabled = not b21.AutoLoadEnabled
    local b304 = b21.AutoLoadEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[b169.AutoLoadButton] then _G.UU.ButtonStates[b169.AutoLoadButton].BaseColor = b304 end
    b44(b169.AutoLoadButton, b40.Medium, { BackgroundColor3 = b304 })
    b169.AutoLoadButton.Text = "Auto Load: " .. (b21.AutoLoadEnabled and "ON" or "OFF")
    local b298, b299
    if b21.AutoLoadEnabled then
        if b21.SavedCode and b21.SavedCode ~= "" then
            b298, b299 = "Auto-load enabled", Color3.fromRGB(50, 220, 100)
        else
            b298, b299 = "No code to auto-load", Color3.fromRGB(220, 50, 50)
        end
    else
        b298, b299 = "Auto-load disabled", Color3.fromRGB(180, 180, 180)
    end
    b169.Status.Text = "Status: " .. b298
    b44(b169.Status, b40.Fast, { TextColor3 = b299 })
    task.wait(2)
    if b169.Status.Text:match("enabled") or b169.Status.Text:match("disabled") or b169.Status.Text:match("code") then
        b169.Status.Text = "Status: Ready"
        b44(b169.Status, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    b34()
end)

b169.LoadStringBox:GetPropertyChangedSignal("Text"):Connect(function()
    if _G.UU.Threads.SaveCode then
        pcall(task.cancel, _G.UU.Threads.SaveCode)
        _G.UU.Threads.SaveCode = nil
    end
    _G.UU.Threads.SaveCode = task.delay(1.0, function()
        _G.UU.Threads.SaveCode = nil
        b21.SavedCode = b169.LoadStringBox.Text
        b34()
        b169.Status.Text = "Status: Code auto-saved ✓"
        b44(b169.Status, b40.Fast, { TextColor3 = Color3.fromRGB(100, 200, 255) })
        task.wait(2)
        if b169.Status.Text == "Status: Code auto-saved ✓" then
            b169.Status.Text = "Status: Ready"
            b44(b169.Status, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        end
    end)
    b93(b169.LoadStringBox, b169.LineNumbers, b169.LoadStringScrollFrame, b169.LineNumbersScrollFrame)
end)

b169.LoadStringScrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    b169.LineNumbersScrollFrame.CanvasPosition = Vector2.new(0, b169.LoadStringScrollFrame.CanvasPosition.Y)
end)

b170.KeybindButton.MouseButton1Click:Connect(function()
    if not b49("Keybind", 0.5) or b21.IsChangingKeybind then return end
    b90(b170.KeybindButton)
    b21.IsChangingKeybind = true
    b170.KeybindButton.Text = "Press any key..."
    b170.Status.Text = "Waiting for input..."
    b44(b170.Status, b40.Fast, { TextColor3 = Color3.fromRGB(255, 200, 100) })
    b170.KeybindButton.Active = false
    local b344
    local b345 = task.delay(5, function()
        _G.UU.Threads.KeybindTimeout = nil
        if b344 then b344:Disconnect() end
        b21.IsChangingKeybind = false
        b170.KeybindButton.Active = true
        b170.KeybindButton.Text = "Toggle Keybind: " .. (b22[b21.Keybind] or b21.Keybind.Name)
        b170.Status.Text = "Timeout - Click again to retry"
        b44(b170.Status, b40.Fast, { TextColor3 = Color3.fromRGB(255, 100, 100) })
        task.wait(2)
        if b170.Status.Text:match("Timeout") then
            b170.Status.Text = "Click the button above to change your toggle keybind."
            b44(b170.Status, b40.Fast, { TextColor3 = Color3.fromRGB(150, 150, 150) })
        end
    end)
    _G.UU.Threads.KeybindTimeout = b345
    b344 = b3.InputBegan:Connect(function(b338, b346)
        if b338.UserInputType == Enum.UserInputType.Keyboard and not b346 then
            if _G.UU.Threads.KeybindTimeout then
                pcall(task.cancel, _G.UU.Threads.KeybindTimeout)
                _G.UU.Threads.KeybindTimeout = nil
            end
            b21.Keybind = b338.KeyCode
            local b281 = b22[b338.KeyCode] or b338.KeyCode.Name
            b170.KeybindButton.Text = "Toggle Keybind: " .. b281
            b170.Status.Text = "Keybind changed successfully!"
            b44(b170.Status, b40.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
            b34()
            b170.KeybindButton.Active = true
            b344:Disconnect()
            task.delay(0.1, function() b21.IsChangingKeybind = false end)
            task.wait(1.5)
            if b170.Status.Text:match("successfully") then
                b170.Status.Text = "Click the button above to change your toggle keybind."
                b44(b170.Status, b40.Fast, { TextColor3 = Color3.fromRGB(150, 150, 150) })
            end
        end
    end)
end)

b170.AutoHideToggle.MouseButton1Click:Connect(function()
    if not b49("AutoHide", 0.3) then return end
    b90(b170.AutoHideToggle)
    b21.AutoHideEnabled = not b21.AutoHideEnabled
    local b304 = b21.AutoHideEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[b170.AutoHideToggle] then _G.UU.ButtonStates[b170.AutoHideToggle].BaseColor = b304 end
    b44(b170.AutoHideToggle, b40.Medium, { BackgroundColor3 = b304 })
    b170.AutoHideToggle.Text = "Auto Hide UI: " .. (b21.AutoHideEnabled and "ON" or "OFF")
    if b21.AutoHideEnabled then
        b170.Status.Text = "Auto-hide enabled - UI will start hidden on next execution"
        b44(b170.Status, b40.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
    else
        b170.Status.Text = "Auto-hide disabled - UI will show normally on start"
        b44(b170.Status, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    b34()
end)

local function b347(b152)
    if b21.CurrentTab == b152 then return end
    if not b49("Tab", 0.15) then return end
    b21.CurrentTab = b152
    b34()
    for b348, b349 in pairs(b149) do
        if b348 == b152 then
            b349.Visible = true
            b349.Position = UDim2.new(0, 15, 0, 0)
            b44(b349, b40.Smooth, { Position = UDim2.new(0, 5, 0, 0) })
        else
            b349.Visible = false
        end
    end
    for b348, b350 in pairs(b148) do
        local b351 = b348 == b152
        b44(b350.Button, b40.Fast, { BackgroundColor3 = b351 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(35, 35, 42) })
        b44(b350.Icon, b40.Fast, { TextColor3 = b351 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180), TextSize = b351 and 20 or 18 })
        b44(b350.Label, b40.Fast, { TextColor3 = b351 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180) })
    end
end

for b162, b163 in ipairs(b161) do
    if b148[b163.name] then
        local b152 = b163.name
        b148[b152].Button.MouseButton1Click:Connect(function() b347(b152) end)
    end
end

local b352 = {}
local b353 = false

local function b354()
    if b353 or #b352 == 0 then return end
    b353 = true
    local b355 = table.remove(b352, 1)
    b355()
    task.wait(0.05)
    b353 = false
    if #b352 > 0 then b354() end
end

local function b356(b355)
    table.insert(b352, b355)
    b354()
end

local function b357(b358, b359)
    local b360 = b56.Width * b359
    local b361 = b56.Height * b359
    local b362 = math.max(0, (b358.X - b360) / 2)
    local b363 = math.max(0, (b358.Y - b361) / 2)
    return b362, b363
end

local function b364(b358, b359)
    local b365 = math.floor(60 * b359)
    local b362 = math.max(0, (b358.X - b365) / 2)
    local b363 = math.max(0, math.min(30, b358.Y - b365))
    return b365, b362, b363
end

local function b366(b367)
    if not b57 then return end
    b44(b57, b40.Smooth, { Scale = b367 })
    b58 = b367
    if b137.Visible and b21.SavedReopenPosition then
        b137.Position = UDim2.new(0, b21.SavedReopenPosition.X, 0, b21.SavedReopenPosition.Y)
    end
    b138.TextSize = math.floor(24 * b367)
end

local b368 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
local b369 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0)

local function b370()
    if not b49("UI", 0.6) then return end
    b356(function()
        if b130.Visible then
            local currentUIPosX = b130.Position.X.Offset
            local currentUIPosY = b130.Position.Y.Offset
            b21.SavedUIPosition = { X = currentUIPosX, Y = currentUIPosY }
            
            b130.Size = UDim2.new(0, b56.Width, 0, b56.Height)
            local b371 = b44(b57, b369, { Scale = 0 })
            b371.Completed:Wait()
            b130.Visible = false
            b57.Scale = 0
            b34()

            local b372 = b55()
            local b365 = math.floor(60 * b58)
            local savedReopenX, savedReopenY
            if b21.SavedReopenPosition then
                savedReopenX = b21.SavedReopenPosition.X
                savedReopenY = b21.SavedReopenPosition.Y
            else
                local _, defX, defY = b364(b372, b58)
                savedReopenX = defX
                savedReopenY = defY
            end
            
            b137.Size = UDim2.new(0, 0, 0, 0)
            b137.Position = UDim2.new(0, savedReopenX, 0, savedReopenY)
            b137.ImageTransparency = 1
            b138.TextTransparency = 1
            b137.Rotation = -180
            b137.Visible = true

            local b373 = b2:Create(b137, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, b365, 0, b365),
                Position = UDim2.new(0, savedReopenX, 0, savedReopenY),
                ImageTransparency = 0,
                Rotation = 0,
            })
            local b374 = b2:Create(b138, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0,
            })
            b373:Play()
            task.delay(0.15, function() b374:Play() end)
            b373.Completed:Wait()
        else
            if b144 then b144:Disconnect(); b144 = nil end

            local currentReopenX = b137.Position.X.Offset
            local currentReopenY = b137.Position.Y.Offset
            b21.SavedReopenPosition = { X = currentReopenX, Y = currentReopenY }
            
            local b375 = b137.Size.X.Offset
            local b376 = b137.Position

            local b377 = b2:Create(b137, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0, currentReopenX, 0, currentReopenY),
                ImageTransparency = 1,
                Rotation = 90,
            })
            local b378 = b2:Create(b138, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
            })
            b378:Play()
            b377:Play()
            b377.Completed:Wait()

            b137.Visible = false
            b137.Rotation = 0
            b137.ImageTransparency = 0
            b138.TextTransparency = 0
            b34()

            b130.Visible = true
            b130.Size = UDim2.new(0, b56.Width, 0, b56.Height)
            b57.Scale = 0
            local savedUIX, savedUIY
            if b21.SavedUIPosition then
                savedUIX = b21.SavedUIPosition.X
                savedUIY = b21.SavedUIPosition.Y
            else
                local defX, defY = b357(b55(), b58)
                savedUIX = defX
                savedUIY = defY
            end
            b130.Position = UDim2.new(0, savedUIX, 0, savedUIY)
            local b379 = b44(b57, b368, { Scale = b58 })
            b379.Completed:Wait()
        end
    end)
end

b134.MouseButton1Click:Connect(b370)
b134.MouseEnter:Connect(function() b44(b134, b40.Fast, { BackgroundColor3 = Color3.fromRGB(240, 70, 70), Size = UDim2.new(0, 34, 0, 34), Rotation = 90 }) end)
b134.MouseLeave:Connect(function() b44(b134, b40.Fast, { BackgroundColor3 = Color3.fromRGB(220, 50, 50), Size = UDim2.new(0, 30, 0, 30), Rotation = 0 }) end)
b134.MouseButton1Down:Connect(function() b44(b134, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 28, 0, 28) }) end)
b134.MouseButton1Up:Connect(function() b44(b134, b40.Fast, { Size = UDim2.new(0, 30, 0, 30) }) end)

b137.MouseButton1Click:Connect(function() if not b143 then b370() end end)

b137.MouseEnter:Connect(function()
    if not b139 then
        local b365 = math.floor(60 * b58)
        b44(b137, b40.Medium, { Size = UDim2.new(0, math.floor(b365 * 1.17), 0, math.floor(b365 * 1.17)) })
        if b144 then b144:Disconnect() end
        b144 = b5.RenderStepped:Connect(function(b380)
            if b137.Visible then
                b137.Rotation = (b137.Rotation + (b380 * 180)) % 360
            else
                if b144 then b144:Disconnect(); b144 = nil end
            end
        end)
    end
end)
b137.MouseLeave:Connect(function()
    if b144 then b144:Disconnect(); b144 = nil end
    if not b139 then
        local b365 = math.floor(60 * b58)
        b44(b137, b40.Medium, { Size = UDim2.new(0, b365, 0, b365), Rotation = 0 })
    end
end)
b137.MouseButton1Down:Connect(function()
    if not b139 then
        local b365 = math.floor(60 * b58)
        b44(b137, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, math.floor(b365 * 0.92), 0, math.floor(b365 * 0.92)) })
    end
end)
b137.MouseButton1Up:Connect(function()
    if not b139 then
        local b365 = math.floor(60 * b58)
        b44(b137, b40.Fast, { Size = UDim2.new(0, b365, 0, b365) })
    end
end)

table.insert(_G.UU.Connections, b3.InputBegan:Connect(function(b338, b346)
    if not b346 and b338.KeyCode == b21.Keybind and not b21.IsChangingKeybind then
        b370()
    end
end))

local b381 = Vector2.new(0, 0)
local b382 = false

local function b383()
    if b382 then return end
    b382 = true
    task.delay(0.1, function()
        b382 = false
        local b384 = b55()
        if math.abs(b384.X - b381.X) < 2 and math.abs(b384.Y - b381.Y) < 2 then return end
        b381 = b384
        local b385 = b59(b384)
        if _G.UU.UI.ResolutionLabel then _G.UU.UI.ResolutionLabel.Text = string.format("Resolution: %dx%d", b384.X, b384.Y) end
        if _G.UU.UI.DeviceLabel then _G.UU.UI.DeviceLabel.Text = "Device: " .. b19() end
        b366(b385)
        b21.SavedUIPosition = nil
        b21.SavedReopenPosition = nil
        
        local b362, b363 = b357(b384, b385)
        b130.Position = UDim2.new(0, b362, 0, b363)
        
        local b365 = math.floor(60 * b58)
        b362 = math.max(0, (b384.X - b365) / 2)
        b363 = math.max(0, math.min(30, b384.Y - b365))
        b137.Size = UDim2.new(0, b365, 0, b365)
        b137.Position = UDim2.new(0, b362, 0, b363)
        
        b34()
    end)
end

if workspace.CurrentCamera then
    table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(b383))
end
table.insert(_G.UU.Connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(b383))
    end
end))

table.insert(_G.UU.Connections, b5.RenderStepped:Connect(function()
    b292 = b292 + 1
    local b386 = tick()

    if b386 - b291 >= 1 then
        b290 = math.floor(b292 / (b386 - b291))
        b292 = 0
        b291 = b386
        if b164.FPSLabel then b164.FPSLabel.Text = "FPS: " .. b290 end
        table.remove(b288, 1); table.insert(b288, b290)
        local b387, b388, b389 = math.huge, 0, 0
        for b390, b391 in ipairs(b288) do
            b387 = math.min(b387, b391)
            b388 = math.max(b388, b391)
            b389 = b389 + b391
        end
        local b392 = math.floor(b389 / #b288)
        if b167.FPSStats then
            b167.FPSStats.Current.Text = "Current: " .. b290
            b167.FPSStats.Avg.Text = "Average: " .. b392
            b167.FPSStats.MinMax.Text = string.format("Min: %d | Max: %d", b387, b388)
        end

        local b393 = b10:GetTotalMemoryUsageMb()
        b294 = math.max(b294, b393)
        if b164.MemoryLabel then
            b164.MemoryLabel.Text = string.format("Memory: %.1f MB", b393)
        end
        if b167.MemoryStats then
            b167.MemoryStats.Current.Text = string.format("Current: %.1f MB", b393)
            b167.MemoryStats.Peak.Text = string.format("Peak: %.1f MB", b294)
        end
    end

    if b292 % 30 == 0 then
        local b394 = math.floor(b11:GetNetworkPing() * 1000)
        if b164.PingLabel then
            b164.PingLabel.Text = "Ping: " .. b394 .. " ms"
            b164.PingLabel.TextColor3 = b394 < 100 and Color3.fromRGB(0, 255, 0) or b394 < 200 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        table.remove(b289, 1); table.insert(b289, b394)
        local b395, b396, b397 = math.huge, 0, 0
        for b390, b398 in ipairs(b289) do
            b395 = math.min(b395, b398)
            b396 = math.max(b396, b398)
            b397 = b397 + b398
        end
        local b399 = math.floor(b397 / #b289)
        if b167.PingStats then
            b167.PingStats.Current.Text = "Current: " .. b394 .. "ms"
            b167.PingStats.Avg.Text = "Average: " .. b399 .. "ms"
            b167.PingStats.MinMax.Text = string.format("Min: %dms | Max: %dms", b395, b396)
            local b400, b401
            if b394 < 50 then
                b400, b401 = "Excellent", Color3.fromRGB(50, 220, 100)
            elseif b394 < 100 then
                b400, b401 = "Good", Color3.fromRGB(100, 200, 255)
            elseif b394 < 200 then
                b400, b401 = "Fair", Color3.fromRGB(255, 200, 100)
            elseif b394 < 300 then
                b400, b401 = "Poor", Color3.fromRGB(255, 150, 50)
            else
                b400, b401 = "Very Poor", Color3.fromRGB(220, 50, 50)
            end
            b167.PingStats.Quality.Text = b400
            b167.PingStats.Quality.TextColor3 = b401
        end
    end
end))

local b402 = b37()

local function b403(b404, b405)
    local b304 = b405 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    b404.BackgroundColor3 = b304
    if _G.UU.ButtonStates[b404] then _G.UU.ButtonStates[b404].BaseColor = b304 end
end

if b402 then
    if b170.KeybindButton then b170.KeybindButton.Text = "Current Key: " .. (b22[b21.Keybind] or b21.Keybind.Name) end
    if b166.SpamInput then b166.SpamInput.Text = b21.SpamKey end
    if b169.LoadStringBox then b169.LoadStringBox.Text = b21.SavedCode end

    b333((b21.JumpDelay - 5) / 25)
    b335((b21.ClickDelay - 1) / 9)
    b336((b21.SpamDelay - 0.05) / 4.95)
    b337((b21.TargetFPS - 15) / 345)
    b300()

    b403(b169.AutoLoadButton, b21.AutoLoadEnabled)
    b169.AutoLoadButton.Text = "Auto Load: " .. (b21.AutoLoadEnabled and "ON" or "OFF")

    b403(b170.AutoHideToggle, b21.AutoHideEnabled)
    b170.AutoHideToggle.Text = "Auto Hide UI: " .. (b21.AutoHideEnabled and "ON" or "OFF")

    if b21.AutoRejoinEnabled then
        b403(b168.AutoRejoinToggle, true)
        b168.AutoRejoinToggle.Text = "Auto Rejoin: ON"
        b168.Status.Text = "Status: Enabled\n\nAutomatically rejoins the server when disconnected."
        b168.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        b318()
    end

    if b21.FPSUnlockEnabled and b286 then
        b403(b167.FPSUnlockToggle, true)
        b167.FPSUnlockToggle.Text = "FPS Unlock: ON"
        b167.FPSUnlockStatus.TextColor3 = Color3.fromRGB(50, 220, 100)
        b167.FPSUnlockStatus.Text = "Current Limit: " .. b21.TargetFPS .. " FPS (Custom)"
        pcall(setfpscap, b21.TargetFPS)
    else
        b403(b167.FPSUnlockToggle, false)
        b167.FPSUnlockToggle.Text = "FPS Unlock: OFF"
    end

    b403(b165.JumpToggle, b21.JumpEnabled)
    b165.JumpToggle.Text = "Auto Jump: " .. (b21.JumpEnabled and "ON" or "OFF")
    if b21.JumpEnabled then task.wait(0.1); b305() end

    b403(b165.ClickToggle, b21.ClickEnabled)
    b165.ClickToggle.Text = "Auto Click: " .. (b21.ClickEnabled and "ON" or "OFF")
    if b21.ClickEnabled then task.wait(0.1); b307() end

    if b21.AutoSpamEnabled and b23[b21.SpamKey] then
        b403(b166.AutoSpamToggle, true)
        b166.AutoSpamToggle.Text = "ON"
        b166.Status.Text = "System Status: Spamming " .. b21.SpamKey
        b166.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        task.wait(0.1); b313()
    else
        b21.AutoSpamEnabled = false
        b403(b166.AutoSpamToggle, false)
        b166.AutoSpamToggle.Text = "OFF"
    end

    b296()
else
    b333(0.2); b335(0.22); b336(0.01); b337(0.13)
    b300()
    b403(b165.JumpToggle, false); b165.JumpToggle.Text = "Auto Jump: OFF"
    b403(b165.ClickToggle, false); b165.ClickToggle.Text = "Auto Click: OFF"
    b403(b166.AutoSpamToggle, false); b166.AutoSpamToggle.Text = "OFF"
    b403(b167.FPSUnlockToggle, false); b167.FPSUnlockToggle.Text = "FPS Unlock: OFF"
    b167.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
    b403(b169.AutoLoadButton, false); b169.AutoLoadButton.Text = "Auto Load: OFF"
    b403(b170.AutoHideToggle, false); b170.AutoHideToggle.Text = "Auto Hide UI: OFF"
    b296()
end

task.spawn(function()
    pcall(function()
        if _G.UU.UI.PlayerImage then
            _G.UU.UI.PlayerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. b13 .. "&w=420&h=420"
        end
        if _G.UU.UI.GameName and _G.UU.UI.GameImage then
            local b406 = b8:GetProductInfo(game.PlaceId)
            _G.UU.UI.GameName.Text = b406.Name
            if b406.IconImageAssetId and b406.IconImageAssetId ~= 0 then
                _G.UU.UI.GameImage.Image = "rbxthumb://type=Asset&id=" .. b406.IconImageAssetId .. "&w=420&h=420"
            end
        end
    end)
end)

b93(b169.LoadStringBox, b169.LineNumbers, b169.LoadStringScrollFrame, b169.LineNumbersScrollFrame)

b129.Destroying:Connect(function()
    for b348, b15 in pairs(_G.UU.Threads) do
        if b15 and typeof(b15) == "thread" and coroutine.status(b15) ~= "dead" then
            pcall(task.cancel, b15)
        end
        _G.UU.Threads[b348] = nil
    end
    if b317 then pcall(function() b317:Disconnect() end); b317 = nil end
    if b144 then pcall(function() b144:Disconnect() end); b144 = nil end
end)

for b348, b349 in pairs(b149) do b349.Visible = false end
b21.CurrentTab = nil

local b407 = b55()
b381 = b407
b58 = b59(b407)

task.wait(0.1)

local b408 = b21.AutoHideEnabled == false

b130.Size = UDim2.new(0, b56.Width, 0, b56.Height)
b57.Scale = 0

local b409 = b407.X
local b410 = b407.Y
local b362, b363
if b21.SavedUIPosition then
    b362 = b21.SavedUIPosition.X
    b363 = b21.SavedUIPosition.Y
else
    b362, b363 = b357(b407, b58)
end
b130.Position = UDim2.new(0, b362, 0, b363)

local b365
if b21.SavedReopenPosition then
    b362 = b21.SavedReopenPosition.X
    b363 = b21.SavedReopenPosition.Y
    b365 = math.floor(60 * b58)
else
    b365, b362, b363 = b364(b407, b58)
end
b137.Size = UDim2.new(0, b365, 0, b365)
b137.Position = UDim2.new(0, b362, 0, b363)
b137.ImageTransparency = 0
b138.TextTransparency = 0

if b408 then
    b130.Visible = true
    local b411 = b44(b57, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = b58 })
    b411.Completed:Wait()
    b137.Visible = false
else
    b130.Visible = false
    b137.Visible = true
    b137.Size = UDim2.new(0, b365, 0, b365)
end

b347("Home")
b34()

if queue_on_teleport and not _G.UU.TeleportQueued then
    _G.UU.TeleportQueued = true
    pcall(function()
        queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/6942x/UniversalUtility/main/Init.lua", true))()')
    end)
end

_G.UU.Loaded = true
_G.UU.LoadLock = false

task.defer(function()
    if b402 and b21.AutoLoadEnabled and b21.SavedCode and b21.SavedCode ~= "" then
        local b328, b329 = b326(b21.SavedCode)
        if b328 then
            b169.Status.Text = "System Status: Auto-load executed successfully"
            b44(b169.Status, b40.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        else
            b169.Status.Text = "System Status: Auto-load failed - " .. b329
            b44(b169.Status, b40.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
        end
        task.wait(3)
        b169.Status.Text = "System Status: Ready to execute"
        b44(b169.Status, b40.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
end)

return _G.UU
