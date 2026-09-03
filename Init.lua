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
        for wa1, wa2 in pairs(_G.UU.Threads) do
            if wa2 and typeof(wa2) == "thread" and coroutine.status(wa2) ~= "dead" then
                pcall(task.cancel, wa2)
            end
            _G.UU.Threads[wa1] = nil
        end
    end
    if _G.UU.Connections then
        for wa3, wa4 in pairs(_G.UU.Connections) do
            pcall(function() wa4:Disconnect() end)
        end
        _G.UU.Connections = {}
    end
    _G.UU.TeleportQueued = false
    local wa5 = w6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
    if wa5 then wa5:Destroy() end
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
    local wa1 = w3:GetLastInputType()
    if wa1 == Enum.UserInputType.Touch then return "Mobile"
    elseif wa1 == Enum.UserInputType.Gamepad1 or wa1 == Enum.UserInputType.Gamepad2 then return "Console" end
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
for wa1 = 65, 90 do
    local wa2 = string.char(wa1)
    w22[Enum.KeyCode[wa2]] = wa2
    w23[wa2] = Enum.KeyCode[wa2]
end

local wa3 = { "One","Two","Three","Four","Five","Six","Seven","Eight","Nine" }
for wa4 = 0, 9 do
    local wa5 = wa4 == 0 and "Zero" or wa3[wa4]
    w22[Enum.KeyCode[wa5]] = tostring(wa4)
    w23[tostring(wa4)] = Enum.KeyCode[wa5]
end

for wa6 = 1, 12 do
    w22[Enum.KeyCode["F"..wa6]] = "F"..wa6
    w23["F"..wa6] = Enum.KeyCode["F"..wa6]
end

for wa7, wa8 in pairs({
    LeftControl="Left Ctrl", RightControl="Right Ctrl",
    LeftShift="Left Shift", RightShift="Right Shift",
    LeftAlt="Left Alt", RightAlt="Right Alt",
    Tab="Tab", CapsLock="Caps Lock",
    Space="Space", Return="Enter",
    Backspace="Backspace", Delete="Delete",
    Insert="Insert", Home="Home",
    End="End", PageUp="Page Up",
    PageDown="Page Down",
}) do w22[Enum.KeyCode[wa7]] = wa8 end
_G.UU.KCN = w22
_G.UU.KCM = w23

local function w32()
    return "UniversalUtility/Accounts/" .. w12 .. ".json"
end

local function w14()
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
    w14()
    local wa1, wa2 = _G.UU.UI and _G.UU.UI.MainFrame, _G.UU.UI and _G.UU.UI.ReopenButton
    if wa1 and wa1.Visible then
        w21.SavedUIPosition = { X = wa1.Position.X.Offset, Y = wa1.Position.Y.Offset }
    end
    if wa2 and wa2.Visible then
        w21.SavedReopenPosition = { X = wa2.Position.X.Offset, Y = wa2.Position.Y.Offset }
    end
    local wa3 = {
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
    local wa4, wa5 = pcall(function()
        writefile(w32(), w:JSONEncode(wa3))
    end)
    if wa4 then
        _G.UU.LastSaveTime = tick()
        _G.UU.SavePending = false
    else
        if _G.UU.AddActivityLog then
            _G.UU.AddActivityLog("Save error: " .. tostring(wa5), Color3.fromRGB(220, 80, 80))
        end
    end
    return wa4
end

_G.UU.SaveCFG = w33

local w15 = {}
local function w16(wa1, wa2)
    if _G.UU.AddActivityLog then
        _G.UU.AddActivityLog(wa1, wa2)
    else
        table.insert(w15, { msg = wa1, col = wa2 })
    end
end

local function w17(wa1)
    local wa2 = w33()
    if wa2 then
        w16(wa1 .. " → Saved ✓", Color3.fromRGB(80, 220, 120))
    else
        w16(wa1 .. " → Save failed ✗", Color3.fromRGB(220, 80, 80))
    end
end

local function w39()
    if _G.UU.SavePending then return end
    _G.UU.SavePending = true
    local wa1 = tick() - _G.UU.LastSaveTime
    if wa1 >= 0.1 then
        w33()
    else
        task.delay(0.1 - wa1, function()
            if _G.UU.SavePending then
                w33()
            end
        end)
    end
end

_G.UU.DebouncedSave = w39

local function w41()
    if not (readfile and isfile) then return false end
    local wa1 = w32()
    if not isfile(wa1) then return false end
    local wa2, wa3 = pcall(function() return w:JSONDecode(readfile(wa1)) end)
    if not wa2 or not wa3 or wa3.UserId ~= w13 then return false end
    w21.Keybind = Enum.KeyCode[wa3.Keybind] or Enum.KeyCode.G
    w21.MousePosEnabled = wa3.MousePosEnabled or false
    w21.MousePosSaved = wa3.MousePosSaved or { X = 960, Y = 540 }
    w21.JumpEnabled = wa3.JumpEnabled or false
    w21.ClickEnabled = wa3.ClickEnabled or false
    w21.AutoRejoinEnabled = wa3.AutoRejoinEnabled or false
    w21.FPSUnlockEnabled = wa3.FPSUnlockEnabled or false
    w21.AutoSpamEnabled = wa3.AutoSpamEnabled or false
    w21.AutoLoadEnabled = wa3.AutoLoadEnabled or false
    w21.AutoHideEnabled = wa3.AutoHideEnabled or false
    w21.TargetFPS = wa3.TargetFPS or 60
    w21.JumpDelay = wa3.JumpDelay or 10.0
    w21.ClickDelay = wa3.ClickDelay or 3.0
    w21.SpamDelay = wa3.SpamDelay or 0.1
    w21.SpamKey = wa3.SpamKey or "Q"
    w21.SavedCode = wa3.SavedCode or ""
    w21.CurrentTab = wa3.CurrentTab or "Home"
    w21.UIPosition = wa3.UIPosition or { X = 0.5, Y = 0.5 }
    w21.ReopenPosition = wa3.ReopenPosition or { X = 0.5, Y = 30 }
    w21.SavedUIPosition = wa3.SavedUIPosition or nil
    w21.SavedReopenPosition = wa3.SavedReopenPosition or nil
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
local function w46(wa1)
    if w45[wa1] then w45[wa1]:Cancel(); w45[wa1] = nil end
end

local function w48(wa1, wa2, wa3)
    w46(wa1)
    local wa4 = w2:Create(wa1, wa2, wa3)
    w45[wa1] = wa4
    wa4:Play()
    wa4.Completed:Connect(function(wa5)
        if wa5 == Enum.TweenStatus.Completed then w45[wa1] = nil end
    end)
    return wa4
end

local function w53(wa1, wa2)
    if _G.UU.Debounces[wa1] then return false end
    _G.UU.Debounces[wa1] = true
    task.delay(wa2 or 0.3, function() _G.UU.Debounces[wa1] = false end)
    return true
end

local function w56(wa1)
    if _G.UU.Threads[wa1] then
        local wa2 = _G.UU.Threads[wa1]
        _G.UU.Threads[wa1] = nil
        if typeof(wa2) == "thread" and coroutine.status(wa2) ~= "dead" then
            pcall(task.cancel, wa2)
        end
    end
end

local function w59()
    return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
end

local w60, w61, w62 = { Width = 650, Height = 500 }, nil, 1
local function w63(wa1)
    return math.clamp(math.min(wa1.X / 1920, wa1.Y / 1080), 0.75, 1.4)
end

local function w65(wa1, wa2)
    local wa3 = Instance.new("UICorner", wa1)
    wa3.CornerRadius = UDim.new(0, wa2 or 8)
    return wa3
end

local function w69(wa1, wa2, wa3, wa4)
    local wa5 = Instance.new("UIGradient", wa1)
    wa5.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, wa2),
        ColorSequenceKeypoint.new(1, wa3),
    }
    wa5.Rotation = wa4 or 90
    return wa5
end

local function w74(wa1, wa2, wa3, wa4, wa5, wa6, wa7, wa8)
    local wa9 = Instance.new("Frame", wa1)
    wa9.Size = wa2
    wa9.Position = wa3
    wa9.BackgroundTransparency = 1
    local waa = Instance.new("TextLabel", wa9)
    waa.Size = UDim2.new(1, 0, 0, 18)
    waa.BackgroundTransparency = 1
    waa.Text = wa8 or wa5
    waa.Font = Enum.Font.Gotham
    waa.TextSize = 12
    waa.TextColor3 = Color3.fromRGB(180, 180, 180)
    waa.TextXAlignment = Enum.TextXAlignment.Left
    local wab = Instance.new("Frame", wa9)
    wab.Size = UDim2.new(1, -60, 0, 6)
    wab.Position = UDim2.new(0, 0, 0, 22)
    wab.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    wab.BorderSizePixel = 0
    w65(wab, 3)
    local wac, wad = Instance.new("Frame", wab), wa6 or 0
    local wae = (wa7 or 1) - wad
    local waf = (wa4 - wad) / math.max(wae, 0.001)
    wac.Size = UDim2.new(math.clamp(waf, 0, 1), 0, 1, 0)
    wac.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    wac.BorderSizePixel = 0
    w65(wac, 3)
    local wag = Instance.new("TextButton", wab)
    wag.Size = UDim2.new(1, 0, 1, 0)
    wag.BackgroundTransparency = 1
    wag.Text = ""
    local wah = Instance.new("TextBox", wa9)
    wah.Size = UDim2.new(0, 50, 0, 24)
    wah.Position = UDim2.new(1, -50, 0, 16)
    wah.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    wah.Text = tostring(wa4)
    wah.Font = Enum.Font.Gotham
    wah.TextScaled = true
    wah.TextColor3 = Color3.fromRGB(255, 255, 255)
    wah.ClearTextOnFocus = false
    wah.BorderSizePixel = 0
    w65(wah, 5)
    return wa9, wab, wac, wag, wah
end

local function w91(wa1, wa2, wa3, wa4, wa5, wa6)
    w48(wa1, w44.Fast, { Size = UDim2.new((wa3 - wa4) / (wa5 - wa4), 0, 1, 0) })
    wa2.Text = string.format(wa6, wa3)
end

local function w18(wa1, wa2, wa3, wa4, wa5, wa6)
    wa1.Size = UDim2.new((wa3 - wa4) / (wa5 - wa4), 0, 1, 0)
    wa2.Text = string.format(wa6, wa3)
end

local function w98(wa1, wa2)
    task.spawn(function()
        wa2 = wa2 or 0.95
        local wa3 = wa1.Size
        w48(wa1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(wa3.X.Scale * wa2, wa3.X.Offset * wa2, wa3.Y.Scale * wa2, wa3.Y.Offset * wa2)
        })
        task.wait(0.1)
        w48(wa1, w44.Back, { Size = wa3 })
    end)
end

local function w20(wa1, wa2, wa3, wa4)
    local wa5, wa6 = wa1.Text, 1
    for _ in wa5:gmatch("\n") do wa6 = wa6 + 1 end
    local wa7 = {}
    for wa8 = 1, wa6 do wa7[wa8] = tostring(wa8) end
    wa2.Text = table.concat(wa7, "\n") .. "\n"
    local wa9 = w9:GetTextSize(wa1.Text, wa1.TextSize, wa1.Font, Vector2.new(wa1.AbsoluteSize.X - 10, math.huge))
    local waa = math.max(200, wa9.Y + 20)
    wa1.Size = UDim2.new(1, -10, 0, waa)
    wa3.CanvasSize = UDim2.new(0, 0, 0, waa)
    wa4.CanvasSize = UDim2.new(0, 0, 0, waa)
    wa2.Size = UDim2.new(1, -5, 0, waa)
end

local function w24(wa1, wa2)
    local wa3, wa4, wa5, wa6 = false, nil, nil, nil
    wa1.InputBegan:Connect(function(wa7)
        if wa7.UserInputType == Enum.UserInputType.MouseButton1 or wa7.UserInputType == Enum.UserInputType.Touch then
            wa3 = true
            wa4 = wa7.Position
            wa5 = wa1.Position
            if wa6 then wa6:Disconnect() end
            wa6 = w3.InputChanged:Connect(function(wa8)
                if (wa8.UserInputType == Enum.UserInputType.MouseMovement or wa8.UserInputType == Enum.UserInputType.Touch) and wa3 then
                    local wa9 = wa8.Position - wa4
                    wa1.Position = UDim2.new(wa5.X.Scale, wa5.X.Offset + wa9.X, wa5.Y.Scale, wa5.Y.Offset + wa9.Y)
                end
            end)
            wa7.Changed:Connect(function()
                if wa7.UserInputState == Enum.UserInputState.End then
                    wa3 = false
                    if wa6 then wa6:Disconnect(); wa6 = nil end
                    if wa2 then wa2() end
                end
            end)
        end
    end)
end

local function w47(wa1, wa2, wa3, wa4)
    local wa5 = Instance.new("Frame", wa1)
    wa5.Size = wa2
    wa5.Position = wa3
    wa5.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    wa5.BorderSizePixel = 0
    w65(wa5, 8)
    Instance.new("UIStroke", wa5).Color = Color3.fromRGB(50, 50, 60)
    local wa6 = Instance.new("TextLabel", wa5)
    wa6.Size = UDim2.new(1, -10, 1, -10)
    wa6.Position = UDim2.new(0, 5, 0, 5)
    wa6.BackgroundTransparency = 1
    wa6.Text = wa4
    wa6.Font = Enum.Font.GothamBold
    wa6.TextSize = 14
    wa6.TextColor3 = Color3.fromRGB(180, 180, 180)
    wa6.TextXAlignment = Enum.TextXAlignment.Center
    wa6.TextWrapped = true
    wa6.TextYAlignment = Enum.TextYAlignment.Top
    return wa5, wa6
end

local function w49(wa1, wa2)
    local wa3 = Instance.new("Frame", wa1)
    wa3.Size = UDim2.new(1, -20, 0, 1)
    wa3.Position = UDim2.new(0, 10, 0, wa2)
    wa3.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    wa3.BorderSizePixel = 0
    return wa3
end

local function w50(wa1, wa2, wa3, wa4)
    local wa5 = Instance.new("TextLabel", wa1)
    wa5.Size = UDim2.new(1, -20, 0, 20)
    wa5.Position = UDim2.new(0, 10, 0, wa3)
    wa5.BackgroundTransparency = 1
    wa5.Text = wa2
    wa5.Font = Enum.Font.GothamBold
    wa5.TextSize = 13
    wa5.TextColor3 = wa4 or Color3.fromRGB(200, 200, 200)
    wa5.TextXAlignment = Enum.TextXAlignment.Left
    return wa5
end

local function w51(wa1, wa2, wa3)
    local wa4 = Instance.new("Frame", wa1)
    wa4.Size = UDim2.new(1, 0, 0, wa2)
    wa4.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    wa4.BorderSizePixel = 0
    wa4.LayoutOrder = wa3 or 1
    w65(wa4, 10)
    w69(wa4, Color3.fromRGB(35, 35, 42), Color3.fromRGB(40, 40, 47), 90)
    return wa4
end

local function w52(wa1, wa2, wa3)
    local wa4 = Instance.new("TextLabel", wa1)
    wa4.Size = UDim2.new(1, -20, 0, 16)
    wa4.Position = UDim2.new(0, 10, 0, wa3)
    wa4.BackgroundTransparency = 1
    wa4.Text = wa2
    wa4.Font = Enum.Font.Gotham
    wa4.TextSize = 12
    wa4.TextColor3 = Color3.fromRGB(150, 150, 150)
    wa4.TextXAlignment = Enum.TextXAlignment.Left
    return wa4
end

local function w54(wa1, wa2, wa3)
    local wa4 = Instance.new("TextLabel", wa1)
    wa4.Size = UDim2.new(1, -20, 0, 26)
    wa4.Position = UDim2.new(0, 10, 0, wa3)
    wa4.BackgroundTransparency = 1
    wa4.Text = wa2
    wa4.Font = Enum.Font.GothamBold
    wa4.TextSize = 18
    wa4.TextXAlignment = Enum.TextXAlignment.Left
    return wa4
end

local function w55(wa1, wa2, wa3)
    local wa4 = Instance.new("Frame", wa1)
    wa4.Size = UDim2.new(1, -20, 0, 36)
    wa4.Position = UDim2.new(0, 10, 0, wa3)
    wa4.BackgroundTransparency = 1
    local wa5 = Instance.new("TextLabel", wa4)
    wa5.Size = UDim2.new(1, -70, 1, 0)
    wa5.BackgroundTransparency = 1
    wa5.Text = wa2
    wa5.Font = Enum.Font.GothamBold
    wa5.TextSize = 14
    wa5.TextColor3 = Color3.fromRGB(200, 200, 200)
    wa5.TextXAlignment = Enum.TextXAlignment.Left
    return wa4, wa5
end

local w57 = {}
local function w58(wa1, wa2, wa3, wa4, wa5)
    local wa6, wa7 = wa2.X.Offset or 56, wa2.Y.Offset or 28
    local wa8, wa9 = wa7 - 6, 3
    local waa, wab = wa6 - wa8 - 3, Instance.new("Frame", wa1)
    wab.Size = UDim2.new(0, wa6, 0, wa7)
    wab.Position = wa3
    wab.AnchorPoint = Vector2.new(0.5, 0.5)
    wab.BorderSizePixel = 0
    wab.BackgroundColor3 = wa4 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70)
    w65(wab, wa7 / 2)
    local wac = Instance.new("Frame", wab)
    wac.Size = UDim2.new(0, wa8, 0, wa8)
    wac.Position = UDim2.new(0, wa4 and waa or wa9, 0.5, 0)
    wac.AnchorPoint = Vector2.new(0, 0.5)
    wac.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    wac.BorderSizePixel = 0
    w65(wac, wa8 / 2)
    local wad = Instance.new("TextButton", wab)
    wad.Size = UDim2.new(1, 0, 1, 0)
    wad.BackgroundTransparency = 1
    wad.Text = ""
    wad.ZIndex = wab.ZIndex + 2
    local wae = { value = wa4, track = wab, knob = wac, offX = wa9, onX = waa }
    w57[wad] = wae
    if wa5 then
        wad.MouseButton1Click:Connect(function()
            wae.value = not wae.value
            w48(wab, w44.Fast, { BackgroundColor3 = wae.value and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70) })
            w48(wac, w44.Fast, { Position = UDim2.new(0, wae.value and waa or wa9, 0.5, 0) })
            wa5(wae.value)
        end)
    end
    return wad, wab, wac, wae
end

local function w70(wa1, wa2)
    if not wa1 then return end
    wa1.value = wa2
    w48(wa1.track, w44.Fast, { BackgroundColor3 = wa2 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(60, 60, 70) })
    w48(wa1.knob, w44.Fast, { Position = UDim2.new(0, wa2 and wa1.onX or wa1.offX, 0.5, 0) })
end

local function w25(wa1, wa2, wa3, wa4)
    wa1.MouseEnter:Connect(function()
        w48(wa1, w44.Fast, wa3)
    end)
    wa1.MouseLeave:Connect(function()
        w48(wa1, w44.Fast, wa2)
    end)
    wa1.MouseButton1Down:Connect(function()
        w48(wa1, w44.Fast, wa4)
    end)
    wa1.MouseButton1Up:Connect(function()
        w48(wa1, w44.Fast, wa3)
    end)
end

local function w26(wa1, wa2, wa3, wa4)
    local wa5 = Instance.new("Frame", wa1)
    wa5.Size = wa2
    wa5.Position = wa3
    wa5.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    wa5.BorderSizePixel = 0
    w65(wa5, 8)
    Instance.new("UIStroke", wa5).Color = Color3.fromRGB(50, 50, 60)
    local wa6 = Instance.new("ScrollingFrame", wa5)
    wa6.Size = UDim2.new(1, -4, 1, -4)
    wa6.Position = UDim2.new(0, 2, 0, 2)
    wa6.BackgroundTransparency = 1
    wa6.BorderSizePixel = 0
    wa6.ScrollBarThickness = 3
    wa6.ScrollBarImageColor3 = wa4 or Color3.fromRGB(100, 150, 255)
    wa6.ScrollBarImageTransparency = 0.5
    wa6.CanvasSize = UDim2.new(0, 0, 0, 0)
    wa6.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local wa7 = Instance.new("UIListLayout", wa6)
    wa7.SortOrder = Enum.SortOrder.LayoutOrder
    wa7.Padding = UDim.new(0, 2)
    local wa8 = Instance.new("UIPadding", wa6)
    wa8.PaddingLeft = UDim.new(0, 6)
    wa8.PaddingRight = UDim.new(0, 6)
    wa8.PaddingTop = UDim.new(0, 4)
    wa8.PaddingBottom = UDim.new(0, 4)
    local wa9 = Instance.new("TextLabel", wa6)
    wa9.Size = UDim2.new(1, 0, 0, 20)
    wa9.BackgroundTransparency = 1
    wa9.Font = Enum.Font.Code
    wa9.TextSize = 11
    wa9.TextColor3 = Color3.fromRGB(90, 90, 100)
    wa9.TextXAlignment = Enum.TextXAlignment.Left
    wa9.LayoutOrder = 1
    local waa = 1
    local wax = {}
    local function wab(wac, wad)
        wa9.Visible = false
        waa = waa + 1
        local wae, waf = os.date and os.date("%H:%M:%S") or "—", Instance.new("TextLabel", wa6)
        waf.Size = UDim2.new(1, 0, 0, 0)
        waf.AutomaticSize = Enum.AutomaticSize.Y
        waf.BackgroundTransparency = 1
        waf.Text = "["..wae.."] "..wac
        waf.Font = Enum.Font.Code
        waf.TextSize = 11
        waf.TextColor3 = wad or Color3.fromRGB(220, 220, 220)
        waf.TextXAlignment = Enum.TextXAlignment.Left
        waf.TextYAlignment = Enum.TextYAlignment.Top
        waf.TextWrapped = true
        waf.RichText = false
        waf.LayoutOrder = waa
        wax[#wax + 1] = waf
        if #wax > 40 then
            wax[1]:Destroy()
            table.remove(wax, 1)
        end
        task.defer(function() wa6.CanvasPosition = Vector2.new(0, math.huge) end)
        return waf
    end
    local wag = Instance.new("TextButton", wa1)
    wag.Size = UDim2.new(0, 50, 0, 18)
    wag.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    wag.Text = "Clear"
    wag.Font = Enum.Font.Gotham
    wag.TextSize = 11
    wag.TextColor3 = Color3.fromRGB(180, 180, 180)
    wag.BorderSizePixel = 0
    wag.AutoButtonColor = false
    w65(wag, 4)
    w25(wag,
        { BackgroundColor3 = Color3.fromRGB(60, 60, 70), Size = UDim2.new(0, 50, 0, 18) },
        { BackgroundColor3 = Color3.fromRGB(80, 80, 90), Size = UDim2.new(0, 55, 0, 21) },
        { BackgroundColor3 = Color3.fromRGB(100, 100, 110), Size = UDim2.new(0, 45, 0, 15) }
    )
    wag.MouseButton1Click:Connect(function()
        for _, wah in ipairs(wa6:GetChildren()) do
            if wah:IsA("TextLabel") and wah ~= wa9 then
                wah:Destroy()
            end
        end
        wax = {}
        waa = 1
        wa9.Visible = true
    end)
    return wa5, wa6, wa9, wab, wag
end

local wa1 = w6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
if wa1 then wa1:Destroy() end

local w71 = Instance.new("ScreenGui")
w71.Name = "UniversalUtility"
w71.ResetOnSpawn = false
w71.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(w71); w71.Parent = w6
elseif gethui then
    w71.Parent = gethui()
else
    w71.Parent = w6
end

local w72 = Instance.new("Frame", w71)
w72.Name = "MainFrame"
w72.Size = UDim2.new(0, 0, 0, 0)
w72.Position = UDim2.new(0, 0, 0, 0)
w72.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
w72.BorderSizePixel = 0
w72.Active = true
w72.ClipsDescendants = true
w72.Visible = false

w65(w72, 16)
w24(w72, w39)

w61 = Instance.new("UIScale", w72)
w61.Scale = 1

local w73 = Instance.new("ImageLabel", w72)
w73.BackgroundTransparency = 1
w73.Position = UDim2.new(0, -15, 0, -15)
w73.Size = UDim2.new(1, 30, 1, 30)
w73.ZIndex = 0
w73.Image = "rbxassetid://6014261993"
w73.ImageColor3 = Color3.fromRGB(0, 0, 0)
w73.ImageTransparency = 0.5
w73.ScaleType = Enum.ScaleType.Slice
w73.SliceCenter = Rect.new(49, 49, 450, 450)

local w75 = Instance.new("Frame", w72)
w75.Size = UDim2.new(1, 0, 0, 46)
w75.Position = UDim2.new(0, 0, 0, 0)
w75.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
w75.BorderSizePixel = 0

w65(w75, 16)
w69(w75, Color3.fromRGB(38, 38, 46), Color3.fromRGB(30, 30, 37), 90)

do
    local wa1 = Instance.new("TextLabel", w75)
    wa1.Size = UDim2.new(1, -60, 1, 0)
    wa1.Position = UDim2.new(0, 14, 0, 0)
    wa1.BackgroundTransparency = 1
    wa1.Text = "⚡ Universal Utility"
    wa1.Font = Enum.Font.GothamBold
    wa1.TextSize = 22
    wa1.TextColor3 = Color3.fromRGB(255, 255, 255)
    wa1.TextXAlignment = Enum.TextXAlignment.Left
end

local w76 = Instance.new("ImageButton", w75)
w76.Size = UDim2.new(0, 28, 0, 28)
w76.Position = UDim2.new(1, -14, 0.5, 0)
w76.AnchorPoint = Vector2.new(1, 0.5)
w76.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
w76.BorderSizePixel = 0
w76.Image = "rbxassetid://3926305904"
w76.ImageRectOffset = Vector2.new(284, 4)
w76.ImageRectSize = Vector2.new(24, 24)
w76.ImageColor3 = Color3.fromRGB(255, 255, 255)
w65(w76, 8)

local w77 = Instance.new("Frame", w72)
w77.Size = UDim2.new(0, 178, 1, -52)
w77.Position = UDim2.new(0, 5, 0, 52)
w77.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
w77.BorderSizePixel = 0
w65(w77, 10)
w69(w77, Color3.fromRGB(30, 30, 35), Color3.fromRGB(25, 25, 30), 90)

local w82 = Instance.new("Frame", w72)
w82.Size = UDim2.new(1, -193, 1, -57)
w82.Position = UDim2.new(0, 188, 0, 52)
w82.BackgroundTransparency = 1
w82.BorderSizePixel = 0
w82.ClipsDescendants = true

local w83 = Instance.new("ImageButton", w71)
w83.Name = "ReopenButton"
w83.Size = UDim2.new(0, 0, 0, 0)
w83.Position = UDim2.new(0, 0, 0, 0)
w83.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
w83.BorderSizePixel = 0
w83.Visible = false
w83.ZIndex = 10
w83.Active = true
w83.ImageTransparency = 1
w65(w83, 100)
w69(w83, Color3.fromRGB(100, 150, 255), Color3.fromRGB(80, 130, 235), 45)

local w84 = Instance.new("TextLabel", w83)
w84.Size = UDim2.new(1, 0, 1, 0)
w84.BackgroundTransparency = 1
w84.Text = "⚡"
w84.Font = Enum.Font.GothamBold
w84.TextSize = 24
w84.TextColor3 = Color3.fromRGB(255, 255, 255)
w84.TextTransparency = 1

local w85, w86, w87, w88, w89 = false, nil, nil, nil, false
local w30, w27 = nil, false
local function w28()
    if w30 then
        w30:Disconnect()
        w30 = nil
    end
    w27 = false
end

local function w29()
    if w27 then return end
    w27 = true
    if w30 then w30:Disconnect() end
    w30 = w5.RenderStepped:Connect(function(wa1)
        if w83.Visible then
            w83.Rotation = (w83.Rotation + (wa1 * 180)) % 360
        else
            w28()
        end
    end)
end

w83.InputBegan:Connect(function(wa1)
    if wa1.UserInputType == Enum.UserInputType.MouseButton1 or wa1.UserInputType == Enum.UserInputType.Touch then
        w85 = true
        w89 = false
        w86 = wa1.Position
        w87 = w83.Position
        w29()
        if w88 then w88:Disconnect() end
        w88 = w3.InputChanged:Connect(function(wa2)
            if (wa2.UserInputType == Enum.UserInputType.MouseMovement or wa2.UserInputType == Enum.UserInputType.Touch) and w85 then
                local wa3 = wa2.Position - w86
                if math.abs(wa3.X) > 5 or math.abs(wa3.Y) > 5 then w89 = true end
                w83.Position = UDim2.new(0, w87.X.Offset + wa3.X, 0, w87.Y.Offset + wa3.Y)
            end
        end)
        wa1.Changed:Connect(function()
            if wa1.UserInputState == Enum.UserInputState.End or wa1.UserInputState == Enum.UserInputState.Cancel then
                w85 = false
                if w88 then w88:Disconnect(); w88 = nil end
                local wa4, wa5, wa6, wa7 = math.floor(60 * w62), w3:GetMouseLocation(), w83.AbsolutePosition, w83.AbsoluteSize
                local wa8 = wa5.X >= wa6.X and wa5.X <= wa6.X + wa7.X
                    and wa5.Y >= wa6.Y and wa5.Y <= wa6.Y + wa7.Y
                if wa8 then
                    w48(w83, w44.Medium, { Size = UDim2.new(0, math.floor(wa4 * 1.17), 0, math.floor(wa4 * 1.17)) })
                    w29()
                else
                    w48(w83, w44.Medium, { Size = UDim2.new(0, wa4, 0, wa4), Rotation = 0 })
                end
                task.wait(0.1)
                if w89 then
                    w21.SavedReopenPosition = { X = w83.Position.X.Offset, Y = w83.Position.Y.Offset }
                    w33()
                end
                w89 = false
            end
        end)
    end
end)
w83.MouseEnter:Connect(function()
    if not w85 then
        local wa1 = math.floor(60 * w62)
        w48(w83, w44.Medium, { Size = UDim2.new(0, math.floor(wa1 * 1.17), 0, math.floor(wa1 * 1.17)) })
        w29()
    end
end)
w83.MouseLeave:Connect(function()
    if not w85 then
        w28()
        local wa1 = math.floor(60 * w62)
        w48(w83, w44.Medium, { Size = UDim2.new(0, wa1, 0, wa1), Rotation = 0 })
    end
end)
w83.MouseButton1Down:Connect(function()
    if not w85 then
        local wa1 = math.floor(60 * w62)
        w48(w83, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, math.floor(wa1 * 0.92), 0, math.floor(wa1 * 0.92)) })
    end
end)
w83.MouseButton1Up:Connect(function()
    if not w85 then
        local wa1 = math.floor(60 * w62)
        w48(w83, w44.Fast, { Size = UDim2.new(0, wa1, 0, wa1) })
    end
end)

local w90, w92, w93 = {}, {}, {}
_G.UU.UI = {
    ScreenGui = w71,
    MainFrame = w72,
    ContentFrame = w82,
    SideNav = w77,
    CloseButton = w76,
    ReopenButton = w83,
    TabButtons = w90,
    TabContents = w92,
    TweenPresets = w44,
    ActiveTweens = w45,
    PlayTween = w48,
    CancelTween = w46,
    UIScale = w61,
    AllFrames = w93,
}

local function w94(wa1, wa2, wa3)
    local wa4 = Instance.new("TextButton", w77)
    wa4.Name = wa1.."Tab"
    wa4.Size = UDim2.new(1, -10, 0, 50)
    wa4.Position = UDim2.new(0.5, 0, 0, 8 + ((wa3 - 1) * 55) + 27)
    wa4.AnchorPoint = Vector2.new(0.5, 0.5)
    wa4.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    wa4.BorderSizePixel = 0
    wa4.Text = ""
    wa4.AutoButtonColor = false
    w65(wa4, 8)
    local wa5 = Instance.new("TextLabel", wa4)
    wa5.Size = UDim2.new(0, 30, 1, 0)
    wa5.Position = UDim2.new(0, 10, 0, 0)
    wa5.BackgroundTransparency = 1
    wa5.Text = wa2
    wa5.Font = Enum.Font.GothamBold
    wa5.TextSize = 18
    wa5.TextColor3 = Color3.fromRGB(180, 180, 180)
    wa5.TextXAlignment = Enum.TextXAlignment.Left
    local wa6 = Instance.new("TextLabel", wa4)
    wa6.Size = UDim2.new(1, -50, 1, 0)
    wa6.Position = UDim2.new(0, 45, 0, 0)
    wa6.BackgroundTransparency = 1
    wa6.Text = wa1
    wa6.Font = Enum.Font.GothamBold
    wa6.TextSize = 13
    wa6.TextColor3 = Color3.fromRGB(180, 180, 180)
    wa6.TextXAlignment = Enum.TextXAlignment.Left
    w90[wa1] = { Button = wa4, Icon = wa5, Label = wa6 }
    w93["Tab_"..wa1] = wa4
    wa4.MouseEnter:Connect(function()
        local wa7 = w21.CurrentTab == wa1
        if wa7 then
            w48(wa4, w44.Fast, { Size = UDim2.new(1, -4, 0, 54) })
            w48(wa5, w44.Fast, { TextSize = 21 })
            w48(wa6, w44.Fast, { TextSize = 14 })
        else
            w48(wa4, w44.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52), Size = UDim2.new(1, -4, 0, 54) })
            w48(wa5, w44.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 21 })
            w48(wa6, w44.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 14 })
        end
    end)
    wa4.MouseLeave:Connect(function()
        local wa7 = w21.CurrentTab == wa1
        if wa7 then
            w48(wa4, w44.Fast, { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(1, -10, 0, 50) })
            w48(wa5, w44.Fast, { TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18 })
            w48(wa6, w44.Fast, { TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13 })
        else
            w48(wa4, w44.Fast, { BackgroundColor3 = Color3.fromRGB(35, 35, 42), Size = UDim2.new(1, -10, 0, 50) })
            w48(wa5, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 18 })
            w48(wa6, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13 })
        end
    end)
    wa4.MouseButton1Down:Connect(function()
        local wa7 = w21.CurrentTab == wa1
        if wa7 then
            w48(wa4, w44.Fast, { Size = UDim2.new(1, -14, 0, 46) })
        else
            w48(wa4, w44.Fast, { BackgroundColor3 = Color3.fromRGB(55, 55, 62), Size = UDim2.new(1, -14, 0, 46) })
        end
        w48(wa5, w44.Fast, { TextSize = 16 })
    end)
    wa4.MouseButton1Up:Connect(function()
        local wa7 = w21.CurrentTab == wa1
        if wa7 then
            w48(wa4, w44.Fast, { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(1, -4, 0, 54) })
        else
            w48(wa4, w44.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52), Size = UDim2.new(1, -4, 0, 54) })
        end
        w48(wa5, w44.Fast, { TextSize = 21 })
    end)
    return wa4
end

local function w95(wa1)
    local wa2 = Instance.new("ScrollingFrame", w82)
    wa2.Name = wa1.."Content"
    wa2.Size = UDim2.new(1, -10, 1, -10)
    wa2.Position = UDim2.new(0, 5, 0, 5)
    wa2.BackgroundTransparency = 1
    wa2.BorderSizePixel = 0
    wa2.ScrollBarThickness = 4
    wa2.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    wa2.ScrollBarImageTransparency = 0.5
    wa2.CanvasSize = UDim2.new(0, 0, 0, 0)
    wa2.Visible = false
    wa2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local wa3 = Instance.new("UIListLayout", wa2)
    wa3.SortOrder = Enum.SortOrder.LayoutOrder
    wa3.Padding = UDim.new(0, 10)
    w92[wa1] = wa2
    w93["Content_"..wa1] = wa2
    return wa2
end

local w96 = {
    { name = "Home", icon = "🏠", order = 1 },
    { name = "Anti-AFK", icon = "⚡", order = 2 },
    { name = "KeySpam", icon = "⌨️", order = 3 },
    { name = "Performance Status", icon = "📊", order = 4 },
    { name = "Auto Rejoin", icon = "🔄", order = 5 },
    { name = "Script Loader", icon = "💾", order = 6 },
    { name = "Settings", icon = "⚙️", order = 7 },
}
for wa1, wa2 in ipairs(w96) do
    w94(wa2.name, wa2.icon, wa2.order)
    w95(wa2.name)
end

local w97, w99, wA = {}, {}, {}
local wB, wC, wD, wE = {}, {}, {}, {}

local w34
do
    local wa1 = {
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
    local wa2 = {
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
    local function wa3(wa4)
        if not wa4 then return "🌐" end
        return wa2[wa4:upper()] or "🌐"
    end
    function w34(wa5)
        task.spawn(function()
            local wa6, wa7 = nil, game.JobId
            if wa7 and wa7 ~= "" then
                for wa8, wa9 in pairs(wa1) do
                    if wa7:lower():find(wa8, 1, true) then
                        wa6 = wa9
                        break
                    end
                end
            end
            if not wa6 then
                local waa, wab = pcall(function()
                    local wac, wad = pcall(function()
                        return w:JSONDecode(game:HttpGet("https://ipinfo.io/json", true))
                    end)
                    if wac and wad and wad.country then
                        local wae = wa3(wad.country)
                        local waf = wae .. " " .. wad.country
                        if wad.region and wad.region ~= "" then
                            waf = waf .. " - " .. wad.region
                        end
                        if wad.city and wad.city ~= "" then
                            waf = waf .. ", " .. wad.city
                        end
                        return waf
                    end
                    return nil
                end)
                if waa and wab then
                    wa6 = wab
                end
            end
            if not wa6 then
                wa6 = "🌐 Unknown"
            end
            if wa5 and wa5.Parent then
                wa5.Text = "Server Region: " .. wa6
            end
        end)
    end
end

do
    local wa1 = w92["Home"]
    local wa2 = w51(wa1, 200, 1)
    w93["Home_Card1"] = wa2
    local wa3 = Instance.new("ImageLabel", wa2)
    wa3.Size = UDim2.new(0, 120, 0, 140)
    wa3.Position = UDim2.new(0, 10, 0, 10)
    wa3.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    wa3.BorderSizePixel = 0
    wa3.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    w65(wa3, 10)
    Instance.new("UIStroke", wa3).Color = Color3.fromRGB(100, 150, 255)
    local wa4 = Instance.new("TextLabel", wa2)
    wa4.Size = UDim2.new(1, -145, 0, 22)
    wa4.Position = UDim2.new(0, 140, 0, 10)
    wa4.BackgroundTransparency = 1
    wa4.Text = w12
    wa4.Font = Enum.Font.GothamBold
    wa4.TextSize = 28
    wa4.TextColor3 = Color3.fromRGB(255, 255, 255)
    wa4.TextXAlignment = Enum.TextXAlignment.Left
    local wa5 = Instance.new("TextLabel", wa2)
    wa5.Size = UDim2.new(1, -145, 0, 16)
    wa5.Position = UDim2.new(0, 140, 0, 33)
    wa5.BackgroundTransparency = 1
    wa5.Text = "User ID: "..w13
    wa5.Font = Enum.Font.Gotham
    wa5.TextSize = 12
    wa5.TextColor3 = Color3.fromRGB(150, 150, 150)
    wa5.TextXAlignment = Enum.TextXAlignment.Left
    local wa6 = Instance.new("TextLabel", wa2)
    wa6.Size = UDim2.new(1, -145, 0, 18); wa6.Position = UDim2.new(0, 140, 0, 55)
    wa6.BackgroundTransparency = 1; wa6.Text = "FPS: 60"
    wa6.Font = Enum.Font.Gotham; wa6.TextSize = 16
    wa6.TextColor3 = Color3.fromRGB(100, 200, 255); wa6.TextXAlignment = Enum.TextXAlignment.Left
    local wa7 = Instance.new("TextLabel", wa2)
    wa7.Size = UDim2.new(1, -145, 0, 18); wa7.Position = UDim2.new(0, 140, 0, 70)
    wa7.BackgroundTransparency = 1; wa7.Text = "Ping: 0 ms"
    wa7.Font = Enum.Font.Gotham; wa7.TextSize = 16
    wa7.TextColor3 = Color3.fromRGB(0, 255, 0); wa7.TextXAlignment = Enum.TextXAlignment.Left
    local wa8 = Instance.new("TextLabel", wa2)
    wa8.Size = UDim2.new(1, -145, 0, 18); wa8.Position = UDim2.new(0, 140, 0, 90)
    wa8.BackgroundTransparency = 1; wa8.Text = "Memory: 0 MB"
    wa8.Font = Enum.Font.Gotham; wa8.TextSize = 16
    wa8.TextColor3 = Color3.fromRGB(255, 180, 100); wa8.TextXAlignment = Enum.TextXAlignment.Left
    local wa9, waa = "Unknown", "N/A"
    pcall(function()
        if identifyexecutor then wa9, waa = identifyexecutor()
        elseif getexecutorname then wa9 = getexecutorname() end
    end)
    local wab = Instance.new("TextLabel", wa2)
    wab.Size = UDim2.new(1, -145, 0, 18); wab.Position = UDim2.new(0, 140, 0, 105)
    wab.BackgroundTransparency = 1; wab.Text = "Executor: "..wa9.." "..waa
    wab.Font = Enum.Font.Gotham; wab.TextSize = 14
    wab.TextColor3 = Color3.fromRGB(255, 100, 200); wab.TextXAlignment = Enum.TextXAlignment.Left
    local wac = Instance.new("TextLabel", wa2)
    wac.Size = UDim2.new(1, -145, 0, 18); wac.Position = UDim2.new(0, 140, 0, 125)
    wac.BackgroundTransparency = 1; wac.Text = "Device: "..w19()
    wac.Font = Enum.Font.Gotham; wac.TextSize = 14
    wac.TextColor3 = Color3.fromRGB(180, 255, 150); wac.TextXAlignment = Enum.TextXAlignment.Left
    local wad, wae = w59(), Instance.new("TextLabel", wa2)
    wae.Size = UDim2.new(1, -145, 0, 16); wae.Position = UDim2.new(0, 140, 0, 140)
    wae.BackgroundTransparency = 1; wae.Text = string.format("Resolution: %dx%d", wad.X, wad.Y)
    wae.Font = Enum.Font.Gotham; wae.TextSize = 12
    wae.TextColor3 = Color3.fromRGB(120, 120, 120); wae.TextXAlignment = Enum.TextXAlignment.Left
    local waf = w51(wa1, 178, 2)
    w93["Home_Card2"] = waf
    local wag = Instance.new("ImageLabel", waf)
    wag.Size = UDim2.new(0, 120, 0, 125); wag.Position = UDim2.new(0, 10, 0, 10)
    wag.BackgroundColor3 = Color3.fromRGB(45, 45, 52); wag.BorderSizePixel = 0
    wag.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    w65(wag, 10); Instance.new("UIStroke", wag).Color = Color3.fromRGB(100, 150, 255)
    local wah = Instance.new("TextLabel", waf)
    wah.Size = UDim2.new(1, -145, 0, 24); wah.Position = UDim2.new(0, 140, 0, 5)
    wah.BackgroundTransparency = 1; wah.Text = "Loading game info..."
    wah.Font = Enum.Font.GothamBold; wah.TextSize = 24
    wah.TextColor3 = Color3.fromRGB(255, 255, 255); wah.TextXAlignment = Enum.TextXAlignment.Left
    wah.TextWrapped = true
    local wai = Instance.new("TextLabel", waf)
    wai.Size = UDim2.new(1, -145, 0, 16); wai.Position = UDim2.new(0, 140, 0, 30)
    wai.BackgroundTransparency = 1; wai.Text = "Place Id: "..game.PlaceId
    wai.Font = Enum.Font.Gotham; wai.TextSize = 16
    wai.TextColor3 = Color3.fromRGB(150, 180, 255); wai.TextXAlignment = Enum.TextXAlignment.Left
    local waj = Instance.new("TextLabel", waf)
    waj.Size = UDim2.new(1, -145, 0, 16); waj.Position = UDim2.new(0, 140, 0, 45)
    waj.BackgroundTransparency = 1; waj.Text = "Universe Id: "..game.GameId
    waj.Font = Enum.Font.Gotham; waj.TextSize = 16
    waj.TextColor3 = Color3.fromRGB(200, 160, 255); waj.TextXAlignment = Enum.TextXAlignment.Left
    local wak = Instance.new("TextLabel", waf)
    wak.Size = UDim2.new(1, -145, 0, 16); wak.Position = UDim2.new(0, 140, 0, 70)
    wak.BackgroundTransparency = 1
    wak.Text = "Server Players: "..#w1:GetPlayers().." / "..w1.MaxPlayers
    wak.Font = Enum.Font.Gotham; wak.TextSize = 16
    wak.TextColor3 = Color3.fromRGB(150, 255, 180); wak.TextXAlignment = Enum.TextXAlignment.Left
    local wal = Instance.new("TextLabel", waf)
    wal.Size = UDim2.new(1, -145, 0, 16); wal.Position = UDim2.new(0, 140, 0, 85)
    wal.BackgroundTransparency = 1; wal.Text = "Place Version: "..game.PlaceVersion
    wal.Font = Enum.Font.Gotham; wal.TextSize = 16
    wal.TextColor3 = Color3.fromRGB(255, 200, 100); wal.TextXAlignment = Enum.TextXAlignment.Left
    local wam = Instance.new("TextLabel", waf)
    wam.Size = UDim2.new(1, -145, 0, 16); wam.Position = UDim2.new(0, 140, 0, 100)
    wam.BackgroundTransparency = 1; wam.Text = "Server Region: Detecting..."
    wam.Font = Enum.Font.Gotham; wam.TextSize = 12
    wam.TextColor3 = Color3.fromRGB(130, 220, 255); wam.TextXAlignment = Enum.TextXAlignment.Left
    local wan = Instance.new("TextLabel", waf)
    wan.Size = UDim2.new(1, -145, 0, 14); wan.Position = UDim2.new(0, 140, 0, 120)
    wan.BackgroundTransparency = 1; wan.Text = "Job Id: "..(game.JobId ~= "" and game.JobId or "N/A")
    wan.Font = Enum.Font.Gotham; wan.TextSize = 12
    wan.TextColor3 = Color3.fromRGB(255, 180, 180); wan.TextXAlignment = Enum.TextXAlignment.Left
    wan.TextTruncate = Enum.TextTruncate.AtEnd
    w34(wam)
    table.insert(_G.UU.Connections, w1.PlayerAdded:Connect(function()
        wak.Text = "Server Players: "..#w1:GetPlayers().." / "..w1.MaxPlayers
    end))
    table.insert(_G.UU.Connections, w1.PlayerRemoving:Connect(function()
        wak.Text = "Server Players: "..(#w1:GetPlayers() - 1).." / "..w1.MaxPlayers
    end))
    _G.UU.UI.PlayerImage = wa3
    _G.UU.UI.GameName = wah
    _G.UU.UI.GameImage = wag
    _G.UU.UI.ResolutionLabel = wae
    _G.UU.UI.DeviceLabel = wac
    w97.FPSLabel = wa6
    w97.PingLabel = wa7
    w97.MemoryLabel = wa8
end

do
    local wa1 = w92["Anti-AFK"]
    local wa2 = w51(wa1, 450, 1)
    w93["AntiAFK_Card"] = wa2
    local wa3 = w54(wa2, "⚡ Anti-AFK System", 8)
    wa3.TextColor3 = Color3.fromRGB(100, 200, 255)
    w52(wa2, "Prevent disconnections by simulating player activity", 34)
    local wa4, _ = w55(wa2, "Auto Jump", 60)
    local wa5, _, _, wa6 = w58(wa4, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.JumpEnabled, nil)
    local wa7, _ = w55(wa2, "Auto Click", 102)
    local wa8, _, _, wa9 = w58(wa7, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.ClickEnabled, nil)
    w49(wa2, 150)
    local waa, _ = w55(wa2, "Mouse Position", 162)
    local wab, _, _, wac = w58(waa, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.MousePosEnabled, nil)
    local wad = Instance.new("TextLabel", wa2)
    wad.Size = UDim2.new(1, -20, 0, 16)
    wad.Position = UDim2.new(0, 10, 0, 198)
    wad.BackgroundTransparency = 1
    wad.Text = string.format("[Locked] F5 · %d, %d", math.floor(w21.MousePosSaved.X), math.floor(w21.MousePosSaved.Y))
    wad.Font = Enum.Font.Gotham
    wad.TextSize = 12
    wad.TextColor3 = Color3.fromRGB(150, 150, 150)
    wad.TextXAlignment = Enum.TextXAlignment.Left
    w49(wa2, 233)
    local _, wae, waf, wag, wah = w74(wa2, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 248), 10, "Jump Interval (seconds)")
    local _, wai, waj, wak, wal = w74(wa2, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 315), 3, "Click Interval (seconds)")
    local _, wam = w47(wa2, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 380), "Status: All Inactive")
    w99 = {
        JumpToggleBtn = wa5,
        JumpToggleState = wa6,
        ClickToggleBtn = wa8,
        ClickToggleState = wa9,
        MousePosToggleBtn = wab,
        MousePosToggleState = wac,
        MousePosLabel = wad,
        JumpDelaySlider = wae,
        JumpSliderFill = waf,
        JumpSliderButton = wag,
        JumpDelayBox = wah,
        ClickDelaySlider = wai,
        ClickSliderFill = waj,
        ClickSliderButton = wak,
        ClickDelayBox = wal,
        Status = wam,
    }
end

do
    local wa1 = w92["KeySpam"]
    local wa2 = w51(wa1, 330, 1)
    w93["KeySpam_Card"] = wa2
    local wa3 = w54(wa2, "⌨️ Key Spam Controller", 8)
    wa3.TextColor3 = Color3.fromRGB(255, 200, 100)
    w52(wa2, "Automatically spam any keyboard key at custom intervals", 34)
    w50(wa2, "Target Key", 60)
    local wa4 = Instance.new("TextBox", wa2)
    wa4.Size = UDim2.new(1, -20, 0, 40)
    wa4.Position = UDim2.new(0, 10, 0, 82)
    wa4.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    wa4.Text = w21.SpamKey
    wa4.PlaceholderText = "Enter key (A-Z, 0-9, F1-F12)"
    wa4.Font = Enum.Font.Gotham
    wa4.TextSize = 14
    wa4.TextColor3 = Color3.fromRGB(255, 255, 255)
    wa4.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    wa4.BorderSizePixel = 0
    wa4.ClearTextOnFocus = false
    w65(wa4, 8)
    Instance.new("UIStroke", wa4).Color = Color3.fromRGB(60, 60, 70)
    w49(wa2, 135)
    local _, wa5, wa6, wa7, wa8 = w74(wa2, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 150), 0.1, "Spam Interval (seconds)")
    local wa9, _ = w55(wa2, "Auto Spam", 215)
    local waa, _, _, wab = w58(wa9, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.AutoSpamEnabled, nil)
    local _, wac = w47(wa2, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 265), "Status: Inactive")
    wA = {
        SpamInput = wa4,
        SpamDelaySlider = wa5,
        SpamSliderFill = wa6,
        SpamSliderButton = wa7,
        SpamDelayBox = wa8,
        AutoSpamToggleBtn = waa,
        AutoSpamToggleState = wab,
        Status = wac,
    }
end

do
    local wa1 = w92["Performance Status"]
    local wa2 = w51(wa1, 660, 1)
    w93["Performance_Card"] = wa2
    local wa3 = w54(wa2, "📊 Performance Monitor", 8)
    wa3.TextColor3 = Color3.fromRGB(100, 255, 150)
    w52(wa2, "Track real-time performance metrics and unlock FPS limits", 34)
    local wa4, _ = w55(wa2, "FPS Unlock", 60)
    local wa5, _, _, wa6 = w58(wa4, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.FPSUnlockEnabled, nil)
    local wa7 = Instance.new("TextLabel", wa2)
    wa7.Size = UDim2.new(1, -20, 0, 20)
    wa7.Position = UDim2.new(0, 10, 0, 102)
    wa7.BackgroundTransparency = 1
    wa7.Text = "Current Limit: 60 FPS"
    wa7.Font = Enum.Font.Gotham
    wa7.TextSize = 13
    wa7.TextColor3 = Color3.fromRGB(180, 180, 180)
    wa7.TextXAlignment = Enum.TextXAlignment.Center
    local _, wa8, wa9, waa, wab = w74(wa2, UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 135), 60, "Target FPS Limit")
    w49(wa2, 200)
    w50(wa2, "Framerate Statistics", 210)
    local wac = Instance.new("Frame", wa2)
    wac.Size = UDim2.new(1, -20, 0, 50); wac.Position = UDim2.new(0, 10, 0, 235)
    wac.BackgroundColor3 = Color3.fromRGB(30, 30, 35); wac.BorderSizePixel = 0
    w65(wac, 8); Instance.new("UIStroke", wac).Color = Color3.fromRGB(50, 50, 60)
    local function wad(wae, waf, wag, wah)
        local wai = Instance.new("TextLabel", wae)
        wai.Size = UDim2.new(waf[3], 0, 1, 0); wai.Position = UDim2.new(waf[1], 0, 0, 0)
        wai.BackgroundTransparency = 1; wai.Text = wag
        wai.Font = Enum.Font.GothamBold; wai.TextSize = 13
        wai.TextColor3 = wah; wai.TextXAlignment = Enum.TextXAlignment.Center
        return wai
    end
    local waj = wad(wac, {0, 0, 0.33}, "Current: 60", Color3.fromRGB(100, 200, 255))
    local wak = wad(wac, {0.33, 0, 0.33}, "Average: 60", Color3.fromRGB(50, 220, 100))
    local wal = wad(wac, {0.66, 0, 0.34}, "Min: 60 | Max: 60", Color3.fromRGB(255, 200, 100))
    w49(wa2, 300); w50(wa2, "Network Latency Statistics", 310)
    local wam = Instance.new("Frame", wa2)
    wam.Size = UDim2.new(1, -20, 0, 50); wam.Position = UDim2.new(0, 10, 0, 335)
    wam.BackgroundColor3 = Color3.fromRGB(30, 30, 35); wam.BorderSizePixel = 0
    w65(wam, 8); Instance.new("UIStroke", wam).Color = Color3.fromRGB(50, 50, 60)
    local wan = wad(wam, {0, 0, 0.33}, "Current: 0ms", Color3.fromRGB(100, 200, 255))
    local wao = wad(wam, {0.33, 0, 0.33}, "Average: 0ms", Color3.fromRGB(50, 220, 100))
    local wap = wad(wam, {0.66, 0, 0.34}, "Min: 0ms | Max: 0ms", Color3.fromRGB(255, 200, 100))
    local waq = Instance.new("Frame", wa2)
    waq.Size = UDim2.new(1, -20, 0, 50); waq.Position = UDim2.new(0, 10, 0, 400)
    waq.BackgroundColor3 = Color3.fromRGB(30, 30, 35); waq.BorderSizePixel = 0
    w65(waq, 8); Instance.new("UIStroke", waq).Color = Color3.fromRGB(50, 50, 60)
    wad(waq, {0, 0, 0.5}, "Connection Quality", Color3.fromRGB(255, 255, 255))
    local war = wad(waq, {0.5, 0, 0.5}, "Excellent", Color3.fromRGB(50, 220, 100))
    w49(wa2, 460); w50(wa2, "Memory Usage Statistics", 470)
    local was = Instance.new("Frame", wa2)
    was.Size = UDim2.new(1, -20, 0, 50); was.Position = UDim2.new(0, 10, 0, 495)
    was.BackgroundColor3 = Color3.fromRGB(30, 30, 35); was.BorderSizePixel = 0
    w65(was, 8); Instance.new("UIStroke", was).Color = Color3.fromRGB(50, 50, 60)
    local wat = wad(was, {0, 0, 0.5}, "Current: 0 MB", Color3.fromRGB(255, 180, 100))
    local wau = wad(was, {0.5, 0, 0.5}, "Peak: 0 MB", Color3.fromRGB(255, 150, 50))
    local wav = Instance.new("TextLabel", wa2)
    wav.Size = UDim2.new(1, -20, 0, 60); wav.Position = UDim2.new(0, 10, 0, 555)
    wav.BackgroundColor3 = Color3.fromRGB(30, 30, 35); wav.BorderSizePixel = 0
    wav.Text = "Performance monitoring tracks your game's framerate, network latency, and memory usage in real-time.\n\nLowering FPS limits reduces memory usage."
    wav.Font = Enum.Font.Gotham; wav.TextSize = 12
    wav.TextColor3 = Color3.fromRGB(200, 180, 150); wav.TextWrapped = true
    wav.TextXAlignment = Enum.TextXAlignment.Left; wav.TextYAlignment = Enum.TextYAlignment.Top
    w65(wav, 8); Instance.new("UIStroke", wav).Color = Color3.fromRGB(50, 50, 60)
    local waw = Instance.new("UIPadding", wav)
    waw.PaddingLeft = UDim.new(0, 10); waw.PaddingRight = UDim.new(0, 10)
    waw.PaddingTop = UDim.new(0, 10); waw.PaddingBottom = UDim.new(0, 10)
    wB = {
        FPSToggleBtn = wa5,
        FPSToggleState = wa6,
        FPSUnlockStatus = wa7,
        FPSSlider = wa8,
        FPSFill = wa9,
        FPSButton = waa,
        FPSValueBox = wab,
        FPSStats = { Current = waj, Avg = wak, MinMax = wal },
        PingStats = { Current = wan, Avg = wao, MinMax = wap, Quality = war },
        MemoryStats = { Current = wat, Peak = wau },
    }
end

do
    local wa1 = w92["Auto Rejoin"]
    local wa2 = w51(wa1, 270, 1)
    w93["AutoRejoin_Card"] = wa2
    local wa3 = w54(wa2, "🔄 Auto Rejoin System", 8)
    wa3.TextColor3 = Color3.fromRGB(150, 200, 255)
    w52(wa2, "Automatically reconnect when disconnected from the server", 34)
    local wa4, _ = w55(wa2, "Auto Rejoin", 65)
    local wa5, _, _, wa6 = w58(wa4, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.AutoRejoinEnabled, nil)
    local _, wa7 = w47(wa2, UDim2.new(1, -20, 0, 105), UDim2.new(0, 10, 0, 120),
        "Status: Disabled\n\nWhen enabled, automatically rejoins the current server when disconnected.")
    wC = {
        AutoRejoinToggleBtn = wa5,
        AutoRejoinToggleState = wa6,
        Status = wa7,
    }
end

do
    local wa1 = w92["Script Loader"]
    local wa2 = w51(wa1, 660, 1)
    w93["ScriptLoader_Card"] = wa2
    local wa3 = w54(wa2, "💾 Script Executor", 8)
    wa3.TextColor3 = Color3.fromRGB(200, 150, 255)
    w52(wa2, "Execute custom Lua scripts with auto-save and auto-load capabilities", 34)
    local wa4 = Instance.new("Frame", wa2)
    wa4.Size = UDim2.new(1, -20, 0, 220)
    wa4.Position = UDim2.new(0, 10, 0, 60)
    wa4.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    wa4.BorderSizePixel = 0
    w65(wa4, 8)
    Instance.new("UIStroke", wa4).Color = Color3.fromRGB(60, 60, 70)
    local wa5 = Instance.new("ScrollingFrame", wa4)
    wa5.Size = UDim2.new(0, 40, 1, 0)
    wa5.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    wa5.BorderSizePixel = 0
    wa5.ScrollBarThickness = 0
    wa5.ScrollingEnabled = false
    wa5.CanvasSize = UDim2.new(0, 0, 0, 220)
    w65(wa5, 8)
    local wa6 = Instance.new("TextLabel", wa5)
    wa6.Size = UDim2.new(1, -5, 1, 0)
    wa6.BackgroundTransparency = 1
    wa6.Text = "1"
    wa6.Font = Enum.Font.Code
    wa6.TextSize = 12
    wa6.TextColor3 = Color3.fromRGB(120, 120, 120)
    wa6.TextXAlignment = Enum.TextXAlignment.Right
    wa6.TextYAlignment = Enum.TextYAlignment.Top
    local wa7 = Instance.new("Frame", wa4)
    wa7.Size = UDim2.new(0, 1, 1, 0)
    wa7.Position = UDim2.new(0, 40, 0, 0)
    wa7.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    wa7.BorderSizePixel = 0
    local wa8 = Instance.new("ScrollingFrame", wa4)
    wa8.Size = UDim2.new(1, -41, 1, 0)
    wa8.Position = UDim2.new(0, 41, 0, 0)
    wa8.BackgroundTransparency = 1
    wa8.BorderSizePixel = 0
    wa8.ScrollBarThickness = 4
    wa8.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    wa8.ScrollBarImageTransparency = 0.5
    wa8.CanvasSize = UDim2.new(0, 0, 0, 220)
    local wa9 = Instance.new("TextBox", wa8)
    wa9.Size = UDim2.new(1, -10, 1, 0)
    wa9.Position = UDim2.new(0, 5, 0, 0)
    wa9.BackgroundTransparency = 1
    wa9.Text = w21.SavedCode
    wa9.PlaceholderText = "-- Paste your Lua code here..."
    wa9.Font = Enum.Font.Code
    wa9.TextSize = 12
    wa9.TextColor3 = Color3.fromRGB(255, 255, 255)
    wa9.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    wa9.BorderSizePixel = 0
    wa9.TextWrapped = false
    wa9.TextXAlignment = Enum.TextXAlignment.Left
    wa9.TextYAlignment = Enum.TextYAlignment.Top
    wa9.MultiLine = true
    wa9.ClearTextOnFocus = false
    wa9.TextEditable = true
    local waa = Instance.new("TextButton", wa2)
    waa.Size = UDim2.new(0.5, -15, 0, 36)
    waa.Position = UDim2.new(0.25, 2.5, 0, 318)
    waa.AnchorPoint = Vector2.new(0.5, 0.5)
    waa.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    waa.Text = "▶ Execute"
    waa.Font = Enum.Font.GothamBold
    waa.TextSize = 14
    waa.TextColor3 = Color3.fromRGB(255, 255, 255)
    waa.BorderSizePixel = 0
    waa.AutoButtonColor = false
    w65(waa, 8)
    w25(waa,
        { BackgroundColor3 = Color3.fromRGB(100, 150, 255), Size = UDim2.new(0.5, -15, 0, 36) },
        { BackgroundColor3 = Color3.fromRGB(120, 170, 255), Size = UDim2.new(0.5, -8, 0, 40) },
        { BackgroundColor3 = Color3.fromRGB(80, 130, 225), Size = UDim2.new(0.5, -22, 0, 32) }
    )
    local wab, _ = w55(wa2, "Auto Load", 300)
    wab.Size = UDim2.new(0.5, -15, 0, 36); wab.Position = UDim2.new(0.5, 5, 0, 300)
    local wac, _, _, wad = w58(wab, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.AutoLoadEnabled, nil)
    w49(wa2, 348)
    w50(wa2, "Status", 360)
    local wae = Instance.new("Frame", wa2)
    wae.Size = UDim2.new(1, -20, 0, 36)
    wae.Position = UDim2.new(0, 10, 0, 382)
    wae.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    wae.BorderSizePixel = 0
    w65(wae, 8)
    Instance.new("UIStroke", wae).Color = Color3.fromRGB(50, 50, 60)
    local waf = Instance.new("TextLabel", wae)
    waf.Size = UDim2.new(1, -10, 1, 0)
    waf.Position = UDim2.new(0, 10, 0, 0)
    waf.BackgroundTransparency = 1
    waf.Text = "Ready"
    waf.Font = Enum.Font.GothamBold
    waf.TextSize = 13
    waf.TextColor3 = Color3.fromRGB(180, 180, 180)
    waf.TextXAlignment = Enum.TextXAlignment.Left
    waf.TextYAlignment = Enum.TextYAlignment.Center
    waf.TextTruncate = Enum.TextTruncate.AtEnd
    w49(wa2, 430)
    w50(wa2, "Output", 442)
    local _, wag, wah, wai, waj = w26(wa2,
        UDim2.new(1, -20, 0, 140),
        UDim2.new(0, 10, 0, 465),
        Color3.fromRGB(100, 150, 255)
    )
    waj.Position = UDim2.new(1, -35, 0, 450)
    waj.AnchorPoint = Vector2.new(0.5, 0.5)
    wah.Text = "No output yet."
    local wak = Instance.new("TextLabel", wa2)
    wak.Size = UDim2.new(1, -20, 0, 30); wak.Position = UDim2.new(0, 10, 0, 618)
    wak.BackgroundTransparency = 1
    wak.Text = "Code is auto-saved while typing. Enable Auto Load to execute on rejoin."
    wak.Font = Enum.Font.Gotham; wak.TextSize = 11
    wak.TextColor3 = Color3.fromRGB(100, 100, 110)
    wak.TextXAlignment = Enum.TextXAlignment.Center; wak.TextWrapped = true
    wD = {
        LoadStringBox = wa9,
        LineNumbers = wa6,
        LoadStringScrollFrame = wa8,
        LineNumbersScrollFrame = wa5,
        ExecuteButton = waa,
        AutoLoadToggleBtn = wac,
        AutoLoadToggleState = wad,
        Status = waf,
        OutputScroll = wag,
        OutputEmpty = wah,
        AddOutput = wai,
    }
end

do
    local wa1 = w92["Settings"]
    local wa2 = w51(wa1, 560, 1)
    w93["Settings_Card"] = wa2
    local wa3 = w54(wa2, "⚙️ UI Configuration", 8)
    wa3.TextColor3 = Color3.fromRGB(255, 180, 100)
    w52(wa2, "Customize interface preferences and keybinds", 34)
    w50(wa2, "Toggle Keybind", 60)
    local wa4 = w22[w21.Keybind] or w21.Keybind.Name
    local wa5 = Instance.new("TextButton", wa2)
    wa5.Size = UDim2.new(1, -20, 0, 40)
    wa5.Position = UDim2.new(0.5, 0, 0, 102)
    wa5.AnchorPoint = Vector2.new(0.5, 0.5)
    wa5.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    wa5.Text = "Current Key: "..wa4
    wa5.Font = Enum.Font.GothamBold
    wa5.TextSize = 13
    wa5.TextColor3 = Color3.fromRGB(255, 255, 255)
    wa5.BorderSizePixel = 0
    wa5.AutoButtonColor = false
    w65(wa5, 8)
    w25(wa5,
        { BackgroundColor3 = Color3.fromRGB(45, 45, 52), Size = UDim2.new(1, -20, 0, 40) },
        { BackgroundColor3 = Color3.fromRGB(55, 55, 65), Size = UDim2.new(1, -15, 0, 44) },
        { BackgroundColor3 = Color3.fromRGB(70, 70, 80), Size = UDim2.new(1, -25, 0, 36) }
    )
    w49(wa2, 135)
    local wa6, _ = w55(wa2, "Auto Hide UI", 150)
    local wa7, _, _, wa8 = w58(wa6, UDim2.new(0, 56, 0, 28), UDim2.new(1, -28, 0.5, 0), w21.AutoHideEnabled, nil)
    local _, wa9 = w47(wa2, UDim2.new(1, -20, 0, 60), UDim2.new(0, 10, 0, 200), "")
    wa9.TextColor3 = Color3.fromRGB(150, 150, 150)
    w49(wa2, 278)
    local waa = w50(wa2, "Activity Log", 290)
    waa.TextColor3 = Color3.fromRGB(200, 200, 200)
    local wab, wac, wad, wae, waf = w26(wa2,
        UDim2.new(1, -20, 0, 200),
        UDim2.new(0, 10, 0, 312),
        Color3.fromRGB(255, 180, 100)
    )
    waf.Position = UDim2.new(1, -35, 0, 297.5)
    waf.AnchorPoint = Vector2.new(0.5, 0.5)
    wad.Text = "No activity yet."
    wE = {
        KeybindButton = wa5,
        AutoHideToggleBtn = wa7,
        AutoHideToggleState = wa8,
        Status = wa9,
        AddSettingsLog = wae,
    }
    _G.UU.AddActivityLog = wae
    for _, wag in ipairs(w15) do
        _G.UU.AddActivityLog(wag.msg, wag.col)
    end
    w15 = {}
end

local wF = typeof(setfpscap) == "function"
if wF then
    local wa1 = pcall(setfpscap, 60)
    if not wa1 then wF = false end
end

local wG, wH, wI = {}, {}, 60
local wJ, wK = tick(), 0
local wL = 0
for wa1 = 1, 60 do
    table.insert(wG, 60)
    table.insert(wH, 0)
end

local function wM()
    if not w99.Status then return end
    local wa1, wa2
    if w21.JumpEnabled and w21.ClickEnabled then
        wa1, wa2 = "Status: Jump & Click Active", Color3.fromRGB(50, 220, 100)
    elseif w21.JumpEnabled then
        wa1, wa2 = "Status: Jump Active", Color3.fromRGB(100, 200, 255)
    elseif w21.ClickEnabled then
        wa1, wa2 = "Status: Click Active", Color3.fromRGB(255, 200, 100)
    else
        wa1, wa2 = "Status: All Inactive", Color3.fromRGB(180, 180, 180)
    end
    w48(w99.Status, w44.Fast, { TextColor3 = wa2 })
    w99.Status.Text = wa1
end

local function wN()
    w56("Jump")
    _G.UU.Threads.Jump = task.spawn(function()
        while w21.JumpEnabled do
            task.wait(math.max(w21.JumpDelay or 1, 0.05))
            if w21.JumpEnabled and w11.Character then
                local wa1 = w11.Character:FindFirstChildOfClass("Humanoid")
                if wa1 then wa1:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
        _G.UU.Threads.Jump = nil
    end)
end

local function wO()
    w56("Click")
    _G.UU.Threads.Click = task.spawn(function()
        while w21.ClickEnabled do
            task.wait(math.max(w21.ClickDelay or 0.1, 0.05))
            if w21.ClickEnabled then
                local wa1, wa2
                if w21.MousePosEnabled then
                    local wa3 = w3:GetMouseLocation()
                    wa1, wa2 = wa3.X, wa3.Y
                else
                    wa1, wa2 = w21.MousePosSaved.X, w21.MousePosSaved.Y
                end
                w4:SendMouseButtonEvent(wa1, wa2, 0, true, game, 0)
                task.wait(0.05)
                w4:SendMouseButtonEvent(wa1, wa2, 0, false, game, 0)
            end
        end
        _G.UU.Threads.Click = nil
    end)
end

local function wP()
    w56("Spam")
    local wa1 = w21.SpamKey:upper()
    local wa2 = w23[wa1]
    if not wa2 then return end
    _G.UU.Threads.Spam = task.spawn(function()
        while w21.AutoSpamEnabled do
            task.wait(math.max(w21.SpamDelay or 0.1, 0.05))
            if w21.AutoSpamEnabled then
                w4:SendKeyEvent(true, wa2, false, game)
                task.wait(0.05)
                w4:SendKeyEvent(false, wa2, false, game)
            end
        end
        _G.UU.Threads.Spam = nil
    end)
end

local wb, w38 = false, nil
local function w40()
    if w38 then
        pcall(function() w38:Disconnect() end)
        w38 = nil
    end
end

local function wQ()
    w40()
    if not w21.AutoRejoinEnabled then return end
    w56("RejoinWait")
    _G.UU.Threads.RejoinWait = task.spawn(function()
        local wa1 = w6:FindFirstChild("RobloxPromptGui")
        if not wa1 then
            local wa2, wa3 = pcall(function() return w6:WaitForChild("RobloxPromptGui", 10) end)
            if not wa2 or not wa3 then
                if wC.Status then
                    wC.Status.Text = "Status: Enabled (waiting for prompt GUI...)\n\nAutomatically rejoins when disconnected."
                end
                return
            end
            wa1 = wa3
        end
        local wa4 = wa1:FindFirstChild("promptOverlay")
        if not wa4 then
            local wa5, wa6 = pcall(function() return wa1:WaitForChild("promptOverlay", 10) end)
            if not wa5 or not wa6 then
                if wC.Status then
                    wC.Status.Text = "Status: Enabled (prompt overlay unavailable)\n\nAutomatically rejoins when disconnected."
                end
                return
            end
            wa4 = wa6
        end
        w38 = wa4.ChildAdded:Connect(function(wa7)
            if wa7.Name == "ErrorPrompt" and w21.AutoRejoinEnabled and not wb then
                wb = true
                w16("Disconnected detected → rejoining...", Color3.fromRGB(255, 200, 100))
                _G.UU.Threads.Rejoin = task.spawn(function()
                    while w21.AutoRejoinEnabled and wb do
                        w7:Teleport(game.PlaceId, w11)
                        task.wait(2)
                    end
                    _G.UU.Threads.Rejoin = nil
                end)
            end
        end)
        table.insert(_G.UU.Connections, w38)
    end)
end

local function wR(wa1)
    if not wa1 or wa1 == "" then return false, "Empty script", "No code to execute." end
    local wa2, wa3 = pcall(function()
        local wa4, wa5 = loadstring(wa1)
        if not wa4 then error(wa5, 0) end
        wa4()
    end)
    if wa2 then return true, "Executed successfully!", nil end
    return false, "Execution failed", tostring(wa3)
end

local wS = { jump = false, click = false, spam = false, fps = false }
local function w42(wa1, wa2, wa3, wa4, wa5, wa6, wa7, wa8, wa9, waa)
    local function wab(wac)
        w21[wa1] = wa2 + (wac * wa3)
        if wa8 == "%d" then w21[wa1] = math.floor(w21[wa1]) end
        w18(wa4(), wa5(), w21[wa1], wa6, wa7, wa8)
        if waa then waa() end
    end
    local function wad(wac)
        w21[wa1] = wa2 + (wac * wa3)
        if wa8 == "%d" then w21[wa1] = math.floor(w21[wa1]) end
        w91(wa4(), wa5(), w21[wa1], wa6, wa7, wa8)
        if waa then waa() end
        w17(string.format(wa9 .. " → " .. wa8, w21[wa1]))
    end
    return wab, wad
end

local wT, w78 = w42(
    "JumpDelay", 5, 25,
    function() return w99.JumpSliderFill end, function() return w99.JumpDelayBox end,
    5, 30, "%.1f", "Jump Interval")
local wU, w79 = w42(
    "ClickDelay", 1, 9,
    function() return w99.ClickSliderFill end, function() return w99.ClickDelayBox end,
    1, 10, "%.1f", "Click Interval")
local wV, w80 = w42(
    "SpamDelay", 0.05, 4.95,
    function() return wA.SpamSliderFill end, function() return wA.SpamDelayBox end,
    0.05, 5, "%.2f", "Spam Interval")
local wW, w81 = w42(
    "TargetFPS", 15, 345,
    function() return wB.FPSFill end, function() return wB.FPSValueBox end,
    15, 360, "%d", "Target FPS",
    function()
        if w21.FPSUnlockEnabled and wF then
            pcall(setfpscap, w21.TargetFPS)
            wB.FPSUnlockStatus.Text = "Your target: "..w21.TargetFPS.." FPS"
        end
    end)
w99.JumpSliderButton.MouseButton1Down:Connect(function() wS.jump = true; w98(w99.JumpSliderButton, 0.9) end)
w99.ClickSliderButton.MouseButton1Down:Connect(function() wS.click = true; w98(w99.ClickSliderButton, 0.9) end)
wA.SpamSliderButton.MouseButton1Down:Connect(function() wS.spam = true; w98(wA.SpamSliderButton, 0.9) end)
wB.FPSButton.MouseButton1Down:Connect(function() wS.fps = true; w98(wB.FPSButton, 0.9) end)
table.insert(_G.UU.Connections, w3.InputEnded:Connect(function(wa1)
    if wa1.UserInputType == Enum.UserInputType.MouseButton1 then
        if wS.jump then w78((w21.JumpDelay - 5) / 25) end
        if wS.click then w79((w21.ClickDelay - 1) / 9) end
        if wS.spam then w80((w21.SpamDelay - 0.05) / 4.95) end
        if wS.fps then w81((w21.TargetFPS - 15) / 345) end
        wS.jump = false; wS.click = false; wS.spam = false; wS.fps = false
    end
end))
table.insert(_G.UU.Connections, w3.InputChanged:Connect(function(wa1)
    if wa1.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local wa2 = w3:GetMouseLocation().X
    if wS.jump and w99.JumpDelaySlider then
        wT(math.clamp((wa2 - w99.JumpDelaySlider.AbsolutePosition.X) / w99.JumpDelaySlider.AbsoluteSize.X, 0, 1))
    elseif wS.click and w99.ClickDelaySlider then
        wU(math.clamp((wa2 - w99.ClickDelaySlider.AbsolutePosition.X) / w99.ClickDelaySlider.AbsoluteSize.X, 0, 1))
    elseif wS.spam and wA.SpamDelaySlider then
        wV(math.clamp((wa2 - wA.SpamDelaySlider.AbsolutePosition.X) / wA.SpamDelaySlider.AbsoluteSize.X, 0, 1))
    elseif wS.fps and wB.FPSSlider then
        wW(math.clamp((wa2 - wB.FPSSlider.AbsolutePosition.X) / wB.FPSSlider.AbsoluteSize.X, 0, 1))
    end
end))
w99.JumpDelayBox.FocusLost:Connect(function()
    w78((math.clamp(tonumber(w99.JumpDelayBox.Text) or w21.JumpDelay, 5, 30) - 5) / 25)
end)
w99.ClickDelayBox.FocusLost:Connect(function()
    w79((math.clamp(tonumber(w99.ClickDelayBox.Text) or w21.ClickDelay, 1, 10) - 1) / 9)
end)
wA.SpamDelayBox.FocusLost:Connect(function()
    w80((math.clamp(tonumber(wA.SpamDelayBox.Text) or w21.SpamDelay, 0.05, 5) - 0.05) / 4.95)
end)
wB.FPSValueBox.FocusLost:Connect(function()
    w81((math.clamp(tonumber(wB.FPSValueBox.Text) or w21.TargetFPS, 15, 360) - 15) / 345)
end)
wA.SpamInput.FocusLost:Connect(function()
    local wa1 = w21.SpamKey
    w21.SpamKey = wA.SpamInput.Text:upper()
    if w21.SpamKey ~= wa1 then
        w17("Spam Key → " .. w21.SpamKey)
    end
end)
w99.JumpToggleBtn.MouseButton1Click:Connect(function()
    if not w53("Jump", 0.3) then return end
    w21.JumpEnabled = not w21.JumpEnabled
    w70(w99.JumpToggleState, w21.JumpEnabled)
    if w21.JumpEnabled then task.wait(0.05); wN() else w56("Jump") end
    wM()
    w17("Auto Jump → " .. (w21.JumpEnabled and "Enabled" or "Disabled"))
end)
w99.ClickToggleBtn.MouseButton1Click:Connect(function()
    if not w53("Click", 0.3) then return end
    w21.ClickEnabled = not w21.ClickEnabled
    w70(w99.ClickToggleState, w21.ClickEnabled)
    if w21.ClickEnabled then task.wait(0.05); wO() else w56("Click") end
    wM()
    w17("Auto Click → " .. (w21.ClickEnabled and "Enabled" or "Disabled"))
end)
wA.AutoSpamToggleBtn.MouseButton1Click:Connect(function()
    if not w53("Spam", 0.3) then return end
    w21.AutoSpamEnabled = not w21.AutoSpamEnabled
    if w21.AutoSpamEnabled then
        local wa1 = wA.SpamInput.Text:upper()
        local wa2 = w23[wa1]
        if not wa2 then
            w21.AutoSpamEnabled = false
            w70(wA.AutoSpamToggleState, false)
            wA.Status.Text = "Status: Invalid key"
            w48(wA.Status, w44.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            w16("Key Spam → Invalid key '" .. wa1 .. "'", Color3.fromRGB(220, 80, 80))
            w33()
            return
        end
        if wa2 == Enum.KeyCode.P or wa2 == w21.Keybind or wa2 == Enum.KeyCode.F5 then
            w21.AutoSpamEnabled = false
            w70(wA.AutoSpamToggleState, false)
            wA.Status.Text = "Status: Key reserved"
            w48(wA.Status, w44.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            w16("Key Spam → Key '" .. wa1 .. "' is reserved", Color3.fromRGB(220, 80, 80))
            w33()
            return
        end
        w21.SpamKey = wa1
        w70(wA.AutoSpamToggleState, true)
        wA.Status.Text = "Status: Spamming "..wa1
        w48(wA.Status, w44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        task.wait(0.05); wP()
    else
        w70(wA.AutoSpamToggleState, false)
        wA.Status.Text = "Status: Inactive"
        w48(wA.Status, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        w56("Spam")
    end
    w17("Key Spam → " .. (w21.AutoSpamEnabled and ("Enabled (" .. w21.SpamKey .. ")") or "Disabled"))
end)
wB.FPSToggleBtn.MouseButton1Click:Connect(function()
    if not w53("FPS", 0.3) then return end
    if not wF then
        wB.FPSUnlockStatus.Text = "FPS Unlock not supported"
        w48(wB.FPSUnlockStatus, w44.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
        w16("FPS Unlock → Not supported by executor", Color3.fromRGB(220, 80, 80))
        return
    end
    w21.FPSUnlockEnabled = not w21.FPSUnlockEnabled
    w70(wB.FPSToggleState, w21.FPSUnlockEnabled)
    if w21.FPSUnlockEnabled then
        pcall(setfpscap, w21.TargetFPS)
        wB.FPSUnlockStatus.Text = "Your target: "..w21.TargetFPS.." FPS"
        w48(wB.FPSUnlockStatus, w44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
    else
        pcall(setfpscap, 60)
        wB.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
        w48(wB.FPSUnlockStatus, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    w17("FPS Unlock → " .. (w21.FPSUnlockEnabled and ("Enabled (" .. w21.TargetFPS .. " FPS)") or "Disabled"))
end)
wC.AutoRejoinToggleBtn.MouseButton1Click:Connect(function()
    if not w53("Rejoin", 0.3) then return end
    w21.AutoRejoinEnabled = not w21.AutoRejoinEnabled
    w70(wC.AutoRejoinToggleState, w21.AutoRejoinEnabled)
    if w21.AutoRejoinEnabled then
        wC.Status.Text = "Status: Enabled\n\nAutomatically rejoins when disconnected."
        w48(wC.Status, w44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        wQ()
    else
        wb = false; w56("Rejoin")
        w40()
        wC.Status.Text = "Status: Disabled\n\nWhen enabled, automatically rejoins the current server when disconnected."
        w48(wC.Status, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    w17("Auto Rejoin → " .. (w21.AutoRejoinEnabled and "Enabled" or "Disabled"))
end)
wD.ExecuteButton.MouseButton1Click:Connect(function()
    if not w53("Execute", 0.5) then return end
    local wa1, wa2 = wD.LoadStringBox.Text, 0
    for _ in (wa1.."\n"):gmatch("[^\n]*\n") do wa2 = wa2 + 1 end
    wD.Status.Text = "Executing..."
    wD.Status.TextColor3 = Color3.fromRGB(255, 200, 100)
    w48(wD.ExecuteButton, w44.Medium, { BackgroundColor3 = Color3.fromRGB(255, 200, 100) })
    local wa3, _, wa4 = wR(wa1)
    if wa3 then
        wD.AddOutput("Script executed successfully.", Color3.fromRGB(80, 220, 120))
        w16(string.format("Script executed ✓ (%d lines)", wa2), Color3.fromRGB(80, 220, 120))
        w48(wD.ExecuteButton, w44.Medium, { BackgroundColor3 = Color3.fromRGB(50, 180, 80) })
    else
        if wa4 then
            wD.AddOutput(wa4, Color3.fromRGB(255, 100, 100))
            w16("Script error: " .. tostring(wa4):sub(1, 80), Color3.fromRGB(255, 100, 100))
        end
        w48(wD.ExecuteButton, w44.Medium, { BackgroundColor3 = Color3.fromRGB(180, 50, 50) })
    end
    task.wait(0.5)
    wD.Status.Text = "Ready"
    wD.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    w48(wD.ExecuteButton, w44.Medium, { BackgroundColor3 = Color3.fromRGB(100, 150, 255) })
end)
wD.AutoLoadToggleBtn.MouseButton1Click:Connect(function()
    if not w53("AutoLoad", 0.3) then return end
    w21.AutoLoadEnabled = not w21.AutoLoadEnabled
    w70(wD.AutoLoadToggleState, w21.AutoLoadEnabled)
    if w21.AutoLoadEnabled then
        if w21.SavedCode and w21.SavedCode ~= "" then
            wD.AddOutput("Auto-load enabled — will execute saved code on rejoin.", Color3.fromRGB(80, 220, 120))
            w16("Auto Load → Enabled (code ready)", Color3.fromRGB(80, 220, 120))
        else
            wD.AddOutput("Auto-load enabled — but no code is saved yet.", Color3.fromRGB(255, 200, 100))
            w16("Auto Load → Enabled (no code saved yet)", Color3.fromRGB(255, 200, 100))
        end
    else
        wD.AddOutput("Auto-load disabled.", Color3.fromRGB(160, 160, 160))
        w16("Auto Load → Disabled", Color3.fromRGB(160, 160, 160))
    end
    local wa1 = w33()
    if not wa1 then
        w16("Auto Load change → Save failed ✗", Color3.fromRGB(220, 80, 80))
    end
end)

local w37 = false
wD.LoadStringBox:GetPropertyChangedSignal("Text"):Connect(function()
    w21.SavedCode = wD.LoadStringBox.Text
    if not w37 then
        w37 = true
        task.defer(function()
            w37 = false
            w20(wD.LoadStringBox, wD.LineNumbers, wD.LoadStringScrollFrame, wD.LineNumbersScrollFrame)
        end)
    end
    if _G.UU.CodeSaveJob then pcall(task.cancel, _G.UU.CodeSaveJob) end
    _G.UU.CodeSaveJob = task.delay(0.75, function()
        _G.UU.CodeSaveJob = nil
        wD.Status.Text = "Saving..."
        wD.Status.TextColor3 = Color3.fromRGB(100, 200, 255)
        local wa2 = w33()
        if wa2 then
            wD.Status.Text = "Saved"
            wD.Status.TextColor3 = Color3.fromRGB(80, 220, 120)
        else
            wD.Status.Text = "Save failed"
            wD.Status.TextColor3 = Color3.fromRGB(220, 80, 80)
        end
        task.delay(1.5, function()
            if wD.Status.Text == "Saved" or wD.Status.Text == "Save failed" then
                wD.Status.Text = "Ready"
                wD.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end)
    end)
end)
wD.LoadStringScrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    wD.LineNumbersScrollFrame.CanvasPosition = Vector2.new(0, wD.LoadStringScrollFrame.CanvasPosition.Y)
end)
wE.KeybindButton.MouseButton1Click:Connect(function()
    if not w53("Keybind", 0.5) or w21.IsChangingKeybind then return end
    w21.IsChangingKeybind = true
    wE.KeybindButton.Text = "Press any key..."
    w16("Keybind: waiting for key press...", Color3.fromRGB(255, 200, 100))
    wE.KeybindButton.Active = false
    local wa1
    local wa2 = task.delay(5, function()
        _G.UU.Threads.KeybindTimeout = nil
        if wa1 then wa1:Disconnect() end
        w21.IsChangingKeybind = false
        wE.KeybindButton.Active = true
        wE.KeybindButton.Text = "Current Key: "..(w22[w21.Keybind] or w21.Keybind.Name)
        w16("Keybind: input timed out — no change.", Color3.fromRGB(255, 100, 100))
    end)
    _G.UU.Threads.KeybindTimeout = wa2
    wa1 = w3.InputBegan:Connect(function(wa3, wa4)
        if wa3.UserInputType == Enum.UserInputType.Keyboard and not wa4 then
            if _G.UU.Threads.KeybindTimeout then
                pcall(task.cancel, _G.UU.Threads.KeybindTimeout)
                _G.UU.Threads.KeybindTimeout = nil
            end
            if wa3.KeyCode == Enum.KeyCode.F5 then
                wE.KeybindButton.Text = "Current Key: "..(w22[w21.Keybind] or w21.Keybind.Name)
                wE.KeybindButton.Active = true
                w21.IsChangingKeybind = false
                wa1:Disconnect()
                w16("Keybind: F5 is reserved", Color3.fromRGB(255, 100, 100))
                return
            end
            w21.Keybind = wa3.KeyCode
            local wa5 = w22[wa3.KeyCode] or wa3.KeyCode.Name
            wE.KeybindButton.Text = "Current Key: "..wa5
            w17("Keybind → " .. wa5)
            wE.KeybindButton.Active = true
            wa1:Disconnect()
            task.delay(0.1, function() w21.IsChangingKeybind = false end)
        end
    end)
end)
wE.AutoHideToggleBtn.MouseButton1Click:Connect(function()
    if not w53("AutoHide", 0.3) then return end
    w21.AutoHideEnabled = not w21.AutoHideEnabled
    w70(wE.AutoHideToggleState, w21.AutoHideEnabled)
    if w21.AutoHideEnabled then
        wE.Status.Text = "Auto Hide enabled — UI starts hidden on next execution."
        w48(wE.Status, w44.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        w16("Auto Hide → Enabled (UI hidden on start)", Color3.fromRGB(50, 220, 100))
    else
        wE.Status.Text = "Auto Hide disabled — UI shows normally on start."
        w48(wE.Status, w44.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        w16("Auto Hide → Disabled (UI shows on start)", Color3.fromRGB(180, 180, 180))
    end
    local wa1 = w33()
    if wa1 then
        w16("Auto Hide change → Saved ✓", Color3.fromRGB(80, 220, 120))
    else
        w16("Auto Hide change → Save failed ✗", Color3.fromRGB(220, 80, 80))
    end
end)

local function w43(wa1)
    for wa2, wa3 in pairs(w90) do
        local wa4 = wa2 == wa1
        w46(wa3.Button); w46(wa3.Icon); w46(wa3.Label)
        wa3.Button.BackgroundColor3 = wa4 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(35, 35, 42)
        wa3.Button.Size = wa4 and UDim2.new(1, -4, 0, 54) or UDim2.new(1, -10, 0, 50)
        wa3.Icon.TextColor3 = wa4 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        wa3.Icon.TextSize = wa4 and 19 or 18
        wa3.Label.TextColor3 = wa4 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    end
end

local function wX(wa1)
    if w21.CurrentTab == wa1 and _G.UU.Debounces["Tab"] then return end
    if not w53("Tab", 0.15) then return end
    w21.CurrentTab = wa1
    w33()
    for wa2, wa3 in pairs(w92) do
        if wa2 == wa1 then
            wa3.Visible = true
            wa3.Position = UDim2.new(0, 15, 0, 0)
            w48(wa3, w44.Smooth, { Position = UDim2.new(0, 5, 0, 0) })
        else
            wa3.Visible = false
        end
    end
    w43(wa1)
end

for wa1, wa2 in ipairs(w96) do
    if w90[wa2.name] then
        local wa3 = wa2.name
        w90[wa3].Button.MouseButton1Click:Connect(function() wX(wa3) end)
    end
end

local wY, wZ = {}, false
local function wc()
    if wZ or #wY == 0 then return end
    wZ = true
    task.spawn(function()
        while #wY > 0 do
            local wa1 = table.remove(wY, 1)
            wa1()
            task.wait(0.05)
        end
        wZ = false
    end)
end

local function wd(wa1)
    table.insert(wY, wa1)
    wc()
end

local function we(wa1, wa2)
    local wa3, wa4 = w60.Width * wa2, w60.Height * wa2
    return math.max(0, (wa1.X - wa3) / 2), math.max(0, (wa1.Y - wa4) / 2)
end

local function wf(wa1, wa2)
    local wa3 = math.floor(60 * wa2)
    return wa3, math.max(0, (wa1.X - wa3) / 2), math.max(0, math.min(30, wa1.Y - wa3))
end

local function wg(wa1)
    if not w61 then return end
    w62 = wa1
    w48(w61, w44.Smooth, { Scale = wa1 })
    w84.TextSize = math.floor(24 * wa1)
end

local wh, wi = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0)
local function wj()
    if not w53("UI", 0.6) then return end
    wd(function()
        if w72.Visible then
            w21.SavedUIPosition = { X = w72.Position.X.Offset, Y = w72.Position.Y.Offset }
            w72.Size = UDim2.new(0, w60.Width, 0, w60.Height)
            local wa1, wa2 = w48(w61, wi, { Scale = 0 }), w2:Create(w72, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
            wa2:Play()
            wa1.Completed:Wait()
            w72.Visible = false; w72.BackgroundTransparency = 0; w61.Scale = 0; w33()
            local wa3, wa4 = w59(), math.floor(60 * w62)
            local wa5, wa6
            if w21.SavedReopenPosition then
                wa5 = w21.SavedReopenPosition.X
                wa6 = w21.SavedReopenPosition.Y
            else
                local _, wa7, wa8 = wf(wa3, w62)
                wa5, wa6 = wa7, wa8
            end
            w83.Size = UDim2.new(0, wa4, 0, wa4)
            w83.Position = UDim2.new(0, wa5, 0, wa6)
            w83.ImageTransparency = 1; w84.TextTransparency = 1
            w83.Rotation = -180; w83.Visible = true
            local wa9 = w2:Create(w83, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, wa4, 0, wa4),
                Position = UDim2.new(0, wa5, 0, wa6),
                ImageTransparency = 0, Rotation = 0,
            })
            local waa = w2:Create(w84, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
            wa9:Play(); task.delay(0.15, function() waa:Play() end); wa9.Completed:Wait()
        else
            w28()
            w21.SavedReopenPosition = { X = w83.Position.X.Offset, Y = w83.Position.Y.Offset }
            local wab = w2:Create(w83, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0, w83.Position.X.Offset, 0, w83.Position.Y.Offset),
                ImageTransparency = 1, Rotation = 90,
            })
            local wac = w2:Create(w84, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 })
            wac:Play(); wab:Play(); wab.Completed:Wait()
            w83.Visible = false; w83.Rotation = 0; w83.ImageTransparency = 0; w84.TextTransparency = 0; w33()
            local wad, wae
            if w21.SavedUIPosition then
                wad = w21.SavedUIPosition.X; wae = w21.SavedUIPosition.Y
            else
                wad, wae = we(w59(), w62)
            end
            w72.Visible = true
            w72.Size = UDim2.new(0, w60.Width, 0, w60.Height)
            w72.Position = UDim2.new(0, wad, 0, wae + 18)
            w72.BackgroundTransparency = 1
            w61.Scale = 0
            local waf = w2:Create(w72, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, wad, 0, wae),
                BackgroundTransparency = 0,
            })
            local wag = w48(w61, wh, { Scale = w62 })
            waf:Play()
            wag.Completed:Wait()
            w72.BackgroundTransparency = 0
        end
    end)
end

w76.MouseButton1Click:Connect(wj)
w76.MouseEnter:Connect(function() w48(w76, w44.Fast, { BackgroundColor3 = Color3.fromRGB(240, 70, 70), Size = UDim2.new(0, 32, 0, 32), Rotation = 90 }) end)
w76.MouseLeave:Connect(function() w48(w76, w44.Fast, { BackgroundColor3 = Color3.fromRGB(220, 50, 50), Size = UDim2.new(0, 28, 0, 28), Rotation = 0 }) end)
w76.MouseButton1Down:Connect(function() w48(w76, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 24, 0, 24) }) end)
w76.MouseButton1Up:Connect(function() w48(w76, w44.Fast, { Size = UDim2.new(0, 28, 0, 28) }) end)
w83.MouseButton1Click:Connect(function() if not w89 then wj() end end)
table.insert(_G.UU.Connections, w3.InputBegan:Connect(function(wa1, wa2)
    if not wa2 and wa1.KeyCode == w21.Keybind and not w21.IsChangingKeybind then
        wj()
    end
end))

local wk, w64 = Vector2.new(0, 0), nil
local function w66()
    if w64 then w64:Disconnect(); w64 = nil end
    if w21.MousePosEnabled then
        w64 = w5.RenderStepped:Connect(function()
            local wa1 = w3:GetMouseLocation()
            w21.MousePosSaved.X = wa1.X
            w21.MousePosSaved.Y = wa1.Y
        end)
    end
end

table.insert(_G.UU.Connections, w3.InputBegan:Connect(function(wa1, wa2)
    if not wa2 and wa1.KeyCode == Enum.KeyCode.F5 then
        w21.MousePosEnabled = not w21.MousePosEnabled
        w70(w99.MousePosToggleState, w21.MousePosEnabled)
        w66()
        w17("Mouse Position → " .. (w21.MousePosEnabled and "Tracking" or "Locked"))
    end
end))
w99.MousePosToggleBtn.MouseButton1Click:Connect(function()
    w21.MousePosEnabled = not w21.MousePosEnabled
    w70(w99.MousePosToggleState, w21.MousePosEnabled)
    w66()
    w17("Mouse Position → " .. (w21.MousePosEnabled and "Tracking" or "Locked"))
end)
_G.UU.Threads.MousePosLabel = task.spawn(function()
    while true do
        task.wait(0.25)
        if w99.MousePosLabel and w99.MousePosLabel.Parent then
            local wa1 = w21.MousePosEnabled and "Tracking" or "Locked"
            w99.MousePosLabel.Text = string.format("[%s] F5 · %d, %d", wa1, math.floor(w21.MousePosSaved.X), math.floor(w21.MousePosSaved.Y))
            w99.MousePosLabel.TextColor3 = w21.MousePosEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(150, 150, 150)
        end
    end
end)

local w67 = false
local function w68()
    if w67 then return end
    w67 = true
    task.delay(0.1, function()
        w67 = false
        local wa1 = w59()
        if math.abs(wa1.X - wk.X) < 2 and math.abs(wa1.Y - wk.Y) < 2 then return end
        wk = wa1
        local wa2 = w63(wa1)
        if _G.UU.UI.ResolutionLabel then _G.UU.UI.ResolutionLabel.Text = string.format("Resolution: %dx%d", wa1.X, wa1.Y) end
        if _G.UU.UI.DeviceLabel then _G.UU.UI.DeviceLabel.Text = "Device: "..w19() end
        wg(wa2)
        w21.SavedUIPosition = nil
        w21.SavedReopenPosition = nil
        local wa3, wa4 = we(wa1, wa2)
        w72.Position = UDim2.new(0, wa3, 0, wa4)
        local wa5 = math.floor(60 * w62)
        wa3 = math.max(0, (wa1.X - wa5) / 2)
        wa4 = math.max(0, math.min(30, wa1.Y - wa5))
        w83.Size = UDim2.new(0, wa5, 0, wa5)
        w83.Position = UDim2.new(0, wa3, 0, wa4)
        w33()
    end)
end

if workspace.CurrentCamera then
    table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(w68))
end

table.insert(_G.UU.Connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(w68))
    end
end))
table.insert(_G.UU.Connections, w5.RenderStepped:Connect(function()
    wK = wK + 1
    local wa1 = tick()
    if wa1 - wJ >= 1 then
        wI = math.floor(wK / (wa1 - wJ))
        wK = 0; wJ = wa1
        if w97.FPSLabel then w97.FPSLabel.Text = "FPS: "..wI end
        table.remove(wG, 1); table.insert(wG, wI)
        local wa2, wa3, wa4 = math.huge, 0, 0
        for _, wa5 in ipairs(wG) do
            wa2 = math.min(wa2, wa5); wa3 = math.max(wa3, wa5); wa4 = wa4 + wa5
        end
        local wa6 = math.floor(wa4 / #wG)
        if wB.FPSStats then
            wB.FPSStats.Current.Text = "Current: "..wI
            wB.FPSStats.Avg.Text = "Average: "..wa6
            wB.FPSStats.MinMax.Text = string.format("Min: %d | Max: %d", wa2, wa3)
        end
        local wa7 = w10:GetTotalMemoryUsageMb()
        wL = math.max(wL, wa7)
        if w97.MemoryLabel then w97.MemoryLabel.Text = string.format("Memory: %.1f MB", wa7) end
        if wB.MemoryStats then
            wB.MemoryStats.Current.Text = string.format("Current: %.1f MB", wa7)
            wB.MemoryStats.Peak.Text = string.format("Peak: %.1f MB", wL)
        end
    end
    if tick() - (_G.UU.LastPingTime or 0) >= 2 then
        _G.UU.LastPingTime = tick()
        local wa8 = math.floor(w11:GetNetworkPing() * 1000)
        if w97.PingLabel then
            w97.PingLabel.Text = "Ping: "..wa8.." ms"
            w97.PingLabel.TextColor3 = wa8 < 100 and Color3.fromRGB(0, 255, 0) or wa8 < 200 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        table.remove(wH, 1); table.insert(wH, wa8)
        local wa9, waa, wab = math.huge, 0, 0
        for _, wac in ipairs(wH) do
            wa9 = math.min(wa9, wac); waa = math.max(waa, wac); wab = wab + wac
        end
        local wad = math.floor(wab / #wH)
        if wB.PingStats then
            wB.PingStats.Current.Text = "Current: "..wa8.."ms"
            wB.PingStats.Avg.Text = "Average: "..wad.."ms"
            wB.PingStats.MinMax.Text = string.format("Min: %dms | Max: %dms", wa9, waa)
            local wae, waf
            if wa8 < 50 then wae, waf = "Excellent", Color3.fromRGB(50, 220, 100)
            elseif wa8 < 100 then wae, waf = "Good", Color3.fromRGB(100, 200, 255)
            elseif wa8 < 200 then wae, waf = "Fair", Color3.fromRGB(255, 200, 100)
            elseif wa8 < 300 then wae, waf = "Poor", Color3.fromRGB(255, 150, 50)
            else wae, waf = "Very Poor", Color3.fromRGB(220, 50, 50)
            end
            wB.PingStats.Quality.Text = wae
            wB.PingStats.Quality.TextColor3 = waf
        end
    end
end))

local wl = w41()

if wl then
    if wE.KeybindButton then wE.KeybindButton.Text = "Current Key: "..(w22[w21.Keybind] or w21.Keybind.Name) end
    if wA.SpamInput then wA.SpamInput.Text = w21.SpamKey end
    if wD.LoadStringBox then wD.LoadStringBox.Text = w21.SavedCode end
    wT((w21.JumpDelay - 5) / 25)
    wU((w21.ClickDelay - 1) / 9)
    wV((w21.SpamDelay - 0.05) / 4.95)
    wW((w21.TargetFPS - 15) / 345)
    w70(wD.AutoLoadToggleState, w21.AutoLoadEnabled)
    w70(wE.AutoHideToggleState, w21.AutoHideEnabled)
    if w21.AutoHideEnabled then
        wE.Status.Text = "Auto Hide enabled — UI starts hidden on next execution."
        wE.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
    else
        wE.Status.Text = "Auto Hide disabled — UI shows normally on start."
        wE.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
    if w21.AutoRejoinEnabled then
        w70(wC.AutoRejoinToggleState, true)
        wC.Status.Text = "Status: Enabled\n\nAutomatically rejoins when disconnected."
        wC.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        wQ()
    else
        w70(wC.AutoRejoinToggleState, false)
    end
    if w21.FPSUnlockEnabled and wF then
        w70(wB.FPSToggleState, true)
        wB.FPSUnlockStatus.TextColor3 = Color3.fromRGB(50, 220, 100)
        wB.FPSUnlockStatus.Text = "Current Limit: "..w21.TargetFPS.." FPS (Custom)"
        pcall(setfpscap, w21.TargetFPS)
    else
        w70(wB.FPSToggleState, false)
        if wF then pcall(setfpscap, 60) end
    end
    w70(w99.JumpToggleState, w21.JumpEnabled)
    if w21.JumpEnabled then task.wait(0.1); wN() end
    w70(w99.ClickToggleState, w21.ClickEnabled)
    w70(w99.MousePosToggleState, w21.MousePosEnabled)
    if w21.ClickEnabled then task.wait(0.1); wO() end
    if w21.MousePosEnabled then w66() end
    if w21.AutoSpamEnabled and w23[w21.SpamKey] then
        w70(wA.AutoSpamToggleState, true)
        wA.Status.Text = "Status: Spamming "..w21.SpamKey
        wA.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        task.wait(0.1); wP()
    else
        w21.AutoSpamEnabled = false
        w70(wA.AutoSpamToggleState, false)
    end
    wM()
    task.defer(function()
        w16("Config loaded for "..w12.." (Id: "..w13..")", Color3.fromRGB(100, 200, 255))
    end)
else
    wT(0.2); wU(0.22); wV(0.01); wW(0.13)
    w70(w99.JumpToggleState, false)
    w70(w99.ClickToggleState, false)
    w70(wA.AutoSpamToggleState, false)
    w70(w99.MousePosToggleState, false)
    w70(wB.FPSToggleState, false)
    w70(wC.AutoRejoinToggleState, false)
    w70(wD.AutoLoadToggleState, false)
    w70(wE.AutoHideToggleState, false)
    wB.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
    wE.Status.Text = "Auto Hide disabled — UI shows normally on start."
    wE.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    wM()
    task.defer(function()
        w16("Fresh start — no saved config found.", Color3.fromRGB(255, 200, 100))
        w16("Using defaults. Keybind: G | Auto Hide: Off", Color3.fromRGB(150, 150, 150))
    end)
end

task.spawn(function()
    pcall(function()
        if _G.UU.UI.PlayerImage then
            _G.UU.UI.PlayerImage.Image = "rbxthumb://type=AvatarHeadShot&id="..w13.."&w=420&h=420"
        end
        if _G.UU.UI.GameName and _G.UU.UI.GameImage then
            local wa1 = w8:GetProductInfo(game.PlaceId)
            _G.UU.UI.GameName.Text = wa1.Name
            if wa1.IconImageAssetId and wa1.IconImageAssetId ~= 0 then
                _G.UU.UI.GameImage.Image = "rbxthumb://type=Asset&id="..wa1.IconImageAssetId.."&w=420&h=420"
            end
        end
    end)
end)

w20(wD.LoadStringBox, wD.LineNumbers, wD.LoadStringScrollFrame, wD.LineNumbersScrollFrame)

w71.Destroying:Connect(function()
    w33()
    w28()
    for wa1, wa2 in pairs(_G.UU.Threads) do
        if wa2 and typeof(wa2) == "thread" and coroutine.status(wa2) ~= "dead" then
            pcall(task.cancel, wa2)
        end
        _G.UU.Threads[wa1] = nil
    end
    if w38 then pcall(function() w38:Disconnect() end); w38 = nil end
end)
for wa1, wa2 in pairs(w92) do wa2.Visible = false end

do
    local wa1 = w59()
    if wa1.X < 100 or wa1.Y < 100 then
        repeat task.wait() until workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X > 100
    end

    task.wait(0.1)

    local wa2 = not w21.AutoHideEnabled
    wa1 = w59()
    wk = wa1
    w62 = w63(wa1)

    local wa3, wa4
    if w21.SavedUIPosition and w21.SavedUIPosition.X and w21.SavedUIPosition.Y then
        wa3 = w21.SavedUIPosition.X
        wa4 = w21.SavedUIPosition.Y
    else
        wa3, wa4 = we(wa1, w62)
    end

    local wa5, wa6, wa7
    if w21.SavedReopenPosition and w21.SavedReopenPosition.X and w21.SavedReopenPosition.Y then
        wa5 = math.floor(60 * w62)
        wa6 = w21.SavedReopenPosition.X
        wa7 = w21.SavedReopenPosition.Y
    else
        wa5, wa6, wa7 = wf(wa1, w62)
    end

    local wa8 = w21.CurrentTab or "Home"
    for wa9, waa in pairs(w92) do
        waa.Visible = (wa9 == wa8)
    end

    w43(wa8)
    w21.CurrentTab = wa8
    w33()

    if wa2 then
        w72.Visible = true
        w72.Size = UDim2.new(0, w60.Width, 0, w60.Height)
        w72.Position = UDim2.new(0, wa3, 0, wa4 + 24)
        w72.BackgroundTransparency = 1
        w61.Scale = 0
        w83.Visible = false
        local wab = w2:Create(w72, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, wa3, 0, wa4),
            BackgroundTransparency = 0,
        })
        local wac = w48(w61, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = w62 })
        wab:Play()
        wac.Completed:Wait()
        w72.BackgroundTransparency = 0
    else
        w72.Visible = false
        w83.Size = UDim2.new(0, 0, 0, 0)
        w83.Position = UDim2.new(0, wa6 + wa5 / 2, 0, wa7 + wa5 / 2)
        w83.ImageTransparency = 1
        w84.TextTransparency = 1
        w83.Rotation = -270
        w83.Visible = true
        local wad = w2:Create(w83, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, wa5, 0, wa5),
            Position = UDim2.new(0, wa6, 0, wa7),
            ImageTransparency = 0,
            Rotation = 0,
        })
        local wae = w2:Create(w84, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 })
        wad:Play()
        task.delay(0.2, function() wae:Play() end)
        wad.Completed:Wait()
    end
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
    if wl and w21.AutoLoadEnabled and w21.SavedCode and w21.SavedCode ~= "" then
        wD.Status.Text = "Executing..."
        wD.Status.TextColor3 = Color3.fromRGB(255, 200, 100)
        w16("Auto Load → executing saved script on start...", Color3.fromRGB(255, 200, 100))
        local wa1, _, wa2 = wR(w21.SavedCode)
        if wa1 then
            wD.AddOutput("Auto-load executed successfully.", Color3.fromRGB(80, 220, 120))
            w16("Auto Load → script executed ✓", Color3.fromRGB(80, 220, 120))
        else
            if wa2 then
                wD.AddOutput(wa2, Color3.fromRGB(255, 100, 100))
                w16("Auto Load error: " .. tostring(wa2):sub(1, 80), Color3.fromRGB(255, 100, 100))
            end
        end
        wD.Status.Text = "Ready"
        wD.Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)

return _G.UU
