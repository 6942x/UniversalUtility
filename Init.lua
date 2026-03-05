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
    repeat b11 = b1.LocalPlayer; task.wait() until b11
end

local b12 = b11.Name
local b13 = b11.UserId
if not b12 or b12 == "" then
    repeat b12 = b11.Name; task.wait() until b12 and b12 ~= ""
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
    _G.UU.TeleportQueued = false
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
    if b3.TouchEnabled and not b3.KeyboardEnabled and not b3.MouseEnabled then return "Mobile"
    elseif b3.GamepadEnabled and not b3.KeyboardEnabled then return "Console"
    elseif b3.KeyboardEnabled and b3.MouseEnabled then return "PC" end
    local b20 = b3:GetLastInputType()
    if b20 == Enum.UserInputType.Touch then return "Mobile"
    elseif b20 == Enum.UserInputType.Gamepad1 or b20 == Enum.UserInputType.Gamepad2 then return "Console" end
    return "PC"
end

local b21 = {
    Keybind            = Enum.KeyCode.G,
    ClickType          = "Current",
    JumpEnabled        = false,
    ClickEnabled       = false,
    AutoSpamEnabled    = false,
    AutoLoadEnabled    = false,
    IsChangingKeybind  = false,
    FPSUnlockEnabled   = false,
    AutoRejoinEnabled  = false,
    AutoHideEnabled    = false,
    TargetFPS          = 60,
    JumpDelay          = 10.0,
    ClickDelay         = 3.0,
    SpamDelay          = 0.1,
    SpamKey            = "Q",
    SavedCode          = "",
    CurrentTab         = "Home",
    UIPosition         = { X = 0.5, Y = 0.5 },
    ReopenPosition     = { X = 0.5, Y = 30 },
    SavedUIPosition    = nil,
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

local b26 = { "One","Two","Three","Four","Five","Six","Seven","Eight","Nine" }
for b27 = 0, 9 do
    local b28 = b27 == 0 and "Zero" or b26[b27]
    b22[Enum.KeyCode[b28]] = tostring(b27)
    b23[tostring(b27)] = Enum.KeyCode[b28]
end

for b29 = 1, 12 do
    b22[Enum.KeyCode["F"..b29]] = "F"..b29
    b23["F"..b29] = Enum.KeyCode["F"..b29]
end

for b30, b31 in pairs({
    LeftControl="Left Ctrl", RightControl="Right Ctrl",
    LeftShift="Left Shift", RightShift="Right Shift",
    LeftAlt="Left Alt",     RightAlt="Right Alt",
    Tab="Tab",              CapsLock="Caps Lock",
    Space="Space",          Return="Enter",
    Backspace="Backspace",  Delete="Delete",
    Insert="Insert",        Home="Home",
    End="End",              PageUp="Page Up",
    PageDown="Page Down",
}) do b22[Enum.KeyCode[b30]] = b31 end

_G.UU.KCN = b22
_G.UU.KCM = b23

local function b32()
    return "UniversalUtilityConfig-"..b13..".json"
end

local function b33()
    if not writefile then return end
    local b34 = _G.UU.UI and _G.UU.UI.MainFrame
    local b35 = _G.UU.UI and _G.UU.UI.ReopenButton
    if b34 and b34.Visible then
        b21.SavedUIPosition = { X = b34.Position.X.Offset, Y = b34.Position.Y.Offset }
    end
    if b35 and b35.Visible then
        b21.SavedReopenPosition = { X = b35.Position.X.Offset, Y = b35.Position.Y.Offset }
    end
    writefile(b32(), b:JSONEncode({
        UserId              = b13,
        Username            = b12,
        Keybind             = b21.Keybind.Name,
        ClickType           = b21.ClickType,
        JumpEnabled         = b21.JumpEnabled,
        ClickEnabled        = b21.ClickEnabled,
        AutoRejoinEnabled   = b21.AutoRejoinEnabled,
        FPSUnlockEnabled    = b21.FPSUnlockEnabled,
        AutoSpamEnabled     = b21.AutoSpamEnabled,
        AutoLoadEnabled     = b21.AutoLoadEnabled,
        AutoHideEnabled     = b21.AutoHideEnabled,
        TargetFPS           = b21.TargetFPS,
        JumpDelay           = b21.JumpDelay,
        ClickDelay          = b21.ClickDelay,
        SpamDelay           = b21.SpamDelay,
        SpamKey             = b21.SpamKey,
        SavedCode           = b21.SavedCode,
        CurrentTab          = b21.CurrentTab,
        UIPosition          = b21.UIPosition,
        ReopenPosition      = b21.ReopenPosition,
        SavedUIPosition     = b21.SavedUIPosition,
        SavedReopenPosition = b21.SavedReopenPosition,
    }))
end
_G.UU.SaveCFG = b33

local function b36()
    if not (readfile and isfile and isfile(b32())) then return false end
    local b37, b38 = pcall(function() return b:JSONDecode(readfile(b32())) end)
    if not b37 or not b38 or b38.UserId ~= b13 then return false end
    b21.Keybind             = Enum.KeyCode[b38.Keybind] or Enum.KeyCode.G
    b21.ClickType           = b38.ClickType or "Current"
    b21.JumpEnabled         = b38.JumpEnabled or false
    b21.ClickEnabled        = b38.ClickEnabled or false
    b21.AutoRejoinEnabled   = b38.AutoRejoinEnabled or false
    b21.FPSUnlockEnabled    = b38.FPSUnlockEnabled or false
    b21.AutoSpamEnabled     = b38.AutoSpamEnabled or false
    b21.AutoLoadEnabled     = b38.AutoLoadEnabled or false
    b21.AutoHideEnabled     = b38.AutoHideEnabled or false
    b21.TargetFPS           = b38.TargetFPS or 60
    b21.JumpDelay           = b38.JumpDelay or 10.0
    b21.ClickDelay          = b38.ClickDelay or 3.0
    b21.SpamDelay           = b38.SpamDelay or 0.1
    b21.SpamKey             = b38.SpamKey or "Q"
    b21.SavedCode           = b38.SavedCode or ""
    b21.CurrentTab          = b38.CurrentTab or "Home"
    b21.UIPosition          = b38.UIPosition or { X = 0.5, Y = 0.5 }
    b21.ReopenPosition      = b38.ReopenPosition or { X = 0.5, Y = 30 }
    b21.SavedUIPosition     = b38.SavedUIPosition or nil
    b21.SavedReopenPosition = b38.SavedReopenPosition or nil
    return true
end

local b39 = {
    Fast    = TweenInfo.new(0.15, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    Medium  = TweenInfo.new(0.25, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    Slow    = TweenInfo.new(0.35, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    Back    = TweenInfo.new(0.50, Enum.EasingStyle.Back,    Enum.EasingDirection.Out),
    BackIn  = TweenInfo.new(0.35, Enum.EasingStyle.Back,    Enum.EasingDirection.In),
    Elastic = TweenInfo.new(0.60, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Smooth  = TweenInfo.new(0.30, Enum.EasingStyle.Sine,    Enum.EasingDirection.InOut),
}

local b40 = {}

local function b41(b42)
    if b40[b42] then b40[b42]:Cancel(); b40[b42] = nil end
end

local function b43(b42, b44, b45)
    b41(b42)
    local b46 = b2:Create(b42, b44, b45)
    b40[b42] = b46
    b46:Play()
    b46.Completed:Connect(function(b47)
        if b47 == Enum.TweenStatus.Completed then b40[b42] = nil end
    end)
    return b46
end

local function b48(b49, b50)
    if _G.UU.Debounces[b49] then return false end
    _G.UU.Debounces[b49] = true
    task.delay(b50 or 0.3, function() _G.UU.Debounces[b49] = false end)
    return true
end

local function b51(b52)
    if _G.UU.Threads[b52] then
        local b53 = _G.UU.Threads[b52]
        _G.UU.Threads[b52] = nil
        if typeof(b53) == "thread" and coroutine.status(b53) ~= "dead" then
            pcall(task.cancel, b53)
        end
    end
end

local function b54()
    return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
end

local b55 = { Width = 650, Height = 500 }

local b56 = nil
local b57 = 1

local function b58(b59)
    return math.clamp(math.min(b59.X / 1920, b59.Y / 1080), 0.75, 1.4)
end

local function b60(b61, b62)
    local b63 = Instance.new("UICorner", b61)
    b63.CornerRadius = UDim.new(0, b62 or 8)
    return b63
end

local function b64(b61, b65, b66, b67)
    local b68 = Instance.new("UIGradient", b61)
    b68.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, b65),
        ColorSequenceKeypoint.new(1, b66),
    }
    b68.Rotation = b67 or 90
    return b68
end

local function b69(b61, b70, b71, b72, b73, b74_min, b74_max, b74_label)
    local b74 = Instance.new("Frame", b61)
    b74.Size     = b70
    b74.Position = b71
    b74.BackgroundTransparency = 1
    local b75 = Instance.new("TextLabel", b74)
    b75.Size                = UDim2.new(1, 0, 0, 18)
    b75.BackgroundTransparency = 1
    b75.Text                = b74_label or b73
    b75.Font                = Enum.Font.Gotham
    b75.TextSize            = 12
    b75.TextColor3          = Color3.fromRGB(180, 180, 180)
    b75.TextXAlignment      = Enum.TextXAlignment.Left
    local b76 = Instance.new("Frame", b74)
    b76.Size             = UDim2.new(1, -60, 0, 6)
    b76.Position         = UDim2.new(0, 0, 0, 22)
    b76.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b76.BorderSizePixel  = 0
    b60(b76, 3)
    local b77 = Instance.new("Frame", b76)
    local b77_min = b74_min or 0
    local b77_max = (b74_max or 1) - b77_min
    local b77_init = (b72 - b77_min) / math.max(b77_max, 0.001)
    b77.Size             = UDim2.new(math.clamp(b77_init, 0, 1), 0, 1, 0)
    b77.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    b77.BorderSizePixel  = 0
    b60(b77, 3)
    local b78 = Instance.new("TextButton", b76)
    b78.Size                = UDim2.new(1, 0, 1, 0)
    b78.BackgroundTransparency = 1
    b78.Text                = ""
    local b79 = Instance.new("TextBox", b74)
    b79.Size             = UDim2.new(0, 50, 0, 24)
    b79.Position         = UDim2.new(1, -50, 0, 16)
    b79.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b79.Text             = tostring(b72)
    b79.Font             = Enum.Font.Gotham
    b79.TextScaled       = true
    b79.TextColor3       = Color3.fromRGB(255, 255, 255)
    b79.ClearTextOnFocus = false
    b79.BorderSizePixel  = 0
    b60(b79, 5)
    return b74, b76, b77, b78, b79
end

local function b80(b81, b82, b83, b84, b85, b86)
    b2:Create(b81, b39.Fast, { Size = UDim2.new((b83 - b84) / (b85 - b84), 0, 1, 0) }):Play()
    b82.Text = string.format(b86, b83)
end

local function b87(b88, b89)
    b89 = b89 or 0.95
    local b90 = b88.Size
    b43(b88, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(b90.X.Scale * b89, b90.X.Offset * b89, b90.Y.Scale * b89, b90.Y.Offset * b89)
    })
    task.wait(0.1)
    b43(b88, b39.Back, { Size = b90 })
end

local function b91(b92, b93, b94, b95)
    local b96 = b92.Text
    local b97 = 1
    for _ in b96:gmatch("\n") do b97 = b97 + 1 end
    local b98 = ""
    for b99 = 1, b97 do b98 = b98..b99.."\n" end
    b93.Text = b98
    local b100 = b9:GetTextSize(b92.Text, b92.TextSize, b92.Font, Vector2.new(b92.AbsoluteSize.X - 10, math.huge))
    local b101 = math.max(200, b100.Y + 20)
    b92.Size = UDim2.new(1, -10, 0, b101)
    b94.CanvasSize = UDim2.new(0, 0, 0, b101)
    b95.CanvasSize = UDim2.new(0, 0, 0, b101)
    b93.Size = UDim2.new(1, -5, 0, b101)
end

local function b102(b61, b103)
    local b104, b105, b106, b107 = false, nil, nil, nil
    b61.InputBegan:Connect(function(b108)
        if b108.UserInputType == Enum.UserInputType.MouseButton1 or b108.UserInputType == Enum.UserInputType.Touch then
            b104 = true
            b105 = b108.Position
            b106 = b61.Position
            if b107 then b107:Disconnect() end
            b107 = b3.InputChanged:Connect(function(b109)
                if (b109.UserInputType == Enum.UserInputType.MouseMovement or b109.UserInputType == Enum.UserInputType.Touch) and b104 then
                    local b110 = b109.Position - b105
                    b61.Position = UDim2.new(b106.X.Scale, b106.X.Offset + b110.X, b106.Y.Scale, b106.Y.Offset + b110.Y)
                end
            end)
            b108.Changed:Connect(function()
                if b108.UserInputState == Enum.UserInputState.End then
                    b104 = false
                    if b107 then b107:Disconnect(); b107 = nil end
                    if b103 then b103() end
                end
            end)
        end
    end)
end

local function b111(b61, b70, b112, b113)
    local b114 = Instance.new("Frame", b61)
    b114.Size             = b70
    b114.Position         = b112
    b114.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b114.BorderSizePixel  = 0
    b60(b114, 8)
    Instance.new("UIStroke", b114).Color = Color3.fromRGB(50, 50, 60)
    local b115 = Instance.new("TextLabel", b114)
    b115.Size                = UDim2.new(1, -10, 1, -10)
    b115.Position            = UDim2.new(0, 5, 0, 5)
    b115.BackgroundTransparency = 1
    b115.Text                = b113
    b115.Font                = Enum.Font.GothamBold
    b115.TextSize            = 14
    b115.TextColor3          = Color3.fromRGB(180, 180, 180)
    b115.TextXAlignment      = Enum.TextXAlignment.Center
    b115.TextWrapped         = true
    b115.TextYAlignment      = Enum.TextYAlignment.Top
    return b114, b115
end

local function b116(b61, b117)
    local b118 = Instance.new("Frame", b61)
    b118.Size             = UDim2.new(1, -20, 0, 1)
    b118.Position         = UDim2.new(0, 10, 0, b117)
    b118.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b118.BorderSizePixel  = 0
    return b118
end

local function b119(b61, b113, b117, b120)
    local b121 = Instance.new("TextLabel", b61)
    b121.Size                = UDim2.new(1, -20, 0, 20)
    b121.Position            = UDim2.new(0, 10, 0, b117)
    b121.BackgroundTransparency = 1
    b121.Text                = b113
    b121.Font                = Enum.Font.GothamBold
    b121.TextSize            = 13
    b121.TextColor3          = b120 or Color3.fromRGB(200, 200, 200)
    b121.TextXAlignment      = Enum.TextXAlignment.Left
    return b121
end

local function b122(b61, b123, b124)
    local b125 = Instance.new("Frame", b61)
    b125.Size             = UDim2.new(1, 0, 0, b123)
    b125.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    b125.BorderSizePixel  = 0
    b125.LayoutOrder      = b124 or 1
    b60(b125, 10)
    b64(b125, Color3.fromRGB(35, 35, 42), Color3.fromRGB(40, 40, 47), 90)
    return b125
end

local function b126(b61, b113, b127)
    local b128 = Instance.new("TextLabel", b61)
    b128.Size                = UDim2.new(1, -20, 0, 16)
    b128.Position            = UDim2.new(0, 10, 0, b127)
    b128.BackgroundTransparency = 1
    b128.Text                = b113
    b128.Font                = Enum.Font.Gotham
    b128.TextSize            = 12
    b128.TextColor3          = Color3.fromRGB(150, 150, 150)
    b128.TextXAlignment      = Enum.TextXAlignment.Left
    return b128
end

local function b129(b61, b113, b127)
    local b130 = Instance.new("TextLabel", b61)
    b130.Size                = UDim2.new(1, -20, 0, 26)
    b130.Position            = UDim2.new(0, 10, 0, b127)
    b130.BackgroundTransparency = 1
    b130.Text                = b113
    b130.Font                = Enum.Font.GothamBold
    b130.TextSize            = 18
    b130.TextXAlignment      = Enum.TextXAlignment.Left
    return b130
end

local function b131(b61, b113, b127)
    local b132 = Instance.new("Frame", b61)
    b132.Size                = UDim2.new(1, -20, 0, 36)
    b132.Position            = UDim2.new(0, 10, 0, b127)
    b132.BackgroundTransparency = 1
    local b133 = Instance.new("TextLabel", b132)
    b133.Size                = UDim2.new(1, -70, 1, 0)
    b133.BackgroundTransparency = 1
    b133.Text                = b113
    b133.Font                = Enum.Font.GothamBold
    b133.TextSize            = 14
    b133.TextColor3          = Color3.fromRGB(200, 200, 200)
    b133.TextXAlignment      = Enum.TextXAlignment.Left
    return b132, b133
end

local b134 = {}

local function b135(b61, b70, b136, b137, b138)
    local b139 = b70.X.Offset or 56
    local b140 = b70.Y.Offset or 28
    local b141 = b140 - 6
    local b142 = 3
    local b143 = b139 - b141 - 3
    local b144 = Instance.new("Frame", b61)
    b144.Size             = UDim2.new(0, b139, 0, b140)
    b144.Position         = b136
    b144.AnchorPoint      = Vector2.new(0.5, 0.5)
    b144.BorderSizePixel  = 0
    b144.BackgroundColor3 = b137 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70)
    b60(b144, b140 / 2)
    local b145 = Instance.new("Frame", b144)
    b145.Size             = UDim2.new(0, b141, 0, b141)
    b145.Position         = UDim2.new(0, b137 and b143 or b142, 0.5, 0)
    b145.AnchorPoint      = Vector2.new(0, 0.5)
    b145.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    b145.BorderSizePixel  = 0
    b60(b145, b141 / 2)
    local b146 = Instance.new("TextButton", b144)
    b146.Size                = UDim2.new(1, 0, 1, 0)
    b146.BackgroundTransparency = 1
    b146.Text                = ""
    b146.ZIndex              = b144.ZIndex + 2
    local b147 = { value = b137, track = b144, knob = b145, offX = b142, onX = b143 }
    b134[b146] = b147
    if b138 then
        b146.MouseButton1Click:Connect(function()
            b147.value = not b147.value
            b43(b144, b39.Fast, { BackgroundColor3 = b147.value and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70) })
            b43(b145, b39.Fast, { Position = UDim2.new(0, b147.value and b143 or b142, 0.5, 0) })
            b138(b147.value)
        end)
    end
    return b146, b144, b145, b147
end

local function b148(b147, b137)
    if not b147 then return end
    b147.value = b137
    b43(b147.track, b39.Fast, { BackgroundColor3 = b137 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70) })
    b43(b147.knob, b39.Fast, { Position = UDim2.new(0, b137 and b147.onX or b147.offX, 0.5, 0) })
end

local b149 = b6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
if b149 then b149:Destroy() end

local b150 = Instance.new("ScreenGui")
b150.Name           = "UniversalUtility"
b150.ResetOnSpawn   = false
b150.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then
    syn.protect_gui(b150); b150.Parent = b6
elseif gethui then
    b150.Parent = gethui()
else
    b150.Parent = b6
end

local b151 = Instance.new("Frame", b150)
b151.Name              = "MainFrame"
b151.Size              = UDim2.new(0, 0, 0, 0)
b151.Position          = UDim2.new(0, 0, 0, 0)
b151.BackgroundColor3  = Color3.fromRGB(25, 25, 30)
b151.BorderSizePixel   = 0
b151.Active            = true
b151.ClipsDescendants  = true
b151.Visible           = false
b60(b151, 16)

b102(b151, b33)

b56 = Instance.new("UIScale", b151)
b56.Scale = 1

local b152 = Instance.new("ImageLabel", b151)
b152.BackgroundTransparency = 1
b152.Position               = UDim2.new(0, -15, 0, -15)
b152.Size                   = UDim2.new(1, 30, 1, 30)
b152.ZIndex                 = 0
b152.Image                  = "rbxassetid://6014261993"
b152.ImageColor3            = Color3.fromRGB(0, 0, 0)
b152.ImageTransparency      = 0.5
b152.ScaleType              = Enum.ScaleType.Slice
b152.SliceCenter            = Rect.new(49, 49, 450, 450)

local b153 = Instance.new("Frame", b151)
b153.Size             = UDim2.new(1, 0, 0, 40)
b153.Position         = UDim2.new(0, 0, 0, 5)
b153.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
b153.BorderSizePixel  = 0
b60(b153, 16)
b64(b153, Color3.fromRGB(35, 35, 42), Color3.fromRGB(30, 30, 37), 90)

local b154 = Instance.new("TextLabel", b153)
b154.Size              = UDim2.new(1, -60, 1, 0)
b154.Position          = UDim2.new(0, 15, 0, 0)
b154.BackgroundTransparency = 1
b154.Text              = "⚡ Universal Utility"
b154.Font              = Enum.Font.GothamBold
b154.TextSize          = 24
b154.TextColor3        = Color3.fromRGB(255, 255, 255)
b154.TextXAlignment    = Enum.TextXAlignment.Left

local b155 = Instance.new("ImageButton", b153)
b155.Size               = UDim2.new(0, 30, 0, 30)
b155.Position           = UDim2.new(1, -12.5, 0.5, 0)
b155.AnchorPoint        = Vector2.new(1, 0.5)
b155.BackgroundColor3   = Color3.fromRGB(220, 50, 50)
b155.BorderSizePixel    = 0
b155.Image              = "rbxassetid://3926305904"
b155.ImageRectOffset    = Vector2.new(284, 4)
b155.ImageRectSize      = Vector2.new(24, 24)
b155.ImageColor3        = Color3.fromRGB(255, 255, 255)
b60(b155, 8)

local b156 = Instance.new("Frame", b151)
b156.Size             = UDim2.new(0, 180, 1, -57)
b156.Position         = UDim2.new(0, 2.5, 0, 50)
b156.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
b156.BorderSizePixel  = 0
b60(b156, 12)
b64(b156, Color3.fromRGB(30, 30, 35), Color3.fromRGB(25, 25, 30), 90)

local b157 = Instance.new("Frame", b151)
b157.Size                 = UDim2.new(1, -185, 1, -40)
b157.Position             = UDim2.new(0, 183, 0, 50)
b157.BackgroundTransparency = 1
b157.BorderSizePixel      = 0
b157.ClipsDescendants     = true

local b158 = Instance.new("ImageButton", b150)
b158.Name             = "ReopenButton"
b158.Size             = UDim2.new(0, 0, 0, 0)
b158.Position         = UDim2.new(0, 0, 0, 0)
b158.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
b158.BorderSizePixel  = 0
b158.Visible          = false
b158.ZIndex           = 10
b158.Active           = true
b158.ImageTransparency = 1
b60(b158, 100)
b64(b158, Color3.fromRGB(100, 150, 255), Color3.fromRGB(80, 130, 235), 45)

local b159 = Instance.new("TextLabel", b158)
b159.Size                = UDim2.new(1, 0, 1, 0)
b159.BackgroundTransparency = 1
b159.Text                = "⚡"
b159.Font                = Enum.Font.GothamBold
b159.TextSize            = 24
b159.TextColor3          = Color3.fromRGB(255, 255, 255)
b159.TextTransparency    = 1

local b160, b161, b162, b163, b164 = false, nil, nil, nil, false
local b165 = nil

b158.InputBegan:Connect(function(b166)
    if b166.UserInputType == Enum.UserInputType.MouseButton1 or b166.UserInputType == Enum.UserInputType.Touch then
        b160 = true
        b164 = false
        b161 = b166.Position
        b162 = b158.Position
        if b163 then b163:Disconnect() end
        b163 = b3.InputChanged:Connect(function(b167)
            if (b167.UserInputType == Enum.UserInputType.MouseMovement or b167.UserInputType == Enum.UserInputType.Touch) and b160 then
                local b168 = b167.Position - b161
                if math.abs(b168.X) > 5 or math.abs(b168.Y) > 5 then b164 = true end
                b158.Position = UDim2.new(0, b162.X.Offset + b168.X, 0, b162.Y.Offset + b168.Y)
            end
        end)
        b166.Changed:Connect(function()
            if b166.UserInputState == Enum.UserInputState.End then
                b160 = false
                if b163 then b163:Disconnect(); b163 = nil end
                task.wait(0.1)
                if b164 then
                    b21.SavedReopenPosition = { X = b158.Position.X.Offset, Y = b158.Position.Y.Offset }
                    b33()
                end
                b164 = false
            end
        end)
    end
end)

local b169 = {}
local b170 = {}
local b171 = {}

_G.UU.UI = {
    ScreenGui    = b150,
    MainFrame    = b151,
    ContentFrame = b157,
    SideNav      = b156,
    CloseButton  = b155,
    ReopenButton = b158,
    TabButtons   = b169,
    TabContents  = b170,
    TweenPresets = b39,
    ActiveTweens = b40,
    PlayTween    = b43,
    CancelTween  = b41,
    UIScale      = b56,
    AllFrames    = b171,
}

local function b172(b173, b174, b175)
    local b176 = Instance.new("TextButton", b156)
    b176.Name              = b173.."Tab"
    b176.Size              = UDim2.new(1, -10, 0, 55)
    b176.Position          = UDim2.new(0, 5, 0, 5 + ((b175 - 1) * 60))
    b176.BackgroundColor3  = Color3.fromRGB(35, 35, 42)
    b176.BorderSizePixel   = 0
    b176.Text              = ""
    b176.AutoButtonColor   = false
    b60(b176, 8)
    local b177 = Instance.new("TextLabel", b176)
    b177.Size              = UDim2.new(0, 30, 1, 0)
    b177.Position          = UDim2.new(0, 10, 0, 0)
    b177.BackgroundTransparency = 1
    b177.Text              = b174
    b177.Font              = Enum.Font.GothamBold
    b177.TextSize          = 24
    b177.TextColor3        = Color3.fromRGB(180, 180, 180)
    b177.TextXAlignment    = Enum.TextXAlignment.Left
    local b178 = Instance.new("TextLabel", b176)
    b178.Size              = UDim2.new(1, -50, 1, 0)
    b178.Position          = UDim2.new(0, 45, 0, 0)
    b178.BackgroundTransparency = 1
    b178.Text              = b173
    b178.Font              = Enum.Font.GothamBold
    b178.TextSize          = 13
    b178.TextColor3        = Color3.fromRGB(180, 180, 180)
    b178.TextXAlignment    = Enum.TextXAlignment.Left
    b169[b173] = { Button = b176, Icon = b177, Label = b178 }
    b171["Tab_"..b173] = b176
    b176.MouseEnter:Connect(function()
        if b21.CurrentTab ~= b173 then
            b43(b176, b39.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52) })
            b43(b177, b39.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200) })
            b43(b178, b39.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200) })
        end
    end)
    b176.MouseLeave:Connect(function()
        if b21.CurrentTab ~= b173 then
            b43(b176, b39.Fast, { BackgroundColor3 = Color3.fromRGB(35, 35, 42) })
            b43(b177, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
            b43(b178, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        end
    end)
    return b176
end

local function b179(b173)
    local b180 = Instance.new("ScrollingFrame", b157)
    b180.Name                  = b173.."Content"
    b180.Size                  = UDim2.new(1, -10, 1, -10)
    b180.Position              = UDim2.new(0, 5, 0, 5)
    b180.BackgroundTransparency = 1
    b180.BorderSizePixel       = 0
    b180.ScrollBarThickness    = 4
    b180.ScrollBarImageColor3  = Color3.fromRGB(100, 150, 255)
    b180.ScrollBarImageTransparency = 0.5
    b180.CanvasSize            = UDim2.new(0, 0, 0, 0)
    b180.Visible               = false
    b180.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    local b181 = Instance.new("UIListLayout", b180)
    b181.SortOrder = Enum.SortOrder.LayoutOrder
    b181.Padding   = UDim.new(0, 10)
    b170[b173] = b180
    b171["Content_"..b173] = b180
    return b180
end

local b182 = {
    { name = "Home",               icon = "🏠", order = 1 },
    { name = "Anti-AFK",           icon = "⚡", order = 2 },
    { name = "KeySpam",            icon = "⌨️", order = 3 },
    { name = "Performance Status", icon = "📊", order = 4 },
    { name = "Auto Rejoin",        icon = "🔄", order = 5 },
    { name = "Script Loader",      icon = "💾", order = 6 },
    { name = "Settings",           icon = "⚙️", order = 7 },
}

for b183, b184 in ipairs(b182) do
    b172(b184.name, b184.icon, b184.order)
    b179(b184.name)
end

local b185, b186, b187 = {}, {}, {}
local b188, b189, b190, b191 = {}, {}, {}, {}

do
    local b192 = b170["Home"]
    local b193 = b122(b192, 200, 1)
    b171["Home_Card1"] = b193

    local b194 = Instance.new("ImageLabel", b193)
    b194.Size             = UDim2.new(0, 120, 0, 140)
    b194.Position         = UDim2.new(0, 10, 0, 10)
    b194.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b194.BorderSizePixel  = 0
    b194.Image            = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    b60(b194, 10)
    Instance.new("UIStroke", b194).Color = Color3.fromRGB(100, 150, 255)

    local b195 = Instance.new("TextLabel", b193)
    b195.Size              = UDim2.new(1, -145, 0, 22)
    b195.Position          = UDim2.new(0, 140, 0, 10)
    b195.BackgroundTransparency = 1
    b195.Text              = b12
    b195.Font              = Enum.Font.GothamBold
    b195.TextSize          = 28
    b195.TextColor3        = Color3.fromRGB(255, 255, 255)
    b195.TextXAlignment    = Enum.TextXAlignment.Left

    local b196 = Instance.new("TextLabel", b193)
    b196.Size              = UDim2.new(1, -145, 0, 16)
    b196.Position          = UDim2.new(0, 140, 0, 33)
    b196.BackgroundTransparency = 1
    b196.Text              = "User ID: "..b13
    b196.Font              = Enum.Font.Gotham
    b196.TextSize          = 12
    b196.TextColor3        = Color3.fromRGB(150, 150, 150)
    b196.TextXAlignment    = Enum.TextXAlignment.Left

    local b197 = Instance.new("TextLabel", b193)
    b197.Size = UDim2.new(1, -145, 0, 18); b197.Position = UDim2.new(0, 140, 0, 55)
    b197.BackgroundTransparency = 1; b197.Text = "FPS: 60"
    b197.Font = Enum.Font.Gotham; b197.TextSize = 16
    b197.TextColor3 = Color3.fromRGB(100, 200, 255); b197.TextXAlignment = Enum.TextXAlignment.Left

    local b198 = Instance.new("TextLabel", b193)
    b198.Size = UDim2.new(1, -145, 0, 18); b198.Position = UDim2.new(0, 140, 0, 70)
    b198.BackgroundTransparency = 1; b198.Text = "Ping: 0 ms"
    b198.Font = Enum.Font.Gotham; b198.TextSize = 16
    b198.TextColor3 = Color3.fromRGB(0, 255, 0); b198.TextXAlignment = Enum.TextXAlignment.Left

    local b199 = Instance.new("TextLabel", b193)
    b199.Size = UDim2.new(1, -145, 0, 18); b199.Position = UDim2.new(0, 140, 0, 90)
    b199.BackgroundTransparency = 1; b199.Text = "Memory: 0 MB"
    b199.Font = Enum.Font.Gotham; b199.TextSize = 16
    b199.TextColor3 = Color3.fromRGB(255, 180, 100); b199.TextXAlignment = Enum.TextXAlignment.Left

    local b200, b201 = "Unknown", "N/A"
    if identifyexecutor then b200, b201 = identifyexecutor()
    elseif getexecutorname then b200 = getexecutorname() end

    local b202 = Instance.new("TextLabel", b193)
    b202.Size = UDim2.new(1, -145, 0, 18); b202.Position = UDim2.new(0, 140, 0, 105)
    b202.BackgroundTransparency = 1; b202.Text = "Executor: "..b200.." "..b201
    b202.Font = Enum.Font.Gotham; b202.TextSize = 14
    b202.TextColor3 = Color3.fromRGB(255, 100, 200); b202.TextXAlignment = Enum.TextXAlignment.Left

    local b203 = Instance.new("TextLabel", b193)
    b203.Size = UDim2.new(1, -145, 0, 18); b203.Position = UDim2.new(0, 140, 0, 125)
    b203.BackgroundTransparency = 1; b203.Text = "Device: "..b19()
    b203.Font = Enum.Font.Gotham; b203.TextSize = 14
    b203.TextColor3 = Color3.fromRGB(180, 255, 150); b203.TextXAlignment = Enum.TextXAlignment.Left

    local b204 = b54()
    local b205 = Instance.new("TextLabel", b193)
    b205.Size = UDim2.new(1, -145, 0, 16); b205.Position = UDim2.new(0, 140, 0, 140)
    b205.BackgroundTransparency = 1; b205.Text = string.format("Resolution: %dx%d", b204.X, b204.Y)
    b205.Font = Enum.Font.Gotham; b205.TextSize = 12
    b205.TextColor3 = Color3.fromRGB(120, 120, 120); b205.TextXAlignment = Enum.TextXAlignment.Left

    local b206 = b122(b192, 220, 2)
    b171["Home_Card2"] = b206

    local b207 = Instance.new("ImageLabel", b206)
    b207.Size = UDim2.new(0, 120, 0, 140); b207.Position = UDim2.new(0, 10, 0, 10)
    b207.BackgroundColor3 = Color3.fromRGB(45, 45, 52); b207.BorderSizePixel = 0
    b207.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    b60(b207, 10); Instance.new("UIStroke", b207).Color = Color3.fromRGB(100, 150, 255)

    local b208 = Instance.new("TextLabel", b206)
    b208.Size = UDim2.new(1, -145, 0, 24); b208.Position = UDim2.new(0, 140, 0, 10)
    b208.BackgroundTransparency = 1; b208.Text = "Loading game info..."
    b208.Font = Enum.Font.GothamBold; b208.TextSize = 24
    b208.TextColor3 = Color3.fromRGB(255, 255, 255); b208.TextXAlignment = Enum.TextXAlignment.Left
    b208.TextWrapped = true

    local b209 = Instance.new("TextLabel", b206)
    b209.Size = UDim2.new(1, -145, 0, 18); b209.Position = UDim2.new(0, 140, 0, 50)
    b209.BackgroundTransparency = 1; b209.Text = "Place ID: "..game.PlaceId
    b209.Font = Enum.Font.Gotham; b209.TextSize = 18
    b209.TextColor3 = Color3.fromRGB(150, 180, 255); b209.TextXAlignment = Enum.TextXAlignment.Left

    local b210 = Instance.new("TextLabel", b206)
    b210.Size = UDim2.new(1, -145, 0, 18); b210.Position = UDim2.new(0, 140, 0, 85)
    b210.BackgroundTransparency = 1; b210.Text = "Server Players: "..#b1:GetPlayers()
    b210.Font = Enum.Font.Gotham; b210.TextSize = 18
    b210.TextColor3 = Color3.fromRGB(150, 255, 180); b210.TextXAlignment = Enum.TextXAlignment.Left

    local b211 = Instance.new("TextLabel", b206)
    b211.Size = UDim2.new(1, -145, 0, 16); b211.Position = UDim2.new(0, 140, 0, 130)
    b211.BackgroundTransparency = 1; b211.Text = "JobId: "..game.JobId
    b211.Font = Enum.Font.Gotham; b211.TextSize = 11
    b211.TextColor3 = Color3.fromRGB(255, 180, 180); b211.TextXAlignment = Enum.TextXAlignment.Left
    b211.TextTruncate = Enum.TextTruncate.AtEnd

    local function b212()
        b210.Text = "Players: "..#b1:GetPlayers()
    end
    table.insert(_G.UU.Connections, b1.PlayerAdded:Connect(b212))
    table.insert(_G.UU.Connections, b1.PlayerRemoving:Connect(b212))

    _G.UU.UI.PlayerImage  = b194
    _G.UU.UI.GameName     = b208
    _G.UU.UI.GameImage    = b207
    _G.UU.UI.ResolutionLabel = b205
    _G.UU.UI.DeviceLabel  = b203
    b185.FPSLabel         = b197
    b185.PingLabel        = b198
    b185.MemoryLabel      = b199
end

do
    local b213 = b170["Anti-AFK"]
    local b214 = b122(b213, 450, 1)
    b171["AntiAFK_Card"] = b214

    local b215 = b129(b214, "⚡ Anti-AFK System", 8)
    b215.TextColor3 = Color3.fromRGB(100, 200, 255)
    b126(b214, "Prevent disconnections by simulating player activity", 34)

    local b216, _ = b131(b214, "Auto Jump", 60)
    local b217, __, b218, b219 = b135(b216, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), b21.JumpEnabled, nil)

    local b220, _ = b131(b214, "Auto Click", 102)
    local b221, __, b222, b223 = b135(b220, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), b21.ClickEnabled, nil)

    b116(b214, 150)
    b119(b214, "Click Position Mode", 162)

    local function b224(b225, b226)
        local b227 = Instance.new("TextButton", b214)
        b227.Size             = UDim2.new(0, 85, 0, 30)
        b227.Position         = UDim2.new(b225, 0, 0, b226)
        b227.AnchorPoint      = Vector2.new(0.5, 0)
        b227.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        b227.Font             = Enum.Font.GothamBold
        b227.TextSize         = 13
        b227.TextColor3       = Color3.fromRGB(255, 255, 255)
        b227.BorderSizePixel  = 0
        b227.AutoButtonColor  = false
        b60(b227, 8)
        return b227
    end

    local b228 = b224(0.2, 190); b228.Text = "Current"
    local b229 = b224(0.5, 190); b229.Text = "Center"
    local b230 = b224(0.8, 190); b230.Text = "Random"

    b116(b214, 233)

    local b231, b232, b233, b234, b235 = b69(b214, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 248), 10, "Jump Interval (seconds)")
    local b236, b237, b238, b239, b240 = b69(b214, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 315), 3, "Click Interval (seconds)")

    local b241, b242 = b111(b214, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 380), "Status: All Inactive")

    b186 = {
        JumpToggleBtn      = b217,
        JumpToggleState    = b219,
        ClickToggleBtn     = b221,
        ClickToggleState   = b223,
        ClickTypeCurrent   = b228,
        ClickTypeCenter    = b229,
        ClickTypeRandom    = b230,
        JumpDelaySlider    = b232,
        JumpSliderFill     = b233,
        JumpSliderButton   = b234,
        JumpDelayBox       = b235,
        ClickDelaySlider   = b237,
        ClickSliderFill    = b238,
        ClickSliderButton  = b239,
        ClickDelayBox      = b240,
        Status             = b242,
    }
end

do
    local b243 = b170["KeySpam"]
    local b244 = b122(b243, 330, 1)
    b171["KeySpam_Card"] = b244

    local b245 = b129(b244, "⌨️ Key Spam Controller", 8)
    b245.TextColor3 = Color3.fromRGB(255, 200, 100)
    b126(b244, "Automatically spam any keyboard key at custom intervals", 34)

    b119(b244, "Target Key", 60)

    local b246 = Instance.new("TextBox", b244)
    b246.Size             = UDim2.new(1, -20, 0, 40)
    b246.Position         = UDim2.new(0, 10, 0, 82)
    b246.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b246.Text             = b21.SpamKey
    b246.PlaceholderText  = "Enter key (A-Z, 0-9, F1-F12)"
    b246.Font             = Enum.Font.Gotham
    b246.TextSize         = 14
    b246.TextColor3       = Color3.fromRGB(255, 255, 255)
    b246.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    b246.BorderSizePixel  = 0
    b246.ClearTextOnFocus = false
    b60(b246, 8)
    Instance.new("UIStroke", b246).Color = Color3.fromRGB(60, 60, 70)

    b116(b244, 135)

    local b247, b248, b249, b250, b251 = b69(b244, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 150), 0.1, "Spam Interval (seconds)")

    local b252, _ = b131(b244, "Auto Spam", 215)
    local b253, __, b254, b255 = b135(b252, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), b21.AutoSpamEnabled, nil)

    local b256, b257 = b111(b244, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 265), "Status: Inactive")

    b187 = {
        SpamInput          = b246,
        SpamDelaySlider    = b248,
        SpamSliderFill     = b249,
        SpamSliderButton   = b250,
        SpamDelayBox       = b251,
        AutoSpamToggleBtn  = b253,
        AutoSpamToggleState = b255,
        Status             = b257,
    }
end

do
    local b258 = b170["Performance Status"]
    local b259 = b122(b258, 660, 1)
    b171["Performance_Card"] = b259

    local b260 = b129(b259, "📊 Performance Monitor", 8)
    b260.TextColor3 = Color3.fromRGB(100, 255, 150)
    b126(b259, "Track real-time performance metrics and unlock FPS limits", 34)

    local b261, _ = b131(b259, "FPS Unlock", 60)
    local b262, __, b263, b264 = b135(b261, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), b21.FPSUnlockEnabled, nil)

    local b265 = Instance.new("TextLabel", b259)
    b265.Size              = UDim2.new(1, -20, 0, 20)
    b265.Position          = UDim2.new(0, 10, 0, 102)
    b265.BackgroundTransparency = 1
    b265.Text              = "Current Limit: 60 FPS"
    b265.Font              = Enum.Font.Gotham
    b265.TextSize          = 13
    b265.TextColor3        = Color3.fromRGB(180, 180, 180)
    b265.TextXAlignment    = Enum.TextXAlignment.Center

    local b266, b267, b268, b269, b270 = b69(b259, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 135), 60, "Target FPS Limit")

    b116(b259, 200)
    b119(b259, "Framerate Statistics", 210)

    local b271 = Instance.new("Frame", b259)
    b271.Size = UDim2.new(1, -20, 0, 50); b271.Position = UDim2.new(0, 10, 0, 235)
    b271.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b271.BorderSizePixel = 0
    b60(b271, 8); Instance.new("UIStroke", b271).Color = Color3.fromRGB(50, 50, 60)

    local function b272(b273, b274, b275, b276)
        local b277 = Instance.new("TextLabel", b273)
        b277.Size = UDim2.new(b274[3], 0, 1, 0); b277.Position = UDim2.new(b274[1], 0, 0, 0)
        b277.BackgroundTransparency = 1; b277.Text = b275
        b277.Font = Enum.Font.GothamBold; b277.TextSize = 13
        b277.TextColor3 = b276; b277.TextXAlignment = Enum.TextXAlignment.Center
        return b277
    end

    local b278 = b272(b271, {0,    0, 0.33}, "Current: 60",      Color3.fromRGB(100, 200, 255))
    local b279 = b272(b271, {0.33, 0, 0.33}, "Average: 60",      Color3.fromRGB(50,  220, 100))
    local b280 = b272(b271, {0.66, 0, 0.34}, "Min: 60 | Max: 60",Color3.fromRGB(255, 200, 100))

    b116(b259, 300); b119(b259, "Network Latency Statistics", 310)

    local b281 = Instance.new("Frame", b259)
    b281.Size = UDim2.new(1, -20, 0, 50); b281.Position = UDim2.new(0, 10, 0, 335)
    b281.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b281.BorderSizePixel = 0
    b60(b281, 8); Instance.new("UIStroke", b281).Color = Color3.fromRGB(50, 50, 60)

    local b282 = b272(b281, {0,    0, 0.33}, "Current: 0ms",         Color3.fromRGB(100, 200, 255))
    local b283 = b272(b281, {0.33, 0, 0.33}, "Average: 0ms",         Color3.fromRGB(50,  220, 100))
    local b284 = b272(b281, {0.66, 0, 0.34}, "Min: 0ms | Max: 0ms",  Color3.fromRGB(255, 200, 100))

    local b285 = Instance.new("Frame", b259)
    b285.Size = UDim2.new(1, -20, 0, 50); b285.Position = UDim2.new(0, 10, 0, 400)
    b285.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b285.BorderSizePixel = 0
    b60(b285, 8); Instance.new("UIStroke", b285).Color = Color3.fromRGB(50, 50, 60)

    b272(b285, {0, 0, 0.5}, "Connection Quality", Color3.fromRGB(255, 255, 255))
    local b286 = b272(b285, {0.5, 0, 0.5}, "Excellent", Color3.fromRGB(50, 220, 100))

    b116(b259, 460); b119(b259, "Memory Usage Statistics", 470)

    local b287 = Instance.new("Frame", b259)
    b287.Size = UDim2.new(1, -20, 0, 50); b287.Position = UDim2.new(0, 10, 0, 495)
    b287.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b287.BorderSizePixel = 0
    b60(b287, 8); Instance.new("UIStroke", b287).Color = Color3.fromRGB(50, 50, 60)

    local b288 = b272(b287, {0,   0, 0.5}, "Current: 0 MB", Color3.fromRGB(255, 180, 100))
    local b289 = b272(b287, {0.5, 0, 0.5}, "Peak: 0 MB",    Color3.fromRGB(255, 150, 50))

    local b290 = Instance.new("TextLabel", b259)
    b290.Size = UDim2.new(1, -20, 0, 60); b290.Position = UDim2.new(0, 10, 0, 555)
    b290.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b290.BorderSizePixel = 0
    b290.Text = "Performance monitoring tracks your game's framerate, network latency, and memory usage in real-time.\n\nLowering FPS limits reduces memory usage."
    b290.Font = Enum.Font.Gotham; b290.TextSize = 12
    b290.TextColor3 = Color3.fromRGB(200, 180, 150); b290.TextWrapped = true
    b290.TextXAlignment = Enum.TextXAlignment.Left; b290.TextYAlignment = Enum.TextYAlignment.Top
    b60(b290, 8); Instance.new("UIStroke", b290).Color = Color3.fromRGB(50, 50, 60)
    local b291 = Instance.new("UIPadding", b290)
    b291.PaddingLeft = UDim.new(0, 10); b291.PaddingRight  = UDim.new(0, 10)
    b291.PaddingTop  = UDim.new(0, 10); b291.PaddingBottom = UDim.new(0, 10)

    b188 = {
        FPSToggleBtn    = b262,
        FPSToggleState  = b264,
        FPSUnlockStatus = b265,
        FPSSlider       = b267,
        FPSFill         = b268,
        FPSButton       = b269,
        FPSValueBox     = b270,
        FPSStats        = { Current = b278, Avg = b279, MinMax = b280 },
        PingStats       = { Current = b282, Avg = b283, MinMax = b284, Quality = b286 },
        MemoryStats     = { Current = b288, Peak = b289 },
    }
end

do
    local b292 = b170["Auto Rejoin"]
    local b293 = b122(b292, 270, 1)
    b171["AutoRejoin_Card"] = b293

    local b294 = b129(b293, "🔄 Auto Rejoin System", 8)
    b294.TextColor3 = Color3.fromRGB(150, 200, 255)
    b126(b293, "Automatically reconnect when disconnected from the server", 34)

    local b295, _ = b131(b293, "Auto Rejoin", 65)
    local b296, __, b297, b298 = b135(b295, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), b21.AutoRejoinEnabled, nil)

    local b299, b300 = b111(b293, UDim2.new(1, -20, 0, 105), UDim2.new(0, 10, 0, 120),
        "Status: Disabled\n\nWhen enabled, automatically rejoins the current server when disconnected.")

    b189 = {
        AutoRejoinToggleBtn   = b296,
        AutoRejoinToggleState = b298,
        Status                = b300,
    }
end

do
    local b301 = b170["Script Loader"]
    local b302 = b122(b301, 480, 1)
    b171["ScriptLoader_Card"] = b302

    local b303 = b129(b302, "💾 Script Executor", 8)
    b303.TextColor3 = Color3.fromRGB(200, 150, 255)
    b126(b302, "Execute custom Lua scripts with auto-save and auto-load capabilities", 34)

    local b304 = Instance.new("Frame", b302)
    b304.Size             = UDim2.new(1, -20, 0, 220)
    b304.Position         = UDim2.new(0, 10, 0, 60)
    b304.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b304.BorderSizePixel  = 0
    b60(b304, 8)
    Instance.new("UIStroke", b304).Color = Color3.fromRGB(60, 60, 70)

    local b305 = Instance.new("ScrollingFrame", b304)
    b305.Size             = UDim2.new(0, 40, 1, 0)
    b305.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    b305.BorderSizePixel  = 0
    b305.ScrollBarThickness = 0
    b305.ScrollingEnabled = false
    b305.CanvasSize       = UDim2.new(0, 0, 0, 220)
    b60(b305, 8)

    local b306 = Instance.new("TextLabel", b305)
    b306.Size              = UDim2.new(1, -5, 1, 0)
    b306.BackgroundTransparency = 1
    b306.Text              = "1"
    b306.Font              = Enum.Font.Code
    b306.TextSize          = 12
    b306.TextColor3        = Color3.fromRGB(120, 120, 120)
    b306.TextXAlignment    = Enum.TextXAlignment.Right
    b306.TextYAlignment    = Enum.TextYAlignment.Top

    local b307 = Instance.new("Frame", b304)
    b307.Size             = UDim2.new(0, 1, 1, 0)
    b307.Position         = UDim2.new(0, 40, 0, 0)
    b307.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    b307.BorderSizePixel  = 0

    local b308 = Instance.new("ScrollingFrame", b304)
    b308.Size             = UDim2.new(1, -41, 1, 0)
    b308.Position         = UDim2.new(0, 41, 0, 0)
    b308.BackgroundTransparency = 1
    b308.BorderSizePixel  = 0
    b308.ScrollBarThickness = 4
    b308.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    b308.ScrollBarImageTransparency = 0.5
    b308.CanvasSize       = UDim2.new(0, 0, 0, 220)

    local b309 = Instance.new("TextBox", b308)
    b309.Size             = UDim2.new(1, -10, 1, 0)
    b309.Position         = UDim2.new(0, 5, 0, 0)
    b309.BackgroundTransparency = 1
    b309.Text             = b21.SavedCode
    b309.PlaceholderText  = "-- Paste your Lua code here..."
    b309.Font             = Enum.Font.Code
    b309.TextSize         = 12
    b309.TextColor3       = Color3.fromRGB(255, 255, 255)
    b309.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    b309.BorderSizePixel  = 0
    b309.TextWrapped      = true
    b309.TextXAlignment   = Enum.TextXAlignment.Left
    b309.TextYAlignment   = Enum.TextYAlignment.Top
    b309.MultiLine        = true
    b309.ClearTextOnFocus = false
    b309.TextEditable     = true

    local b310 = Instance.new("TextButton", b302)
    b310.Size             = UDim2.new(0.5, -15, 0, 36)
    b310.Position         = UDim2.new(0, 10, 0, 300)
    b310.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    b310.Text             = "▶  Execute"
    b310.Font             = Enum.Font.GothamBold
    b310.TextSize         = 14
    b310.TextColor3       = Color3.fromRGB(255, 255, 255)
    b310.BorderSizePixel  = 0
    b310.AutoButtonColor  = false
    b60(b310, 8)
    b310.MouseEnter:Connect(function() b43(b310, b39.Fast, { BackgroundColor3 = Color3.fromRGB(120, 170, 255) }) end)
    b310.MouseLeave:Connect(function() b43(b310, b39.Fast, { BackgroundColor3 = Color3.fromRGB(100, 150, 255) }) end)

    local b311, _ = b131(b302, "Auto Load", 300)
    b311.Size = UDim2.new(0.5, -15, 0, 36); b311.Position = UDim2.new(0.5, 5, 0, 300)
    local b312, __, b313, b314 = b135(b311, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), b21.AutoLoadEnabled, nil)

    local b315, b316 = b111(b302, UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 355), "Status: Ready")

    local b317 = Instance.new("TextLabel", b302)
    b317.Size = UDim2.new(1, -20, 0, 60); b317.Position = UDim2.new(0, 10, 0, 405)
    b317.BackgroundTransparency = 1
    b317.Text = "Code is auto-saved while typing. Enable Auto Load to execute on rejoin."
    b317.Font = Enum.Font.Gotham; b317.TextSize = 12
    b317.TextColor3 = Color3.fromRGB(130, 130, 130)
    b317.TextXAlignment = Enum.TextXAlignment.Center; b317.TextWrapped = true

    b190 = {
        LoadStringBox          = b309,
        LineNumbers            = b306,
        LoadStringScrollFrame  = b308,
        LineNumbersScrollFrame = b305,
        ExecuteButton          = b310,
        AutoLoadToggleBtn      = b312,
        AutoLoadToggleState    = b314,
        Status                 = b316,
    }
end

do
    local b318 = b170["Settings"]
    local b319 = b122(b318, 270, 1)
    b171["Settings_Card"] = b319

    local b320 = b129(b319, "⚙️ UI Configuration", 8)
    b320.TextColor3 = Color3.fromRGB(255, 180, 100)
    b126(b319, "Customize interface preferences and keybinds", 34)

    b119(b319, "Toggle Keybind", 60)

    local b321 = b22[b21.Keybind] or b21.Keybind.Name
    local b322 = Instance.new("TextButton", b319)
    b322.Size             = UDim2.new(1, -20, 0, 40)
    b322.Position         = UDim2.new(0, 10, 0, 82)
    b322.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    b322.Text             = "Current Key: "..b321
    b322.Font             = Enum.Font.GothamBold
    b322.TextSize         = 13
    b322.TextColor3       = Color3.fromRGB(255, 255, 255)
    b322.BorderSizePixel  = 0
    b322.AutoButtonColor  = false
    b60(b322, 8)
    b322.MouseEnter:Connect(function() b43(b322, b39.Fast, { BackgroundColor3 = Color3.fromRGB(55, 55, 65) }) end)
    b322.MouseLeave:Connect(function() b43(b322, b39.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52) }) end)

    b116(b319, 135)

    local b323, _ = b131(b319, "Auto Hide UI", 150)
    local b324, __, b325, b326 = b135(b323, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), b21.AutoHideEnabled, nil)

    local b327, b328 = b111(b319, UDim2.new(1, -20, 0, 60), UDim2.new(0, 10, 0, 200), "")
    b328.TextColor3 = Color3.fromRGB(150, 150, 150)

    b191 = {
        KeybindButton        = b322,
        AutoHideToggleBtn    = b324,
        AutoHideToggleState  = b326,
        Status               = b328,
    }
end

local b329 = typeof(setfpscap) == "function"
if b329 then
    local b330 = pcall(setfpscap, 60)
    if not b330 then b329 = false end
end

local b331, b332, b333 = {}, {}, 60
local b334, b335, b336 = tick(), 0, 60
local b337 = 0

for b338 = 1, 60 do
    table.insert(b331, 60)
    table.insert(b332, 0)
end

local function b339()
    if not b186.Status then return end
    local b340, b341
    if b21.JumpEnabled and b21.ClickEnabled then
        b340, b341 = "Status: Jump & Click Active", Color3.fromRGB(50, 220, 100)
    elseif b21.JumpEnabled then
        b340, b341 = "Status: Jump Active", Color3.fromRGB(100, 200, 255)
    elseif b21.ClickEnabled then
        b340, b341 = "Status: Click Active", Color3.fromRGB(255, 200, 100)
    else
        b340, b341 = "Status: All Inactive", Color3.fromRGB(180, 180, 180)
    end
    b43(b186.Status, b39.Fast, { TextColor3 = b341 })
    b186.Status.Text = b340
end

local function b342()
    for b343, b344 in pairs({ Current = b186.ClickTypeCurrent, Center = b186.ClickTypeCenter, Random = b186.ClickTypeRandom }) do
        if b344 then
            b43(b344, b39.Fast, { BackgroundColor3 = b21.ClickType == b343 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(45, 45, 52) })
        end
    end
end

local function b345()
    b51("Jump")
    _G.UU.Threads.Jump = task.spawn(function()
        while b21.JumpEnabled do
            task.wait(b21.JumpDelay)
            if b21.JumpEnabled and b11.Character then
                local b346 = b11.Character:FindFirstChildOfClass("Humanoid")
                if b346 then b346:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
        _G.UU.Threads.Jump = nil
    end)
end

local function b347()
    b51("Click")
    _G.UU.Threads.Click = task.spawn(function()
        while b21.ClickEnabled do
            task.wait(b21.ClickDelay)
            if b21.ClickEnabled then
                local b348, b349
                if b21.ClickType == "Current" then
                    local b350 = b3:GetMouseLocation()
                    b348, b349 = b350.X, b350.Y
                elseif b21.ClickType == "Center" then
                    local b351 = workspace.CurrentCamera.ViewportSize
                    b348, b349 = b351.X / 2, b351.Y / 2
                else
                    local b351 = workspace.CurrentCamera.ViewportSize
                    b348, b349 = math.random(100, b351.X - 100), math.random(100, b351.Y - 100)
                end
                b4:SendMouseButtonEvent(b348, b349, 0, true, game, 0)
                task.wait(0.05)
                b4:SendMouseButtonEvent(b348, b349, 0, false, game, 0)
            end
        end
        _G.UU.Threads.Click = nil
    end)
end

local function b352()
    b51("Spam")
    local b353 = b21.SpamKey:upper()
    local b354 = b23[b353]
    if not b354 then return end
    _G.UU.Threads.Spam = task.spawn(function()
        while b21.AutoSpamEnabled do
            task.wait(b21.SpamDelay)
            if b21.AutoSpamEnabled then
                b4:SendKeyEvent(true, b354, false, game)
                task.wait(0.05)
                b4:SendKeyEvent(false, b354, false, game)
            end
        end
        _G.UU.Threads.Spam = nil
    end)
end

local b355 = false
local b356 = nil

local function b357()
    if b356 then pcall(function() b356:Disconnect() end); b356 = nil end
    if not b21.AutoRejoinEnabled then return end
    task.spawn(function()
        local b358 = b6:FindFirstChild("RobloxPromptGui")
        if not b358 then
            local b359, b360 = pcall(function() return b6:WaitForChild("RobloxPromptGui", 10) end)
            if not b359 or not b360 then
                if b189.Status then
                    b189.Status.Text = "Status: Enabled (waiting for prompt GUI...)\n\nAutomatically rejoins when disconnected."
                end
                return
            end
            b358 = b360
        end
        local b361 = b358:FindFirstChild("promptOverlay")
        if not b361 then
            local b362, b363 = pcall(function() return b358:WaitForChild("promptOverlay", 10) end)
            if not b362 or not b363 then
                if b189.Status then
                    b189.Status.Text = "Status: Enabled (prompt overlay unavailable)\n\nAutomatically rejoins when disconnected."
                end
                return
            end
            b361 = b363
        end
        b356 = b361.ChildAdded:Connect(function(b364)
            if b364.Name == "ErrorPrompt" and b21.AutoRejoinEnabled and not b355 then
                b355 = true
                _G.UU.Threads.Rejoin = task.spawn(function()
                    while b21.AutoRejoinEnabled and b355 do
                        b7:Teleport(game.PlaceId, b11)
                        task.wait(2)
                    end
                    _G.UU.Threads.Rejoin = nil
                end)
            end
        end)
    end)
end

local function b365(b366)
    if not b366 or b366 == "" then return false, "Empty script" end
    local b367, b368 = pcall(function()
        local b369, b370 = loadstring(b366)
        if not b369 then error(b370) end
        b369()
    end)
    if b367 then return true, "Executed successfully!" end
    return false, "Error - "..tostring(b368):sub(1, 50).."..."
end

local b371 = { jump = false, click = false, spam = false, fps = false }

local function b372(b373)
    b21.JumpDelay = 5 + (b373 * 25)
    b80(b186.JumpSliderFill, b186.JumpDelayBox, b21.JumpDelay, 5, 30, "%.1f")
    b33()
end

local function b374(b373)
    b21.ClickDelay = 1 + (b373 * 9)
    b80(b186.ClickSliderFill, b186.ClickDelayBox, b21.ClickDelay, 1, 10, "%.1f")
    b33()
end

local function b375(b373)
    b21.SpamDelay = 0.05 + (b373 * 4.95)
    b80(b187.SpamSliderFill, b187.SpamDelayBox, b21.SpamDelay, 0.05, 5, "%.2f")
    b33()
end

local function b376(b373)
    b21.TargetFPS = math.floor(15 + (b373 * 345))
    b80(b188.FPSFill, b188.FPSValueBox, b21.TargetFPS, 15, 360, "%d")
    if b21.FPSUnlockEnabled and b329 then
        pcall(setfpscap, b21.TargetFPS)
        b188.FPSUnlockStatus.Text = "Your target: "..b21.TargetFPS.." FPS"
    end
    b33()
end

b186.JumpSliderButton.MouseButton1Down:Connect(function() b371.jump = true; b87(b186.JumpSliderButton, 0.9) end)
b186.ClickSliderButton.MouseButton1Down:Connect(function() b371.click = true; b87(b186.ClickSliderButton, 0.9) end)
b187.SpamSliderButton.MouseButton1Down:Connect(function() b371.spam = true; b87(b187.SpamSliderButton, 0.9) end)
b188.FPSButton.MouseButton1Down:Connect(function() b371.fps = true; b87(b188.FPSButton, 0.9) end)

table.insert(_G.UU.Connections, b3.InputEnded:Connect(function(b377)
    if b377.UserInputType == Enum.UserInputType.MouseButton1 then
        b371.jump = false; b371.click = false; b371.spam = false; b371.fps = false
    end
end))

table.insert(_G.UU.Connections, b3.InputChanged:Connect(function(b377)
    if b377.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local b378 = b3:GetMouseLocation().X
    if b371.jump and b186.JumpDelaySlider then
        b372(math.clamp((b378 - b186.JumpDelaySlider.AbsolutePosition.X) / b186.JumpDelaySlider.AbsoluteSize.X, 0, 1))
    elseif b371.click and b186.ClickDelaySlider then
        b374(math.clamp((b378 - b186.ClickDelaySlider.AbsolutePosition.X) / b186.ClickDelaySlider.AbsoluteSize.X, 0, 1))
    elseif b371.spam and b187.SpamDelaySlider then
        b375(math.clamp((b378 - b187.SpamDelaySlider.AbsolutePosition.X) / b187.SpamDelaySlider.AbsoluteSize.X, 0, 1))
    elseif b371.fps and b188.FPSSlider then
        b376(math.clamp((b378 - b188.FPSSlider.AbsolutePosition.X) / b188.FPSSlider.AbsoluteSize.X, 0, 1))
    end
end))

b186.JumpDelayBox.FocusLost:Connect(function()
    b372((math.clamp(tonumber(b186.JumpDelayBox.Text) or b21.JumpDelay, 5, 30) - 5) / 25)
end)
b186.ClickDelayBox.FocusLost:Connect(function()
    b374((math.clamp(tonumber(b186.ClickDelayBox.Text) or b21.ClickDelay, 1, 10) - 1) / 9)
end)
b187.SpamDelayBox.FocusLost:Connect(function()
    b375((math.clamp(tonumber(b187.SpamDelayBox.Text) or b21.SpamDelay, 0.05, 5) - 0.05) / 4.95)
end)
b188.FPSValueBox.FocusLost:Connect(function()
    b376((math.clamp(tonumber(b188.FPSValueBox.Text) or b21.TargetFPS, 15, 360) - 15) / 345)
end)
b187.SpamInput.FocusLost:Connect(function()
    b21.SpamKey = b187.SpamInput.Text:upper()
    b33()
end)

local b379 = false
local function b380(b381)
    if b379 or b21.ClickType == b381 then return end
    b379 = true; b21.ClickType = b381; b342(); b33()
    task.delay(0.1, function() b379 = false end)
end

b186.ClickTypeCurrent.MouseButton1Click:Connect(function() b380("Current") end)
b186.ClickTypeCenter.MouseButton1Click:Connect(function()  b380("Center")  end)
b186.ClickTypeRandom.MouseButton1Click:Connect(function()  b380("Random")  end)

b186.JumpToggleBtn.MouseButton1Click:Connect(function()
    if not b48("Jump", 0.3) then return end
    b21.JumpEnabled = not b21.JumpEnabled
    b148(b186.JumpToggleState, b21.JumpEnabled)
    if b21.JumpEnabled then task.wait(0.05); b345() else b51("Jump") end
    b339(); b33()
end)

b186.ClickToggleBtn.MouseButton1Click:Connect(function()
    if not b48("Click", 0.3) then return end
    b21.ClickEnabled = not b21.ClickEnabled
    b148(b186.ClickToggleState, b21.ClickEnabled)
    if b21.ClickEnabled then task.wait(0.05); b347() else b51("Click") end
    b339(); b33()
end)

b187.AutoSpamToggleBtn.MouseButton1Click:Connect(function()
    if not b48("Spam", 0.3) then return end
    b21.AutoSpamEnabled = not b21.AutoSpamEnabled
    if b21.AutoSpamEnabled then
        local b382 = b187.SpamInput.Text:upper()
        local b383 = b23[b382]
        if not b383 then
            b21.AutoSpamEnabled = false
            b148(b187.AutoSpamToggleState, false)
            b187.Status.Text = "Status: Invalid key"
            b43(b187.Status, b39.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            return
        end
        if b383 == Enum.KeyCode.P or b383 == b21.Keybind then
            b21.AutoSpamEnabled = false
            b148(b187.AutoSpamToggleState, false)
            b187.Status.Text = "Status: Key reserved"
            b43(b187.Status, b39.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            return
        end
        b21.SpamKey = b382
        b148(b187.AutoSpamToggleState, true)
        b187.Status.Text = "Status: Spamming "..b382
        b43(b187.Status, b39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        task.wait(0.05); b352()
    else
        b148(b187.AutoSpamToggleState, false)
        b187.Status.Text = "Status: Inactive"
        b43(b187.Status, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        b51("Spam")
    end
    b33()
end)

b188.FPSToggleBtn.MouseButton1Click:Connect(function()
    if not b48("FPS", 0.3) then return end
    if not b329 then
        b188.FPSUnlockStatus.Text = "FPS Unlock not supported"
        b43(b188.FPSUnlockStatus, b39.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
        return
    end
    b21.FPSUnlockEnabled = not b21.FPSUnlockEnabled
    b148(b188.FPSToggleState, b21.FPSUnlockEnabled)
    if b21.FPSUnlockEnabled then
        pcall(setfpscap, b21.TargetFPS)
        b188.FPSUnlockStatus.Text = "Your target: "..b21.TargetFPS.." FPS"
        b43(b188.FPSUnlockStatus, b39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
    else
        pcall(setfpscap, 60)
        b188.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
        b43(b188.FPSUnlockStatus, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    b33()
end)

b189.AutoRejoinToggleBtn.MouseButton1Click:Connect(function()
    if not b48("Rejoin", 0.3) then return end
    b21.AutoRejoinEnabled = not b21.AutoRejoinEnabled
    b148(b189.AutoRejoinToggleState, b21.AutoRejoinEnabled)
    if b21.AutoRejoinEnabled then
        b189.Status.Text = "Status: Enabled\n\nAutomatically rejoins when disconnected."
        b43(b189.Status, b39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        b357()
    else
        b355 = false; b51("Rejoin")
        if b356 then pcall(function() b356:Disconnect() end); b356 = nil end
        b189.Status.Text = "Status: Disabled\n\nWhen enabled, automatically rejoins the current server when disconnected."
        b43(b189.Status, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    b33()
end)

b190.ExecuteButton.MouseButton1Click:Connect(function()
    if not b48("Execute", 0.5) then return end
    local b384 = b190.LoadStringBox.Text
    b190.Status.Text = "Status: Executing..."
    b43(b190.Status, b39.Fast, { TextColor3 = Color3.fromRGB(255, 200, 100) })
    b43(b190.ExecuteButton, b39.Medium, { BackgroundColor3 = Color3.fromRGB(255, 200, 100) })
    local b385, b386 = b365(b384)
    local b387 = b385 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    b190.Status.Text = "Status: "..b386
    b43(b190.Status, b39.Fast, { TextColor3 = b387 })
    b43(b190.ExecuteButton, b39.Medium, { BackgroundColor3 = b387 })
    task.wait(2)
    if b190.Status.Text:match("Error") or b190.Status.Text:match("successfully") then
        b190.Status.Text = "Status: Ready"
        b43(b190.Status, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        b43(b190.ExecuteButton, b39.Medium, { BackgroundColor3 = Color3.fromRGB(100, 150, 255) })
    end
end)

b190.AutoLoadToggleBtn.MouseButton1Click:Connect(function()
    if not b48("AutoLoad", 0.3) then return end
    b21.AutoLoadEnabled = not b21.AutoLoadEnabled
    b148(b190.AutoLoadToggleState, b21.AutoLoadEnabled)
    local b388, b389
    if b21.AutoLoadEnabled then
        if b21.SavedCode and b21.SavedCode ~= "" then
            b388, b389 = "Auto-load enabled", Color3.fromRGB(50, 220, 100)
        else
            b388, b389 = "No code to auto-load", Color3.fromRGB(220, 50, 50)
        end
    else
        b388, b389 = "Auto-load disabled", Color3.fromRGB(180, 180, 180)
    end
    b190.Status.Text = "Status: "..b388
    b43(b190.Status, b39.Fast, { TextColor3 = b389 })
    task.wait(2)
    if b190.Status.Text:match("enabled") or b190.Status.Text:match("disabled") or b190.Status.Text:match("code") then
        b190.Status.Text = "Status: Ready"
        b43(b190.Status, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    b33()
end)

b190.LoadStringBox:GetPropertyChangedSignal("Text"):Connect(function()
    if _G.UU.Threads.SaveCode then
        pcall(task.cancel, _G.UU.Threads.SaveCode)
        _G.UU.Threads.SaveCode = nil
    end
    _G.UU.Threads.SaveCode = task.delay(1.0, function()
        _G.UU.Threads.SaveCode = nil
        b21.SavedCode = b190.LoadStringBox.Text
        b33()
        b190.Status.Text = "Status: Code auto-saved ✓"
        b43(b190.Status, b39.Fast, { TextColor3 = Color3.fromRGB(100, 200, 255) })
        task.wait(2)
        if b190.Status.Text == "Status: Code auto-saved ✓" then
            b190.Status.Text = "Status: Ready"
            b43(b190.Status, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        end
    end)
    b91(b190.LoadStringBox, b190.LineNumbers, b190.LoadStringScrollFrame, b190.LineNumbersScrollFrame)
end)

b190.LoadStringScrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    b190.LineNumbersScrollFrame.CanvasPosition = Vector2.new(0, b190.LoadStringScrollFrame.CanvasPosition.Y)
end)

b191.KeybindButton.MouseButton1Click:Connect(function()
    if not b48("Keybind", 0.5) or b21.IsChangingKeybind then return end
    b21.IsChangingKeybind = true
    b191.KeybindButton.Text   = "Press any key..."
    b191.Status.Text          = "Waiting for input..."
    b43(b191.Status, b39.Fast, { TextColor3 = Color3.fromRGB(255, 200, 100) })
    b191.KeybindButton.Active = false
    local b390
    local b391 = task.delay(5, function()
        _G.UU.Threads.KeybindTimeout = nil
        if b390 then b390:Disconnect() end
        b21.IsChangingKeybind    = false
        b191.KeybindButton.Active = true
        b191.KeybindButton.Text  = "Current Key: "..(b22[b21.Keybind] or b21.Keybind.Name)
        b191.Status.Text         = "Timed out."
        b43(b191.Status, b39.Fast, { TextColor3 = Color3.fromRGB(255, 100, 100) })
        task.wait(2)
        if b191.Status.Text == "Timed out." then
            b191.Status.Text      = b21.AutoHideEnabled and "Auto Hide enabled — UI starts hidden on next execution." or "Auto Hide disabled — UI shows normally on start."
            b43(b191.Status, b39.Fast, { TextColor3 = b21.AutoHideEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(180, 180, 180) })
        end
    end)
    _G.UU.Threads.KeybindTimeout = b391
    b390 = b3.InputBegan:Connect(function(b392, b393)
        if b392.UserInputType == Enum.UserInputType.Keyboard and not b393 then
            if _G.UU.Threads.KeybindTimeout then
                pcall(task.cancel, _G.UU.Threads.KeybindTimeout)
                _G.UU.Threads.KeybindTimeout = nil
            end
            b21.Keybind              = b392.KeyCode
            local b394              = b22[b392.KeyCode] or b392.KeyCode.Name
            b191.KeybindButton.Text  = "Current Key: "..b394
            b191.Status.Text         = "Keybind changed!"
            b43(b191.Status, b39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
            b33()
            b191.KeybindButton.Active = true
            b390:Disconnect()
            task.delay(0.1, function() b21.IsChangingKeybind = false end)
            task.wait(1.5)
            if b191.Status.Text == "Keybind changed!" then
                b191.Status.Text      = b21.AutoHideEnabled and "Auto Hide enabled — UI starts hidden on next execution." or "Auto Hide disabled — UI shows normally on start."
                b43(b191.Status, b39.Fast, { TextColor3 = b21.AutoHideEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(180, 180, 180) })
            end
        end
    end)
end)

b191.AutoHideToggleBtn.MouseButton1Click:Connect(function()
    if not b48("AutoHide", 0.3) then return end
    b21.AutoHideEnabled = not b21.AutoHideEnabled
    b148(b191.AutoHideToggleState, b21.AutoHideEnabled)
    if b21.AutoHideEnabled then
        b191.Status.Text = "Auto Hide enabled — UI starts hidden on next execution."
        b43(b191.Status, b39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
    else
        b191.Status.Text = "Auto Hide disabled — UI shows normally on start."
        b43(b191.Status, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    b33()
end)

local function b395(b396)
    if b21.CurrentTab == b396 then return end
    if not b48("Tab", 0.15) then return end
    b21.CurrentTab = b396; b33()
    for b397, b398 in pairs(b170) do
        if b397 == b396 then
            b398.Visible  = true
            b398.Position = UDim2.new(0, 15, 0, 0)
            b43(b398, b39.Smooth, { Position = UDim2.new(0, 5, 0, 0) })
        else
            b398.Visible = false
        end
    end
    for b397, b399 in pairs(b169) do
        local b400 = b397 == b396
        b43(b399.Button, b39.Fast, { BackgroundColor3 = b400 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(35, 35, 42) })
        b43(b399.Icon,   b39.Fast, { TextColor3 = b400 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180), TextSize = b400 and 20 or 18 })
        b43(b399.Label,  b39.Fast, { TextColor3 = b400 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180) })
    end
end

for b401, b402 in ipairs(b182) do
    if b169[b402.name] then
        local b403 = b402.name
        b169[b403].Button.MouseButton1Click:Connect(function() b395(b403) end)
    end
end

local b404 = {}
local b405 = false

local function b406()
    if b405 or #b404 == 0 then return end
    b405 = true
    local b407 = table.remove(b404, 1)
    b407()
    task.wait(0.05)
    b405 = false
    if #b404 > 0 then b406() end
end

local function b408(b407)
    table.insert(b404, b407)
    b406()
end

local function b409(b410, b411)
    local b412 = b55.Width * b411
    local b413 = b55.Height * b411
    return math.max(0, (b410.X - b412) / 2), math.max(0, (b410.Y - b413) / 2)
end

local function b414(b410, b411)
    local b415 = math.floor(60 * b411)
    return b415, math.max(0, (b410.X - b415) / 2), math.max(0, math.min(30, b410.Y - b415))
end

local function b416(b417)
    if not b56 then return end
    b43(b56, b39.Smooth, { Scale = b417 })
    b57 = b417
    b159.TextSize = math.floor(24 * b417)
end

local b418 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
local b419 = TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.In,  0, false, 0)

local function b420()
    if not b48("UI", 0.6) then return end
    b408(function()
        if b151.Visible then
            b21.SavedUIPosition = { X = b151.Position.X.Offset, Y = b151.Position.Y.Offset }
            b151.Size = UDim2.new(0, b55.Width, 0, b55.Height)
            local b421 = b43(b56, b419, { Scale = 0 })
            b421.Completed:Wait()
            b151.Visible = false; b56.Scale = 0; b33()

            local b422 = b54()
            local b423 = math.floor(60 * b57)
            local b424, b425
            if b21.SavedReopenPosition then
                b424 = b21.SavedReopenPosition.X
                b425 = b21.SavedReopenPosition.Y
            else
                local _, b426, b427 = b414(b422, b57)
                b424, b425 = b426, b427
            end
            b158.Size = UDim2.new(0, b423, 0, b423)
            b158.Position = UDim2.new(0, b424, 0, b425)
            b158.ImageTransparency = 1; b159.TextTransparency = 1
            b158.Rotation = -180; b158.Visible = true
            local b428 = b2:Create(b158, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, b423, 0, b423),
                Position = UDim2.new(0, b424, 0, b425),
                ImageTransparency = 0, Rotation = 0,
            })
            local b429 = b2:Create(b159, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
            b428:Play(); task.delay(0.15, function() b429:Play() end); b428.Completed:Wait()
        else
            if b165 then b165:Disconnect(); b165 = nil end
            b21.SavedReopenPosition = { X = b158.Position.X.Offset, Y = b158.Position.Y.Offset }
            local b430 = b2:Create(b158, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0, b158.Position.X.Offset, 0, b158.Position.Y.Offset),
                ImageTransparency = 1, Rotation = 90,
            })
            local b431 = b2:Create(b159, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
            b431:Play(); b430:Play(); b430.Completed:Wait()
            b158.Visible = false; b158.Rotation = 0; b158.ImageTransparency = 0; b159.TextTransparency = 0; b33()
            b151.Visible = true; b151.Size = UDim2.new(0, b55.Width, 0, b55.Height); b56.Scale = 0
            local b432, b433
            if b21.SavedUIPosition then
                b432 = b21.SavedUIPosition.X; b433 = b21.SavedUIPosition.Y
            else
                b432, b433 = b409(b54(), b57)
            end
            b151.Position = UDim2.new(0, b432, 0, b433)
            local b434 = b43(b56, b418, { Scale = b57 })
            b434.Completed:Wait()
        end
    end)
end

b155.MouseButton1Click:Connect(b420)
b155.MouseEnter:Connect(function()    b43(b155, b39.Fast, { BackgroundColor3 = Color3.fromRGB(240, 70, 70),  Size = UDim2.new(0, 34, 0, 34), Rotation = 90 }) end)
b155.MouseLeave:Connect(function()    b43(b155, b39.Fast, { BackgroundColor3 = Color3.fromRGB(220, 50, 50),  Size = UDim2.new(0, 30, 0, 30), Rotation = 0  }) end)
b155.MouseButton1Down:Connect(function() b43(b155, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 28, 0, 28) }) end)
b155.MouseButton1Up:Connect(function()   b43(b155, b39.Fast, { Size = UDim2.new(0, 30, 0, 30) }) end)

b158.MouseButton1Click:Connect(function() if not b164 then b420() end end)

b158.MouseEnter:Connect(function()
    if not b160 then
        local b435 = math.floor(60 * b57)
        b43(b158, b39.Medium, { Size = UDim2.new(0, math.floor(b435 * 1.17), 0, math.floor(b435 * 1.17)) })
        if b165 then b165:Disconnect() end
        b165 = b5.RenderStepped:Connect(function(b436)
            if b158.Visible then
                b158.Rotation = (b158.Rotation + (b436 * 180)) % 360
            else
                if b165 then b165:Disconnect(); b165 = nil end
            end
        end)
    end
end)
b158.MouseLeave:Connect(function()
    if b165 then b165:Disconnect(); b165 = nil end
    if not b160 then
        local b435 = math.floor(60 * b57)
        b43(b158, b39.Medium, { Size = UDim2.new(0, b435, 0, b435), Rotation = 0 })
    end
end)
b158.MouseButton1Down:Connect(function()
    if not b160 then
        local b435 = math.floor(60 * b57)
        b43(b158, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, math.floor(b435 * 0.92), 0, math.floor(b435 * 0.92)) })
    end
end)
b158.MouseButton1Up:Connect(function()
    if not b160 then
        local b435 = math.floor(60 * b57)
        b43(b158, b39.Fast, { Size = UDim2.new(0, b435, 0, b435) })
    end
end)

table.insert(_G.UU.Connections, b3.InputBegan:Connect(function(b437, b438)
    if not b438 and b437.KeyCode == b21.Keybind and not b21.IsChangingKeybind then
        b420()
    end
end))

local b439 = Vector2.new(0, 0)
local b440 = false

local function b441()
    if b440 then return end
    b440 = true
    task.delay(0.1, function()
        b440 = false
        local b442 = b54()
        if math.abs(b442.X - b439.X) < 2 and math.abs(b442.Y - b439.Y) < 2 then return end
        b439 = b442
        local b443 = b58(b442)
        if _G.UU.UI.ResolutionLabel then _G.UU.UI.ResolutionLabel.Text = string.format("Resolution: %dx%d", b442.X, b442.Y) end
        if _G.UU.UI.DeviceLabel    then _G.UU.UI.DeviceLabel.Text     = "Device: "..b19() end
        b416(b443)
        b21.SavedUIPosition     = nil
        b21.SavedReopenPosition = nil
        local b444, b445 = b409(b442, b443)
        b151.Position = UDim2.new(0, b444, 0, b445)
        local b446 = math.floor(60 * b57)
        b444 = math.max(0, (b442.X - b446) / 2)
        b445 = math.max(0, math.min(30, b442.Y - b446))
        b158.Size     = UDim2.new(0, b446, 0, b446)
        b158.Position = UDim2.new(0, b444, 0, b445)
        b33()
    end)
end

if workspace.CurrentCamera then
    table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(b441))
end
table.insert(_G.UU.Connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(b441))
    end
end))

table.insert(_G.UU.Connections, b5.RenderStepped:Connect(function()
    b335 = b335 + 1
    local b447 = tick()
    if b447 - b334 >= 1 then
        b333 = math.floor(b335 / (b447 - b334))
        b335 = 0; b334 = b447
        if b185.FPSLabel then b185.FPSLabel.Text = "FPS: "..b333 end
        table.remove(b331, 1); table.insert(b331, b333)
        local b448, b449, b450 = math.huge, 0, 0
        for _, b451 in ipairs(b331) do
            b448 = math.min(b448, b451); b449 = math.max(b449, b451); b450 = b450 + b451
        end
        local b452 = math.floor(b450 / #b331)
        if b188.FPSStats then
            b188.FPSStats.Current.Text = "Current: "..b333
            b188.FPSStats.Avg.Text     = "Average: "..b452
            b188.FPSStats.MinMax.Text  = string.format("Min: %d | Max: %d", b448, b449)
        end
        local b453 = b10:GetTotalMemoryUsageMb()
        b337 = math.max(b337, b453)
        if b185.MemoryLabel then b185.MemoryLabel.Text = string.format("Memory: %.1f MB", b453) end
        if b188.MemoryStats then
            b188.MemoryStats.Current.Text = string.format("Current: %.1f MB", b453)
            b188.MemoryStats.Peak.Text    = string.format("Peak: %.1f MB", b337)
        end
    end
    if b335 % 30 == 0 then
        local b454 = math.floor(b11:GetNetworkPing() * 1000)
        if b185.PingLabel then
            b185.PingLabel.Text      = "Ping: "..b454.." ms"
            b185.PingLabel.TextColor3 = b454 < 100 and Color3.fromRGB(0, 255, 0) or b454 < 200 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        table.remove(b332, 1); table.insert(b332, b454)
        local b455, b456, b457 = math.huge, 0, 0
        for _, b458 in ipairs(b332) do
            b455 = math.min(b455, b458); b456 = math.max(b456, b458); b457 = b457 + b458
        end
        local b459 = math.floor(b457 / #b332)
        if b188.PingStats then
            b188.PingStats.Current.Text = "Current: "..b454.."ms"
            b188.PingStats.Avg.Text     = "Average: "..b459.."ms"
            b188.PingStats.MinMax.Text  = string.format("Min: %dms | Max: %dms", b455, b456)
            local b460, b461
            if     b454 < 50  then b460, b461 = "Excellent",  Color3.fromRGB(50,  220, 100)
            elseif b454 < 100 then b460, b461 = "Good",       Color3.fromRGB(100, 200, 255)
            elseif b454 < 200 then b460, b461 = "Fair",       Color3.fromRGB(255, 200, 100)
            elseif b454 < 300 then b460, b461 = "Poor",       Color3.fromRGB(255, 150, 50)
            else                   b460, b461 = "Very Poor",  Color3.fromRGB(220, 50,  50)
            end
            b188.PingStats.Quality.Text      = b460
            b188.PingStats.Quality.TextColor3 = b461
        end
    end
end))

local b462 = b36()

if b462 then
    if b191.KeybindButton then b191.KeybindButton.Text = "Current Key: "..(b22[b21.Keybind] or b21.Keybind.Name) end
    if b187.SpamInput     then b187.SpamInput.Text     = b21.SpamKey end
    if b190.LoadStringBox then b190.LoadStringBox.Text = b21.SavedCode end

    b372((b21.JumpDelay  - 5)    / 25)
    b374((b21.ClickDelay - 1)    / 9)
    b375((b21.SpamDelay  - 0.05) / 4.95)
    b376((b21.TargetFPS  - 15)   / 345)
    b342()

    b148(b190.AutoLoadToggleState, b21.AutoLoadEnabled)

    b148(b191.AutoHideToggleState, b21.AutoHideEnabled)
    if b21.AutoHideEnabled then
        b191.Status.Text      = "Auto Hide enabled — UI starts hidden on next execution."
        b191.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
    else
        b191.Status.Text      = "Auto Hide disabled — UI shows normally on start."
        b191.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    end

    if b21.AutoRejoinEnabled then
        b148(b189.AutoRejoinToggleState, true)
        b189.Status.Text      = "Status: Enabled\n\nAutomatically rejoins when disconnected."
        b189.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        b357()
    else
        b148(b189.AutoRejoinToggleState, false)
    end

    if b21.FPSUnlockEnabled and b329 then
        b148(b188.FPSToggleState, true)
        b188.FPSUnlockStatus.TextColor3 = Color3.fromRGB(50, 220, 100)
        b188.FPSUnlockStatus.Text       = "Current Limit: "..b21.TargetFPS.." FPS (Custom)"
        pcall(setfpscap, b21.TargetFPS)
    else
        b148(b188.FPSToggleState, false)
    end

    b148(b186.JumpToggleState, b21.JumpEnabled)
    if b21.JumpEnabled then task.wait(0.1); b345() end

    b148(b186.ClickToggleState, b21.ClickEnabled)
    if b21.ClickEnabled then task.wait(0.1); b347() end

    if b21.AutoSpamEnabled and b23[b21.SpamKey] then
        b148(b187.AutoSpamToggleState, true)
        b187.Status.Text      = "Status: Spamming "..b21.SpamKey
        b187.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        task.wait(0.1); b352()
    else
        b21.AutoSpamEnabled = false
        b148(b187.AutoSpamToggleState, false)
    end

    b339()
else
    b372(0.2); b374(0.22); b375(0.01); b376(0.13)
    b342()
    b148(b186.JumpToggleState,    false)
    b148(b186.ClickToggleState,   false)
    b148(b187.AutoSpamToggleState, false)
    b148(b188.FPSToggleState,     false)
    b148(b189.AutoRejoinToggleState, false)
    b148(b190.AutoLoadToggleState, false)
    b148(b191.AutoHideToggleState, false)
    b188.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
    b191.Status.Text          = "Auto Hide disabled — UI shows normally on start."
    b191.Status.TextColor3    = Color3.fromRGB(180, 180, 180)
    b339()
end

task.spawn(function()
    pcall(function()
        if _G.UU.UI.PlayerImage then
            _G.UU.UI.PlayerImage.Image = "rbxthumb://type=AvatarHeadShot&id="..b13.."&w=420&h=420"
        end
        if _G.UU.UI.GameName and _G.UU.UI.GameImage then
            local b463 = b8:GetProductInfo(game.PlaceId)
            _G.UU.UI.GameName.Text = b463.Name
            if b463.IconImageAssetId and b463.IconImageAssetId ~= 0 then
                _G.UU.UI.GameImage.Image = "rbxthumb://type=Asset&id="..b463.IconImageAssetId.."&w=420&h=420"
            end
        end
    end)
end)

b91(b190.LoadStringBox, b190.LineNumbers, b190.LoadStringScrollFrame, b190.LineNumbersScrollFrame)

b150.Destroying:Connect(function()
    for b464, b15 in pairs(_G.UU.Threads) do
        if b15 and typeof(b15) == "thread" and coroutine.status(b15) ~= "dead" then
            pcall(task.cancel, b15)
        end
        _G.UU.Threads[b464] = nil
    end
    if b356 then pcall(function() b356:Disconnect() end); b356 = nil end
    if b165 then pcall(function() b165:Disconnect() end); b165 = nil end
end)

for b465, b466 in pairs(b170) do b466.Visible = false end
b21.CurrentTab = nil

local b467 = b54()
if b467.X < 100 or b467.Y < 100 then
    repeat task.wait() until workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X > 100
    b467 = b54()
end
b439 = b467
b57 = b58(b467)

task.wait(0.1)

local b468 = not b21.AutoHideEnabled

b467 = b54()
b57 = b58(b467)

b151.Size  = UDim2.new(0, b55.Width, 0, b55.Height)
b56.Scale  = 0

local b469, b470
if b21.SavedUIPosition and b21.SavedUIPosition.X and b21.SavedUIPosition.Y then
    b469 = b21.SavedUIPosition.X
    b470 = b21.SavedUIPosition.Y
else
    b469, b470 = b409(b467, b57)
end
b151.Position = UDim2.new(0, b469, 0, b470)

local b471, b472, b473
if b21.SavedReopenPosition and b21.SavedReopenPosition.X and b21.SavedReopenPosition.Y then
    b471 = math.floor(60 * b57)
    b472 = b21.SavedReopenPosition.X
    b473 = b21.SavedReopenPosition.Y
else
    b471, b472, b473 = b414(b467, b57)
end
b158.Size             = UDim2.new(0, b471, 0, b471)
b158.Position         = UDim2.new(0, b472, 0, b473)
b158.ImageTransparency = 0
b159.TextTransparency  = 0

if b468 then
    b151.Visible = true
    local b474 = b43(b56, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = b57 })
    b474.Completed:Wait()
    b158.Visible = false
else
    b151.Visible = false
    b158.Visible = true
    b158.Size    = UDim2.new(0, b471, 0, b471)
    b158.Position = UDim2.new(0, b472, 0, b473)
end

b395("Home")
b33()

if queue_on_teleport and not _G.UU.TeleportQueued then
    _G.UU.TeleportQueued = true
    pcall(function()
        queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/6942x/UniversalUtility/main/Init.lua", true))()')
    end)
end

_G.UU.Loaded    = true
_G.UU.LoadLock  = false

task.defer(function()
    if b462 and b21.AutoLoadEnabled and b21.SavedCode and b21.SavedCode ~= "" then
        local b475, b476 = b365(b21.SavedCode)
        if b475 then
            b190.Status.Text = "Status: Auto-load executed successfully"
            b43(b190.Status, b39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        else
            b190.Status.Text = "Status: Auto-load failed — "..b476
            b43(b190.Status, b39.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
        end
        task.wait(3)
        b190.Status.Text = "Status: Ready"
        b43(b190.Status, b39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
end)

return _G.UU
