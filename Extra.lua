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
	TPOnly = false,
	Rotation = true,
	Velocity = true,
	Freeze = false,
	AutoEquip = false,
	EquipAfterDeath = false,
	ToolName = "",
	Tolerance = 1,
	Interval = 0.1,
	RespawnDelay = 0,
	PeriodicReset = false,
	ResetMinutes = 5,
	Elapsed = 0,
	Display = 0,
	Corrections = 0,
	Anchored = {},
}
local t8
local t9
local t10
local t11
local t12
local t13 = t5

local function t94(t95)
	if typeof(t95) ~= "Instance" then
		return
	end
	for t96, t97 in ipairs(t95:GetChildren()) do
		if t97:IsA("ScreenGui") and t97.Name == t13 then
			pcall(t97.Destroy, t97)
		end
	end
end

pcall(t94, t3:FindFirstChildOfClass("PlayerGui"))
pcall(function()
	t94(game:GetService("CoreGui"))
end)
if type(gethui) == "function" then
	pcall(function()
		t94(gethui())
	end)
end

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
	for t25, t26 in ipairs({
		"Locked",
		"TPOnly",
		"Rotation",
		"Velocity",
		"Freeze",
		"AutoHide",
		"AutoEquip",
		"EquipAfterDeath",
		"PeriodicReset",
	}) do
		if type(t24[t26]) == "boolean" then
			t7[t26] = t24[t26]
		end
	end
	if type(t24.ToolName) == "string" then
		t7.ToolName = t24.ToolName
	end
	if t21(t24.Tolerance) then
		t7.Tolerance = math.clamp(t24.Tolerance, 0.1, 10)
	end
	if t21(t24.ResetMinutes) then
		t7.ResetMinutes = math.clamp(t24.ResetMinutes, 1, 180)
	end
	if t21(t24.RespawnDelay) then
		t7.RespawnDelay = math.clamp(t24.RespawnDelay, 0, 30)
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
	local t24 = { Version = 1, Target = t8 and { t8:GetComponents() } or nil }
	for t25, t26 in ipairs({
		"Locked",
		"TPOnly",
		"Rotation",
		"Velocity",
		"Freeze",
		"AutoHide",
		"Tolerance",
		"Interval",
		"RespawnDelay",
		"PeriodicReset",
		"ResetMinutes",
		"MenuKey",
		"AutoEquip",
		"EquipAfterDeath",
		"ToolName",
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
	if not t8 then
		t8 = t48.CFrame
	end
	if not t12 then
		t12 = t48.CFrame
	end
	return t48
end

local function t49(t35, t122)
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
	if t7.Freeze and not t122 then
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
	local t68 = t57:AddTab("Equipment", "backpack")
	local t59 = t57:AddTab("Settings", "settings")
	local t60 = t58:AddLeftGroupbox("Position Lock")
	local t61 = t58:AddRightGroupbox("Live Status")
	local t62 = t59:AddLeftGroupbox("Behavior")
	local t63 = t59:AddRightGroupbox("Interface")
	t10 = t61:AddLabel({ Text = "Waiting for character", DoesWrap = true })
	local t123, t124
	if t7.TPOnly then
		t7.Locked = false
	end
	t11 = t60:AddToggle("PositionLocked", {
		Text = "Lock Position",
		Default = t7.Locked,
		Callback = function(t22)
			t7.Locked = t22
			if t22 then
				t7.TPOnly = false
				if t123 and t123.Value then
					t123:SetValue(false)
				end
			end
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

	t123 = t60:AddToggle("TPOnly", {
		Text = "TP Only",
		Default = t7.TPOnly,
		Callback = function(t22)
			t7.TPOnly = t22
			if t22 then
				t11:SetValue(false)
				t43()
				t124 = nil
				t7.Elapsed = t7.Interval
			end
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
		Text = "Return to Starting Position",
		Func = function()
			local t48 = t44()
			if t48 and t12 then
				t11:SetValue(false)
				t123:SetValue(false)
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
	t62:AddSlider("RespawnDelay", {
		Text = "Respawn Delay (seconds)",
		Default = t7.RespawnDelay,
		Min = 0,
		Max = 30,
		Rounding = 0,
		Callback = function(t22)
			t7.RespawnDelay = t22
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
	local t69 = t68:AddLeftGroupbox("Tool Selection")
	local t70 = t69:AddLabel({ Text = "Select a tool from your backpack.", DoesWrap = true })
	local t71
	local t72 = {}
	local t73 = false
	local t74 = false
	local t75 = 0
	local t76 = 0
	local t77 = false

	local function t78()
		local t79 = t3.Character
		local t80 = t3:FindFirstChildOfClass("Backpack")
		local t81 = t79 and t79:FindFirstChildOfClass("Humanoid")
		local t82, t83 = {}, {}
		local t84, t85
		for t86 = 1, 2 do
			local t87 = t86 == 1 and t80 or nil
			if t86 == 2 then
				t87 = t79
			end
			if t87 then
				for t88, t89 in ipairs(t87:GetChildren()) do
					if t89:IsA("Tool") then
						if not t83[t89.Name] then
							t83[t89.Name] = true
							t82[#t82 + 1] = t89.Name
						end
						if t89.Name == t7.ToolName then
							if t86 == 1 then
								t84 = t89
							else
								t85 = t89
							end
						end
					end
				end
			end
		end
		table.sort(t82, function(t90, t91)
			if t90:lower() == t91:lower() then
				return t90 < t91
			end
			return t90:lower() < t91:lower()
		end)
		return t82, t83, t81, t84, t85
	end

	local function t92()
		local t82, t83, t81, t84, t85 = t78()
		local t93 = #t82 ~= #t72
		if not t93 then
			for t88, t89 in ipairs(t82) do
				if t89 ~= t72[t88] then
					t93 = true
					break
				end
			end
		end
		if t93 then
			t73 = true
			t72 = t82
			t71:SetValues(t82)
			t71:SetValue(t83[t7.ToolName] and t7.ToolName or nil)
			t73 = false
		end
		if not t81 or t81.Health <= 0 then
			if t81 then
				t77 = true
			end
			t70:SetText("Waiting for respawn")
			return
		end
		if t85 then
			t74 = false
		end
		if t7.ToolName == "" then
			t70:SetText("Select a tool")
		elseif t85 then
			t70:SetText("Equipped: " .. t7.ToolName)
		elseif not t84 then
			t70:SetText("Waiting for tool: " .. t7.ToolName)
		else
			t70:SetText("Unequipped: " .. t7.ToolName)
			if (t7.AutoEquip or t74 and t7.EquipAfterDeath) and os.clock() >= t76 then
				t76 = os.clock() + 0.75
				pcall(t81.EquipTool, t81, t84)
				if t84.Parent == t3.Character then
					t74 = false
				end
			end
		end
	end

	t71 = t69:AddDropdown("SelectedTool", {
		Text = "Backpack Tools",
		Values = {},
		Searchable = true,
		AllowNull = true,
		Callback = function(t22)
			if not t73 then
				t7.ToolName = t22 or ""
			end
		end,
	})
	t69:AddToggle("AutoEquip", {
		Text = "Auto Equip",
		Default = t7.AutoEquip,
		Callback = function(t22)
			t7.AutoEquip = t22
		end,
	})
	t69:AddToggle("EquipAfterDeath", {
		Text = "Auto Equip After Death",
		Default = t7.EquipAfterDeath,
		Callback = function(t22)
			t7.EquipAfterDeath = t22
			if not t22 then
				t74 = false
			end
		end,
	})
	t69:AddButton({
		Text = "Equip Now",
		Func = function()
			local t82, t83, t81, t84, t85 = t78()
			if t81 and t81.Health > 0 and t84 and not t85 then
				t81:EquipTool(t84)
			end
		end,
	})
	t39(t3.CharacterRemoving, function(t79)
		local t81 = t79:FindFirstChildOfClass("Humanoid")
		if t81 and t81.Health <= 0 then
			t77 = true
		end
	end)
	t39(t3.CharacterAdded, function()
		t74 = t77 and t7.EquipAfterDeath
		t77 = false
		t76 = 0
	end)
	t39(t1.Heartbeat, function(t64)
		t75 = t75 + t64
		if t7.Alive and t75 >= 0.2 then
			t75 = 0
			t92()
		end
	end)
	t92()

	local t98, t99
	local t102 = os.clock()
	local t103
	t62:AddToggle("PeriodicReset", {
		Text = "Periodic Reset",
		Default = t7.PeriodicReset,
		Callback = function(t22)
			t7.PeriodicReset = t22
			t102 = os.clock()
		end,
	})
	local function t106(t107)
		local t108 = t107:lower():gsub(",", "."):gsub("%s+", "")
		local t109 = "^%d*%.?%d+$"
		local t110
		if t108:match(t109) then
			t110 = tonumber(t108)
		else
			t110 = 0
			local t111 = 0
			while t108 ~= "" do
				local t112, t113, t114 = t108:match("^(%d*%.?%d+)([hm])()")
				local t115 = t113 == "h" and 1 or 2
				if not t112 or t115 <= t111 then
					return nil
				end
				t111 = t115
				t110 = t110 + tonumber(t112) * (t113 == "h" and 60 or 1)
				t108 = t108:sub(t114)
			end
			if t111 == 0 then
				return nil
			end
		end
		if t110 and t110 >= 1 and t110 <= 180 then
			return t110
		end
	end

	local t116 = t62:AddInput("ResetMinutes", {
		Text = "Reset Interval",
		Default = tostring(t7.ResetMinutes) .. "m",
		Placeholder = "90m / 1.5h / 2h 30m",
		Finished = true,
		ClearTextOnFocus = false,
		ClearTextOnBlur = false,
	})
	local function t117()
		local t118 = t106(t116.Container.Text)
		if not t118 then
			t116:SetValue(tostring(t7.ResetMinutes) .. "m")
			t9:Notify({ Title = "Position Lock", Description = "Enter an interval from 1m to 3h.", Time = 4 })
			return
		end
		if t7.ResetMinutes ~= t118 then
			t7.ResetMinutes = t118
			t102 = os.clock()
		end
	end
	t39(t116.Container.FocusLost, t117)

	t39(t3.CharacterRemoving, function()
		t98, t99 = nil, nil
		t43()
	end)
	t39(t3.CharacterAdded, function(t100)
		t98, t99 = t100, os.clock()
		t102 = t99
		t103 = nil
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
		local t104 = t3.Character
		if t7.PeriodicReset and t104 and t104 ~= t103 and os.clock() - t102 >= t7.ResetMinutes * 60 then
			local t105 = t104:FindFirstChildOfClass("Humanoid")
			if t105 and t105.Health > 0 then
				t103 = t104
				t105.Health = 0
				return
			end
		end
		local t65, t66 = pcall(function()
			if t7.Locked or t7.TPOnly and t124 ~= t3.Character then
				if t98 == t3.Character and t99 then
					local t101 = t7.RespawnDelay - (os.clock() - t99)
					if t101 > 0 then
						return string.format("Respawn: waiting %.1fs", t101)
					end
				end
				local t125 = t3.Character
				local t126 = t49(false, t7.TPOnly)
				if t7.TPOnly and t126 ~= nil then
					t124 = t125
				end
				return t126
			end
			local t48 = t44()
			return t48 and (t48.Position - t8.Position).Magnitude
		end)
		if t7.Display >= 0.5 then
			t7.Display = 0
			local t67 = not t65 and ("Correction failed: " .. tostring(t66))
				or type(t66) == "string" and t66
				or t66 == nil and "Waiting for a living character"
				or string.format(
					"%s\nDistance: %.2f studs\nCorrections: %d\nTarget: %.3f, %.3f, %.3f",
					t7.Locked and "Position locked" or t7.TPOnly and "TP Only" or "Lock paused",
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
