local u = game:GetService("HttpService")
local u1 = game:GetService("Players")
local u2 = game:GetService("RunService")
local u3 = game:GetService("UserInputService")
local u4 = game:GetService("VirtualInputManager")
local u5 = game:GetService("CoreGui")
local u6 = game:GetService("TeleportService")
local u7 = game:GetService("MarketplaceService")
local u8 = game:GetService("Stats")

local u9 = u1.LocalPlayer

while not u9 do
        task.wait()
        u9 = u1.LocalPlayer
end

local u10 = u9.Name
local u11 = u9.UserId

while not u10 or u10 == "" do
        task.wait()
        u10 = u9.Name
end

_G.UU = _G.UU or {}
_G.UU.LogBuffer = _G.UU.LogBuffer or {}

if _G.UU.Loaded or (_G.UU.LoadLock == true and ((tonumber(_G.UU.LoadLockTime) or 0) == 0 or os.clock() - tonumber(_G.UU.LoadLockTime) >= 5)) then
        for ua1, ua2 in pairs(_G.UU.Threads or {}) do
                if typeof(ua2) == "thread" and coroutine.status(ua2) ~= "dead" then
                        pcall(task.cancel, ua2)
                end

                _G.UU.Threads[ua1] = nil
        end

        for ua1, ua2 in pairs(_G.UU.Connections or {}) do
                pcall(function()
                        ua2:Disconnect()
                end)
        end

        if _G.UU.EditorApp then
                pcall(function()
                        _G.UU.EditorApp:Destroy()
                end)
        end

        if _G.UU.App then
                pcall(function()
                        _G.UU.App:Destroy()
                end)
        end

        _G.UU.Connections = {}
        _G.UU.TeleportQueued = false
        _G.UU.Loaded = false
        _G.UU.LoadLock = false
elseif _G.UU.LoadLock == true then
        repeat
                task.wait(0.1)
        until _G.UU.LoadLock ~= true or (tonumber(_G.UU.LoadLockTime) or 0) == 0 or os.clock() - tonumber(_G.UU.LoadLockTime) >= 5

        if _G.UU.LoadLock ~= true then
                return _G.UU
        end

        _G.UU.LoadLock = false
end

_G.UU.LoadLock = true
_G.UU.LoadLockTime = os.clock()
_G.UU.Threads = {}
_G.UU.Connections = {}
_G.UU.SavePending = false
_G.UU.LastSaveTime = 0

local u12 = {
        Keybind = Enum.KeyCode.G,

        JumpEnabled = false,
        ClickEnabled = false,
        AutoSpamEnabled = false,
        AutoLoadEnabled = false,
        AutoRejoinEnabled = false,
        AutoHideEnabled = false,
        FPSUnlockEnabled = false,
        MousePosEnabled = false,

        TargetFPS = 60,
        JumpDelay = 10,
        ClickDelay = 3,
        SpamDelay = 0.1,

        SpamKey = "Q",
        SavedCode = "",
        CurrentTab = "Home",

        MousePosSaved = { X = 960, Y = 540 },

        ThemeMode = "Dark",
        AccentName = "Blue",
}

_G.UU.CFG = u12

local u63 = {
        Blue = "#0A84FF",
        Indigo = "#5E5CE6",
        Purple = "#BF5AF2",
        Pink = "#FF375F",
        Red = "#FF453A",
        Orange = "#FF9F0A",
        Yellow = "#FFD60A",
        Green = "#32D74B",
        Mint = "#66D4CF",
        Cyan = "#64D2FF",
        Teal = "#6AC4DC",
        Lime = "#B5E655",
        Grey = "#98989D",
        White = "#F2F2F7",
}

local function u64(ua1, ua2)
        return '<font color="' .. ua1 .. '">' .. tostring(ua2) .. "</font>"
end

local function u65(ua1, ua2, ua3)
        return "[" .. u64(ua1 and u63.Mint or u63.Yellow, ua1 and "Tracking" or "Locked") .. "] F5 · " .. u64(u63.Grey, math.floor(ua2) .. ", " .. math.floor(ua3))
end

local function u66(ua1)
        ua1 = tostring(ua1)

        if ua1:find("error", 1, true) or ua1:find("failed", 1, true) or ua1:find("Invalid", 1, true) or ua1:find("reserved", 1, true) or ua1:find("Not supported", 1, true) or ua1:find("Uninject", 1, true) then
                return u63.Red
        end

        if ua1:find("✓", 1, true) then
                return u63.Green
        end

        local ua2 = {
                { "Auto Jump", u63.Green },
                { "Auto Click", u63.Orange },
                { "Key Spam", u63.Yellow },
                { "Auto Rejoin", u63.Cyan },
                { "Mouse", u63.Mint },
                { "Auto Load", u63.Blue },
                { "Script", u63.Blue },
                { "FPS", u63.Pink },
                { "Keybind", u63.Purple },
                { "Accent", u63.Pink },
                { "Theme", u63.Indigo },
                { "Config", u63.Lime },
                { "Fresh", u63.Lime },
                { "Defaults", u63.Lime },
        }

        for ua3, ua4 in ipairs(ua2) do
                if ua1:find(ua4[1], 1, true) then
                        return ua4[2]
                end
        end

        return u63.White
end

local function u67(ua1)
        local ua2 = tostring(ua1)

        ua2 = ua2:gsub("&", "&amp;")
        ua2 = ua2:gsub("<", "&lt;")
        ua2 = ua2:gsub(">", "&gt;")

        return ua2
end

local function u68(ua1)
        if ua1 < 50 then
                return u63.Green
        end

        if ua1 < 100 then
                return u63.Mint
        end

        if ua1 < 200 then
                return u63.Yellow
        end

        if ua1 < 300 then
                return u63.Orange
        end

        return u63.Red
end

local function u69(ua1)
        local ua2 = {}
        local ua3 = 1
        local ua4 = #ua1
        local ua5 = false
        local ua6 = {
                Keyword = "#EA6C98",
                Number = "#FFC600",
                String = "#02B875",
                Comment = "#6E7681",
                Builtin = "#01A2E2",
                Func = "#C7A5FF",
                Prop = "#B5BFC8",
        }
        local ua7 = {
                ["and"] = true,
                ["break"] = true,
                ["continue"] = true,
                ["do"] = true,
                ["else"] = true,
                ["elseif"] = true,
                ["end"] = true,
                ["false"] = true,
                ["for"] = true,
                ["function"] = true,
                ["if"] = true,
                ["in"] = true,
                ["local"] = true,
                ["nil"] = true,
                ["not"] = true,
                ["or"] = true,
                ["repeat"] = true,
                ["return"] = true,
                ["then"] = true,
                ["true"] = true,
                ["until"] = true,
                ["while"] = true,
        }
        local ua8 = {
                print = true,
                warn = true,
                error = true,
                assert = true,
                pcall = true,
                xpcall = true,
                select = true,
                type = true,
                typeof = true,
                ipairs = true,
                pairs = true,
                next = true,
                tonumber = true,
                tostring = true,
                unpack = true,
                rawget = true,
                rawset = true,
                rawequal = true,
                rawlen = true,
                setmetatable = true,
                getmetatable = true,
                require = true,
                loadstring = true,
                load = true,
                tick = true,
                wait = true,
                spawn = true,
                delay = true,
                game = true,
                workspace = true,
                script = true,
                shared = true,
                task = true,
                math = true,
                string = true,
                table = true,
                os = true,
                coroutine = true,
                bit32 = true,
                utf8 = true,
                debug = true,
                getgenv = true,
                gethui = true,
                setfpscap = true,
                identifyexecutor = true,
                getexecutorname = true,
                writefile = true,
                readfile = true,
                isfile = true,
                listfiles = true,
                queue_on_teleport = true,
                newproxy = true,
                collectgarbage = true,
                ["_G"] = true,
                ["_VERSION"] = true,
        }

        while ua3 <= ua4 do
                local ua9 = ua1:match("^%-%-%[=*%[", ua3)

                if ua9 then
                        local ua10, ua11 = ua1:find("]" .. ua9:match("%[(=*)%[") .. "]", ua3 + #ua9, true)
                        local ua12 = ua11 or ua4

                        ua2[#ua2 + 1] = '<font color="' .. ua6.Comment .. '">' .. u67(ua1:sub(ua3, ua12)) .. "</font>"

                        ua3 = ua12 + 1
                elseif ua1:sub(ua3, ua3 + 1) == "--" then
                        local ua9 = ua1:find("\n", ua3, true) or ua4 + 1

                        ua2[#ua2 + 1] = '<font color="' .. ua6.Comment .. '">' .. u67(ua1:sub(ua3, ua9 - 1)) .. "</font>"

                        ua3 = ua9
                elseif ua1:match("^%[=*%[", ua3) then
                        local ua9 = ua1:match("^%[=*%[", ua3)
                        local ua10, ua11 = ua1:find("]" .. ua9:match("%[(=*)%[") .. "]", ua3 + #ua9, true)
                        local ua12 = ua11 or ua4

                        ua2[#ua2 + 1] = '<font color="' .. ua6.String .. '">' .. u67(ua1:sub(ua3, ua12)) .. "</font>"

                        ua3 = ua12 + 1
                elseif ua1:sub(ua3, ua3) == '"' or ua1:sub(ua3, ua3) == "'" then
                        local ua9 = ua1:sub(ua3, ua3)
                        local ua10 = ua3 + 1

                        while ua10 <= ua4 do
                                local ua11 = ua1:sub(ua10, ua10)

                                if ua11 == "\\" then
                                        ua10 = ua10 + 2
                                elseif ua11 == ua9 then
                                        ua10 = ua10 + 1

                                        break
                                else
                                        ua10 = ua10 + 1
                                end
                        end

                        ua10 = math.min(ua10, ua4 + 1)

                        ua2[#ua2 + 1] = '<font color="' .. ua6.String .. '">' .. u67(ua1:sub(ua3, ua10 - 1)) .. "</font>"

                        ua3 = ua10
                else
                        local ua9 = ua1:match("^0[xX]%x+", ua3) or ua1:match("^%d*%.?%d+[eE][+-]?%d+", ua3) or ua1:match("^%d*%.?%d+", ua3) or ua1:match("^%.%d+", ua3)

                        if ua9 then
                                ua2[#ua2 + 1] = '<font color="' .. ua6.Number .. '">' .. ua9 .. "</font>"

                                ua3 = ua3 + #ua9
                        else
                                local ua9 = ua1:match("^[%a_][%w_]*", ua3)

                                if ua9 then
                                        local ua10 = ua1:sub(ua3 - 1, ua3 - 1)

                                        if ua7[ua9] then
                                                ua2[#ua2 + 1] = '<font color="' .. ua6.Keyword .. '">' .. ua9 .. "</font>"

                                                ua5 = ua9 == "function"
                                        elseif ua5 then
                                                ua2[#ua2 + 1] = '<font color="' .. ua6.Func .. '">' .. ua9 .. "</font>"

                                                ua5 = false
                                        elseif ua8[ua9] then
                                                ua2[#ua2 + 1] = '<font color="' .. ua6.Builtin .. '">' .. ua9 .. "</font>"
                                        elseif ua10 == "." or ua10 == ":" then
                                                ua2[#ua2 + 1] = '<font color="' .. ua6.Prop .. '">' .. ua9 .. "</font>"
                                        else
                                                ua2[#ua2 + 1] = ua9
                                        end

                                        ua3 = ua3 + #ua9
                                else
                                        local ua9 = ua1:sub(ua3, ua3)

                                        ua2[#ua2 + 1] = u67(ua9)

                                        if ua9 ~= " " and ua9 ~= "\t" and ua9 ~= "\n" and ua9 ~= "\r" then
                                                ua5 = false
                                        end

                                        ua3 = ua3 + 1
                                end
                        end
                end
        end

        return table.concat(ua2)
end

local function u13()
        return "UniversalUtility/Accounts/" .. u10 .. ".json"
end

local function u14()
        if makefolder and isfolder then
                if not isfolder("UniversalUtility") then
                        makefolder("UniversalUtility")
                end

                if not isfolder("UniversalUtility/Accounts") then
                        makefolder("UniversalUtility/Accounts")
                end
        end
end

local function u15()
        if not writefile then
                return false
        end

        u14()

        local ua1 = pcall(function()
                writefile(u13(), u:JSONEncode({
                        UserId = u11,
                        Username = u10,
                        Keybind = u12.Keybind.Name,
                        JumpEnabled = u12.JumpEnabled,
                        ClickEnabled = u12.ClickEnabled,
                        AutoSpamEnabled = u12.AutoSpamEnabled,
                        AutoLoadEnabled = u12.AutoLoadEnabled,
                        AutoRejoinEnabled = u12.AutoRejoinEnabled,
                        AutoHideEnabled = u12.AutoHideEnabled,
                        FPSUnlockEnabled = u12.FPSUnlockEnabled,
                        MousePosEnabled = u12.MousePosEnabled,
                        TargetFPS = u12.TargetFPS,
                        JumpDelay = u12.JumpDelay,
                        ClickDelay = u12.ClickDelay,
                        SpamDelay = u12.SpamDelay,
                        SpamKey = u12.SpamKey,
                        SavedCode = u12.SavedCode,
                        CurrentTab = u12.CurrentTab,
                        ThemeMode = u12.ThemeMode,
                        AccentName = u12.AccentName,
                        MousePosSaved = u12.MousePosSaved,
                }))
        end)

        if ua1 then
                _G.UU.LastSaveTime = tick()
                _G.UU.SavePending = false
        end

        return ua1
end

_G.UU.SaveCFG = u15

local function u16()
        if _G.UU.SavePending then
                return
        end

        _G.UU.SavePending = true

        local ua1 = tick() - _G.UU.LastSaveTime

        if ua1 >= 0.1 then
                _G.UU.SavePending = false
                u15()
        else
                task.delay(0.1 - ua1, function()
                        if _G.UU.SavePending then
                                _G.UU.SavePending = false
                                u15()
                        end
                end)
        end
end

_G.UU.DebouncedSave = u16

local function u17()
        if not (readfile and isfile) then
                return false
        end

        local ua1 = u13()

        if not isfile(ua1) then
                return false
        end

        local ua2, ua3 = pcall(function()
                return u:JSONDecode(readfile(ua1))
        end)

        if not ua2 or type(ua3) ~= "table" or ua3.UserId ~= u11 then
                return false
        end

        u12.Keybind = Enum.KeyCode[ua3.Keybind] or Enum.KeyCode.G
        u12.JumpEnabled = ua3.JumpEnabled or false
        u12.ClickEnabled = ua3.ClickEnabled or false
        u12.AutoSpamEnabled = ua3.AutoSpamEnabled or false
        u12.AutoLoadEnabled = ua3.AutoLoadEnabled or false
        u12.AutoRejoinEnabled = ua3.AutoRejoinEnabled or false
        u12.AutoHideEnabled = ua3.AutoHideEnabled or false
        u12.FPSUnlockEnabled = ua3.FPSUnlockEnabled or false
        u12.MousePosEnabled = ua3.MousePosEnabled or false
        u12.TargetFPS = math.clamp(tonumber(ua3.TargetFPS) or 60, 15, 360)
        u12.JumpDelay = math.clamp(tonumber(ua3.JumpDelay) or 10, 1, 600)
        u12.ClickDelay = math.clamp(tonumber(ua3.ClickDelay) or 3, 1, 600)
        u12.SpamDelay = math.clamp(tonumber(ua3.SpamDelay) or 0.1, 0.05, 5)
        u12.SpamKey = ua3.SpamKey or "Q"
        u12.SavedCode = ua3.SavedCode or ""
        u12.CurrentTab = ua3.CurrentTab or "Home"
        u12.ThemeMode = ua3.ThemeMode == "Light" and "Light" or "Dark"
        u12.AccentName = type(ua3.AccentName) == "string" and ua3.AccentName or "Blue"
        u12.MousePosSaved = ua3.MousePosSaved or { X = 960, Y = 540 }

        return true
end

local u18 = u17()

local function u19(ua1)
        ua1 = math.floor(ua1 * 10 + 0.5) / 10

        if ua1 < 60 then
                if ua1 % 1 == 0 then
                        return string.format("%ds", ua1)
                end

                return string.format("%.1fs", ua1)
        end

        local ua2 = math.floor(ua1 / 60 + 0.001)
        local ua3 = math.floor(ua1 - ua2 * 60 + 0.5)

        if ua3 >= 60 then
                ua2, ua3 = ua2 + 1, 0
        end

        if ua3 == 0 then
                return string.format("%dm", ua2)
        end

        return string.format("%dm %02ds", ua2, ua3)
end

local function u20(ua1)
        return math.floor((600 ^ math.clamp(ua1, 0, 1)) * 10 + 0.5) / 10
end

local function u21(ua1)
        ua1 = math.clamp(ua1, 1, 600)
        return math.clamp(math.log(ua1) / math.log(600), 0, 1)
end

local function u22()
        if u3.TouchEnabled and not u3.KeyboardEnabled and not u3.MouseEnabled then
                return "Mobile"
        end

        if u3.GamepadEnabled and not u3.KeyboardEnabled then
                return "Console"
        end

        if u3.KeyboardEnabled and u3.MouseEnabled then
                return "PC"
        end

        local ua1 = u3:GetLastInputType()

        if ua1 == Enum.UserInputType.Touch then
                return "Mobile"
        end

        if ua1 == Enum.UserInputType.Gamepad1 or ua1 == Enum.UserInputType.Gamepad2 then
                return "Console"
        end

        return "PC"
end

local function u23(ua1)
        if type(ua1) ~= "string" or #ua1 ~= 2 then
                return "🌐"
        end

        local ua2, ua3 = ua1:upper():byte(1, 2)

        if ua2 < 65 or ua2 > 90 or ua3 < 65 or ua3 > 90 then
                return "🌐"
        end

        return utf8.char(0x1F1E6 + ua2 - 65, 0x1F1E6 + ua3 - 65)
end

local u24 = {
        ["us-east-1"] = "US, N. Virginia",
        ["us-east-2"] = "US, Ohio",
        ["us-west-1"] = "US, N. California",
        ["us-west-2"] = "US, Oregon",
        ["eu-west-1"] = "IE, Ireland",
        ["eu-west-2"] = "GB, London",
        ["eu-west-3"] = "FR, Paris",
        ["eu-central-1"] = "DE, Frankfurt",
        ["eu-central-2"] = "CH, Zurich",
        ["eu-north-1"] = "SE, Stockholm",
        ["eu-south-1"] = "IT, Milan",
        ["eu-south-2"] = "ES, Spain",
        ["ap-southeast-1"] = "SG, Singapore",
        ["ap-southeast-2"] = "AU, Sydney",
        ["ap-southeast-3"] = "ID, Jakarta",
        ["ap-southeast-4"] = "AU, Melbourne",
        ["ap-northeast-1"] = "JP, Tokyo",
        ["ap-northeast-2"] = "KR, Seoul",
        ["ap-northeast-3"] = "JP, Osaka",
        ["ap-south-1"] = "IN, Mumbai",
        ["ap-south-2"] = "IN, Hyderabad",
        ["ap-east-1"] = "HK, Hong Kong",
        ["sa-east-1"] = "BR, São Paulo",
        ["ca-central-1"] = "CA, Montreal",
        ["ca-west-1"] = "CA, Calgary",
        ["me-south-1"] = "BH, Bahrain",
        ["me-central-1"] = "AE, UAE",
        ["af-south-1"] = "ZA, Cape Town",
        ["il-central-1"] = "IL, Tel Aviv",
        ["mx-central-1"] = "MX, Mexico City",
}

local function u25(ua1)
        task.spawn(function()
                local ua2 = nil
                local ua3 = game.JobId

                if ua3 ~= "" then
                        for ua4, ua5 in pairs(u24) do
                                if ua3:lower():find(ua4, 1, true) then
                                        ua2 = u23(ua4:sub(1, 2)) .. " " .. ua5
                                        break
                                end
                        end
                end

                if not ua2 then
                        local ua6, ua7 = pcall(function()
                                return u:JSONDecode(game:HttpGet("https://ipinfo.io/json", true))
                        end)

                        if ua6 and type(ua7) == "table" and ua7.country then
                                ua2 = u23(ua7.country) .. " " .. ua7.country

                                if ua7.region and ua7.region ~= "" then
                                        ua2 = ua2 .. " - " .. ua7.region
                                end

                                if ua7.city and ua7.city ~= "" then
                                        ua2 = ua2 .. ", " .. ua7.city
                                end
                        end
                end

                if ua1 and ua1.Parent then
                        ua1.Text = u64(u63.Grey, "Server Region: ") .. u64(u63.Mint, u67(ua2 or "Unknown"))
                end
        end)
end

local function u26(ua1)
        local ua2 = os.date and os.date("%H:%M:%S") or "--:--:--"

        table.insert(_G.UU.LogBuffer, 1, "[" .. u64(u63.Cyan, ua2) .. "] " .. u64(u66(ua1), u67(ua1)))

        if #_G.UU.LogBuffer > 6 then
                table.remove(_G.UU.LogBuffer, 7)
        end

        local ua3 = _G.UU.UI

        if ua3 and ua3.Settings then
                for ua4 = 1, 6 do
                        local ua5 = ua3.Settings.Activity[ua4]

                        if ua5 then
                                ua5.Text = _G.UU.LogBuffer[ua4] or u64(u63.Grey, "—")
                        end
                end
        end
end

local function u27(ua1, ua2)
        local ua3 = _G.UU.App

        if not ua3 then
                return
        end

        pcall(function()
                ua3:Notification({
                        App = "Universal Utility",
                        Title = ua1,
                        Subtitle = ua2,
                        Duration = 4,
                })
        end)
end

local function u28(ua1)
        local ua2 = _G.UU.Threads[ua1]
        _G.UU.Threads[ua1] = nil

        if ua2 and typeof(ua2) == "thread" and coroutine.status(ua2) ~= "dead" then
                pcall(task.cancel, ua2)
        end
end

local function u29(ua1, ua2)
        u28(ua1)
        _G.UU.Threads[ua1] = task.spawn(ua2)
end
local function u30(ua1, ua2)
        u12.MousePosEnabled = ua1

        local ua3 = _G.UU.UI

        if not ua2 and ua3 and ua3.AntiAFK and ua3.AntiAFK.MouseToggle then
                ua3.SyncMouse = true
                ua3.AntiAFK.MouseToggle.Value = ua1
                ua3.SyncMouse = false
        end

        if ua3 and ua3.TrackingConnection then
                local ua4 = ua3.TrackingConnection
                ua3.TrackingConnection = nil

                pcall(function()
                        ua4:Disconnect()
                end)
        end

        if ua1 then
                local ua5 = u2.RenderStepped:Connect(function()
                        local ua6 = u3:GetMouseLocation()
                        u12.MousePosSaved.X = ua6.X
                        u12.MousePosSaved.Y = ua6.Y
                end)

                ua3.TrackingConnection = ua5
                table.insert(_G.UU.Connections, ua5)
        end

        if ua3 and ua3.AntiAFK and ua3.AntiAFK.MouseState then
                ua3.AntiAFK.MouseState.Text = u65(ua1, u12.MousePosSaved.X, u12.MousePosSaved.Y)
        end

        u26("Mouse Position → " .. (ua1 and "Tracking" or "Locked"))
        u16()
end

local function u31()
        u29("Jump", function()
                while u12.JumpEnabled do
                        task.wait(math.max(u12.JumpDelay, 0.05))

                        if u12.JumpEnabled and u9.Character then
                                local ua1 = u9.Character:FindFirstChildOfClass("Humanoid")

                                if ua1 then
                                        ua1:ChangeState(Enum.HumanoidStateType.Jumping)
                                end
                        end
                end
        end)
end

local function u32()
        u29("Click", function()
                while u12.ClickEnabled do
                        task.wait(math.max(u12.ClickDelay, 0.05))

                        if u12.ClickEnabled then
                                local ua1, ua2

                                if u12.MousePosEnabled then
                                        local ua3 = u3:GetMouseLocation()
                                        ua1, ua2 = ua3.X, ua3.Y
                                else
                                        ua1, ua2 = u12.MousePosSaved.X, u12.MousePosSaved.Y
                                end

                                u4:SendMouseButtonEvent(ua1, ua2, 0, true, game, 0)
                                task.wait(0.05)
                                u4:SendMouseButtonEvent(ua1, ua2, 0, false, game, 0)
                        end
                end
        end)
end

local function u33()
        local ua1 = Enum.KeyCode[u12.SpamKey]

        if not ua1 then
                return false
        end

        u29("Spam", function()
                while u12.AutoSpamEnabled do
                        task.wait(math.max(u12.SpamDelay, 0.05))

                        if u12.AutoSpamEnabled then
                                u4:SendKeyEvent(true, ua1, false, game)
                                task.wait(0.05)
                                u4:SendKeyEvent(false, ua1, false, game)
                        end
                end
        end)

        return true
end

local function u34()
        u29("RejoinWait", function()
                local ua1 = u5:FindFirstChild("RobloxPromptGui")

                if not ua1 then
                        local ua2, ua3 = pcall(function()
                                return u5:WaitForChild("RobloxPromptGui", 10)
                        end)

                        if not ua2 or not ua3 then
                                return
                        end

                        ua1 = ua3
                end

                local ua4 = ua1:FindFirstChild("promptOverlay")

                if not ua4 then
                        local ua5, ua6 = pcall(function()
                                return ua1:WaitForChild("promptOverlay", 10)
                        end)

                        if not ua5 or not ua6 then
                                return
                        end

                        ua4 = ua6
                end

                local ua7 = ua4.ChildAdded:Connect(function(ua8)
                        if ua8.Name == "ErrorPrompt" and u12.AutoRejoinEnabled then
                                u26("Disconnected detected → rejoining")
                                u27("Rejoining", "Disconnected from the server")

                                u29("Rejoin", function()
                                        while u12.AutoRejoinEnabled do
                                                u6:Teleport(game.PlaceId, u9)
                                                task.wait(2)
                                        end
                                end)
                        end
                end)

                table.insert(_G.UU.Connections, ua7)
        end)
end

local function u35(ua1)
        if type(ua1) ~= "string" or ua1 == "" then
                return false, "No code to execute"
        end

        local ua2, ua3 = pcall(function()
                local ua4, ua5 = loadstring(ua1)

                if not ua4 then
                        error(ua5, 0)
                end

                ua4()
        end)

        if ua2 then
                return true, nil
        end

        return false, tostring(ua3)
end

local u36 = typeof(setfpscap) == "function"

if u36 then
        u36 = pcall(setfpscap, 60)
end

local function u37()
        if not u36 then
                return
        end

        if u12.FPSUnlockEnabled then
                pcall(setfpscap, u12.TargetFPS)
        else
                pcall(setfpscap, 60)
        end
end

_G.UU.UI = {}

local u38 = loadstring(game:HttpGet("https://github.com/cascadeui/Cascade/releases/latest/download/dist.luau"))()

local u39 = u38.New({
        WindowPill = true,
        Theme = u38.Themes[u12.ThemeMode] or u38.Themes.Dark,
        Accent = u38.Accents[u12.AccentName] or u38.Accents.Blue,
})

_G.UU.App = u39

local u40 = u39:Window({
        Title = "Universal Utility",
        Subtitle = u10,
        Draggable = true,
        Resizable = true,
        Dropshadow = true,
        CanExit = false,
        CanMinimize = true,
        CanZoom = true,
        Minimized = u12.AutoHideEnabled,
})

local u41 = u40:Section({ Title = "General" })
local u42 = u40:Section({ Title = "Automation" })
local u43 = u40:Section({ Title = "Session" })
local u44 = u40:Section({ Title = "System" })

local function u45(ua1, ua2, ua3)
        local ua4 = ua1:Row()

        ua4:Left():TitleStack({
                Title = ua2,
                Subtitle = ua3,
        })

        return ua4
end

local function u70(ua1)
        local ua2 = ua1.Structures

        ua2.Gradient.Enabled = false
        ua2.Surface.BackgroundTransparency = 1
        ua2.Surface.Size = UDim2.fromOffset(38, 38)
        ua2.Image.Size = UDim2.fromOffset(36, 36)
        ua2.Body.Size = UDim2.fromOffset(40, 40)

        return ua1
end

local function u46(ua1, ua2, ua3)
        local ua4 = ua1:Tab({
                Title = ua2,
                Icon = ua3,
        })

        local ua5 = ua4.Structures
        local ua6 = ua5.Leading:FindFirstChild("UIListLayout")

        ua5.Symbol.ScaleType = Enum.ScaleType.Fit
        ua5.Symbol.Size = UDim2.fromOffset(18, 18)

        if ua6 then
                ua6.Padding = UDim.new(0, 6)
                ua6.VerticalAlignment = Enum.VerticalAlignment.Center
        end

        return ua4
end

local function u47(ua1, ua2)
        local ua3 = ua1:Right():Slider(ua2)

        if ua3.Structures and ua3.Structures.Thumb then
                ua3.Structures.Thumb.Position = UDim2.fromScale(1, 0.5)
        end

        return ua3
end

local u48 = false

local u49, u50 = {}, {}

for ua1 = 1, 60 do
        u49[ua1] = 60
        u50[ua1] = 0
end

local u51, u52 = 0, tick()
local u53 = 0
local u54 = false
local u55 = nil

local u56 = u46(u41, "Home", u38.Symbols.house)
local u57 = u46(u42, "Anti-AFK", u38.Symbols.bolt)
local u58 = u46(u42, "Key Spam", u38.Symbols.keyboard)
local u59 = u46(u43, "Auto Rejoin", u38.Symbols.arrowClockwise)
local u60 = u46(u43, "Script Loader", u38.Symbols.docPlaintext)
local u61 = u46(u44, "Performance", u38.Symbols.waveform)
local u62 = u46(u44, "Settings", u38.Symbols.gearshape)

_G.UU.UI.Tabs = {
        Home = u56,
        AntiAFK = u57,
        KeySpam = u58,
        Rejoin = u59,
        Loader = u60,
        Performance = u61,
        Settings = u62,
}

do
        local ua1 = _G.UU.UI
        local ua2 = u56:PageSection({ Title = "Player" }):Form()

        local ua3 = ua2:Row()

        u70(ua3:Left():ImageSurface({
                Image = "rbxthumb://type=AvatarHeadShot&id=" .. u11 .. "&w=150&h=150",
        }))

        ua3:Right():TitleStack({
                Title = u10,
                Subtitle = u64(u63.Grey, "User ID: ") .. u64(u63.Cyan, u11),
        })

        local ua4, ua5 = "Unknown", ""

        pcall(function()
                if identifyexecutor then
                        ua4, ua5 = identifyexecutor()
                elseif getexecutorname then
                        ua4 = getexecutorname()
                end
        end)

        ua1.Home = {
                Executor = u45(ua2, "Executor"):Right():Label({
                        Text = u64(u63.Blue, ua4 .. (ua5 ~= "" and (" " .. ua5) or "")),
                }),
                Device = u45(ua2, "Device"):Right():Label({
                        Text = u64(u63.Mint, u22()),
                }),
                Resolution = u45(ua2, "Resolution"):Right():Label({
                        Text = u64(u63.Cyan, "Detecting..."),
                }),
                FPS = u45(ua2, "FPS"):Right():Label({
                        Text = u64(u63.Grey, "—"),
                }),
                Ping = u45(ua2, "Ping"):Right():Label({
                        Text = u64(u63.Grey, "—"),
                }),
                Memory = u45(ua2, "Memory"):Right():Label({
                        Text = u64(u63.Grey, "—"),
                }),
        }

        local ua6 = u56:PageSection({ Title = "Game" }):Form()
        local ua7 = ua6:Row()

        ua1.GameIcon = ua7:Left():ImageSurface({
                Image = u38.Symbols.docPlaintext,
        })

        u70(ua1.GameIcon)

        ua1.GameName = ua7:Right():TitleStack({
                Title = "Loading game info...",
                Subtitle = u64(u63.Blue, "Universal Utility"),
        })

        ua1.Home.PlaceId = u45(ua6, "Place Id"):Right():Label({
                Text = u64(u63.Indigo, tostring(game.PlaceId)),
        })

        ua1.Home.UniverseId = u45(ua6, "Universe Id"):Right():Label({
                Text = u64(u63.Teal, tostring(game.GameId)),
        })

        ua1.Home.Players = u45(ua6, "Server Players"):Right():Label({
                Text = u64(u63.Lime, #u1:GetPlayers() .. " / " .. u1.MaxPlayers),
        })

        ua1.Home.PlaceVersion = u45(ua6, "Place Version"):Right():Label({
                Text = u64(u63.Orange, tostring(game.PlaceVersion)),
        })

        ua1.Home.Region = u45(ua6, "Server Region"):Right():Label({
                Text = u64(u63.Grey, "Server Region: ") .. u64(u63.Mint, "Detecting..."),
        })

        ua1.Home.JobId = u45(ua6, "Job Id"):Right():Label({
                Text = u64(u63.Grey, game.JobId ~= "" and game.JobId or "N/A"),
                TextTruncate = Enum.TextTruncate.AtEnd,
        })

        task.spawn(function()
                pcall(function()
                        local ua8 = u7:GetProductInfo(game.PlaceId)

                        _G.UU.UI.GameName.Title = ua8.Name

                        if ua8.IconImageAssetId and ua8.IconImageAssetId ~= 0 then
                                _G.UU.UI.GameIcon.Image = "rbxthumb://type=Asset&id=" .. ua8.IconImageAssetId .. "&w=150&h=150"
                        end
                end)
        end)

        u25(ua1.Home.Region)
end

do
        local ua1 = _G.UU.UI
        local ua2 = u57:PageSection({ Title = "Automation" }):Form()

        ua1.AntiAFK = {}

        local ua3 = u45(ua2, "Auto Jump", "Simulates jumping to keep the session alive")

        ua3:Right():Toggle({
                Value = u12.JumpEnabled,
                ValueChanged = function(ua8, ua9)
                        if not u48 then
                                return
                        end

                        u12.JumpEnabled = ua9

                        if ua9 then
                                task.defer(u31)
                        else
                                u28("Jump")
                        end

                        u26("Auto Jump → " .. (ua9 and "Enabled" or "Disabled"))
                        u16()
                end,
        })

        local ua4 = u45(ua2, "Auto Click", "Simulates mouse clicks at the chosen position")

        ua4:Right():Toggle({
                Value = u12.ClickEnabled,
                ValueChanged = function(ua8, ua9)
                        if not u48 then
                                return
                        end

                        u12.ClickEnabled = ua9

                        if ua9 then
                                task.defer(u32)
                        else
                                u28("Click")
                        end

                        u26("Auto Click → " .. (ua9 and "Enabled" or "Disabled"))
                        u16()
                end,
        })

        local ua5 = u45(ua2, "Mouse Position", "Track the live cursor or lock a saved position")

        ua1.AntiAFK.MouseToggle = ua5:Right():Toggle({
                Value = u12.MousePosEnabled,
                ValueChanged = function(ua8, ua9)
                        if ua1.SyncMouse or not u48 then
                                return
                        end

                        u30(ua9, true)
                end,
        })

        ua1.AntiAFK.MouseState = u45(ua2, "Mouse State", "F5 toggles between tracking and locked"):Right():Label({
                Text = u65(u12.MousePosEnabled, u12.MousePosSaved.X, u12.MousePosSaved.Y),
        })

        local ua6 = u57:PageSection({ Title = "Cooldowns", Subtitle = "Exponential scale from 1 second to 10 minutes" }):Form()

        ua1.AntiAFK.JumpValue = u45(ua6, "Jump Delay"):Right():Label({
                Text = u64(u63.Green, u19(u12.JumpDelay)),
        })

        local ua7 = u45(ua6, "Jump Cooldown")

        u47(ua7, {
                Minimum = 0,
                Maximum = 1,
                Value = u21(u12.JumpDelay),
                ValueChanged = function(ua8, ua9)
                        u12.JumpDelay = u20(ua9)

                        if ua1.AntiAFK.JumpValue then
                                ua1.AntiAFK.JumpValue.Text = u64(u63.Green, u19(u12.JumpDelay))
                        end

                        u16()
                end,
        })

        ua1.AntiAFK.ClickValue = u45(ua6, "Click Delay"):Right():Label({
                Text = u64(u63.Orange, u19(u12.ClickDelay)),
        })

        local ua8 = u45(ua6, "Click Cooldown")

        u47(ua8, {
                Minimum = 0,
                Maximum = 1,
                Value = u21(u12.ClickDelay),
                ValueChanged = function(ua8, ua9)
                        u12.ClickDelay = u20(ua9)

                        if ua1.AntiAFK.ClickValue then
                                ua1.AntiAFK.ClickValue.Text = u64(u63.Orange, u19(u12.ClickDelay))
                        end

                        u16()
                end,
        })
end

do
        local ua1 = _G.UU.UI
        local ua2 = u58:PageSection({ Title = "Input" }):Form()

        ua1.Spam = {}

        ua1.Spam.Interval = u45(ua2, "Selected Interval"):Right():Label({
                Text = u64(u63.Yellow, string.format("%.2fs", u12.SpamDelay)),
        })

        local ua3 = u45(ua2, "Spam Interval", "Delay between each simulated key press")

        u47(ua3, {
                Minimum = 0.05,
                Maximum = 5,
                Value = u12.SpamDelay,
                ValueChanged = function(ua8, ua9)
                        u12.SpamDelay = math.floor(ua9 * 100 + 0.5) / 100

                        if ua1.Spam.Interval then
                                ua1.Spam.Interval.Text = u64(u63.Yellow, string.format("%.2fs", u12.SpamDelay))
                        end

                        u16()
                end,
        })

        local ua4 = u45(ua2, "Target Key", "The key that gets pressed automatically")

        ua4:Right():KeybindField({
                Value = Enum.KeyCode[u12.SpamKey] or Enum.KeyCode.Q,
                ValueChanged = function(ua8, ua9)
                        if not u48 then
                                return
                        end

                        local ua10 = u12.SpamKey
                        u12.SpamKey = ua9.Name

                        if u12.AutoSpamEnabled then
                                local ua11 = ua9 == Enum.KeyCode.P or ua9.Name == "F5" or ua9 == u12.Keybind

                                if ua11 then
                                        u12.AutoSpamEnabled = false
                                        u28("Spam")

                                        ua1.SyncSpam = true
                                        ua1.Spam.Toggle.Value = false
                                        ua1.SyncSpam = false

                                        u26("Key Spam → Key '" .. ua9.Name .. "' is reserved")
                                        u27("Key Spam", "Key '" .. ua9.Name .. "' is reserved")
                                        u16()
                                        return
                                end

                                u33()
                        end

                        if ua10 ~= ua9.Name then
                                u26("Spam Key → " .. ua9.Name)
                        end

                        u16()
                end,
        })

        local ua5 = u58:PageSection({ Title = "Control" }):Form()
        local ua6 = u45(ua5, "Auto Spam", "Repeatedly presses the target key")

        ua1.Spam.Toggle = ua6:Right():Toggle({
                Value = u12.AutoSpamEnabled,
                ValueChanged = function(ua8, ua9)
                        if ua1.SyncSpam or not u48 then
                                return
                        end

                        u12.AutoSpamEnabled = ua9

                        if ua9 then
                                local ua10 = Enum.KeyCode[u12.SpamKey]
                                local ua11 = ua10 and (ua10 == Enum.KeyCode.P or ua10.Name == "F5" or ua10 == u12.Keybind)

                                if not ua10 or ua11 then
                                        u12.AutoSpamEnabled = false

                                        ua1.SyncSpam = true
                                        ua8.Value = false
                                        ua1.SyncSpam = false

                                        u26("Key Spam → " .. (not ua10 and "Invalid key '" .. u12.SpamKey .. "'" or "Key '" .. ua10.Name .. "' is reserved"))
                                        u27("Key Spam", not ua10 and "Invalid key" or "Key reserved")
                                        return
                                end

                                u33()
                                u26("Key Spam → Enabled (" .. ua10.Name .. ")")
                        else
                                u28("Spam")
                                u26("Key Spam → Disabled")
                        end

                        u16()
                end,
        })
end

do
        local ua1 = _G.UU.UI
        local ua2 = u59:PageSection({ Title = "Watcher" }):Form()

        ua1.Rejoin = {}

        local ua3 = u45(ua2, "Auto Rejoin", "Reconnects automatically when disconnected")

        ua1.Rejoin.Toggle = ua3:Right():Toggle({
                Value = u12.AutoRejoinEnabled,
                ValueChanged = function(ua8, ua9)
                        if not u48 then
                                return
                        end

                        u12.AutoRejoinEnabled = ua9

                        if ua9 then
                                u34()
                                u26("Auto Rejoin → Enabled")
                        else
                                u28("Rejoin")
                                u28("RejoinWait")
                                u26("Auto Rejoin → Disabled")
                        end

                        u16()
                end,
        })
end

local u71 = u38.New({
        WindowPill = false,
        Theme = u38.Themes[u12.ThemeMode] or u38.Themes.Dark,
        Accent = u38.Accents[u12.AccentName] or u38.Accents.Blue,
})

_G.UU.EditorApp = u71

do
        local ua1 = _G.UU.UI
        local ua2 = u60:PageSection({ Title = "Editor" }):Form()

        ua1.Loader = { Output = {}, History = {} }

        ua1.Loader.AutoLoad = u45(ua2, "Auto Load", "Executes the saved code on every injection"):Right():Toggle({
                Value = u12.AutoLoadEnabled,
                ValueChanged = function(ua8, ua9)
                        if not u48 then
                                return
                        end

                        u12.AutoLoadEnabled = ua9

                        if ua9 then
                                u26(u12.SavedCode ~= "" and "Auto Load → Enabled (code ready)" or "Auto Load → Enabled (no code saved)")
                        else
                                u26("Auto Load → Disabled")
                        end

                        u16()
                end,
        })

        local ua3 = u71:Window({
                Title = "Code Editor",
                Subtitle = u10,
                Size = UDim2.fromOffset(620, 460),
                Searching = false,
                CanExit = false,
                CanMinimize = true,
                CanZoom = true,
                Minimized = true,
        })

        local ua5 = ua3:Section({ Title = "Code" })
        local ua6 = u46(ua5, "Editor", u38.Symbols.docPlaintext)

        ua6.Selected = true

        local ua7 = ua6.Structures.Page.__instance or ua6.Structures.Page
        local ua8 = game:GetService("TextService")
        local ua9 = Font.fromEnum(Enum.Font.Code)
        local ua10 = ua8:GetTextSize("Ag", 14, Enum.Font.Code, Vector2.new(10000, 10000)).Y
        local ua11 = Instance.new("Frame")

        ua11.Name = "EditorPane"
        ua11.Size = UDim2.new(1, 0, 0, 330)
        ua11.BackgroundColor3 = Color3.fromRGB(26, 28, 37)
        ua11.BorderSizePixel = 0
        ua11.ClipsDescendants = true
        ua11.Parent = ua7

        Instance.new("UICorner", ua11).CornerRadius = UDim.new(0, 8)

        local ua12 = Instance.new("ScrollingFrame")

        ua12.Name = "Scroller"
        ua12.Size = UDim2.new(1, 0, 1, -26)
        ua12.BackgroundTransparency = 1
        ua12.BorderSizePixel = 0
        ua12.ScrollBarThickness = 5
        ua12.ScrollBarImageColor3 = Color3.fromRGB(120, 128, 150)
        ua12.ScrollingDirection = Enum.ScrollingDirection.XY
        ua12.CanvasSize = UDim2.new()
        ua12.Parent = ua11

        local ua13 = Instance.new("TextLabel")

        ua13.Name = "Numbers"
        ua13.Size = UDim2.new(0, 34, 0, 240)
        ua13.BackgroundColor3 = Color3.fromRGB(21, 23, 30)
        ua13.BorderSizePixel = 0
        ua13.FontFace = ua9
        ua13.TextSize = 14
        ua13.TextColor3 = Color3.fromRGB(90, 97, 115)
        ua13.TextXAlignment = Enum.TextXAlignment.Right
        ua13.TextYAlignment = Enum.TextYAlignment.Top
        ua13.Text = "1"
        ua13.Parent = ua12

        local ua14 = Instance.new("Frame")

        ua14.Name = "TextZone"
        ua14.Position = UDim2.new(0, 40, 0, 0)
        ua14.Size = UDim2.new(0, 480, 0, 240)
        ua14.BackgroundTransparency = 1
        ua14.Parent = ua12

        local ua15 = Instance.new("TextLabel")

        ua15.Name = "Highlight"
        ua15.Size = UDim2.new(1, 0, 1, 0)
        ua15.BackgroundTransparency = 1
        ua15.FontFace = ua9
        ua15.TextSize = 14
        ua15.TextColor3 = Color3.fromRGB(233, 234, 238)
        ua15.TextXAlignment = Enum.TextXAlignment.Left
        ua15.TextYAlignment = Enum.TextYAlignment.Top
        ua15.TextWrapped = false
        ua15.RichText = true
        ua15.Text = ""
        ua15.Parent = ua14

        local ua16 = Instance.new("TextBox")

        ua16.Name = "Input"
        ua16.Size = UDim2.new(1, 0, 1, 0)
        ua16.BackgroundTransparency = 1
        ua16.BorderSizePixel = 0
        ua16.FontFace = ua9
        ua16.TextSize = 14
        ua16.TextColor3 = Color3.new(0, 0, 0)
        ua16.TextTransparency = 1
        ua16.TextXAlignment = Enum.TextXAlignment.Left
        ua16.TextYAlignment = Enum.TextYAlignment.Top
        ua16.TextWrapped = false
        ua16.MultiLine = true
        ua16.ClearTextOnFocus = false
        ua16.Text = ""
        ua16.ZIndex = 2
        ua16.Parent = ua14

        local ua17 = Instance.new("Frame")

        ua17.Name = "Footer"
        ua17.Position = UDim2.new(0, 0, 1, -26)
        ua17.Size = UDim2.new(1, 0, 0, 26)
        ua17.BackgroundColor3 = Color3.fromRGB(21, 23, 30)
        ua17.BorderSizePixel = 0
        ua17.Parent = ua11

        local ua18 = Instance.new("TextLabel")

        ua18.Name = "Hint"
        ua18.Position = UDim2.new(0, 10, 0, 0)
        ua18.Size = UDim2.new(0.62, 0, 1, 0)
        ua18.BackgroundTransparency = 1
        ua18.FontFace = ua9
        ua18.TextSize = 12
        ua18.TextColor3 = Color3.fromRGB(108, 116, 136)
        ua18.TextXAlignment = Enum.TextXAlignment.Left
        ua18.Text = "Lua · made for short loadstrings"
        ua18.Parent = ua17

        local ua19 = Instance.new("TextLabel")

        ua19.Name = "Count"
        ua19.Position = UDim2.new(0.62, 0, 0, 0)
        ua19.Size = UDim2.new(0.38, -54, 1, 0)
        ua19.BackgroundTransparency = 1
        ua19.FontFace = ua9
        ua19.TextSize = 12
        ua19.TextColor3 = Color3.fromRGB(139, 147, 163)
        ua19.TextXAlignment = Enum.TextXAlignment.Right
        ua19.Text = "1 / 50 lines"
        ua19.Parent = ua17

        local ua20 = Instance.new("TextButton")

        ua20.Name = "Run"
        ua20.AnchorPoint = Vector2.new(1, 0.5)
        ua20.Position = UDim2.new(1, -8, 0.5, 0)
        ua20.Size = UDim2.fromOffset(40, 18)
        ua20.BackgroundColor3 = Color3.fromRGB(29, 42, 33)
        ua20.BorderSizePixel = 0
        ua20.FontFace = ua9
        ua20.TextSize = 12
        ua20.TextColor3 = Color3.fromRGB(50, 215, 75)
        ua20.Text = "Run"

        Instance.new("UICorner", ua20).CornerRadius = UDim.new(0, 5)

        ua20.Parent = ua17

        local ua21 = false
        local ua22 = false

        local function ua23(ua24)
                local ua25 = select(2, ua24:gsub("\n", "")) + 1

                if ua25 > 50 then
                        local ua26, ua27 = 0, 0

                        for ua28 = 1, #ua24 do
                                if ua24:sub(ua28, ua28) == "\n" then
                                        ua26 = ua26 + 1

                                        if ua26 == 50 then
                                                ua27 = ua28 - 1

                                                break
                                        end
                                end
                        end

                        ua24 = ua24:sub(1, ua27)

                        if not ua22 then
                                ua22 = true

                                if ua21 then
                                        u26("Editor → 50 line limit reached")
                                end
                        end

                        ua16.Text = ua24

                        return
                end

                if ua25 < 50 then
                        ua22 = false
                end

                local ua29 = {}

                for ua30 = 1, ua25 do
                        ua29[#ua29 + 1] = ua30
                end

                ua13.Text = table.concat(ua29, "\n")

                local ua35, ua36 = pcall(u69, ua24)

                if ua35 then
                        ua15.Text = ua36
                else
                        ua15.Text = u67 and u67(ua24) or ""
                end

                ua19.TextColor3 = ua22 and Color3.fromRGB(255, 69, 58) or ua25 >= 45 and Color3.fromRGB(255, 159, 10) or Color3.fromRGB(139, 147, 163)
                ua19.Text = ua25 .. " / 50 lines"

                local ua31 = 0

                for ua32 in (ua24 .. "\n"):gmatch("(.-)\n") do
                        if ua32 ~= "" then
                                ua31 = math.max(ua31, ua8:GetTextSize(ua32, 14, Enum.Font.Code, Vector2.new(10000, 10000)).X)
                        end
                end

                local ua33 = math.max(ua25 * ua10 + 12, 240)
                local ua34 = math.max(ua31 + 8, 480)

                ua13.Size = UDim2.new(0, 34, 0, ua33)
                ua14.Size = UDim2.new(0, ua34, 0, ua33)
                ua12.CanvasSize = UDim2.fromOffset(ua34 + 48, ua33)

                if ua21 then
                        u12.SavedCode = ua24

                        if u55 then
                                pcall(task.cancel, u55)
                        end

                        u55 = task.delay(0.75, u16)
                end
        end

        ua16:GetPropertyChangedSignal("Text"):Connect(function()
                ua23(ua16.Text)
        end)

        ua20.MouseButton1Click:Connect(function()
                local ua48, ua49 = u35(u12.SavedCode)

                if ua48 then
                        ua1.Loader.PushOutput("Script executed successfully.", u63.Green)
                        u26("Script executed ✓")
                else
                        if ua49 then
                                ua1.Loader.PushOutput(tostring(ua49), u63.Red)
                        end

                        u26("Script error: " .. tostring(ua49):sub(1, 80))
                        u27("Execution failed", tostring(ua49):sub(1, 120))
                end
        end)

        pcall(ua23, u12.SavedCode or "")

        ua21 = true

        local ua36 = u45(ua2, "Open Editor", "Popup window with Studio-style colors · 50 lines max")

        ua36:Right():Button({
                Label = "Open",
                State = "Primary",
                Pushed = function()
                        ua3.Minimized = false
                end,
        })

        local ua37 = u45(ua2, "Execute", "Runs the current code immediately")

        ua37:Right():Button({
                Label = "Execute",
                State = "Primary",
                Pushed = function()
                        local ua50, ua51 = u35(u12.SavedCode)

                        if ua50 then
                                ua1.Loader.PushOutput("Script executed successfully.", u63.Green)
                                u26("Script executed ✓")
                        else
                                if ua51 then
                                        ua1.Loader.PushOutput(tostring(ua51), u63.Red)
                                end

                                u26("Script error: " .. tostring(ua51):sub(1, 80))
                                u27("Execution failed", tostring(ua51):sub(1, 120))
                        end
                end,
        })

        local ua38 = u45(ua2, "Clear Editor", "Empties the code field and the saved config")

        ua38:Right():Button({
                Label = "Clear",
                State = "Destructive",
                Pushed = function()
                        ua16.Text = ""
                        u12.SavedCode = ""

                        u26("Script Loader → Editor cleared")
                        u16()
                end,
        })

        local ua39 = u60:Form()

        u45(ua39, "Output", "Shows the results of your last script run, newest first"):Right():Button({
                Label = "Clear",
                State = "Destructive",
                Pushed = function()
                        ua1.Loader.History = {}

                        for ua41 = 1, 3 do
                                local ua42 = ua1.Loader.Output[ua41]

                                if ua42 then
                                        ua42.Text = u64(u63.Grey, "—")
                                end
                        end
                end,
        })

        for ua40 = 1, 3 do
                ua1.Loader.Output[ua40] = ua39:Row():Left():Label({
                        Text = u64(u63.Grey, "—"),
                })
        end

        ua1.Loader.PushOutput = function(ua41, ua42)
                local ua43 = ua1.Loader.History

                table.insert(ua43, 1, u64(ua42 or u63.White, u67(ua41)))

                if #ua43 > 3 then
                        table.remove(ua43, 4)
                end

                for ua44 = 1, 3 do
                        local ua45 = ua1.Loader.Output[ua44]

                        if ua45 then
                                ua45.Text = ua43[ua44] or u64(u63.Grey, "—")
                        end
                end
        end

        local ua52 = Instance.new("Frame")

        ua52.Name = "Caret"
        ua52.Size = UDim2.fromOffset(2, math.max(ua10 - 4, 10))
        ua52.BackgroundColor3 = Color3.fromRGB(240, 241, 245)
        ua52.BorderSizePixel = 0
        ua52.Visible = false
        ua52.ZIndex = 2
        ua52.Parent = ua14

        local ua53 = nil

        local function ua54()
                local ua56 = string.split(ua16.Text, "\n")
                local ua57 = ua16.CursorPosition
                local ua58 = math.clamp(ua57.Y, 1, #ua56)
                local ua59 = ua56[ua58] or ""
                local ua60 = ua8:GetTextSize(ua59:sub(1, math.max(math.min(ua57.X - 1, #ua59), 0)), 14, Enum.Font.Code, Vector2.new(10000, 10000)).X

                ua52.Position = UDim2.fromOffset(ua60, (ua58 - 1) * ua10 + 2)

                local ua61 = ua12.AbsoluteWindowSize

                if ua61.X > 1 then
                        local ua62 = ua12.CanvasPosition

                        if ua60 < ua62.X or ua60 > ua62.X + ua61.X - 60 then
                                ua12.CanvasPosition = Vector2.new(math.max(ua60 - ua61.X + 120, 0), ua62.Y)
                        end

                        local ua63 = (ua58 - 1) * ua10

                        if ua63 < ua62.Y or ua63 > ua62.Y + ua61.Y - ua10 * 2 - 30 then
                                ua12.CanvasPosition = Vector2.new(ua12.CanvasPosition.X, math.max(ua63 - ua61.Y + ua10 * 2 + 30, 0))
                        end
                end
        end

        local function ua55()
                for ua56, ua57 in pairs(ua14:GetChildren()) do
                        if ua57.Name == "SelRect" then
                                ua57:Destroy()
                        end
                end

                local ua56 = ua16.SelectionStart
                local ua57 = ua16.CursorPosition

                if not ua16:IsFocused() or not ua56 or not ua57 then
                        return
                end

                local ua58 = string.split(ua16.Text, "\n")
                local ua59, ua60 = math.min(ua56.Y, ua57.Y), math.max(ua56.Y, ua57.Y)

                if ua59 < 1 or ua59 > #ua58 + 1 or (ua59 == ua60 and ua56.X == ua57.X) then
                        return
                end

                for ua61 = math.max(ua59, 1), math.min(ua60, #ua58) do
                        local ua62, ua63 = 0, 0
                        local ua64 = ua58[ua61] or ""

                        if ua61 == ua59 and ua61 == ua60 then
                                ua62 = math.min(ua56.X, ua57.X) - 1
                                ua63 = math.max(ua56.X, ua57.X) - 1
                        elseif ua61 == ua59 then
                                ua62 = (ua56.Y <= ua57.Y and ua56.X or ua57.X) - 1
                                ua63 = #ua64
                        elseif ua61 == ua60 then
                                ua63 = (ua56.Y <= ua57.Y and ua57.X or ua56.X) - 1
                        else
                                ua63 = #ua64
                        end

                        local ua65 = ua8:GetTextSize(ua64:sub(1, math.max(math.min(ua62, #ua64), 0)), 14, Enum.Font.Code, Vector2.new(10000, 10000)).X
                        local ua66 = ua8:GetTextSize(ua64:sub(1, math.max(math.min(ua63, #ua64), 0)), 14, Enum.Font.Code, Vector2.new(10000, 10000)).X
                        local ua67 = Instance.new("Frame")

                        ua67.Name = "SelRect"
                        ua67.BackgroundColor3 = Color3.fromRGB(58, 110, 180)
                        ua67.BackgroundTransparency = 0.5
                        ua67.BorderSizePixel = 0
                        ua67.Position = UDim2.fromOffset(ua65, (ua61 - 1) * ua10)
                        ua67.Size = UDim2.fromOffset(math.max(ua66 - ua65, 5), ua10)
                        ua67.ZIndex = 1
                        ua67.Parent = ua14
                end
        end

        ua16.Focused:Connect(function()
                if ua53 then
                        pcall(task.cancel, ua53)
                end

                ua52.Visible = true
                ua54()

                ua53 = task.spawn(function()
                        while ua52.Parent and ua16:IsFocused() do
                                task.wait(0.45)

                                if not (ua52.Parent and ua16:IsFocused()) then
                                        break
                                end

                                ua52.Visible = not ua52.Visible
                        end
                end)

                ua55()
        end)

        ua16.FocusLost:Connect(function()
                if ua53 then
                        pcall(task.cancel, ua53)

                        ua53 = nil
                end

                ua52.Visible = false
                ua55()
        end)

        ua16:GetPropertyChangedSignal("CursorPosition"):Connect(function()
                ua54()
                ua55()
        end)

        ua16:GetPropertyChangedSignal("SelectionStart"):Connect(function()
                ua55()
        end)

        ua16:GetPropertyChangedSignal("Text"):Connect(function()
                ua54()
                ua55()
        end)
end

do
        local ua1 = _G.UU.UI
        local ua2 = u61:PageSection({ Title = "FPS Unlock" }):Form()

        ua1.Perf = {}

        ua1.Perf.Target = u45(ua2, "Selected Limit"):Right():Label({
                Text = u64(u63.Cyan, u12.TargetFPS .. " FPS"),
        })

        local ua3 = u45(ua2, "Target FPS", "Custom framerate limit from 15 to 360")

        u47(ua3, {
                Minimum = 15,
                Maximum = 360,
                Value = u12.TargetFPS,
                ValueChanged = function(ua8, ua9)
                        u12.TargetFPS = math.floor(ua9 + 0.5)

                        if ua1.Perf.Target then
                                ua1.Perf.Target.Text = u64(u63.Cyan, u12.TargetFPS .. " FPS")
                        end

                        if u12.FPSUnlockEnabled then
                                u37()
                        end

                        u16()
                end,
        })

        local ua4 = u45(ua2, "FPS Unlock", "Removes the default 60 FPS cap")

        ua1.Perf.Toggle = ua4:Right():Toggle({
                Value = u12.FPSUnlockEnabled,
                ValueChanged = function(ua8, ua9)
                        if ua1.SyncFps or not u48 then
                                return
                        end

                        if not u36 then
                                ua1.SyncFps = true
                                ua8.Value = false
                                ua1.SyncFps = false

                                u26("FPS Unlock → Not supported by executor")
                                u27("FPS Unlock", "Not supported by this executor")
                                return
                        end

                        u12.FPSUnlockEnabled = ua9
                        u37()
                        u26("FPS Unlock → " .. (ua9 and ("Enabled (" .. u12.TargetFPS .. " FPS)") or "Disabled"))
                        u16()
                end,
        })

        local ua5 = u61:PageSection({ Title = "Framerate" }):Form()

        ua1.Perf.FpsCurrent = u45(ua5, "Current"):Right():Label({
                Text = u64(u63.Green, "60"),
        })

        ua1.Perf.FpsAvg = u45(ua5, "Average"):Right():Label({
                Text = u64(u63.Mint, "60"),
        })

        ua1.Perf.FpsRange = u45(ua5, "Range"):Right():Label({
                Text = u64(u63.Grey, "Min: 60 | Max: 60"),
        })

        local ua6 = u61:PageSection({ Title = "Network" }):Form()

        ua1.Perf.PingCurrent = u45(ua6, "Current"):Right():Label({
                Text = u64(u63.Green, "0 ms"),
        })

        ua1.Perf.PingAvg = u45(ua6, "Average"):Right():Label({
                Text = u64(u63.Mint, "0 ms"),
        })

        ua1.Perf.PingRange = u45(ua6, "Range"):Right():Label({
                Text = u64(u63.Grey, "Min: 0 ms | Max: 0 ms"),
        })

        ua1.Perf.Quality = u45(ua6, "Connection Quality"):Right():Label({
                Text = u64(u63.Grey, "Measuring..."),
        })

        local ua7 = u61:PageSection({ Title = "Memory" }):Form()

        ua1.Perf.MemCurrent = u45(ua7, "Current"):Right():Label({
                Text = u64(u63.Purple, "0 MB"),
        })

        ua1.Perf.MemPeak = u45(ua7, "Peak"):Right():Label({
                Text = u64(u63.Pink, "0 MB"),
        })
end

do
        local ua1 = _G.UU.UI
        local ua2 = u62:PageSection({ Title = "Appearance", Subtitle = "Theme and accent apply instantly across the whole interface" }):Form()

        ua1.Settings = { Activity = {} }

        local ua3 = u45(ua2, "Theme", "Pick between the light and the dark appearance")
        local ua4 = u12.ThemeMode == "Dark" and 2 or 1

        ua1.Settings.Theme = ua3:Right():RadioButtonGroup({
                Options = { "Light", "Dark" },
                ValueChanged = function(ua5, ua6)
                        if not u48 then
                                return
                        end

                        local ua7 = ua6 == 2 and "Dark" or "Light"

                        if ua7 == u12.ThemeMode then
                                return
                        end

                        u12.ThemeMode = ua7
                        u39.Theme = ua7 == "Dark" and u38.Themes.Dark or u38.Themes.Light
                        u71.Theme = u39.Theme

                        u26("Theme → " .. ua7)
                        u16()
                end,
        })

        ua1.Settings.Theme.Value = ua4

        local ua6 = u45(ua2, "Accent Color", "Highlight color used by switches, buttons and selections")
        local ua7 = { "Blue", "Purple", "Pink", "Red", "Orange", "Yellow", "Green", "Graphite" }
        local ua8 = 0

        for ua9, ua10 in ipairs(ua7) do
                if ua10 == u12.AccentName then
                        ua8 = ua9
                end
        end

        if ua8 == 0 then
                ua8 = 1
                u12.AccentName = "Blue"
        end

        ua1.Settings.Accent = ua6:Right():PullDownButton({
                Options = ua7,
                Value = ua8,
                Label = u64(u63[u12.AccentName] or u63.Blue, u12.AccentName),
                ValueChanged = function(ua11, ua12)
                        if not u48 then
                                return
                        end

                        local ua13 = ua7[ua12]

                        if not ua13 then
                                return
                        end

                        u12.AccentName = ua13
                        u39.Accent = u38.Accents[ua13]
                        u71.Accent = u39.Accent

                        ua11.Label = u64(u63[ua13] or u63.Blue, ua13)

                        u26("Accent → " .. ua13)
                        u16()
                end,
        })

        do
                local ua28 = ua1.Settings.Accent.Structures.PullDownIndicator

                ua28.Indicators.Image = u38.Symbols.chevronDown
                ua28.Indicators.Size = UDim2.fromOffset(14, 14)
                ua28.Indicators.AnchorPoint = Vector2.new(0.5, 0.5)
                ua28.Indicators.Position = UDim2.fromScale(0.5, 0.5)
                ua28.Indicators.ScaleType = Enum.ScaleType.Fit
        end

        local ua14 = u62:PageSection({ Title = "Interface" }):Form()

        local ua15 = u45(ua14, "Toggle Keybind", "Show or hide the window")

        ua15:Right():KeybindField({
                Value = u12.Keybind,
                ValueChanged = function(ua16, ua17)
                        if not u48 then
                                return
                        end

                        u12.Keybind = ua17
                        u26("Keybind → " .. ua17.Name)
                        u16()
                end,
                BindPressed = function(ua16, ua17, ua18, ua19)
                        if not ua18 or ua19 then
                                return
                        end

                        u40.Minimized = not u40.Minimized
                end,
        })

        local ua20 = u45(ua14, "Auto Hide UI", "Starts minimized on the next injection")

        ua20:Right():Toggle({
                Value = u12.AutoHideEnabled,
                ValueChanged = function(ua16, ua17)
                        if not u48 then
                                return
                        end

                        u12.AutoHideEnabled = ua17
                        u26("Auto Hide UI → " .. (ua17 and "Enabled" or "Disabled"))
                        u16()
                end,
        })

        local ua21 = u62:Form()

        u45(ua21, "Activity", "Tracks every action with a timestamp, newest first"):Right():Button({
                Label = "Clear",
                State = "Destructive",
                Pushed = function()
                        _G.UU.LogBuffer = {}

                        for ua23 = 1, 6 do
                                local ua24 = ua1.Settings.Activity[ua23]

                                if ua24 then
                                        ua24.Text = u64(u63.Grey, "—")
                                end
                        end
                end,
        })

        for ua22 = 1, 6 do
                ua1.Settings.Activity[ua22] = ua21:Row():Left():Label({
                        Text = _G.UU.LogBuffer[ua22] or u64(u63.Grey, "—"),
                })
        end

        local ua23 = u62:PageSection({ Title = "Danger Zone", Subtitle = "Fully removes Universal Utility and stops everything it runs" }):Form()

        local ua24 = u45(ua23, "Uninject", "Press twice to confirm the removal"):Right():Button({
                Label = "Uninject",
                State = "Destructive",
                Pushed = function(ua25)
                        if not u54 then
                                u54 = true
                                ua25.Label = "Click again to confirm"
                                u26("Uninject → click again to confirm")

                                task.delay(3, function()
                                        u54 = false

                                        if ua25.Parent then
                                                ua25.Label = "Uninject"
                                        end
                                end)

                                return
                        end

                        u54 = false
                        ua25.Label = "Uninjecting..."
                        u26("Uninject → stopping everything")
                        u15()

                        task.delay(0.15, function()
                                for ua26, ua27 in pairs(_G.UU.Threads) do
                                        if typeof(ua27) == "thread" and coroutine.status(ua27) ~= "dead" then
                                                pcall(task.cancel, ua27)
                                        end

                                        _G.UU.Threads[ua26] = nil
                                end

                                for ua26, ua27 in pairs(_G.UU.Connections) do
                                        pcall(function()
                                                ua27:Disconnect()
                                        end)
                                end

                                _G.UU.Connections = {}

                                if u36 then
                                        pcall(setfpscap, 60)
                                end

                                pcall(function()
                                        if typeof(dequeue_on_teleport) == "function" then
                                                dequeue_on_teleport()
                                        end
                                end)

                                u71:Destroy()
                                u39:Destroy()

                                _G.UU.Threads = {}
                                _G.UU.Connections = {}
                                _G.UU.UI = {}
                                _G.UU.App = nil
                                _G.UU.EditorApp = nil
                                _G.UU.CFG = nil
                                _G.UU.SaveCFG = nil
                                _G.UU.DebouncedSave = nil
                                _G.UU.Loaded = false
                                _G.UU.LoadLock = false
                        end)
                end,
        })
end

for ua1, ua2 in pairs(_G.UU.UI.Tabs) do
        ua2.Activated:Connect(function()
                u12.CurrentTab = ua1
                u16()
        end)
end

local ua1 = _G.UU.UI.Tabs[u12.CurrentTab] and u12.CurrentTab or "Home"
_G.UU.UI.Tabs[ua1].Selected = true

u48 = true

table.insert(_G.UU.Connections, u3.InputBegan:Connect(function(ua2, ua3)
        if ua3 then
                return
        end

        if ua2.KeyCode == Enum.KeyCode.F5 and ua2.KeyCode ~= u12.Keybind then
                u30(not u12.MousePosEnabled, false)
        end
end))

table.insert(_G.UU.Connections, u1.PlayerAdded:Connect(function()
        if _G.UU.UI.Home and _G.UU.UI.Home.Players then
                _G.UU.UI.Home.Players.Text = u64(u63.Lime, #u1:GetPlayers() .. " / " .. u1.MaxPlayers)
        end
end))

table.insert(_G.UU.Connections, u1.PlayerRemoving:Connect(function()
        if _G.UU.UI.Home and _G.UU.UI.Home.Players then
                _G.UU.UI.Home.Players.Text = u64(u63.Lime, #u1:GetPlayers() .. " / " .. u1.MaxPlayers)
        end
end))

local function ua4()
        local ua2 = workspace.CurrentCamera

        if not ua2 then
                return
        end

        if _G.UU.UI.Home and _G.UU.UI.Home.Resolution then
                _G.UU.UI.Home.Resolution.Text = u64(u63.Cyan, string.format("%dx%d", ua2.ViewportSize.X, ua2.ViewportSize.Y))
        end
end

ua4()

local function ua5()
        local ua2 = workspace.CurrentCamera

        if ua2 then
                table.insert(_G.UU.Connections, ua2:GetPropertyChangedSignal("ViewportSize"):Connect(ua4))
        end
end

ua5()

table.insert(_G.UU.Connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(ua5))

table.insert(_G.UU.Connections, u2.RenderStepped:Connect(function()
        u51 = u51 + 1
        local ua2 = tick()

        if ua2 - u52 >= 1 then
                local ua3 = math.floor(u51 / (ua2 - u52))
                u51 = 0
                u52 = ua2

                table.remove(u49, 1)
                table.insert(u49, ua3)

                local ua4, ua5, ua6 = math.huge, 0, 0

                for ua7, ua8 in ipairs(u49) do
                        ua4 = math.min(ua4, ua8)
                        ua5 = math.max(ua5, ua8)
                        ua6 = ua6 + ua8
                end

                local ua9 = math.floor(ua6 / #u49)
                local ua10 = _G.UU.UI
                local ua11 = u8:GetTotalMemoryUsageMb()
                u53 = math.max(u53, ua11)

                if ua10.Home then
                        if ua10.Home.FPS then
                                ua10.Home.FPS.Text = u64(u63.Green, ua3)
                        end

                        if ua10.Home.Memory then
                                ua10.Home.Memory.Text = u64(u63.Purple, string.format("%.1f MB", ua11))
                        end
                end

                if ua10.Perf then
                        if ua10.Perf.FpsCurrent then
                                ua10.Perf.FpsCurrent.Text = u64(u63.Green, ua3)
                        end

                        if ua10.Perf.FpsAvg then
                                ua10.Perf.FpsAvg.Text = u64(u63.Mint, ua9)
                        end

                        if ua10.Perf.FpsRange then
                                ua10.Perf.FpsRange.Text = u64(u63.Grey, string.format("Min: %d | Max: %d", ua4, ua5))
                        end

                        if ua10.Perf.MemCurrent then
                                ua10.Perf.MemCurrent.Text = u64(u63.Purple, string.format("%.1f MB", ua11))
                        end

                        if ua10.Perf.MemPeak then
                                ua10.Perf.MemPeak.Text = u64(u63.Pink, string.format("%.1f MB", u53))
                        end
                end
        end

        if tick() - (_G.UU.LastPingTime or 0) >= 2 then
                _G.UU.LastPingTime = tick()

                local ua2 = math.floor(u9:GetNetworkPing() * 1000)
                table.remove(u50, 1)
                table.insert(u50, ua2)

                local ua3, ua4, ua5 = math.huge, 0, 0

                for ua6, ua7 in ipairs(u50) do
                        ua3 = math.min(ua3, ua7)
                        ua4 = math.max(ua4, ua7)
                        ua5 = ua5 + ua7
                end

                local ua8 = math.floor(ua5 / #u50)
                local ua9 = _G.UU.UI

                if ua9.Home and ua9.Home.Ping then
                        ua9.Home.Ping.Text = u64(u68(ua2), ua2 .. " ms")
                end

                if ua9.Perf then
                        if ua9.Perf.PingCurrent then
                                ua9.Perf.PingCurrent.Text = u64(u68(ua2), ua2 .. " ms")
                        end

                        if ua9.Perf.PingAvg then
                                ua9.Perf.PingAvg.Text = u64(u63.Mint, ua8 .. " ms")
                        end

                        if ua9.Perf.PingRange then
                                ua9.Perf.PingRange.Text = u64(u63.Grey, string.format("Min: %d ms | Max: %d ms", ua3, ua4))
                        end

                        if ua9.Perf.Quality then
                                local ua10

                                if ua2 < 50 then
                                        ua10 = "Excellent"
                                elseif ua2 < 100 then
                                        ua10 = "Good"
                                elseif ua2 < 200 then
                                        ua10 = "Fair"
                                elseif ua2 < 300 then
                                        ua10 = "Poor"
                                else
                                        ua10 = "Very Poor"
                                end

                                ua9.Perf.Quality.Text = u64(u68(ua2), ua10)
                        end
                end
        end
end))

u29("MouseLabel", function()
        while true do
                task.wait(0.25)

                local ua2 = _G.UU.UI

                if ua2.AntiAFK and ua2.AntiAFK.MouseState and ua2.AntiAFK.MouseState.Parent then
                        ua2.AntiAFK.MouseState.Text = u65(u12.MousePosEnabled, u12.MousePosSaved.X, u12.MousePosSaved.Y)
                end
        end
end)

if u12.JumpEnabled then
        task.defer(u31)
end

if u12.ClickEnabled then
        task.defer(u32)
end

if u12.AutoSpamEnabled and not u33() then
        u12.AutoSpamEnabled = false

        _G.UU.UI.SyncSpam = true
        _G.UU.UI.Spam.Toggle.Value = false
        _G.UU.UI.SyncSpam = false

        u26("Key Spam → Invalid key '" .. u12.SpamKey .. "' saved in config")
end

if u12.AutoRejoinEnabled then
        u34()
end

if u12.FPSUnlockEnabled and u36 then
        u37()
else
        if u36 then
                pcall(setfpscap, 60)
        end

        if u12.FPSUnlockEnabled and not u36 then
                u12.FPSUnlockEnabled = false

                _G.UU.UI.SyncFps = true
                _G.UU.UI.Perf.Toggle.Value = false
                _G.UU.UI.SyncFps = false

                u26("FPS Unlock → Not supported by executor")
        end
end

if u12.MousePosEnabled then
        u30(true, false)
end

u39.Destroying:Connect(function()
        u15()

        for ua2, ua3 in pairs(_G.UU.Threads) do
                if typeof(ua3) == "thread" and coroutine.status(ua3) ~= "dead" then
                        pcall(task.cancel, ua3)
                end
        end
end)

if queue_on_teleport and not _G.UU.TeleportQueued then
        _G.UU.TeleportQueued = true

        pcall(function()
                queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/6942x/UniversalUtility/main/Init.lua", true))()')
        end)
end

_G.UU.Loaded = true
_G.UU.LoadLock = false

task.defer(function()
        if u18 then
                u26("Config loaded for " .. u10 .. " (Id: " .. u11 .. ")")
                u27("Welcome back", "Config loaded for " .. u10)
        else
                u26("Fresh start — no saved config found")
                u26("Defaults applied · Keybind: G")
                u27("Welcome", "Universal Utility is ready")
        end

        local ua2 = _G.UU.UI

        if ua2.Loader and ua2.Loader.PushOutput and u12.AutoLoadEnabled and u12.SavedCode ~= "" then
                u26("Auto Load → executing saved script")

                local ua3, ua4 = u35(u12.SavedCode)

                if ua3 then
                        ua2.Loader.PushOutput("Auto-load executed successfully.", u63.Green)
                        u26("Auto Load → script executed ✓")
                else
                        if ua4 then
                                ua2.Loader.PushOutput(tostring(ua4), u63.Red)
                        end

                        u26("Auto Load error: " .. tostring(ua4):sub(1, 80))
                        u27("Auto Load failed", tostring(ua4):sub(1, 120))
                end
        end
end)

return _G.UU
