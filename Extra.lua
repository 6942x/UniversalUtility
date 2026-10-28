local t = game:GetService("Players")
local t1 = game:GetService("RunService")
local t2 = t.LocalPlayer
assert(t2, "Position Lock requires the game client")

local t3 = type(getgenv) == "function" and getgenv() or _G
local t4 = "PositionLock_" .. t2.UserId
local t5 = t3[t4]
if type(t5) == "table" and type(t5.Stop) == "function" then
    pcall(t5.Stop)
end

local t6 = {
    Alive = true,
    Connections = {},
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
local t7 = CFrame.new(
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
local t8
local t9
local t10
local t11
local t12 = "PositionLock_" .. t2.UserId

local function t13(t14, t15)
    local t16 = t14:Connect(t15)
    t6.Connections[#t6.Connections + 1] = t16
    return t16
end

local function t17()
    for t18, t19 in pairs(t6.Anchored) do
        pcall(function()
            t18.Anchored = t19
        end)
        t6.Anchored[t18] = nil
    end
end

local function t20()
    if not t6.Alive then
        return
    end
    t6.Alive = false
    t6.Locked = false
    for t21, t16 in ipairs(t6.Connections) do
        pcall(t16.Disconnect, t16)
    end
    t17()
    if t8 and not t8.Unloaded then
        pcall(t8.Unload, t8)
    end
    if t3[t4] == t6 then
        t3[t4] = nil
    end
end

t6.Stop = t20
t3[t4] = t6

local function t18()
    local t22 = t2.Character
    local t23 = t22 and t22:FindFirstChildOfClass("Humanoid")
    local t24 = t22 and t22:FindFirstChild("HumanoidRootPart")
    if not t24 or not t23 or t23.Health <= 0 then
        return nil
    end
    if not t11 then
        t11 = t24.CFrame
    end
    return t24
end

local function t25(t26)
    local t24 = t18()
    if not t24 then
        return nil
    end
    local t27 = (t24.Position - t7.Position).Magnitude
    local t28 = 0
    if t6.Rotation then
        local t29
        t29, t28 = t24.CFrame.Rotation:ToObjectSpace(t7.Rotation):ToAxisAngle()
    end
    if t26 or t27 > t6.Tolerance or math.abs(t28) > math.rad(2) then
        t24.CFrame = t6.Rotation and t7 or CFrame.new(t7.Position) * t24.CFrame.Rotation
        t6.Corrections = t6.Corrections + 1
    end
    if t6.Velocity then
        t24.AssemblyLinearVelocity = Vector3.zero
        t24.AssemblyAngularVelocity = Vector3.zero
    end
    if t6.Freeze then
        if t6.Anchored[t24] == nil then
            t6.Anchored[t24] = t24.Anchored
        end
        t24.Anchored = true
    end
    return (t24.Position - t7.Position).Magnitude
end

local t30, t31 = xpcall(function()
    assert(type(loadstring) == "function", "This environment cannot load Obsidian")
    local t32 = game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua")
    if not t6.Alive then
        return
    end
    local t33, t34 = loadstring(t32, "=PositionLock.Obsidian")
    assert(t33, t34)
    t8 = t33()
    if not t6.Alive then
        pcall(t8.Unload, t8)
        return
    end
    local t35 = t8:CreateWindow({
        Title = "Position Lock",
        Footer = "Automatic position correction",
        Icon = "map-pin",
        Center = true,
        AutoShow = true,
        ShowCustomCursor = false,
        ToggleKeybind = Enum.KeyCode.RightControl,
    })
    if not t6.Alive then
        pcall(t8.Unload, t8)
        return
    end
    if t8.ScreenGui then
        t8.ScreenGui.Name = t12
        t13(t8.ScreenGui.Destroying, t20)
    end
    t8:OnUnload(t20)
    local t36 = t35:AddTab("Position", "crosshair")
    local t37 = t35:AddTab("Settings", "settings")
    local t38 = t36:AddLeftGroupbox("Position Lock")
    local t39 = t36:AddRightGroupbox("Live Status")
    local t40 = t37:AddLeftGroupbox("Behavior")
    local t41 = t37:AddRightGroupbox("Interface")
    t9 = t39:AddLabel({ Text = "Waiting for character", DoesWrap = true })
    t39:AddLabel({ Text = "Target: 37853.582, -60.412, 1252.328", DoesWrap = true })
    t10 = t38:AddToggle("PositionLocked", {
        Text = "Lock Position",
        Default = true,
        Callback = function(t19)
            t6.Locked = t19
            t6.Elapsed = t6.Interval
            if not t19 then
                t17()
            end
        end,
    })
    t38:AddButton({
        Text = "Teleport Now",
        Func = function()
            t25(true)
        end,
    })
    t38:AddButton({
        Text = "Use Current Position",
        Func = function()
            local t24 = t18()
            if t24 then
                t7 = t24.CFrame
                t8:Notify({
                    Title = "Position Lock",
                    Description = "Target updated to your current position",
                    Time = 3,
                })
            end
        end,
    })
    t38:AddButton({
        Text = "Restore Original Target",
        Func = function()
            t7 = CFrame.new(
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
            t6.Elapsed = t6.Interval
        end,
    })
    t38:AddButton({
        Text = "Return to Starting Position",
        Func = function()
            local t24 = t18()
            if t24 and t11 then
                t10:SetValue(false)
                t24.CFrame = t11
                t24.AssemblyLinearVelocity = Vector3.zero
                t24.AssemblyAngularVelocity = Vector3.zero
            end
        end,
    })
    t40:AddSlider("DistanceTolerance", {
        Text = "Distance Tolerance (studs)",
        Default = 1,
        Min = 0.1,
        Max = 10,
        Rounding = 1,
        Callback = function(t19)
            t6.Tolerance = t19
        end,
    })
    t40:AddSlider("CheckInterval", {
        Text = "Check Interval (seconds)",
        Default = 0.1,
        Min = 0.03,
        Max = 2,
        Rounding = 2,
        Callback = function(t19)
            t6.Interval = t19
        end,
    })
    t40:AddToggle("MatchRotation", {
        Text = "Lock Rotation",
        Default = true,
        Callback = function(t19)
            t6.Rotation = t19
        end,
    })
    t40:AddToggle("ResetVelocity", {
        Text = "Stop Drift and Falling",
        Default = true,
        Callback = function(t19)
            t6.Velocity = t19
        end,
    })
    t40:AddToggle("FreezeRoot", {
        Text = "Freeze While Locked",
        Default = false,
        Callback = function(t19)
            t6.Freeze = t19
            if not t19 then
                t17()
            end
        end,
    })
    t41:AddLabel("Menu Key")
        :AddKeyPicker("MenuKey", { Default = "RightControl", NoUI = true, Text = "Menu Key" })
    t8.ToggleKeybind = t8.Options.MenuKey
    t41:AddButton({ Text = "Uninject", Func = t20 })
    t13(t2.CharacterRemoving, function()
        t17()
    end)
    t13(t2.CharacterAdded, function()
        t6.Elapsed = t6.Interval
    end)
    t13(t1.Heartbeat, function(t42)
        if not t6.Alive then
            return
        end
        t6.Elapsed = t6.Elapsed + t42
        t6.Display = t6.Display + t42
        if t6.Elapsed < t6.Interval then
            return
        end
        t6.Elapsed = 0
        local t43, t44 = pcall(function()
            if t6.Locked then
                return t25(false)
            end
            local t24 = t18()
            return t24 and (t24.Position - t7.Position).Magnitude
        end)
        if t6.Display >= 0.5 then
            t6.Display = 0
            local t45 = not t43 and ("Correction failed: " .. tostring(t44))
                or t44 == nil and "Waiting for a living character"
                or string.format(
                    "%s\nDistance: %.2f studs\nCorrections: %d\nTarget: %.3f, %.3f, %.3f",
                    t6.Locked and "Position locked" or "Lock paused",
                    t44,
                    t6.Corrections,
                    t7.X,
                    t7.Y,
                    t7.Z
                )
            t9:SetText(t45)
        end
    end)
    t25(false)
end, debug.traceback)

if not t30 then
    t20()
    warn("[Position Lock] " .. tostring(t31))
    pcall(function()
        game:GetService("StarterGui"):SetCore(
            "SendNotification",
            { Title = "Position Lock failed", Text = tostring(t31):sub(1, 180), Duration = 10 }
        )
    end)
end
