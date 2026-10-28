local t = game:GetService("Players")
local t1 = game:GetService("RunService")
local t2 = game:GetService("HttpService")
local t3 = t.LocalPlayer
assert(t3, "Position Lock requires the game client")

local t4 = type(getgenv) == "function" and getgenv() or _G
local t5 = "PositionLock_" .. t3.UserId
local t6 = t4[t5]
if type(t6) == "table" and type(t6.Stop) == "function" then
    pcall(t6.Stop)
end

local t7 = {
    Alive = true,
    Connections = {},
    AutoHide = false,
    MenuKey = "RightControl",
    Locked = true,
    Rotation = true,
    Velocity = true,
    Freeze = false,
    Tolerance = 1,
    Interval = 0.1,
    Elapsed = 0,
    Display = 0,
    Corrections = 0,
    Anchored = {},
}
local t8 = CFrame.new(
    37853.582,
    -60.4120293,
    1252.32764,
    -0.999987721,
    1.65771926e-05,
    0.00495962985,
    1.69502164e-05,
    1,
    7.7791512e-05,
    -0.00495963171,
    7.78790563e-05,
    -0.999987721
)
local t9
local t10
local t11
local t12
local t13 = "PositionLock_" .. t3.UserId

local t14 = "PositionLock_" .. game.PlaceId .. "_" .. t3.UserId .. ".json"
local t15 = t14 .. "_Settings"
local t16
local t17
local t18 = 0
local t19 = 0
local t20 = type(writefile) == "function" and type(readfile) == "function"

local function t21(t22)
    return type(t22) == "number" and t22 == t22 and math.abs(t22) < math.huge
end

local function t23(t24)
    if type(t24) ~= "table" then
        return false
    end
    for t25, t26 in ipairs({ "Locked", "Rotation", "Velocity", "Freeze", "AutoHide" }) do
        if type(t24[t26]) == "boolean" then
            t7[t26] = t24[t26]
        end
    end
    if t21(t24.Tolerance) then
        t7.Tolerance = math.clamp(t24.Tolerance, 0.1, 10)
    end
    if t21(t24.Interval) then
        t7.Interval = math.clamp(t24.Interval, 0.03, 2)
    end
    if type(t24.MenuKey) == "string" then
        local t27, t28 = pcall(function()
            return Enum.KeyCode[t24.MenuKey]
        end)
        if t27 and t28 and t24.MenuKey ~= "Unknown" then
            t7.MenuKey = t24.MenuKey
        end
    end
    if type(t24.Target) == "table" and #t24.Target == 12 then
        local t27 = true
        for t25 = 1, 12 do
            if not t21(t24.Target[t25]) then
                t27 = false
            end
        end
        if t27 then
            local t29, t30 = pcall(CFrame.new, table.unpack(t24.Target))
            if t29 then
                t8 = t30
            end
        end
    end
    return true
end

local t31 = false
if type(readfile) == "function" then
    for t25, t32 in ipairs({ t14, t14 .. ".bak" }) do
        local t33, t24 = pcall(function()
            return t2:JSONDecode(readfile(t32))
        end)
        if t33 and t23(t24) then
            t31 = true
            break
        end
    end
end
if not t31 then
    t23(t4[t15])
end

local function t34(t35)
    if t9 and t9.Options and t9.Options.MenuKey then
        local t22 = t9.Options.MenuKey.Value
        local t27, t28 = pcall(function()
            return Enum.KeyCode[t22]
        end)
        if t27 and t28 and t22 ~= "Unknown" then
            t7.MenuKey = t22
        end
    end
    local t24 = { Version = 1, Target = { t8:GetComponents() } }
    for t25, t26 in ipairs({
        "Locked",
        "Rotation",
        "Velocity",
        "Freeze",
        "AutoHide",
        "Tolerance",
        "Interval",
        "MenuKey",
    }) do
        t24[t26] = t7[t26]
    end
    t4[t15] = t24
    local t36 = t2:JSONEncode(t24)
    if t36 ~= t17 then
        t17 = t36
        t18 = os.clock()
    end
    if t36 == t16 or not t20 or not t35 and os.clock() - t18 < 0.4 then
        return
    end
    local t37, t38 = pcall(function()
        if t16 then
            writefile(t14 .. ".bak", t16)
        end
        writefile(t14, t36)
    end)
    if t37 then
        t16 = t36
    else
        warn("[Position Lock] Settings could not be saved: " .. tostring(t38))
    end
end

local function t39(t40, t41)
    local t42 = t40:Connect(t41)
    t7.Connections[#t7.Connections + 1] = t42
    return t42
end

local function t43()
    for t44, t22 in pairs(t7.Anchored) do
        pcall(function()
            t44.Anchored = t22
        end)
        t7.Anchored[t44] = nil
    end
end

local function t45()
    if not t7.Alive then
        return
    end
    pcall(t34, true)
    t7.Alive = false
    t7.Locked = false
    for t25, t42 in ipairs(t7.Connections) do
        pcall(t42.Disconnect, t42)
    end
    t43()
    if t9 and not t9.Unloaded then
        pcall(t9.Unload, t9)
    end
    if t4[t5] == t7 then
        t4[t5] = nil
    end
end

t7.Stop = t45
t4[t5] = t7

local function t44()
    local t46 = t3.Character
    local t47 = t46 and t46:FindFirstChildOfClass("Humanoid")
    local t48 = t46 and t46:FindFirstChild("HumanoidRootPart")
    if not t48 or not t47 or t47.Health <= 0 then
        return nil
    end
    if not t12 then
        t12 = t48.CFrame
    end
    return t48
end

local function t49(t35)
    local t48 = t44()
    if not t48 then
        return nil
    end
    local t50 = (t48.Position - t8.Position).Magnitude
    local t51 = 0
    if t7.Rotation then
        local t52
        t52, t51 = t48.CFrame.Rotation:ToObjectSpace(t8.Rotation):ToAxisAngle()
    end
    if t35 or t50 > t7.Tolerance or math.abs(t51) > math.rad(2) then
        t48.CFrame = t7.Rotation and t8 or CFrame.new(t8.Position) * t48.CFrame.Rotation
        t7.Corrections = t7.Corrections + 1
    end
    if t7.Velocity then
        t48.AssemblyLinearVelocity = Vector3.zero
        t48.AssemblyAngularVelocity = Vector3.zero
    end
    if t7.Freeze then
        if t7.Anchored[t48] == nil then
            t7.Anchored[t48] = t48.Anchored
        end
        t48.Anchored = true
    end
    return (t48.Position - t8.Position).Magnitude
end

local t53, t38 = xpcall(function()
    assert(type(loadstring) == "function", "This environment cannot load Obsidian")
    local t54 = game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua")
    if not t7.Alive then
        return
    end
    local t55, t56 = loadstring(t54, "=PositionLock.Obsidian")
    assert(t55, t56)
    t9 = t55()
    if not t7.Alive then
        pcall(t9.Unload, t9)
        return
    end
    local t57 = t9:CreateWindow({
        Title = "Position Lock",
        Footer = "Automatic position correction",
        Icon = "map-pin",
        Center = true,
        AutoShow = not t7.AutoHide,
        ShowCustomCursor = false,
        ToggleKeybind = Enum.KeyCode[t7.MenuKey],
    })
    if not t7.Alive then
        pcall(t9.Unload, t9)
        return
    end
    if t9.ScreenGui then
        t9.ScreenGui.Name = t13
        t39(t9.ScreenGui.Destroying, t45)
    end
    t9:OnUnload(t45)
    local t58 = t57:AddTab("Position", "crosshair")
    local t59 = t57:AddTab("Settings", "settings")
    local t60 = t58:AddLeftGroupbox("Position Lock")
    local t61 = t58:AddRightGroupbox("Live Status")
    local t62 = t59:AddLeftGroupbox("Behavior")
    local t63 = t59:AddRightGroupbox("Interface")
    t10 = t61:AddLabel({ Text = "Waiting for character", DoesWrap = true })
    t61:AddLabel({ Text = "Target: 37853.582, -60.412, 1252.328", DoesWrap = true })
    t11 = t60:AddToggle("PositionLocked", {
        Text = "Lock Position",
        Default = t7.Locked,
        Callback = function(t22)
            t7.Locked = t22
            t7.Elapsed = t7.Interval
            if not t22 then
                t43()
            end
        end,
    })
    t60:AddButton({
        Text = "Teleport Now",
        Func = function()
            t49(true)
        end,
    })
    t60:AddButton({
        Text = "Use Current Position",
        Func = function()
            local t48 = t44()
            if t48 then
                t8 = t48.CFrame
                t9:Notify({
                    Title = "Position Lock",
                    Description = "Target updated to your current position",
                    Time = 3,
                })
            end
        end,
    })
    t60:AddButton({
        Text = "Restore Original Target",
        Func = function()
            t8 = CFrame.new(
                37853.582,
                -60.4120293,
                1252.32764,
                -0.999987721,
                1.65771926e-05,
                0.00495962985,
                1.69502164e-05,
                1,
                7.7791512e-05,
                -0.00495963171,
                7.78790563e-05,
                -0.999987721
            )
            t7.Elapsed = t7.Interval
        end,
    })
    t60:AddButton({
        Text = "Return to Starting Position",
        Func = function()
            local t48 = t44()
            if t48 and t12 then
                t11:SetValue(false)
                t48.CFrame = t12
                t48.AssemblyLinearVelocity = Vector3.zero
                t48.AssemblyAngularVelocity = Vector3.zero
            end
        end,
    })
    t62:AddSlider("DistanceTolerance", {
        Text = "Distance Tolerance (studs)",
        Default = t7.Tolerance,
        Min = 0.1,
        Max = 10,
        Rounding = 1,
        Callback = function(t22)
            t7.Tolerance = t22
        end,
    })
    t62:AddSlider("CheckInterval", {
        Text = "Check Interval (seconds)",
        Default = t7.Interval,
        Min = 0.03,
        Max = 2,
        Rounding = 2,
        Callback = function(t22)
            t7.Interval = t22
        end,
    })
    t62:AddToggle("MatchRotation", {
        Text = "Lock Rotation",
        Default = t7.Rotation,
        Callback = function(t22)
            t7.Rotation = t22
        end,
    })
    t62:AddToggle("ResetVelocity", {
        Text = "Stop Drift and Falling",
        Default = t7.Velocity,
        Callback = function(t22)
            t7.Velocity = t22
        end,
    })
    t62:AddToggle("FreezeRoot", {
        Text = "Freeze While Locked",
        Default = t7.Freeze,
        Callback = function(t22)
            t7.Freeze = t22
            if not t22 then
                t43()
            end
        end,
    })
    t63:AddLabel("Menu Key"):AddKeyPicker("MenuKey", { Default = t7.MenuKey, NoUI = true, Text = "Menu Key" })
    t9.ToggleKeybind = t9.Options.MenuKey
    t63:AddToggle("AutoHideUI", {
        Text = "Auto Hide UI on Startup",
        Default = t7.AutoHide,
        Callback = function(t22)
            t7.AutoHide = t22
        end,
    })
    t63:AddLabel({
        Text = t20 and "Settings save automatically for this player and game."
            or "File access unavailable: settings persist only in this session.",
        DoesWrap = true,
    })
    t63:AddButton({ Text = "Uninject", Func = t45 })
    t39(t3.CharacterRemoving, function()
        t43()
    end)
    t39(t3.CharacterAdded, function()
        t7.Elapsed = t7.Interval
    end)
    t39(t1.Heartbeat, function(t64)
        if not t7.Alive then
            return
        end
        t19 = t19 + t64
        if t19 >= 0.2 then
            t19 = 0
            pcall(t34, false)
        end
        t7.Elapsed = t7.Elapsed + t64
        t7.Display = t7.Display + t64
        if t7.Elapsed < t7.Interval then
            return
        end
        t7.Elapsed = 0
        local t65, t66 = pcall(function()
            if t7.Locked then
                return t49(false)
            end
            local t48 = t44()
            return t48 and (t48.Position - t8.Position).Magnitude
        end)
        if t7.Display >= 0.5 then
            t7.Display = 0
            local t67 = not t65 and ("Correction failed: " .. tostring(t66))
                or t66 == nil and "Waiting for a living character"
                or string.format(
                    "%s\nDistance: %.2f studs\nCorrections: %d\nTarget: %.3f, %.3f, %.3f",
                    t7.Locked and "Position locked" or "Lock paused",
                    t66,
                    t7.Corrections,
                    t8.X,
                    t8.Y,
                    t8.Z
                )
            t10:SetText(t67)
        end
    end)
    t34(true)
    if t7.AutoHide then
        t9:Notify({
            Title = "Position Lock",
            Description = "Interface hidden. Press " .. t7.MenuKey .. " to open it.",
            Time = 7,
        })
    end
    if t7.Locked then
        t49(false)
    end
end, debug.traceback)

if not t53 then
    t45()
    warn("[Position Lock] " .. tostring(t38))
    pcall(function()
        game:GetService("StarterGui"):SetCore(
            "SendNotification",
            { Title = "Position Lock failed", Text = tostring(t38):sub(1, 180), Duration = 10 }
        )
    end)
end
