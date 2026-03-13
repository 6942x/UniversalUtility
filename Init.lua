local a = game:GetService("HttpService")
local a1 = game:GetService("Players")
local a2 = game:GetService("TweenService")
local a3 = game:GetService("UserInputService")
local a4 = game:GetService("VirtualInputManager")
local a5 = game:GetService("RunService")
local a6 = game:GetService("CoreGui")
local a7 = game:GetService("TeleportService")
local a8 = game:GetService("MarketplaceService")
local a9 = game:GetService("TextService")
local a10 = game:GetService("Stats")

local a11 = a1.LocalPlayer
if not a11 then
    repeat a11 = a1.LocalPlayer; task.wait() until a11
end

local a12 = a11.Name
local a13 = a11.UserId
if not a12 or a12 == "" then
    repeat a12 = a11.Name; task.wait() until a12 and a12 ~= ""
end

_G.UU = _G.UU or {}

if _G.UU.Loaded then
    if _G.UU.Threads then
        for a14, a15 in pairs(_G.UU.Threads) do
            if a15 and typeof(a15) == "thread" and coroutine.status(a15) ~= "dead" then
                pcall(task.cancel, a15)
            end
            _G.UU.Threads[a14] = nil
        end
    end
    if _G.UU.Connections then
        for a16, a17 in pairs(_G.UU.Connections) do
            pcall(function() a17:Disconnect() end)
        end
        _G.UU.Connections = {}
    end
    _G.UU.TeleportQueued = false
    local a18 = a6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
    if a18 then a18:Destroy() end
    _G.UU.Loaded    = false
    _G.UU.LoadLock  = false
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
_G.UU.SavePending = false
_G.UU.LastSaveTime = 0

local function a19()
    if a3.TouchEnabled and not a3.KeyboardEnabled and not a3.MouseEnabled then return "Mobile"
    elseif a3.GamepadEnabled and not a3.KeyboardEnabled then return "Console"
    elseif a3.KeyboardEnabled and a3.MouseEnabled then return "PC" end
    local a20 = a3:GetLastInputType()
    if a20 == Enum.UserInputType.Touch then return "Mobile"
    elseif a20 == Enum.UserInputType.Gamepad1 or a20 == Enum.UserInputType.Gamepad2 then return "Console" end
    return "PC"
end

local a21 = {
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
_G.UU.CFG = a21

local a22 = {}
local a23 = {}

for a24 = 65, 90 do
    local a25 = string.char(a24)
    a22[Enum.KeyCode[a25]] = a25
    a23[a25] = Enum.KeyCode[a25]
end

local a26 = { "One","Two","Three","Four","Five","Six","Seven","Eight","Nine" }
for a27 = 0, 9 do
    local a28 = a27 == 0 and "Zero" or a26[a27]
    a22[Enum.KeyCode[a28]] = tostring(a27)
    a23[tostring(a27)] = Enum.KeyCode[a28]
end

for a29 = 1, 12 do
    a22[Enum.KeyCode["F"..a29]] = "F"..a29
    a23["F"..a29] = Enum.KeyCode["F"..a29]
end

for a30, a31 in pairs({
    LeftControl="Left Ctrl", RightControl="Right Ctrl",
    LeftShift="Left Shift", RightShift="Right Shift",
    LeftAlt="Left Alt",     RightAlt="Right Alt",
    Tab="Tab",              CapsLock="Caps Lock",
    Space="Space",          Return="Enter",
    Backspace="Backspace",  Delete="Delete",
    Insert="Insert",        Home="Home",
    End="End",              PageUp="Page Up",
    PageDown="Page Down",
}) do a22[Enum.KeyCode[a30]] = a31 end

_G.UU.KCN = a22
_G.UU.KCM = a23

local function a32()
    return "UniversalUtility/Accounts/" .. a12 .. ".json"
end

local function a32_ensureFolders()
    if not (makefolder and isfolder) then return end
    if not isfolder("UniversalUtility") then
        makefolder("UniversalUtility")
    end
    if not isfolder("UniversalUtility/Accounts") then
        makefolder("UniversalUtility/Accounts")
    end
end

local function a33()
    if not writefile then return end
    a32_ensureFolders()
    local a34 = _G.UU.UI and _G.UU.UI.MainFrame
    local a35 = _G.UU.UI and _G.UU.UI.ReopenButton
    if a34 and a34.Visible then
        a21.SavedUIPosition = { X = a34.Position.X.Offset, Y = a34.Position.Y.Offset }
    end
    if a35 and a35.Visible then
        a21.SavedReopenPosition = { X = a35.Position.X.Offset, Y = a35.Position.Y.Offset }
    end
    local a36 = {
        UserId              = a13,
        Username            = a12,
        Keybind             = a21.Keybind.Name,
        ClickType           = a21.ClickType,
        JumpEnabled         = a21.JumpEnabled,
        ClickEnabled        = a21.ClickEnabled,
        AutoRejoinEnabled   = a21.AutoRejoinEnabled,
        FPSUnlockEnabled    = a21.FPSUnlockEnabled,
        AutoSpamEnabled     = a21.AutoSpamEnabled,
        AutoLoadEnabled     = a21.AutoLoadEnabled,
        AutoHideEnabled     = a21.AutoHideEnabled,
        TargetFPS           = a21.TargetFPS,
        JumpDelay           = a21.JumpDelay,
        ClickDelay          = a21.ClickDelay,
        SpamDelay           = a21.SpamDelay,
        SpamKey             = a21.SpamKey,
        SavedCode           = a21.SavedCode,
        CurrentTab          = a21.CurrentTab,
        UIPosition          = a21.UIPosition,
        ReopenPosition      = a21.ReopenPosition,
        SavedUIPosition     = a21.SavedUIPosition,
        SavedReopenPosition = a21.SavedReopenPosition,
    }
    local a37, a38 = pcall(function()
        writefile(a32(), a:JSONEncode(a36))
    end)
    if a37 then
        _G.UU.LastSaveTime = tick()
        _G.UU.SavePending = false
    else
        if _G.UU.AddActivityLog then
            _G.UU.AddActivityLog("Save error: " .. tostring(a38), Color3.fromRGB(220, 80, 80))
        end
    end
    return a37
end
_G.UU.SaveCFG = a33

local _pendingLogs = {}

local function a33_log(a33_msg, a33_col)
    if _G.UU.AddActivityLog then
        _G.UU.AddActivityLog(a33_msg, a33_col)
    else
        table.insert(_pendingLogs, { msg = a33_msg, col = a33_col })
    end
end

local function a33_save_log(a33_action)
    local a33_ok = a33()
    if a33_ok then
        a33_log(a33_action .. " → Saved ✓", Color3.fromRGB(80, 220, 120))
    else
        a33_log(a33_action .. " → Save failed ✗", Color3.fromRGB(220, 80, 80))
    end
end

local function a39()
    if _G.UU.SavePending then return end
    _G.UU.SavePending = true
    local a40 = tick() - _G.UU.LastSaveTime
    if a40 >= 0.1 then
        a33()
    else
        task.delay(0.1 - a40, function()
            if _G.UU.SavePending then
                a33()
            end
        end)
    end
end
_G.UU.DebouncedSave = a39

local function a41()
    if not (readfile and isfile) then return false end
    local a32_path = a32()
    if not isfile(a32_path) then return false end
    local a42, a43 = pcall(function() return a:JSONDecode(readfile(a32_path)) end)
    if not a42 or not a43 or a43.UserId ~= a13 then return false end
    a21.Keybind             = Enum.KeyCode[a43.Keybind] or Enum.KeyCode.G
    a21.ClickType           = a43.ClickType or "Current"
    a21.JumpEnabled         = a43.JumpEnabled or false
    a21.ClickEnabled        = a43.ClickEnabled or false
    a21.AutoRejoinEnabled   = a43.AutoRejoinEnabled or false
    a21.FPSUnlockEnabled    = a43.FPSUnlockEnabled or false
    a21.AutoSpamEnabled     = a43.AutoSpamEnabled or false
    a21.AutoLoadEnabled     = a43.AutoLoadEnabled or false
    a21.AutoHideEnabled     = a43.AutoHideEnabled or false
    a21.TargetFPS           = a43.TargetFPS or 60
    a21.JumpDelay           = a43.JumpDelay or 10.0
    a21.ClickDelay          = a43.ClickDelay or 3.0
    a21.SpamDelay           = a43.SpamDelay or 0.1
    a21.SpamKey             = a43.SpamKey or "Q"
    a21.SavedCode           = a43.SavedCode or ""
    a21.CurrentTab          = a43.CurrentTab or "Home"
    a21.UIPosition          = a43.UIPosition or { X = 0.5, Y = 0.5 }
    a21.ReopenPosition      = a43.ReopenPosition or { X = 0.5, Y = 30 }
    a21.SavedUIPosition     = a43.SavedUIPosition or nil
    a21.SavedReopenPosition = a43.SavedReopenPosition or nil
    return true
end

local a44 = {
    Fast    = TweenInfo.new(0.15, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    Medium  = TweenInfo.new(0.25, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    Slow    = TweenInfo.new(0.35, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out),
    Back    = TweenInfo.new(0.50, Enum.EasingStyle.Back,    Enum.EasingDirection.Out),
    BackIn  = TweenInfo.new(0.35, Enum.EasingStyle.Back,    Enum.EasingDirection.In),
    Elastic = TweenInfo.new(0.60, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Smooth  = TweenInfo.new(0.30, Enum.EasingStyle.Sine,    Enum.EasingDirection.InOut),
}

local a45 = {}

local function a46(a47)
    if a45[a47] then a45[a47]:Cancel(); a45[a47] = nil end
end

local function a48(a47, a49, a50)
    a46(a47)
    local a51 = a2:Create(a47, a49, a50)
    a45[a47] = a51
    a51:Play()
    a51.Completed:Connect(function(a52)
        if a52 == Enum.TweenStatus.Completed then a45[a47] = nil end
    end)
    return a51
end

local function a53(a54, a55)
    if _G.UU.Debounces[a54] then return false end
    _G.UU.Debounces[a54] = true
    task.delay(a55 or 0.3, function() _G.UU.Debounces[a54] = false end)
    return true
end

local function a56(a57)
    if _G.UU.Threads[a57] then
        local a58 = _G.UU.Threads[a57]
        _G.UU.Threads[a57] = nil
        if typeof(a58) == "thread" and coroutine.status(a58) ~= "dead" then
            pcall(task.cancel, a58)
        end
    end
end

local function a59()
    return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
end

local a60 = { Width = 650, Height = 500 }

local a61 = nil
local a62 = 1

local function a63(a64)
    return math.clamp(math.min(a64.X / 1920, a64.Y / 1080), 0.75, 1.4)
end

local function a65(a66, a67)
    local a68 = Instance.new("UICorner", a66)
    a68.CornerRadius = UDim.new(0, a67 or 8)
    return a68
end

local function a69(a66, a70, a71, a72)
    local a73 = Instance.new("UIGradient", a66)
    a73.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, a70),
        ColorSequenceKeypoint.new(1, a71),
    }
    a73.Rotation = a72 or 90
    return a73
end

local function a74(a66, a75, a76, a77, a78, a79_min, a80_max, a81_label)
    local a82 = Instance.new("Frame", a66)
    a82.Size     = a75
    a82.Position = a76
    a82.BackgroundTransparency = 1
    local a83 = Instance.new("TextLabel", a82)
    a83.Size                = UDim2.new(1, 0, 0, 18)
    a83.BackgroundTransparency = 1
    a83.Text                = a81_label or a78
    a83.Font                = Enum.Font.Gotham
    a83.TextSize            = 12
    a83.TextColor3          = Color3.fromRGB(180, 180, 180)
    a83.TextXAlignment      = Enum.TextXAlignment.Left
    local a84 = Instance.new("Frame", a82)
    a84.Size             = UDim2.new(1, -60, 0, 6)
    a84.Position         = UDim2.new(0, 0, 0, 22)
    a84.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    a84.BorderSizePixel  = 0
    a65(a84, 3)
    local a85 = Instance.new("Frame", a84)
    local a86_min = a79_min or 0
    local a87_max = (a80_max or 1) - a86_min
    local a88_init = (a77 - a86_min) / math.max(a87_max, 0.001)
    a85.Size             = UDim2.new(math.clamp(a88_init, 0, 1), 0, 1, 0)
    a85.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    a85.BorderSizePixel  = 0
    a65(a85, 3)
    local a89 = Instance.new("TextButton", a84)
    a89.Size                = UDim2.new(1, 0, 1, 0)
    a89.BackgroundTransparency = 1
    a89.Text                = ""
    local a90 = Instance.new("TextBox", a82)
    a90.Size             = UDim2.new(0, 50, 0, 24)
    a90.Position         = UDim2.new(1, -50, 0, 16)
    a90.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    a90.Text             = tostring(a77)
    a90.Font             = Enum.Font.Gotham
    a90.TextScaled       = true
    a90.TextColor3       = Color3.fromRGB(255, 255, 255)
    a90.ClearTextOnFocus = false
    a90.BorderSizePixel  = 0
    a65(a90, 5)
    return a82, a84, a85, a89, a90
end

local function a91(a92, a93, a94, a95, a96, a97)
    a48(a92, a44.Fast, { Size = UDim2.new((a94 - a95) / (a96 - a95), 0, 1, 0) })
    a93.Text = string.format(a97, a94)
end

local function a91_instant(a92, a93, a94, a95, a96, a97)
    a92.Size = UDim2.new((a94 - a95) / (a96 - a95), 0, 1, 0)
    a93.Text = string.format(a97, a94)
end

local function a98(a99, a100)
    task.spawn(function()
        a100 = a100 or 0.95
        local a101 = a99.Size
        a48(a99, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(a101.X.Scale * a100, a101.X.Offset * a100, a101.Y.Scale * a100, a101.Y.Offset * a100)
        })
        task.wait(0.1)
        a48(a99, a44.Back, { Size = a101 })
    end)
end

local function a102(a103, a104, a105, a106)
    local a107 = a103.Text
    local a108 = 1
    for _ in a107:gmatch("\n") do a108 = a108 + 1 end
    local a109_parts = {}
    for a110 = 1, a108 do a109_parts[a110] = tostring(a110) end
    a104.Text = table.concat(a109_parts, "\n") .. "\n"
    local a111 = a9:GetTextSize(a103.Text, a103.TextSize, a103.Font, Vector2.new(a103.AbsoluteSize.X - 10, math.huge))
    local a112 = math.max(200, a111.Y + 20)
    a103.Size = UDim2.new(1, -10, 0, a112)
    a105.CanvasSize = UDim2.new(0, 0, 0, a112)
    a106.CanvasSize = UDim2.new(0, 0, 0, a112)
    a104.Size = UDim2.new(1, -5, 0, a112)
end

local function a113(a114, a115)
    local a116, a117, a118, a119 = false, nil, nil, nil
    a114.InputBegan:Connect(function(a120)
        if a120.UserInputType == Enum.UserInputType.MouseButton1 or a120.UserInputType == Enum.UserInputType.Touch then
            a116 = true
            a117 = a120.Position
            a118 = a114.Position
            if a119 then a119:Disconnect() end
            a119 = a3.InputChanged:Connect(function(a121)
                if (a121.UserInputType == Enum.UserInputType.MouseMovement or a121.UserInputType == Enum.UserInputType.Touch) and a116 then
                    local a122 = a121.Position - a117
                    a114.Position = UDim2.new(a118.X.Scale, a118.X.Offset + a122.X, a118.Y.Scale, a118.Y.Offset + a122.Y)
                end
            end)
            a120.Changed:Connect(function()
                if a120.UserInputState == Enum.UserInputState.End then
                    a116 = false
                    if a119 then a119:Disconnect(); a119 = nil end
                    if a115 then a115() end
                end
            end)
        end
    end)
end

local function a123(a114, a75, a124, a125)
    local a126 = Instance.new("Frame", a114)
    a126.Size             = a75
    a126.Position         = a124
    a126.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    a126.BorderSizePixel  = 0
    a65(a126, 8)
    Instance.new("UIStroke", a126).Color = Color3.fromRGB(50, 50, 60)
    local a127 = Instance.new("TextLabel", a126)
    a127.Size                = UDim2.new(1, -10, 1, -10)
    a127.Position            = UDim2.new(0, 5, 0, 5)
    a127.BackgroundTransparency = 1
    a127.Text                = a125
    a127.Font                = Enum.Font.GothamBold
    a127.TextSize            = 14
    a127.TextColor3          = Color3.fromRGB(180, 180, 180)
    a127.TextXAlignment      = Enum.TextXAlignment.Center
    a127.TextWrapped         = true
    a127.TextYAlignment      = Enum.TextYAlignment.Top
    return a126, a127
end

local function a128(a114, a129)
    local a130 = Instance.new("Frame", a114)
    a130.Size             = UDim2.new(1, -20, 0, 1)
    a130.Position         = UDim2.new(0, 10, 0, a129)
    a130.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    a130.BorderSizePixel  = 0
    return a130
end

local function a131(a114, a125, a129, a132)
    local a133 = Instance.new("TextLabel", a114)
    a133.Size                = UDim2.new(1, -20, 0, 20)
    a133.Position            = UDim2.new(0, 10, 0, a129)
    a133.BackgroundTransparency = 1
    a133.Text                = a125
    a133.Font                = Enum.Font.GothamBold
    a133.TextSize            = 13
    a133.TextColor3          = a132 or Color3.fromRGB(200, 200, 200)
    a133.TextXAlignment      = Enum.TextXAlignment.Left
    return a133
end

local function a134(a114, a135, a136)
    local a137 = Instance.new("Frame", a114)
    a137.Size             = UDim2.new(1, 0, 0, a135)
    a137.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    a137.BorderSizePixel  = 0
    a137.LayoutOrder      = a136 or 1
    a65(a137, 10)
    a69(a137, Color3.fromRGB(35, 35, 42), Color3.fromRGB(40, 40, 47), 90)
    return a137
end

local function a138(a114, a125, a139)
    local a140 = Instance.new("TextLabel", a114)
    a140.Size                = UDim2.new(1, -20, 0, 16)
    a140.Position            = UDim2.new(0, 10, 0, a139)
    a140.BackgroundTransparency = 1
    a140.Text                = a125
    a140.Font                = Enum.Font.Gotham
    a140.TextSize            = 12
    a140.TextColor3          = Color3.fromRGB(150, 150, 150)
    a140.TextXAlignment      = Enum.TextXAlignment.Left
    return a140
end

local function a141(a114, a125, a139)
    local a142 = Instance.new("TextLabel", a114)
    a142.Size                = UDim2.new(1, -20, 0, 26)
    a142.Position            = UDim2.new(0, 10, 0, a139)
    a142.BackgroundTransparency = 1
    a142.Text                = a125
    a142.Font                = Enum.Font.GothamBold
    a142.TextSize            = 18
    a142.TextXAlignment      = Enum.TextXAlignment.Left
    return a142
end

local function a143(a114, a125, a139)
    local a144 = Instance.new("Frame", a114)
    a144.Size                = UDim2.new(1, -20, 0, 36)
    a144.Position            = UDim2.new(0, 10, 0, a139)
    a144.BackgroundTransparency = 1
    local a145 = Instance.new("TextLabel", a144)
    a145.Size                = UDim2.new(1, -70, 1, 0)
    a145.BackgroundTransparency = 1
    a145.Text                = a125
    a145.Font                = Enum.Font.GothamBold
    a145.TextSize            = 14
    a145.TextColor3          = Color3.fromRGB(200, 200, 200)
    a145.TextXAlignment      = Enum.TextXAlignment.Left
    return a144, a145
end

local a146 = {}

local function a147(a114, a75, a148, a149, a150)
    local a151 = a75.X.Offset or 56
    local a152 = a75.Y.Offset or 28
    local a153 = a152 - 6
    local a154 = 3
    local a155 = a151 - a153 - 3
    local a156 = Instance.new("Frame", a114)
    a156.Size             = UDim2.new(0, a151, 0, a152)
    a156.Position         = a148
    a156.AnchorPoint      = Vector2.new(0.5, 0.5)
    a156.BorderSizePixel  = 0
    a156.BackgroundColor3 = a149 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70)
    a65(a156, a152 / 2)
    local a157 = Instance.new("Frame", a156)
    a157.Size             = UDim2.new(0, a153, 0, a153)
    a157.Position         = UDim2.new(0, a149 and a155 or a154, 0.5, 0)
    a157.AnchorPoint      = Vector2.new(0, 0.5)
    a157.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    a157.BorderSizePixel  = 0
    a65(a157, a153 / 2)
    local a158 = Instance.new("TextButton", a156)
    a158.Size                = UDim2.new(1, 0, 1, 0)
    a158.BackgroundTransparency = 1
    a158.Text                = ""
    a158.ZIndex              = a156.ZIndex + 2
    local a159 = { value = a149, track = a156, knob = a157, offX = a154, onX = a155 }
    a146[a158] = a159
    if a150 then
        a158.MouseButton1Click:Connect(function()
            a159.value = not a159.value
            a48(a156, a44.Fast, { BackgroundColor3 = a159.value and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70) })
            a48(a157, a44.Fast, { Position = UDim2.new(0, a159.value and a155 or a154, 0.5, 0) })
            a150(a159.value)
        end)
    end
    return a158, a156, a157, a159
end

local function a160(a159, a149)
    if not a159 then return end
    a159.value = a149
    a48(a159.track, a44.Fast, { BackgroundColor3 = a149 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70) })
    a48(a159.knob, a44.Fast, { Position = UDim2.new(0, a149 and a159.onX or a159.offX, 0.5, 0) })
end

local function a498(a498_btn, a498_idle, a498_hover, a498_press)
    a498_btn.MouseEnter:Connect(function()
        a48(a498_btn, a44.Fast, a498_hover)
    end)
    a498_btn.MouseLeave:Connect(function()
        a48(a498_btn, a44.Fast, a498_idle)
    end)
    a498_btn.MouseButton1Down:Connect(function()
        a48(a498_btn, a44.Fast, a498_press)
    end)
    a498_btn.MouseButton1Up:Connect(function()
        a48(a498_btn, a44.Fast, a498_hover)
    end)
end

local function a499(a499_parent, a499_size, a499_pos, a499_barColor)
    local a499_outer = Instance.new("Frame", a499_parent)
    a499_outer.Size             = a499_size
    a499_outer.Position         = a499_pos
    a499_outer.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    a499_outer.BorderSizePixel  = 0
    a65(a499_outer, 8)
    Instance.new("UIStroke", a499_outer).Color = Color3.fromRGB(50, 50, 60)

    local a499_scroll = Instance.new("ScrollingFrame", a499_outer)
    a499_scroll.Size                     = UDim2.new(1, -4, 1, -4)
    a499_scroll.Position                 = UDim2.new(0, 2, 0, 2)
    a499_scroll.BackgroundTransparency   = 1
    a499_scroll.BorderSizePixel          = 0
    a499_scroll.ScrollBarThickness       = 3
    a499_scroll.ScrollBarImageColor3     = a499_barColor or Color3.fromRGB(100, 150, 255)
    a499_scroll.ScrollBarImageTransparency = 0.5
    a499_scroll.CanvasSize               = UDim2.new(0, 0, 0, 0)
    a499_scroll.AutomaticCanvasSize      = Enum.AutomaticSize.Y

    local a499_layout = Instance.new("UIListLayout", a499_scroll)
    a499_layout.SortOrder = Enum.SortOrder.LayoutOrder
    a499_layout.Padding   = UDim.new(0, 2)

    local a499_pad = Instance.new("UIPadding", a499_scroll)
    a499_pad.PaddingLeft   = UDim.new(0, 6)
    a499_pad.PaddingRight  = UDim.new(0, 6)
    a499_pad.PaddingTop    = UDim.new(0, 4)
    a499_pad.PaddingBottom = UDim.new(0, 4)

    local a499_empty = Instance.new("TextLabel", a499_scroll)
    a499_empty.Size                  = UDim2.new(1, 0, 0, 20)
    a499_empty.BackgroundTransparency = 1
    a499_empty.Font                  = Enum.Font.Code
    a499_empty.TextSize              = 11
    a499_empty.TextColor3            = Color3.fromRGB(90, 90, 100)
    a499_empty.TextXAlignment        = Enum.TextXAlignment.Left
    a499_empty.LayoutOrder           = 1

    local a499_count = 1

    local function a499_add(a499_msg, a499_col)
        a499_empty.Visible = false
        a499_count = a499_count + 1
        local a499_ts  = os.date and os.date("%H:%M:%S") or "—"
        local a499_line = Instance.new("TextLabel", a499_scroll)
        a499_line.Size                  = UDim2.new(1, 0, 0, 0)
        a499_line.AutomaticSize         = Enum.AutomaticSize.Y
        a499_line.BackgroundTransparency = 1
        a499_line.Text                  = "["..a499_ts.."] "..a499_msg
        a499_line.Font                  = Enum.Font.Code
        a499_line.TextSize              = 11
        a499_line.TextColor3            = a499_col or Color3.fromRGB(220, 220, 220)
        a499_line.TextXAlignment        = Enum.TextXAlignment.Left
        a499_line.TextYAlignment        = Enum.TextYAlignment.Top
        a499_line.TextWrapped           = true
        a499_line.RichText              = false
        a499_line.LayoutOrder           = a499_count
        task.defer(function() a499_scroll.CanvasPosition = Vector2.new(0, math.huge) end)
        return a499_line
    end

    local a499_clear = Instance.new("TextButton", a499_parent)
    a499_clear.Size             = UDim2.new(0, 50, 0, 18)
    a499_clear.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    a499_clear.Text             = "Clear"
    a499_clear.Font             = Enum.Font.Gotham
    a499_clear.TextSize         = 11
    a499_clear.TextColor3       = Color3.fromRGB(180, 180, 180)
    a499_clear.BorderSizePixel  = 0
    a499_clear.AutoButtonColor  = false
    a65(a499_clear, 4)
    a498(a499_clear,
        { BackgroundColor3 = Color3.fromRGB(60,  60,  70),  Size = UDim2.new(0, 50, 0, 18) },
        { BackgroundColor3 = Color3.fromRGB(80,  80,  90),  Size = UDim2.new(0, 55, 0, 21) },
        { BackgroundColor3 = Color3.fromRGB(100, 100, 110), Size = UDim2.new(0, 45, 0, 15) }
    )

    a499_clear.MouseButton1Click:Connect(function()
        for _, a499_ch in ipairs(a499_scroll:GetChildren()) do
            if a499_ch:IsA("TextLabel") and a499_ch ~= a499_empty then
                a499_ch:Destroy()
            end
        end
        a499_count = 1
        a499_empty.Visible = true
    end)

    return a499_outer, a499_scroll, a499_empty, a499_add, a499_clear
end

local a161 = a6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
if a161 then a161:Destroy() end

local a162 = Instance.new("ScreenGui")
a162.Name           = "UniversalUtility"
a162.ResetOnSpawn   = false
a162.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then
    syn.protect_gui(a162); a162.Parent = a6
elseif gethui then
    a162.Parent = gethui()
else
    a162.Parent = a6
end

local a163 = Instance.new("Frame", a162)
a163.Name              = "MainFrame"
a163.Size              = UDim2.new(0, 0, 0, 0)
a163.Position          = UDim2.new(0, 0, 0, 0)
a163.BackgroundColor3  = Color3.fromRGB(25, 25, 30)
a163.BorderSizePixel   = 0
a163.Active            = true
a163.ClipsDescendants  = true
a163.Visible           = false
a65(a163, 16)

a113(a163, a39)

a61 = Instance.new("UIScale", a163)
a61.Scale = 1

local a164 = Instance.new("ImageLabel", a163)
a164.BackgroundTransparency = 1
a164.Position               = UDim2.new(0, -15, 0, -15)
a164.Size                   = UDim2.new(1, 30, 1, 30)
a164.ZIndex                 = 0
a164.Image                  = "rbxassetid://6014261993"
a164.ImageColor3            = Color3.fromRGB(0, 0, 0)
a164.ImageTransparency      = 0.5
a164.ScaleType              = Enum.ScaleType.Slice
a164.SliceCenter            = Rect.new(49, 49, 450, 450)

local a165 = Instance.new("Frame", a163)
a165.Size             = UDim2.new(1, 0, 0, 46)
a165.Position         = UDim2.new(0, 0, 0, 0)
a165.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
a165.BorderSizePixel  = 0
a65(a165, 16)
a69(a165, Color3.fromRGB(38, 38, 46), Color3.fromRGB(30, 30, 37), 90)

do
    local a166 = Instance.new("TextLabel", a165)
    a166.Size              = UDim2.new(1, -60, 1, 0)
    a166.Position          = UDim2.new(0, 14, 0, 0)
    a166.BackgroundTransparency = 1
    a166.Text              = "⚡ Universal Utility"
    a166.Font              = Enum.Font.GothamBold
    a166.TextSize          = 22
    a166.TextColor3        = Color3.fromRGB(255, 255, 255)
    a166.TextXAlignment    = Enum.TextXAlignment.Left
end

local a167 = Instance.new("ImageButton", a165)
a167.Size               = UDim2.new(0, 28, 0, 28)
a167.Position           = UDim2.new(1, -14, 0.5, 0)
a167.AnchorPoint        = Vector2.new(1, 0.5)
a167.BackgroundColor3   = Color3.fromRGB(220, 50, 50)
a167.BorderSizePixel    = 0
a167.Image              = "rbxassetid://3926305904"
a167.ImageRectOffset    = Vector2.new(284, 4)
a167.ImageRectSize      = Vector2.new(24, 24)
a167.ImageColor3        = Color3.fromRGB(255, 255, 255)
a65(a167, 8)

local a168 = Instance.new("Frame", a163)
a168.Size             = UDim2.new(0, 178, 1, -52)
a168.Position         = UDim2.new(0, 5, 0, 52)
a168.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
a168.BorderSizePixel  = 0
a65(a168, 10)
a69(a168, Color3.fromRGB(30, 30, 35), Color3.fromRGB(25, 25, 30), 90)

local a169 = Instance.new("Frame", a163)
a169.Size                 = UDim2.new(1, -193, 1, -57)
a169.Position             = UDim2.new(0, 188, 0, 52)
a169.BackgroundTransparency = 1
a169.BorderSizePixel      = 0
a169.ClipsDescendants     = true

local a170 = Instance.new("ImageButton", a162)
a170.Name             = "ReopenButton"
a170.Size             = UDim2.new(0, 0, 0, 0)
a170.Position         = UDim2.new(0, 0, 0, 0)
a170.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
a170.BorderSizePixel  = 0
a170.Visible          = false
a170.ZIndex           = 10
a170.Active           = true
a170.ImageTransparency = 1
a65(a170, 100)
a69(a170, Color3.fromRGB(100, 150, 255), Color3.fromRGB(80, 130, 235), 45)

local a171 = Instance.new("TextLabel", a170)
a171.Size                = UDim2.new(1, 0, 1, 0)
a171.BackgroundTransparency = 1
a171.Text                = "⚡"
a171.Font                = Enum.Font.GothamBold
a171.TextSize            = 24
a171.TextColor3          = Color3.fromRGB(255, 255, 255)
a171.TextTransparency    = 1

local a172, a173, a174, a175, a176 = false, nil, nil, nil, false
local a177 = nil
local a177_spinActive = false

local function a177_stopSpin()
    if a177 then
        a177:Disconnect()
        a177 = nil
    end
    a177_spinActive = false
end

local function a177_startSpin()
    if a177_spinActive then return end
    a177_spinActive = true
    if a177 then a177:Disconnect() end
    a177 = a5.RenderStepped:Connect(function(a457)
        if a170.Visible then
            a170.Rotation = (a170.Rotation + (a457 * 180)) % 360
        else
            a177_stopSpin()
        end
    end)
end

a170.InputBegan:Connect(function(a178)
    if a178.UserInputType == Enum.UserInputType.MouseButton1 or a178.UserInputType == Enum.UserInputType.Touch then
        a172 = true
        a176 = false
        a173 = a178.Position
        a174 = a170.Position
        a177_startSpin()
        if a175 then a175:Disconnect() end
        a175 = a3.InputChanged:Connect(function(a179)
            if (a179.UserInputType == Enum.UserInputType.MouseMovement or a179.UserInputType == Enum.UserInputType.Touch) and a172 then
                local a180 = a179.Position - a173
                if math.abs(a180.X) > 5 or math.abs(a180.Y) > 5 then a176 = true end
                a170.Position = UDim2.new(0, a174.X.Offset + a180.X, 0, a174.Y.Offset + a180.Y)
            end
        end)
        a178.Changed:Connect(function()
            if a178.UserInputState == Enum.UserInputState.End or a178.UserInputState == Enum.UserInputState.Cancel then
                a172 = false
                if a175 then a175:Disconnect(); a175 = nil end
                local a456_inner = math.floor(60 * a62)
                local mousePos = a3:GetMouseLocation()
                local btnPos = a170.AbsolutePosition
                local btnSize = a170.AbsoluteSize
                local isHovered = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X
                    and mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
                if isHovered then
                    a48(a170, a44.Medium, { Size = UDim2.new(0, math.floor(a456_inner * 1.17), 0, math.floor(a456_inner * 1.17)) })
                    a177_startSpin()
                else
                    a48(a170, a44.Medium, { Size = UDim2.new(0, a456_inner, 0, a456_inner), Rotation = 0 })
                end
                task.wait(0.1)
                if a176 then
                    a21.SavedReopenPosition = { X = a170.Position.X.Offset, Y = a170.Position.Y.Offset }
                    a33()
                end
                a176 = false
            end
        end)
    end
end)

a170.MouseEnter:Connect(function()
    if not a172 then
        local a456 = math.floor(60 * a62)
        a48(a170, a44.Medium, { Size = UDim2.new(0, math.floor(a456 * 1.17), 0, math.floor(a456 * 1.17)) })
        a177_startSpin()
    end
end)

a170.MouseLeave:Connect(function()
    if not a172 then
        a177_stopSpin()
        local a456 = math.floor(60 * a62)
        a48(a170, a44.Medium, { Size = UDim2.new(0, a456, 0, a456), Rotation = 0 })
    end
end)

a170.MouseButton1Down:Connect(function()
    if not a172 then
        local a456 = math.floor(60 * a62)
        a48(a170, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, math.floor(a456 * 0.92), 0, math.floor(a456 * 0.92)) })
    end
end)

a170.MouseButton1Up:Connect(function()
    if not a172 then
        local a456 = math.floor(60 * a62)
        a48(a170, a44.Fast, { Size = UDim2.new(0, a456, 0, a456) })
    end
end)

local a181 = {}
local a182 = {}
local a183 = {}

_G.UU.UI = {
    ScreenGui    = a162,
    MainFrame    = a163,
    ContentFrame = a169,
    SideNav      = a168,
    CloseButton  = a167,
    ReopenButton = a170,
    TabButtons   = a181,
    TabContents  = a182,
    TweenPresets = a44,
    ActiveTweens = a45,
    PlayTween    = a48,
    CancelTween  = a46,
    UIScale      = a61,
    AllFrames    = a183,
}

local function a184(a185, a186, a187)
    local a188 = Instance.new("TextButton", a168)
    a188.Name              = a185.."Tab"
    a188.Size              = UDim2.new(1, -10, 0, 50)
    a188.Position          = UDim2.new(0.5, 0, 0, 8 + ((a187 - 1) * 55) + 27)
    a188.AnchorPoint       = Vector2.new(0.5, 0.5)
    a188.BackgroundColor3  = Color3.fromRGB(35, 35, 42)
    a188.BorderSizePixel   = 0
    a188.Text              = ""
    a188.AutoButtonColor   = false
    a65(a188, 8)
    local a189 = Instance.new("TextLabel", a188)
    a189.Size              = UDim2.new(0, 30, 1, 0)
    a189.Position          = UDim2.new(0, 10, 0, 0)
    a189.BackgroundTransparency = 1
    a189.Text              = a186
    a189.Font              = Enum.Font.GothamBold
    a189.TextSize          = 18
    a189.TextColor3        = Color3.fromRGB(180, 180, 180)
    a189.TextXAlignment    = Enum.TextXAlignment.Left
    local a190 = Instance.new("TextLabel", a188)
    a190.Size              = UDim2.new(1, -50, 1, 0)
    a190.Position          = UDim2.new(0, 45, 0, 0)
    a190.BackgroundTransparency = 1
    a190.Text              = a185
    a190.Font              = Enum.Font.GothamBold
    a190.TextSize          = 13
    a190.TextColor3        = Color3.fromRGB(180, 180, 180)
    a190.TextXAlignment    = Enum.TextXAlignment.Left
    a181[a185] = { Button = a188, Icon = a189, Label = a190 }
    a183["Tab_"..a185] = a188

    a188.MouseEnter:Connect(function()
        local sel = a21.CurrentTab == a185
        if sel then
            a48(a188, a44.Fast, { Size = UDim2.new(1, -4, 0, 54) })
            a48(a189, a44.Fast, { TextSize = 21 })
            a48(a190, a44.Fast, { TextSize = 14 })
        else
            a48(a188, a44.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52), Size = UDim2.new(1, -4, 0, 54) })
            a48(a189, a44.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 21 })
            a48(a190, a44.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 14 })
        end
    end)
    a188.MouseLeave:Connect(function()
        local sel = a21.CurrentTab == a185
        if sel then
            a48(a188, a44.Fast, { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(1, -10, 0, 50) })
            a48(a189, a44.Fast, { TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18 })
            a48(a190, a44.Fast, { TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13 })
        else
            a48(a188, a44.Fast, { BackgroundColor3 = Color3.fromRGB(35, 35, 42), Size = UDim2.new(1, -10, 0, 50) })
            a48(a189, a44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 18 })
            a48(a190, a44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13 })
        end
    end)
    a188.MouseButton1Down:Connect(function()
        local sel = a21.CurrentTab == a185
        if sel then
            a48(a188, a44.Fast, { Size = UDim2.new(1, -14, 0, 46) })
        else
            a48(a188, a44.Fast, { BackgroundColor3 = Color3.fromRGB(55, 55, 62), Size = UDim2.new(1, -14, 0, 46) })
        end
        a48(a189, a44.Fast, { TextSize = 16 })
    end)
    a188.MouseButton1Up:Connect(function()
        local sel = a21.CurrentTab == a185
        if sel then
            a48(a188, a44.Fast, { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(1, -4, 0, 54) })
        else
            a48(a188, a44.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52), Size = UDim2.new(1, -4, 0, 54) })
        end
        a48(a189, a44.Fast, { TextSize = 21 })
    end)
    return a188
end

local function a191(a185)
    local a192 = Instance.new("ScrollingFrame", a169)
    a192.Name                  = a185.."Content"
    a192.Size                  = UDim2.new(1, -10, 1, -10)
    a192.Position              = UDim2.new(0, 5, 0, 5)
    a192.BackgroundTransparency = 1
    a192.BorderSizePixel       = 0
    a192.ScrollBarThickness    = 4
    a192.ScrollBarImageColor3  = Color3.fromRGB(100, 150, 255)
    a192.ScrollBarImageTransparency = 0.5
    a192.CanvasSize            = UDim2.new(0, 0, 0, 0)
    a192.Visible               = false
    a192.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    local a193 = Instance.new("UIListLayout", a192)
    a193.SortOrder = Enum.SortOrder.LayoutOrder
    a193.Padding   = UDim.new(0, 10)
    a182[a185] = a192
    a183["Content_"..a185] = a192
    return a192
end

local a194 = {
    { name = "Home",               icon = "🏠", order = 1 },
    { name = "Anti-AFK",           icon = "⚡", order = 2 },
    { name = "KeySpam",            icon = "⌨️", order = 3 },
    { name = "Performance Status", icon = "📊", order = 4 },
    { name = "Auto Rejoin",        icon = "🔄", order = 5 },
    { name = "Script Loader",      icon = "💾", order = 6 },
    { name = "Settings",           icon = "⚙️", order = 7 },
}

for a195, a196 in ipairs(a194) do
    a184(a196.name, a196.icon, a196.order)
    a191(a196.name)
end

local a197, a198, a199 = {}, {}, {}
local a200, a201, a202, a203 = {}, {}, {}, {}

local function a218_formatUptime(a218_up)
    local a218_d = math.floor(a218_up / 86400)
    local a218_h = math.floor((a218_up % 86400) / 3600)
    local a218_m = math.floor((a218_up % 3600) / 60)
    local a218_s = a218_up % 60
    if a218_d > 0 then
        return string.format("Server Uptime: %dd %dh %02dm %02ds", a218_d, a218_h, a218_m, a218_s)
    elseif a218_h > 0 then
        return string.format("Server Uptime: %dh %02dm %02ds", a218_h, a218_m, a218_s)
    elseif a218_m > 0 then
        return string.format("Server Uptime: %dm %02ds", a218_m, a218_s)
    else
        return "Server Uptime: " .. a218_s .. "s"
    end
end

local a218_awsRegions = {
    ["us-east-1"]      = "🇺🇸 US East (N. Virginia)",
    ["us-east-2"]      = "🇺🇸 US East (Ohio)",
    ["us-west-1"]      = "🇺🇸 US West (N. California)",
    ["us-west-2"]      = "🇺🇸 US West (Oregon)",
    ["eu-west-1"]      = "🇮🇪 EU West (Ireland)",
    ["eu-west-2"]      = "🇬🇧 EU West (London)",
    ["eu-west-3"]      = "🇫🇷 EU West (Paris)",
    ["eu-central-1"]   = "🇩🇪 EU Central (Frankfurt)",
    ["eu-central-2"]   = "🇨🇭 EU Central (Zurich)",
    ["eu-north-1"]     = "🇸🇪 EU North (Stockholm)",
    ["eu-south-1"]     = "🇮🇹 EU South (Milan)",
    ["eu-south-2"]     = "🇪🇸 EU South (Spain)",
    ["ap-southeast-1"] = "🇸🇬 AP Southeast (Singapore)",
    ["ap-southeast-2"] = "🇦🇺 AP Southeast (Sydney)",
    ["ap-southeast-3"] = "🇮🇩 AP Southeast (Jakarta)",
    ["ap-southeast-4"] = "🇦🇺 AP Southeast (Melbourne)",
    ["ap-northeast-1"] = "🇯🇵 AP Northeast (Tokyo)",
    ["ap-northeast-2"] = "🇰🇷 AP Northeast (Seoul)",
    ["ap-northeast-3"] = "🇯🇵 AP Northeast (Osaka)",
    ["ap-south-1"]     = "🇮🇳 AP South (Mumbai)",
    ["ap-south-2"]     = "🇮🇳 AP South (Hyderabad)",
    ["ap-east-1"]      = "🇭🇰 AP East (Hong Kong)",
    ["sa-east-1"]      = "🇧🇷 SA East (São Paulo)",
    ["ca-central-1"]   = "🇨🇦 CA Central (Montreal)",
    ["ca-west-1"]      = "🇨🇦 CA West (Calgary)",
    ["me-south-1"]     = "🇧🇭 ME South (Bahrain)",
    ["me-central-1"]   = "🇦🇪 ME Central (UAE)",
    ["af-south-1"]     = "🇿🇦 AF South (Cape Town)",
    ["il-central-1"]   = "🇮🇱 IL Central (Tel Aviv)",
    ["mx-central-1"]   = "🇲🇽 MX Central (Mexico City)",
}

local a218_countryFlags = {
    AF="🇦🇫", AL="🇦🇱", DZ="🇩🇿", AD="🇦🇩", AO="🇦🇴", AG="🇦🇬", AR="🇦🇷", AM="🇦🇲",
    AU="🇦🇺", AT="🇦🇹", AZ="🇦🇿", BS="🇧🇸", BH="🇧🇭", BD="🇧🇩", BB="🇧🇧", BY="🇧🇾",
    BE="🇧🇪", BZ="🇧🇿", BJ="🇧🇯", BT="🇧🇹", BO="🇧🇴", BA="🇧🇦", BW="🇧🇼", BR="🇧🇷",
    BN="🇧🇳", BG="🇧🇬", BF="🇧🇫", BI="🇧🇮", CV="🇨🇻", KH="🇰🇭", CM="🇨🇲", CA="🇨🇦",
    CF="🇨🇫", TD="🇹🇩", CL="🇨🇱", CN="🇨🇳", CO="🇨🇴", KM="🇰🇲", CG="🇨🇬", CD="🇨🇩",
    CR="🇨🇷", HR="🇭🇷", CU="🇨🇺", CY="🇨🇾", CZ="🇨🇿", DK="🇩🇰", DJ="🇩🇯", DM="🇩🇲",
    DO="🇩🇴", EC="🇪🇨", EG="🇪🇬", SV="🇸🇻", GQ="🇬🇶", ER="🇪🇷", EE="🇪🇪", SZ="🇸🇿",
    ET="🇪🇹", FJ="🇫🇯", FI="🇫🇮", FR="🇫🇷", GA="🇬🇦", GM="🇬🇲", GE="🇬🇪", DE="🇩🇪",
    GH="🇬🇭", GR="🇬🇷", GD="🇬🇩", GT="🇬🇹", GN="🇬🇳", GW="🇬🇼", GY="🇬🇾", HT="🇭🇹",
    HN="🇭🇳", HU="🇭🇺", IS="🇮🇸", IN="🇮🇳", ID="🇮🇩", IR="🇮🇷", IQ="🇮🇶", IE="🇮🇪",
    IL="🇮🇱", IT="🇮🇹", JM="🇯🇲", JP="🇯🇵", JO="🇯🇴", KZ="🇰🇿", KE="🇰🇪", KI="🇰🇮",
    KP="🇰🇵", KR="🇰🇷", KW="🇰🇼", KG="🇰🇬", LA="🇱🇦", LV="🇱🇻", LB="🇱🇧", LS="🇱🇸",
    LR="🇱🇷", LY="🇱🇾", LI="🇱🇮", LT="🇱🇹", LU="🇱🇺", MG="🇲🇬", MW="🇲🇼", MY="🇲🇾",
    MV="🇲🇻", ML="🇲🇱", MT="🇲🇹", MH="🇲🇭", MR="🇲🇷", MU="🇲🇺", MX="🇲🇽", FM="🇫🇲",
    MD="🇲🇩", MC="🇲🇨", MN="🇲🇳", ME="🇲🇪", MA="🇲🇦", MZ="🇲🇿", MM="🇲🇲", NA="🇳🇦",
    NR="🇳🇷", NP="🇳🇵", NL="🇳🇱", NZ="🇳🇿", NI="🇳🇮", NE="🇳🇪", NG="🇳🇬", NO="🇳🇴",
    OM="🇴🇲", PK="🇵🇰", PW="🇵🇼", PA="🇵🇦", PG="🇵🇬", PY="🇵🇾", PE="🇵🇪", PH="🇵🇭",
    PL="🇵🇱", PT="🇵🇹", QA="🇶🇦", RO="🇷🇴", RU="🇷🇺", RW="🇷🇼", KN="🇰🇳", LC="🇱🇨",
    VC="🇻🇨", WS="🇼🇸", SM="🇸🇲", ST="🇸🇹", SA="🇸🇦", SN="🇸🇳", RS="🇷🇸", SC="🇸🇨",
    SL="🇸🇱", SG="🇸🇬", SK="🇸🇰", SI="🇸🇮", SB="🇸🇧", SO="🇸🇴", ZA="🇿🇦", SS="🇸🇸",
    ES="🇪🇸", LK="🇱🇰", SD="🇸🇩", SR="🇸🇷", SE="🇸🇪", CH="🇨🇭", SY="🇸🇾", TW="🇹🇼",
    TJ="🇹🇯", TZ="🇹🇿", TH="🇹🇭", TL="🇹🇱", TG="🇹🇬", TO="🇹🇴", TT="🇹🇹", TN="🇹🇳",
    TR="🇹🇷", TM="🇹🇲", TV="🇹🇻", UG="🇺🇬", UA="🇺🇦", AE="🇦🇪", GB="🇬🇧", US="🇺🇸",
    UY="🇺🇾", UZ="🇺🇿", VU="🇻🇺", VE="🇻🇪", VN="🇻🇳", YE="🇾🇪", ZM="🇿🇲", ZW="🇿🇼",
    HK="🇭🇰", MO="🇲🇴", TF="🇹🇫", EU="🇪🇺",
}

local function a218_flagForCountry(a218_code)
    if not a218_code then return "🌐" end
    return a218_countryFlags[a218_code:upper()] or "🌐"
end

local function a218_detectRegionAsync(a218_label)
    task.spawn(function()
        local a218_detected = nil
        local a218_jobId = game.JobId
        if a218_jobId and a218_jobId ~= "" then
            for a218_code, a218_name in pairs(a218_awsRegions) do
                if a218_jobId:lower():find(a218_code, 1, true) then
                    a218_detected = a218_name
                    break
                end
            end
        end
        if not a218_detected then
            local a218_ok, a218_res = pcall(function()
                local a218_httpOk, a218_data = pcall(function()
                    return a:JSONDecode(game:HttpGet("https://ipinfo.io/json", true))
                end)
                if a218_httpOk and a218_data and a218_data.country then
                    local a218_flag = a218_flagForCountry(a218_data.country)
                    local a218_str = a218_flag .. " " .. a218_data.country
                    if a218_data.region and a218_data.region ~= "" then
                        a218_str = a218_str .. " - " .. a218_data.region
                    end
                    if a218_data.city and a218_data.city ~= "" then
                        a218_str = a218_str .. ", " .. a218_data.city
                    end
                    return a218_str
                end
                return nil
            end)
            if a218_ok and a218_res then
                a218_detected = a218_res
            end
        end
        if not a218_detected then
            a218_detected = "🌐 Unknown"
        end
        if a218_label and a218_label.Parent then
            a218_label.Text = "Server Region: " .. a218_detected
        end
    end)
end

do
    local a204 = a182["Home"]
    local a205 = a134(a204, 200, 1)
    a183["Home_Card1"] = a205

    local a206 = Instance.new("ImageLabel", a205)
    a206.Size             = UDim2.new(0, 120, 0, 140)
    a206.Position         = UDim2.new(0, 10, 0, 10)
    a206.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    a206.BorderSizePixel  = 0
    a206.Image            = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    a65(a206, 10)
    Instance.new("UIStroke", a206).Color = Color3.fromRGB(100, 150, 255)

    local a207 = Instance.new("TextLabel", a205)
    a207.Size              = UDim2.new(1, -145, 0, 22)
    a207.Position          = UDim2.new(0, 140, 0, 10)
    a207.BackgroundTransparency = 1
    a207.Text              = a12
    a207.Font              = Enum.Font.GothamBold
    a207.TextSize          = 28
    a207.TextColor3        = Color3.fromRGB(255, 255, 255)
    a207.TextXAlignment    = Enum.TextXAlignment.Left

    local a208 = Instance.new("TextLabel", a205)
    a208.Size              = UDim2.new(1, -145, 0, 16)
    a208.Position          = UDim2.new(0, 140, 0, 33)
    a208.BackgroundTransparency = 1
    a208.Text              = "User ID: "..a13
    a208.Font              = Enum.Font.Gotham
    a208.TextSize          = 12
    a208.TextColor3        = Color3.fromRGB(150, 150, 150)
    a208.TextXAlignment    = Enum.TextXAlignment.Left

    local a209 = Instance.new("TextLabel", a205)
    a209.Size = UDim2.new(1, -145, 0, 18); a209.Position = UDim2.new(0, 140, 0, 55)
    a209.BackgroundTransparency = 1; a209.Text = "FPS: 60"
    a209.Font = Enum.Font.Gotham; a209.TextSize = 16
    a209.TextColor3 = Color3.fromRGB(100, 200, 255); a209.TextXAlignment = Enum.TextXAlignment.Left

    local a210 = Instance.new("TextLabel", a205)
    a210.Size = UDim2.new(1, -145, 0, 18); a210.Position = UDim2.new(0, 140, 0, 70)
    a210.BackgroundTransparency = 1; a210.Text = "Ping: 0 ms"
    a210.Font = Enum.Font.Gotham; a210.TextSize = 16
    a210.TextColor3 = Color3.fromRGB(0, 255, 0); a210.TextXAlignment = Enum.TextXAlignment.Left

    local a211 = Instance.new("TextLabel", a205)
    a211.Size = UDim2.new(1, -145, 0, 18); a211.Position = UDim2.new(0, 140, 0, 90)
    a211.BackgroundTransparency = 1; a211.Text = "Memory: 0 MB"
    a211.Font = Enum.Font.Gotham; a211.TextSize = 16
    a211.TextColor3 = Color3.fromRGB(255, 180, 100); a211.TextXAlignment = Enum.TextXAlignment.Left

    local a212, a213 = "Unknown", "N/A"
    pcall(function()
        if identifyexecutor then a212, a213 = identifyexecutor()
        elseif getexecutorname then a212 = getexecutorname() end
    end)

    local a214 = Instance.new("TextLabel", a205)
    a214.Size = UDim2.new(1, -145, 0, 18); a214.Position = UDim2.new(0, 140, 0, 105)
    a214.BackgroundTransparency = 1; a214.Text = "Executor: "..a212.." "..a213
    a214.Font = Enum.Font.Gotham; a214.TextSize = 14
    a214.TextColor3 = Color3.fromRGB(255, 100, 200); a214.TextXAlignment = Enum.TextXAlignment.Left

    local a215 = Instance.new("TextLabel", a205)
    a215.Size = UDim2.new(1, -145, 0, 18); a215.Position = UDim2.new(0, 140, 0, 125)
    a215.BackgroundTransparency = 1; a215.Text = "Device: "..a19()
    a215.Font = Enum.Font.Gotham; a215.TextSize = 14
    a215.TextColor3 = Color3.fromRGB(180, 255, 150); a215.TextXAlignment = Enum.TextXAlignment.Left

    local a216 = a59()
    local a217 = Instance.new("TextLabel", a205)
    a217.Size = UDim2.new(1, -145, 0, 16); a217.Position = UDim2.new(0, 140, 0, 140)
    a217.BackgroundTransparency = 1; a217.Text = string.format("Resolution: %dx%d", a216.X, a216.Y)
    a217.Font = Enum.Font.Gotham; a217.TextSize = 12
    a217.TextColor3 = Color3.fromRGB(120, 120, 120); a217.TextXAlignment = Enum.TextXAlignment.Left

    local a218 = a134(a204, 178, 2)
    a183["Home_Card2"] = a218

    local a219 = Instance.new("ImageLabel", a218)
    a219.Size = UDim2.new(0, 120, 0, 125); a219.Position = UDim2.new(0, 10, 0, 10)
    a219.BackgroundColor3 = Color3.fromRGB(45, 45, 52); a219.BorderSizePixel = 0
    a219.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    a65(a219, 10); Instance.new("UIStroke", a219).Color = Color3.fromRGB(100, 150, 255)

    local a220 = Instance.new("TextLabel", a218)
    a220.Size = UDim2.new(1, -145, 0, 24); a220.Position = UDim2.new(0, 140, 0, 5)
    a220.BackgroundTransparency = 1; a220.Text = "Loading game info..."
    a220.Font = Enum.Font.GothamBold; a220.TextSize = 24
    a220.TextColor3 = Color3.fromRGB(255, 255, 255); a220.TextXAlignment = Enum.TextXAlignment.Left
    a220.TextWrapped = true

    local a221 = Instance.new("TextLabel", a218)
    a221.Size = UDim2.new(1, -145, 0, 16); a221.Position = UDim2.new(0, 140, 0, 30)
    a221.BackgroundTransparency = 1; a221.Text = "Place Id: "..game.PlaceId
    a221.Font = Enum.Font.Gotham; a221.TextSize = 16
    a221.TextColor3 = Color3.fromRGB(150, 180, 255); a221.TextXAlignment = Enum.TextXAlignment.Left

    local a221b = Instance.new("TextLabel", a218)
    a221b.Size = UDim2.new(1, -145, 0, 16); a221b.Position = UDim2.new(0, 140, 0, 45)
    a221b.BackgroundTransparency = 1; a221b.Text = "Universe Id: "..game.GameId
    a221b.Font = Enum.Font.Gotham; a221b.TextSize = 16
    a221b.TextColor3 = Color3.fromRGB(200, 160, 255); a221b.TextXAlignment = Enum.TextXAlignment.Left

    local a222 = Instance.new("TextLabel", a218)
    a222.Size = UDim2.new(1, -145, 0, 16); a222.Position = UDim2.new(0, 140, 0, 70)
    a222.BackgroundTransparency = 1
    a222.Text = "Server Players: "..#a1:GetPlayers().." / "..a1.MaxPlayers
    a222.Font = Enum.Font.Gotham; a222.TextSize = 16
    a222.TextColor3 = Color3.fromRGB(150, 255, 180); a222.TextXAlignment = Enum.TextXAlignment.Left

    local a223b = Instance.new("TextLabel", a218)
    a223b.Size = UDim2.new(1, -145, 0, 16); a223b.Position = UDim2.new(0, 140, 0, 85)
    a223b.BackgroundTransparency = 1; a223b.Text = "Server Uptime: 0s"
    a223b.Font = Enum.Font.Gotham; a223b.TextSize = 16
    a223b.TextColor3 = Color3.fromRGB(255, 220, 100); a223b.TextXAlignment = Enum.TextXAlignment.Left

    local a223c = Instance.new("TextLabel", a218)
    a223c.Size = UDim2.new(1, -145, 0, 16); a223c.Position = UDim2.new(0, 140, 0, 100)
    a223c.BackgroundTransparency = 1; a223c.Text = "Server Region: Detecting..."
    a223c.Font = Enum.Font.Gotham; a223c.TextSize = 12
    a223c.TextColor3 = Color3.fromRGB(130, 220, 255); a223c.TextXAlignment = Enum.TextXAlignment.Left

    local a223 = Instance.new("TextLabel", a218)
    a223.Size = UDim2.new(1, -145, 0, 14); a223.Position = UDim2.new(0, 140, 0, 120)
    a223.BackgroundTransparency = 1; a223.Text = "Job Id: "..(game.JobId ~= "" and game.JobId or "N/A")
    a223.Font = Enum.Font.Gotham; a223.TextSize = 12
    a223.TextColor3 = Color3.fromRGB(255, 180, 180); a223.TextXAlignment = Enum.TextXAlignment.Left
    a223.TextTruncate = Enum.TextTruncate.AtEnd

    local a218_tickOffset = tick() - workspace.DistributedGameTime
    a223b.Text = a218_formatUptime(math.floor(workspace.DistributedGameTime))

    a218_detectRegionAsync(a223c)

    table.insert(_G.UU.Connections, a1.PlayerAdded:Connect(function()
        a222.Text = "Players: "..#a1:GetPlayers().." / "..a1.MaxPlayers
    end))
    table.insert(_G.UU.Connections, a1.PlayerRemoving:Connect(function()
        a222.Text = "Players: "..(#a1:GetPlayers() - 1).." / "..a1.MaxPlayers
    end))

    local a218_lastUp = -1
    local a218_conn = a5.Heartbeat:Connect(function()
        local a218_up = math.floor(tick() - a218_tickOffset)
        if a218_up ~= a218_lastUp then
            a218_lastUp = a218_up
            a223b.Text = a218_formatUptime(a218_up)
        end
    end)
    table.insert(_G.UU.Connections, a218_conn)

    _G.UU.UI.PlayerImage  = a206
    _G.UU.UI.GameName     = a220
    _G.UU.UI.GameImage    = a219
    _G.UU.UI.ResolutionLabel = a217
    _G.UU.UI.DeviceLabel  = a215
    a197.FPSLabel         = a209
    a197.PingLabel        = a210
    a197.MemoryLabel      = a211
end

do
    local a225 = a182["Anti-AFK"]
    local a226 = a134(a225, 450, 1)
    a183["AntiAFK_Card"] = a226

    local a227 = a141(a226, "⚡ Anti-AFK System", 8)
    a227.TextColor3 = Color3.fromRGB(100, 200, 255)
    a138(a226, "Prevent disconnections by simulating player activity", 34)

    local a228, _ = a143(a226, "Auto Jump", 60)
    local a229, _, _, a231 = a147(a228, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), a21.JumpEnabled, nil)

    local a232, _ = a143(a226, "Auto Click", 102)
    local a233, _, _, a235 = a147(a232, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), a21.ClickEnabled, nil)

    a128(a226, 150)
    a131(a226, "Click Position Mode", 162)

    local function a236(a237, a238)
        local a239 = Instance.new("TextButton", a226)
        a239.Size             = UDim2.new(0, 85, 0, 30)
        a239.Position         = UDim2.new(a237, 0, 0, a238 + 15)
        a239.AnchorPoint      = Vector2.new(0.5, 0.5)
        a239.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        a239.Font             = Enum.Font.GothamBold
        a239.TextSize         = 13
        a239.TextColor3       = Color3.fromRGB(255, 255, 255)
        a239.BorderSizePixel  = 0
        a239.AutoButtonColor  = false
        a65(a239, 8)
        local function a239_getSelected()
            return a21.ClickType == (a237 == 0.2 and "Current" or a237 == 0.5 and "Center" or "Random")
        end
        a239.MouseEnter:Connect(function()
            a48(a239, a44.Fast, a239_getSelected()
                and { BackgroundColor3 = Color3.fromRGB(120, 170, 255), Size = UDim2.new(0, 91, 0, 34) }
                or  { BackgroundColor3 = Color3.fromRGB(60,  60,  70),  Size = UDim2.new(0, 91, 0, 34) })
        end)
        a239.MouseLeave:Connect(function()
            a48(a239, a44.Fast, a239_getSelected()
                and { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(0, 85, 0, 30) }
                or  { BackgroundColor3 = Color3.fromRGB(45,  45,  52),  Size = UDim2.new(0, 85, 0, 30) })
        end)
        a239.MouseButton1Down:Connect(function()
            a48(a239, a44.Fast, { BackgroundColor3 = Color3.fromRGB(80, 130, 220), Size = UDim2.new(0, 79, 0, 26) })
        end)
        a239.MouseButton1Up:Connect(function()
            a48(a239, a44.Fast, a239_getSelected()
                and { BackgroundColor3 = Color3.fromRGB(120, 170, 255), Size = UDim2.new(0, 91, 0, 34) }
                or  { BackgroundColor3 = Color3.fromRGB(60,  60,  70),  Size = UDim2.new(0, 91, 0, 34) })
        end)
        return a239
    end

    local a240 = a236(0.2, 190); a240.Text = "Current"
    local a241 = a236(0.5, 190); a241.Text = "Center"
    local a242 = a236(0.8, 190); a242.Text = "Random"

    a128(a226, 233)

    local _, a244, a245, a246, a247 = a74(a226, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 248), 10, "Jump Interval (seconds)")
    local _, a249, a250, a251, a252 = a74(a226, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 315), 3, "Click Interval (seconds)")

    local _, a254 = a123(a226, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 380), "Status: All Inactive")

    a198 = {
        JumpToggleBtn      = a229,
        JumpToggleState    = a231,
        ClickToggleBtn     = a233,
        ClickToggleState   = a235,
        ClickTypeCurrent   = a240,
        ClickTypeCenter    = a241,
        ClickTypeRandom    = a242,
        JumpDelaySlider    = a244,
        JumpSliderFill     = a245,
        JumpSliderButton   = a246,
        JumpDelayBox       = a247,
        ClickDelaySlider   = a249,
        ClickSliderFill    = a250,
        ClickSliderButton  = a251,
        ClickDelayBox      = a252,
        Status             = a254,
    }
end

do
    local a255 = a182["KeySpam"]
    local a256 = a134(a255, 330, 1)
    a183["KeySpam_Card"] = a256

    local a257 = a141(a256, "⌨️ Key Spam Controller", 8)
    a257.TextColor3 = Color3.fromRGB(255, 200, 100)
    a138(a256, "Automatically spam any keyboard key at custom intervals", 34)

    a131(a256, "Target Key", 60)

    local a258 = Instance.new("TextBox", a256)
    a258.Size             = UDim2.new(1, -20, 0, 40)
    a258.Position         = UDim2.new(0, 10, 0, 82)
    a258.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    a258.Text             = a21.SpamKey
    a258.PlaceholderText  = "Enter key (A-Z, 0-9, F1-F12)"
    a258.Font             = Enum.Font.Gotham
    a258.TextSize         = 14
    a258.TextColor3       = Color3.fromRGB(255, 255, 255)
    a258.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    a258.BorderSizePixel  = 0
    a258.ClearTextOnFocus = false
    a65(a258, 8)
    Instance.new("UIStroke", a258).Color = Color3.fromRGB(60, 60, 70)

    a128(a256, 135)

    local _, a260, a261, a262, a263 = a74(a256, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 150), 0.1, "Spam Interval (seconds)")

    local a264, _ = a143(a256, "Auto Spam", 215)
    local a265, _, _, a267 = a147(a264, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), a21.AutoSpamEnabled, nil)

    local _, a269 = a123(a256, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 265), "Status: Inactive")

    a199 = {
        SpamInput          = a258,
        SpamDelaySlider    = a260,
        SpamSliderFill     = a261,
        SpamSliderButton   = a262,
        SpamDelayBox       = a263,
        AutoSpamToggleBtn  = a265,
        AutoSpamToggleState = a267,
        Status             = a269,
    }
end

do
    local a270 = a182["Performance Status"]
    local a271 = a134(a270, 660, 1)
    a183["Performance_Card"] = a271

    local a272 = a141(a271, "📊 Performance Monitor", 8)
    a272.TextColor3 = Color3.fromRGB(100, 255, 150)
    a138(a271, "Track real-time performance metrics and unlock FPS limits", 34)

    local a273, _ = a143(a271, "FPS Unlock", 60)
    local a274, _, _, a276 = a147(a273, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), a21.FPSUnlockEnabled, nil)

    local a277 = Instance.new("TextLabel", a271)
    a277.Size              = UDim2.new(1, -20, 0, 20)
    a277.Position          = UDim2.new(0, 10, 0, 102)
    a277.BackgroundTransparency = 1
    a277.Text              = "Current Limit: 60 FPS"
    a277.Font              = Enum.Font.Gotham
    a277.TextSize          = 13
    a277.TextColor3        = Color3.fromRGB(180, 180, 180)
    a277.TextXAlignment    = Enum.TextXAlignment.Center

    local _, a279, a280, a281, a282 = a74(a271, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 135), 60, "Target FPS Limit")

    a128(a271, 200)
    a131(a271, "Framerate Statistics", 210)

    local a283 = Instance.new("Frame", a271)
    a283.Size = UDim2.new(1, -20, 0, 50); a283.Position = UDim2.new(0, 10, 0, 235)
    a283.BackgroundColor3 = Color3.fromRGB(30, 30, 35); a283.BorderSizePixel = 0
    a65(a283, 8); Instance.new("UIStroke", a283).Color = Color3.fromRGB(50, 50, 60)

    local function a284(a285, a286, a287, a288)
        local a289 = Instance.new("TextLabel", a285)
        a289.Size = UDim2.new(a286[3], 0, 1, 0); a289.Position = UDim2.new(a286[1], 0, 0, 0)
        a289.BackgroundTransparency = 1; a289.Text = a287
        a289.Font = Enum.Font.GothamBold; a289.TextSize = 13
        a289.TextColor3 = a288; a289.TextXAlignment = Enum.TextXAlignment.Center
        return a289
    end

    local a290 = a284(a283, {0,    0, 0.33}, "Current: 60",      Color3.fromRGB(100, 200, 255))
    local a291 = a284(a283, {0.33, 0, 0.33}, "Average: 60",      Color3.fromRGB(50,  220, 100))
    local a292 = a284(a283, {0.66, 0, 0.34}, "Min: 60 | Max: 60",Color3.fromRGB(255, 200, 100))

    a128(a271, 300); a131(a271, "Network Latency Statistics", 310)

    local a293 = Instance.new("Frame", a271)
    a293.Size = UDim2.new(1, -20, 0, 50); a293.Position = UDim2.new(0, 10, 0, 335)
    a293.BackgroundColor3 = Color3.fromRGB(30, 30, 35); a293.BorderSizePixel = 0
    a65(a293, 8); Instance.new("UIStroke", a293).Color = Color3.fromRGB(50, 50, 60)

    local a294 = a284(a293, {0,    0, 0.33}, "Current: 0ms",         Color3.fromRGB(100, 200, 255))
    local a295 = a284(a293, {0.33, 0, 0.33}, "Average: 0ms",         Color3.fromRGB(50,  220, 100))
    local a296 = a284(a293, {0.66, 0, 0.34}, "Min: 0ms | Max: 0ms",  Color3.fromRGB(255, 200, 100))

    local a297 = Instance.new("Frame", a271)
    a297.Size = UDim2.new(1, -20, 0, 50); a297.Position = UDim2.new(0, 10, 0, 400)
    a297.BackgroundColor3 = Color3.fromRGB(30, 30, 35); a297.BorderSizePixel = 0
    a65(a297, 8); Instance.new("UIStroke", a297).Color = Color3.fromRGB(50, 50, 60)

    a284(a297, {0, 0, 0.5}, "Connection Quality", Color3.fromRGB(255, 255, 255))
    local a298 = a284(a297, {0.5, 0, 0.5}, "Excellent", Color3.fromRGB(50, 220, 100))

    a128(a271, 460); a131(a271, "Memory Usage Statistics", 470)

    local a299 = Instance.new("Frame", a271)
    a299.Size = UDim2.new(1, -20, 0, 50); a299.Position = UDim2.new(0, 10, 0, 495)
    a299.BackgroundColor3 = Color3.fromRGB(30, 30, 35); a299.BorderSizePixel = 0
    a65(a299, 8); Instance.new("UIStroke", a299).Color = Color3.fromRGB(50, 50, 60)

    local a300 = a284(a299, {0,   0, 0.5}, "Current: 0 MB", Color3.fromRGB(255, 180, 100))
    local a301 = a284(a299, {0.5, 0, 0.5}, "Peak: 0 MB",    Color3.fromRGB(255, 150, 50))

    local a302 = Instance.new("TextLabel", a271)
    a302.Size = UDim2.new(1, -20, 0, 60); a302.Position = UDim2.new(0, 10, 0, 555)
    a302.BackgroundColor3 = Color3.fromRGB(30, 30, 35); a302.BorderSizePixel = 0
    a302.Text = "Performance monitoring tracks your game's framerate, network latency, and memory usage in real-time.\n\nLowering FPS limits reduces memory usage."
    a302.Font = Enum.Font.Gotham; a302.TextSize = 12
    a302.TextColor3 = Color3.fromRGB(200, 180, 150); a302.TextWrapped = true
    a302.TextXAlignment = Enum.TextXAlignment.Left; a302.TextYAlignment = Enum.TextYAlignment.Top
    a65(a302, 8); Instance.new("UIStroke", a302).Color = Color3.fromRGB(50, 50, 60)
    local a303 = Instance.new("UIPadding", a302)
    a303.PaddingLeft = UDim.new(0, 10); a303.PaddingRight  = UDim.new(0, 10)
    a303.PaddingTop  = UDim.new(0, 10); a303.PaddingBottom = UDim.new(0, 10)

    a200 = {
        FPSToggleBtn    = a274,
        FPSToggleState  = a276,
        FPSUnlockStatus = a277,
        FPSSlider       = a279,
        FPSFill         = a280,
        FPSButton       = a281,
        FPSValueBox     = a282,
        FPSStats        = { Current = a290, Avg = a291, MinMax = a292 },
        PingStats       = { Current = a294, Avg = a295, MinMax = a296, Quality = a298 },
        MemoryStats     = { Current = a300, Peak = a301 },
    }
end

do
    local a304 = a182["Auto Rejoin"]
    local a305 = a134(a304, 270, 1)
    a183["AutoRejoin_Card"] = a305

    local a306 = a141(a305, "🔄 Auto Rejoin System", 8)
    a306.TextColor3 = Color3.fromRGB(150, 200, 255)
    a138(a305, "Automatically reconnect when disconnected from the server", 34)

    local a307, _ = a143(a305, "Auto Rejoin", 65)
    local a308, _, _, a310 = a147(a307, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), a21.AutoRejoinEnabled, nil)

    local _, a312 = a123(a305, UDim2.new(1, -20, 0, 105), UDim2.new(0, 10, 0, 120),
        "Status: Disabled\n\nWhen enabled, automatically rejoins the current server when disconnected.")

    a201 = {
        AutoRejoinToggleBtn   = a308,
        AutoRejoinToggleState = a310,
        Status                = a312,
    }
end

do
    local a313 = a182["Script Loader"]
    local a314 = a134(a313, 660, 1)
    a183["ScriptLoader_Card"] = a314

    local a315 = a141(a314, "💾 Script Executor", 8)
    a315.TextColor3 = Color3.fromRGB(200, 150, 255)
    a138(a314, "Execute custom Lua scripts with auto-save and auto-load capabilities", 34)

    local a316 = Instance.new("Frame", a314)
    a316.Size             = UDim2.new(1, -20, 0, 220)
    a316.Position         = UDim2.new(0, 10, 0, 60)
    a316.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    a316.BorderSizePixel  = 0
    a65(a316, 8)
    Instance.new("UIStroke", a316).Color = Color3.fromRGB(60, 60, 70)

    local a317 = Instance.new("ScrollingFrame", a316)
    a317.Size             = UDim2.new(0, 40, 1, 0)
    a317.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    a317.BorderSizePixel  = 0
    a317.ScrollBarThickness = 0
    a317.ScrollingEnabled = false
    a317.CanvasSize       = UDim2.new(0, 0, 0, 220)
    a65(a317, 8)

    local a318 = Instance.new("TextLabel", a317)
    a318.Size              = UDim2.new(1, -5, 1, 0)
    a318.BackgroundTransparency = 1
    a318.Text              = "1"
    a318.Font              = Enum.Font.Code
    a318.TextSize          = 12
    a318.TextColor3        = Color3.fromRGB(120, 120, 120)
    a318.TextXAlignment    = Enum.TextXAlignment.Right
    a318.TextYAlignment    = Enum.TextYAlignment.Top

    local a319 = Instance.new("Frame", a316)
    a319.Size             = UDim2.new(0, 1, 1, 0)
    a319.Position         = UDim2.new(0, 40, 0, 0)
    a319.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    a319.BorderSizePixel  = 0

    local a320 = Instance.new("ScrollingFrame", a316)
    a320.Size             = UDim2.new(1, -41, 1, 0)
    a320.Position         = UDim2.new(0, 41, 0, 0)
    a320.BackgroundTransparency = 1
    a320.BorderSizePixel  = 0
    a320.ScrollBarThickness = 4
    a320.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    a320.ScrollBarImageTransparency = 0.5
    a320.CanvasSize       = UDim2.new(0, 0, 0, 220)

    local a321 = Instance.new("TextBox", a320)
    a321.Size             = UDim2.new(1, -10, 1, 0)
    a321.Position         = UDim2.new(0, 5, 0, 0)
    a321.BackgroundTransparency = 1
    a321.Text             = a21.SavedCode
    a321.PlaceholderText  = "-- Paste your Lua code here..."
    a321.Font             = Enum.Font.Code
    a321.TextSize         = 12
    a321.TextColor3       = Color3.fromRGB(255, 255, 255)
    a321.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    a321.BorderSizePixel  = 0
    a321.TextWrapped      = false
    a321.TextXAlignment   = Enum.TextXAlignment.Left
    a321.TextYAlignment   = Enum.TextYAlignment.Top
    a321.MultiLine        = true
    a321.ClearTextOnFocus = false
    a321.TextEditable     = true

    local a322 = Instance.new("TextButton", a314)
    a322.Size             = UDim2.new(0.5, -15, 0, 36)
    a322.Position         = UDim2.new(0.25, 2.5, 0, 318)
    a322.AnchorPoint      = Vector2.new(0.5, 0.5)
    a322.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    a322.Text             = "▶  Execute"
    a322.Font             = Enum.Font.GothamBold
    a322.TextSize         = 14
    a322.TextColor3       = Color3.fromRGB(255, 255, 255)
    a322.BorderSizePixel  = 0
    a322.AutoButtonColor  = false
    a65(a322, 8)
    a498(a322,
        { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(0.5, -15, 0, 36) },
        { BackgroundColor3 = Color3.fromRGB(120, 170, 255), Size = UDim2.new(0.5,  -8, 0, 40) },
        { BackgroundColor3 = Color3.fromRGB(80,  130, 225), Size = UDim2.new(0.5, -22, 0, 32) }
    )

    local a323, _ = a143(a314, "Auto Load", 300)
    a323.Size = UDim2.new(0.5, -15, 0, 36); a323.Position = UDim2.new(0.5, 5, 0, 300)
    local a324, _, _, a326 = a147(a323, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), a21.AutoLoadEnabled, nil)

    a128(a314, 348)
    a131(a314, "Status", 360)

    local a327_frame = Instance.new("Frame", a314)
    a327_frame.Size             = UDim2.new(1, -20, 0, 36)
    a327_frame.Position         = UDim2.new(0, 10, 0, 382)
    a327_frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    a327_frame.BorderSizePixel  = 0
    a65(a327_frame, 8)
    Instance.new("UIStroke", a327_frame).Color = Color3.fromRGB(50, 50, 60)

    local a327 = Instance.new("TextLabel", a327_frame)
    a327.Size                = UDim2.new(1, -10, 1, 0)
    a327.Position            = UDim2.new(0, 10, 0, 0)
    a327.BackgroundTransparency = 1
    a327.Text                = "Ready"
    a327.Font                = Enum.Font.GothamBold
    a327.TextSize            = 13
    a327.TextColor3          = Color3.fromRGB(180, 180, 180)
    a327.TextXAlignment      = Enum.TextXAlignment.Left
    a327.TextYAlignment      = Enum.TextYAlignment.Center
    a327.TextTruncate        = Enum.TextTruncate.AtEnd

    a128(a314, 430)
    a131(a314, "Output", 442)

    local _, a330, a333, a335, a328 = a499(a314,
        UDim2.new(1, -20, 0, 140),
        UDim2.new(0, 10, 0, 465),
        Color3.fromRGB(100, 150, 255)
    )
    a328.Position  = UDim2.new(1, -35, 0, 450)
    a328.AnchorPoint = Vector2.new(0.5, 0.5)
    a333.Text = "No output yet."

    local a340 = Instance.new("TextLabel", a314)
    a340.Size = UDim2.new(1, -20, 0, 30); a340.Position = UDim2.new(0, 10, 0, 618)
    a340.BackgroundTransparency = 1
    a340.Text = "Code is auto-saved while typing. Enable Auto Load to execute on rejoin."
    a340.Font = Enum.Font.Gotham; a340.TextSize = 11
    a340.TextColor3 = Color3.fromRGB(100, 100, 110)
    a340.TextXAlignment = Enum.TextXAlignment.Center; a340.TextWrapped = true

    a202 = {
        LoadStringBox          = a321,
        LineNumbers            = a318,
        LoadStringScrollFrame  = a320,
        LineNumbersScrollFrame = a317,
        ExecuteButton          = a322,
        AutoLoadToggleBtn      = a324,
        AutoLoadToggleState    = a326,
        Status                 = a327,
        OutputScroll           = a330,
        OutputEmpty            = a333,
        AddOutput              = a335,
    }
end

do
    local a341 = a182["Settings"]
    local a342 = a134(a341, 560, 1)
    a183["Settings_Card"] = a342

    local a343 = a141(a342, "⚙️ UI Configuration", 8)
    a343.TextColor3 = Color3.fromRGB(255, 180, 100)
    a138(a342, "Customize interface preferences and keybinds", 34)

    a131(a342, "Toggle Keybind", 60)

    local a344 = a22[a21.Keybind] or a21.Keybind.Name
    local a345 = Instance.new("TextButton", a342)
    a345.Size             = UDim2.new(1, -20, 0, 40)
    a345.Position         = UDim2.new(0.5, 0, 0, 102)
    a345.AnchorPoint      = Vector2.new(0.5, 0.5)
    a345.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    a345.Text             = "Current Key: "..a344
    a345.Font             = Enum.Font.GothamBold
    a345.TextSize         = 13
    a345.TextColor3       = Color3.fromRGB(255, 255, 255)
    a345.BorderSizePixel  = 0
    a345.AutoButtonColor  = false
    a65(a345, 8)
    a498(a345,
        { BackgroundColor3 = Color3.fromRGB(45, 45, 52), Size = UDim2.new(1, -20, 0, 40) },
        { BackgroundColor3 = Color3.fromRGB(55, 55, 65), Size = UDim2.new(1, -15, 0, 44) },
        { BackgroundColor3 = Color3.fromRGB(70, 70, 80), Size = UDim2.new(1, -25, 0, 36) }
    )

    a128(a342, 135)

    local a346, _ = a143(a342, "Auto Hide UI", 150)
    local a347, _, _, a349 = a147(a346, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), a21.AutoHideEnabled, nil)

    local _, a351 = a123(a342, UDim2.new(1, -20, 0, 60), UDim2.new(0, 10, 0, 200), "")
    a351.TextColor3 = Color3.fromRGB(150, 150, 150)

    a128(a342, 278)

    local a351b_header = a131(a342, "Activity Log", 290)
    a351b_header.TextColor3 = Color3.fromRGB(200, 200, 200)

    local a351b_outer, a351b_scroll, a351b_empty, a351b_add, a351b_clear = a499(a342,
        UDim2.new(1, -20, 0, 200),
        UDim2.new(0, 10, 0, 312),
        Color3.fromRGB(255, 180, 100)
    )
    a351b_clear.Position   = UDim2.new(1, -35, 0, 297.5)
    a351b_clear.AnchorPoint = Vector2.new(0.5, 0.5)
    a351b_empty.Text = "No activity yet."

    a203 = {
        KeybindButton        = a345,
        AutoHideToggleBtn    = a347,
        AutoHideToggleState  = a349,
        Status               = a351,
        AddSettingsLog       = a351b_add,
    }
    _G.UU.AddActivityLog = a351b_add
    for _, a351b_pending in ipairs(_pendingLogs) do
        _G.UU.AddActivityLog(a351b_pending.msg, a351b_pending.col)
    end
    _pendingLogs = {}
end

local a352 = typeof(setfpscap) == "function"
if a352 then
    local a352_ok = pcall(setfpscap, 60)
    if not a352_ok then a352 = false end
end

local a354, a355, a356 = {}, {}, 60
local a357, a358 = tick(), 0
local a359 = 0

for a360 = 1, 60 do
    table.insert(a354, 60)
    table.insert(a355, 0)
end

local function a361()
    if not a198.Status then return end
    local a362, a363
    if a21.JumpEnabled and a21.ClickEnabled then
        a362, a363 = "Status: Jump & Click Active", Color3.fromRGB(50, 220, 100)
    elseif a21.JumpEnabled then
        a362, a363 = "Status: Jump Active", Color3.fromRGB(100, 200, 255)
    elseif a21.ClickEnabled then
        a362, a363 = "Status: Click Active", Color3.fromRGB(255, 200, 100)
    else
        a362, a363 = "Status: All Inactive", Color3.fromRGB(180, 180, 180)
    end
    a48(a198.Status, a44.Fast, { TextColor3 = a363 })
    a198.Status.Text = a362
end

local function a364()
    for a364_type, a364_btn in pairs({ Current = a198.ClickTypeCurrent, Center = a198.ClickTypeCenter, Random = a198.ClickTypeRandom }) do
        if a364_btn then
            a48(a364_btn, a44.Fast, { BackgroundColor3 = a21.ClickType == a364_type and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(45, 45, 52) })
        end
    end
end

local function a365()
    a56("Jump")
    _G.UU.Threads.Jump = task.spawn(function()
        while a21.JumpEnabled do
            task.wait(a21.JumpDelay)
            if a21.JumpEnabled and a11.Character then
                local a367 = a11.Character:FindFirstChildOfClass("Humanoid")
                if a367 then a367:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
        _G.UU.Threads.Jump = nil
    end)
end

local function a368()
    a56("Click")
    _G.UU.Threads.Click = task.spawn(function()
        while a21.ClickEnabled do
            task.wait(a21.ClickDelay)
            if a21.ClickEnabled then
                local a369, a370
                if a21.ClickType == "Current" then
                    local a371 = a3:GetMouseLocation()
                    a369, a370 = a371.X, a371.Y
                elseif a21.ClickType == "Center" then
                    local a372 = workspace.CurrentCamera.ViewportSize
                    a369, a370 = a372.X / 2, a372.Y / 2
                else
                    local a372 = workspace.CurrentCamera.ViewportSize
                    a369, a370 = math.random(100, a372.X - 100), math.random(100, a372.Y - 100)
                end
                a4:SendMouseButtonEvent(a369, a370, 0, true, game, 0)
                task.wait(0.05)
                a4:SendMouseButtonEvent(a369, a370, 0, false, game, 0)
            end
        end
        _G.UU.Threads.Click = nil
    end)
end

local function a373()
    a56("Spam")
    local a374 = a21.SpamKey:upper()
    local a375 = a23[a374]
    if not a375 then return end
    _G.UU.Threads.Spam = task.spawn(function()
        while a21.AutoSpamEnabled do
            task.wait(a21.SpamDelay)
            if a21.AutoSpamEnabled then
                a4:SendKeyEvent(true, a375, false, game)
                task.wait(0.05)
                a4:SendKeyEvent(false, a375, false, game)
            end
        end
        _G.UU.Threads.Spam = nil
    end)
end

local a376 = false
local a377b = nil

local function a377b_disconnect()
    if a377b then
        pcall(function() a377b:Disconnect() end)
        a377b = nil
    end
end

local function a378()
    a377b_disconnect()
    if not a21.AutoRejoinEnabled then return end
    task.spawn(function()
        local a379 = a6:FindFirstChild("RobloxPromptGui")
        if not a379 then
            local a380, a381 = pcall(function() return a6:WaitForChild("RobloxPromptGui", 10) end)
            if not a380 or not a381 then
                if a201.Status then
                    a201.Status.Text = "Status: Enabled (waiting for prompt GUI...)\n\nAutomatically rejoins when disconnected."
                end
                return
            end
            a379 = a381
        end
        local a382 = a379:FindFirstChild("promptOverlay")
        if not a382 then
            local a383, a384 = pcall(function() return a379:WaitForChild("promptOverlay", 10) end)
            if not a383 or not a384 then
                if a201.Status then
                    a201.Status.Text = "Status: Enabled (prompt overlay unavailable)\n\nAutomatically rejoins when disconnected."
                end
                return
            end
            a382 = a384
        end
        a377b = a382.ChildAdded:Connect(function(a385)
            if a385.Name == "ErrorPrompt" and a21.AutoRejoinEnabled and not a376 then
                a376 = true
                a33_log("Disconnected detected → rejoining...", Color3.fromRGB(255, 200, 100))
                _G.UU.Threads.Rejoin = task.spawn(function()
                    while a21.AutoRejoinEnabled and a376 do
                        a7:Teleport(game.PlaceId, a11)
                        task.wait(2)
                    end
                    _G.UU.Threads.Rejoin = nil
                end)
            end
        end)
        table.insert(_G.UU.Connections, a377b)
    end)
end

local function a386(a387)
    if not a387 or a387 == "" then return false, "Empty script", "No code to execute." end
    local a388, a389 = pcall(function()
        local a390, a391 = loadstring(a387)
        if not a390 then error(a391, 0) end
        a390()
    end)
    if a388 then return true, "Executed successfully!", nil end
    return false, "Execution failed", tostring(a389)
end

local a392 = { jump = false, click = false, spam = false, fps = false }

local function a391_makeSlider(a391_cfgKey, a391_base, a391_range, a391_fill, a391_box, a391_min, a391_max, a391_fmt, a391_label, a391_sideEffect)
    local function a391_instant(a394)
        a21[a391_cfgKey] = a391_base + (a394 * a391_range)
        if a391_fmt == "%d" then a21[a391_cfgKey] = math.floor(a21[a391_cfgKey]) end
        a91_instant(a391_fill(), a391_box(), a21[a391_cfgKey], a391_min, a391_max, a391_fmt)
        if a391_sideEffect then a391_sideEffect() end
    end
    local function a391_logged(a394)
        a21[a391_cfgKey] = a391_base + (a394 * a391_range)
        if a391_fmt == "%d" then a21[a391_cfgKey] = math.floor(a21[a391_cfgKey]) end
        a91(a391_fill(), a391_box(), a21[a391_cfgKey], a391_min, a391_max, a391_fmt)
        if a391_sideEffect then a391_sideEffect() end
        a33_save_log(string.format(a391_label .. " → " .. a391_fmt, a21[a391_cfgKey]))
    end
    return a391_instant, a391_logged
end

local a393, a393_log = a391_makeSlider(
    "JumpDelay", 5, 25,
    function() return a198.JumpSliderFill end, function() return a198.JumpDelayBox end,
    5, 30, "%.1f", "Jump Interval")

local a395, a395_log = a391_makeSlider(
    "ClickDelay", 1, 9,
    function() return a198.ClickSliderFill end, function() return a198.ClickDelayBox end,
    1, 10, "%.1f", "Click Interval")

local a396, a396_log = a391_makeSlider(
    "SpamDelay", 0.05, 4.95,
    function() return a199.SpamSliderFill end, function() return a199.SpamDelayBox end,
    0.05, 5, "%.2f", "Spam Interval")

local a397, a397_log = a391_makeSlider(
    "TargetFPS", 15, 345,
    function() return a200.FPSFill end, function() return a200.FPSValueBox end,
    15, 360, "%d", "Target FPS",
    function()
        if a21.FPSUnlockEnabled and a352 then
            pcall(setfpscap, a21.TargetFPS)
            a200.FPSUnlockStatus.Text = "Your target: "..a21.TargetFPS.." FPS"
        end
    end)

a198.JumpSliderButton.MouseButton1Down:Connect(function() a392.jump = true; a98(a198.JumpSliderButton, 0.9) end)
a198.ClickSliderButton.MouseButton1Down:Connect(function() a392.click = true; a98(a198.ClickSliderButton, 0.9) end)
a199.SpamSliderButton.MouseButton1Down:Connect(function() a392.spam = true; a98(a199.SpamSliderButton, 0.9) end)
a200.FPSButton.MouseButton1Down:Connect(function() a392.fps = true; a98(a200.FPSButton, 0.9) end)

table.insert(_G.UU.Connections, a3.InputEnded:Connect(function(a398)
    if a398.UserInputType == Enum.UserInputType.MouseButton1 then
        if a392.jump then a393_log((a21.JumpDelay - 5) / 25) end
        if a392.click then a395_log((a21.ClickDelay - 1) / 9) end
        if a392.spam then a396_log((a21.SpamDelay - 0.05) / 4.95) end
        if a392.fps then a397_log((a21.TargetFPS - 15) / 345) end
        a392.jump = false; a392.click = false; a392.spam = false; a392.fps = false
    end
end))

table.insert(_G.UU.Connections, a3.InputChanged:Connect(function(a398)
    if a398.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local a399 = a3:GetMouseLocation().X
    if a392.jump and a198.JumpDelaySlider then
        a393(math.clamp((a399 - a198.JumpDelaySlider.AbsolutePosition.X) / a198.JumpDelaySlider.AbsoluteSize.X, 0, 1))
    elseif a392.click and a198.ClickDelaySlider then
        a395(math.clamp((a399 - a198.ClickDelaySlider.AbsolutePosition.X) / a198.ClickDelaySlider.AbsoluteSize.X, 0, 1))
    elseif a392.spam and a199.SpamDelaySlider then
        a396(math.clamp((a399 - a199.SpamDelaySlider.AbsolutePosition.X) / a199.SpamDelaySlider.AbsoluteSize.X, 0, 1))
    elseif a392.fps and a200.FPSSlider then
        a397(math.clamp((a399 - a200.FPSSlider.AbsolutePosition.X) / a200.FPSSlider.AbsoluteSize.X, 0, 1))
    end
end))

a198.JumpDelayBox.FocusLost:Connect(function()
    a393_log((math.clamp(tonumber(a198.JumpDelayBox.Text) or a21.JumpDelay, 5, 30) - 5) / 25)
end)
a198.ClickDelayBox.FocusLost:Connect(function()
    a395_log((math.clamp(tonumber(a198.ClickDelayBox.Text) or a21.ClickDelay, 1, 10) - 1) / 9)
end)
a199.SpamDelayBox.FocusLost:Connect(function()
    a396_log((math.clamp(tonumber(a199.SpamDelayBox.Text) or a21.SpamDelay, 0.05, 5) - 0.05) / 4.95)
end)
a200.FPSValueBox.FocusLost:Connect(function()
    a397_log((math.clamp(tonumber(a200.FPSValueBox.Text) or a21.TargetFPS, 15, 360) - 15) / 345)
end)
a199.SpamInput.FocusLost:Connect(function()
    local a33_prev = a21.SpamKey
    a21.SpamKey = a199.SpamInput.Text:upper()
    if a21.SpamKey ~= a33_prev then
        a33_save_log("Spam Key → " .. a21.SpamKey)
    end
end)

local function a401(a402)
    if not a53("ClickType", 0.1) or a21.ClickType == a402 then return end
    a21.ClickType = a402; a364()
    a33_save_log("Click Mode → " .. a402)
end

a198.ClickTypeCurrent.MouseButton1Click:Connect(function() a401("Current") end)
a198.ClickTypeCenter.MouseButton1Click:Connect(function()  a401("Center")  end)
a198.ClickTypeRandom.MouseButton1Click:Connect(function()  a401("Random")  end)

a198.JumpToggleBtn.MouseButton1Click:Connect(function()
    if not a53("Jump", 0.3) then return end
    a21.JumpEnabled = not a21.JumpEnabled
    a160(a198.JumpToggleState, a21.JumpEnabled)
    if a21.JumpEnabled then task.wait(0.05); a365() else a56("Jump") end
    a361()
    a33_save_log("Auto Jump → " .. (a21.JumpEnabled and "Enabled" or "Disabled"))
end)

a198.ClickToggleBtn.MouseButton1Click:Connect(function()
    if not a53("Click", 0.3) then return end
    a21.ClickEnabled = not a21.ClickEnabled
    a160(a198.ClickToggleState, a21.ClickEnabled)
    if a21.ClickEnabled then task.wait(0.05); a368() else a56("Click") end
    a361()
    a33_save_log("Auto Click → " .. (a21.ClickEnabled and "Enabled" or "Disabled"))
end)

a199.AutoSpamToggleBtn.MouseButton1Click:Connect(function()
    if not a53("Spam", 0.3) then return end
    a21.AutoSpamEnabled = not a21.AutoSpamEnabled
    if a21.AutoSpamEnabled then
        local a403 = a199.SpamInput.Text:upper()
        local a404 = a23[a403]
        if not a404 then
            a21.AutoSpamEnabled = false
            a160(a199.AutoSpamToggleState, false)
            a199.Status.Text = "Status: Invalid key"
            a48(a199.Status, a44.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            a33_log("Key Spam → Invalid key '" .. a403 .. "'", Color3.fromRGB(220, 80, 80))
            a33()
            return
        end
        if a404 == Enum.KeyCode.P or a404 == a21.Keybind then
            a21.AutoSpamEnabled = false
            a160(a199.AutoSpamToggleState, false)
            a199.Status.Text = "Status: Key reserved"
            a48(a199.Status, a44.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            a33_log("Key Spam → Key '" .. a403 .. "' is reserved", Color3.fromRGB(220, 80, 80))
            a33()
            return
        end
        a21.SpamKey = a403
        a160(a199.AutoSpamToggleState, true)
        a199.Status.Text = "Status: Spamming "..a403
        a48(a199.Status, a44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        task.wait(0.05); a373()
    else
        a160(a199.AutoSpamToggleState, false)
        a199.Status.Text = "Status: Inactive"
        a48(a199.Status, a44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        a56("Spam")
    end
    a33_save_log("Key Spam → " .. (a21.AutoSpamEnabled and ("Enabled (" .. a21.SpamKey .. ")") or "Disabled"))
end)

a200.FPSToggleBtn.MouseButton1Click:Connect(function()
    if not a53("FPS", 0.3) then return end
    if not a352 then
        a200.FPSUnlockStatus.Text = "FPS Unlock not supported"
        a48(a200.FPSUnlockStatus, a44.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
        a33_log("FPS Unlock → Not supported by executor", Color3.fromRGB(220, 80, 80))
        return
    end
    a21.FPSUnlockEnabled = not a21.FPSUnlockEnabled
    a160(a200.FPSToggleState, a21.FPSUnlockEnabled)
    if a21.FPSUnlockEnabled then
        pcall(setfpscap, a21.TargetFPS)
        a200.FPSUnlockStatus.Text = "Your target: "..a21.TargetFPS.." FPS"
        a48(a200.FPSUnlockStatus, a44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
    else
        pcall(setfpscap, 60)
        a200.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
        a48(a200.FPSUnlockStatus, a44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    a33_save_log("FPS Unlock → " .. (a21.FPSUnlockEnabled and ("Enabled (" .. a21.TargetFPS .. " FPS)") or "Disabled"))
end)

a201.AutoRejoinToggleBtn.MouseButton1Click:Connect(function()
    if not a53("Rejoin", 0.3) then return end
    a21.AutoRejoinEnabled = not a21.AutoRejoinEnabled
    a160(a201.AutoRejoinToggleState, a21.AutoRejoinEnabled)
    if a21.AutoRejoinEnabled then
        a201.Status.Text = "Status: Enabled\n\nAutomatically rejoins when disconnected."
        a48(a201.Status, a44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        a378()
    else
        a376 = false; a56("Rejoin")
        a377b_disconnect()
        a201.Status.Text = "Status: Disabled\n\nWhen enabled, automatically rejoins the current server when disconnected."
        a48(a201.Status, a44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    a33_save_log("Auto Rejoin → " .. (a21.AutoRejoinEnabled and "Enabled" or "Disabled"))
end)

a202.ExecuteButton.MouseButton1Click:Connect(function()
    if not a53("Execute", 0.5) then return end
    local a405 = a202.LoadStringBox.Text
    local a405_lines = 0
    for _ in (a405.."\n"):gmatch("[^\n]*\n") do a405_lines = a405_lines + 1 end
    a202.Status.Text = "Executing..."
    a202.Status.TextColor3 = Color3.fromRGB(255, 200, 100)
    a48(a202.ExecuteButton, a44.Medium, { BackgroundColor3 = Color3.fromRGB(255, 200, 100) })
    local a406, _, a407err = a386(a405)
    if a406 then
        a202.AddOutput("Script executed successfully.", Color3.fromRGB(80, 220, 120))
        a33_log(string.format("Script executed ✓ (%d lines)", a405_lines), Color3.fromRGB(80, 220, 120))
        a48(a202.ExecuteButton, a44.Medium, { BackgroundColor3 = Color3.fromRGB(50, 180, 80) })
    else
        if a407err then
            a202.AddOutput(a407err, Color3.fromRGB(255, 100, 100))
            a33_log("Script error: " .. tostring(a407err):sub(1, 80), Color3.fromRGB(255, 100, 100))
        end
        a48(a202.ExecuteButton, a44.Medium, { BackgroundColor3 = Color3.fromRGB(180, 50, 50) })
    end
    task.wait(0.5)
    a202.Status.Text = "Ready"
    a202.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    a48(a202.ExecuteButton, a44.Medium, { BackgroundColor3 = Color3.fromRGB(100, 150, 255) })
end)

a202.AutoLoadToggleBtn.MouseButton1Click:Connect(function()
    if not a53("AutoLoad", 0.3) then return end
    a21.AutoLoadEnabled = not a21.AutoLoadEnabled
    a160(a202.AutoLoadToggleState, a21.AutoLoadEnabled)
    if a21.AutoLoadEnabled then
        if a21.SavedCode and a21.SavedCode ~= "" then
            a202.AddOutput("Auto-load enabled — will execute saved code on rejoin.", Color3.fromRGB(80, 220, 120))
            a33_log("Auto Load → Enabled (code ready)", Color3.fromRGB(80, 220, 120))
        else
            a202.AddOutput("Auto-load enabled — but no code is saved yet.", Color3.fromRGB(255, 200, 100))
            a33_log("Auto Load → Enabled (no code saved yet)", Color3.fromRGB(255, 200, 100))
        end
    else
        a202.AddOutput("Auto-load disabled.", Color3.fromRGB(160, 160, 160))
        a33_log("Auto Load → Disabled", Color3.fromRGB(160, 160, 160))
    end
    local a33_autoload_ok = a33()
    if not a33_autoload_ok then
        a33_log("Auto Load change → Save failed ✗", Color3.fromRGB(220, 80, 80))
    end
end)

local a408 = 0
local a409 = 0.3
local a408_lineUpdatePending = false

a202.LoadStringBox:GetPropertyChangedSignal("Text"):Connect(function()
    a21.SavedCode = a202.LoadStringBox.Text
    if not a408_lineUpdatePending then
        a408_lineUpdatePending = true
        task.defer(function()
            a408_lineUpdatePending = false
            a102(a202.LoadStringBox, a202.LineNumbers, a202.LoadStringScrollFrame, a202.LineNumbersScrollFrame)
        end)
    end
    local a410 = tick()
    if a410 - a408 >= a409 then
        a408 = a410
        a202.Status.Text = "Saving..."
        a202.Status.TextColor3 = Color3.fromRGB(100, 200, 255)
        local a410_ok = a33()
        if a410_ok then
            a202.Status.Text = "Saved"
            a202.Status.TextColor3 = Color3.fromRGB(80, 220, 120)
        else
            a202.Status.Text = "Save failed"
            a202.Status.TextColor3 = Color3.fromRGB(220, 80, 80)
        end
        task.delay(1.5, function()
            if a202.Status.Text == "Saved" or a202.Status.Text == "Save failed" then
                a202.Status.Text = "Ready"
                a202.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end)
    end
end)

a202.LoadStringScrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    a202.LineNumbersScrollFrame.CanvasPosition = Vector2.new(0, a202.LoadStringScrollFrame.CanvasPosition.Y)
end)

a203.KeybindButton.MouseButton1Click:Connect(function()
    if not a53("Keybind", 0.5) or a21.IsChangingKeybind then return end
    a21.IsChangingKeybind = true
    a203.KeybindButton.Text = "Press any key..."
    a33_log("Keybind: waiting for key press...", Color3.fromRGB(255, 200, 100))
    a203.KeybindButton.Active = false
    local a411
    local a412 = task.delay(5, function()
        _G.UU.Threads.KeybindTimeout = nil
        if a411 then a411:Disconnect() end
        a21.IsChangingKeybind    = false
        a203.KeybindButton.Active = true
        a203.KeybindButton.Text  = "Current Key: "..(a22[a21.Keybind] or a21.Keybind.Name)
        a33_log("Keybind: input timed out — no change.", Color3.fromRGB(255, 100, 100))
    end)
    _G.UU.Threads.KeybindTimeout = a412
    a411 = a3.InputBegan:Connect(function(a413, a414)
        if a413.UserInputType == Enum.UserInputType.Keyboard and not a414 then
            if _G.UU.Threads.KeybindTimeout then
                pcall(task.cancel, _G.UU.Threads.KeybindTimeout)
                _G.UU.Threads.KeybindTimeout = nil
            end
            a21.Keybind              = a413.KeyCode
            local a415              = a22[a413.KeyCode] or a413.KeyCode.Name
            a203.KeybindButton.Text  = "Current Key: "..a415
            a33_save_log("Keybind → " .. a415)
            a203.KeybindButton.Active = true
            a411:Disconnect()
            task.delay(0.1, function() a21.IsChangingKeybind = false end)
        end
    end)
end)

a203.AutoHideToggleBtn.MouseButton1Click:Connect(function()
    if not a53("AutoHide", 0.3) then return end
    a21.AutoHideEnabled = not a21.AutoHideEnabled
    a160(a203.AutoHideToggleState, a21.AutoHideEnabled)
    if a21.AutoHideEnabled then
        a203.Status.Text = "Auto Hide enabled — UI starts hidden on next execution."
        a48(a203.Status, a44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        a33_log("Auto Hide → Enabled (UI hidden on start)", Color3.fromRGB(50, 220, 100))
    else
        a203.Status.Text = "Auto Hide disabled — UI shows normally on start."
        a48(a203.Status, a44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        a33_log("Auto Hide → Disabled (UI shows on start)", Color3.fromRGB(180, 180, 180))
    end
    local a33_ok = a33()
    if a33_ok then
        a33_log("Auto Hide change → Saved ✓", Color3.fromRGB(80, 220, 120))
    else
        a33_log("Auto Hide change → Save failed ✗", Color3.fromRGB(220, 80, 80))
    end
end)

local function a416_applyVisuals(a417)
    for a418, a420 in pairs(a181) do
        local a421 = a418 == a417
        a46(a420.Button); a46(a420.Icon); a46(a420.Label)
        a420.Button.BackgroundColor3 = a421 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(35, 35, 42)
        a420.Button.Size             = a421 and UDim2.new(1, -4, 0, 54)       or UDim2.new(1, -10, 0, 50)
        a420.Icon.TextColor3         = a421 and Color3.fromRGB(255, 255, 255)  or Color3.fromRGB(180, 180, 180)
        a420.Icon.TextSize           = a421 and 19 or 18
        a420.Label.TextColor3        = a421 and Color3.fromRGB(255, 255, 255)  or Color3.fromRGB(180, 180, 180)
    end
end

local function a416(a417)
    if a21.CurrentTab == a417 and _G.UU.Debounces["Tab"] then return end
    if not a53("Tab", 0.15) then return end
    a21.CurrentTab = a417
    a33()
    for a418, a419 in pairs(a182) do
        if a418 == a417 then
            a419.Visible  = true
            a419.Position = UDim2.new(0, 15, 0, 0)
            a48(a419, a44.Smooth, { Position = UDim2.new(0, 5, 0, 0) })
        else
            a419.Visible = false
        end
    end
    a416_applyVisuals(a417)
end

for a422, a423 in ipairs(a194) do
    if a181[a423.name] then
        local a424 = a423.name
        a181[a424].Button.MouseButton1Click:Connect(function() a416(a424) end)
    end
end

local a425 = {}
local a426 = false

local function a427()
    if a426 or #a425 == 0 then return end
    a426 = true
    task.spawn(function()
        while #a425 > 0 do
            local a428 = table.remove(a425, 1)
            a428()
            task.wait(0.05)
        end
        a426 = false
    end)
end

local function a429(a428)
    table.insert(a425, a428)
    a427()
end

local function a430(a431, a432)
    local a433 = a60.Width * a432
    local a434 = a60.Height * a432
    return math.max(0, (a431.X - a433) / 2), math.max(0, (a431.Y - a434) / 2)
end

local function a435(a431, a432)
    local a436 = math.floor(60 * a432)
    return a436, math.max(0, (a431.X - a436) / 2), math.max(0, math.min(30, a431.Y - a436))
end

local function a437(a438)
    if not a61 then return end
    a62 = a438
    a48(a61, a44.Smooth, { Scale = a438 })
    a171.TextSize = math.floor(24 * a438)
end

local a439 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
local a440 = TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.In,  0, false, 0)

local function a441()
    if not a53("UI", 0.6) then return end
    a429(function()
        if a163.Visible then
            a21.SavedUIPosition = { X = a163.Position.X.Offset, Y = a163.Position.Y.Offset }
            a163.Size = UDim2.new(0, a60.Width, 0, a60.Height)
            local a442sc = a48(a61, a440, { Scale = 0 })
            local a442fd = a2:Create(a163, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
            a442fd:Play()
            a442sc.Completed:Wait()
            a163.Visible = false; a163.BackgroundTransparency = 0; a61.Scale = 0; a33()

            local a443 = a59()
            local a444 = math.floor(60 * a62)
            local a445, a446
            if a21.SavedReopenPosition then
                a445 = a21.SavedReopenPosition.X
                a446 = a21.SavedReopenPosition.Y
            else
                local _, a447, a448 = a435(a443, a62)
                a445, a446 = a447, a448
            end
            a170.Size = UDim2.new(0, a444, 0, a444)
            a170.Position = UDim2.new(0, a445, 0, a446)
            a170.ImageTransparency = 1; a171.TextTransparency = 1
            a170.Rotation = -180; a170.Visible = true
            local a449 = a2:Create(a170, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, a444, 0, a444),
                Position = UDim2.new(0, a445, 0, a446),
                ImageTransparency = 0, Rotation = 0,
            })
            local a450 = a2:Create(a171, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
            a449:Play(); task.delay(0.15, function() a450:Play() end); a449.Completed:Wait()
        else
            a177_stopSpin()
            a21.SavedReopenPosition = { X = a170.Position.X.Offset, Y = a170.Position.Y.Offset }
            local a451 = a2:Create(a170, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0, a170.Position.X.Offset, 0, a170.Position.Y.Offset),
                ImageTransparency = 1, Rotation = 90,
            })
            local a452 = a2:Create(a171, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
            a452:Play(); a451:Play(); a451.Completed:Wait()
            a170.Visible = false; a170.Rotation = 0; a170.ImageTransparency = 0; a171.TextTransparency = 0; a33()
            local a453, a454
            if a21.SavedUIPosition then
                a453 = a21.SavedUIPosition.X; a454 = a21.SavedUIPosition.Y
            else
                a453, a454 = a430(a59(), a62)
            end
            a163.Visible                = true
            a163.Size                   = UDim2.new(0, a60.Width, 0, a60.Height)
            a163.Position               = UDim2.new(0, a453, 0, a454 + 18)
            a163.BackgroundTransparency = 1
            a61.Scale                   = 0
            local a455pos = a2:Create(a163, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position               = UDim2.new(0, a453, 0, a454),
                BackgroundTransparency = 0,
            })
            local a455 = a48(a61, a439, { Scale = a62 })
            a455pos:Play()
            a455.Completed:Wait()
            a163.BackgroundTransparency = 0
        end
    end)
end

a167.MouseButton1Click:Connect(a441)
a167.MouseEnter:Connect(function()    a48(a167, a44.Fast, { BackgroundColor3 = Color3.fromRGB(240, 70, 70),  Size = UDim2.new(0, 32, 0, 32), Rotation = 90 }) end)
a167.MouseLeave:Connect(function()    a48(a167, a44.Fast, { BackgroundColor3 = Color3.fromRGB(220, 50, 50),  Size = UDim2.new(0, 28, 0, 28), Rotation = 0  }) end)
a167.MouseButton1Down:Connect(function() a48(a167, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 24, 0, 24) }) end)
a167.MouseButton1Up:Connect(function()   a48(a167, a44.Fast, { Size = UDim2.new(0, 28, 0, 28) }) end)

a170.MouseButton1Click:Connect(function() if not a176 then a441() end end)

table.insert(_G.UU.Connections, a3.InputBegan:Connect(function(a458, a459)
    if not a459 and a458.KeyCode == a21.Keybind and not a21.IsChangingKeybind then
        a441()
    end
end))

local a460 = Vector2.new(0, 0)
local a461 = false

local function a462()
    if a461 then return end
    a461 = true
    task.delay(0.1, function()
        a461 = false
        local a463 = a59()
        if math.abs(a463.X - a460.X) < 2 and math.abs(a463.Y - a460.Y) < 2 then return end
        a460 = a463
        local a464 = a63(a463)
        if _G.UU.UI.ResolutionLabel then _G.UU.UI.ResolutionLabel.Text = string.format("Resolution: %dx%d", a463.X, a463.Y) end
        if _G.UU.UI.DeviceLabel    then _G.UU.UI.DeviceLabel.Text     = "Device: "..a19() end
        a437(a464)
        a21.SavedUIPosition     = nil
        a21.SavedReopenPosition = nil
        local a465, a466 = a430(a463, a464)
        a163.Position = UDim2.new(0, a465, 0, a466)
        local a467 = math.floor(60 * a62)
        a465 = math.max(0, (a463.X - a467) / 2)
        a466 = math.max(0, math.min(30, a463.Y - a467))
        a170.Size     = UDim2.new(0, a467, 0, a467)
        a170.Position = UDim2.new(0, a465, 0, a466)
        a33()
    end)
end

if workspace.CurrentCamera then
    table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(a462))
end
table.insert(_G.UU.Connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(a462))
    end
end))

table.insert(_G.UU.Connections, a5.RenderStepped:Connect(function()
    a358 = a358 + 1
    local a468 = tick()
    if a468 - a357 >= 1 then
        a356 = math.floor(a358 / (a468 - a357))
        a358 = 0; a357 = a468
        if a197.FPSLabel then a197.FPSLabel.Text = "FPS: "..a356 end
        table.remove(a354, 1); table.insert(a354, a356)
        local a469, a470, a471 = math.huge, 0, 0
        for _, a472 in ipairs(a354) do
            a469 = math.min(a469, a472); a470 = math.max(a470, a472); a471 = a471 + a472
        end
        local a473 = math.floor(a471 / #a354)
        if a200.FPSStats then
            a200.FPSStats.Current.Text = "Current: "..a356
            a200.FPSStats.Avg.Text     = "Average: "..a473
            a200.FPSStats.MinMax.Text  = string.format("Min: %d | Max: %d", a469, a470)
        end
        local a474 = a10:GetTotalMemoryUsageMb()
        a359 = math.max(a359, a474)
        if a197.MemoryLabel then a197.MemoryLabel.Text = string.format("Memory: %.1f MB", a474) end
        if a200.MemoryStats then
            a200.MemoryStats.Current.Text = string.format("Current: %.1f MB", a474)
            a200.MemoryStats.Peak.Text    = string.format("Peak: %.1f MB", a359)
        end
    end
    if a358 % 30 == 0 then
        local a475 = math.floor(a11:GetNetworkPing() * 1000)
        if a197.PingLabel then
            a197.PingLabel.Text      = "Ping: "..a475.." ms"
            a197.PingLabel.TextColor3 = a475 < 100 and Color3.fromRGB(0, 255, 0) or a475 < 200 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        table.remove(a355, 1); table.insert(a355, a475)
        local a476, a477, a478 = math.huge, 0, 0
        for _, a479 in ipairs(a355) do
            a476 = math.min(a476, a479); a477 = math.max(a477, a479); a478 = a478 + a479
        end
        local a480 = math.floor(a478 / #a355)
        if a200.PingStats then
            a200.PingStats.Current.Text = "Current: "..a475.."ms"
            a200.PingStats.Avg.Text     = "Average: "..a480.."ms"
            a200.PingStats.MinMax.Text  = string.format("Min: %dms | Max: %dms", a476, a477)
            local a481, a482
            if     a475 < 50  then a481, a482 = "Excellent",  Color3.fromRGB(50,  220, 100)
            elseif a475 < 100 then a481, a482 = "Good",       Color3.fromRGB(100, 200, 255)
            elseif a475 < 200 then a481, a482 = "Fair",       Color3.fromRGB(255, 200, 100)
            elseif a475 < 300 then a481, a482 = "Poor",       Color3.fromRGB(255, 150, 50)
            else                   a481, a482 = "Very Poor",  Color3.fromRGB(220, 50,  50)
            end
            a200.PingStats.Quality.Text      = a481
            a200.PingStats.Quality.TextColor3 = a482
        end
    end
end))

local a483 = a41()

if a483 then
    if a203.KeybindButton then a203.KeybindButton.Text = "Current Key: "..(a22[a21.Keybind] or a21.Keybind.Name) end
    if a199.SpamInput     then a199.SpamInput.Text     = a21.SpamKey end
    if a202.LoadStringBox then a202.LoadStringBox.Text = a21.SavedCode end

    a393((a21.JumpDelay  - 5)    / 25)
    a395((a21.ClickDelay - 1)    / 9)
    a396((a21.SpamDelay  - 0.05) / 4.95)
    a397((a21.TargetFPS  - 15)   / 345)
    a364()

    a160(a202.AutoLoadToggleState, a21.AutoLoadEnabled)

    a160(a203.AutoHideToggleState, a21.AutoHideEnabled)
    if a21.AutoHideEnabled then
        a203.Status.Text      = "Auto Hide enabled — UI starts hidden on next execution."
        a203.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
    else
        a203.Status.Text      = "Auto Hide disabled — UI shows normally on start."
        a203.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    end

    if a21.AutoRejoinEnabled then
        a160(a201.AutoRejoinToggleState, true)
        a201.Status.Text      = "Status: Enabled\n\nAutomatically rejoins when disconnected."
        a201.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        a378()
    else
        a160(a201.AutoRejoinToggleState, false)
    end

    if a21.FPSUnlockEnabled and a352 then
        a160(a200.FPSToggleState, true)
        a200.FPSUnlockStatus.TextColor3 = Color3.fromRGB(50, 220, 100)
        a200.FPSUnlockStatus.Text       = "Current Limit: "..a21.TargetFPS.." FPS (Custom)"
        pcall(setfpscap, a21.TargetFPS)
    else
        a160(a200.FPSToggleState, false)
        if a352 then pcall(setfpscap, 60) end
    end

    a160(a198.JumpToggleState, a21.JumpEnabled)
    if a21.JumpEnabled then task.wait(0.1); a365() end

    a160(a198.ClickToggleState, a21.ClickEnabled)
    if a21.ClickEnabled then task.wait(0.1); a368() end

    if a21.AutoSpamEnabled and a23[a21.SpamKey] then
        a160(a199.AutoSpamToggleState, true)
        a199.Status.Text      = "Status: Spamming "..a21.SpamKey
        a199.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        task.wait(0.1); a373()
    else
        a21.AutoSpamEnabled = false
        a160(a199.AutoSpamToggleState, false)
    end

    a361()
    task.defer(function()
        a33_log("Config loaded for "..a12.." (Id: "..a13..")", Color3.fromRGB(100, 200, 255))
    end)
else
    a393(0.2); a395(0.22); a396(0.01); a397(0.13)
    a364()
    a160(a198.JumpToggleState,    false)
    a160(a198.ClickToggleState,   false)
    a160(a199.AutoSpamToggleState, false)
    a160(a200.FPSToggleState,     false)
    a160(a201.AutoRejoinToggleState, false)
    a160(a202.AutoLoadToggleState, false)
    a160(a203.AutoHideToggleState, false)
    a200.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
    a203.Status.Text          = "Auto Hide disabled — UI shows normally on start."
    a203.Status.TextColor3    = Color3.fromRGB(180, 180, 180)
    a361()
    task.defer(function()
        a33_log("Fresh start — no saved config found.", Color3.fromRGB(255, 200, 100))
        a33_log("Using defaults. Keybind: G | Auto Hide: Off", Color3.fromRGB(150, 150, 150))
    end)
end

task.spawn(function()
    pcall(function()
        if _G.UU.UI.PlayerImage then
            _G.UU.UI.PlayerImage.Image = "rbxthumb://type=AvatarHeadShot&id="..a13.."&w=420&h=420"
        end
        if _G.UU.UI.GameName and _G.UU.UI.GameImage then
            local a484 = a8:GetProductInfo(game.PlaceId)
            _G.UU.UI.GameName.Text = a484.Name
            if a484.IconImageAssetId and a484.IconImageAssetId ~= 0 then
                _G.UU.UI.GameImage.Image = "rbxthumb://type=Asset&id="..a484.IconImageAssetId.."&w=420&h=420"
            end
        end
    end)
end)

a102(a202.LoadStringBox, a202.LineNumbers, a202.LoadStringScrollFrame, a202.LineNumbersScrollFrame)

a162.Destroying:Connect(function()
    a33()
    a177_stopSpin()
    for a485, a15 in pairs(_G.UU.Threads) do
        if a15 and typeof(a15) == "thread" and coroutine.status(a15) ~= "dead" then
            pcall(task.cancel, a15)
        end
        _G.UU.Threads[a485] = nil
    end
    if a377b then pcall(function() a377b:Disconnect() end); a377b = nil end
end)

for a486, a487 in pairs(a182) do a487.Visible = false end

local a488 = a59()
if a488.X < 100 or a488.Y < 100 then
    repeat task.wait() until workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X > 100
end

task.wait(0.1)

local a489 = not a21.AutoHideEnabled

a488 = a59()
a460 = a488
a62 = a63(a488)

local a490, a491
if a21.SavedUIPosition and a21.SavedUIPosition.X and a21.SavedUIPosition.Y then
    a490 = a21.SavedUIPosition.X
    a491 = a21.SavedUIPosition.Y
else
    a490, a491 = a430(a488, a62)
end

local a492, a493, a494
if a21.SavedReopenPosition and a21.SavedReopenPosition.X and a21.SavedReopenPosition.Y then
    a492 = math.floor(60 * a62)
    a493 = a21.SavedReopenPosition.X
    a494 = a21.SavedReopenPosition.Y
else
    a492, a493, a494 = a435(a488, a62)
end

local a416_startTab = a21.CurrentTab or "Home"
for a418, a419 in pairs(a182) do
    a419.Visible = (a418 == a416_startTab)
end
a416_applyVisuals(a416_startTab)
a21.CurrentTab = a416_startTab
a33()

if a489 then
    a163.Visible                = true
    a163.Size                   = UDim2.new(0, a60.Width, 0, a60.Height)
    a163.Position               = UDim2.new(0, a490, 0, a491 + 24)
    a163.BackgroundTransparency = 1
    a61.Scale                   = 0
    a170.Visible                = false

    local a495pos = a2:Create(a163, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position            = UDim2.new(0, a490, 0, a491),
        BackgroundTransparency = 0,
    })
    local a495sc = a48(a61, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = a62 })
    a495pos:Play()
    a495sc.Completed:Wait()
    a163.BackgroundTransparency = 0
else
    a163.Visible               = false
    a170.Size                  = UDim2.new(0, 0, 0, 0)
    a170.Position              = UDim2.new(0, a493 + a492 / 2, 0, a494 + a492 / 2)
    a170.ImageTransparency     = 1
    a171.TextTransparency      = 1
    a170.Rotation              = -270
    a170.Visible               = true

    local a495sym = a2:Create(a170, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size              = UDim2.new(0, a492, 0, a492),
        Position          = UDim2.new(0, a493, 0, a494),
        ImageTransparency = 0,
        Rotation          = 0,
    })
    local a495txt = a2:Create(a171, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
    a495sym:Play()
    task.delay(0.2, function() a495txt:Play() end)
    a495sym.Completed:Wait()
end

if queue_on_teleport and not _G.UU.TeleportQueued then
    _G.UU.TeleportQueued = true
    pcall(function()
        queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/6942x/UniversalUtility/main/Init.lua", true))()')
    end)
end

_G.UU.Loaded    = true
_G.UU.LoadLock  = false

task.defer(function()
    if a483 and a21.AutoLoadEnabled and a21.SavedCode and a21.SavedCode ~= "" then
        a202.Status.Text = "Executing..."
        a202.Status.TextColor3 = Color3.fromRGB(255, 200, 100)
        a33_log("Auto Load → executing saved script on start...", Color3.fromRGB(255, 200, 100))
        local a496, _, a497err = a386(a21.SavedCode)
        if a496 then
            a202.AddOutput("Auto-load executed successfully.", Color3.fromRGB(80, 220, 120))
            a33_log("Auto Load → script executed ✓", Color3.fromRGB(80, 220, 120))
        else
            if a497err then
                a202.AddOutput(a497err, Color3.fromRGB(255, 100, 100))
                a33_log("Auto Load error: " .. tostring(a497err):sub(1, 80), Color3.fromRGB(255, 100, 100))
            end
        end
        a202.Status.Text = "Ready"
        a202.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)

return _G.UU
