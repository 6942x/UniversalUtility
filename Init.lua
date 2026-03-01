local v = game:GetService("HttpService")
local v1 = game:GetService("Players")
local v2 = game:GetService("TweenService")
local v3 = game:GetService("UserInputService")
local v4 = game:GetService("VirtualInputManager")
local v5 = game:GetService("RunService")
local v6 = game:GetService("CoreGui")
local v7 = game:GetService("TeleportService")
local v8 = game:GetService("MarketplaceService")
local v9 = game:GetService("TextService")

local v10 = v1.LocalPlayer
if not v10 then
    repeat
        v10 = v1.LocalPlayer
        task.wait()
    until v10
end

local v11 = v10.Name
local v12 = v10.UserId
if not v11 or v11 == "" then
    repeat
        v11 = v10.Name
        task.wait()
    until v11 and v11 ~= ""
end

_G.UU = _G.UU or {}

if _G.UU.Loaded then
    if _G.UU.Threads then
        for v13, v14 in pairs(_G.UU.Threads) do
            if v14 and typeof(v14) == "thread" and coroutine.status(v14) ~= "dead" then
                pcall(task.cancel, v14)
            end
            _G.UU.Threads[v13] = nil
        end
    end
    if _G.UU.Connections then
        for v15, v16 in pairs(_G.UU.Connections) do
            pcall(function() v16:Disconnect() end)
        end
        _G.UU.Connections = {}
    end
    if _G.UU.TeleportQueued then
        _G.UU.TeleportQueued = false
    end
    local v17 = v6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
    if v17 then v17:Destroy() end
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

local function v18()
    if v3.TouchEnabled and not v3.KeyboardEnabled and not v3.MouseEnabled then
        return "Mobile"
    elseif v3.GamepadEnabled and not v3.KeyboardEnabled then
        return "Console"
    elseif v3.KeyboardEnabled and v3.MouseEnabled then
        return "PC"
    end
    local v19 = v3:GetLastInputType()
    if v19 == Enum.UserInputType.Touch then
        return "Mobile"
    elseif v19 == Enum.UserInputType.Gamepad1 or v19 == Enum.UserInputType.Gamepad2 then
        return "Console"
    end
    return "PC"
end

local v20 = {
    Keybind = Enum.KeyCode.G,
    ClickType = "Current",
    JumpEnabled = false,
    ClickEnabled = false,
    AutoSpamEnabled = false,
    AutoLoadEnabled = false,
    IsChangingKeybind = false,
    FPSUnlockEnabled = false,
    AutoRejoinEnabled = false,
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
_G.UU.CFG = v20

local v21 = {}
local v22 = {}

for v23 = 65, 90 do
    local v24 = string.char(v23)
    v21[Enum.KeyCode[v24]] = v24
    v22[v24] = Enum.KeyCode[v24]
end

local v25 = { "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine" }
for v26 = 0, 9 do
    local v27 = v26 == 0 and "Zero" or v25[v26]
    v21[Enum.KeyCode[v27]] = tostring(v26)
    v22[tostring(v26)] = Enum.KeyCode[v27]
end

for v28 = 1, 12 do
    v21[Enum.KeyCode["F" .. v28]] = "F" .. v28
    v22["F" .. v28] = Enum.KeyCode["F" .. v28]
end

local v29 = {
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
for v30, v31 in pairs(v29) do
    v21[Enum.KeyCode[v30]] = v31
end

_G.UU.KCN = v21
_G.UU.KCM = v22

local function v32()
    return "UniversalUtilityConfig-" .. v12 .. ".json"
end

local function v33()
    if not writefile then return end
    local v34 = _G.UU.UI and _G.UU.UI.MainFrame
    local v35 = _G.UU.UI and _G.UU.UI.ReopenButton
    if v34 then
        v20.SavedUIPosition = {
            X = v34.Position.X.Offset,
            Y = v34.Position.Y.Offset,
        }
    end
    if v35 then
        v20.SavedReopenPosition = {
            X = v35.Position.X.Offset,
            Y = v35.Position.Y.Offset,
        }
    end
    writefile(v32(), v:JSONEncode({
        UserId = v12,
        Username = v11,
        Keybind = v20.Keybind.Name,
        ClickType = v20.ClickType,
        JumpEnabled = v20.JumpEnabled,
        ClickEnabled = v20.ClickEnabled,
        AutoRejoinEnabled = v20.AutoRejoinEnabled,
        FPSUnlockEnabled = v20.FPSUnlockEnabled,
        AutoSpamEnabled = v20.AutoSpamEnabled,
        AutoLoadEnabled = v20.AutoLoadEnabled,
        TargetFPS = v20.TargetFPS,
        JumpDelay = v20.JumpDelay,
        ClickDelay = v20.ClickDelay,
        SpamDelay = v20.SpamDelay,
        SpamKey = v20.SpamKey,
        SavedCode = v20.SavedCode,
        CurrentTab = v20.CurrentTab,
        UIPosition = v20.UIPosition,
        ReopenPosition = v20.ReopenPosition,
        SavedUIPosition = v20.SavedUIPosition,
        SavedReopenPosition = v20.SavedReopenPosition,
    }))
end
_G.UU.SaveCFG = v33

local function v36()
    if not (readfile and isfile and isfile(v32())) then return false end
    local v37, v38 = pcall(function() return v:JSONDecode(readfile(v32())) end)
    if not v37 or not v38 or v38.UserId ~= v12 then return false end
    v20.Keybind = Enum.KeyCode[v38.Keybind] or Enum.KeyCode.G
    v20.ClickType = v38.ClickType or "Current"
    v20.JumpEnabled = v38.JumpEnabled or false
    v20.ClickEnabled = v38.ClickEnabled or false
    v20.AutoRejoinEnabled = v38.AutoRejoinEnabled or false
    v20.FPSUnlockEnabled = v38.FPSUnlockEnabled or false
    v20.AutoSpamEnabled = v38.AutoSpamEnabled or false
    v20.AutoLoadEnabled = v38.AutoLoadEnabled or false
    v20.TargetFPS = v38.TargetFPS or 60
    v20.JumpDelay = v38.JumpDelay or 10.0
    v20.ClickDelay = v38.ClickDelay or 3.0
    v20.SpamDelay = v38.SpamDelay or 0.1
    v20.SpamKey = v38.SpamKey or "Q"
    v20.SavedCode = v38.SavedCode or ""
    v20.CurrentTab = v38.CurrentTab or "Home"
    v20.UIPosition = v38.UIPosition or { X = 0.5, Y = 0.5 }
    v20.ReopenPosition = v38.ReopenPosition or { X = 0.5, Y = 30 }
    v20.SavedUIPosition = v38.SavedUIPosition or nil
    v20.SavedReopenPosition = v38.SavedReopenPosition or nil
    return true
end

local v39 = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Back = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    BackIn = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    Elastic = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
}

local v40 = {}

local function v41(v42)
    if v40[v42] then
        v40[v42]:Cancel()
        v40[v42] = nil
    end
end

local function v43(v42, v44, v45)
    v41(v42)
    local v46 = v2:Create(v42, v44, v45)
    v40[v42] = v46
    v46:Play()
    v46.Completed:Connect(function(v47)
        if v47 == Enum.TweenStatus.Completed then
            v40[v42] = nil
        end
    end)
    return v46
end

local function v48(v49, v50)
    if _G.UU.Debounces[v49] then return false end
    _G.UU.Debounces[v49] = true
    task.delay(v50 or 0.3, function() _G.UU.Debounces[v49] = false end)
    return true
end

local function v51(v52)
    if _G.UU.Threads[v52] then
        local v53 = _G.UU.Threads[v52]
        _G.UU.Threads[v52] = nil
        if typeof(v53) == "thread" and coroutine.status(v53) ~= "dead" then
            pcall(task.cancel, v53)
        end
    end
end

local function v54()
    return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
end

local v55 = {
    Width = 650, Height = 500,
    SideNavWidth = 180, TopBarHeight = 40,
    FontTitle = 24, FontTab = 13, FontIcon = 24,
    TabButtonHeight = 55, TabButtonGap = 60,
}

local v56 = nil
local v57 = 1

local function v58(v59)
    local v60 = math.min(v59.X / 1920, v59.Y / 1080)
    v60 = math.clamp(v60, 0.75, 1.4)
    return v60
end

local function v61(v62, v63)
    local v64 = Instance.new("UICorner", v62)
    v64.CornerRadius = UDim.new(0, v63 or 8)
    return v64
end

local function v65(v62, v66, v67, v68)
    local v69 = Instance.new("UIGradient", v62)
    v69.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, v66),
        ColorSequenceKeypoint.new(1, v67),
    }
    v69.Rotation = v68 or 90
    return v69
end

local function v70(v62, v71, v72)
    local v73 = Instance.new("TextButton", v62)
    v73.Size = v71
    v73.AnchorPoint = Vector2.new(0.5, 0)
    v73.Position = UDim2.new(0.5, 0, 0, 0)
    v73.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    v73.Text = v72
    v73.Font = Enum.Font.GothamBold
    v73.TextSize = 13
    v73.TextColor3 = Color3.fromRGB(255, 255, 255)
    v73.BorderSizePixel = 0
    v73.AutoButtonColor = false
    v61(v73, 8)
    _G.UU.ButtonStates[v73] = { OriginalSize = v71, IsHovering = false, BaseColor = Color3.fromRGB(45, 45, 52) }
    v73.MouseEnter:Connect(function()
        _G.UU.ButtonStates[v73].IsHovering = true
        v2:Create(v73, v39.Fast, { Size = UDim2.new(v71.X.Scale, v71.X.Offset + 6, v71.Y.Scale, v71.Y.Offset + 4) }):Play()
    end)
    v73.MouseLeave:Connect(function()
        _G.UU.ButtonStates[v73].IsHovering = false
        v2:Create(v73, v39.Fast, { Size = v71, BackgroundColor3 = _G.UU.ButtonStates[v73].BaseColor }):Play()
    end)
    v73.MouseButton1Down:Connect(function()
        if _G.UU.ButtonStates[v73].IsHovering then
            v2:Create(v73, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(v71.X.Scale, v71.X.Offset - 4, v71.Y.Scale, v71.Y.Offset - 3)
            }):Play()
        end
    end)
    v73.MouseButton1Up:Connect(function()
        if _G.UU.ButtonStates[v73].IsHovering then
            v2:Create(v73, v39.Fast, { Size = UDim2.new(v71.X.Scale, v71.X.Offset + 6, v71.Y.Scale, v71.Y.Offset + 4) }):Play()
        else
            v2:Create(v73, v39.Fast, { Size = v71 }):Play()
        end
    end)
    return v73
end

local function v74(v62, v71, v75, v76, v77, v78)
    local v79 = Instance.new("Frame", v62)
    v79.Size = v71
    v79.BackgroundTransparency = 1

    local v80 = Instance.new("TextLabel", v79)
    v80.Size = UDim2.new(1, 0, 0, 18)
    v80.BackgroundTransparency = 1
    v80.Text = v78
    v80.Font = Enum.Font.Gotham
    v80.TextSize = 12
    v80.TextColor3 = Color3.fromRGB(180, 180, 180)
    v80.TextXAlignment = Enum.TextXAlignment.Left

    local v81 = Instance.new("Frame", v79)
    v81.Size = UDim2.new(1, -60, 0, 6)
    v81.Position = UDim2.new(0, 0, 0, 22)
    v81.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    v81.BorderSizePixel = 0
    v61(v81, 3)

    local v82 = Instance.new("Frame", v81)
    v82.Size = UDim2.new((v77 - v75) / (v76 - v75), 0, 1, 0)
    v82.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    v82.BorderSizePixel = 0
    v61(v82, 3)

    local v83 = Instance.new("TextButton", v81)
    v83.Size = UDim2.new(1, 0, 1, 0)
    v83.BackgroundTransparency = 1
    v83.Text = ""

    local v84 = Instance.new("TextBox", v79)
    v84.Size = UDim2.new(0, 50, 0, 24)
    v84.Position = UDim2.new(1, -50, 0, 16)
    v84.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    v84.Text = tostring(v77)
    v84.Font = Enum.Font.Gotham
    v84.TextScaled = true
    v84.TextColor3 = Color3.fromRGB(255, 255, 255)
    v84.ClearTextOnFocus = false
    v84.BorderSizePixel = 0
    v61(v84, 5)

    return v79, v81, v82, v83, v84
end

local function v85(v82, v84, v86, v75, v76, v87)
    local v88 = (v86 - v75) / (v76 - v75)
    v2:Create(v82, v39.Fast, { Size = UDim2.new(v88, 0, 1, 0) }):Play()
    v84.Text = string.format(v87, v86)
end

local function v89(v73, v90)
    v90 = v90 or 0.95
    local v91 = v73.Size
    v43(v73, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(v91.X.Scale * v90, v91.X.Offset * v90, v91.Y.Scale * v90, v91.Y.Offset * v90)
    })
    task.wait(0.1)
    v43(v73, v39.Back, { Size = v91 })
end

local function v92(v93, v94, v95, v96)
    local v97 = v93.Text
    local v98 = 1
    for v99 in v97:gmatch("\n") do v98 = v98 + 1 end
    local v100 = ""
    for v101 = 1, v98 do v100 = v100 .. v101 .. "\n" end
    v94.Text = v100
    local v102 = v9:GetTextSize(v93.Text, v93.TextSize, v93.Font, Vector2.new(v93.AbsoluteSize.X - 10, math.huge))
    local v103 = math.max(200, v102.Y + 20)
    v93.Size = UDim2.new(1, -10, 0, v103)
    v95.CanvasSize = UDim2.new(0, 0, 0, v103)
    v96.CanvasSize = UDim2.new(0, 0, 0, v103)
    v94.Size = UDim2.new(1, -5, 0, v103)
end

local function v104(v62, v105)
    local v106, v107, v108, v109 = false, nil, nil, nil
    v62.InputBegan:Connect(function(v110)
        if v110.UserInputType == Enum.UserInputType.MouseButton1 or v110.UserInputType == Enum.UserInputType.Touch then
            v106 = true
            v107 = v110.Position
            v108 = v62.Position
            if v109 then v109:Disconnect() end
            v109 = v3.InputChanged:Connect(function(v111)
                if (v111.UserInputType == Enum.UserInputType.MouseMovement or v111.UserInputType == Enum.UserInputType.Touch) and v106 then
                    local v112 = v111.Position - v107
                    v62.Position = UDim2.new(v108.X.Scale, v108.X.Offset + v112.X, v108.Y.Scale, v108.Y.Offset + v112.Y)
                end
            end)
            v110.Changed:Connect(function()
                if v110.UserInputState == Enum.UserInputState.End then
                    v106 = false
                    if v109 then v109:Disconnect() v109 = nil end
                    if v105 then v105() end
                end
            end)
        end
    end)
end

local function v113(v62, v71, v114, v72)
    local v115 = Instance.new("Frame", v62)
    v115.Size = v71
    v115.Position = v114
    v115.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    v115.BorderSizePixel = 0
    v61(v115, 8)
    Instance.new("UIStroke", v115).Color = Color3.fromRGB(50, 50, 60)
    local v116 = Instance.new("TextLabel", v115)
    v116.Size = UDim2.new(1, -10, 1, -10)
    v116.Position = UDim2.new(0, 5, 0, 5)
    v116.BackgroundTransparency = 1
    v116.Text = v72
    v116.Font = Enum.Font.GothamBold
    v116.TextSize = 14
    v116.TextColor3 = Color3.fromRGB(180, 180, 180)
    v116.TextXAlignment = Enum.TextXAlignment.Center
    v116.TextWrapped = true
    v116.TextYAlignment = Enum.TextYAlignment.Top
    return v115, v116
end

local function v117(v62, v118)
    local v119 = Instance.new("Frame", v62)
    v119.Size = UDim2.new(1, -20, 0, 1)
    v119.Position = UDim2.new(0, 10, 0, v118)
    v119.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    v119.BorderSizePixel = 0
    return v119
end

local function v120(v62, v72, v118, v121)
    local v122 = Instance.new("TextLabel", v62)
    v122.Size = UDim2.new(1, -20, 0, 20)
    v122.Position = UDim2.new(0, 10, 0, v118)
    v122.BackgroundTransparency = 1
    v122.Text = v72
    v122.Font = Enum.Font.GothamBold
    v122.TextSize = 13
    v122.TextColor3 = v121 or Color3.fromRGB(200, 200, 200)
    v122.TextXAlignment = Enum.TextXAlignment.Left
    return v122
end

local function v123(v62, v124, v125)
    local v126 = Instance.new("Frame", v62)
    v126.Size = UDim2.new(1, 0, 0, v124)
    v126.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    v126.BorderSizePixel = 0
    v126.LayoutOrder = v125 or 1
    v61(v126, 10)
    v65(v126, Color3.fromRGB(35, 35, 42), Color3.fromRGB(40, 40, 47), 90)
    return v126
end

local v127 = v6:FindFirstChild("UniversalUtility") or (gethui and gethui():FindFirstChild("UniversalUtility"))
if v127 then v127:Destroy() end

local v128 = Instance.new("ScreenGui")
v128.Name = "UniversalUtility"
v128.ResetOnSpawn = false
v128.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then
    syn.protect_gui(v128)
    v128.Parent = v6
elseif gethui then
    v128.Parent = gethui()
else
    v128.Parent = v6
end

local v129 = Instance.new("Frame", v128)
v129.Name = "MainFrame"
v129.Size = UDim2.new(0, 0, 0, 0)
v129.Position = UDim2.new(0.5, 0, 0.5, 0)
v129.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
v129.BorderSizePixel = 0
v129.Active = true
v129.ClipsDescendants = true
v129.Visible = false
v61(v129, 16)

v104(v129, v33)

v56 = Instance.new("UIScale", v129)
v56.Scale = 1

local v130 = Instance.new("ImageLabel", v129)
v130.BackgroundTransparency = 1
v130.Position = UDim2.new(0, -15, 0, -15)
v130.Size = UDim2.new(1, 30, 1, 30)
v130.ZIndex = 0
v130.Image = "rbxassetid://6014261993"
v130.ImageColor3 = Color3.fromRGB(0, 0, 0)
v130.ImageTransparency = 0.5
v130.ScaleType = Enum.ScaleType.Slice
v130.SliceCenter = Rect.new(49, 49, 450, 450)

local v131 = Instance.new("Frame", v129)
v131.Size = UDim2.new(1, 0, 0, 40)
v131.Position = UDim2.new(0, 0, 0, 5)
v131.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
v131.BorderSizePixel = 0
v61(v131, 16)
v65(v131, Color3.fromRGB(35, 35, 42), Color3.fromRGB(30, 30, 37), 90)

local v132 = Instance.new("TextLabel", v131)
v132.Size = UDim2.new(1, -80, 1, 0)
v132.Position = UDim2.new(0, 15, 0, 0)
v132.BackgroundTransparency = 1
v132.Text = "⚡ Universal Utility"
v132.Font = Enum.Font.GothamBold
v132.TextSize = 24
v132.TextColor3 = Color3.fromRGB(255, 255, 255)
v132.TextXAlignment = Enum.TextXAlignment.Left

local v133 = Instance.new("ImageButton", v131)
v133.Size = UDim2.new(0, 30, 0, 30)
v133.Position = UDim2.new(1, -12.5, 0.5, 0)
v133.AnchorPoint = Vector2.new(1, 0.5)
v133.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
v133.BorderSizePixel = 0
v133.Image = "rbxassetid://3926305904"
v133.ImageRectOffset = Vector2.new(284, 4)
v133.ImageRectSize = Vector2.new(24, 24)
v133.ImageColor3 = Color3.fromRGB(255, 255, 255)
v61(v133, 8)

local v134 = Instance.new("Frame", v129)
v134.Size = UDim2.new(0, 180, 1, -57)
v134.Position = UDim2.new(0, 2.5, 0, 50)
v134.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
v134.BorderSizePixel = 0
v61(v134, 12)
v65(v134, Color3.fromRGB(30, 30, 35), Color3.fromRGB(25, 25, 30), 90)

local v135 = Instance.new("Frame", v129)
v135.Size = UDim2.new(1, -180, 1, -40)
v135.Position = UDim2.new(0, 180, 0, 50)
v135.BackgroundTransparency = 1
v135.BorderSizePixel = 0
v135.ClipsDescendants = true

local v136 = Instance.new("ImageButton", v128)
v136.Name = "ReopenButton"
v136.Size = UDim2.new(0, 0, 0, 0)
v136.Position = UDim2.new(0.5, 0, 0, 30)
v136.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
v136.BorderSizePixel = 0
v136.Visible = false
v136.ZIndex = 10
v136.Active = true
v136.ImageTransparency = 1
v61(v136, 100)
v65(v136, Color3.fromRGB(100, 150, 255), Color3.fromRGB(80, 130, 235), 45)

local v137 = Instance.new("TextLabel", v136)
v137.Size = UDim2.new(1, 0, 1, 0)
v137.BackgroundTransparency = 1
v137.Text = "⚡"
v137.Font = Enum.Font.GothamBold
v137.TextSize = 24
v137.TextColor3 = Color3.fromRGB(255, 255, 255)
v137.TextTransparency = 1

local v138, v139, v140, v141, v142 = false, nil, nil, nil, false
local v143 = nil

v136.InputBegan:Connect(function(v144)
    if v144.UserInputType == Enum.UserInputType.MouseButton1 or v144.UserInputType == Enum.UserInputType.Touch then
        v138 = true
        v142 = false
        v139 = v144.Position
        v140 = v136.Position
        if v141 then v141:Disconnect() end
        v141 = v3.InputChanged:Connect(function(v145)
            if (v145.UserInputType == Enum.UserInputType.MouseMovement or v145.UserInputType == Enum.UserInputType.Touch) and v138 then
                local v146 = v145.Position - v139
                if math.abs(v146.X) > 5 or math.abs(v146.Y) > 5 then v142 = true end
                v136.Position = UDim2.new(v140.X.Scale, v140.X.Offset + v146.X, 0, v140.Y.Offset + v146.Y)
            end
        end)
        v144.Changed:Connect(function()
            if v144.UserInputState == Enum.UserInputState.End then
                v138 = false
                if v141 then v141:Disconnect() v141 = nil end
                task.wait(0.1)
                if v142 then v33() end
                v142 = false
            end
        end)
    end
end)

local v147 = {}
local v148 = {}

_G.UU.UI = {
    ScreenGui = v128,
    MainFrame = v129,
    ContentFrame = v135,
    SideNav = v134,
    CloseButton = v133,
    ReopenButton = v136,
    TabButtons = v147,
    TabContents = v148,
    TweenPresets = v39,
    ActiveTweens = v40,
    PlayTween = v43,
    CancelTween = v41,
    UIScale = v56,
}

local function v149(v150, v151, v152)
    local v153 = Instance.new("TextButton", v134)
    v153.Name = v150 .. "Tab"
    v153.Size = UDim2.new(1, -10, 0, 55)
    v153.Position = UDim2.new(0, 5, 0, 5 + ((v152 - 1) * 60))
    v153.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    v153.BorderSizePixel = 0
    v153.Text = ""
    v153.AutoButtonColor = false
    v61(v153, 8)

    local v154 = Instance.new("TextLabel", v153)
    v154.Size = UDim2.new(0, 30, 1, 0)
    v154.Position = UDim2.new(0, 10, 0, 0)
    v154.BackgroundTransparency = 1
    v154.Text = v151
    v154.Font = Enum.Font.GothamBold
    v154.TextSize = 24
    v154.TextColor3 = Color3.fromRGB(180, 180, 180)
    v154.TextXAlignment = Enum.TextXAlignment.Left

    local v155 = Instance.new("TextLabel", v153)
    v155.Size = UDim2.new(1, -50, 1, 0)
    v155.Position = UDim2.new(0, 45, 0, 0)
    v155.BackgroundTransparency = 1
    v155.Text = v150
    v155.Font = Enum.Font.GothamBold
    v155.TextSize = 13
    v155.TextColor3 = Color3.fromRGB(180, 180, 180)
    v155.TextXAlignment = Enum.TextXAlignment.Left

    v147[v150] = { Button = v153, Icon = v154, Label = v155 }

    v153.MouseEnter:Connect(function()
        if v20.CurrentTab ~= v150 then
            v43(v153, v39.Fast, { BackgroundColor3 = Color3.fromRGB(45, 45, 52) })
            v43(v154, v39.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200) })
            v43(v155, v39.Fast, { TextColor3 = Color3.fromRGB(200, 200, 200) })
        end
    end)
    v153.MouseLeave:Connect(function()
        if v20.CurrentTab ~= v150 then
            v43(v153, v39.Fast, { BackgroundColor3 = Color3.fromRGB(35, 35, 42) })
            v43(v154, v39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
            v43(v155, v39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        end
    end)
    return v153
end

local function v156(v150)
    local v157 = Instance.new("ScrollingFrame", v135)
    v157.Name = v150 .. "Content"
    v157.Size = UDim2.new(1, -10, 1, -10)
    v157.Position = UDim2.new(0, 5, 0, 5)
    v157.BackgroundTransparency = 1
    v157.BorderSizePixel = 0
    v157.ScrollBarThickness = 4
    v157.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    v157.ScrollBarImageTransparency = 0.5
    v157.CanvasSize = UDim2.new(0, 0, 0, 0)
    v157.Visible = false
    v157.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local v158 = Instance.new("UIListLayout", v157)
    v158.SortOrder = Enum.SortOrder.LayoutOrder
    v158.Padding = UDim.new(0, 10)
    v148[v150] = v157
    return v157
end

local v159 = {
    { name = "Home",               icon = "🏠", order = 1 },
    { name = "Anti-AFK",           icon = "⚡", order = 2 },
    { name = "KeySpam",            icon = "⌨️", order = 3 },
    { name = "Performance Status", icon = "📊", order = 4 },
    { name = "Auto Rejoin",        icon = "🔄", order = 5 },
    { name = "Script Loader",      icon = "💾", order = 6 },
    { name = "Settings",           icon = "⚙️", order = 7 },
}

for v160, v161 in ipairs(v159) do
    v149(v161.name, v161.icon, v161.order)
    v156(v161.name)
end

local v162, v163, v164 = {}, {}, {}
local v165, v166, v167, v168 = {}, {}, {}, {}

do
    local v169 = v148["Home"]
    local v170 = v123(v169, 200, 1)

    local v171 = Instance.new("ImageLabel", v170)
    v171.Size = UDim2.new(0, 120, 0, 140)
    v171.Position = UDim2.new(0, 10, 0, 10)
    v171.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    v171.BorderSizePixel = 0
    v171.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    v61(v171, 10)
    Instance.new("UIStroke", v171).Color = Color3.fromRGB(100, 150, 255)

    local v172 = Instance.new("TextLabel", v170)
    v172.Size = UDim2.new(1, -145, 0, 22)
    v172.Position = UDim2.new(0, 140, 0, 10)
    v172.BackgroundTransparency = 1
    v172.Text = v11
    v172.Font = Enum.Font.GothamBold
    v172.TextSize = 28
    v172.TextColor3 = Color3.fromRGB(255, 255, 255)
    v172.TextXAlignment = Enum.TextXAlignment.Left

    local v173 = Instance.new("TextLabel", v170)
    v173.Size = UDim2.new(1, -145, 0, 16)
    v173.Position = UDim2.new(0, 140, 0, 35)
    v173.BackgroundTransparency = 1
    v173.Text = "User ID: " .. v12
    v173.Font = Enum.Font.Gotham
    v173.TextSize = 12
    v173.TextColor3 = Color3.fromRGB(150, 150, 150)
    v173.TextXAlignment = Enum.TextXAlignment.Left

    local v174 = Instance.new("TextLabel", v170)
    v174.Size = UDim2.new(1, -145, 0, 18)
    v174.Position = UDim2.new(0, 140, 0, 55)
    v174.BackgroundTransparency = 1
    v174.Text = "FPS: 60"
    v174.Font = Enum.Font.Gotham
    v174.TextSize = 20
    v174.TextColor3 = Color3.fromRGB(100, 200, 255)
    v174.TextXAlignment = Enum.TextXAlignment.Left

    local v175 = Instance.new("TextLabel", v170)
    v175.Size = UDim2.new(1, -145, 0, 18)
    v175.Position = UDim2.new(0, 140, 0, 75)
    v175.BackgroundTransparency = 1
    v175.Text = "Ping: 0 ms"
    v175.Font = Enum.Font.Gotham
    v175.TextSize = 20
    v175.TextColor3 = Color3.fromRGB(0, 255, 0)
    v175.TextXAlignment = Enum.TextXAlignment.Left

    local v176, v177 = "Unknown", "N/A"
    if identifyexecutor then
        v176, v177 = identifyexecutor()
    elseif getexecutorname then
        v176 = getexecutorname()
    end

    local v178 = Instance.new("TextLabel", v170)
    v178.Size = UDim2.new(1, -145, 0, 18)
    v178.Position = UDim2.new(0, 140, 0, 100)
    v178.BackgroundTransparency = 1
    v178.Text = "Executor: " .. v176 .. " " .. v177
    v178.Font = Enum.Font.Gotham
    v178.TextSize = 20
    v178.TextColor3 = Color3.fromRGB(255, 100, 200)
    v178.TextXAlignment = Enum.TextXAlignment.Left

    local v179 = Instance.new("TextLabel", v170)
    v179.Size = UDim2.new(1, -145, 0, 18)
    v179.Position = UDim2.new(0, 140, 0, 125)
    v179.BackgroundTransparency = 1
    v179.Text = "Device: " .. v18()
    v179.Font = Enum.Font.Gotham
    v179.TextSize = 20
    v179.TextColor3 = Color3.fromRGB(180, 255, 150)
    v179.TextXAlignment = Enum.TextXAlignment.Left

    local v180 = v54()
    local v181 = Instance.new("TextLabel", v170)
    v181.Size = UDim2.new(1, -145, 0, 18)
    v181.Position = UDim2.new(0, 140, 0, 140)
    v181.BackgroundTransparency = 1
    v181.Text = string.format("Resolution: %dx%d", v180.X, v180.Y)
    v181.Font = Enum.Font.Gotham
    v181.TextSize = 12
    v181.TextColor3 = Color3.fromRGB(150, 150, 150)
    v181.TextXAlignment = Enum.TextXAlignment.Left

    local v182 = v123(v169, 220, 2)

    local v183 = Instance.new("ImageLabel", v182)
    v183.Size = UDim2.new(0, 120, 0, 140)
    v183.Position = UDim2.new(0, 10, 0, 10)
    v183.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    v183.BorderSizePixel = 0
    v183.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    v61(v183, 10)
    Instance.new("UIStroke", v183).Color = Color3.fromRGB(100, 150, 255)

    local v184 = Instance.new("TextLabel", v182)
    v184.Size = UDim2.new(1, -145, 0, 24)
    v184.Position = UDim2.new(0, 140, 0, 10)
    v184.BackgroundTransparency = 1
    v184.Text = "Loading game info..."
    v184.Font = Enum.Font.GothamBold
    v184.TextSize = 24
    v184.TextColor3 = Color3.fromRGB(255, 255, 255)
    v184.TextXAlignment = Enum.TextXAlignment.Left
    v184.TextWrapped = true

    local v185 = Instance.new("TextLabel", v182)
    v185.Size = UDim2.new(1, -145, 0, 18)
    v185.Position = UDim2.new(0, 140, 0, 50)
    v185.BackgroundTransparency = 1
    v185.Text = "Place ID: " .. game.PlaceId
    v185.Font = Enum.Font.Gotham
    v185.TextSize = 20
    v185.TextColor3 = Color3.fromRGB(150, 180, 255)
    v185.TextXAlignment = Enum.TextXAlignment.Left

    local v186 = Instance.new("TextLabel", v182)
    v186.Size = UDim2.new(1, -145, 0, 18)
    v186.Position = UDim2.new(0, 140, 0, 90)
    v186.BackgroundTransparency = 1
    v186.Text = "Players Connected: " .. #v1:GetPlayers()
    v186.Font = Enum.Font.Gotham
    v186.TextSize = 20
    v186.TextColor3 = Color3.fromRGB(150, 255, 180)
    v186.TextXAlignment = Enum.TextXAlignment.Left

    local v187 = Instance.new("TextLabel", v182)
    v187.Size = UDim2.new(1, -145, 0, 18)
    v187.Position = UDim2.new(0, 140, 0, 130)
    v187.BackgroundTransparency = 1
    v187.Text = "Server JobId: " .. game.JobId
    v187.Font = Enum.Font.Gotham
    v187.TextSize = 12
    v187.TextColor3 = Color3.fromRGB(255, 180, 180)
    v187.TextXAlignment = Enum.TextXAlignment.Left

    local function v188()
        v186.Text = "Players Connected: " .. #v1:GetPlayers()
    end
    table.insert(_G.UU.Connections, v1.PlayerAdded:Connect(v188))
    table.insert(_G.UU.Connections, v1.PlayerRemoving:Connect(v188))

    _G.UU.UI.PlayerImage = v171
    _G.UU.UI.GameName = v184
    _G.UU.UI.GameImage = v183
    _G.UU.UI.ResolutionLabel = v181
    _G.UU.UI.DeviceLabel = v179
    v162.FPSLabel = v174
    v162.PingLabel = v175
end

do
    local v189 = v148["Anti-AFK"]
    local v190 = v123(v189, 400, 1)

    local v191 = Instance.new("TextLabel", v190)
    v191.Size = UDim2.new(1, -20, 0, 26); v191.Position = UDim2.new(0, 10, 0, 8)
    v191.BackgroundTransparency = 1; v191.Text = "⚡ Anti-AFK System"
    v191.Font = Enum.Font.GothamBold; v191.TextSize = 18
    v191.TextColor3 = Color3.fromRGB(100, 200, 255); v191.TextXAlignment = Enum.TextXAlignment.Left

    local v192 = Instance.new("TextLabel", v190)
    v192.Size = UDim2.new(1, -20, 0, 16); v192.Position = UDim2.new(0, 10, 0, 34)
    v192.BackgroundTransparency = 1; v192.Text = "Prevent disconnections by simulating player activity"
    v192.Font = Enum.Font.Gotham; v192.TextSize = 12
    v192.TextColor3 = Color3.fromRGB(150, 150, 150); v192.TextXAlignment = Enum.TextXAlignment.Left

    local v193 = v70(v190, UDim2.new(0, 140, 0, 36), "Auto Jump: OFF")
    v193.Position = UDim2.new(0.25, 0, 0, 65)
    local v194 = v70(v190, UDim2.new(0, 140, 0, 36), "Auto Click: OFF")
    v194.Position = UDim2.new(0.75, 0, 0, 65)

    v117(v190, 115)
    v120(v190, "Click Position Mode", 127)

    local v195 = v70(v190, UDim2.new(0, 85, 0, 30), "Current")
    v195.Position = UDim2.new(0.2, 0, 0, 155)
    local v196 = v70(v190, UDim2.new(0, 85, 0, 30), "Center")
    v196.Position = UDim2.new(0.5, 0, 0, 155)
    local v197 = v70(v190, UDim2.new(0, 85, 0, 30), "Random")
    v197.Position = UDim2.new(0.8, 0, 0, 155)

    v117(v190, 198)

    local v198, v199, v200, v201, v202 = v74(v190, UDim2.new(1, -20, 0, 50), 5, 30, 10, "Jump Interval (seconds)")
    v198.Position = UDim2.new(0, 10, 0, 213)
    local v203, v204, v205, v206, v207 = v74(v190, UDim2.new(1, -20, 0, 50), 1, 10, 3, "Click Interval (seconds)")
    v203.Position = UDim2.new(0, 10, 0, 280)

    local v208, v209 = v113(v190, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 345), "Status: All Inactive")

    v163 = {
        JumpToggle = v193,
        ClickToggle = v194,
        ClickTypeCurrent = v195,
        ClickTypeCenter = v196,
        ClickTypeRandom = v197,
        JumpDelaySlider = v199,
        JumpSliderFill = v200,
        JumpSliderButton = v201,
        JumpDelayBox = v202,
        ClickDelaySlider = v204,
        ClickSliderFill = v205,
        ClickSliderButton = v206,
        ClickDelayBox = v207,
        Status = v209,
    }
end

do
    local v210 = v148["KeySpam"]
    local v211 = v123(v210, 320, 1)

    local v212 = Instance.new("TextLabel", v211)
    v212.Size = UDim2.new(1, -20, 0, 26); v212.Position = UDim2.new(0, 10, 0, 8)
    v212.BackgroundTransparency = 1; v212.Text = "⌨️ Key Spam Controller"
    v212.Font = Enum.Font.GothamBold; v212.TextSize = 18
    v212.TextColor3 = Color3.fromRGB(255, 200, 100); v212.TextXAlignment = Enum.TextXAlignment.Left

    local v213 = Instance.new("TextLabel", v211)
    v213.Size = UDim2.new(1, -20, 0, 16); v213.Position = UDim2.new(0, 10, 0, 34)
    v213.BackgroundTransparency = 1; v213.Text = "Automatically spam any keyboard key at custom intervals"
    v213.Font = Enum.Font.Gotham; v213.TextSize = 12
    v213.TextColor3 = Color3.fromRGB(150, 150, 150); v213.TextXAlignment = Enum.TextXAlignment.Left

    v120(v211, "Target Key", 60)

    local v214 = Instance.new("TextBox", v211)
    v214.Size = UDim2.new(1, -20, 0, 40)
    v214.Position = UDim2.new(0, 10, 0, 82)
    v214.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    v214.Text = v20.SpamKey
    v214.PlaceholderText = "Enter key (A-Z, 0-9, F1-F12)"
    v214.Font = Enum.Font.Gotham
    v214.TextSize = 14
    v214.TextColor3 = Color3.fromRGB(255, 255, 255)
    v214.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    v214.BorderSizePixel = 0
    v214.ClearTextOnFocus = false
    v61(v214, 8)
    Instance.new("UIStroke", v214).Color = Color3.fromRGB(60, 60, 70)

    v117(v211, 135)

    local v215, v216, v217, v218, v219 = v74(v211, UDim2.new(1, -20, 0, 50), 0.05, 5, 0.1, "Spam Interval (seconds)")
    v215.Position = UDim2.new(0, 10, 0, 150)

    local v220 = v70(v211, UDim2.new(0, 120, 0, 36), "OFF")
    v220.Position = UDim2.new(0.5, 0, 0, 220)

    local v221, v222 = v113(v211, UDim2.new(1, -20, 0, 45), UDim2.new(0, 10, 0, 265), "System Status: Inactive")

    v164 = {
        SpamInput = v214,
        SpamDelaySlider = v216,
        SpamSliderFill = v217,
        SpamSliderButton = v218,
        SpamDelayBox = v219,
        AutoSpamToggle = v220,
        Status = v222,
    }
end

do
    local v223 = v148["Performance Status"]
    local v224 = v123(v223, 580, 1)

    local v225 = Instance.new("TextLabel", v224)
    v225.Size = UDim2.new(1, -20, 0, 26); v225.Position = UDim2.new(0, 10, 0, 8)
    v225.BackgroundTransparency = 1; v225.Text = "📊 Performance Monitor"
    v225.Font = Enum.Font.GothamBold; v225.TextSize = 18
    v225.TextColor3 = Color3.fromRGB(100, 255, 150); v225.TextXAlignment = Enum.TextXAlignment.Left

    local v226 = Instance.new("TextLabel", v224)
    v226.Size = UDim2.new(1, -20, 0, 16); v226.Position = UDim2.new(0, 10, 0, 34)
    v226.BackgroundTransparency = 1; v226.Text = "Track real-time performance metrics and unlock FPS limits"
    v226.Font = Enum.Font.Gotham; v226.TextSize = 12
    v226.TextColor3 = Color3.fromRGB(150, 150, 150); v226.TextXAlignment = Enum.TextXAlignment.Left

    local v227 = v70(v224, UDim2.new(0, 160, 0, 36), "FPS Unlock: OFF")
    v227.Position = UDim2.new(0.5, 0, 0, 65)

    local v228 = Instance.new("TextLabel", v224)
    v228.Size = UDim2.new(1, -20, 0, 20)
    v228.Position = UDim2.new(0, 10, 0, 108)
    v228.BackgroundTransparency = 1
    v228.Text = "Current Limit: 60 FPS"
    v228.Font = Enum.Font.Gotham
    v228.TextSize = 13
    v228.TextColor3 = Color3.fromRGB(180, 180, 180)
    v228.TextXAlignment = Enum.TextXAlignment.Center

    local v229, v230, v231, v232, v233 = v74(v224, UDim2.new(1, -20, 0, 50), 15, 360, 60, "Target FPS Limit")
    v229.Position = UDim2.new(0, 10, 0, 140)

    v117(v224, 205)
    v120(v224, "Framerate Statistics", 215)

    local v234 = Instance.new("Frame", v224)
    v234.Size = UDim2.new(1, -20, 0, 50)
    v234.Position = UDim2.new(0, 10, 0, 240)
    v234.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    v234.BorderSizePixel = 0
    v61(v234, 8)
    Instance.new("UIStroke", v234).Color = Color3.fromRGB(50, 50, 60)

    local function v235(v62, v236, v72, v121)
        local v237 = Instance.new("TextLabel", v62)
        v237.Size = UDim2.new(v236[3], 0, 1, 0)
        v237.Position = UDim2.new(v236[1], 0, 0, 0)
        v237.BackgroundTransparency = 1
        v237.Text = v72
        v237.Font = Enum.Font.GothamBold
        v237.TextSize = 13
        v237.TextColor3 = v121
        v237.TextXAlignment = Enum.TextXAlignment.Center
        return v237
    end

    local v238 = v235(v234, {0, 0, 0.33}, "Current: 60", Color3.fromRGB(100, 200, 255))
    local v239 = v235(v234, {0.33, 0, 0.33}, "Average: 60", Color3.fromRGB(50, 220, 100))
    local v240 = v235(v234, {0.66, 0, 0.34}, "Min: 60 | Max: 60", Color3.fromRGB(255, 200, 100))

    v117(v224, 305)
    v120(v224, "Network Latency Statistics", 315)

    local v241 = Instance.new("Frame", v224)
    v241.Size = UDim2.new(1, -20, 0, 50)
    v241.Position = UDim2.new(0, 10, 0, 340)
    v241.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    v241.BorderSizePixel = 0
    v61(v241, 8)
    Instance.new("UIStroke", v241).Color = Color3.fromRGB(50, 50, 60)

    local v242 = v235(v241, {0, 0, 0.33}, "Current: 0ms", Color3.fromRGB(100, 200, 255))
    local v243 = v235(v241, {0.33, 0, 0.33}, "Average: 0ms", Color3.fromRGB(50, 220, 100))
    local v244 = v235(v241, {0.66, 0, 0.34}, "Min: 0ms | Max: 0ms", Color3.fromRGB(255, 200, 100))

    local v245 = Instance.new("Frame", v224)
    v245.Size = UDim2.new(1, -20, 0, 50)
    v245.Position = UDim2.new(0, 10, 0, 405)
    v245.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    v245.BorderSizePixel = 0
    v61(v245, 8)
    Instance.new("UIStroke", v245).Color = Color3.fromRGB(50, 50, 60)

    v235(v245, {0, 0, 0.5}, "Connection Quality", Color3.fromRGB(255, 255, 255))
    local v246 = v235(v245, {0.5, 0, 0.5}, "Excellent", Color3.fromRGB(50, 220, 100))

    local v247 = Instance.new("TextLabel", v224)
    v247.Size = UDim2.new(1, -20, 0, 110)
    v247.Position = UDim2.new(0, 10, 0, 465)
    v247.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    v247.BorderSizePixel = 0
    v247.Text = "Performance monitoring tracks your game's framerate and network latency in real-time.\n\nLowering FPS limits reduces memory usage. Higher FPS provides smoother gameplay but increases resource consumption.\n\nOptimal FPS depends on your device capabilities."
    v247.Font = Enum.Font.Gotham
    v247.TextSize = 12
    v247.TextColor3 = Color3.fromRGB(200, 180, 150)
    v247.TextWrapped = true
    v247.TextXAlignment = Enum.TextXAlignment.Left
    v247.TextYAlignment = Enum.TextYAlignment.Top
    v61(v247, 8)
    Instance.new("UIStroke", v247).Color = Color3.fromRGB(50, 50, 60)
    local v248 = Instance.new("UIPadding", v247)
    v248.PaddingLeft = UDim.new(0, 10); v248.PaddingRight = UDim.new(0, 10)
    v248.PaddingTop = UDim.new(0, 10); v248.PaddingBottom = UDim.new(0, 10)

    v165 = {
        FPSUnlockToggle = v227,
        FPSUnlockStatus = v228,
        FPSSlider = v230,
        FPSFill = v231,
        FPSButton = v232,
        FPSValueBox = v233,
        FPSStats = { Current = v238, Avg = v239, MinMax = v240 },
        PingStats = { Current = v242, Avg = v243, MinMax = v244, Quality = v246 },
    }
end

do
    local v249 = v148["Auto Rejoin"]
    local v250 = v123(v249, 250, 1)

    local v251 = Instance.new("TextLabel", v250)
    v251.Size = UDim2.new(1, -20, 0, 26); v251.Position = UDim2.new(0, 10, 0, 8)
    v251.BackgroundTransparency = 1; v251.Text = "🔄 Auto Rejoin System"
    v251.Font = Enum.Font.GothamBold; v251.TextSize = 18
    v251.TextColor3 = Color3.fromRGB(150, 200, 255); v251.TextXAlignment = Enum.TextXAlignment.Left

    local v252 = Instance.new("TextLabel", v250)
    v252.Size = UDim2.new(1, -20, 0, 16); v252.Position = UDim2.new(0, 10, 0, 34)
    v252.BackgroundTransparency = 1; v252.Text = "Automatically reconnect when disconnected from the server"
    v252.Font = Enum.Font.Gotham; v252.TextSize = 12
    v252.TextColor3 = Color3.fromRGB(150, 150, 150); v252.TextXAlignment = Enum.TextXAlignment.Left

    local v253 = v70(v250, UDim2.new(0, 180, 0, 40), "Auto Rejoin: OFF")
    v253.Position = UDim2.new(0.5, 0, 0, 75)

    local v254, v255 = v113(v250, UDim2.new(1, -20, 0, 105), UDim2.new(0, 10, 0, 135),
        "System Status: Disabled\n\nWhen enabled, this feature will automatically rejoin the current server when you get disconnected due to errors or AFK timeout.")

    v166 = { AutoRejoinToggle = v253, Status = v255 }
end

do
    local v256 = v148["Script Loader"]
    local v257 = v123(v256, 460, 1)

    local v258 = Instance.new("TextLabel", v257)
    v258.Size = UDim2.new(1, -20, 0, 26); v258.Position = UDim2.new(0, 10, 0, 8)
    v258.BackgroundTransparency = 1; v258.Text = "💾 Script Executor"
    v258.Font = Enum.Font.GothamBold; v258.TextSize = 18
    v258.TextColor3 = Color3.fromRGB(200, 150, 255); v258.TextXAlignment = Enum.TextXAlignment.Left

    local v259 = Instance.new("TextLabel", v257)
    v259.Size = UDim2.new(1, -20, 0, 16); v259.Position = UDim2.new(0, 10, 0, 34)
    v259.BackgroundTransparency = 1; v259.Text = "Execute custom Lua scripts with auto-save and auto-load capabilities"
    v259.Font = Enum.Font.Gotham; v259.TextSize = 12
    v259.TextColor3 = Color3.fromRGB(150, 150, 150); v259.TextXAlignment = Enum.TextXAlignment.Left

    local v260 = Instance.new("Frame", v257)
    v260.Size = UDim2.new(1, -20, 0, 220)
    v260.Position = UDim2.new(0, 10, 0, 60)
    v260.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    v260.BorderSizePixel = 0
    v61(v260, 8)
    Instance.new("UIStroke", v260).Color = Color3.fromRGB(60, 60, 70)

    local v261 = Instance.new("ScrollingFrame", v260)
    v261.Size = UDim2.new(0, 40, 1, 0)
    v261.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    v261.BorderSizePixel = 0
    v261.ScrollBarThickness = 0
    v261.ScrollingEnabled = false
    v261.CanvasSize = UDim2.new(0, 0, 0, 220)
    v61(v261, 8)

    local v262 = Instance.new("TextLabel", v261)
    v262.Size = UDim2.new(1, -5, 1, 0)
    v262.BackgroundTransparency = 1
    v262.Text = "1"
    v262.Font = Enum.Font.Code
    v262.TextSize = 12
    v262.TextColor3 = Color3.fromRGB(120, 120, 120)
    v262.TextXAlignment = Enum.TextXAlignment.Right
    v262.TextYAlignment = Enum.TextYAlignment.Top

    local v263 = Instance.new("Frame", v260)
    v263.Size = UDim2.new(0, 1, 1, 0)
    v263.Position = UDim2.new(0, 40, 0, 0)
    v263.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    v263.BorderSizePixel = 0

    local v264 = Instance.new("ScrollingFrame", v260)
    v264.Size = UDim2.new(1, -41, 1, 0)
    v264.Position = UDim2.new(0, 41, 0, 0)
    v264.BackgroundTransparency = 1
    v264.BorderSizePixel = 0
    v264.ScrollBarThickness = 4
    v264.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    v264.ScrollBarImageTransparency = 0.5
    v264.CanvasSize = UDim2.new(0, 0, 0, 220)

    local v265 = Instance.new("TextBox", v264)
    v265.Size = UDim2.new(1, -10, 1, 0)
    v265.Position = UDim2.new(0, 5, 0, 0)
    v265.BackgroundTransparency = 1
    v265.Text = v20.SavedCode
    v265.PlaceholderText = "-- Paste your Lua code here..."
    v265.Font = Enum.Font.Code
    v265.TextSize = 12
    v265.TextColor3 = Color3.fromRGB(255, 255, 255)
    v265.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    v265.BorderSizePixel = 0
    v265.TextWrapped = true
    v265.TextXAlignment = Enum.TextXAlignment.Left
    v265.TextYAlignment = Enum.TextYAlignment.Top
    v265.MultiLine = true
    v265.ClearTextOnFocus = false
    v265.TextEditable = true

    local v266 = v70(v257, UDim2.new(0, 140, 0, 36), "Execute")
    v266.Position = UDim2.new(0.25, 0, 0, 300)
    local v267 = v70(v257, UDim2.new(0, 140, 0, 36), "Auto Load: OFF")
    v267.Position = UDim2.new(0.75, 0, 0, 300)

    local v268, v269 = v113(v257, UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 350), "System Status: Ready to execute")

    local v270 = Instance.new("TextLabel", v257)
    v270.Size = UDim2.new(1, -20, 0, 60)
    v270.Position = UDim2.new(0, 10, 0, 395)
    v270.BackgroundTransparency = 1
    v270.Text = "Your code is automatically saved while typing. Enable Auto Load to execute your script automatically when rejoining.\n\nChanges are saved in real-time."
    v270.Font = Enum.Font.Gotham
    v270.TextSize = 12
    v270.TextColor3 = Color3.fromRGB(130, 130, 130)
    v270.TextXAlignment = Enum.TextXAlignment.Center
    v270.TextWrapped = true

    v167 = {
        LoadStringBox = v265,
        LineNumbers = v262,
        LoadStringScrollFrame = v264,
        LineNumbersScrollFrame = v261,
        ExecuteButton = v266,
        AutoLoadButton = v267,
        Status = v269,
    }
end

do
    local v271 = v148["Settings"]
    local v272 = v123(v271, 230, 1)

    local v273 = Instance.new("TextLabel", v272)
    v273.Size = UDim2.new(1, -20, 0, 26); v273.Position = UDim2.new(0, 10, 0, 8)
    v273.BackgroundTransparency = 1; v273.Text = "⚙️ UI Configuration"
    v273.Font = Enum.Font.GothamBold; v273.TextSize = 18
    v273.TextColor3 = Color3.fromRGB(255, 180, 100); v273.TextXAlignment = Enum.TextXAlignment.Left

    local v274 = Instance.new("TextLabel", v272)
    v274.Size = UDim2.new(1, -20, 0, 16); v274.Position = UDim2.new(0, 10, 0, 34)
    v274.BackgroundTransparency = 1; v274.Text = "Customize interface preferences and keybinds"
    v274.Font = Enum.Font.Gotham; v274.TextSize = 11
    v274.TextColor3 = Color3.fromRGB(150, 150, 150); v274.TextXAlignment = Enum.TextXAlignment.Left

    v120(v272, "Toggle Keybind", 60)

    local v275 = v21[v20.Keybind] or v20.Keybind.Name
    local v276 = v70(v272, UDim2.new(0, 220, 0, 40), "Current Key: " .. v275)
    v276.Position = UDim2.new(0.5, 0, 0, 90)

    local v277, v278 = v113(v272, UDim2.new(1, -20, 0, 85), UDim2.new(0, 10, 0, 140),
        "Click the button above to change your toggle keybind.\n\nPress the assigned keybind at any time to show or hide this menu.")

    v168 = { KeybindButton = v276, Status = v278 }
end

local v279 = typeof(setfpscap) == "function"
if v279 then
    local v280 = pcall(setfpscap, 60)
    if not v280 then v279 = false end
end

local v281, v282, v283 = {}, {}, 60
local v284, v285, v286 = tick(), 0, 60

for v287 = 1, 60 do
    table.insert(v281, 60)
    table.insert(v282, 0)
end

local function v288()
    local v289 = v163
    if not v289.Status then return end
    local v290, v291
    if v20.JumpEnabled and v20.ClickEnabled then
        v290, v291 = "Status: Jump & Click Active", Color3.fromRGB(50, 220, 100)
    elseif v20.JumpEnabled then
        v290, v291 = "Status: Jump Active", Color3.fromRGB(100, 200, 255)
    elseif v20.ClickEnabled then
        v290, v291 = "Status: Click Active", Color3.fromRGB(255, 200, 100)
    else
        v290, v291 = "Status: All Inactive", Color3.fromRGB(180, 180, 180)
    end
    v43(v289.Status, v39.Fast, { TextColor3 = v291 })
    v289.Status.Text = v290
end

local function v292()
    local v293 = {
        Current = v163.ClickTypeCurrent,
        Center = v163.ClickTypeCenter,
        Random = v163.ClickTypeRandom,
    }
    for v294, v295 in pairs(v293) do
        if v295 then
            local v296 = v20.ClickType == v294 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(45, 45, 52)
            if _G.UU.ButtonStates[v295] then _G.UU.ButtonStates[v295].BaseColor = v296 end
            v43(v295, v39.Fast, { BackgroundColor3 = v296 })
        end
    end
end

local function v297()
    v51("Jump")
    _G.UU.Threads.Jump = task.spawn(function()
        while v20.JumpEnabled do
            task.wait(v20.JumpDelay)
            if v20.JumpEnabled and v10.Character then
                local v298 = v10.Character:FindFirstChildOfClass("Humanoid")
                if v298 then v298:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
        _G.UU.Threads.Jump = nil
    end)
end

local function v299()
    v51("Click")
    _G.UU.Threads.Click = task.spawn(function()
        while v20.ClickEnabled do
            task.wait(v20.ClickDelay)
            if v20.ClickEnabled then
                local v300, v301
                if v20.ClickType == "Current" then
                    local v302 = v3:GetMouseLocation()
                    v300, v301 = v302.X, v302.Y
                elseif v20.ClickType == "Center" then
                    local v303 = workspace.CurrentCamera.ViewportSize
                    v300, v301 = v303.X / 2, v303.Y / 2
                else
                    local v304 = workspace.CurrentCamera.ViewportSize
                    v300, v301 = math.random(100, v304.X - 100), math.random(100, v304.Y - 100)
                end
                v4:SendMouseButtonEvent(v300, v301, 0, true, game, 0)
                task.wait(0.05)
                v4:SendMouseButtonEvent(v300, v301, 0, false, game, 0)
            end
        end
        _G.UU.Threads.Click = nil
    end)
end

local function v305()
    v51("Spam")
    local v306 = v20.SpamKey:upper()
    local v307 = v22[v306]
    if not v307 then return end
    _G.UU.Threads.Spam = task.spawn(function()
        while v20.AutoSpamEnabled do
            task.wait(v20.SpamDelay)
            if v20.AutoSpamEnabled then
                v4:SendKeyEvent(true, v307, false, game)
                task.wait(0.05)
                v4:SendKeyEvent(false, v307, false, game)
            end
        end
        _G.UU.Threads.Spam = nil
    end)
end

local v308 = false
local v309 = nil

local function v310()
    if v309 then
        pcall(function() v309:Disconnect() end)
        v309 = nil
    end
    if not v20.AutoRejoinEnabled then return end
    task.spawn(function()
        local v311 = v6:FindFirstChild("RobloxPromptGui")
        if not v311 then
            local v312, v313 = pcall(function() return v6:WaitForChild("RobloxPromptGui", 10) end)
            if not v312 or not v313 then
                if v166.Status then
                    v166.Status.Text = "Status: Enabled (waiting for prompt GUI...)\n\nAutomatically rejoins the game when disconnected."
                end
                return
            end
            v311 = v313
        end
        local v314 = v311:FindFirstChild("promptOverlay")
        if not v314 then
            local v315, v316 = pcall(function() return v311:WaitForChild("promptOverlay", 10) end)
            if not v315 or not v316 then
                if v166.Status then
                    v166.Status.Text = "Status: Enabled (prompt overlay unavailable)\n\nAutomatically rejoins the game when disconnected."
                end
                return
            end
            v314 = v316
        end
        v309 = v314.ChildAdded:Connect(function(v317)
            if v317.Name == "ErrorPrompt" and v20.AutoRejoinEnabled and not v308 then
                v308 = true
                _G.UU.Threads.Rejoin = task.spawn(function()
                    while v20.AutoRejoinEnabled and v308 do
                        v7:Teleport(game.PlaceId, v10)
                        task.wait(2)
                    end
                    _G.UU.Threads.Rejoin = nil
                end)
            end
        end)
    end)
end

local function v318(v319)
    if not v319 or v319 == "" then return false, "Empty script" end
    local v320, v321 = pcall(function()
        local v322, v323 = loadstring(v319)
        if not v322 then error(v323) end
        v322()
    end)
    if v320 then return true, "Executed successfully!" end
    return false, "Error - " .. tostring(v321):sub(1, 50) .. "..."
end

local v324 = { jump = false, click = false, spam = false, fps = false }

local function v325(v88)
    v20.JumpDelay = 5 + (v88 * 25)
    v85(v163.JumpSliderFill, v163.JumpDelayBox, v20.JumpDelay, 5, 30, "%.1f")
    v33()
end

local function v326(v88)
    v20.ClickDelay = 1 + (v88 * 9)
    v85(v163.ClickSliderFill, v163.ClickDelayBox, v20.ClickDelay, 1, 10, "%.1f")
    v33()
end

local function v327(v88)
    v20.SpamDelay = 0.05 + (v88 * 4.95)
    v85(v164.SpamSliderFill, v164.SpamDelayBox, v20.SpamDelay, 0.05, 5, "%.2f")
    v33()
end

local function v328(v88)
    v20.TargetFPS = math.floor(15 + (v88 * 345))
    v85(v165.FPSFill, v165.FPSValueBox, v20.TargetFPS, 15, 360, "%d")
    if v20.FPSUnlockEnabled and v279 then
        pcall(setfpscap, v20.TargetFPS)
        v165.FPSUnlockStatus.Text = "Your target: " .. v20.TargetFPS .. " FPS"
    end
    v33()
end

v163.JumpSliderButton.MouseButton1Down:Connect(function() v324.jump = true; v89(v163.JumpSliderButton, 0.9) end)
v163.ClickSliderButton.MouseButton1Down:Connect(function() v324.click = true; v89(v163.ClickSliderButton, 0.9) end)
v164.SpamSliderButton.MouseButton1Down:Connect(function() v324.spam = true; v89(v164.SpamSliderButton, 0.9) end)
v165.FPSButton.MouseButton1Down:Connect(function() v324.fps = true; v89(v165.FPSButton, 0.9) end)

table.insert(_G.UU.Connections, v3.InputEnded:Connect(function(v110)
    if v110.UserInputType == Enum.UserInputType.MouseButton1 then
        v324.jump = false
        v324.click = false
        v324.spam = false
        v324.fps = false
    end
end))

table.insert(_G.UU.Connections, v3.InputChanged:Connect(function(v110)
    if v110.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local v329 = v3:GetMouseLocation().X
    if v324.jump and v163.JumpDelaySlider then
        v325(math.clamp((v329 - v163.JumpDelaySlider.AbsolutePosition.X) / v163.JumpDelaySlider.AbsoluteSize.X, 0, 1))
    elseif v324.click and v163.ClickDelaySlider then
        v326(math.clamp((v329 - v163.ClickDelaySlider.AbsolutePosition.X) / v163.ClickDelaySlider.AbsoluteSize.X, 0, 1))
    elseif v324.spam and v164.SpamDelaySlider then
        v327(math.clamp((v329 - v164.SpamDelaySlider.AbsolutePosition.X) / v164.SpamDelaySlider.AbsoluteSize.X, 0, 1))
    elseif v324.fps and v165.FPSSlider then
        v328(math.clamp((v329 - v165.FPSSlider.AbsolutePosition.X) / v165.FPSSlider.AbsoluteSize.X, 0, 1))
    end
end))

v163.JumpDelayBox.FocusLost:Connect(function()
    local v86 = math.clamp(tonumber(v163.JumpDelayBox.Text) or v20.JumpDelay, 5, 30)
    v325((v86 - 5) / 25)
end)
v163.ClickDelayBox.FocusLost:Connect(function()
    local v86 = math.clamp(tonumber(v163.ClickDelayBox.Text) or v20.ClickDelay, 1, 10)
    v326((v86 - 1) / 9)
end)
v164.SpamDelayBox.FocusLost:Connect(function()
    local v86 = math.clamp(tonumber(v164.SpamDelayBox.Text) or v20.SpamDelay, 0.05, 5)
    v327((v86 - 0.05) / 4.95)
end)
v165.FPSValueBox.FocusLost:Connect(function()
    local v86 = math.clamp(tonumber(v165.FPSValueBox.Text) or v20.TargetFPS, 15, 360)
    v328((v86 - 15) / 345)
end)
v164.SpamInput.FocusLost:Connect(function()
    v20.SpamKey = v164.SpamInput.Text:upper()
    v33()
end)

local v330 = false
local function v331(v332)
    if v330 or v20.ClickType == v332 then return end
    v330 = true
    v20.ClickType = v332
    v292()
    v33()
    task.delay(0.1, function() v330 = false end)
end

v163.ClickTypeCurrent.MouseButton1Click:Connect(function() v331("Current"); v89(v163.ClickTypeCurrent) end)
v163.ClickTypeCenter.MouseButton1Click:Connect(function() v331("Center"); v89(v163.ClickTypeCenter) end)
v163.ClickTypeRandom.MouseButton1Click:Connect(function() v331("Random"); v89(v163.ClickTypeRandom) end)

v163.JumpToggle.MouseButton1Click:Connect(function()
    if not v48("Jump", 0.3) then return end
    v89(v163.JumpToggle)
    v20.JumpEnabled = not v20.JumpEnabled
    local v296 = v20.JumpEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[v163.JumpToggle] then _G.UU.ButtonStates[v163.JumpToggle].BaseColor = v296 end
    v43(v163.JumpToggle, v39.Medium, { BackgroundColor3 = v296 })
    v163.JumpToggle.Text = "Auto Jump: " .. (v20.JumpEnabled and "ON" or "OFF")
    if v20.JumpEnabled then task.wait(0.05); v297() else v51("Jump") end
    v288(); v33()
end)

v163.ClickToggle.MouseButton1Click:Connect(function()
    if not v48("Click", 0.3) then return end
    v89(v163.ClickToggle)
    v20.ClickEnabled = not v20.ClickEnabled
    local v296 = v20.ClickEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[v163.ClickToggle] then _G.UU.ButtonStates[v163.ClickToggle].BaseColor = v296 end
    v43(v163.ClickToggle, v39.Medium, { BackgroundColor3 = v296 })
    v163.ClickToggle.Text = "Auto Click: " .. (v20.ClickEnabled and "ON" or "OFF")
    if v20.ClickEnabled then task.wait(0.05); v299() else v51("Click") end
    v288(); v33()
end)

v164.AutoSpamToggle.MouseButton1Click:Connect(function()
    if not v48("Spam", 0.3) then return end
    v89(v164.AutoSpamToggle)
    v20.AutoSpamEnabled = not v20.AutoSpamEnabled
    if v20.AutoSpamEnabled then
        local v306 = v164.SpamInput.Text:upper()
        local v307 = v22[v306]
        if not v307 then
            v20.AutoSpamEnabled = false
            v164.Status.Text = "Status: Invalid key"
            v43(v164.Status, v39.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            return
        end
        if v307 == Enum.KeyCode.P or v307 == v20.Keybind then
            v20.AutoSpamEnabled = false
            v164.Status.Text = "Status: Key reserved"
            v43(v164.Status, v39.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
            return
        end
        v20.SpamKey = v306
        local v296 = Color3.fromRGB(50, 220, 100)
        if _G.UU.ButtonStates[v164.AutoSpamToggle] then _G.UU.ButtonStates[v164.AutoSpamToggle].BaseColor = v296 end
        v43(v164.AutoSpamToggle, v39.Medium, { BackgroundColor3 = v296 })
        v164.AutoSpamToggle.Text = "ON"
        v164.Status.Text = "Status: Spamming " .. v306
        v43(v164.Status, v39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        task.wait(0.05); v305()
    else
        local v296 = Color3.fromRGB(220, 50, 50)
        if _G.UU.ButtonStates[v164.AutoSpamToggle] then _G.UU.ButtonStates[v164.AutoSpamToggle].BaseColor = v296 end
        v43(v164.AutoSpamToggle, v39.Medium, { BackgroundColor3 = v296 })
        v164.AutoSpamToggle.Text = "OFF"
        v164.Status.Text = "Status: Inactive"
        v43(v164.Status, v39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        v51("Spam")
    end
    v33()
end)

v165.FPSUnlockToggle.MouseButton1Click:Connect(function()
    if not v48("FPS", 0.3) then return end
    v89(v165.FPSUnlockToggle)
    if not v279 then
        v165.FPSUnlockStatus.Text = "FPS Unlock not supported"
        v43(v165.FPSUnlockStatus, v39.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
        return
    end
    v20.FPSUnlockEnabled = not v20.FPSUnlockEnabled
    if v20.FPSUnlockEnabled then
        pcall(setfpscap, v20.TargetFPS)
    else
        pcall(setfpscap, 60)
    end
    local v296 = v20.FPSUnlockEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[v165.FPSUnlockToggle] then _G.UU.ButtonStates[v165.FPSUnlockToggle].BaseColor = v296 end
    v43(v165.FPSUnlockToggle, v39.Medium, { BackgroundColor3 = v296 })
    v165.FPSUnlockToggle.Text = "FPS Unlock: " .. (v20.FPSUnlockEnabled and "ON" or "OFF")
    if v20.FPSUnlockEnabled then
        v165.FPSUnlockStatus.Text = "Your target: " .. v20.TargetFPS .. " FPS"
        v43(v165.FPSUnlockStatus, v39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
    else
        v165.FPSUnlockStatus.Text = "Default FPS"
        v43(v165.FPSUnlockStatus, v39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    v33()
end)

v166.AutoRejoinToggle.MouseButton1Click:Connect(function()
    if not v48("Rejoin", 0.3) then return end
    v89(v166.AutoRejoinToggle)
    v20.AutoRejoinEnabled = not v20.AutoRejoinEnabled
    local v296 = v20.AutoRejoinEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[v166.AutoRejoinToggle] then _G.UU.ButtonStates[v166.AutoRejoinToggle].BaseColor = v296 end
    v43(v166.AutoRejoinToggle, v39.Medium, { BackgroundColor3 = v296 })
    v166.AutoRejoinToggle.Text = "Auto Rejoin: " .. (v20.AutoRejoinEnabled and "ON" or "OFF")
    if v20.AutoRejoinEnabled then
        v166.Status.Text = "Status: Enabled\n\nAutomatically rejoins the game when you get disconnected.\nUseful for preventing AFK kicks."
        v43(v166.Status, v39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        v310()
    else
        v308 = false
        v51("Rejoin")
        if v309 then pcall(function() v309:Disconnect() end); v309 = nil end
        v166.Status.Text = "Status: Disabled\n\nWhen enabled, this feature will automatically rejoin the current server when you get disconnected due to errors or AFK timeout."
        v43(v166.Status, v39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    v33()
end)

v167.ExecuteButton.MouseButton1Click:Connect(function()
    if not v48("Execute", 0.5) then return end
    v89(v167.ExecuteButton)
    local v319 = v167.LoadStringBox.Text
    v167.Status.Text = "Status: Executing..."
    v43(v167.Status, v39.Fast, { TextColor3 = Color3.fromRGB(255, 200, 100) })
    v43(v167.ExecuteButton, v39.Medium, { BackgroundColor3 = Color3.fromRGB(255, 200, 100) })
    local v320, v321 = v318(v319)
    local v333 = v320 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    v167.Status.Text = "Status: " .. v321
    v43(v167.Status, v39.Fast, { TextColor3 = v333 })
    v43(v167.ExecuteButton, v39.Medium, { BackgroundColor3 = v333 })
    task.wait(2)
    if v167.Status.Text:match("Error") or v167.Status.Text:match("successfully") then
        v167.Status.Text = "Status: Ready"
        v43(v167.Status, v39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        v43(v167.ExecuteButton, v39.Medium, { BackgroundColor3 = Color3.fromRGB(45, 45, 52) })
    end
end)

v167.AutoLoadButton.MouseButton1Click:Connect(function()
    if not v48("AutoLoad", 0.3) then return end
    v89(v167.AutoLoadButton)
    v20.AutoLoadEnabled = not v20.AutoLoadEnabled
    local v296 = v20.AutoLoadEnabled and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    if _G.UU.ButtonStates[v167.AutoLoadButton] then _G.UU.ButtonStates[v167.AutoLoadButton].BaseColor = v296 end
    v43(v167.AutoLoadButton, v39.Medium, { BackgroundColor3 = v296 })
    v167.AutoLoadButton.Text = "Auto Load: " .. (v20.AutoLoadEnabled and "ON" or "OFF")
    local v290, v291
    if v20.AutoLoadEnabled then
        if v20.SavedCode and v20.SavedCode ~= "" then
            v290, v291 = "Auto-load enabled", Color3.fromRGB(50, 220, 100)
        else
            v290, v291 = "No code to auto-load", Color3.fromRGB(220, 50, 50)
        end
    else
        v290, v291 = "Auto-load disabled", Color3.fromRGB(180, 180, 180)
    end
    v167.Status.Text = "Status: " .. v290
    v43(v167.Status, v39.Fast, { TextColor3 = v291 })
    task.wait(2)
    if v167.Status.Text:match("enabled") or v167.Status.Text:match("disabled") or v167.Status.Text:match("code") then
        v167.Status.Text = "Status: Ready"
        v43(v167.Status, v39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
    v33()
end)

v167.LoadStringBox:GetPropertyChangedSignal("Text"):Connect(function()
    if _G.UU.Threads.SaveCode then
        pcall(task.cancel, _G.UU.Threads.SaveCode)
        _G.UU.Threads.SaveCode = nil
    end
    _G.UU.Threads.SaveCode = task.delay(1.0, function()
        _G.UU.Threads.SaveCode = nil
        v20.SavedCode = v167.LoadStringBox.Text
        v33()
        v167.Status.Text = "Status: Code auto-saved ✓"
        v43(v167.Status, v39.Fast, { TextColor3 = Color3.fromRGB(100, 200, 255) })
        task.wait(2)
        if v167.Status.Text == "Status: Code auto-saved ✓" then
            v167.Status.Text = "Status: Ready"
            v43(v167.Status, v39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
        end
    end)
    v92(v167.LoadStringBox, v167.LineNumbers, v167.LoadStringScrollFrame, v167.LineNumbersScrollFrame)
end)

v167.LoadStringScrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    v167.LineNumbersScrollFrame.CanvasPosition = Vector2.new(0, v167.LoadStringScrollFrame.CanvasPosition.Y)
end)

v168.KeybindButton.MouseButton1Click:Connect(function()
    if not v48("Keybind", 0.5) or v20.IsChangingKeybind then return end
    v89(v168.KeybindButton)
    v20.IsChangingKeybind = true
    v168.KeybindButton.Text = "Press any key..."
    v168.Status.Text = "Waiting for input..."
    v43(v168.Status, v39.Fast, { TextColor3 = Color3.fromRGB(255, 200, 100) })
    v168.KeybindButton.Active = false
    local v334
    local v335 = task.delay(5, function()
        _G.UU.Threads.KeybindTimeout = nil
        if v334 then v334:Disconnect() end
        v20.IsChangingKeybind = false
        v168.KeybindButton.Active = true
        v168.KeybindButton.Text = "Toggle Keybind: " .. (v21[v20.Keybind] or v20.Keybind.Name)
        v168.Status.Text = "Timeout - Click again to retry"
        v43(v168.Status, v39.Fast, { TextColor3 = Color3.fromRGB(255, 100, 100) })
        task.wait(2)
        if v168.Status.Text:match("Timeout") then
            v168.Status.Text = "Click the button above to change your toggle keybind."
            v43(v168.Status, v39.Fast, { TextColor3 = Color3.fromRGB(150, 150, 150) })
        end
    end)
    _G.UU.Threads.KeybindTimeout = v335
    v334 = v3.InputBegan:Connect(function(v110, v336)
        if v110.UserInputType == Enum.UserInputType.Keyboard and not v336 then
            if _G.UU.Threads.KeybindTimeout then
                pcall(task.cancel, _G.UU.Threads.KeybindTimeout)
                _G.UU.Threads.KeybindTimeout = nil
            end
            v20.Keybind = v110.KeyCode
            local v275 = v21[v110.KeyCode] or v110.KeyCode.Name
            v168.KeybindButton.Text = "Toggle Keybind: " .. v275
            v168.Status.Text = "Keybind changed successfully!"
            v43(v168.Status, v39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
            v33()
            v168.KeybindButton.Active = true
            v334:Disconnect()
            task.delay(0.1, function() v20.IsChangingKeybind = false end)
            task.wait(1.5)
            if v168.Status.Text:match("successfully") then
                v168.Status.Text = "Click the button above to change your toggle keybind."
                v43(v168.Status, v39.Fast, { TextColor3 = Color3.fromRGB(150, 150, 150) })
            end
        end
    end)
end)

local function v337(v150)
    if v20.CurrentTab == v150 then return end
    if not v48("Tab", 0.15) then return end
    v20.CurrentTab = v150
    v33()
    for v338, v339 in pairs(v148) do
        if v338 == v150 then
            v339.Visible = true
            v339.Position = UDim2.new(0, 15, 0, 0)
            v43(v339, v39.Smooth, { Position = UDim2.new(0, 5, 0, 0) })
        else
            v339.Visible = false
        end
    end
    for v338, v340 in pairs(v147) do
        local v341 = v338 == v150
        v43(v340.Button, v39.Fast, { BackgroundColor3 = v341 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(35, 35, 42) })
        v43(v340.Icon, v39.Fast, { TextColor3 = v341 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180), TextSize = v341 and 20 or 18 })
        v43(v340.Label, v39.Fast, { TextColor3 = v341 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180) })
    end
end

for v160, v161 in ipairs(v159) do
    if v147[v161.name] then
        local v150 = v161.name
        v147[v150].Button.MouseButton1Click:Connect(function() v337(v150) end)
    end
end

local v342 = {}
local v343 = false

local function v344()
    if v343 or #v342 == 0 then return end
    v343 = true
    local v345 = table.remove(v342, 1)
    v345()
    task.wait(0.05)
    v343 = false
    if #v342 > 0 then v344() end
end

local function v346(v345)
    table.insert(v342, v345)
    v344()
end

local function v347(v59, v60)
    local v348 = v55.Width * v60
    local v349 = v55.Height * v60
    local v350 = math.max(0, (v59.X - v348) / 2)
    local v351 = math.max(0, (v59.Y - v349) / 2)
    return v350, v351
end

local function v352(v59, v60)
    local v353 = math.floor(60 * v60)
    local v350 = math.max(0, (v59.X - v353) / 2)
    local v351 = math.max(0, math.min(30, v59.Y - v353))
    return v353, v350, v351
end

local function v354(v355)
    if not v56 then return end
    v43(v56, v39.Smooth, { Scale = v355 })
    v57 = v355
    if v136.Visible and v20.SavedReopenPosition then
        v136.Position = UDim2.new(0, v20.SavedReopenPosition.X, 0, v20.SavedReopenPosition.Y)
    end
    v137.TextSize = math.floor(24 * v355)
end

local v356 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
local v357 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, false, 0)

local function v358()
    if not v48("UI", 0.6) then return end
    v346(function()
        if v129.Visible then
            local currentUIPosX = v129.Position.X.Offset
            local currentUIPosY = v129.Position.Y.Offset
            v20.SavedUIPosition = { X = currentUIPosX, Y = currentUIPosY }
            
            v129.Size = UDim2.new(0, v55.Width, 0, v55.Height)
            local v359 = v43(v56, v357, { Scale = 0 })
            v359.Completed:Wait()
            v129.Visible = false
            v56.Scale = 0
            v33()

            local v180 = v54()
            local v353 = math.floor(60 * v57)
            local savedReopenX, savedReopenY
            if v20.SavedReopenPosition then
                savedReopenX = v20.SavedReopenPosition.X
                savedReopenY = v20.SavedReopenPosition.Y
            else
                local _, defX, defY = v352(v180, v57)
                savedReopenX = defX
                savedReopenY = defY
            end
            
            v136.Size = UDim2.new(0, 0, 0, 0)
            v136.Position = UDim2.new(0, savedReopenX, 0, savedReopenY)
            v136.ImageTransparency = 1
            v137.TextTransparency = 1
            v136.Rotation = -180
            v136.Visible = true

            local v360 = v2:Create(v136, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, v353, 0, v353),
                Position = UDim2.new(0, savedReopenX, 0, savedReopenY),
                ImageTransparency = 0,
                Rotation = 0,
            })
            local v361 = v2:Create(v137, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0,
            })
            v360:Play()
            task.delay(0.15, function() v361:Play() end)
            v360.Completed:Wait()
        else
            if v143 then v143:Disconnect(); v143 = nil end

            local currentReopenX = v136.Position.X.Offset
            local currentReopenY = v136.Position.Y.Offset
            v20.SavedReopenPosition = { X = currentReopenX, Y = currentReopenY }
            
            local v362 = v136.Size.X.Offset
            local v363 = v136.Position

            local v364 = v2:Create(v136, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0, currentReopenX, 0, currentReopenY),
                ImageTransparency = 1,
                Rotation = 90,
            })
            local v365 = v2:Create(v137, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
            })
            v365:Play()
            v364:Play()
            v364.Completed:Wait()

            v136.Visible = false
            v136.Rotation = 0
            v136.ImageTransparency = 0
            v137.TextTransparency = 0
            v33()

            v129.Visible = true
            v129.Size = UDim2.new(0, v55.Width, 0, v55.Height)
            v56.Scale = 0
            local savedUIX, savedUIY
            if v20.SavedUIPosition then
                savedUIX = v20.SavedUIPosition.X
                savedUIY = v20.SavedUIPosition.Y
            else
                local defX, defY = v347(v54(), v57)
                savedUIX = defX
                savedUIY = defY
            end
            v129.Position = UDim2.new(0, savedUIX, 0, savedUIY)
            local v366 = v43(v56, v356, { Scale = v57 })
            v366.Completed:Wait()
        end
    end)
end

v133.MouseButton1Click:Connect(v358)
v133.MouseEnter:Connect(function() v43(v133, v39.Fast, { BackgroundColor3 = Color3.fromRGB(240, 70, 70), Size = UDim2.new(0, 34, 0, 34), Rotation = 90 }) end)
v133.MouseLeave:Connect(function() v43(v133, v39.Fast, { BackgroundColor3 = Color3.fromRGB(220, 50, 50), Size = UDim2.new(0, 30, 0, 30), Rotation = 0 }) end)
v133.MouseButton1Down:Connect(function() v43(v133, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 28, 0, 28) }) end)
v133.MouseButton1Up:Connect(function() v43(v133, v39.Fast, { Size = UDim2.new(0, 30, 0, 30) }) end)

v136.MouseButton1Click:Connect(function() if not v142 then v358() end end)

v136.MouseEnter:Connect(function()
    if not v138 then
        local v353 = math.floor(60 * v57)
        v43(v136, v39.Medium, { Size = UDim2.new(0, math.floor(v353 * 1.17), 0, math.floor(v353 * 1.17)) })
        if v143 then v143:Disconnect() end
        v143 = v5.RenderStepped:Connect(function(v367)
            if v136.Visible then
                v136.Rotation = (v136.Rotation + (v367 * 180)) % 360
            else
                if v143 then v143:Disconnect(); v143 = nil end
            end
        end)
    end
end)
v136.MouseLeave:Connect(function()
    if v143 then v143:Disconnect(); v143 = nil end
    if not v138 then
        local v353 = math.floor(60 * v57)
        v43(v136, v39.Medium, { Size = UDim2.new(0, v353, 0, v353), Rotation = 0 })
    end
end)
v136.MouseButton1Down:Connect(function()
    if not v138 then
        local v353 = math.floor(60 * v57)
        v43(v136, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, math.floor(v353 * 0.92), 0, math.floor(v353 * 0.92)) })
    end
end)
v136.MouseButton1Up:Connect(function()
    if not v138 then
        local v353 = math.floor(60 * v57)
        v43(v136, v39.Fast, { Size = UDim2.new(0, v353, 0, v353) })
    end
end)

table.insert(_G.UU.Connections, v3.InputBegan:Connect(function(v110, v336)
    if not v336 and v110.KeyCode == v20.Keybind and not v20.IsChangingKeybind then
        v358()
    end
end))

local v368 = Vector2.new(0, 0)
local v369 = false

local function v370()
    if v369 then return end
    v369 = true
    task.delay(0.1, function()
        v369 = false
        local v371 = v54()
        if math.abs(v371.X - v368.X) < 2 and math.abs(v371.Y - v368.Y) < 2 then return end
        v368 = v371
        local v372 = v58(v371)
        if _G.UU.UI.ResolutionLabel then _G.UU.UI.ResolutionLabel.Text = string.format("Resolution: %dx%d", v371.X, v371.Y) end
        if _G.UU.UI.DeviceLabel then _G.UU.UI.DeviceLabel.Text = "Device: " .. v18() end
        v354(v372)
        v20.SavedUIPosition = nil
        v20.SavedReopenPosition = nil
        
        local v350, v351 = v347(v371, v372)
        v129.Position = UDim2.new(0, v350, 0, v351)
        
        local v353 = math.floor(60 * v57)
        v350 = math.max(0, (v371.X - v353) / 2)
        v351 = math.max(0, math.min(30, v371.Y - v353))
        v136.Size = UDim2.new(0, v353, 0, v353)
        v136.Position = UDim2.new(0, v350, 0, v351)
        
        v33()
    end)
end

if workspace.CurrentCamera then
    table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v370))
end
table.insert(_G.UU.Connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        table.insert(_G.UU.Connections, workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v370))
    end
end))

table.insert(_G.UU.Connections, v5.RenderStepped:Connect(function()
    v285 = v285 + 1
    local v373 = tick()

    if v373 - v284 >= 1 then
        v283 = math.floor(v285 / (v373 - v284))
        v285 = 0
        v284 = v373
        if v162.FPSLabel then v162.FPSLabel.Text = "FPS: " .. v283 end
        table.remove(v281, 1); table.insert(v281, v283)
        local v374, v375, v376 = math.huge, 0, 0
        for v377, v378 in ipairs(v281) do
            v374 = math.min(v374, v378)
            v375 = math.max(v375, v378)
            v376 = v376 + v378
        end
        local v379 = math.floor(v376 / #v281)
        if v165.FPSStats then
            v165.FPSStats.Current.Text = "Current: " .. v283
            v165.FPSStats.Avg.Text = "Average: " .. v379
            v165.FPSStats.MinMax.Text = string.format("Min: %d | Max: %d", v374, v375)
        end
    end

    if v285 % 30 == 0 then
        local v380 = math.floor(v10:GetNetworkPing() * 1000)
        if v162.PingLabel then
            v162.PingLabel.Text = "Ping: " .. v380 .. " ms"
            v162.PingLabel.TextColor3 = v380 < 100 and Color3.fromRGB(0, 255, 0) or v380 < 200 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        table.remove(v282, 1); table.insert(v282, v380)
        local v381, v382, v383 = math.huge, 0, 0
        for v377, v384 in ipairs(v282) do
            v381 = math.min(v381, v384)
            v382 = math.max(v382, v384)
            v383 = v383 + v384
        end
        local v385 = math.floor(v383 / #v282)
        if v165.PingStats then
            v165.PingStats.Current.Text = "Current: " .. v380 .. "ms"
            v165.PingStats.Avg.Text = "Average: " .. v385 .. "ms"
            v165.PingStats.MinMax.Text = string.format("Min: %dms | Max: %dms", v381, v382)
            local v386, v387
            if v380 < 50 then
                v386, v387 = "Excellent", Color3.fromRGB(50, 220, 100)
            elseif v380 < 100 then
                v386, v387 = "Good", Color3.fromRGB(100, 200, 255)
            elseif v380 < 200 then
                v386, v387 = "Fair", Color3.fromRGB(255, 200, 100)
            elseif v380 < 300 then
                v386, v387 = "Poor", Color3.fromRGB(255, 150, 50)
            else
                v386, v387 = "Very Poor", Color3.fromRGB(220, 50, 50)
            end
            v165.PingStats.Quality.Text = v386
            v165.PingStats.Quality.TextColor3 = v387
        end
    end
end))

local v388 = v36()

local function v389(v73, v390)
    local v296 = v390 and Color3.fromRGB(50, 220, 100) or Color3.fromRGB(220, 50, 50)
    v73.BackgroundColor3 = v296
    if _G.UU.ButtonStates[v73] then _G.UU.ButtonStates[v73].BaseColor = v296 end
end

if v388 then
    if v168.KeybindButton then v168.KeybindButton.Text = "Current Key: " .. (v21[v20.Keybind] or v20.Keybind.Name) end
    if v164.SpamInput then v164.SpamInput.Text = v20.SpamKey end
    if v167.LoadStringBox then v167.LoadStringBox.Text = v20.SavedCode end

    v325((v20.JumpDelay - 5) / 25)
    v326((v20.ClickDelay - 1) / 9)
    v327((v20.SpamDelay - 0.05) / 4.95)
    v328((v20.TargetFPS - 15) / 345)
    v292()

    v389(v167.AutoLoadButton, v20.AutoLoadEnabled)
    v167.AutoLoadButton.Text = "Auto Load: " .. (v20.AutoLoadEnabled and "ON" or "OFF")

    if v20.AutoRejoinEnabled then
        v389(v166.AutoRejoinToggle, true)
        v166.AutoRejoinToggle.Text = "Auto Rejoin: ON"
        v166.Status.Text = "Status: Enabled\n\nAutomatically rejoins the server when disconnected."
        v166.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        v310()
    end

    if v20.FPSUnlockEnabled and v279 then
        v389(v165.FPSUnlockToggle, true)
        v165.FPSUnlockToggle.Text = "FPS Unlock: ON"
        v165.FPSUnlockStatus.TextColor3 = Color3.fromRGB(50, 220, 100)
        v165.FPSUnlockStatus.Text = "Current Limit: " .. v20.TargetFPS .. " FPS (Custom)"
        pcall(setfpscap, v20.TargetFPS)
    else
        v389(v165.FPSUnlockToggle, false)
        v165.FPSUnlockToggle.Text = "FPS Unlock: OFF"
    end

    v389(v163.JumpToggle, v20.JumpEnabled)
    v163.JumpToggle.Text = "Auto Jump: " .. (v20.JumpEnabled and "ON" or "OFF")
    if v20.JumpEnabled then task.wait(0.1); v297() end

    v389(v163.ClickToggle, v20.ClickEnabled)
    v163.ClickToggle.Text = "Auto Click: " .. (v20.ClickEnabled and "ON" or "OFF")
    if v20.ClickEnabled then task.wait(0.1); v299() end

    if v20.AutoSpamEnabled and v22[v20.SpamKey] then
        v389(v164.AutoSpamToggle, true)
        v164.AutoSpamToggle.Text = "ON"
        v164.Status.Text = "System Status: Spamming " .. v20.SpamKey
        v164.Status.TextColor3 = Color3.fromRGB(50, 220, 100)
        task.wait(0.1); v305()
    else
        v20.AutoSpamEnabled = false
        v389(v164.AutoSpamToggle, false)
        v164.AutoSpamToggle.Text = "OFF"
    end

    v288()
else
    v325(0.2); v326(0.22); v327(0.01); v328(0.13)
    v292()
    v389(v163.JumpToggle, false); v163.JumpToggle.Text = "Auto Jump: OFF"
    v389(v163.ClickToggle, false); v163.ClickToggle.Text = "Auto Click: OFF"
    v389(v164.AutoSpamToggle, false); v164.AutoSpamToggle.Text = "OFF"
    v389(v165.FPSUnlockToggle, false); v165.FPSUnlockToggle.Text = "FPS Unlock: OFF"
    v165.FPSUnlockStatus.Text = "Current Limit: 60 FPS (Default)"
    v389(v167.AutoLoadButton, false); v167.AutoLoadButton.Text = "Auto Load: OFF"
    v288()
end

task.spawn(function()
    pcall(function()
        if _G.UU.UI.PlayerImage then
            _G.UU.UI.PlayerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. v12 .. "&w=420&h=420"
        end
        if _G.UU.UI.GameName and _G.UU.UI.GameImage then
            local v391 = v8:GetProductInfo(game.PlaceId)
            _G.UU.UI.GameName.Text = v391.Name
            if v391.IconImageAssetId and v391.IconImageAssetId ~= 0 then
                _G.UU.UI.GameImage.Image = "rbxthumb://type=Asset&id=" .. v391.IconImageAssetId .. "&w=420&h=420"
            end
        end
    end)
end)

v92(v167.LoadStringBox, v167.LineNumbers, v167.LoadStringScrollFrame, v167.LineNumbersScrollFrame)

v128.Destroying:Connect(function()
    for v338, v14 in pairs(_G.UU.Threads) do
        if v14 and typeof(v14) == "thread" and coroutine.status(v14) ~= "dead" then
            pcall(task.cancel, v14)
        end
        _G.UU.Threads[v338] = nil
    end
    if v309 then pcall(function() v309:Disconnect() end); v309 = nil end
    if v143 then pcall(function() v143:Disconnect() end); v143 = nil end
end)

for v338, v339 in pairs(v148) do v339.Visible = false end
v20.CurrentTab = nil

local v392 = v54()
v368 = v392
v57 = v58(v392)

task.wait(0.1)
v129.Visible = true
v129.Size = UDim2.new(0, v55.Width, 0, v55.Height)
v56.Scale = 0

local v393 = v392.X
local v394 = v392.Y
local v350, v351
if v20.SavedUIPosition then
    v350 = v20.SavedUIPosition.X
    v351 = v20.SavedUIPosition.Y
else
    v350, v351 = v347(v392, v57)
end
v129.Position = UDim2.new(0, v350, 0, v351)

local v353
if v20.SavedReopenPosition then
    v350 = v20.SavedReopenPosition.X
    v351 = v20.SavedReopenPosition.Y
    v353 = math.floor(60 * v57)
else
    v353, v350, v351 = v352(v392, v57)
end
v136.Size = UDim2.new(0, v353, 0, v353)
v136.Position = UDim2.new(0, v350, 0, v351)
v136.Visible = false
v136.ImageTransparency = 0
v137.TextTransparency = 0

local v395 = v43(v56, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = v57 })
v395.Completed:Wait()

v337("Home")
v33()

if queue_on_teleport and not _G.UU.TeleportQueued then
    _G.UU.TeleportQueued = true
    pcall(function()
        queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/6942x/UniversalUtility/main/Init.lua", true))()')
    end)
end

_G.UU.Loaded = true
_G.UU.LoadLock = false

task.defer(function()
    if v388 and v20.AutoLoadEnabled and v20.SavedCode and v20.SavedCode ~= "" then
        local v320, v321 = v318(v20.SavedCode)
        if v320 then
            v167.Status.Text = "System Status: Auto-load executed successfully"
            v43(v167.Status, v39.Fast, { TextColor3 = Color3.fromRGB(50, 220, 100) })
        else
            v167.Status.Text = "System Status: Auto-load failed - " .. v321
            v43(v167.Status, v39.Fast, { TextColor3 = Color3.fromRGB(220, 50, 50) })
        end
        task.wait(3)
        v167.Status.Text = "System Status: Ready to execute"
        v43(v167.Status, v39.Fast, { TextColor3 = Color3.fromRGB(180, 180, 180) })
    end
end)

return _G.UU
