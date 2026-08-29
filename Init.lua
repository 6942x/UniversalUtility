local w, w1, w2, w3, w4 = game:GetService("HttpService"), game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("VirtualInputManager")
local w5, w6, w7, w8, w9 = game:GetService("RunService"), game:GetService("CoreGui"), game:GetService("TeleportService"), game:GetService("MarketplaceService"), game:GetService("TextService")
local w10 = game:GetService("Stats")
local w11 = w1.LocalPlayer

if not w11 then
    repeat w11 = w1.LocalPlayer; task.wait() until w11
end

local w12, w13 = w11.Name, w11.UserId
if not w12 or w12 == "" then
    repeat w12 = w11.Name; task.wait() until w12 and w12 ~= ""
end

_G.UU = _G.UU or {}
if _G.UU.Loaded then
    if _G.UU.Threads then
        for w14, w15 in pairs(_G.UU.Threads) do
            if w15 and typeof(w15) == "thread" and coroutine.status(w15) ~= "dead" then
                pcall(task.cancel, w15)
            end
            _G.UU.Threads[w14] = nil
        end
    end
    if _G.UU.Connections then
        for w16, w17 in pairs(_G.UU.Connections) do
            pcall(function() w17:Disconnect() end)
        end
        _G.UU.Connections = {}
    end
    _G.UU.TeleportQueued = false
    local w18 = w6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
    if w18 then w18:Destroy() end
    _G.UU.Loaded = false
    _G.UU.LoadLock = false
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

local function w19()
    if w3.TouchEnabled and not w3.KeyboardEnabled and not w3.MouseEnabled then return "Mobile"
    elseif w3.GamepadEnabled and not w3.KeyboardEnabled then return "Console"
    elseif w3.KeyboardEnabled and w3.MouseEnabled then return "PC" end
    local w20 = w3:GetLastInputType()
    if w20 == Enum.UserInputType.Touch then return "Mobile"
    elseif w20 == Enum.UserInputType.Gamepad1 or w20 == Enum.UserInputType.Gamepad2 then return "Console" end
    return "PC"
end

local w21 = {
    Keybind = Enum.KeyCode.G,
    MousePosEnabled = false,
    MousePosSaved = { X = 960, Y = 540 },
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
_G.UU.CFG = w21

local w22, w23 = {}, {}
for w24 = 65, 90 do
    local w25 = string.char(w24)
    w22[Enum.KeyCode[w25]] = w25
    w23[w25] = Enum.KeyCode[w25]
end

local w26 = { "One","Two","Three","Four","Five","Six","Seven","Eight","Nine" }
for w27 = 0, 9 do
    local w28 = w27 == 0 and "Zero" or w26[w27]
    w22[Enum.KeyCode[w28]] = tostring(w27)
    w23[tostring(w27)] = Enum.KeyCode[w28]
end

for w29 = 1, 12 do
    w22[Enum.KeyCode["F"..w29]] = "F"..w29
    w23["F"..w29] = Enum.KeyCode["F"..w29]
end

for w30, w31 in pairs({
    LeftControl="Left Ctrl", RightControl="Right Ctrl",
    LeftShift="Left Shift", RightShift="Right Shift",
    LeftAlt="Left Alt", RightAlt="Right Alt",
    Tab="Tab", CapsLock="Caps Lock",
    Space="Space", Return="Enter",
    Backspace="Backspace", Delete="Delete",
    Insert="Insert", Home="Home",
    End="End", PageUp="Page Up",
    PageDown="Page Down",
}) do w22[Enum.KeyCode[w30]] = w31 end
_G.UU.KCN = w22
_G.UU.KCM = w23

local function w32()
    return "UniversalUtility/Accounts/" .. w12 .. ".json"
end

local function w32EF()
    if not (makefolder and isfolder) then return end
    if not isfolder("UniversalUtility") then
        makefolder("UniversalUtility")
    end
    if not isfolder("UniversalUtility/Accounts") then
        makefolder("UniversalUtility/Accounts")
    end
end

local function w33()
    if not writefile then return end
    w32EF()
    local w34, w35 = _G.UU.UI and _G.UU.UI.MainFrame, _G.UU.UI and _G.UU.UI.ReopenButton
    if w34 and w34.Visible then
        w21.SavedUIPosition = { X = w34.Position.X.Offset, Y = w34.Position.Y.Offset }
    end
    if w35 and w35.Visible then
        w21.SavedReopenPosition = { X = w35.Position.X.Offset, Y = w35.Position.Y.Offset }
    end
    local w36 = {
        UserId = w13,
        Username = w12,
        Keybind = w21.Keybind.Name,
        MousePosEnabled = w21.MousePosEnabled,
        MousePosSaved = w21.MousePosSaved,
        JumpEnabled = w21.JumpEnabled,
        ClickEnabled = w21.ClickEnabled,
        AutoRejoinEnabled = w21.AutoRejoinEnabled,
        FPSUnlockEnabled = w21.FPSUnlockEnabled,
        AutoSpamEnabled = w21.AutoSpamEnabled,
        AutoLoadEnabled = w21.AutoLoadEnabled,
        AutoHideEnabled = w21.AutoHideEnabled,
        TargetFPS = w21.TargetFPS,
        JumpDelay = w21.JumpDelay,
        ClickDelay = w21.ClickDelay,
        SpamDelay = w21.SpamDelay,
        SpamKey = w21.SpamKey,
        SavedCode = w21.SavedCode,
        CurrentTab = w21.CurrentTab,
        UIPosition = w21.UIPosition,
        ReopenPosition = w21.ReopenPosition,
        SavedUIPosition = w21.SavedUIPosition,
        SavedReopenPosition = w21.SavedReopenPosition,
    }
    local w37, w38 = pcall(function()
        writefile(w32(), w:JSONEncode(w36))
    end)
    if w37 then
        _G.UU.LastSaveTime = tick()
        _G.UU.SavePending = false
    else
        if _G.UU.AddActivityLog then
            _G.UU.AddActivityLog("Save error: " .. tostring(w38), Color3.fromRGB(220, 80, 80))
        end
    end
    return w37
end

_G.UU.SaveCFG = w33

local wPL = {}
local function w33L(w33Mg, w33Co)
    if _G.UU.AddActivityLog then
        _G.UU.AddActivityLog(w33Mg, w33Co)
    else
        table.insert(wPL, { msg = w33Mg, col = w33Co })
    end
end

local function w33SL(w33Ac)
    local w33Ok = w33()
    if w33Ok then
        w33L(w33Ac .. " → Saved ✓", Color3.fromRGB(80, 220, 120))
    else
        w33L(w33Ac .. " → Save failed ✗", Color3.fromRGB(220, 80, 80))
    end
end

local function w39()
    if _G.UU.SavePending then return end
    _G.UU.SavePending = true
    local w40 = tick() - _G.UU.LastSaveTime
    if w40 >= 0.1 then
        w33()
    else
        task.delay(0.1 - w40, function()
            if _G.UU.SavePending then
                w33()
            end
        end)
    end
end

_G.UU.DebouncedSave = w39

local function w41()
    if not (readfile and isfile) then return false end
    local w32Pa = w32()
    if not isfile(w32Pa) then return false end
    local w42, w43 = pcall(function() return w:JSONDecode(readfile(w32Pa)) end)
    if not w42 or not w43 or w43.UserId ~= w13 then return false end
    w21.Keybind = Enum.KeyCode[w43.Keybind] or Enum.KeyCode.G
    w21.MousePosEnabled = w43.MousePosEnabled or false
    w21.MousePosSaved = w43.MousePosSaved or { X = 960, Y = 540 }
    w21.JumpEnabled = w43.JumpEnabled or false
    w21.ClickEnabled = w43.ClickEnabled or false
    w21.AutoRejoinEnabled = w43.AutoRejoinEnabled or false
    w21.FPSUnlockEnabled = w43.FPSUnlockEnabled or false
    w21.AutoSpamEnabled = w43.AutoSpamEnabled or false
    w21.AutoLoadEnabled = w43.AutoLoadEnabled or false
    w21.AutoHideEnabled = w43.AutoHideEnabled or false
    w21.TargetFPS = w43.TargetFPS or 60
    w21.JumpDelay = w43.JumpDelay or 10.0
    w21.ClickDelay = w43.ClickDelay or 3.0
    w21.SpamDelay = w43.SpamDelay or 0.1
    w21.SpamKey = w43.SpamKey or "Q"
    w21.SavedCode = w43.SavedCode or ""
    w21.CurrentTab = w43.CurrentTab or "Home"
    w21.UIPosition = w43.UIPosition or { X = 0.5, Y = 0.5 }
    w21.ReopenPosition = w43.ReopenPosition or { X = 0.5, Y = 30 }
    w21.SavedUIPosition = w43.SavedUIPosition or nil
    w21.SavedReopenPosition = w43.SavedReopenPosition or nil
    return true
end

local w44 = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Back = TweenInfo.new(0.50, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    BackIn = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    Elastic = TweenInfo.new(0.60, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.30, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
}

local w45 = {}
local function w46(w47)
    if w45[w47] then w45[w47]:Cancel(); w45[w47] = nil end
end

local function w48(w47, w49, w50)
    w46(w47)
    local w51 = w2:Create(w47, w49, w50)
    w45[w47] = w51
    w51:Play()
    w51.Completed:Connect(function(w52)
        if w52 == Enum.TweenStatus.Completed then w45[w47] = nil end
    end)
    return w51
end

local function w53(w54, w55)
    if _G.UU.Debounces[w54] then return false end
    _G.UU.Debounces[w54] = true
    task.delay(w55 or 0.3, function() _G.UU.Debounces[w54] = false end)
    return true
end

local function w56(w57)
    if _G.UU.Threads[w57] then
        local w58 = _G.UU.Threads[w57]
        _G.UU.Threads[w57] = nil
        if typeof(w58) == "thread" and coroutine.status(w58) ~= "dead" then
            pcall(task.cancel, w58)
        end
    end
end

local function w59()
    return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
end

local w60, w61, w62 = { Width = 650, Height = 500 }, nil, 1
local function w63(w64)
    return math.clamp(math.min(w64.X / 1920, w64.Y / 1080), 0.75, 1.4)
end

local function w65(w66, w67)
    local w68 = Instance.new("UICorner", w66)
    w68.CornerRadius = UDim.new(0, w67 or 8)
    return w68
end

local function w69(w66, w70, w71, w72)
    local w73 = Instance.new("UIGradient", w66)
    w73.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, w70),
        ColorSequenceKeypoint.new(1, w71),
    }
    w73.Rotation = w72 or 90
    return w73
end

local function w74(w66, w75, w76, w77, w78, w79M, w80M, w81Lb)
    local w82 = Instance.new("Frame", w66)
    w82.Size = w75
    w82.Position = w76
    w82.BackgroundTransparency = 1
    local w83 = Instance.new("TextLabel", w82)
    w83.Size = UDim2.new(1, 0, 0, 18)
    w83.BackgroundTransparency = 1
    w83.Text = w81Lb or w78
    w83.Font = Enum.Font.Gotham
    w83.TextSize = 12
    w83.TextColor3 = Color3.fromRGB(180, 180, 180)
    w83.TextXAlignment = Enum.TextXAlignment.Left
    local w84 = Instance.new("Frame", w82)
    w84.Size = UDim2.new(1, -60, 0, 6)
    w84.Position = UDim2.new(0, 0, 0, 22)
    w84.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    w84.BorderSizePixel = 0
    w65(w84, 3)
    local w85, w86M = Instance.new("Frame", w84), w79M or 0
    local w87M = (w80M or 1) - w86M
    local w88I = (w77 - w86M) / math.max(w87M, 0.001)
    w85.Size = UDim2.new(math.clamp(w88I, 0, 1), 0, 1, 0)
    w85.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    w85.BorderSizePixel = 0
    w65(w85, 3)
    local w89 = Instance.new("TextButton", w84)
    w89.Size = UDim2.new(1, 0, 1, 0)
    w89.BackgroundTransparency = 1
    w89.Text = ""
    local w90 = Instance.new("TextBox", w82)
    w90.Size = UDim2.new(0, 50, 0, 24)
    w90.Position = UDim2.new(1, -50, 0, 16)
    w90.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    w90.Text = tostring(w77)
    w90.Font = Enum.Font.Gotham
    w90.TextScaled = true
    w90.TextColor3 = Color3.fromRGB(255, 255, 255)
    w90.ClearTextOnFocus = false
    w90.BorderSizePixel = 0
    w65(w90, 5)
    return w82, w84, w85, w89, w90
end

local function w91(w92, w93, w94, w95, w96, w97)
    w48(w92, w44.Fast, { Size = UDim2.new((w94 - w95) / (w96 - w95), 0, 1, 0) })
    w93.Text = string.format(w97, w94)
end

local function w91Si(w92, w93, w94, w95, w96, w97)
    w92.Size = UDim2.new((w94 - w95) / (w96 - w95), 0, 1, 0)
    w93.Text = string.format(w97, w94)
end

local function w98(w99, w100)
    task.spawn(function()
        w100 = w100 or 0.95
        local w101 = w99.Size
        w48(w99, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(w101.X.Scale * w100, w101.X.Offset * w100, w101.Y.Scale * w100, w101.Y.Offset * w100)
        })
        task.wait(0.1)
        w48(w99, w44.Back, { Size = w101 })
    end)
end

local function w102(w103, w104, w105, w106)
    local w107, w108 = w103.Text, 1
    for _ in w107:gmatch("\n") do w108 = w108 + 1 end
    local w109P = {}
    for w110 = 1, w108 do w109P[w110] = tostring(w110) end
    w104.Text = table.concat(w109P, "\n") .. "\n"
    local w111 = w9:GetTextSize(w103.Text, w103.TextSize, w103.Font, Vector2.new(w103.AbsoluteSize.X - 10, math.huge))
    local w112 = math.max(200, w111.Y + 20)
    w103.Size = UDim2.new(1, -10, 0, w112)
    w105.CanvasSize = UDim2.new(0, 0, 0, w112)
    w106.CanvasSize = UDim2.new(0, 0, 0, w112)
    w104.Size = UDim2.new(1, -5, 0, w112)
end

local function w113(w114, w115)
    local w116, w117, w118, w119 = false, nil, nil, nil
    w114.InputBegan:Connect(function(w120)
        if w120.UserInputType == Enum.UserInputType.MouseButton1 or w120.UserInputType == Enum.UserInputType.Touch then
            w116 = true
            w117 = w120.Position
            w118 = w114.Position
            if w119 then w119:Disconnect() end
            w119 = w3.InputChanged:Connect(function(w121)
                if (w121.UserInputType == Enum.UserInputType.MouseMovement or w121.UserInputType == Enum.UserInputType.Touch) and w116 then
                    local w122 = w121.Position - w117
                    w114.Position = UDim2.new(w118.X.Scale, w118.X.Offset + w122.X, w118.Y.Scale, w118.Y.Offset + w122.Y)
                end
            end)
            w120.Changed:Connect(function()
                if w120.UserInputState == Enum.UserInputState.End then
                    w116 = false
                    if w119 then w119:Disconnect(); w119 = nil end
                    if w115 then w115() end
                end
            end)
        end
    end)
end

local function w123(w114, w75, w124, w125)
    local w126 = Instance.new("Frame", w114)
    w126.Size = w75
    w126.Position = w124
    w126.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    w126.BorderSizePixel = 0
    w65(w126, 8)
    Instance.new("UIStroke", w126).Color = Color3.fromRGB(50, 50, 60)
    local w127 = Instance.new("TextLabel", w126)
    w127.Size = UDim2.new(1, -10, 1, -10)
    w127.Position = UDim2.new(0, 5, 0, 5)
    w127.BackgroundTransparency = 1
    w127.Text = w125
    w127.Font = Enum.Font.GothamBold
    w127.TextSize = 14
    w127.TextColor3 = Color3.fromRGB(180, 180, 180)
    w127.TextXAlignment = Enum.TextXAlignment.Center
    w127.TextWrapped = true
    w127.TextYAlignment = Enum.TextYAlignment.Top
    return w126, w127
end

local function w128(w114, w129)
    local w130 = Instance.new("Frame", w114)
    w130.Size = UDim2.new(1, -20, 0, 1)
    w130.Position = UDim2.new(0, 10, 0, w129)
    w130.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    w130.BorderSizePixel = 0
    return w130
end

local function w131(w114, w125, w129, w132)
    local w133 = Instance.new("TextLabel", w114)
    w133.Size = UDim2.new(1, -20, 0, 20)
    w133.Position = UDim2.new(0, 10, 0, w129)
    w133.BackgroundTransparency = 1
    w133.Text = w125
    w133.Font = Enum.Font.GothamBold
    w133.TextSize = 13
    w133.TextColor3 = w132 or Color3.fromRGB(200, 200, 200)
    w133.TextXAlignment = Enum.TextXAlignment.Left
    return w133
end

local function w134(w114, w135, w136)
    local w137 = Instance.new("Frame", w114)
    w137.Size = UDim2.new(1, 0, 0, w135)
    w137.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    w137.BorderSizePixel = 0
    w137.LayoutOrder = w136 or 1
    w65(w137, 10)
    w69(w137, Color3.fromRGB(35, 35, 42), Color3.fromRGB(40, 40, 47), 90)
    return w137
end

local function w138(w114, w125, w139)
    local w140 = Instance.new("TextLabel", w114)
    w140.Size = UDim2.new(1, -20, 0, 16)
    w140.Position = UDim2.new(0, 10, 0, w139)
    w140.BackgroundTransparency = 1
    w140.Text = w125
    w140.Font = Enum.Font.Gotham
    w140.TextSize = 12
    w140.TextColor3 = Color3.fromRGB(150, 150, 150)
    w140.TextXAlignment = Enum.TextXAlignment.Left
    return w140
end

local function w141(w114, w125, w139)
    local w142 = Instance.new("TextLabel", w114)
    w142.Size = UDim2.new(1, -20, 0, 26)
    w142.Position = UDim2.new(0, 10, 0, w139)
    w142.BackgroundTransparency = 1
    w142.Text = w125
    w142.Font = Enum.Font.GothamBold
    w142.TextSize = 18
    w142.TextXAlignment = Enum.TextXAlignment.Left
    return w142
end

local function w143(w114, w125, w139)
    local w144 = Instance.new("Frame", w114)
    w144.Size = UDim2.new(1, -20, 0, 36)
    w144.Position = UDim2.new(0, 10, 0, w139)
    w144.BackgroundTransparency = 1
    local w145 = Instance.new("TextLabel", w144)
    w145.Size = UDim2.new(1, -70, 1, 0)
    w145.BackgroundTransparency = 1
    w145.Text = w125
    w145.Font = Enum.Font.GothamBold
    w145.TextSize = 14
    w145.TextColor3 = Color3.fromRGB(200, 200, 200)
    w145.TextXAlignment = Enum.TextXAlignment.Left
    return w144, w145
end

local w146 = {}
local function w147(w114, w75, w148, w149, w150)
    local w151, w152 = w75.X.Offset or 56, w75.Y.Offset or 28
    local w153, w154 = w152 - 6, 3
    local w155, w156 = w151 - w153 - 3, Instance.new("Frame", w114)
    w156.Size = UDim2.new(0, w151, 0, w152)
    w156.Position = w148
    w156.AnchorPoint = Vector2.new(0.5, 0.5)
    w156.BorderSizePixel = 0
    w156.BackgroundColor3 = w149 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70)
    w65(w156, w152 / 2)
    local w157 = Instance.new("Frame", w156)
    w157.Size = UDim2.new(0, w153, 0, w153)
    w157.Position = UDim2.new(0, w149 and w155 or w154, 0.5, 0)
    w157.AnchorPoint = Vector2.new(0, 0.5)
    w157.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    w157.BorderSizePixel = 0
    w65(w157, w153 / 2)
    local w158 = Instance.new("TextButton", w156)
    w158.Size = UDim2.new(1, 0, 1, 0)
    w158.BackgroundTransparency = 1
    w158.Text = ""
    w158.ZIndex = w156.ZIndex + 2
    local w159 = { value = w149, track = w156, knob = w157, offX = w154, onX = w155 }
    w146[w158] = w159
    if w150 then
        w158.MouseButton1Click:Connect(function()
            w159.value = not w159.value
            w48(w156, w44.Fast, { BackgroundColor3 = w159.value and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70) })
            w48(w157, w44.Fast, { Position = UDim2.new(0, w159.value and w155 or w154, 0.5, 0) })
            w150(w159.value)
        end)
    end
    return w158, w156, w157, w159
end

local function w160(w159, w149)
    if not w159 then return end
    w159.value = w149
    w48(w159.track, w44.Fast, { BackgroundColor3 = w149 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70) })
    w48(w159.knob, w44.Fast, { Position = UDim2.new(0, w149 and w159.onX or w159.offX, 0.5, 0) })
end

local function w498(w498B, w498I, w498H, w498P)
    w498B.MouseEnter:Connect(function()
        w48(w498B, w44.Fast, w498H)
    end)
    w498B.MouseLeave:Connect(function()
        w48(w498B, w44.Fast, w498I)
    end)
    w498B.MouseButton1Down:Connect(function()
        w48(w498B, w44.Fast, w498P)
    end)
    w498B.MouseButton1Up:Connect(function()
        w48(w498B, w44.Fast, w498H)
    end)
end

local function w499(w499Pa, w499Sz, w499Po, w499BC)
    local w499Ot = Instance.new("Frame", w499Pa)
    w499Ot.Size = w499Sz
    w499Ot.Position = w499Po
    w499Ot.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    w499Ot.BorderSizePixel = 0
    w65(w499Ot, 8)
    Instance.new("UIStroke", w499Ot).Color = Color3.fromRGB(50, 50, 60)
    local w499Sr = Instance.new("ScrollingFrame", w499Ot)
    w499Sr.Size = UDim2.new(1, -4, 1, -4)
    w499Sr.Position = UDim2.new(0, 2, 0, 2)
    w499Sr.BackgroundTransparency = 1
    w499Sr.BorderSizePixel = 0
    w499Sr.ScrollBarThickness = 3
    w499Sr.ScrollBarImageColor3 = w499BC or Color3.fromRGB(100, 150, 255)
    w499Sr.ScrollBarImageTransparency = 0.5
    w499Sr.CanvasSize = UDim2.new(0, 0, 0, 0)
    w499Sr.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local w499L = Instance.new("UIListLayout", w499Sr)
    w499L.SortOrder = Enum.SortOrder.LayoutOrder
    w499L.Padding = UDim.new(0, 2)
    local w499P = Instance.new("UIPadding", w499Sr)
    w499P.PaddingLeft = UDim.new(0, 6)
    w499P.PaddingRight = UDim.new(0, 6)
    w499P.PaddingTop = UDim.new(0, 4)
    w499P.PaddingBottom = UDim.new(0, 4)
    local w499Em = Instance.new("TextLabel", w499Sr)
    w499Em.Size = UDim2.new(1, 0, 0, 20)
    w499Em.BackgroundTransparency = 1
    w499Em.Font = Enum.Font.Code
    w499Em.TextSize = 11
    w499Em.TextColor3 = Color3.fromRGB(90, 90, 100)
    w499Em.TextXAlignment = Enum.TextXAlignment.Left
    w499Em.LayoutOrder = 1
    local w499Ca = 1
    local function w499Ad(w499Mg, w499Co)
        w499Em.Visible = false
        w499Ca = w499Ca + 1
        local w499T, w499La = os.date and os.date("%H:%M:%S") or "—", Instance.new("TextLabel", w499Sr)
        w499La.Size = UDim2.new(1, 0, 0, 0)
        w499La.AutomaticSize = Enum.AutomaticSize.Y
        w499La.BackgroundTransparency = 1
        w499La.Text = "["..w499T.."] "..w499Mg
        w499La.Font = Enum.Font.Code
        w499La.TextSize = 11
        w499La.TextColor3 = w499Co or Color3.fromRGB(220, 220, 220)
        w499La.TextXAlignment = Enum.TextXAlignment.Left
        w499La.TextYAlignment = Enum.TextYAlignment.Top
        w499La.TextWrapped = true
        w499La.RichText = false
        w499La.LayoutOrder = w499Ca
        task.defer(function() w499Sr.CanvasPosition = Vector2.new(0, math.huge) end)
        return w499La
    end
    local w499Cl = Instance.new("TextButton", w499Pa)
    w499Cl.Size = UDim2.new(0, 50, 0, 18)
    w499Cl.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    w499Cl.Text = "Clear"
    w499Cl.Font = Enum.Font.Gotham
    w499Cl.TextSize = 11
    w499Cl.TextColor3 = Color3.fromRGB(180, 180, 180)
    w499Cl.BorderSizePixel = 0
    w499Cl.AutoButtonColor = false
    w65(w499Cl, 4)
    w498(w499Cl,
        { BackgroundColor3 = Color3.fromRGB(60, 60, 70), Size = UDim2.new(0, 50, 0, 18) },
        { BackgroundColor3 = Color3.fromRGB(80, 80, 90), Size = UDim2.new(0, 55, 0, 21) },
        { BackgroundColor3 = Color3.fromRGB(100, 100, 110), Size = UDim2.new(0, 45, 0, 15) }
    )
    w499Cl.MouseButton1Click:Connect(function()
        for _, w499C in ipairs(w499Sr:GetChildren()) do
            if w499C:IsA("TextLabel") and w499C ~= w499Em then
                w499C:Destroy()
            end
        end
        w499Ca = 1
        w499Em.Visible = true
    end)
    return w499Ot, w499Sr, w499Em, w499Ad, w499Cl
end

local w161 = w6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
if w161 then w161:Destroy() end

local w162 = Instance.new("ScreenGui")
w162.Name = "UniversalUtility"
w162.ResetOnSpawn = false
w162.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(w162); w162.Parent = w6
elseif gethui then
    w162.Parent = gethui()
else
    w162.Parent = w6
end

local w163 = Instance.new("Frame", w162)
w163.Name = "MainFrame"
w163.Size = UDim2.new(0, 0, 0, 0)
w163.Position = UDim2.new(0, 0, 0, 0)
w163.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
w163.BorderSizePixel = 0
w163.Active = true
w163.ClipsDescendants = true
w163.Visible = false

w65(w163, 16)
w113(w163, w39)

w61 = Instance.new("UIScale", w163)
w61.Scale = 1

local w164 = Instance.new("ImageLabel", w163)
w164.BackgroundTransparency = 1
w164.Position = UDim2.new(0, -15, 0, -15)
w164.Size = UDim2.new(1, 30, 1, 30)
w164.ZIndex = 0
w164.Image = "rbxassetid://6014261993"
w164.ImageColor3 = Color3.fromRGB(0, 0, 0)
w164.ImageTransparency = 0.5
w164.ScaleType = Enum.ScaleType.Slice
w164.SliceCenter = Rect.new(49, 49, 450, 450)

local w165 = Instance.new("Frame", w163)
w165.Size = UDim2.new(1, 0, 0, 46)
w165.Position = UDim2.new(0, 0, 0, 0)
w165.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
w165.BorderSizePixel = 0

w65(w165, 16)
w69(w165, Color3.fromRGB(38, 38, 46), Color3.fromRGB(30, 30, 37), 90)

do
    local w166 = Instance.new("TextLabel", w165)
    w166.Size = UDim2.new(1, -60, 1, 0)
    w166.Position = UDim2.new(0, 14, 0, 0)
    w166.BackgroundTransparency = 1
    w166.Text = "⚡ Universal Utility"
    w166.Font = Enum.Font.GothamBold
    w166.TextSize = 22
    w166.TextColor3 = Color3.fromRGB(255, 255, 255)
    w166.TextXAlignment = Enum.TextXAlignment.Left
end

local w167 = Instance.new("ImageButton", w165)
w167.Size = UDim2.new(0, 28, 0, 28)
w167.Position = UDim2.new(1, -14, 0.5, 0)
w167.AnchorPoint = Vector2.new(1, 0.5)
w167.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
w167.BorderSizePixel = 0
w167.Image = "rbxassetid://3926305904"
w167.ImageRectOffset = Vector2.new(284, 4)
w167.ImageRectSize = Vector2.new(24, 24)
w167.ImageColor3 = Color3.fromRGB(255, 255, 255)
w65(w167, 8)

local w168 = Instance.new("Frame", w163)
w168.Size = UDim2.new(0, 178, 1, -52)
w168.Position = UDim2.new(0, 5, 0, 52)
w168.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
w168.BorderSizePixel = 0
w65(w168, 10)
w69(w168, Color3.fromRGB(30, 30, 35), Color3.fromRGB(25, 25, 30), 90)

local w169 = Instance.new("Frame", w163)
w169.Size = UDim2.new(1, -193, 1, -57)
w169.Position = UDim2.new(0, 188, 0, 52)
w169.BackgroundTransparency = 1
w169.BorderSizePixel = 0
w169.ClipsDescendants = true

local w170 = Instance.new("ImageButton", w162)
w170.Name = "ReopenButton"
w170.Size = UDim2.new(0, 0, 0, 0)
w170.Position = UDim2.new(0, 0, 0, 0)
w170.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
w170.BorderSizePixel = 0
w170.Visible = false
w170.ZIndex = 10
w170.Active = true
w170.ImageTransparency = 1
w65(w170, 100)
w69(w170, Color3.fromRGB(100, 150, 255), Color3.fromRGB(80, 130, 235), 45)

local w171 = Instance.new("TextLabel", w170)
w171.Size = UDim2.new(1, 0, 1, 0)
w171.BackgroundTransparency = 1
w171.Text = "⚡"
w171.Font = Enum.Font.GothamBold
w171.TextSize = 24
w171.TextColor3 = Color3.fromRGB(255, 255, 255)
w171.TextTransparency = 1

local w172, w173, w174, w175, w176 = false, nil, nil, nil, false
local w177, w177SA = nil, false
local function w177SX()
    if w177 then
        w177:Disconnect()
        w177 = nil
    end
    w177SA = false
end

local function w177SS()
    if w177SA then return end
    w177SA = true
    if w177 then w177:Disconnect() end
    w177 = w5.RenderStepped:Connect(function(w457)
        if w170.Visible then
            w170.Rotation = (w170.Rotation + (w457 * 180)) % 360
        else
            w177SX()
        end
    end)
end

w170.InputBegan:Connect(function(w178)
    if w178.UserInputType == Enum.UserInputType.MouseButton1 or w178.UserInputType == Enum.UserInputType.Touch then
        w172 = true
        w176 = false
        w173 = w178.Position
        w174 = w170.Position
        w177SS()
        if w175 then w175:Disconnect() end
        w175 = w3.InputChanged:Connect(function(w179)
            if (w179.UserInputType == Enum.UserInputType.MouseMovement or w179.UserInputType == Enum.UserInputType.Touch) and w172 then
                local w180 = w179.Position - w173
                if math.abs(w180.X) > 5 or math.abs(w180.Y) > 5 then w176 = true end
                w170.Position = UDim2.new(0, w174.X.Offset + w180.X, 0, w174.Y.Offset + w180.Y)
            end
        end)
        w178.Changed:Connect(function()
            if w178.UserInputState == Enum.UserInputState.End or w178.UserInputState == Enum.UserInputState.Cancel then
                w172 = false
                if w175 then w175:Disconnect(); w175 = nil end
                local w456In, mousePos, btnPos, btnSize = math.floor(60 * w62), w3:GetMouseLocation(), w170.AbsolutePosition, w170.AbsoluteSize
                local isHovered = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X
                    and mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
                if isHovered then
                    w48(w170, w44.Medium, { Size = UDim2.new(0, math.floor(w456In * 1.17), 0, math.floor(w456In * 1.17)) })
                    w177SS()
                else
                    w48(w170, w44.Medium, { Size = UDim2.new(0, w456In, 0, w456In), Rotation = 0 })
                end
                task.wait(0.1)
                if w176 then
                    w21.SavedReopenPosition = { X = w170.Position.X.Offset, Y = w170.Position.Y.Offset }
                    w33()
                end
                w176 = false
            end
        end)
    end
end)
w170.MouseEnter:Connect(function()
    if not w172 then
        local w456 = math.floor(60 * w62)
        w48(w170, w44.Medium, { Size = UDim2.new(0, math.floor(w456 * 1.17), 0, math.floor(w456 * 1.17)) })
        w177SS()
    end
end)
w170.MouseLeave:Connect(function()
    if not w172 then
        w177SX()
        local w456 = math.floor(60 * w62)
        w48(w170, w44.Medium, { Size = UDim2.new(0, w456, 0, w456), Rotation = 0 })
    end
end)
w170.MouseButton1Down:Connect(function()
    if not w172 then
        local w456 = math.floor(60 * w62)
        w48(w170, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, math.floor(w456 * 0.92), 0, math.floor(w456 * 0.92)) })
    end
end)
w170.MouseButton1Up:Connect(function()
    if not w172 then
        local w456 = math.floor(60 * w62)
        w48(w170, w44.Fast, { Size = UDim2.new(0, w456, 0, w456) })
    end
end)

local w181, w182, w183 = {}, {}, {}
_G.UU.UI = {
    ScreenGui = w162,
    MainFrame = w163,
    ContentFrame = w169,
    SideNav = w168,
    CloseButton = w167,
    ReopenButton = w170,
    TabButtons = w181,
    TabContents = w182,
    TweenPresets = w44,
    ActiveTweens = w45,
    PlayTween = w48,
    CancelTween = w46,
    UIScale = w61,
    AllFrames = w183,
}

local function w184(w185, w186, w187)
    local w188 = Instance.new("TextButton", w168)
    w188.Name = w185.."Tab"
    w188.Size = UDim2.new(1, -10, 0, 50)
    w188.Position = UDim2.new(0.5, 0, 0, 8 + ((w187 - 1) * 55) + 27)
    w188.AnchorPoint = Vector2.new(0.5, 0.5)
    w188.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    w188.BorderSizePixel = 0
    w188.Text = ""
    w188.AutoButtonColor = false
    w65(w188, 8)
    local w189 = Instance.new("TextLabel", w188)
    w189.Size = UDim2.new(0, 30, 1, 0)
    w189.Position = UDim2.new(0, 10, 0, 0)
    w189.BackgroundTransparency = 1
    w189.Text = w186
    w189.Font = Enum.Font.GothamBold
    w189.TextSize = 18
    w189.TextColor3 = Color3.fromRGB(180, 180, 180)
    w189.TextXAlignment = Enum.TextXAlignment.Left
    local w190 = Instance.new("TextLabel", w188)
    w190.Size = UDim2.new(1, -50, 1, 0)
    w190.Position = UDim2.new(0, 45, 0, 0)
    w190.BackgroundTransparency = 1
    w190.Text = w185
    w190.Font = Enum.Font.GothamBold
    w190.TextSize = 13
    w190.TextColor3 = Color3.fromRGB(180, 180, 180)
    w190.TextXAlignment = Enum.TextXAlignment.Left
    w181[w185] = { Button = w188, Icon = w189, Label = w190 }
    w183["Tab_"..w185] = w188
    w188.MouseEnter:Connect(function()
        local sel = w21.CurrentTab == w185
        if sel then
            w48(w188, w44.Fast, { Size = UDim2.new(1, -4, 0, 54) })
            w48(w189, w44.Fast, { TextSize = 21 })
            w48(w190, w44.Fast, { TextSize = 14 })
        else
            w48(w188, w44.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52), Size = UDim2.new(1, -4, 0, 54) })
            w48(w189, w44.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 21 })
            w48(w190, w44.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 14 })
        end
    end)
    w188.MouseLeave:Connect(function()
        local sel = w21.CurrentTab == w185
        if sel then
            w48(w188, w44.Fast, { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(1, -10, 0, 50) })
            w48(w189, w44.Fast, { TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18 })
            w48(w190, w44.Fast, { TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13 })
        else
            w48(w188, w44.Fast, { BackgroundColor3 = Color3.fromRGB(35, 35, 42), Size = UDim2.new(1, -10, 0, 50) })
            w48(w189, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 18 })
            w48(w190, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13 })
        end
    end)
    w188.MouseButton1Down:Connect(function()
        local sel = w21.CurrentTab == w185
        if sel then
            w48(w188, w44.Fast, { Size = UDim2.new(1, -14, 0, 46) })
        else
            w48(w188, w44.Fast, { BackgroundColor3 = Color3.fromRGB(55, 55, 62), Size = UDim2.new(1, -14, 0, 46) })
        end
        w48(w189, w44.Fast, { TextSize = 16 })
    end)
    w188.MouseButton1Up:Connect(function()
        local sel = w21.CurrentTab == w185
        if sel then
            w48(w188, w44.Fast, { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(1, -4, 0, 54) })
        else
            w48(w188, w44.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52), Size = UDim2.new(1, -4, 0, 54) })
        end
        w48(w189, w44.Fast, { TextSize = 21 })
    end)
    return w188
end

local function w191(w185)
    local w192 = Instance.new("ScrollingFrame", w169)
    w192.Name = w185.."Content"
    w192.Size = UDim2.new(1, -10, 1, -10)
    w192.Position = UDim2.new(0, 5, 0, 5)
    w192.BackgroundTransparency = 1
    w192.BorderSizePixel = 0
    w192.ScrollBarThickness = 4
    w192.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    w192.ScrollBarImageTransparency = 0.5
    w192.CanvasSize = UDim2.new(0, 0, 0, 0)
    w192.Visible = false
    w192.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local w193 = Instance.new("UIListLayout", w192)
    w193.SortOrder = Enum.SortOrder.LayoutOrder
    w193.Padding = UDim.new(0, 10)
    w182[w185] = w192
    w183["Content_"..w185] = w192
    return w192
end

local w194 = {
    { name = "Home", icon = "🏠", order = 1 },
    { name = "Anti-AFK", icon = "⚡", order = 2 },
    { name = "KeySpam", icon = "⌨️", order = 3 },
    { name = "Performance Status", icon = "📊", order = 4 },
    { name = "Auto Rejoin", icon = "🔄", order = 5 },
    { name = "Script Loader", icon = "💾", order = 6 },
    { name = "Settings", icon = "⚙️", order = 7 },
}
for w195, w196 in ipairs(w194) do
    w184(w196.name, w196.icon, w196.order)
    w191(w196.name)
end

local w197, w198, w199 = {}, {}, {}
local w200, w201, w202, w203 = {}, {}, {}, {}
local function w218FU(w218Up)
    local w218Dy, w218Hr, w218Mn, w218Sc = math.floor(w218Up / 86400), math.floor((w218Up % 86400) / 3600), math.floor((w218Up % 3600) / 60), w218Up % 60
    if w218Dy > 0 then
        return string.format("Server Uptime: %dd %dh %02dm %02ds", w218Dy, w218Hr, w218Mn, w218Sc)
    elseif w218Hr > 0 then
        return string.format("Server Uptime: %dh %02dm %02ds", w218Hr, w218Mn, w218Sc)
    elseif w218Mn > 0 then
        return string.format("Server Uptime: %dm %02ds", w218Mn, w218Sc)
    else
        return "Server Uptime: " .. w218Sc .. "s"
    end
end

local w218AR = {
    ["us-east-1"] = "🇺🇸 US East (N. Virginia)",
    ["us-east-2"] = "🇺🇸 US East (Ohio)",
    ["us-west-1"] = "🇺🇸 US West (N. California)",
    ["us-west-2"] = "🇺🇸 US West (Oregon)",
    ["eu-west-1"] = "🇮🇪 EU West (Ireland)",
    ["eu-west-2"] = "🇬🇧 EU West (London)",
    ["eu-west-3"] = "🇫🇷 EU West (Paris)",
    ["eu-central-1"] = "🇩🇪 EU Central (Frankfurt)",
    ["eu-central-2"] = "🇨🇭 EU Central (Zurich)",
    ["eu-north-1"] = "🇸🇪 EU North (Stockholm)",
    ["eu-south-1"] = "🇮🇹 EU South (Milan)",
    ["eu-south-2"] = "🇪🇸 EU South (Spain)",
    ["ap-southeast-1"] = "🇸🇬 AP Southeast (Singapore)",
    ["ap-southeast-2"] = "🇦🇺 AP Southeast (Sydney)",
    ["ap-southeast-3"] = "🇮🇩 AP Southeast (Jakarta)",
    ["ap-southeast-4"] = "🇦🇺 AP Southeast (Melbourne)",
    ["ap-northeast-1"] = "🇯🇵 AP Northeast (Tokyo)",
    ["ap-northeast-2"] = "🇰🇷 AP Northeast (Seoul)",
    ["ap-northeast-3"] = "🇯🇵 AP Northeast (Osaka)",
    ["ap-south-1"] = "🇮🇳 AP South (Mumbai)",
    ["ap-south-2"] = "🇮🇳 AP South (Hyderabad)",
    ["ap-east-1"] = "🇭🇰 AP East (Hong Kong)",
    ["sa-east-1"] = "🇧🇷 SA East (São Paulo)",
    ["ca-central-1"] = "🇨🇦 CA Central (Montreal)",
    ["ca-west-1"] = "🇨🇦 CA West (Calgary)",
    ["me-south-1"] = "🇧🇭 ME South (Bahrain)",
    ["me-central-1"] = "🇦🇪 ME Central (UAE)",
    ["af-south-1"] = "🇿🇦 AF South (Cape Town)",
    ["il-central-1"] = "🇮🇱 IL Central (Tel Aviv)",
    ["mx-central-1"] = "🇲🇽 MX Central (Mexico City)",
}

local w218CF = {
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

local function w218FC(w218Cd)
    if not w218Cd then return "🌐" end
    return w218CF[w218Cd:upper()] or "🌐"
end

local function w218DR(w218Lb)
    task.spawn(function()
        local w218Dt, w218JI = nil, game.JobId
        if w218JI and w218JI ~= "" then
            for w218Cd, w218Nm in pairs(w218AR) do
                if w218JI:lower():find(w218Cd, 1, true) then
                    w218Dt = w218Nm
                    break
                end
            end
        end
        if not w218Dt then
            local w218Ok, w218Rs = pcall(function()
                local w218HO, w218Da = pcall(function()
                    return w:JSONDecode(game:HttpGet("https://ipinfo.io/json", true))
                end)
                if w218HO and w218Da and w218Da.country then
                    local w218Fl = w218FC(w218Da.country)
                    local w218St = w218Fl .. " " .. w218Da.country
                    if w218Da.region and w218Da.region ~= "" then
                        w218St = w218St .. " - " .. w218Da.region
                    end
                    if w218Da.city and w218Da.city ~= "" then
                        w218St = w218St .. ", " .. w218Da.city
                    end
                    return w218St
                end
                return nil
            end)
            if w218Ok and w218Rs then
                w218Dt = w218Rs
            end
        end
        if not w218Dt then
            w218Dt = "🌐 Unknown"
        end
        if w218Lb and w218Lb.Parent then
            w218Lb.Text = "Server Region: " .. w218Dt
        end
    end)
end

do
    local w204 = w182["Home"]
    local w205 = w134(w204, 200, 1)
    w183["Home_Card1"] = w205
    local w206 = Instance.new("ImageLabel", w205)
    w206.Size = UDim2.new(0, 120, 0, 140)
    w206.Position = UDim2.new(0, 10, 0, 10)
    w206.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    w206.BorderSizePixel = 0
    w206.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    w65(w206, 10)
    Instance.new("UIStroke", w206).Color = Color3.fromRGB(100, 150, 255)
    local w207 = Instance.new("TextLabel", w205)
    w207.Size = UDim2.new(1, -145, 0, 22)
    w207.Position = UDim2.new(0, 140, 0, 10)
    w207.BackgroundTransparency = 1
    w207.Text = w12
    w207.Font = Enum.Font.GothamBold
    w207.TextSize = 28
    w207.TextColor3 = Color3.fromRGB(255, 255, 255)
    w207.TextXAlignment = Enum.TextXAlignment.Left
    local w208 = Instance.new("TextLabel", w205)
    w208.Size = UDim2.new(1, -145, 0, 16)
    w208.Position = UDim2.new(0, 140, 0, 33)
    w208.BackgroundTransparency = 1
    w208.Text = "User ID: "..w13
    w208.Font = Enum.Font.Gotham
    w208.TextSize = 12
    w208.TextColor3 = Color3.fromRGB(150, 150, 150)
    w208.TextXAlignment = Enum.TextXAlignment.Left
    local w209 = Instance.new("TextLabel", w205)
    w209.Size = UDim2.new(1, -145, 0, 18); w209.Position = UDim2.new(0, 140, 0, 55)
    w209.BackgroundTransparency = 1; w209.Text = "FPS: 60"
    w209.Font = Enum.Font.Gotham; w209.TextSize = 16
    w209.TextColor3 = Color3.fromRGB(100, 200, 255); w209.TextXAlignment = Enum.TextXAlignment.Left
    local w210 = Instance.new("TextLabel", w205)
    w210.Size = UDim2.new(1, -145, 0, 18); w210.Position = UDim2.new(0, 140, 0, 70)
    w210.BackgroundTransparency = 1; w210.Text = "Ping: 0 ms"
    w210.Font = Enum.Font.Gotham; w210.TextSize = 16
    w210.TextColor3 = Color3.fromRGB(0, 255, 0); w210.TextXAlignment = Enum.TextXAlignment.Left
    local w211 = Instance.new("TextLabel", w205)
    w211.Size = UDim2.new(1, -145, 0, 18); w211.Position = UDim2.new(0, 140, 0, 90)
    w211.BackgroundTransparency = 1; w211.Text = "Memory: 0 MB"
    w211.Font = Enum.Font.Gotham; w211.TextSize = 16
    w211.TextColor3 = Color3.fromRGB(255, 180, 100); w211.TextXAlignment = Enum.TextXAlignment.Left
    local w212, w213 = "Unknown", "N/A"
    pcall(function()
        if identifyexecutor then w212, w213 = identifyexecutor()
        elseif getexecutorname then w212 = getexecutorname() end
    end)
    local w214 = Instance.new("TextLabel", w205)
    w214.Size = UDim2.new(1, -145, 0, 18); w214.Position = UDim2.new(0, 140, 0, 105)
    w214.BackgroundTransparency = 1; w214.Text = "Executor: "..w212.." "..w213
    w214.Font = Enum.Font.Gotham; w214.TextSize = 14
    w214.TextColor3 = Color3.fromRGB(255, 100, 200); w214.TextXAlignment = Enum.TextXAlignment.Left
    local w215 = Instance.new("TextLabel", w205)
    w215.Size = UDim2.new(1, -145, 0, 18); w215.Position = UDim2.new(0, 140, 0, 125)
    w215.BackgroundTransparency = 1; w215.Text = "Device: "..w19()
    w215.Font = Enum.Font.Gotham; w215.TextSize = 14
    w215.TextColor3 = Color3.fromRGB(180, 255, 150); w215.TextXAlignment = Enum.TextXAlignment.Left
    local w216, w217 = w59(), Instance.new("TextLabel", w205)
    w217.Size = UDim2.new(1, -145, 0, 16); w217.Position = UDim2.new(0, 140, 0, 140)
    w217.BackgroundTransparency = 1; w217.Text = string.format("Resolution: %dx%d", w216.X, w216.Y)
    w217.Font = Enum.Font.Gotham; w217.TextSize = 12
    w217.TextColor3 = Color3.fromRGB(120, 120, 120); w217.TextXAlignment = Enum.TextXAlignment.Left
    local w218 = w134(w204, 178, 2)
    w183["Home_Card2"] = w218
    local w219 = Instance.new("ImageLabel", w218)
    w219.Size = UDim2.new(0, 120, 0, 125); w219.Position = UDim2.new(0, 10, 0, 10)
    w219.BackgroundColor3 = Color3.fromRGB(45, 45, 52); w219.BorderSizePixel = 0
    w219.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    w65(w219, 10); Instance.new("UIStroke", w219).Color = Color3.fromRGB(100, 150, 255)
    local w220 = Instance.new("TextLabel", w218)
    w220.Size = UDim2.new(1, -145, 0, 24); w220.Position = UDim2.new(0, 140, 0, 5)
    w220.BackgroundTransparency = 1; w220.Text = "Loading game info..."
    w220.Font = Enum.Font.GothamBold; w220.TextSize = 24
    w220.TextColor3 = Color3.fromRGB(255, 255, 255); w220.TextXAlignment = Enum.TextXAlignment.Left
    w220.TextWrapped = true
    local w221 = Instance.new("TextLabel", w218)
    w221.Size = UDim2.new(1, -145, 0, 16); w221.Position = UDim2.new(0, 140, 0, 30)
    w221.BackgroundTransparency = 1; w221.Text = "Place Id: "..game.PlaceId
    w221.Font = Enum.Font.Gotham; w221.TextSize = 16
    w221.TextColor3 = Color3.fromRGB(150, 180, 255); w221.TextXAlignment = Enum.TextXAlignment.Left
    local w221B = Instance.new("TextLabel", w218)
    w221B.Size = UDim2.new(1, -145, 0, 16); w221B.Position = UDim2.new(0, 140, 0, 45)
    w221B.BackgroundTransparency = 1; w221B.Text = "Universe Id: "..game.GameId
    w221B.Font = Enum.Font.Gotham; w221B.TextSize = 16
    w221B.TextColor3 = Color3.fromRGB(200, 160, 255); w221B.TextXAlignment = Enum.TextXAlignment.Left
    local w222 = Instance.new("TextLabel", w218)
    w222.Size = UDim2.new(1, -145, 0, 16); w222.Position = UDim2.new(0, 140, 0, 70)
    w222.BackgroundTransparency = 1
    w222.Text = "Server Players: "..#w1:GetPlayers().." / "..w1.MaxPlayers
    w222.Font = Enum.Font.Gotham; w222.TextSize = 16
    w222.TextColor3 = Color3.fromRGB(150, 255, 180); w222.TextXAlignment = Enum.TextXAlignment.Left
    local w223B = Instance.new("TextLabel", w218)
    w223B.Size = UDim2.new(1, -145, 0, 16); w223B.Position = UDim2.new(0, 140, 0, 85)
    w223B.BackgroundTransparency = 1; w223B.Text = "Server Uptime: 0s"
    w223B.Font = Enum.Font.Gotham; w223B.TextSize = 16
    w223B.TextColor3 = Color3.fromRGB(255, 220, 100); w223B.TextXAlignment = Enum.TextXAlignment.Left
    local wa = Instance.new("TextLabel", w218)
    wa.Size = UDim2.new(1, -145, 0, 16); wa.Position = UDim2.new(0, 140, 0, 100)
    wa.BackgroundTransparency = 1; wa.Text = "Server Region: Detecting..."
    wa.Font = Enum.Font.Gotham; wa.TextSize = 12
    wa.TextColor3 = Color3.fromRGB(130, 220, 255); wa.TextXAlignment = Enum.TextXAlignment.Left
    local w223 = Instance.new("TextLabel", w218)
    w223.Size = UDim2.new(1, -145, 0, 14); w223.Position = UDim2.new(0, 140, 0, 120)
    w223.BackgroundTransparency = 1; w223.Text = "Job Id: "..(game.JobId ~= "" and game.JobId or "N/A")
    w223.Font = Enum.Font.Gotham; w223.TextSize = 12
    w223.TextColor3 = Color3.fromRGB(255, 180, 180); w223.TextXAlignment = Enum.TextXAlignment.Left
    w223.TextTruncate = Enum.TextTruncate.AtEnd
    local w218TO = tick() - workspace.DistributedGameTime
    w223B.Text = w218FU(math.floor(workspace.DistributedGameTime))
    w218DR(wa)
    table.insert(_G.UU.Connections, w1.PlayerAdded:Connect(function()
        w222.Text = "Players: "..#w1:GetPlayers().." / "..w1.MaxPlayers
    end))
    table.insert(_G.UU.Connections, w1.PlayerRemoving:Connect(function()
        w222.Text = "Players: "..(#w1:GetPlayers() - 1).." / "..w1.MaxPlayers
    end))
    local w218LU, w218Cn = -1, w5.Heartbeat:Connect(function()
        local w218Up = math.floor(tick() - w218TO)
        if w218Up ~= w218LU then
            w218LU = w218Up
            w223B.Text = w218FU(w218Up)
        end
    end)
    table.insert(_G.UU.Connections, w218Cn)
    _G.UU.UI.PlayerImage = w206
    _G.UU.UI.GameName = w220
    _G.UU.UI.GameImage = w219
    _G.UU.UI.ResolutionLabel = w217
    _G.UU.UI.DeviceLabel = w215
    w197.FPSLabel = w209
    w197.PingLabel = w210
    w197.MemoryLabel = w211
end

do
    local w225 = w182["Anti-AFK"]
    local w226 = w134(w225, 450, 1)
    w183["AntiAFK_Card"] = w226
    local w227 = w141(w226, "⚡ Anti-AFK System", 8)
    w227.TextColor3 = Color3.fromRGB(100, 200, 255)
    w138(w226, "Prevent disconnections by simulating player activity", 34)
    local w228, _ = w143(w226, "Auto Jump", 60)
    local w229, _, _, w231 = w147(w228, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.JumpEnabled, nil)
    local w232, _ = w143(w226, "Auto Click", 102)
    local w233, _, _, w235 = w147(w232, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.ClickEnabled, nil)
    w128(w226, 150)
    local wS, _ = w143(w226, "Mouse Position", 162)
    local wT, _, _, wU = w147(wS, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.MousePosEnabled, nil)
    local wV = Instance.new("TextLabel", w226)
    wV.Size = UDim2.new(1, -20, 0, 16)
    wV.Position = UDim2.new(0, 10, 0, 198)
    wV.BackgroundTransparency = 1
    wV.Text = string.format("[Locked] F5 · %d, %d", math.floor(w21.MousePosSaved.X), math.floor(w21.MousePosSaved.Y))
    wV.Font = Enum.Font.Gotham
    wV.TextSize = 12
    wV.TextColor3 = Color3.fromRGB(150, 150, 150)
    wV.TextXAlignment = Enum.TextXAlignment.Left
    w128(w226, 233)
    local _, w244, w245, w246, w247 = w74(w226, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 248), 10, "Jump Interval (seconds)")
    local _, w249, w250, w251, w252 = w74(w226, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 315), 3, "Click Interval (seconds)")
    local _, w254 = w123(w226, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 380), "Status: All Inactive")
    w198 = {
        JumpToggleBtn = w229,
        JumpToggleState = w231,
        ClickToggleBtn = w233,
        ClickToggleState = w235,
        MousePosToggleBtn = wT,
        MousePosToggleState = wU,
        MousePosLabel = wV,
        JumpDelaySlider = w244,
        JumpSliderFill = w245,
        JumpSliderButton = w246,
        JumpDelayBox = w247,
        ClickDelaySlider = w249,
        ClickSliderFill = w250,
        ClickSliderButton = w251,
        ClickDelayBox = w252,
        Status = w254,
    }
end

do
    local w255 = w182["KeySpam"]
    local w256 = w134(w255, 330, 1)
    w183["KeySpam_Card"] = w256
    local w257 = w141(w256, "⌨️ Key Spam Controller", 8)
    w257.TextColor3 = Color3.fromRGB(255, 200, 100)
    w138(w256, "Automatically spam any keyboard key at custom intervals", 34)
    w131(w256, "Target Key", 60)
    local w258 = Instance.new("TextBox", w256)
    w258.Size = UDim2.new(1, -20, 0, 40)
    w258.Position = UDim2.new(0, 10, 0, 82)
    w258.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    w258.Text = w21.SpamKey
    w258.PlaceholderText = "Enter key (A-Z, 0-9, F1-F12)"
    w258.Font = Enum.Font.Gotham
    w258.TextSize = 14
    w258.TextColor3 = Color3.fromRGB(255, 255, 255)
    w258.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    w258.BorderSizePixel = 0
    w258.ClearTextOnFocus = false
    w65(w258, 8)
    Instance.new("UIStroke", w258).Color = Color3.fromRGB(60, 60, 70)
    w128(w256, 135)
    local _, w260, w261, w262, w263 = w74(w256, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 150), 0.1, "Spam Interval (seconds)")
    local w264, _ = w143(w256, "Auto Spam", 215)
    local w265, _, _, w267 = w147(w264, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.AutoSpamEnabled, nil)
    local _, w269 = w123(w256, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 265), "Status: Inactive")
    w199 = {
        SpamInput = w258,
        SpamDelaySlider = w260,
        SpamSliderFill = w261,
        SpamSliderButton = w262,
        SpamDelayBox = w263,
        AutoSpamToggleBtn = w265,
        AutoSpamToggleState = w267,
        Status = w269,
    }
end

do
    local w270 = w182["Performance Status"]
    local w271 = w134(w270, 660, 1)
    w183["Performance_Card"] = w271
    local w272 = w141(w271, "📊 Performance Monitor", 8)
    w272.TextColor3 = Color3.fromRGB(100, 255, 150)
    w138(w271, "Track real-time performance metrics and unlock FPS limits", 34)
    local w273, _ = w143(w271, "FPS Unlock", 60)
    local w274, _, _, w276 = w147(w273, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.FPSUnlockEnabled, nil)
    local w277 = Instance.new("TextLabel", w271)
    w277.Size = UDim2.new(1, -20, 0, 20)
    w277.Position = UDim2.new(0, 10, 0, 102)
    w277.BackgroundTransparency = 1
    w277.Text = "Current Limit: 60 FPS"
    w277.Font = Enum.Font.Gotham
    w277.TextSize = 13
    w277.TextColor3 = Color3.fromRGB(180, 180, 180)
    w277.TextXAlignment = Enum.TextXAlignment.Center
    local _, w279, w280, w281, w282 = w74(w271, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 135), 60, "Target FPS Limit")
    w128(w271, 200)
    w131(w271, "Framerate Statistics", 210)
    local w283 = Instance.new("Frame", w271)
    w283.Size = UDim2.new(1, -20, 0, 50); w283.Position = UDim2.new(0, 10, 0, 235)
    w283.BackgroundColor3 = Color3.fromRGB(30, 30, 35); w283.BorderSizePixel = 0
    w65(w283, 8); Instance.new("UIStroke", w283).Color = Color3.fromRGB(50, 50, 60)
    local function w284(w285, w286, w287, w288)
        local w289 = Instance.new("TextLabel", w285)
        w289.Size = UDim2.new(w286[3], 0, 1, 0); w289.Position = UDim2.new(w286[1], 0, 0, 0)
        w289.BackgroundTransparency = 1; w289.Text = w287
        w289.Font = Enum.Font.GothamBold; w289.TextSize = 13
        w289.TextColor3 = w288; w289.TextXAlignment = Enum.TextXAlignment.Center
        return w289
    end
    local w290, w291 = w284(w283, {0, 0, 0.33}, "Current: 60", Color3.fromRGB(100, 200, 255)), w284(w283, {0.33, 0, 0.33}, "Average: 60", Color3.fromRGB(50, 220, 100))
    local w292 = w284(w283, {0.66, 0, 0.34}, "Min: 60 | Max: 60",Color3.fromRGB(255, 200, 100))
    w128(w271, 300); w131(w271, "Network Latency Statistics", 310)
    local w293 = Instance.new("Frame", w271)
    w293.Size = UDim2.new(1, -20, 0, 50); w293.Position = UDim2.new(0, 10, 0, 335)
    w293.BackgroundColor3 = Color3.fromRGB(30, 30, 35); w293.BorderSizePixel = 0
    w65(w293, 8); Instance.new("UIStroke", w293).Color = Color3.fromRGB(50, 50, 60)
    local w294, w295 = w284(w293, {0, 0, 0.33}, "Current: 0ms", Color3.fromRGB(100, 200, 255)), w284(w293, {0.33, 0, 0.33}, "Average: 0ms", Color3.fromRGB(50, 220, 100))
    local w296, w297 = w284(w293, {0.66, 0, 0.34}, "Min: 0ms | Max: 0ms", Color3.fromRGB(255, 200, 100)), Instance.new("Frame", w271)
    w297.Size = UDim2.new(1, -20, 0, 50); w297.Position = UDim2.new(0, 10, 0, 400)
    w297.BackgroundColor3 = Color3.fromRGB(30, 30, 35); w297.BorderSizePixel = 0
    w65(w297, 8); Instance.new("UIStroke", w297).Color = Color3.fromRGB(50, 50, 60)
    w284(w297, {0, 0, 0.5}, "Connection Quality", Color3.fromRGB(255, 255, 255))
    local w298 = w284(w297, {0.5, 0, 0.5}, "Excellent", Color3.fromRGB(50, 220, 100))
    w128(w271, 460); w131(w271, "Memory Usage Statistics", 470)
    local w299 = Instance.new("Frame", w271)
    w299.Size = UDim2.new(1, -20, 0, 50); w299.Position = UDim2.new(0, 10, 0, 495)
    w299.BackgroundColor3 = Color3.fromRGB(30, 30, 35); w299.BorderSizePixel = 0
    w65(w299, 8); Instance.new("UIStroke", w299).Color = Color3.fromRGB(50, 50, 60)
    local w300, w301 = w284(w299, {0, 0, 0.5}, "Current: 0 MB", Color3.fromRGB(255, 180, 100)), w284(w299, {0.5, 0, 0.5}, "Peak: 0 MB", Color3.fromRGB(255, 150, 50))
    local w302 = Instance.new("TextLabel", w271)
    w302.Size = UDim2.new(1, -20, 0, 60); w302.Position = UDim2.new(0, 10, 0, 555)
    w302.BackgroundColor3 = Color3.fromRGB(30, 30, 35); w302.BorderSizePixel = 0
    w302.Text = "Performance monitoring tracks your game's framerate, network latency, and memory usage in real-time.\n\nLowering FPS limits reduces memory usage."
    w302.Font = Enum.Font.Gotham; w302.TextSize = 12
    w302.TextColor3 = Color3.fromRGB(200, 180, 150); w302.TextWrapped = true
    w302.TextXAlignment = Enum.TextXAlignment.Left; w302.TextYAlignment = Enum.TextYAlignment.Top
    w65(w302, 8); Instance.new("UIStroke", w302).Color = Color3.fromRGB(50, 50, 60)
    local w303 = Instance.new("UIPadding", w302)
    w303.PaddingLeft = UDim.new(0, 10); w303.PaddingRight = UDim.new(0, 10)
    w303.PaddingTop = UDim.new(0, 10); w303.PaddingBottom = UDim.new(0, 10)
    w200 = {
        FPSToggleBtn = w274,
        FPSToggleState = w276,
        FPSUnlockStatus = w277,
        FPSSlider = w279,
        FPSFill = w280,
        FPSButton = w281,
        FPSValueBox = w282,
        FPSStats = { Current = w290, Avg = w291, MinMax = w292 },
        PingStats = { Current = w294, Avg = w295, MinMax = w296, Quality = w298 },
        MemoryStats = { Current = w300, Peak = w301 },
    }
end

do
    local w304 = w182["Auto Rejoin"]
    local w305 = w134(w304, 270, 1)
    w183["AutoRejoin_Card"] = w305
    local w306 = w141(w305, "🔄 Auto Rejoin System", 8)
    w306.TextColor3 = Color3.fromRGB(150, 200, 255)
    w138(w305, "Automatically reconnect when disconnected from the server", 34)
    local w307, _ = w143(w305, "Auto Rejoin", 65)
    local w308, _, _, w310 = w147(w307, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.AutoRejoinEnabled, nil)
    local _, w312 = w123(w305, UDim2.new(1, -20, 0, 105), UDim2.new(0, 10, 0, 120),
        "Status: Disabled\n\nWhen enabled, automatically rejoins the current server when disconnected.")
    w201 = {
        AutoRejoinToggleBtn = w308,
        AutoRejoinToggleState = w310,
        Status = w312,
    }
end

do
    local w313 = w182["Script Loader"]
    local w314 = w134(w313, 660, 1)
    w183["ScriptLoader_Card"] = w314
    local w315 = w141(w314, "💾 Script Executor", 8)
    w315.TextColor3 = Color3.fromRGB(200, 150, 255)
    w138(w314, "Execute custom Lua scripts with auto-save and auto-load capabilities", 34)
    local w316 = Instance.new("Frame", w314)
    w316.Size = UDim2.new(1, -20, 0, 220)
    w316.Position = UDim2.new(0, 10, 0, 60)
    w316.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    w316.BorderSizePixel = 0
    w65(w316, 8)
    Instance.new("UIStroke", w316).Color = Color3.fromRGB(60, 60, 70)
    local w317 = Instance.new("ScrollingFrame", w316)
    w317.Size = UDim2.new(0, 40, 1, 0)
    w317.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    w317.BorderSizePixel = 0
    w317.ScrollBarThickness = 0
    w317.ScrollingEnabled = false
    w317.CanvasSize = UDim2.new(0, 0, 0, 220)
    w65(w317, 8)
    local w318 = Instance.new("TextLabel", w317)
    w318.Size = UDim2.new(1, -5, 1, 0)
    w318.BackgroundTransparency = 1
    w318.Text = "1"
    w318.Font = Enum.Font.Code
    w318.TextSize = 12
    w318.TextColor3 = Color3.fromRGB(120, 120, 120)
    w318.TextXAlignment = Enum.TextXAlignment.Right
    w318.TextYAlignment = Enum.TextYAlignment.Top
    local w319 = Instance.new("Frame", w316)
    w319.Size = UDim2.new(0, 1, 1, 0)
    w319.Position = UDim2.new(0, 40, 0, 0)
    w319.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    w319.BorderSizePixel = 0
    local w320 = Instance.new("ScrollingFrame", w316)
    w320.Size = UDim2.new(1, -41, 1, 0)
    w320.Position = UDim2.new(0, 41, 0, 0)
    w320.BackgroundTransparency = 1
    w320.BorderSizePixel = 0
    w320.ScrollBarThickness = 4
    w320.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    w320.ScrollBarImageTransparency = 0.5
    w320.CanvasSize = UDim2.new(0, 0, 0, 220)
    local w321 = Instance.new("TextBox", w320)
    w321.Size = UDim2.new(1, -10, 1, 0)
    w321.Position = UDim2.new(0, 5, 0, 0)
    w321.BackgroundTransparency = 1
    w321.Text = w21.SavedCode
    w321.PlaceholderText = "-- Paste your Lua code here..."
    w321.Font = Enum.Font.Code
    w321.TextSize = 12
    w321.TextColor3 = Color3.fromRGB(255, 255, 255)
    w321.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    w321.BorderSizePixel = 0
    w321.TextWrapped = false
    w321.TextXAlignment = Enum.TextXAlignment.Left
    w321.TextYAlignment = Enum.TextYAlignment.Top
    w321.MultiLine = true
    w321.ClearTextOnFocus = false
    w321.TextEditable = true
    local w322 = Instance.new("TextButton", w314)
    w322.Size = UDim2.new(0.5, -15, 0, 36)
    w322.Position = UDim2.new(0.25, 2.5, 0, 318)
    w322.AnchorPoint = Vector2.new(0.5, 0.5)
    w322.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    w322.Text = "▶ Execute"
    w322.Font = Enum.Font.GothamBold
    w322.TextSize = 14
    w322.TextColor3 = Color3.fromRGB(255, 255, 255)
    w322.BorderSizePixel = 0
    w322.AutoButtonColor = false
    w65(w322, 8)
    w498(w322,
        { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(0.5, -15, 0, 36) },
        { BackgroundColor3 = Color3.fromRGB(120, 170, 255), Size = UDim2.new(0.5, -8, 0, 40) },
        { BackgroundColor3 = Color3.fromRGB(80, 130, 225), Size = UDim2.new(0.5, -22, 0, 32) }
    )
    local w323, _ = w143(w314, "Auto Load", 300)
    w323.Size = UDim2.new(0.5, -15, 0, 36); w323.Position = UDim2.new(0.5, 5, 0, 300)
    local w324, _, _, w326 = w147(w323, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.AutoLoadEnabled, nil)
    w128(w314, 348)
    w131(w314, "Status", 360)
    local w327Fr = Instance.new("Frame", w314)
    w327Fr.Size = UDim2.new(1, -20, 0, 36)
    w327Fr.Position = UDim2.new(0, 10, 0, 382)
    w327Fr.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    w327Fr.BorderSizePixel = 0
    w65(w327Fr, 8)
    Instance.new("UIStroke", w327Fr).Color = Color3.fromRGB(50, 50, 60)
    local w327 = Instance.new("TextLabel", w327Fr)
    w327.Size = UDim2.new(1, -10, 1, 0)
    w327.Position = UDim2.new(0, 10, 0, 0)
    w327.BackgroundTransparency = 1
    w327.Text = "Ready"
    w327.Font = Enum.Font.GothamBold
    w327.TextSize = 13
    w327.TextColor3 = Color3.fromRGB(180, 180, 180)
    w327.TextXAlignment = Enum.TextXAlignment.Left
    w327.TextYAlignment = Enum.TextYAlignment.Center
    w327.TextTruncate = Enum.TextTruncate.AtEnd
    w128(w314, 430)
    w131(w314, "Output", 442)
    local _, w330, w333, w335, w328 = w499(w314,
        UDim2.new(1, -20, 0, 140),
        UDim2.new(0, 10, 0, 465),
        Color3.fromRGB(100, 150, 255)
    )
    w328.Position = UDim2.new(1, -35, 0, 450)
    w328.AnchorPoint = Vector2.new(0.5, 0.5)
    w333.Text = "No output yet."
    local w340 = Instance.new("TextLabel", w314)
    w340.Size = UDim2.new(1, -20, 0, 30); w340.Position = UDim2.new(0, 10, 0, 618)
    w340.BackgroundTransparency = 1
    w340.Text = "Code is auto-saved while typing. Enable Auto Load to execute on rejoin."
    w340.Font = Enum.Font.Gotham; w340.TextSize = 11
    w340.TextColor3 = Color3.fromRGB(100, 100, 110)
    w340.TextXAlignment = Enum.TextXAlignment.Center; w340.TextWrapped = true
    w202 = {
        LoadStringBox = w321,
        LineNumbers = w318,
        LoadStringScrollFrame = w320,
        LineNumbersScrollFrame = w317,
        ExecuteButton = w322,
        AutoLoadToggleBtn = w324,
        AutoLoadToggleState = w326,
        Status = w327,
        OutputScroll = w330,
        OutputEmpty = w333,
        AddOutput = w335,
    }
end

do
    local w341 = w182["Settings"]
    local w342 = w134(w341, 560, 1)
    w183["Settings_Card"] = w342
    local w343 = w141(w342, "⚙️ UI Configuration", 8)
    w343.TextColor3 = Color3.fromRGB(255, 180, 100)
    w138(w342, "Customize interface preferences and keybinds", 34)
    w131(w342, "Toggle Keybind", 60)
    local w344, w345 = w22[w21.Keybind] or w21.Keybind.Name, Instance.new("TextButton", w342)
    w345.Size = UDim2.new(1, -20, 0, 40)
    w345.Position = UDim2.new(0.5, 0, 0, 102)
    w345.AnchorPoint = Vector2.new(0.5, 0.5)
    w345.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    w345.Text = "Current Key: "..w344
    w345.Font = Enum.Font.GothamBold
    w345.TextSize = 13
    w345.TextColor3 = Color3.fromRGB(255, 255, 255)
    w345.BorderSizePixel = 0
    w345.AutoButtonColor = false
    w65(w345, 8)
    w498(w345,
        { BackgroundColor3 = Color3.fromRGB(45, 45, 52), Size = UDim2.new(1, -20, 0, 40) },
        { BackgroundColor3 = Color3.fromRGB(55, 55, 65), Size = UDim2.new(1, -15, 0, 44) },
        { BackgroundColor3 = Color3.fromRGB(70, 70, 80), Size = UDim2.new(1, -25, 0, 36) }
    )
    w128(w342, 135)
    local w346, _ = w143(w342, "Auto Hide UI", 150)
    local w347, _, _, w349 = w147(w346, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.AutoHideEnabled, nil)
    local _, w351 = w123(w342, UDim2.new(1, -20, 0, 60), UDim2.new(0, 10, 0, 200), "")
    w351.TextColor3 = Color3.fromRGB(150, 150, 150)
    w128(w342, 278)
    local w351bHd = w131(w342, "Activity Log", 290)
    w351bHd.TextColor3 = Color3.fromRGB(200, 200, 200)
    local w351bOt, w351bSr, w351bEm, w351bAd, w351bCl = w499(w342,
        UDim2.new(1, -20, 0, 200),
        UDim2.new(0, 10, 0, 312),
        Color3.fromRGB(255, 180, 100)
    )
    w351bCl.Position = UDim2.new(1, -35, 0, 297.5)
    w351bCl.AnchorPoint = Vector2.new(0.5, 0.5)
    w351bEm.Text = "No activity yet."
    w203 = {
        KeybindButton = w345,
        AutoHideToggleBtn = w347,
        AutoHideToggleState = w349,
        Status = w351,
        AddSettingsLog = w351bAd,
    }
    _G.UU.AddActivityLog = w351bAd
    for _, w351bPn in ipairs(wPL) do
        _G.UU.AddActivityLog(w351bPn.msg, w351bPn.col)
    end
    wPL = {}
end

local w352 = typeof(setfpscap) == "function"
if w352 then
    local w352Ok = pcall(setfpscap, 60)
    if not w352Ok then w352 = false end
end

local w354, w355, w356 = {}, {}, 60
local w357, w358 = tick(), 0
local w359 = 0
for w360 = 1, 60 do
    table.insert(w354, 60)
    table.insert(w355, 0)
end

local function w361()
    if not w198.Status then return end
    local w362, w363
    if w21.JumpEnabled and w21.ClickEnabled then
        w362, w363 = "Status: Jump & Click Active", Color3.fromRGB(50, 220, 100)
    elseif w21.JumpEnabled then
        w362, w363 = "Status: Jump Active", Color3.fromRGB(100, 200, 255)
    elseif w21.ClickEnabled then
        w362, w363 = "Status: Click Active", Color3.fromRGB(255, 200, 100)
    else
        w362, w363 = "Status: All Inactive", Color3.fromRGB(180, 180, 180)
    end
    w48(w198.Status, w44.Fast, { TextColor3 = w363 })
    w198.Status.Text = w362
end

local function w365()
    w56("Jump")
    _G.UU.Threads.Jump = task.spawn(function()
        while w21.JumpEnabled do
            task.wait(w21.JumpDelay)
            if w21.JumpEnabled and w11.Character then
                local w367 = w11.Character:FindFirstChildOfClass("Humanoid")
                if w367 then w367:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
        _G.UU.Threads.Jump = nil
    end)
end

local function w368()
    w56("Click")
    _G.UU.Threads.Click = task.spawn(function()
        while w21.ClickEnabled do
            task.wait(w21.ClickDelay)
            if w21.ClickEnabled then
                local w7, w8
                if w21.MousePosEnabled then
                    local w9 = w3:GetMouseLocation()
                    w7, w8 = w9.X, w9.Y
                else
                    w7, w8 = w21.MousePosSaved.X, w21.MousePosSaved.Y
                end
                w4:SendMouseButtonEvent(w7, w8, 0, true, game, 0)
                task.wait(0.05)
                w4:SendMouseButtonEvent(w7, w8, 0, false, game, 0)
            end
        end
        _G.UU.Threads.Click = nil
    end)
end

local function w373()
    w56("Spam")
    local w374 = w21.SpamKey:upper()
    local w375 = w23[w374]
    if not w375 then return end
    _G.UU.Threads.Spam = task.spawn(function()
        while w21.AutoSpamEnabled do
            task.wait(w21.SpamDelay)
            if w21.AutoSpamEnabled then
                w4:SendKeyEvent(true, w375, false, game)
                task.wait(0.05)
                w4:SendKeyEvent(false, w375, false, game)
            end
        end
        _G.UU.Threads.Spam = nil
    end)
end

local w376, w377B = false, nil
local function w377bDC()
    if w377B then
        pcall(function() w377B:Disconnect() end)
        w377B = nil
    end
end

local function w378()
    w377bDC()
    if not w21.AutoRejoinEnabled then return end
    task.spawn(function()
        local w379 = w6:FindFirstChild("RobloxPromptGui")
        if not w379 then
            local w380, w381 = pcall(function() return w6:WaitForChild("RobloxPromptGui", 10) end)
            if not w380 or not w381 then
                if w201.Status then
                    w201.Status.Text = "Status: Enabled (waiting for prompt GUI...)\n\nAutomatically rejoins when disconnected."
                end
                return
            end
            w379 = w381
        end
        local w382 = w379:FindFirstChild("promptOverlay")
        if not w382 then
            local w383, w384 = pcall(function() return w379:WaitForChild("promptOverlay", 10) end)
            if not w383 or not w384 then
                if w201.Status then
                    w201.Status.Text = "Status: Enabled (prompt overlay unavailable)\n\nAutomatically rejoins when disconnected."
                end
                return
            end
            w382 = w384
        end
        w377B = w382.ChildAdded:Connect(function(w385)
            if w385.Name == "ErrorPrompt" and w21.AutoRejoinEnabled and not w376 then
                w376 = true
                w33L("Disconnected detected → rejoining...", Color3.fromRGB(255, 200, 100))
                _G.UU.Threads.Rejoin = task.spawn(function()
                    while w21.AutoRejoinEnabled and w376 do
                        w7:Teleport(game.PlaceId, w11)
                        task.wait(2)
                    end
                    _G.UU.Threads.Rejoin = nil
                end)
            end
        end)
        table.insert(_G.UU.Connections, w377B)
    end)
end

local function w386(w387)
    if not w387 or w387 == "" then return false, "Empty script", "No code to execute." end
    local w388, w389 = pcall(function()
        local w390, w391 = loadstring(w387)
        if not w390 then error(w391, 0) end
        w390()
    end)
    if w388 then return true, "Executed successfully!", nil end
    return false, "Execution failed", tostring(w389)
end

local w392 = { jump = false, click = false, spam = false, fps = false }
local function w391MS(w391CK, w391Bs, w391Rg, w391Fi, w391Bx, w391Ma, w391M, w391Fm, w391Lb, w391SE)
    local function w391Si(w394)
        w21[w391CK] = w391Bs + (w394 * w391Rg)
        if w391Fm == "%d" then w21[w391CK] = math.floor(w21[w391CK]) end
        w91Si(w391Fi(), w391Bx(), w21[w391CK], w391Ma, w391M, w391Fm)
        if w391SE then w391SE() end
    end
    local function w391Lg(w394)
        w21[w391CK] = w391Bs + (w394 * w391Rg)
        if w391Fm == "%d" then w21[w391CK] = math.floor(w21[w391CK]) end
        w91(w391Fi(), w391Bx(), w21[w391CK], w391Ma, w391M, w391Fm)
        if w391SE then w391SE() end
        w33SL(string.format(w391Lb .. " → " .. w391Fm, w21[w391CK]))
    end
    return w391Si, w391Lg
end

local w393, w393L = w391MS(
    "JumpDelay", 5, 25,
    function() return w198.JumpSliderFill end, function() return w198.JumpDelayBox end,
    5, 30, "%.1f", "Jump Interval")
local w395, w395L = w391MS(
    "ClickDelay", 1, 9,
    function() return w198.ClickSliderFill end, function() return w198.ClickDelayBox end,
    1, 10, "%.1f", "Click Interval")
local w396, w396L = w391MS(
    "SpamDelay", 0.05, 4.95,
    function() return w199.SpamSliderFill end, function() return w199.SpamDelayBox end,
    0.05, 5, "%.2f", "Spam Interval")
local w397, w397L = w391MS(
    "TargetFPS", 15, 345,
    function() return w200.FPSFill end, function() return w200.FPSValueBox end,
    15, 360, "%d", "Target FPS",
    function()
        if w21.FPSUnlockEnabled and w352 then
            pcall(setfpscap, w21.TargetFPS)
            w200.FPSUnlockStatus.Text = "Your target: "..w21.TargetFPS.." FPS"
        end
    end)
w198.JumpSliderButton.MouseButton1Down:Connect(function() w392.jump = true; w98(w198.JumpSliderButton, 0.9) end)
w198.ClickSliderButton.MouseButton1Down:Connect(function() w392.click = true; w98(w198.ClickSliderButton, 0.9) end)
w199.SpamSliderButton.MouseButton1Down:Connect(function() w392.spam = true; w98(w199.SpamSliderButton, 0.9) end)
w200.FPSButton.MouseButton1Down:Connect(function() w392.fps = true; w98(w200.FPSButton, 0.9) end)
table.insert(_G.UU.Connections, w3.InputEnded:Connect(function(w398)
    if w398.UserInputType == Enum.UserInputType.MouseButton1 then
        if w392.jump then w393L((w21.JumpDelay - 5) / 25) end
        if w392.click then w395L((w21.ClickDelay - 1) / 9) end
        if w392.spam then w396L((w21.SpamDelay - 0.05) / 4.95) end
        if w392.fps then w397L((w21.TargetFPS - 15) / 345) end
        w392.jump = false; w392.click = false; w392.spam = false; w392.fps = false
    end
end))
table.insert(_G.UU.Connections, w3.InputChanged:Connect(function(w398)
    if w398.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local w399 = w3:GetMouseLocation().X
    if w392.jump and w198.JumpDelaySlider then
        w393(math.clamp((w399 - w198.JumpDelaySlider.AbsolutePosition.X) / w198.JumpDelaySlider.AbsoluteSize.X, 0, 1))
    elseif w392.click and w198.ClickDelaySlider then
        w395(math.clamp((w399 - w198.ClickDelaySlider.AbsolutePosition.X) / w198.ClickDelaySlider.AbsoluteSize.X, 0, 1))
    elseif w392.spam and w199.SpamDelaySlider then
        w396(math.clamp((w399 - w199.SpamDelaySlider.AbsolutePosition.X) / w199.SpamDelaySlider.AbsoluteSize.X, 0, 1))
    elseif w392.fps and w200.FPSSlider then
        w397(math.clamp((w399 - w200.FPSSlider.AbsolutePosition.X) / w200.FPSSlider.AbsoluteSize.X, 0, 1))
    end
end))
w198.JumpDelayBox.FocusLost:Connect(function()
    w393L((math.clamp(tonumber(w198.JumpDelayBox.Text) or w21.JumpDelay, 5, 30) - 5) / 25)
end)
w198.ClickDelayBox.FocusLost:Connect(function()
    w395L((math.clamp(tonumber(w198.ClickDelayBox.Text) or w21.ClickDelay, 1, 10) - 1) / 9)
end)
w199.SpamDelayBox.FocusLost:Connect(function()
    w396L((math.clamp(tonumber(w199.SpamDelayBox.Text) or w21.SpamDelay, 0.05, 5) - 0.05) / 4.95)
end)
w200.FPSValueBox.FocusLost:Connect(function()
    w397L((math.clamp(tonumber(w200.FPSValueBox.Text) or w21.TargetFPS, 15, 360) - 15) / 345)
end)
w199.SpamInput.FocusLost:Connect(function()
    local w33Pv = w21.SpamKey
    w21.SpamKey = w199.SpamInput.Text:upper()
    if w21.SpamKey ~= w33Pv then
        w33SL("Spam Key → " .. w21.SpamKey)
    end
end)
w198.JumpToggleBtn.MouseButton1Click:Connect(function()
    if not w53("Jump", 0.3) then return end
    w21.JumpEnabled = not w21.JumpEnabled
    w160(w198.JumpToggleState, w21.JumpEnabled)
    if w21.JumpEnabled then task.wait(0.05); w365() else w56("Jump") end
    w361()
    w33SL("Auto Jump → " .. (w21.JumpEnabled and "Enabled" or "Disabled"))
end)
w198.ClickToggleBtn.MouseButton1Click:Connect(function()
    if not w53("Click", 0.3) then return end
    w21.ClickEnabled = not w21.ClickEnabled
    w160(w198.ClickToggleState, w21.ClickEnabled)
    if w21.ClickEnabled then task.wait(0.05); w368() else w56("Click") end
    w361()
    w33SL("Auto Click → " .. (w21.ClickEnabled and "Enabled" or "Disabled"))
end)
w199.AutoSpamToggleBtn.MouseButton1Click:Connect(function()
    if not w53("Spam", 0.3) then return end
    w21.AutoSpamEnabled = not w21.AutoSpamEnabled
    if w21.AutoSpamEnabled then
        local w403 = w199.SpamInput.Text:upper()
        local w404 = w23[w403]
        if not w404 then
            w21.AutoSpamEnabled = false
            w160(w199.AutoSpamToggleState, false)
            w199.Status.Text = "Status: Invalid key"
            w48(w199.Status, w44.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            w33L("Key Spam → Invalid key '" .. w403 .. "'", Color3.fromRGB(220, 80, 80))
            w33()
            return
        end
        if w404 == Enum.KeyCode.P or w404 == w21.Keybind or w404 == Enum.KeyCode.F5 then
            w21.AutoSpamEnabled = false
            w160(w199.AutoSpamToggleState, false)
            w199.Status.Text = "Status: Key reserved"
            w48(w199.Status, w44.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            w33L("Key Spam → Key '" .. w403 .. "' is reserved", Color3.fromRGB(220, 80, 80))
            w33()
            return
        end
        w21.SpamKey = w403
        w160(w199.AutoSpamToggleState, true)
        w199.Status.Text = "Status: Spamming "..w403
        w48(w199.Status, w44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        task.wait(0.05); w373()
    else
        w160(w199.AutoSpamToggleState, false)
        w199.Status.Text = "Status: Inactive"
        w48(w199.Status, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        w56("Spam")
    end
    w33SL("Key Spam → " .. (w21.AutoSpamEnabled and ("Enabled (" .. w21.SpamKey .. ")") or "Disabled"))
end)
w200.FPSToggleBtn.MouseButton1Click:Connect(function()
    if not w53("FPS", 0.3) then return end
    if not w352 then
        w200.FPSUnlockStatus.Text = "FPS Unlock not supported"
        w48(w200.FPSUnlockStatus, w44.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
        w33L("FPS Unlock → Not supported by executor", Color3.fromRGB(220, 80, 80))
        return
    end
    w21.FPSUnlockEnabled = not w21.FPSUnlockEnabled
    w160(w200.FPSToggleState, w21.FPSUnlockEnabled)
    if w21.FPSUnlockEnabled then
        pcall(setfpscap, w21.TargetFPS)
        w200.FPSUnlockStatus.Text = "Your target: "..w21.TargetFPS.." FPS"
        w48(w200.FPSUnlockStatus, w44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
    else
        pcall(setfpscap, 60)
        w200.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
        w48(w200.FPSUnlockStatus, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    w33SL("FPS Unlock → " .. (w21.FPSUnlockEnabled and ("Enabled (" .. w21.TargetFPS .. " FPS)") or "Disabled"))
end)
w201.AutoRejoinToggleBtn.MouseButton1Click:Connect(function()
    if not w53("Rejoin", 0.3) then return end
    w21.AutoRejoinEnabled = not w21.AutoRejoinEnabled
    w160(w201.AutoRejoinToggleState, w21.AutoRejoinEnabled)
    if w21.AutoRejoinEnabled then
        w201.Status.Text = "Status: Enabled\n\nAutomatically rejoins when disconnected."
        w48(w201.Status, w44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        w378()
    else
        w376 = false; w56("Rejoin")
        w377bDC()
        w201.Status.Text = "Status: Disabled\n\nWhen enabled, automatically rejoins the current server when disconnected."
        w48(w201.Status, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    w33SL("Auto Rejoin → " .. (w21.AutoRejoinEnabled and "Enabled" or "Disabled"))
end)
w202.ExecuteButton.MouseButton1Click:Connect(function()
    if not w53("Execute", 0.5) then return end
    local w405, w405L = w202.LoadStringBox.Text, 0
    for _ in (w405.."\n"):gmatch("[^\n]*\n") do w405L = w405L + 1 end
    w202.Status.Text = "Executing..."
    w202.Status.TextColor3 = Color3.fromRGB(255, 200, 100)
    w48(w202.ExecuteButton, w44.Medium, { BackgroundColor3 = Color3.fromRGB(255, 200, 100) })
    local w406, _, wb = w386(w405)
    if w406 then
        w202.AddOutput("Script executed successfully.", Color3.fromRGB(80, 220, 120))
        w33L(string.format("Script executed ✓ (%d lines)", w405L), Color3.fromRGB(80, 220, 120))
        w48(w202.ExecuteButton, w44.Medium, { BackgroundColor3 = Color3.fromRGB(50, 180, 80) })
    else
        if wb then
            w202.AddOutput(wb, Color3.fromRGB(255, 100, 100))
            w33L("Script error: " .. tostring(wb):sub(1, 80), Color3.fromRGB(255, 100, 100))
        end
        w48(w202.ExecuteButton, w44.Medium, { BackgroundColor3 = Color3.fromRGB(180, 50, 50) })
    end
    task.wait(0.5)
    w202.Status.Text = "Ready"
    w202.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    w48(w202.ExecuteButton, w44.Medium, { BackgroundColor3 = Color3.fromRGB(100, 150, 255) })
end)
w202.AutoLoadToggleBtn.MouseButton1Click:Connect(function()
    if not w53("AutoLoad", 0.3) then return end
    w21.AutoLoadEnabled = not w21.AutoLoadEnabled
    w160(w202.AutoLoadToggleState, w21.AutoLoadEnabled)
    if w21.AutoLoadEnabled then
        if w21.SavedCode and w21.SavedCode ~= "" then
            w202.AddOutput("Auto-load enabled — will execute saved code on rejoin.", Color3.fromRGB(80, 220, 120))
            w33L("Auto Load → Enabled (code ready)", Color3.fromRGB(80, 220, 120))
        else
            w202.AddOutput("Auto-load enabled — but no code is saved yet.", Color3.fromRGB(255, 200, 100))
            w33L("Auto Load → Enabled (no code saved yet)", Color3.fromRGB(255, 200, 100))
        end
    else
        w202.AddOutput("Auto-load disabled.", Color3.fromRGB(160, 160, 160))
        w33L("Auto Load → Disabled", Color3.fromRGB(160, 160, 160))
    end
    local w33AO = w33()
    if not w33AO then
        w33L("Auto Load change → Save failed ✗", Color3.fromRGB(220, 80, 80))
    end
end)

local w408, w409, w408L = 0, 0.3, false
w202.LoadStringBox:GetPropertyChangedSignal("Text"):Connect(function()
    w21.SavedCode = w202.LoadStringBox.Text
    if not w408L then
        w408L = true
        task.defer(function()
            w408L = false
            w102(w202.LoadStringBox, w202.LineNumbers, w202.LoadStringScrollFrame, w202.LineNumbersScrollFrame)
        end)
    end
    local w410 = tick()
    if w410 - w408 >= w409 then
        w408 = w410
        w202.Status.Text = "Saving..."
        w202.Status.TextColor3 = Color3.fromRGB(100, 200, 255)
        local w410Ok = w33()
        if w410Ok then
            w202.Status.Text = "Saved"
            w202.Status.TextColor3 = Color3.fromRGB(80, 220, 120)
        else
            w202.Status.Text = "Save failed"
            w202.Status.TextColor3 = Color3.fromRGB(220, 80, 80)
        end
        task.delay(1.5, function()
            if w202.Status.Text == "Saved" or w202.Status.Text == "Save failed" then
                w202.Status.Text = "Ready"
                w202.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end)
    end
end)
w202.LoadStringScrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    w202.LineNumbersScrollFrame.CanvasPosition = Vector2.new(0, w202.LoadStringScrollFrame.CanvasPosition.Y)
end)
w203.KeybindButton.MouseButton1Click:Connect(function()
    if not w53("Keybind", 0.5) or w21.IsChangingKeybind then return end
    w21.IsChangingKeybind = true
    w203.KeybindButton.Text = "Press any key..."
    w33L("Keybind: waiting for key press...", Color3.fromRGB(255, 200, 100))
    w203.KeybindButton.Active = false
    local w411
    local w412 = task.delay(5, function()
        _G.UU.Threads.KeybindTimeout = nil
        if w411 then w411:Disconnect() end
        w21.IsChangingKeybind = false
        w203.KeybindButton.Active = true
        w203.KeybindButton.Text = "Current Key: "..(w22[w21.Keybind] or w21.Keybind.Name)
        w33L("Keybind: input timed out — no change.", Color3.fromRGB(255, 100, 100))
    end)
    _G.UU.Threads.KeybindTimeout = w412
    w411 = w3.InputBegan:Connect(function(w413, w414)
        if w413.UserInputType == Enum.UserInputType.Keyboard and not w414 then
            if _G.UU.Threads.KeybindTimeout then
                pcall(task.cancel, _G.UU.Threads.KeybindTimeout)
                _G.UU.Threads.KeybindTimeout = nil
            end
            if w413.KeyCode == Enum.KeyCode.F5 then
                w203.KeybindButton.Text = "Current Key: "..(w22[w21.Keybind] or w21.Keybind.Name)
                w203.KeybindButton.Active = true
                w21.IsChangingKeybind = false
                w411:Disconnect()
                w33L("Keybind: F5 is reserved", Color3.fromRGB(255, 100, 100))
                return
            end
            w21.Keybind = w413.KeyCode
            local w415 = w22[w413.KeyCode] or w413.KeyCode.Name
            w203.KeybindButton.Text = "Current Key: "..w415
            w33SL("Keybind → " .. w415)
            w203.KeybindButton.Active = true
            w411:Disconnect()
            task.delay(0.1, function() w21.IsChangingKeybind = false end)
        end
    end)
end)
w203.AutoHideToggleBtn.MouseButton1Click:Connect(function()
    if not w53("AutoHide", 0.3) then return end
    w21.AutoHideEnabled = not w21.AutoHideEnabled
    w160(w203.AutoHideToggleState, w21.AutoHideEnabled)
    if w21.AutoHideEnabled then
        w203.Status.Text = "Auto Hide enabled — UI starts hidden on next execution."
        w48(w203.Status, w44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        w33L("Auto Hide → Enabled (UI hidden on start)", Color3.fromRGB(50, 220, 100))
    else
        w203.Status.Text = "Auto Hide disabled — UI shows normally on start."
        w48(w203.Status, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        w33L("Auto Hide → Disabled (UI shows on start)", Color3.fromRGB(180, 180, 180))
    end
    local w33Ok = w33()
    if w33Ok then
        w33L("Auto Hide change → Saved ✓", Color3.fromRGB(80, 220, 120))
    else
        w33L("Auto Hide change → Save failed ✗", Color3.fromRGB(220, 80, 80))
    end
end)

local function w416AV(w417)
    for w418, w420 in pairs(w181) do
        local w421 = w418 == w417
        w46(w420.Button); w46(w420.Icon); w46(w420.Label)
        w420.Button.BackgroundColor3 = w421 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(35, 35, 42)
        w420.Button.Size = w421 and UDim2.new(1, -4, 0, 54) or UDim2.new(1, -10, 0, 50)
        w420.Icon.TextColor3 = w421 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        w420.Icon.TextSize = w421 and 19 or 18
        w420.Label.TextColor3 = w421 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    end
end

local function w416(w417)
    if w21.CurrentTab == w417 and _G.UU.Debounces["Tab"] then return end
    if not w53("Tab", 0.15) then return end
    w21.CurrentTab = w417
    w33()
    for w418, w419 in pairs(w182) do
        if w418 == w417 then
            w419.Visible = true
            w419.Position = UDim2.new(0, 15, 0, 0)
            w48(w419, w44.Smooth, { Position = UDim2.new(0, 5, 0, 0) })
        else
            w419.Visible = false
        end
    end
    w416AV(w417)
end

for w422, w423 in ipairs(w194) do
    if w181[w423.name] then
        local w424 = w423.name
        w181[w424].Button.MouseButton1Click:Connect(function() w416(w424) end)
    end
end

local w425, w426 = {}, false
local function w427()
    if w426 or #w425 == 0 then return end
    w426 = true
    task.spawn(function()
        while #w425 > 0 do
            local w428 = table.remove(w425, 1)
            w428()
            task.wait(0.05)
        end
        w426 = false
    end)
end

local function w429(w428)
    table.insert(w425, w428)
    w427()
end

local function w430(w431, w432)
    local w433, w434 = w60.Width * w432, w60.Height * w432
    return math.max(0, (w431.X - w433) / 2), math.max(0, (w431.Y - w434) / 2)
end

local function w435(w431, w432)
    local w436 = math.floor(60 * w432)
    return w436, math.max(0, (w431.X - w436) / 2), math.max(0, math.min(30, w431.Y - w436))
end

local function w437(w438)
    if not w61 then return end
    w62 = w438
    w48(w61, w44.Smooth, { Scale = w438 })
    w171.TextSize = math.floor(24 * w438)
end

local w439, w440 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0)
local function w441()
    if not w53("UI", 0.6) then return end
    w429(function()
        if w163.Visible then
            w21.SavedUIPosition = { X = w163.Position.X.Offset, Y = w163.Position.Y.Offset }
            w163.Size = UDim2.new(0, w60.Width, 0, w60.Height)
            local wd, wc = w48(w61, w440, { Scale = 0 }), w2:Create(w163, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
            wc:Play()
            wd.Completed:Wait()
            w163.Visible = false; w163.BackgroundTransparency = 0; w61.Scale = 0; w33()
            local w443, w444 = w59(), math.floor(60 * w62)
            local w445, w446
            if w21.SavedReopenPosition then
                w445 = w21.SavedReopenPosition.X
                w446 = w21.SavedReopenPosition.Y
            else
                local _, w447, w448 = w435(w443, w62)
                w445, w446 = w447, w448
            end
            w170.Size = UDim2.new(0, w444, 0, w444)
            w170.Position = UDim2.new(0, w445, 0, w446)
            w170.ImageTransparency = 1; w171.TextTransparency = 1
            w170.Rotation = -180; w170.Visible = true
            local w449 = w2:Create(w170, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, w444, 0, w444),
                Position = UDim2.new(0, w445, 0, w446),
                ImageTransparency = 0, Rotation = 0,
            })
            local w450 = w2:Create(w171, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
            w449:Play(); task.delay(0.15, function() w450:Play() end); w449.Completed:Wait()
        else
            w177SX()
            w21.SavedReopenPosition = { X = w170.Position.X.Offset, Y = w170.Position.Y.Offset }
            local w451 = w2:Create(w170, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0, w170.Position.X.Offset, 0, w170.Position.Y.Offset),
                ImageTransparency = 1, Rotation = 90,
            })
            local w452 = w2:Create(w171, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
            w452:Play(); w451:Play(); w451.Completed:Wait()
            w170.Visible = false; w170.Rotation = 0; w170.ImageTransparency = 0; w171.TextTransparency = 0; w33()
            local w453, w454
            if w21.SavedUIPosition then
                w453 = w21.SavedUIPosition.X; w454 = w21.SavedUIPosition.Y
            else
                w453, w454 = w430(w59(), w62)
            end
            w163.Visible = true
            w163.Size = UDim2.new(0, w60.Width, 0, w60.Height)
            w163.Position = UDim2.new(0, w453, 0, w454 + 18)
            w163.BackgroundTransparency = 1
            w61.Scale = 0
            local we = w2:Create(w163, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, w453, 0, w454),
                BackgroundTransparency = 0,
            })
            local w455 = w48(w61, w439, { Scale = w62 })
            we:Play()
            w455.Completed:Wait()
            w163.BackgroundTransparency = 0
        end
    end)
end

w167.MouseButton1Click:Connect(w441)
w167.MouseEnter:Connect(function() w48(w167, w44.Fast, { BackgroundColor3 = Color3.fromRGB(240, 70, 70), Size = UDim2.new(0, 32, 0, 32), Rotation = 90 }) end)
w167.MouseLeave:Connect(function() w48(w167, w44.Fast, { BackgroundColor3 = Color3.fromRGB(220, 50, 50), Size = UDim2.new(0, 28, 0, 28), Rotation = 0 }) end)
w167.MouseButton1Down:Connect(function() w48(w167, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 24, 0, 24) }) end)
w167.MouseButton1Up:Connect(function() w48(w167, w44.Fast, { Size = UDim2.new(0, 28, 0, 28) }) end)
w170.MouseButton1Click:Connect(function() if not w176 then w441() end end)
table.insert(_G.UU.Connections, w3.InputBegan:Connect(function(w458, w459)
    if not w459 and w458.KeyCode == w21.Keybind and not w21.IsChangingKeybind then
        w441()
    end
end))

local w460, wM = Vector2.new(0, 0), nil
local function wN()
    if wM then wM:Disconnect(); wM = nil end
    if w21.MousePosEnabled then
        wM = w5.RenderStepped:Connect(function()
            local wO = w3:GetMouseLocation()
            w21.MousePosSaved.X = wO.X
            w21.MousePosSaved.Y = wO.Y
        end)
    end
end

table.insert(_G.UU.Connections, w3.InputBegan:Connect(function(wP, wQ)
    if not wQ and wP.KeyCode == Enum.KeyCode.F5 then
        w21.MousePosEnabled = not w21.MousePosEnabled
        w160(w198.MousePosToggleState, w21.MousePosEnabled)
        wN()
        w33SL("Mouse Position → " .. (w21.MousePosEnabled and "Tracking" or "Locked"))
    end
end))
w198.MousePosToggleBtn.MouseButton1Click:Connect(function()
    w21.MousePosEnabled = not w21.MousePosEnabled
    w160(w198.MousePosToggleState, w21.MousePosEnabled)
    wN()
    w33SL("Mouse Position → " .. (w21.MousePosEnabled and "Tracking" or "Locked"))
end)
task.spawn(function()
    while true do
        task.wait(0.25)
        if w198.MousePosLabel and w198.MousePosLabel.Parent then
            local wR = w21.MousePosEnabled and "Tracking" or "Locked"
            w198.MousePosLabel.Text = string.format("[%s] F5 · %d, %d", wR, math.floor(w21.MousePosSaved.X), math.floor(w21.MousePosSaved.Y))
            w198.MousePosLabel.TextColor3 = w21.MousePosEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(150, 150, 150)
        end
    end
end)

local w461 = false
local function w462()
    if w461 then return end
    w461 = true
    task.delay(0.1, function()
        w461 = false
        local w463 = w59()
        if math.abs(w463.X - w460.X) < 2 and math.abs(w463.Y - w460.Y) < 2 then return end
        w460 = w463
        local w464 = w63(w463)
        if _G.UU.UI.ResolutionLabel then _G.UU.UI.ResolutionLabel.Text = string.format("Resolution: %dx%d", w463.X, w463.Y) end
        if _G.UU.UI.DeviceLabel then _G.UU.UI.DeviceLabel.Text = "Device: "..w19() end
        w437(w464)
        w21.SavedUIPosition = nil
        w21.SavedReopenPosition = nil
        local w465, w466 = w430(w463, w464)
        w163.Position = UDim2.new(0, w465, 0, w466)
        local w467 = math.floor(60 * w62)
        w465 = math.max(0, (w463.X - w467) / 2)
        w466 = math.max(0, math.min(30, w463.Y - w467))
        w170.Size = UDim2.new(0, w467, 0, w467)
        w170.Position = UDim2.new(0, w465, 0, w466)
        w33()
    end)
end

if workspace.CurrentCamera then
    table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(w462))
end

table.insert(_G.UU.Connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(w462))
    end
end))
table.insert(_G.UU.Connections, w5.RenderStepped:Connect(function()
    w358 = w358 + 1
    local w468 = tick()
    if w468 - w357 >= 1 then
        w356 = math.floor(w358 / (w468 - w357))
        w358 = 0; w357 = w468
        if w197.FPSLabel then w197.FPSLabel.Text = "FPS: "..w356 end
        table.remove(w354, 1); table.insert(w354, w356)
        local w469, w470, w471 = math.huge, 0, 0
        for _, w472 in ipairs(w354) do
            w469 = math.min(w469, w472); w470 = math.max(w470, w472); w471 = w471 + w472
        end
        local w473 = math.floor(w471 / #w354)
        if w200.FPSStats then
            w200.FPSStats.Current.Text = "Current: "..w356
            w200.FPSStats.Avg.Text = "Average: "..w473
            w200.FPSStats.MinMax.Text = string.format("Min: %d | Max: %d", w469, w470)
        end
        local w474 = w10:GetTotalMemoryUsageMb()
        w359 = math.max(w359, w474)
        if w197.MemoryLabel then w197.MemoryLabel.Text = string.format("Memory: %.1f MB", w474) end
        if w200.MemoryStats then
            w200.MemoryStats.Current.Text = string.format("Current: %.1f MB", w474)
            w200.MemoryStats.Peak.Text = string.format("Peak: %.1f MB", w359)
        end
    end
    if w358 % 30 == 0 then
        local w475 = math.floor(w11:GetNetworkPing() * 1000)
        if w197.PingLabel then
            w197.PingLabel.Text = "Ping: "..w475.." ms"
            w197.PingLabel.TextColor3 = w475 < 100 and Color3.fromRGB(0, 255, 0) or w475 < 200 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        table.remove(w355, 1); table.insert(w355, w475)
        local w476, w477, w478 = math.huge, 0, 0
        for _, w479 in ipairs(w355) do
            w476 = math.min(w476, w479); w477 = math.max(w477, w479); w478 = w478 + w479
        end
        local w480 = math.floor(w478 / #w355)
        if w200.PingStats then
            w200.PingStats.Current.Text = "Current: "..w475.."ms"
            w200.PingStats.Avg.Text = "Average: "..w480.."ms"
            w200.PingStats.MinMax.Text = string.format("Min: %dms | Max: %dms", w476, w477)
            local w481, w482
            if w475 < 50 then w481, w482 = "Excellent", Color3.fromRGB(50, 220, 100)
            elseif w475 < 100 then w481, w482 = "Good", Color3.fromRGB(100, 200, 255)
            elseif w475 < 200 then w481, w482 = "Fair", Color3.fromRGB(255, 200, 100)
            elseif w475 < 300 then w481, w482 = "Poor", Color3.fromRGB(255, 150, 50)
            else w481, w482 = "Very Poor", Color3.fromRGB(220, 50, 50)
            end
            w200.PingStats.Quality.Text = w481
            w200.PingStats.Quality.TextColor3 = w482
        end
    end
end))

local w483 = w41()

if w483 then
    if w203.KeybindButton then w203.KeybindButton.Text = "Current Key: "..(w22[w21.Keybind] or w21.Keybind.Name) end
    if w199.SpamInput then w199.SpamInput.Text = w21.SpamKey end
    if w202.LoadStringBox then w202.LoadStringBox.Text = w21.SavedCode end
    w393((w21.JumpDelay - 5) / 25)
    w395((w21.ClickDelay - 1) / 9)
    w396((w21.SpamDelay - 0.05) / 4.95)
    w397((w21.TargetFPS - 15) / 345)
    w160(w202.AutoLoadToggleState, w21.AutoLoadEnabled)
    w160(w203.AutoHideToggleState, w21.AutoHideEnabled)
    if w21.AutoHideEnabled then
        w203.Status.Text = "Auto Hide enabled — UI starts hidden on next execution."
        w203.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
    else
        w203.Status.Text = "Auto Hide disabled — UI shows normally on start."
        w203.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
    if w21.AutoRejoinEnabled then
        w160(w201.AutoRejoinToggleState, true)
        w201.Status.Text = "Status: Enabled\n\nAutomatically rejoins when disconnected."
        w201.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        w378()
    else
        w160(w201.AutoRejoinToggleState, false)
    end
    if w21.FPSUnlockEnabled and w352 then
        w160(w200.FPSToggleState, true)
        w200.FPSUnlockStatus.TextColor3 = Color3.fromRGB(50, 220, 100)
        w200.FPSUnlockStatus.Text = "Current Limit: "..w21.TargetFPS.." FPS (Custom)"
        pcall(setfpscap, w21.TargetFPS)
    else
        w160(w200.FPSToggleState, false)
        if w352 then pcall(setfpscap, 60) end
    end
    w160(w198.JumpToggleState, w21.JumpEnabled)
    if w21.JumpEnabled then task.wait(0.1); w365() end
    w160(w198.ClickToggleState, w21.ClickEnabled)
    w160(w198.MousePosToggleState, w21.MousePosEnabled)
    if w21.ClickEnabled then task.wait(0.1); w368() end
    if w21.MousePosEnabled then wN() end
    if w21.AutoSpamEnabled and w23[w21.SpamKey] then
        w160(w199.AutoSpamToggleState, true)
        w199.Status.Text = "Status: Spamming "..w21.SpamKey
        w199.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        task.wait(0.1); w373()
    else
        w21.AutoSpamEnabled = false
        w160(w199.AutoSpamToggleState, false)
    end
    w361()
    task.defer(function()
        w33L("Config loaded for "..w12.." (Id: "..w13..")", Color3.fromRGB(100, 200, 255))
    end)
else
    w393(0.2); w395(0.22); w396(0.01); w397(0.13)
    w160(w198.JumpToggleState, false)
    w160(w198.ClickToggleState, false)
    w160(w199.AutoSpamToggleState, false)
    w160(w198.MousePosToggleState, false)
    w160(w200.FPSToggleState, false)
    w160(w201.AutoRejoinToggleState, false)
    w160(w202.AutoLoadToggleState, false)
    w160(w203.AutoHideToggleState, false)
    w200.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
    w203.Status.Text = "Auto Hide disabled — UI shows normally on start."
    w203.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    w361()
    task.defer(function()
        w33L("Fresh start — no saved config found.", Color3.fromRGB(255, 200, 100))
        w33L("Using defaults. Keybind: G | Auto Hide: Off", Color3.fromRGB(150, 150, 150))
    end)
end

task.spawn(function()
    pcall(function()
        if _G.UU.UI.PlayerImage then
            _G.UU.UI.PlayerImage.Image = "rbxthumb://type=AvatarHeadShot&id="..w13.."&w=420&h=420"
        end
        if _G.UU.UI.GameName and _G.UU.UI.GameImage then
            local w484 = w8:GetProductInfo(game.PlaceId)
            _G.UU.UI.GameName.Text = w484.Name
            if w484.IconImageAssetId and w484.IconImageAssetId ~= 0 then
                _G.UU.UI.GameImage.Image = "rbxthumb://type=Asset&id="..w484.IconImageAssetId.."&w=420&h=420"
            end
        end
    end)
end)

w102(w202.LoadStringBox, w202.LineNumbers, w202.LoadStringScrollFrame, w202.LineNumbersScrollFrame)

w162.Destroying:Connect(function()
    w33()
    w177SX()
    for w485, w15 in pairs(_G.UU.Threads) do
        if w15 and typeof(w15) == "thread" and coroutine.status(w15) ~= "dead" then
            pcall(task.cancel, w15)
        end
        _G.UU.Threads[w485] = nil
    end
    if w377B then pcall(function() w377B:Disconnect() end); w377B = nil end
end)
for w486, w487 in pairs(w182) do w487.Visible = false end

local w488 = w59()
if w488.X < 100 or w488.Y < 100 then
    repeat task.wait() until workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X > 100
end

task.wait(0.1)

local w489 = not w21.AutoHideEnabled
w488 = w59()
w460 = w488
w62 = w63(w488)

local w490, w491
if w21.SavedUIPosition and w21.SavedUIPosition.X and w21.SavedUIPosition.Y then
    w490 = w21.SavedUIPosition.X
    w491 = w21.SavedUIPosition.Y
else
    w490, w491 = w430(w488, w62)
end

local w492, w493, w494
if w21.SavedReopenPosition and w21.SavedReopenPosition.X and w21.SavedReopenPosition.Y then
    w492 = math.floor(60 * w62)
    w493 = w21.SavedReopenPosition.X
    w494 = w21.SavedReopenPosition.Y
else
    w492, w493, w494 = w435(w488, w62)
end

local w416ST = w21.CurrentTab or "Home"
for w418, w419 in pairs(w182) do
    w419.Visible = (w418 == w416ST)
end

w416AV(w416ST)
w21.CurrentTab = w416ST
w33()

if w489 then
    w163.Visible = true
    w163.Size = UDim2.new(0, w60.Width, 0, w60.Height)
    w163.Position = UDim2.new(0, w490, 0, w491 + 24)
    w163.BackgroundTransparency = 1
    w61.Scale = 0
    w170.Visible = false
    local wf = w2:Create(w163, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, w490, 0, w491),
        BackgroundTransparency = 0,
    })
    local wg = w48(w61, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = w62 })
    wf:Play()
    wg.Completed:Wait()
    w163.BackgroundTransparency = 0
else
    w163.Visible = false
    w170.Size = UDim2.new(0, 0, 0, 0)
    w170.Position = UDim2.new(0, w493 + w492 / 2, 0, w494 + w492 / 2)
    w170.ImageTransparency = 1
    w171.TextTransparency = 1
    w170.Rotation = -270
    w170.Visible = true
    local wh = w2:Create(w170, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, w492, 0, w492),
        Position = UDim2.new(0, w493, 0, w494),
        ImageTransparency = 0,
        Rotation = 0,
    })
    local wi = w2:Create(w171, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
    wh:Play()
    task.delay(0.2, function() wi:Play() end)
    wh.Completed:Wait()
end

if queue_on_teleport and not _G.UU.TeleportQueued then
    _G.UU.TeleportQueued = true
    pcall(function()
        queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/6942x/UniversalUtility/main/Init.lua", true))()')
    end)
end

_G.UU.Loaded = true
_G.UU.LoadLock = false

task.defer(function()
    if w483 and w21.AutoLoadEnabled and w21.SavedCode and w21.SavedCode ~= "" then
        w202.Status.Text = "Executing..."
        w202.Status.TextColor3 = Color3.fromRGB(255, 200, 100)
        w33L("Auto Load → executing saved script on start...", Color3.fromRGB(255, 200, 100))
        local w496, _, wj = w386(w21.SavedCode)
        if w496 then
            w202.AddOutput("Auto-load executed successfully.", Color3.fromRGB(80, 220, 120))
            w33L("Auto Load → script executed ✓", Color3.fromRGB(80, 220, 120))
        else
            if wj then
                w202.AddOutput(wj, Color3.fromRGB(255, 100, 100))
                w33L("Auto Load error: " .. tostring(wj):sub(1, 80), Color3.fromRGB(255, 100, 100))
            end
        end
        w202.Status.Text = "Ready"
        w202.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)

return _G.UU
