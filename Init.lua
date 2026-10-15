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

local u12 = _G

pcall(function()
    local u13 = getgenv()

    if typeof(u13) == "table" then
        u12 = u13
    end
end)

u12.UU = u12.UU or {}
_G.UU = u12.UU
_G.UU.LogBuffer = _G.UU.LogBuffer or {}

while true do
    local u13 = tonumber(_G.UU.LoadLockTime) or 0
    local u14 = os.clock() - u13

    if _G.UU.Loaded or (_G.UU.LoadLock == true and (u13 == 0 or u14 >= 5 or u14 < 0)) then
        for u15, u16 in pairs(_G.UU.Threads or {}) do
            if typeof(u16) == "thread" and coroutine.status(u16) ~= "dead" then
                pcall(task.cancel, u16)
            end

            _G.UU.Threads[u15] = nil
        end

        for u15, u16 in pairs(_G.UU.Connections or {}) do
            pcall(function()
                u16:Disconnect()
            end)
        end

        if _G.UU.HeldMouse then
            pcall(function()
                u4:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
        if _G.UU.HeldKey then
            pcall(function()
                u4:SendKeyEvent(false, _G.UU.HeldKey, false, game)
            end)
        end
        _G.UU.HeldMouse = false
        _G.UU.HeldKey = nil

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

        break
    end

    if _G.UU.LoadLock ~= true then
        break
    end

    task.wait(0.1)
end

_G.UU.LoadLock = true
_G.UU.LoadLockTime = os.clock()
_G.UU.Threads = {}
_G.UU.Connections = {}
_G.UU.SavePending = false
_G.UU.LastSaveTime = 0
_G.UU.Session = {}
local u17 = _G.UU.Session

local function u18()
    return _G.UU.Session == u17
end

local u19 = {
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

_G.UU.CFG = u19

local u20 = {
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

local function u21(u13, u14)
    return '<font color="' .. u13 .. '">' .. tostring(u14) .. "</font>"
end

local function u22(u13, u14, u15)
    return "["
        .. u21(u13 and u20.Mint or u20.Yellow, u13 and "Tracking" or "Locked")
        .. "] F5 · "
        .. u21(u20.Grey, math.floor(u14) .. ", " .. math.floor(u15))
end

local function u23(u13)
    u13 = tostring(u13)

    if
        u13:find("error", 1, true)
        or u13:find("failed", 1, true)
        or u13:find("Invalid", 1, true)
        or u13:find("reserved", 1, true)
        or u13:find("Not supported", 1, true)
        or u13:find("Uninject", 1, true)
    then
        return u20.Red
    end

    if u13:find("✓", 1, true) then
        return u20.Green
    end

    local u14 = {
        { "Auto Jump", u20.Green },
        { "Auto Click", u20.Orange },
        { "Key Spam", u20.Yellow },
        { "Auto Rejoin", u20.Cyan },
        { "Mouse", u20.Mint },
        { "Auto Load", u20.Blue },
        { "Script", u20.Blue },
        { "FPS", u20.Pink },
        { "Keybind", u20.Purple },
        { "Accent", u20.Pink },
        { "Theme", u20.Indigo },
        { "Config", u20.Lime },
        { "Fresh", u20.Lime },
        { "Defaults", u20.Lime },
    }

    for u15, u16 in ipairs(u14) do
        if u13:find(u16[1], 1, true) then
            return u16[2]
        end
    end

    return u20.White
end

local function u24(u13)
    local u14 = tostring(u13)

    u14 = u14:gsub("&", "&amp;")
    u14 = u14:gsub("<", "&lt;")
    u14 = u14:gsub(">", "&gt;")

    return u14
end

local function u25(u13)
    if u13 < 50 then
        return u20.Green
    end

    if u13 < 100 then
        return u20.Mint
    end

    if u13 < 200 then
        return u20.Yellow
    end

    if u13 < 300 then
        return u20.Orange
    end

    return u20.Red
end

local function u26(u13)
    local u14 = {}
    local u15 = 1
    local u16 = #u13
    local u27 = false
    local u28 = {
        Keyword = "#EA6C98",
        Number = "#FFC600",
        String = "#02B875",
        Comment = "#6E7681",
        Builtin = "#01A2E2",
        Func = "#C7A5FF",
        Prop = "#B5BFC8",
    }
    local u29 = {
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
    local u30 = {
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

    while u15 <= u16 do
        local u31 = u13:match("^%-%-%[=*%[", u15)

        if u31 then
            local u32, u33 = u13:find("]" .. u31:match("%[(=*)%[") .. "]", u15 + #u31, true)
            local u34 = u33 or u16

            u14[#u14 + 1] = '<font color="' .. u28.Comment .. '">' .. u24(u13:sub(u15, u34)) .. "</font>"

            u15 = u34 + 1
        elseif u13:sub(u15, u15 + 1) == "--" then
            local u31 = u13:find("\n", u15, true) or u16 + 1

            u14[#u14 + 1] = '<font color="' .. u28.Comment .. '">' .. u24(u13:sub(u15, u31 - 1)) .. "</font>"

            u15 = u31
        elseif u13:match("^%[=*%[", u15) then
            local u31 = u13:match("^%[=*%[", u15)
            local u32, u33 = u13:find("]" .. u31:match("%[(=*)%[") .. "]", u15 + #u31, true)
            local u34 = u33 or u16

            u14[#u14 + 1] = '<font color="' .. u28.String .. '">' .. u24(u13:sub(u15, u34)) .. "</font>"

            u15 = u34 + 1
        elseif u13:sub(u15, u15) == '"' or u13:sub(u15, u15) == "'" then
            local u31 = u13:sub(u15, u15)
            local u32 = u15 + 1

            while u32 <= u16 do
                local u33 = u13:sub(u32, u32)

                if u33 == "\\" then
                    u32 = u32 + 2
                elseif u33 == u31 then
                    u32 = u32 + 1

                    break
                else
                    u32 = u32 + 1
                end
            end

            u32 = math.min(u32, u16 + 1)

            u14[#u14 + 1] = '<font color="' .. u28.String .. '">' .. u24(u13:sub(u15, u32 - 1)) .. "</font>"

            u15 = u32
        else
            local u31 = u13:match("^0[xX]%x+", u15)
                or u13:match("^%d*%.?%d+[eE][+-]?%d+", u15)
                or u13:match("^%d*%.?%d+", u15)
                or u13:match("^%.%d+", u15)

            if u31 then
                u14[#u14 + 1] = '<font color="' .. u28.Number .. '">' .. u31 .. "</font>"

                u15 = u15 + #u31
            else
                local u31 = u13:match("^[%a_][%w_]*", u15)

                if u31 then
                    local u32 = u13:sub(u15 - 1, u15 - 1)

                    if u29[u31] then
                        u14[#u14 + 1] = '<font color="' .. u28.Keyword .. '">' .. u31 .. "</font>"

                        u27 = u31 == "function"
                    elseif u27 then
                        u14[#u14 + 1] = '<font color="' .. u28.Func .. '">' .. u31 .. "</font>"

                        u27 = false
                    elseif u30[u31] then
                        u14[#u14 + 1] = '<font color="' .. u28.Builtin .. '">' .. u31 .. "</font>"
                    elseif u32 == "." or u32 == ":" then
                        u14[#u14 + 1] = '<font color="' .. u28.Prop .. '">' .. u31 .. "</font>"
                    else
                        u14[#u14 + 1] = u31
                    end

                    u15 = u15 + #u31
                else
                    local u31 = u13:sub(u15, u15)

                    u14[#u14 + 1] = u24(u31)

                    if u31 ~= " " and u31 ~= "\t" and u31 ~= "\n" and u31 ~= "\r" then
                        u27 = false
                    end

                    u15 = u15 + 1
                end
            end
        end
    end

    return table.concat(u14)
end

local function u35()
    return "UniversalUtility/Accounts/" .. u10 .. ".json"
end

local function u36()
    if makefolder and isfolder then
        if not isfolder("UniversalUtility") then
            makefolder("UniversalUtility")
        end

        if not isfolder("UniversalUtility/Accounts") then
            makefolder("UniversalUtility/Accounts")
        end
    end
end

local function u37()
    if not u18() then
        return false
    end
    if not writefile then
        return false
    end

    u36()

    local u13 = pcall(function()
        writefile(
            u35(),
            u:JSONEncode({
                UserId = u11,
                Username = u10,
                Keybind = u19.Keybind.Name,
                JumpEnabled = u19.JumpEnabled,
                ClickEnabled = u19.ClickEnabled,
                AutoSpamEnabled = u19.AutoSpamEnabled,
                AutoLoadEnabled = u19.AutoLoadEnabled,
                AutoRejoinEnabled = u19.AutoRejoinEnabled,
                AutoHideEnabled = u19.AutoHideEnabled,
                FPSUnlockEnabled = u19.FPSUnlockEnabled,
                MousePosEnabled = u19.MousePosEnabled,
                TargetFPS = u19.TargetFPS,
                JumpDelay = u19.JumpDelay,
                ClickDelay = u19.ClickDelay,
                SpamDelay = u19.SpamDelay,
                SpamKey = u19.SpamKey,
                SavedCode = u19.SavedCode,
                CurrentTab = u19.CurrentTab,
                ThemeMode = u19.ThemeMode,
                AccentName = u19.AccentName,
                MousePosSaved = u19.MousePosSaved,
            })
        )
    end)

    if u13 then
        _G.UU.LastSaveTime = tick()
        _G.UU.SavePending = false
    end

    return u13
end

_G.UU.SaveCFG = u37

local function u38()
    if not u18() then
        return
    end
    if _G.UU.SavePending then
        return
    end

    _G.UU.SavePending = true

    local u13 = tick() - _G.UU.LastSaveTime

    if u13 >= 0.1 then
        _G.UU.SavePending = false
        u37()
    else
        task.delay(0.1 - u13, function()
            if _G.UU.SavePending then
                _G.UU.SavePending = false
                u37()
            end
        end)
    end
end

_G.UU.DebouncedSave = u38

local function u39()
    if not (readfile and isfile) then
        return false
    end

    local u13 = u35()

    if not isfile(u13) then
        return false
    end

    local u14, u15 = pcall(function()
        return u:JSONDecode(readfile(u13))
    end)

    if not u14 or type(u15) ~= "table" or u15.UserId ~= u11 then
        return false
    end

    u19.Keybind = Enum.KeyCode[u15.Keybind] or Enum.KeyCode.G
    u19.JumpEnabled = u15.JumpEnabled or false
    u19.ClickEnabled = u15.ClickEnabled or false
    u19.AutoSpamEnabled = u15.AutoSpamEnabled or false
    u19.AutoLoadEnabled = u15.AutoLoadEnabled or false
    u19.AutoRejoinEnabled = u15.AutoRejoinEnabled or false
    u19.AutoHideEnabled = u15.AutoHideEnabled or false
    u19.FPSUnlockEnabled = u15.FPSUnlockEnabled or false
    u19.MousePosEnabled = u15.MousePosEnabled or false
    u19.TargetFPS = math.clamp(tonumber(u15.TargetFPS) or 60, 15, 360)
    u19.JumpDelay = math.clamp(tonumber(u15.JumpDelay) or 10, 1, 600)
    u19.ClickDelay = math.clamp(tonumber(u15.ClickDelay) or 3, 0.01, 600)
    u19.SpamDelay = math.clamp(tonumber(u15.SpamDelay) or 0.1, 0.05, 5)
    u19.SpamKey = u15.SpamKey or "Q"
    u19.SavedCode = u15.SavedCode or ""
    u19.CurrentTab = u15.CurrentTab or "Home"
    u19.ThemeMode = u15.ThemeMode == "Light" and "Light" or "Dark"
    u19.AccentName = type(u15.AccentName) == "string" and u15.AccentName or "Blue"
    u19.MousePosSaved = u15.MousePosSaved or { X = 960, Y = 540 }

    return true
end

local u40 = u39()

local function u41(u13)
    u13 = u13 < 1 and math.floor(u13 * 100 + 0.5) / 100 or math.floor(u13 * 10 + 0.5) / 10

    if u13 < 1 then
        return string.format("%.2fs", u13)
    end

    if u13 < 60 then
        if u13 % 1 == 0 then
            return string.format("%ds", u13)
        end

        return string.format("%.1fs", u13)
    end

    local u14 = math.floor(u13 / 60 + 0.001)
    local u15 = math.floor(u13 - u14 * 60 + 0.5)

    if u15 >= 60 then
        u14, u15 = u14 + 1, 0
    end

    if u15 == 0 then
        return string.format("%dm", u14)
    end

    return string.format("%dm %02ds", u14, u15)
end

local function u42(u13)
    return math.floor((600 ^ math.clamp(u13, 0, 1)) * 10 + 0.5) / 10
end

local function u43(u13)
    u13 = math.clamp(u13, 1, 600)
    return math.clamp(math.log(u13) / math.log(600), 0, 1)
end

local function u44(u13)
    local u14 = 0.01 * 60000 ^ math.clamp(u13, 0, 1)

    if u14 < 1 then
        return math.floor(u14 * 100 + 0.5) / 100
    end

    return math.floor(u14 * 10 + 0.5) / 10
end

local function u45(u13)
    u13 = math.clamp(u13, 0.01, 600)
    return math.clamp(math.log(u13 / 0.01) / math.log(60000), 0, 1)
end

local function u46()
    if u3.TouchEnabled and not u3.KeyboardEnabled and not u3.MouseEnabled then
        return "Mobile"
    end

    if u3.GamepadEnabled and not u3.KeyboardEnabled then
        return "Console"
    end

    if u3.KeyboardEnabled and u3.MouseEnabled then
        return "PC"
    end

    local u13 = u3:GetLastInputType()

    if u13 == Enum.UserInputType.Touch then
        return "Mobile"
    end

    if u13 == Enum.UserInputType.Gamepad1 or u13 == Enum.UserInputType.Gamepad2 then
        return "Console"
    end

    return "PC"
end

local function u47(u13)
    if type(u13) ~= "string" or #u13 ~= 2 then
        return "🌐"
    end

    local u14, u15 = u13:upper():byte(1, 2)

    if u14 < 65 or u14 > 90 or u15 < 65 or u15 > 90 then
        return "🌐"
    end

    return utf8.char(0x1F1E6 + u14 - 65, 0x1F1E6 + u15 - 65)
end

local u48 = {
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

local function u49(u13)
    task.spawn(function()
        local u14 = nil
        local u15 = game.JobId

        if u15 ~= "" then
            for u16, u27 in pairs(u48) do
                if u15:lower():find(u16, 1, true) then
                    u14 = u47(u16:sub(1, 2)) .. " " .. u27
                    break
                end
            end
        end

        if not u14 then
            local u28, u29 = pcall(function()
                return u:JSONDecode(game:HttpGet("https://ipinfo.io/json", true))
            end)

            if u28 and type(u29) == "table" and u29.country then
                u14 = u47(u29.country) .. " " .. u29.country

                if u29.region and u29.region ~= "" then
                    u14 = u14 .. " - " .. u29.region
                end

                if u29.city and u29.city ~= "" then
                    u14 = u14 .. ", " .. u29.city
                end
            end
        end

        if u13 and u13.Parent then
            u13.Text = u21(u20.Grey, "Server Region: ") .. u21(u20.Mint, u24(u14 or "Unknown"))
        end
    end)
end

local function u50(u13)
    if not u18() then
        return
    end
    local u14 = os.date and os.date("%H:%M:%S") or "--:--:--"

    table.insert(_G.UU.LogBuffer, 1, "[" .. u21(u20.Cyan, u14) .. "] " .. u21(u23(u13), u24(u13)))

    if #_G.UU.LogBuffer > 6 then
        table.remove(_G.UU.LogBuffer, 7)
    end

    local u15 = _G.UU.UI

    if u15 and u15.Settings then
        for u16 = 1, 6 do
            local u27 = u15.Settings.Activity[u16]

            if u27 then
                u27.Text = _G.UU.LogBuffer[u16] or u21(u20.Grey, "—")
            end
        end
    end
end

local function u51(u13, u14)
    local u15 = _G.UU.App

    if not u15 then
        return
    end

    pcall(function()
        u15:Notification({
            App = "Universal Utility",
            Title = u13,
            Subtitle = u14,
            Duration = 4,
        })
    end)
end

local function u52(u13)
    if u13 == "Click" and _G.UU.HeldMouse then
        pcall(function()
            u4:SendMouseButtonEvent(u19.MousePosSaved.X, u19.MousePosSaved.Y, 0, false, game, 0)
        end)
        _G.UU.HeldMouse = false
    elseif u13 == "Spam" and _G.UU.HeldKey then
        pcall(function()
            u4:SendKeyEvent(false, _G.UU.HeldKey, false, game)
        end)
        _G.UU.HeldKey = nil
    end
    local u14 = _G.UU.Threads[u13]
    _G.UU.Threads[u13] = nil

    if u14 and typeof(u14) == "thread" and coroutine.status(u14) ~= "dead" then
        pcall(task.cancel, u14)
    end
end

local function u53(u13, u14)
    if not u18() then
        return
    end
    u52(u13)
    _G.UU.Threads[u13] = task.spawn(function()
        if u18() then
            u14()
        end
    end)
end
local function u54(u13, u14)
    u19.MousePosEnabled = u13

    local u15 = _G.UU.UI

    if not u14 and u15 and u15.AntiAFK and u15.AntiAFK.MouseToggle then
        u15.SyncMouse = true
        u15.AntiAFK.MouseToggle.Value = u13
        u15.SyncMouse = false
    end

    if u15 and u15.TrackingConnection then
        local u16 = u15.TrackingConnection
        u15.TrackingConnection = nil

        pcall(function()
            u16:Disconnect()
        end)
    end

    if u13 then
        local u27 = u2.RenderStepped:Connect(function()
            local u28 = u3:GetMouseLocation()
            u19.MousePosSaved.X = u28.X
            u19.MousePosSaved.Y = u28.Y
        end)

        u15.TrackingConnection = u27
        table.insert(_G.UU.Connections, u27)
    end

    if u15 and u15.AntiAFK and u15.AntiAFK.MouseState then
        u15.AntiAFK.MouseState.Text = u22(u13, u19.MousePosSaved.X, u19.MousePosSaved.Y)
    end

    u50("Mouse Position → " .. (u13 and "Tracking" or "Locked"))
    u38()
end

local function u55()
    u53("Jump", function()
        while u19.JumpEnabled do
            task.wait(math.max(u19.JumpDelay, 0.05))

            if u19.JumpEnabled and u9.Character then
                local u13 = u9.Character:FindFirstChildOfClass("Humanoid")

                if u13 then
                    u13:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)
end

local function u56()
    u53("Click", function()
        while u19.ClickEnabled do
            task.wait(math.max(u19.ClickDelay, 0.01))

            if u19.ClickEnabled then
                local u13, u14

                if u19.MousePosEnabled then
                    local u15 = u3:GetMouseLocation()
                    u13, u14 = u15.X, u15.Y
                else
                    u13, u14 = u19.MousePosSaved.X, u19.MousePosSaved.Y
                end

                _G.UU.HeldMouse = true
                u4:SendMouseButtonEvent(u13, u14, 0, true, game, 0)
                task.wait(math.min(0.05, u19.ClickDelay * 0.5))
                u4:SendMouseButtonEvent(u13, u14, 0, false, game, 0)
                _G.UU.HeldMouse = false
            end
        end
    end)
end

local function u57(u13, u14)
    u19.ClickEnabled = u13

    local u15 = _G.UU.UI

    if not u14 and u15 and u15.AntiAFK and u15.AntiAFK.ClickToggle then
        u15.SyncClick = true
        u15.AntiAFK.ClickToggle.Value = u13
        u15.SyncClick = false
    end

    if u13 then
        task.defer(u56)
    else
        u52("Click")
    end

    u50("Auto Click → " .. (u13 and "Enabled" or "Disabled"))
    u38()
end

local function u58()
    local u13 = Enum.KeyCode[u19.SpamKey]

    if not u13 then
        return false
    end

    u53("Spam", function()
        while u19.AutoSpamEnabled do
            task.wait(math.max(u19.SpamDelay, 0.05))

            if u19.AutoSpamEnabled then
                _G.UU.HeldKey = u13
                u4:SendKeyEvent(true, u13, false, game)
                task.wait(0.05)
                u4:SendKeyEvent(false, u13, false, game)
                _G.UU.HeldKey = nil
            end
        end
    end)

    return true
end

local function u59()
    if _G.UU.RejoinConnection then
        _G.UU.RejoinConnection:Disconnect()
        _G.UU.RejoinConnection = nil
    end
    u53("RejoinWait", function()
        local u13 = u5:FindFirstChild("RobloxPromptGui")

        if not u13 then
            local u14, u15 = pcall(function()
                return u5:WaitForChild("RobloxPromptGui", 10)
            end)

            if not u14 or not u15 then
                return
            end

            u13 = u15
        end

        local u16 = u13:FindFirstChild("promptOverlay")

        if not u16 then
            local u27, u28 = pcall(function()
                return u13:WaitForChild("promptOverlay", 10)
            end)

            if not u27 or not u28 then
                return
            end

            u16 = u28
        end

        local u29 = u16.ChildAdded:Connect(function(u30)
            if u30.Name == "ErrorPrompt" and u19.AutoRejoinEnabled then
                u50("Disconnected detected → rejoining")
                u51("Rejoining", "Disconnected from the server")

                u53("Rejoin", function()
                    while u19.AutoRejoinEnabled do
                        pcall(function()
                            u6:Teleport(game.PlaceId, u9)
                        end)
                        task.wait(2)
                    end
                end)
            end
        end)

        _G.UU.RejoinConnection = u29
        table.insert(_G.UU.Connections, u29)
    end)
end

local function u60(u13)
    if type(u13) ~= "string" or u13 == "" then
        return false, "No code to execute"
    end

    local u14, u15 = pcall(function()
        local u16, u27 = loadstring(u13)

        if not u16 then
            error(u27, 0)
        end

        u16()
    end)

    if u14 then
        return true, nil
    end

    return false, tostring(u15)
end

local u61 = typeof(setfpscap) == "function"

if u61 then
    u61 = pcall(setfpscap, 60)
end

local function u62()
    if not u61 then
        return
    end

    if u19.FPSUnlockEnabled then
        pcall(setfpscap, u19.TargetFPS)
    else
        pcall(setfpscap, 60)
    end
end

_G.UU.UI = {}

local u63 =
    loadstring(game:HttpGet("https://github.com/cascadeui/Cascade/releases/latest/download/dist.luau"))()
if not u18() then
    return
end

local function u64(u13, u14)
    local u15 = Vector2.new(1280, 720)

    pcall(function()
        local u16 = workspace.CurrentCamera

        if u16 then
            u15 = u16.ViewportSize
        end
    end)

    return UDim2.fromOffset(
        math.max(320, math.min(u13, math.floor(u15.X) - 24)),
        math.max(240, math.min(u14, math.floor(u15.Y) - 64))
    )
end

pcall(function()
    for u13, u14 in pairs(u5:GetChildren()) do
        if u14.Name == "Cascade" then
            u14:Destroy()
        end
    end

    local u13 = u9:FindFirstChild("PlayerGui")

    if u13 then
        for u14, u15 in pairs(u13:GetChildren()) do
            if u15.Name == "Cascade" then
                u15:Destroy()
            end
        end
    end
end)

local u65 = u63.New({
    WindowPill = true,
    Theme = u63.Themes[u19.ThemeMode] or u63.Themes.Dark,
    Accent = u63.Accents[u19.AccentName] or u63.Accents.Blue,
})

_G.UU.App = u65

local u66 = u65:Window({
    Title = "Universal Utility",
    Subtitle = u10,
    Size = u64(850, 530),
    Draggable = true,
    Resizable = true,
    Dropshadow = true,
    CanExit = false,
    CanMinimize = true,
    CanZoom = true,
    Minimized = u19.AutoHideEnabled,
})

local u67 = u66:Section({ Title = "General" })
local u68 = u66:Section({ Title = "Automation" })
local u69 = u66:Section({ Title = "Session" })
local u70 = u66:Section({ Title = "System" })

local function u71(u13, u14, u15)
    local u16 = u13:Row()

    u16:Left():TitleStack({
        Title = u14,
        Subtitle = u15,
    })

    return u16
end

local function u72(u13)
    local u14 = u13.Structures

    u14.Gradient.Enabled = false
    u14.Surface.BackgroundTransparency = 1
    u14.Surface.Size = UDim2.fromOffset(38, 38)
    u14.Image.Size = UDim2.fromOffset(36, 36)
    u14.Body.Size = UDim2.fromOffset(40, 40)

    return u13
end

local function u73(u13, u14, u15)
    local u16 = u13:Tab({
        Title = u14,
        Icon = u15,
    })

    local u27 = u16.Structures
    local u28 = u27.Leading:FindFirstChild("UIListLayout")

    u27.Symbol.ScaleType = Enum.ScaleType.Fit
    u27.Symbol.Size = UDim2.fromOffset(18, 18)

    if u28 then
        u28.Padding = UDim.new(0, 6)
        u28.VerticalAlignment = Enum.VerticalAlignment.Center
    end

    return u16
end

local function u74(u13, u14)
    local u15 = u13:Right():Slider(u14)

    if u15.Structures and u15.Structures.Thumb then
        u15.Structures.Thumb.Position = UDim2.fromScale(1, 0.5)
    end

    return u15
end

local u75 = false

local u76, u77 = {}, {}

local u78, u79 = 0, tick()
local u80 = 0
local u81 = false
local u82 = nil

local u83 = u73(u67, "Home", u63.Symbols.house)
local u84 = u73(u68, "Anti-AFK", u63.Symbols.bolt)
local u85 = u73(u68, "Key Spam", u63.Symbols.keyboard)
local u86 = u73(u69, "Auto Rejoin", u63.Symbols.arrowClockwise)
local u87 = u73(u69, "Script Loader", u63.Symbols.docPlaintext)
local u88 = u73(u70, "Performance", u63.Symbols.waveform)
local u89 = u73(u70, "Settings", u63.Symbols.gearshape)

_G.UU.UI.Tabs = {
    Home = u83,
    AntiAFK = u84,
    KeySpam = u85,
    Rejoin = u86,
    Loader = u87,
    Performance = u88,
    Settings = u89,
}

do
    local u13 = _G.UU.UI
    local u14 = u83:PageSection({ Title = "Player" }):Form()

    local u15 = u14:Row()

    u72(u15:Left():ImageSurface({
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. u11 .. "&w=150&h=150",
    }))

    u15:Right():TitleStack({
        Title = u10,
        Subtitle = u21(u20.Grey, "User ID: ") .. u21(u20.Cyan, u11),
    })

    local u16, u27 = "Unknown", ""

    pcall(function()
        if identifyexecutor then
            u16, u27 = identifyexecutor()
        elseif getexecutorname then
            u16 = getexecutorname()
        end
    end)

    u13.Home = {
        Executor = u71(u14, "Executor"):Right():Label({
            Text = u21(u20.Blue, u16 .. (u27 ~= "" and (" " .. u27) or "")),
        }),
        Device = u71(u14, "Device"):Right():Label({
            Text = u21(u20.Mint, u46()),
        }),
        Resolution = u71(u14, "Resolution"):Right():Label({
            Text = u21(u20.Cyan, "Detecting..."),
        }),
        FPS = u71(u14, "FPS"):Right():Label({
            Text = u21(u20.Grey, "—"),
        }),
        Ping = u71(u14, "Ping"):Right():Label({
            Text = u21(u20.Grey, "—"),
        }),
        Memory = u71(u14, "Memory"):Right():Label({
            Text = u21(u20.Grey, "—"),
        }),
    }

    local u28 = u83:PageSection({ Title = "Game" }):Form()
    local u29 = u28:Row()

    u13.GameIcon = u29:Left():ImageSurface({
        Image = u63.Symbols.docPlaintext,
    })

    u72(u13.GameIcon)

    u13.GameName = u29:Right():TitleStack({
        Title = "Loading game info...",
        Subtitle = u21(u20.Blue, "Universal Utility"),
    })

    u13.Home.PlaceId = u71(u28, "Place Id"):Right():Label({
        Text = u21(u20.Indigo, tostring(game.PlaceId)),
    })

    u13.Home.UniverseId = u71(u28, "Universe Id"):Right():Label({
        Text = u21(u20.Teal, tostring(game.GameId)),
    })

    u13.Home.Players = u71(u28, "Server Players"):Right():Label({
        Text = u21(u20.Lime, #u1:GetPlayers() .. " / " .. u1.MaxPlayers),
    })

    u13.Home.PlaceVersion = u71(u28, "Place Version"):Right():Label({
        Text = u21(u20.Orange, tostring(game.PlaceVersion)),
    })

    u13.Home.Region = u71(u28, "Server Region"):Right():Label({
        Text = u21(u20.Grey, "Server Region: ") .. u21(u20.Mint, "Detecting..."),
    })

    u13.Home.JobId = u71(u28, "Job Id"):Right():Label({
        Text = u21(u20.Grey, game.JobId ~= "" and game.JobId or "N/A"),
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    task.spawn(function()
        pcall(function()
            local u30 = u7:GetProductInfo(game.PlaceId)

            _G.UU.UI.GameName.Title = u30.Name

            if u30.IconImageAssetId and u30.IconImageAssetId ~= 0 then
                _G.UU.UI.GameIcon.Image = "rbxthumb://type=Asset&id="
                    .. u30.IconImageAssetId
                    .. "&w=150&h=150"
            end
        end)
    end)

    u49(u13.Home.Region)
end

do
    local u13 = _G.UU.UI
    local u14 = u84:PageSection({ Title = "Automation" }):Form()

    u13.AntiAFK = {}

    local u15 = u71(u14, "Auto Jump", "Simulates jumping to keep the session alive")

    u15:Right():Toggle({
        Value = u19.JumpEnabled,
        ValueChanged = function(u30, u31)
            if not u75 then
                return
            end

            u19.JumpEnabled = u31

            if u31 then
                task.defer(u55)
            else
                u52("Jump")
            end

            u50("Auto Jump → " .. (u31 and "Enabled" or "Disabled"))
            u38()
        end,
    })

    local u16 = u71(u14, "Auto Click", "Simulates mouse clicks at the chosen position · F4 toggles")

    u13.AntiAFK.ClickToggle = u16:Right():Toggle({
        Value = u19.ClickEnabled,
        ValueChanged = function(u30, u31)
            if u13.SyncClick or not u75 then
                return
            end

            u57(u31, true)
        end,
    })

    local u27 = u71(u14, "Mouse Position", "Track the live cursor or lock a saved position")

    u13.AntiAFK.MouseToggle = u27:Right():Toggle({
        Value = u19.MousePosEnabled,
        ValueChanged = function(u30, u31)
            if u13.SyncMouse or not u75 then
                return
            end

            u54(u31, true)
        end,
    })

    u13.AntiAFK.MouseState = u71(u14, "Mouse State", "F5 toggles between tracking and locked"):Right():Label({
        Text = u22(u19.MousePosEnabled, u19.MousePosSaved.X, u19.MousePosSaved.Y),
    })

    local u28 = u84:PageSection({
        Title = "Cooldowns",
        Subtitle = "Exponential scale from 0.01 seconds to 10 minutes",
    }):Form()

    u13.AntiAFK.JumpValue = u71(u28, "Jump Delay"):Right():Label({
        Text = u21(u20.Green, u41(u19.JumpDelay)),
    })

    local u29 = u71(u28, "Jump Cooldown")

    u74(u29, {
        Minimum = 0,
        Maximum = 1,
        Value = u43(u19.JumpDelay),
        ValueChanged = function(u30, u31)
            u19.JumpDelay = u42(u31)

            if u13.AntiAFK.JumpValue then
                u13.AntiAFK.JumpValue.Text = u21(u20.Green, u41(u19.JumpDelay))
            end

            u38()
        end,
    })

    u13.AntiAFK.ClickValue = u71(u28, "Click Delay"):Right():Label({
        Text = u21(u20.Orange, u41(u19.ClickDelay)),
    })

    local u30 = u71(u28, "Click Cooldown")

    u74(u30, {
        Minimum = 0,
        Maximum = 1,
        Value = u45(u19.ClickDelay),
        ValueChanged = function(u30, u31)
            u19.ClickDelay = u44(u31)

            if u13.AntiAFK.ClickValue then
                u13.AntiAFK.ClickValue.Text = u21(u20.Orange, u41(u19.ClickDelay))
            end

            u38()
        end,
    })
end

do
    local u13 = _G.UU.UI
    local u14 = u85:PageSection({ Title = "Input" }):Form()

    u13.Spam = {}

    u13.Spam.Interval = u71(u14, "Selected Interval"):Right():Label({
        Text = u21(u20.Yellow, string.format("%.2fs", u19.SpamDelay)),
    })

    local u15 = u71(u14, "Spam Interval", "Delay between each simulated key press")

    u74(u15, {
        Minimum = 0.05,
        Maximum = 5,
        Value = u19.SpamDelay,
        ValueChanged = function(u30, u31)
            u19.SpamDelay = math.floor(u31 * 100 + 0.5) / 100

            if u13.Spam.Interval then
                u13.Spam.Interval.Text = u21(u20.Yellow, string.format("%.2fs", u19.SpamDelay))
            end

            u38()
        end,
    })

    local u16 = u71(u14, "Target Key", "The key that gets pressed automatically")

    u16:Right():KeybindField({
        Value = Enum.KeyCode[u19.SpamKey] or Enum.KeyCode.Q,
        ValueChanged = function(u30, u31)
            if not u75 then
                return
            end

            local u32 = u19.SpamKey
            u19.SpamKey = u31.Name

            if u19.AutoSpamEnabled then
                local u33 = u31 == Enum.KeyCode.P
                    or u31.Name == "F4"
                    or u31.Name == "F5"
                    or u31 == u19.Keybind

                if u33 then
                    u19.AutoSpamEnabled = false
                    u52("Spam")

                    u13.SyncSpam = true
                    u13.Spam.Toggle.Value = false
                    u13.SyncSpam = false

                    u50("Key Spam → Key '" .. u31.Name .. "' is reserved")
                    u51("Key Spam", "Key '" .. u31.Name .. "' is reserved")
                    u38()
                    return
                end

                u58()
            end

            if u32 ~= u31.Name then
                u50("Spam Key → " .. u31.Name)
            end

            u38()
        end,
    })

    local u27 = u85:PageSection({ Title = "Control" }):Form()
    local u28 = u71(u27, "Auto Spam", "Repeatedly presses the target key")

    u13.Spam.Toggle = u28:Right():Toggle({
        Value = u19.AutoSpamEnabled,
        ValueChanged = function(u30, u31)
            if u13.SyncSpam or not u75 then
                return
            end

            u19.AutoSpamEnabled = u31

            if u31 then
                local u32 = Enum.KeyCode[u19.SpamKey]
                local u33 = u32
                    and (u32 == Enum.KeyCode.P or u32.Name == "F4" or u32.Name == "F5" or u32 == u19.Keybind)

                if not u32 or u33 then
                    u19.AutoSpamEnabled = false

                    u13.SyncSpam = true
                    u30.Value = false
                    u13.SyncSpam = false

                    u50(
                        "Key Spam → "
                            .. (
                                not u32 and "Invalid key '" .. u19.SpamKey .. "'"
                                or "Key '" .. u32.Name .. "' is reserved"
                            )
                    )
                    u51("Key Spam", not u32 and "Invalid key" or "Key reserved")
                    return
                end

                u58()
                u50("Key Spam → Enabled (" .. u32.Name .. ")")
            else
                u52("Spam")
                u50("Key Spam → Disabled")
            end

            u38()
        end,
    })
end

do
    local u13 = _G.UU.UI
    local u14 = u86:PageSection({ Title = "Watcher" }):Form()

    u13.Rejoin = {}

    local u15 = u71(u14, "Auto Rejoin", "Reconnects automatically when disconnected")

    u13.Rejoin.Toggle = u15:Right():Toggle({
        Value = u19.AutoRejoinEnabled,
        ValueChanged = function(u30, u31)
            if not u75 then
                return
            end

            u19.AutoRejoinEnabled = u31

            if u31 then
                u59()
                u50("Auto Rejoin → Enabled")
            else
                u52("Rejoin")
                u52("RejoinWait")
                if _G.UU.RejoinConnection then
                    _G.UU.RejoinConnection:Disconnect()
                    _G.UU.RejoinConnection = nil
                end
                u50("Auto Rejoin → Disabled")
            end

            u38()
        end,
    })
end

local u90 = u63.New({
    WindowPill = false,
    Theme = u63.Themes[u19.ThemeMode] or u63.Themes.Dark,
    Accent = u63.Accents[u19.AccentName] or u63.Accents.Blue,
})

_G.UU.EditorApp = u90

do
    local u13 = _G.UU.UI
    local u14 = u87:PageSection({ Title = "Editor" }):Form()

    u13.Loader = { Output = {}, History = {} }

    u13.Loader.AutoLoad = u71(u14, "Auto Load", "Executes the saved code on every injection"):Right():Toggle({
        Value = u19.AutoLoadEnabled,
        ValueChanged = function(u30, u31)
            if not u75 then
                return
            end

            u19.AutoLoadEnabled = u31

            if u31 then
                u50(
                    u19.SavedCode ~= "" and "Auto Load → Enabled (code ready)"
                        or "Auto Load → Enabled (no code saved)"
                )
            else
                u50("Auto Load → Disabled")
            end

            u38()
        end,
    })

    local u91 = u64(620, 460)
    local u92 = UDim2.fromScale(0.5, 0.5)

    pcall(function()
        local u93 = u66.Structures.Body.__instance

        if not (u93 and u93.Parent) then
            return
        end

        local u94 = u93.Parent.AbsoluteSize
        local u95 = u93.AbsoluteSize

        if u95.X < 50 or u95.Y < 50 then
            u95 = Vector2.new(u93.Size.X.Offset, u93.Size.Y.Offset)
        end

        if u95.X < 50 or u95.Y < 50 then
            u95 = Vector2.new(math.min(850, u94.X - 24), math.min(530, u94.Y - 64))
        end

        local u96 = u93.Position
        local u97 = u66.Minimized and Vector2.new(u94.X / 2, u94.Y / 2)
            or Vector2.new(u96.X.Offset + u96.X.Scale * u94.X, u96.Y.Offset + u96.Y.Scale * u94.Y)
        local u98 = Vector2.new(u91.X.Offset, u91.Y.Offset)
        local u99 = {
            Vector2.new(u97.X + u95.X / 2 + u98.X / 2 + 12, u97.Y),
            Vector2.new(u97.X - u95.X / 2 - u98.X / 2 - 12, u97.Y),
            Vector2.new(u97.X, u97.Y + u95.Y / 2 + u98.Y / 2 + 12),
            Vector2.new(u97.X, u97.Y - u95.Y / 2 - u98.Y / 2 - 12),
        }

        for u100, u101 in ipairs(u99) do
            if
                u101.X - u98.X / 2 >= 6
                and u101.X + u98.X / 2 <= u94.X - 6
                and u101.Y - u98.Y / 2 >= 6
                and u101.Y + u98.Y / 2 <= u94.Y - 6
            then
                u92 = UDim2.fromOffset(math.floor(u101.X), math.floor(u101.Y))

                return
            end
        end

        u92 = UDim2.fromOffset(
            math.floor(math.clamp(u97.X + 40, u98.X / 2 + 6, math.max(u98.X / 2 + 7, u94.X - u98.X / 2 - 6))),
            math.floor(math.clamp(u97.Y + 40, u98.Y / 2 + 6, math.max(u98.Y / 2 + 7, u94.Y - u98.Y / 2 - 6)))
        )
    end)

    local u15 = u90:Window({
        Title = "Code Editor",
        Subtitle = u10,
        Size = u91,
        Position = u92,
        Searching = false,
        CanExit = false,
        CanMinimize = true,
        CanZoom = true,
        Minimized = true,
    })

    task.delay(0.3, function()
        pcall(function()
            if u15.Minimized then
                u15.Position = u92
                u15.Minimized = true
            end
        end)
    end)

    local u27 = u15:Section({ Title = "Code" })
    local u28 = u73(u27, "Editor", u63.Symbols.docPlaintext)

    u28.Selected = true

    local u29 = u28.Structures.Page.__instance or u28.Structures.Page
    local u30 = game:GetService("TextService")
    local u31 = Font.fromEnum(Enum.Font.Code)
    local u32 = u30:GetTextSize("Ag", 14, Enum.Font.Code, Vector2.new(10000, 10000)).Y
    local u33 = Instance.new("Frame")

    u33.Name = "EditorPane"
    u33.Size = UDim2.new(1, 0, 0, 240)
    u33.BackgroundColor3 = Color3.fromRGB(26, 28, 37)
    u33.BorderSizePixel = 0
    u33.ClipsDescendants = true
    u33.Parent = u29

    local u102 = u29:FindFirstChild("Margins") or u29:FindFirstChildOfClass("UIPadding")

    if u102 then
        u102.PaddingTop = UDim.new()
        u102.PaddingBottom = UDim.new()
        u102.PaddingLeft = UDim.new()
        u102.PaddingRight = UDim.new()
    end

    local u34 = Instance.new("ScrollingFrame")

    u34.Name = "Scroller"
    u34.Size = UDim2.new(1, 0, 1, -26)
    u34.BackgroundTransparency = 1
    u34.BorderSizePixel = 0
    u34.ScrollBarThickness = 5
    u34.ScrollBarImageColor3 = Color3.fromRGB(120, 128, 150)
    u34.ScrollingDirection = Enum.ScrollingDirection.XY
    u34.CanvasSize = UDim2.new()
    u34.Parent = u33

    local u103 = Instance.new("TextLabel")

    u103.Name = "Numbers"
    u103.Size = UDim2.new(0, 40, 0, 240)
    u103.BackgroundColor3 = Color3.fromRGB(21, 23, 30)
    u103.BorderSizePixel = 0
    u103.FontFace = u31
    u103.TextSize = 14
    u103.TextColor3 = Color3.fromRGB(90, 97, 115)
    u103.TextXAlignment = Enum.TextXAlignment.Right
    u103.TextYAlignment = Enum.TextYAlignment.Top
    u103.Text = "1"
    u103.Parent = u34

    Instance.new("UIPadding", u103).PaddingRight = UDim.new(0, 6)

    local u104 = Instance.new("Frame")

    u104.Name = "TextZone"
    u104.Position = UDim2.new(0, 40, 0, 0)
    u104.Size = UDim2.new(0, 480, 0, 240)
    u104.BackgroundTransparency = 1
    u104.Parent = u34

    local u105 = Instance.new("TextLabel")

    u105.Name = "Highlight"
    u105.Size = UDim2.new(1, 0, 1, 0)
    u105.BackgroundTransparency = 1
    u105.FontFace = u31
    u105.TextSize = 14
    u105.TextColor3 = Color3.fromRGB(233, 234, 238)
    u105.TextXAlignment = Enum.TextXAlignment.Left
    u105.TextYAlignment = Enum.TextYAlignment.Top
    u105.TextWrapped = false
    u105.RichText = true
    u105.Text = ""
    u105.Parent = u104

    local u106 = Instance.new("TextBox")

    u106.Name = "Input"
    u106.Size = UDim2.new(1, 0, 1, 0)
    u106.BackgroundTransparency = 1
    u106.BorderSizePixel = 0
    u106.FontFace = u31
    u106.TextSize = 14
    u106.TextColor3 = Color3.new(0, 0, 0)
    u106.TextTransparency = 1
    u106.TextXAlignment = Enum.TextXAlignment.Left
    u106.TextYAlignment = Enum.TextYAlignment.Top
    u106.TextWrapped = false
    u106.MultiLine = true
    u106.ClearTextOnFocus = false
    u106.Text = ""
    u106.ZIndex = 2
    u106.Parent = u104

    local u107 = Instance.new("Frame")

    u107.Name = "Footer"
    u107.Position = UDim2.new(0, 0, 1, -26)
    u107.Size = UDim2.new(1, 0, 0, 26)
    u107.BackgroundColor3 = Color3.fromRGB(21, 23, 30)
    u107.BorderSizePixel = 0
    u107.Parent = u33

    local u108 = Instance.new("TextLabel")

    u108.Name = "Hint"
    u108.Position = UDim2.new(0, 10, 0, 0)
    u108.Size = UDim2.new(0.62, 0, 1, 0)
    u108.BackgroundTransparency = 1
    u108.FontFace = u31
    u108.TextSize = 12
    u108.TextColor3 = Color3.fromRGB(108, 116, 136)
    u108.TextXAlignment = Enum.TextXAlignment.Left
    u108.Text = "Lua · made for short loadstrings"
    u108.Parent = u107

    local u109 = Instance.new("TextLabel")

    u109.Name = "Count"
    u109.Position = UDim2.new(0.62, 0, 0, 0)
    u109.Size = UDim2.new(0.38, -54, 1, 0)
    u109.BackgroundTransparency = 1
    u109.FontFace = u31
    u109.TextSize = 12
    u109.TextColor3 = Color3.fromRGB(139, 147, 163)
    u109.TextXAlignment = Enum.TextXAlignment.Right
    u109.Text = "1 / 50 lines"
    u109.Parent = u107

    local u110 = Instance.new("TextButton")

    u110.Name = "Run"
    u110.AnchorPoint = Vector2.new(1, 0.5)
    u110.Position = UDim2.new(1, -8, 0.5, 0)
    u110.Size = UDim2.fromOffset(40, 18)
    u110.BackgroundColor3 = Color3.fromRGB(29, 42, 33)
    u110.BorderSizePixel = 0
    u110.FontFace = u31
    u110.TextSize = 12
    u110.TextColor3 = Color3.fromRGB(50, 215, 75)
    u110.Text = "Run"

    Instance.new("UICorner", u110).CornerRadius = UDim.new(0, 5)

    u110.Parent = u107

    local u111 = false
    local u112 = false
    local u113 = false
    local u114 = u106.Text

    local function u115(u116)
        local u117 = select(2, u116:gsub("\n", "")) + 1

        if u117 > 50 then
            local u118, u119 = 0, 0

            for u120 = 1, #u116 do
                if u116:sub(u120, u120) == "\n" then
                    u118 = u118 + 1

                    if u118 == 50 then
                        u119 = u120 - 1

                        break
                    end
                end
            end

            u116 = u116:sub(1, u119)

            if not u112 then
                u112 = true

                if u111 then
                    u50("Editor → 50 line limit reached")
                end
            end

            u106.Text = u116

            return
        end

        if u117 < 50 then
            u112 = false
        end

        local u121 = {}

        for u122 = 1, u117 do
            u121[#u121 + 1] = u122
        end

        u103.Text = table.concat(u121, "\n")

        if u113 then
            u105.Text = ""
        else
            local u123, u124 = pcall(u26, u116)

            if u123 then
                u105.Text = u124
            else
                u105.Text = u24 and u24(u116) or ""
            end
        end

        u109.TextColor3 = u112 and Color3.fromRGB(255, 69, 58)
            or u117 >= 45 and Color3.fromRGB(255, 159, 10)
            or Color3.fromRGB(139, 147, 163)
        u109.Text = u117 .. " / 50 lines"

        local u125 = 0

        for u126 in (u116 .. "\n"):gmatch("(.-)\n") do
            if u126 ~= "" then
                u125 = math.max(u125, u30:GetTextSize(u126, 14, Enum.Font.Code, Vector2.new(10000, 10000)).X)
            end
        end

        local u127 = u34.AbsoluteWindowSize
        local u128 = math.max(u117 * u32 + 12, 240, math.floor(u127.Y))
        local u129 = math.max(u125 + 8, 480, math.floor(u127.X) - 40)

        u103.Size = UDim2.new(0, 40, 0, u128)
        u104.Size = UDim2.new(0, u129, 0, u128)
        u34.CanvasSize = UDim2.fromOffset(u129 + 40, u128)

        if u111 then
            u19.SavedCode = u116

            if u82 then
                pcall(task.cancel, u82)
            end

            u82 = task.delay(0.75, u38)
        end
    end

    u106:GetPropertyChangedSignal("Text"):Connect(function()
        u114 = u106.Text

        u115(u106.Text)
    end)

    u106.FocusLost:Connect(function()
        if not u111 or u106.Text == u19.SavedCode then
            return
        end

        u19.SavedCode = u106.Text
        u38()
    end)

    local function u130()
        local u131 = u29.AbsoluteWindowSize

        u33.Size = UDim2.new(1, 0, 0, math.max(240, math.floor(u131.Y)))

        task.defer(u115, u106.Text)
    end

    u29:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(u130)

    task.defer(u130)

    u110.MouseButton1Click:Connect(function()
        local u132, u133 = u60(u19.SavedCode)

        if u132 then
            u13.Loader.PushOutput("Script executed successfully.", u20.Green)
            u50("Script executed ✓")
        else
            if u133 then
                u13.Loader.PushOutput(tostring(u133), u20.Red)
            end

            u50("Script error: " .. tostring(u133):sub(1, 80))
            u51("Execution failed", tostring(u133):sub(1, 120))
        end
    end)

    u114 = u19.SavedCode or ""
    u106.Text = u114

    pcall(u115, u106.Text)

    u111 = true

    local u124 = u71(u14, "Open Editor", "Popup window with Studio-style colors · 50 lines max")

    u124:Right():Button({
        Label = "Open",
        State = "Primary",
        Pushed = function()
            u15.Minimized = false
        end,
    })

    local u134 = u66.Minimized
    local u135 = not u15.Minimized

    u53("Editor", function()
        while u18() and not _G.UU.Loaded do
            task.wait(0.1)
        end

        while u18() and _G.UU.Loaded do
            pcall(function()
                local u136 = u66.Minimized

                if u136 ~= u134 then
                    u134 = u136

                    if u136 then
                        u135 = not u15.Minimized
                        u15.Minimized = true
                    elseif u135 then
                        u15.Minimized = false
                    end
                end

                if u106.Text ~= u114 then
                    u114 = u106.Text

                    u115(u114)
                end
            end)

            task.wait(0.15)
        end
    end)

    local u127 = u71(u14, "Execute", "Runs the current code immediately")

    u127:Right():Button({
        Label = "Execute",
        State = "Primary",
        Pushed = function()
            local u137, u138 = u60(u19.SavedCode)

            if u137 then
                u13.Loader.PushOutput("Script executed successfully.", u20.Green)
                u50("Script executed ✓")
            else
                if u138 then
                    u13.Loader.PushOutput(tostring(u138), u20.Red)
                end

                u50("Script error: " .. tostring(u138):sub(1, 80))
                u51("Execution failed", tostring(u138):sub(1, 120))
            end
        end,
    })

    local u139 = u71(u14, "Clear Editor", "Empties the code field and the saved config")

    u139:Right():Button({
        Label = "Clear",
        State = "Destructive",
        Pushed = function()
            u106.Text = ""
            u19.SavedCode = ""

            u50("Script Loader → Editor cleared")
            u38()
        end,
    })

    local u140 = u87:Form()

    u71(u140, "Output", "Shows the results of your last script run, newest first"):Right():Button({
        Label = "Clear",
        State = "Destructive",
        Pushed = function()
            u13.Loader.History = {}

            for u141 = 1, 3 do
                local u142 = u13.Loader.Output[u141]

                if u142 then
                    u142.Text = u21(u20.Grey, "—")
                end
            end
        end,
    })

    for u143 = 1, 3 do
        u13.Loader.Output[u143] = u140:Row():Left():Label({
            Text = u21(u20.Grey, "—"),
        })
    end

    u13.Loader.PushOutput = function(u141, u142)
        local u144 = u13.Loader.History

        table.insert(u144, 1, u21(u142 or u20.White, u24(u141)))

        if #u144 > 3 then
            table.remove(u144, 4)
        end

        for u145 = 1, 3 do
            local u146 = u13.Loader.Output[u145]

            if u146 then
                u146.Text = u144[u145] or u21(u20.Grey, "—")
            end
        end
    end

    local u147 = Instance.new("Frame")

    u147.Name = "Caret"
    u147.Size = UDim2.fromOffset(2, math.max(u32 - 4, 10))
    u147.BackgroundColor3 = Color3.fromRGB(240, 241, 245)
    u147.BorderSizePixel = 0
    u147.Visible = false
    u147.ZIndex = 2
    u147.Parent = u104

    local u148 = nil

    local function u149(u13)
        if typeof(u13) == "Vector2" then
            return u13
        end

        if type(u13) ~= "number" or u13 ~= u13 then
            return nil
        end

        local u150 = string.split(u106.Text, "\n")
        local u151, u152

        if u13 < 0 then
            u151 = #u150
            u152 = #(u150[u151] or "") + 1
        else
            local u153 = u106.Text:sub(1, math.clamp(math.floor(u13), 0, #u106.Text))
            local u154 = u153:match(".*\n")

            u151 = select(2, u153:gsub("\n", "")) + 1
            u152 = #u153 - (u154 and #u154 or 0) + 1
        end

        u151 = math.clamp(u151, 1, #u150)

        return { X = math.clamp(u152, 1, #(u150[u151] or "") + 1), Y = u151 }
    end

    local function u155()
        if u113 then
            return
        end

        u113 = true
        u105.Visible = false
        u147.Visible = false
        u106.TextTransparency = 0
        u106.TextColor3 = Color3.fromRGB(233, 234, 238)
    end

    local function u156()
        if u113 then
            u147.Visible = false

            return false
        end

        local u157 = string.split(u106.Text, "\n")
        local u158 = u149(u106.CursorPosition)

        if not u158 then
            u147.Visible = false

            if u106:IsFocused() then
                u155()
            end

            return false
        end

        local u159 = math.clamp(u158.Y, 1, #u157)
        local u160 = u157[u159] or ""
        local u161 = u30:GetTextSize(
            u160:sub(1, math.max(math.min(u158.X - 1, #u160), 0)),
            14,
            Enum.Font.Code,
            Vector2.new(10000, 10000)
        ).X

        u147.Position = UDim2.fromOffset(u161, (u159 - 1) * u32 + 2)

        local u162 = u34.AbsoluteWindowSize

        if u106:IsFocused() and u162.X > 1 then
            local u163 = u34.CanvasPosition

            if u161 < u163.X or u161 > u163.X + u162.X - 60 then
                u34.CanvasPosition = Vector2.new(math.max(u161 - u162.X + 120, 0), u163.Y)
            end

            local u164 = (u159 - 1) * u32

            if u164 < u163.Y or u164 > u163.Y + u162.Y - u32 * 2 - 30 then
                u34.CanvasPosition =
                    Vector2.new(u34.CanvasPosition.X, math.max(u164 - u162.Y + u32 * 2 + 30, 0))
            end
        end

        local u165 = u106:IsFocused()

        u147.Visible = u165

        return u165
    end

    local function u166()
        for u157, u158 in pairs(u104:GetChildren()) do
            if u158.Name == "SelRect" then
                u158:Destroy()
            end
        end

        if u113 then
            return
        end

        local u157 = u106.SelectionStart

        if typeof(u157) == "number" and u157 < 0 then
            return
        end

        u157 = u149(u157)
        local u158 = u149(u106.CursorPosition)

        if not u106:IsFocused() or not u157 or not u158 then
            return
        end

        local u159 = string.split(u106.Text, "\n")
        local u160, u161 = math.min(u157.Y, u158.Y), math.max(u157.Y, u158.Y)

        if u160 < 1 or u160 > #u159 + 1 or (u160 == u161 and u157.X == u158.X) then
            return
        end

        for u162 = math.max(u160, 1), math.min(u161, #u159) do
            local u163, u164 = 0, 0
            local u165 = u159[u162] or ""

            if u162 == u160 and u162 == u161 then
                u163 = math.min(u157.X, u158.X) - 1
                u164 = math.max(u157.X, u158.X) - 1
            elseif u162 == u160 then
                u163 = (u157.Y <= u158.Y and u157.X or u158.X) - 1
                u164 = #u165
            elseif u162 == u161 then
                u164 = (u157.Y <= u158.Y and u158.X or u157.X) - 1
            else
                u164 = #u165
            end

            local u167 = u30:GetTextSize(
                u165:sub(1, math.max(math.min(u163, #u165), 0)),
                14,
                Enum.Font.Code,
                Vector2.new(10000, 10000)
            ).X
            local u168 = u30:GetTextSize(
                u165:sub(1, math.max(math.min(u164, #u165), 0)),
                14,
                Enum.Font.Code,
                Vector2.new(10000, 10000)
            ).X
            local u169 = Instance.new("Frame")

            u169.Name = "SelRect"
            u169.BackgroundColor3 = Color3.fromRGB(58, 110, 180)
            u169.BackgroundTransparency = 0.5
            u169.BorderSizePixel = 0
            u169.Position = UDim2.fromOffset(u167, (u162 - 1) * u32)
            u169.Size = UDim2.fromOffset(math.max(u168 - u167, 5), u32)
            u169.ZIndex = 1
            u169.Parent = u104
        end
    end

    u106.Focused:Connect(function()
        task.defer(function()
            if not u149(u106.CursorPosition) then
                u155()
            end
        end)

        if u148 then
            pcall(task.cancel, u148)

            u148 = nil
        end

        if u156() then
            u148 = task.spawn(function()
                while u147.Parent and u106:IsFocused() do
                    task.wait(0.45)

                    if not (u147.Parent and u106:IsFocused()) then
                        break
                    end

                    u147.Visible = not u147.Visible
                end
            end)
            _G.UU.Threads.Caret = u148
        end

        u166()
    end)

    u106.FocusLost:Connect(function()
        if u148 then
            pcall(task.cancel, u148)

            u148 = nil
        end

        u147.Visible = false
        u166()
    end)

    u106:GetPropertyChangedSignal("CursorPosition"):Connect(function()
        u156()
        u166()
    end)

    u106:GetPropertyChangedSignal("SelectionStart"):Connect(function()
        u166()
    end)

    u106:GetPropertyChangedSignal("Text"):Connect(function()
        u156()
        u166()
    end)

    u34:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
        local u170 = u34.AbsoluteWindowSize

        if u104.Size.Y.Offset < math.floor(u170.Y) or u104.Size.X.Offset < math.floor(u170.X) - 40 then
            u115(u106.Text)
        end
    end)
end

do
    local u13 = _G.UU.UI
    local u14 = u88:PageSection({ Title = "FPS Unlock" }):Form()

    u13.Perf = {}

    u13.Perf.Target = u71(u14, "Selected Limit"):Right():Label({
        Text = u21(u20.Cyan, u19.TargetFPS .. " FPS"),
    })

    local u15 = u71(u14, "Target FPS", "Custom framerate limit from 15 to 360")

    u74(u15, {
        Minimum = 15,
        Maximum = 360,
        Value = u19.TargetFPS,
        ValueChanged = function(u30, u31)
            u19.TargetFPS = math.floor(u31 + 0.5)

            if u13.Perf.Target then
                u13.Perf.Target.Text = u21(u20.Cyan, u19.TargetFPS .. " FPS")
            end

            if u19.FPSUnlockEnabled then
                u62()
            end

            u38()
        end,
    })

    local u16 = u71(u14, "FPS Unlock", "Removes the default 60 FPS cap")

    u13.Perf.Toggle = u16:Right():Toggle({
        Value = u19.FPSUnlockEnabled,
        ValueChanged = function(u30, u31)
            if u13.SyncFps or not u75 then
                return
            end

            if not u61 then
                u13.SyncFps = true
                u30.Value = false
                u13.SyncFps = false

                u50("FPS Unlock → Not supported by executor")
                u51("FPS Unlock", "Not supported by this executor")
                return
            end

            u19.FPSUnlockEnabled = u31
            u62()
            u50("FPS Unlock → " .. (u31 and ("Enabled (" .. u19.TargetFPS .. " FPS)") or "Disabled"))
            u38()
        end,
    })

    local u27 = u88:PageSection({ Title = "Framerate" }):Form()

    u13.Perf.FpsCurrent = u71(u27, "Current"):Right():Label({
        Text = u21(u20.Green, "60"),
    })

    u13.Perf.FpsAvg = u71(u27, "Average"):Right():Label({
        Text = u21(u20.Mint, "60"),
    })

    u13.Perf.FpsRange = u71(u27, "Range"):Right():Label({
        Text = u21(u20.Grey, "Min: 60 | Max: 60"),
    })

    local u28 = u88:PageSection({ Title = "Network" }):Form()

    u13.Perf.PingCurrent = u71(u28, "Current"):Right():Label({
        Text = u21(u20.Green, "0 ms"),
    })

    u13.Perf.PingAvg = u71(u28, "Average"):Right():Label({
        Text = u21(u20.Mint, "0 ms"),
    })

    u13.Perf.PingRange = u71(u28, "Range"):Right():Label({
        Text = u21(u20.Grey, "Min: 0 ms | Max: 0 ms"),
    })

    u13.Perf.Quality = u71(u28, "Connection Quality"):Right():Label({
        Text = u21(u20.Grey, "Measuring..."),
    })

    local u29 = u88:PageSection({ Title = "Memory" }):Form()

    u13.Perf.MemCurrent = u71(u29, "Current"):Right():Label({
        Text = u21(u20.Purple, "0 MB"),
    })

    u13.Perf.MemPeak = u71(u29, "Peak"):Right():Label({
        Text = u21(u20.Pink, "0 MB"),
    })
end

do
    local u13 = _G.UU.UI
    local u14 = u89:PageSection({
        Title = "Appearance",
        Subtitle = "Theme and accent apply instantly across the whole interface",
    }):Form()

    u13.Settings = { Activity = {} }

    local u15 = u71(u14, "Theme", "Pick between the light and the dark appearance")

    local function u16(u27)
        local u28 = game:GetService("TweenService")
        local u29 = Instance.new("Frame")
        local u30 = Instance.new("TextButton")
        local u31 = Instance.new("UICorner")
        local u32 = Instance.new("UIStroke")
        local u33 = Instance.new("TextLabel")
        local u34 = Instance.new("ImageLabel")
        local u103 = Instance.new("CanvasGroup")
        local u104 = Instance.new("UICorner")
        local u105 = Instance.new("UIStroke")
        local u106 = Instance.new("UIPadding")
        local u107 = Instance.new("UIListLayout")

        u29.Name = "Select"
        u29.Size = UDim2.fromOffset(150, 32)
        u29.BackgroundTransparency = 1
        u29.Parent = u27.Parent

        u30.Size = UDim2.fromScale(1, 1)
        u30.AutoButtonColor = false
        u30.Text = ""
        u30.Parent = u29

        u31.CornerRadius = UDim.new(0, 8)
        u31.Parent = u30

        u32.Thickness = 1
        u32.Parent = u30

        u33.BackgroundTransparency = 1
        u33.AnchorPoint = Vector2.new(0, 0.5)
        u33.Position = UDim2.new(0, 12, 0.5, 0)
        u33.Size = UDim2.new(1, -44, 1, 0)
        u33.FontFace = Font.new("rbxassetid://12187365364")
        u33.TextSize = 14
        u33.RichText = true
        u33.TextXAlignment = Enum.TextXAlignment.Left
        u33.TextTruncate = Enum.TextTruncate.AtEnd
        u33.Parent = u30

        u34.BackgroundTransparency = 1
        u34.AnchorPoint = Vector2.new(1, 0.5)
        u34.Position = UDim2.new(1, -11, 0.5, 0)
        u34.Size = UDim2.fromOffset(14, 14)
        u34.Image = u63.Symbols.chevronDown
        u34.ScaleType = Enum.ScaleType.Fit
        u34.Parent = u30

        u103.AnchorPoint = Vector2.new(1, 0)
        u103.Size = UDim2.fromOffset(150, 14 + #u27.Options * 28 + (#u27.Options - 1) * 3)
        u103.ClipsDescendants = true
        u103.Visible = false
        u103.ZIndex = 50

        u104.CornerRadius = UDim.new(0, 8)
        u104.Parent = u103

        u105.Thickness = 1
        u105.Parent = u103

        u106.PaddingTop = UDim.new(0, 4)
        u106.PaddingBottom = UDim.new(0, 4)
        u106.PaddingLeft = UDim.new(0, 4)
        u106.PaddingRight = UDim.new(0, 4)
        u106.Parent = u103

        u107.Padding = UDim.new(0, 3)
        u107.SortOrder = Enum.SortOrder.LayoutOrder
        u107.Parent = u103

        local u108 = u27.Index
        local u109 = false
        local u110 = {}
        local u111
        local u112
        local u115
        local u129 = u27.Parent.Parent
        local u123
        local u124
        local u140
        local u143
        local u139

        u139 = function()
            local u127 = u129

            while u127 and not u127:IsA("ScrollingFrame") do
                u127 = u127.Parent
            end

            if u127 and u127.Parent then
                u127 = u127.Parent
            else
                u127 = u129

                while u127.Parent and u127.Parent:IsA("GuiObject") do
                    u127 = u127.Parent
                end
            end

            if u127 ~= u124 then
                u124 = u127

                u103.Parent = u124

                u140 = u124:FindFirstChildOfClass("UIPadding")
                u143 = u140 and Vector2.new(u140.PaddingLeft.Offset, u140.PaddingTop.Offset) or Vector2.new()
            end

            local u141 = u30.AbsolutePosition
            local u142 = u30.AbsoluteSize
            local u144 = u141.X + u142.X - u124.AbsolutePosition.X - u143.X
            local u145 = u141.Y + u142.Y - u124.AbsolutePosition.Y - u143.Y
            local u146 = u124.AbsoluteSize.Y - u143.Y - u103.AbsoluteSize.Y

            u103.Position = UDim2.fromOffset(u144, math.max(0, math.min(u145, u146)))
        end

        u30:GetPropertyChangedSignal("AbsolutePosition"):Connect(u139)

        u139()

        u111 = function(u116)
            local u117 = u27.Options[u116]

            u33.Text = u117.Dot and u21(u117.Dot, "●") .. "  " .. u117.Text or u117.Text
        end

        u112 = function(u116)
            if u109 == u116 then
                return
            end

            u109 = u116

            if u123 then
                u123:Cancel()

                u123 = nil
            end

            local u117 = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            u139()

            local u118 = UDim2.fromOffset(u103.Position.X.Offset, u103.Position.Y.Offset)

            if u116 then
                u103.GroupTransparency = 1
                u103.Position = UDim2.fromOffset(u118.X.Offset, u118.Y.Offset - 6)
                u103.Visible = true
            end

            u123 = u28:Create(u103, u117, {
                GroupTransparency = u116 and 0 or 1,
                Position = u116 and u118 or UDim2.fromOffset(u118.X.Offset, u118.Y.Offset - 6),
            })

            u123:Play()

            if u116 then
                u123.Completed:Connect(function(u127)
                    if u127 ~= Enum.PlaybackState.Completed then
                        return
                    end

                    u139()
                end)
            end

            u28:Create(u34, u117, { Rotation = u116 and 180 or 0 }):Play()

            if not u116 then
                u123.Completed:Connect(function(u124)
                    if u124 ~= Enum.PlaybackState.Completed or u109 then
                        return
                    end

                    u103.Visible = false

                    u123 = nil
                end)
            end
        end

        u115 = function(u116)
            local u117 = u65.Theme

            u30.BackgroundColor3 = u117.Controls.Background[1].Value
            u30.BackgroundTransparency = u117.Controls.Background[2].Value
            u32.Color = u117.Text.Quaternary[1].Value
            u32.Transparency = u117.Text.Quaternary[2].Value
            u33.TextColor3 = u117.Text.Primary[1].Value
            u33.TextTransparency = u117.Text.Primary[2].Value
            u34.ImageColor3 = u117.Text.Primary[1].Value
            u34.ImageTransparency = math.min(1, u117.Text.Primary[2].Value + 0.15)
            u103.BackgroundColor3 = u117.Controls.MenuButton.MenuBackground[1].Value
            u103.BackgroundTransparency = u117.Controls.MenuButton.MenuBackground[2].Value
            u105.Color = u117.Text.Quaternary[1].Value
            u105.Transparency = u117.Text.Quaternary[2].Value

            for u118, u119 in ipairs(u110) do
                local u120 = u118 == u116
                local u121 = u27.Colors and u27.Colors(u118) or u20[u19.AccentName] or u20.Grey

                u119.Row.BackgroundColor3 = u117.Text.Primary[1].Value
                u119.Row.BackgroundTransparency = 1
                u119.Label.TextColor3 = u117.Text.Primary[1].Value
                u119.Label.TextTransparency = u120 and 0 or 0.3
                u119.Check.ImageColor3 = Color3.fromHex(u121)
                u119.Check.Visible = u120
            end
        end

        for u116, u117 in ipairs(u27.Options) do
            local u122 = Instance.new("TextButton")
            local u125 = Instance.new("UICorner")
            local u126 = Instance.new("TextLabel")
            local u128 = Instance.new("ImageLabel")

            u122.Size = UDim2.new(1, 0, 0, 28)
            u122.AutoButtonColor = false
            u122.Text = ""
            u122.LayoutOrder = u116
            u122.ZIndex = 2
            u122.Parent = u103

            u125.CornerRadius = UDim.new(0, 6)
            u125.Parent = u122

            u126.BackgroundTransparency = 1
            u126.AnchorPoint = Vector2.new(0, 0.5)
            u126.Position = UDim2.new(0, 9, 0.5, 0)
            u126.Size = UDim2.new(1, -38, 1, 0)
            u126.FontFace = Font.new("rbxassetid://12187365364")
            u126.TextSize = 14
            u126.RichText = true
            u126.TextXAlignment = Enum.TextXAlignment.Left
            u126.TextTruncate = Enum.TextTruncate.AtEnd
            u126.Text = u117.Dot and u21(u117.Dot, "●") .. "  " .. u117.Text or u117.Text
            u126.ZIndex = 2
            u126.Parent = u122

            u128.BackgroundTransparency = 1
            u128.AnchorPoint = Vector2.new(1, 0.5)
            u128.Position = UDim2.new(1, -9, 0.5, 0)
            u128.Size = UDim2.fromOffset(14, 14)
            u128.Image = u63.Symbols.checkmark
            u128.ScaleType = Enum.ScaleType.Fit
            u128.ZIndex = 2
            u128.Parent = u122

            u122.MouseEnter:Connect(function()
                if u108 ~= u116 then
                    u122.BackgroundTransparency = 0.92
                end
            end)

            u122.MouseLeave:Connect(function()
                u122.BackgroundTransparency = 1
            end)

            u122.Activated:Connect(function()
                if u108 == u116 then
                    u112(false)

                    return
                end

                u108 = u116
                u111(u116)
                u112(false)

                task.spawn(u27.OnSelect, u116)
                u115(u116)
            end)

            u110[u116] = { Row = u122, Label = u126, Check = u128 }
        end

        table.insert(
            _G.UU.Connections,
            u3.InputBegan:Connect(function(u116)
                if not u109 then
                    return
                end

                if
                    u116.UserInputType ~= Enum.UserInputType.MouseButton1
                    and u116.UserInputType ~= Enum.UserInputType.Touch
                then
                    return
                end

                local u117 = u116.Position
                local u118 = u30.AbsolutePosition
                local u119 = u30.AbsoluteSize
                local u120 = u103.AbsolutePosition
                local u121 = u103.AbsoluteSize
                local u122 = u117.X >= u118.X
                    and u117.X <= u118.X + u119.X
                    and u117.Y >= u118.Y
                    and u117.Y <= u118.Y + u119.Y
                local u125 = u117.X >= u120.X
                    and u117.X <= u120.X + u121.X
                    and u117.Y >= u120.Y
                    and u117.Y <= u120.Y + u121.Y

                if not u122 and not u125 then
                    u112(false)
                end
            end)
        )

        u30.Activated:Connect(function()
            u112(not u109)
        end)

        u111(u108)
        u115(u108)

        return {
            Refresh = function()
                u115(u108)
            end,
        }
    end

    u13.Settings.Theme = u16({
        Parent = u15.Structures.RightAccessories,
        Options = { { Text = "Light" }, { Text = "Dark" } },
        Index = u19.ThemeMode == "Dark" and 2 or 1,
        OnSelect = function(u27)
            if not u75 then
                return
            end

            local u28 = u27 == 2 and "Dark" or "Light"

            if u28 == u19.ThemeMode then
                return
            end

            u19.ThemeMode = u28
            u65.Theme = u28 == "Dark" and u63.Themes.Dark or u63.Themes.Light
            u90.Theme = u65.Theme

            u50("Theme → " .. u28)
            u38()

            if u13.Settings.Accent and u13.Settings.Accent.Refresh then
                u13.Settings.Accent.Refresh()
            end
        end,
    })

    local u27 = u71(u14, "Accent Color", "Highlight color used by switches, buttons and selections")
    local u28 = { "Blue", "Purple", "Pink", "Red", "Orange", "Yellow", "Green", "Graphite" }
    local u29 = 0

    for u30, u31 in ipairs(u28) do
        if u31 == u19.AccentName then
            u29 = u30
        end
    end

    if u29 == 0 then
        u29 = 1
        u19.AccentName = "Blue"
    end

    local u32 = {}

    for u30, u31 in ipairs(u28) do
        u32[u30] = { Text = u31, Dot = u20[u31] or u20.Grey }
    end

    u13.Settings.Accent = u16({
        Parent = u27.Structures.RightAccessories,
        Options = u32,
        Index = u29,
        Colors = function(u33)
            return u32[u33].Dot
        end,
        OnSelect = function(u33)
            if not u75 then
                return
            end

            local u34 = u28[u33]

            if not u34 then
                return
            end

            u19.AccentName = u34
            u65.Accent = u63.Accents[u34]
            u90.Accent = u65.Accent

            u50("Accent → " .. u34)
            u38()

            if u13.Settings.Theme and u13.Settings.Theme.Refresh then
                u13.Settings.Theme.Refresh()
            end
        end,
    })

    local u104 = u89:PageSection({ Title = "Interface" }):Form()

    local u105 = u71(u104, "Toggle Keybind", "Show or hide the window")

    u105:Right():KeybindField({
        Value = u19.Keybind,
        ValueChanged = function(u106, u107)
            if not u75 then
                return
            end

            u19.Keybind = u107
            u50("Keybind → " .. u107.Name)
            u38()
        end,
        BindPressed = function(u106, u107, u108, u109)
            if not u108 or u109 then
                return
            end

            u66.Minimized = not u66.Minimized
        end,
    })

    local u110 = u71(u104, "Auto Hide UI", "Starts minimized on the next injection")

    u110:Right():Toggle({
        Value = u19.AutoHideEnabled,
        ValueChanged = function(u106, u107)
            if not u75 then
                return
            end

            u19.AutoHideEnabled = u107
            u50("Auto Hide UI → " .. (u107 and "Enabled" or "Disabled"))
            u38()
        end,
    })

    local u111 = u89:Form()

    u71(u111, "Activity", "Tracks every action with a timestamp, newest first"):Right():Button({
        Label = "Clear",
        State = "Destructive",
        Pushed = function()
            _G.UU.LogBuffer = {}

            for u115 = 1, 6 do
                local u116 = u13.Settings.Activity[u115]

                if u116 then
                    u116.Text = u21(u20.Grey, "—")
                end
            end
        end,
    })

    for u112 = 1, 6 do
        u13.Settings.Activity[u112] = u111:Row():Left():Label({
            Text = _G.UU.LogBuffer[u112] or u21(u20.Grey, "—"),
        })
    end

    local u115 = u89:PageSection({
        Title = "Danger Zone",
        Subtitle = "Fully removes Universal Utility and stops everything it runs",
    }):Form()

    local u116 = u71(u115, "Uninject", "Press twice to confirm the removal"):Right():Button({
        Label = "Uninject",
        State = "Destructive",
        Pushed = function(u117)
            if not u81 then
                u81 = true
                u117.Label = "Click again to confirm"

                task.delay(3, function()
                    u81 = false

                    if u117.Parent then
                        u117.Label = "Uninject"
                    end
                end)

                return
            end

            u81 = false
            u117.Label = "Uninjecting..."
            u37()

            task.delay(0.15, function()
                if not u18() then
                    return
                end
                if u82 then
                    pcall(task.cancel, u82)
                end
                u52("Click")
                u52("Spam")
                for u118, u119 in pairs(_G.UU.Threads) do
                    if typeof(u119) == "thread" and coroutine.status(u119) ~= "dead" then
                        pcall(task.cancel, u119)
                    end

                    _G.UU.Threads[u118] = nil
                end

                for u118, u119 in pairs(_G.UU.Connections) do
                    pcall(function()
                        u119:Disconnect()
                    end)
                end

                _G.UU.Connections = {}

                if u61 then
                    pcall(setfpscap, 60)
                end

                pcall(function()
                    if typeof(dequeue_on_teleport) == "function" then
                        dequeue_on_teleport()
                    end
                end)

                pcall(u37)

                u90:Destroy()
                u65:Destroy()

                _G.UU.Threads = {}
                _G.UU.Connections = {}
                _G.UU.UI = {}
                _G.UU.LogBuffer = {}
                _G.UU.App = nil
                _G.UU.EditorApp = nil
                _G.UU.CFG = nil
                _G.UU.SaveCFG = nil
                _G.UU.DebouncedSave = nil
                _G.UU.Loaded = false
                _G.UU.LoadLock = false
                _G.UU.TeleportQueued = false
                _G.UU.RejoinConnection = nil
            end)
        end,
    })
end

for u13, u14 in pairs(_G.UU.UI.Tabs) do
    u14.Activated:Connect(function()
        u19.CurrentTab = u13
        u38()
    end)
end

local u13 = _G.UU.UI.Tabs[u19.CurrentTab] and u19.CurrentTab or "Home"
_G.UU.UI.Tabs[u13].Selected = true

u75 = true

table.insert(
    _G.UU.Connections,
    u3.InputBegan:Connect(function(u14, u15)
        if u15 then
            return
        end

        if u14.KeyCode == Enum.KeyCode.F5 and u14.KeyCode ~= u19.Keybind then
            u54(not u19.MousePosEnabled, false)
        end

        if u14.KeyCode == Enum.KeyCode.F4 and u14.KeyCode ~= u19.Keybind then
            u57(not u19.ClickEnabled, false)
        end
    end)
)

table.insert(
    _G.UU.Connections,
    u1.PlayerAdded:Connect(function()
        if _G.UU.UI.Home and _G.UU.UI.Home.Players then
            _G.UU.UI.Home.Players.Text = u21(u20.Lime, #u1:GetPlayers() .. " / " .. u1.MaxPlayers)
        end
    end)
)

table.insert(
    _G.UU.Connections,
    u1.PlayerRemoving:Connect(function()
        if _G.UU.UI.Home and _G.UU.UI.Home.Players then
            _G.UU.UI.Home.Players.Text = u21(u20.Lime, #u1:GetPlayers() .. " / " .. u1.MaxPlayers)
        end
    end)
)

local function u16()
    local u14 = workspace.CurrentCamera

    if not u14 then
        return
    end

    if _G.UU.UI.Home and _G.UU.UI.Home.Resolution then
        _G.UU.UI.Home.Resolution.Text =
            u21(u20.Cyan, string.format("%dx%d", u14.ViewportSize.X, u14.ViewportSize.Y))
    end
end

u16()

local function u27()
    local u14 = workspace.CurrentCamera

    if u14 then
        table.insert(_G.UU.Connections, u14:GetPropertyChangedSignal("ViewportSize"):Connect(u16))
    end
end

u27()

table.insert(_G.UU.Connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(u27))

table.insert(
    _G.UU.Connections,
    u2.RenderStepped:Connect(function()
        u78 = u78 + 1
        local u14 = tick()

        if u14 - u79 >= 1 then
            local u15 = math.floor(u78 / (u14 - u79))
            u78 = 0
            u79 = u14

            if #u76 >= 60 then
                table.remove(u76, 1)
            end
            table.insert(u76, u15)

            local u16, u27, u28 = math.huge, 0, 0

            for u29, u30 in ipairs(u76) do
                u16 = math.min(u16, u30)
                u27 = math.max(u27, u30)
                u28 = u28 + u30
            end

            local u31 = math.floor(u28 / #u76)
            local u32 = _G.UU.UI
            local u33 = u8:GetTotalMemoryUsageMb()
            u80 = math.max(u80, u33)

            if u32.Home then
                if u32.Home.FPS then
                    u32.Home.FPS.Text = u21(u20.Green, u15)
                end

                if u32.Home.Memory then
                    u32.Home.Memory.Text = u21(u20.Purple, string.format("%.1f MB", u33))
                end
            end

            if u32.Perf then
                if u32.Perf.FpsCurrent then
                    u32.Perf.FpsCurrent.Text = u21(u20.Green, u15)
                end

                if u32.Perf.FpsAvg then
                    u32.Perf.FpsAvg.Text = u21(u20.Mint, u31)
                end

                if u32.Perf.FpsRange then
                    u32.Perf.FpsRange.Text = u21(u20.Grey, string.format("Min: %d | Max: %d", u16, u27))
                end

                if u32.Perf.MemCurrent then
                    u32.Perf.MemCurrent.Text = u21(u20.Purple, string.format("%.1f MB", u33))
                end

                if u32.Perf.MemPeak then
                    u32.Perf.MemPeak.Text = u21(u20.Pink, string.format("%.1f MB", u80))
                end
            end
        end

        if tick() - (_G.UU.LastPingTime or 0) >= 2 then
            _G.UU.LastPingTime = tick()

            local u14 = math.floor(u9:GetNetworkPing() * 1000)
            if #u77 >= 60 then
                table.remove(u77, 1)
            end
            table.insert(u77, u14)

            local u15, u16, u27 = math.huge, 0, 0

            for u28, u29 in ipairs(u77) do
                u15 = math.min(u15, u29)
                u16 = math.max(u16, u29)
                u27 = u27 + u29
            end

            local u30 = math.floor(u27 / #u77)
            local u31 = _G.UU.UI

            if u31.Home and u31.Home.Ping then
                u31.Home.Ping.Text = u21(u25(u14), u14 .. " ms")
            end

            if u31.Perf then
                if u31.Perf.PingCurrent then
                    u31.Perf.PingCurrent.Text = u21(u25(u14), u14 .. " ms")
                end

                if u31.Perf.PingAvg then
                    u31.Perf.PingAvg.Text = u21(u20.Mint, u30 .. " ms")
                end

                if u31.Perf.PingRange then
                    u31.Perf.PingRange.Text =
                        u21(u20.Grey, string.format("Min: %d ms | Max: %d ms", u15, u16))
                end

                if u31.Perf.Quality then
                    local u32

                    if u14 < 50 then
                        u32 = "Excellent"
                    elseif u14 < 100 then
                        u32 = "Good"
                    elseif u14 < 200 then
                        u32 = "Fair"
                    elseif u14 < 300 then
                        u32 = "Poor"
                    else
                        u32 = "Very Poor"
                    end

                    u31.Perf.Quality.Text = u21(u25(u14), u32)
                end
            end
        end
    end)
)

u53("MouseLabel", function()
    while true do
        task.wait(0.25)

        local u14 = _G.UU.UI

        if u14.AntiAFK and u14.AntiAFK.MouseState and u14.AntiAFK.MouseState.Parent then
            u14.AntiAFK.MouseState.Text = u22(u19.MousePosEnabled, u19.MousePosSaved.X, u19.MousePosSaved.Y)
        end
    end
end)

if u19.JumpEnabled then
    task.defer(u55)
end

if u19.ClickEnabled then
    task.defer(u56)
end

if u19.AutoSpamEnabled then
    local u14 = Enum.KeyCode[u19.SpamKey]
    local u15 = u14 and (u14 == Enum.KeyCode.P or u14.Name == "F4" or u14.Name == "F5" or u14 == u19.Keybind)

    if not u14 or u15 then
        u19.AutoSpamEnabled = false

        _G.UU.UI.SyncSpam = true
        _G.UU.UI.Spam.Toggle.Value = false
        _G.UU.UI.SyncSpam = false

        u50(
            "Key Spam → "
                .. (
                    not u14 and "Invalid key '" .. u19.SpamKey .. "' saved in config"
                    or "Key '" .. u14.Name .. "' is reserved"
                )
        )
    else
        u58()
    end
end

if u19.AutoRejoinEnabled then
    u59()
end

if u19.FPSUnlockEnabled and u61 then
    u62()
else
    if u61 then
        pcall(setfpscap, 60)
    end

    if u19.FPSUnlockEnabled and not u61 then
        u19.FPSUnlockEnabled = false

        _G.UU.UI.SyncFps = true
        _G.UU.UI.Perf.Toggle.Value = false
        _G.UU.UI.SyncFps = false

        u50("FPS Unlock → Not supported by executor")
    end
end

if u19.MousePosEnabled then
    u54(true, false)
end

u65.Destroying:Connect(function()
    if not u18() then
        return
    end
    pcall(u37)
    _G.UU.Loaded = false
    _G.UU.LoadLock = false
    if u82 then
        pcall(task.cancel, u82)
    end
    u52("Click")
    u52("Spam")

    for u14, u15 in pairs(_G.UU.Threads) do
        if typeof(u15) == "thread" and coroutine.status(u15) ~= "dead" then
            pcall(task.cancel, u15)
        end
    end

    for u14, u15 in pairs(_G.UU.Connections) do
        pcall(function()
            u15:Disconnect()
        end)
    end
    if u61 then
        pcall(setfpscap, 60)
    end
    pcall(function()
        u90:Destroy()
    end)
    _G.UU.Session = nil
end)

if queue_on_teleport and not _G.UU.TeleportQueued then
    _G.UU.TeleportQueued = true

    pcall(function()
        queue_on_teleport(
            'loadstring(game:HttpGet("https://raw.githubusercontent.com/6942x/UniversalUtility/main/Init.lua", true))()'
        )
    end)
end

_G.UU.Loaded = true
_G.UU.LoadLock = false

task.defer(function()
    if u40 then
        u50("Config loaded for " .. u10 .. " (Id: " .. u11 .. ")")
        u51("Welcome back", "Config loaded for " .. u10)
    else
        u50("Fresh start — no saved config found")
        u50("Defaults applied · Keybind: G")
        u51("Welcome", "Universal Utility is ready")
    end

    local u14 = _G.UU.UI

    if u14.Loader and u14.Loader.PushOutput and u19.AutoLoadEnabled and u19.SavedCode ~= "" then
        u50("Auto Load → executing saved script")

        local u15, u16 = u60(u19.SavedCode)

        if u15 then
            u14.Loader.PushOutput("Auto-load executed successfully.", u20.Green)
            u50("Auto Load → script executed ✓")
        else
            if u16 then
                u14.Loader.PushOutput(tostring(u16), u20.Red)
            end

            u50("Auto Load error: " .. tostring(u16):sub(1, 80))
            u51("Auto Load failed", tostring(u16):sub(1, 120))
        end
    end
end)

return _G.UU
