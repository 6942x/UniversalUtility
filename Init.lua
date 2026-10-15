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

local u60 = false

local function u61(u13)
    if not u18() then
        return false, "This utility session has ended"
    end
    if u60 then
        return false, "A script is already running"
    end
    if type(u13) ~= "string" or u13 == "" then
        return false, "No code to execute"
    end

    u60 = true
    local u14, u15 = xpcall(function()
        local u16, u27 = loadstring(u13, "=UniversalUtility.ScriptLoader")

        if not u16 then
            error(u27, 0)
        end

        u16()
    end, debug.traceback)
    u60 = false

    if u14 then
        return true, nil
    end

    return false, tostring(u15)
end

local u62 = typeof(setfpscap) == "function"

if u62 then
    u62 = pcall(setfpscap, 60)
end

local function u63()
    if not u62 then
        return
    end

    if u19.FPSUnlockEnabled then
        pcall(setfpscap, u19.TargetFPS)
    else
        pcall(setfpscap, 60)
    end
end

_G.UU.UI = {}

local u64 =
    loadstring(game:HttpGet("https://github.com/cascadeui/Cascade/releases/latest/download/dist.luau"))()
if not u18() then
    return
end

local function u65(u13, u14)
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

local u66 = u64.New({
    WindowPill = true,
    Theme = u64.Themes[u19.ThemeMode] or u64.Themes.Dark,
    Accent = u64.Accents[u19.AccentName] or u64.Accents.Blue,
})

_G.UU.App = u66

local u67 = u66:Window({
    Title = "Universal Utility",
    Subtitle = u10,
    Size = u65(850, 530),
    Draggable = true,
    Resizable = true,
    Dropshadow = true,
    CanExit = false,
    CanMinimize = true,
    CanZoom = true,
    Minimized = u19.AutoHideEnabled,
})

local u68 = u67:Section({ Title = "General" })
local u69 = u67:Section({ Title = "Automation" })
local u70 = u67:Section({ Title = "Session" })
local u71 = u67:Section({ Title = "System" })

local function u72(u13, u14, u15)
    local u16 = u13:Row()

    u16:Left():TitleStack({
        Title = u14,
        Subtitle = u15,
    })

    return u16
end

local function u73(u13)
    local u14 = u13.Structures

    u14.Gradient.Enabled = false
    u14.Surface.BackgroundTransparency = 1
    u14.Surface.Size = UDim2.fromOffset(38, 38)
    u14.Image.Size = UDim2.fromOffset(36, 36)
    u14.Body.Size = UDim2.fromOffset(40, 40)

    return u13
end

local function u74(u13, u14, u15)
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

local function u75(u13, u14)
    local u15 = u13:Right():Slider(u14)

    if u15.Structures and u15.Structures.Thumb then
        u15.Structures.Thumb.Position = UDim2.fromScale(1, 0.5)
    end

    return u15
end

local u76 = false

local u77, u78 = {}, {}

local u79, u80 = 0, tick()
local u81 = 0
local u82 = false
local u83 = nil

local u84 = u74(u68, "Home", u64.Symbols.house)
local u85 = u74(u69, "Anti-AFK", u64.Symbols.bolt)
local u86 = u74(u69, "Key Spam", u64.Symbols.keyboard)
local u87 = u74(u70, "Auto Rejoin", u64.Symbols.arrowClockwise)
local u88 = u74(u70, "Script Loader", u64.Symbols.docPlaintext)
local u89 = u74(u71, "Performance", u64.Symbols.waveform)
local u90 = u74(u71, "Settings", u64.Symbols.gearshape)

_G.UU.UI.Tabs = {
    Home = u84,
    AntiAFK = u85,
    KeySpam = u86,
    Rejoin = u87,
    Loader = u88,
    Performance = u89,
    Settings = u90,
}

do
    local u13 = _G.UU.UI
    local u14 = u84:PageSection({ Title = "Player" }):Form()

    local u15 = u14:Row()

    u73(u15:Left():ImageSurface({
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
        Executor = u72(u14, "Executor"):Right():Label({
            Text = u21(u20.Blue, u16 .. (u27 ~= "" and (" " .. u27) or "")),
        }),
        Device = u72(u14, "Device"):Right():Label({
            Text = u21(u20.Mint, u46()),
        }),
        Resolution = u72(u14, "Resolution"):Right():Label({
            Text = u21(u20.Cyan, "Detecting..."),
        }),
        FPS = u72(u14, "FPS"):Right():Label({
            Text = u21(u20.Grey, "—"),
        }),
        Ping = u72(u14, "Ping"):Right():Label({
            Text = u21(u20.Grey, "—"),
        }),
        Memory = u72(u14, "Memory"):Right():Label({
            Text = u21(u20.Grey, "—"),
        }),
    }

    local u28 = u84:PageSection({ Title = "Game" }):Form()
    local u29 = u28:Row()

    u13.GameIcon = u29:Left():ImageSurface({
        Image = u64.Symbols.docPlaintext,
    })

    u73(u13.GameIcon)

    u13.GameName = u29:Right():TitleStack({
        Title = "Loading game info...",
        Subtitle = u21(u20.Blue, "Universal Utility"),
    })

    u13.Home.PlaceId = u72(u28, "Place Id"):Right():Label({
        Text = u21(u20.Indigo, tostring(game.PlaceId)),
    })

    u13.Home.UniverseId = u72(u28, "Universe Id"):Right():Label({
        Text = u21(u20.Teal, tostring(game.GameId)),
    })

    u13.Home.Players = u72(u28, "Server Players"):Right():Label({
        Text = u21(u20.Lime, #u1:GetPlayers() .. " / " .. u1.MaxPlayers),
    })

    u13.Home.PlaceVersion = u72(u28, "Place Version"):Right():Label({
        Text = u21(u20.Orange, tostring(game.PlaceVersion)),
    })

    u13.Home.Region = u72(u28, "Server Region"):Right():Label({
        Text = u21(u20.Grey, "Server Region: ") .. u21(u20.Mint, "Detecting..."),
    })

    u13.Home.JobId = u72(u28, "Job Id"):Right():Label({
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
    local u14 = u85:PageSection({ Title = "Automation" }):Form()

    u13.AntiAFK = {}

    local u15 = u72(u14, "Auto Jump", "Simulates jumping to keep the session alive")

    u15:Right():Toggle({
        Value = u19.JumpEnabled,
        ValueChanged = function(u30, u31)
            if not u76 then
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

    local u16 = u72(u14, "Auto Click", "Simulates mouse clicks at the chosen position · F4 toggles")

    u13.AntiAFK.ClickToggle = u16:Right():Toggle({
        Value = u19.ClickEnabled,
        ValueChanged = function(u30, u31)
            if u13.SyncClick or not u76 then
                return
            end

            u57(u31, true)
        end,
    })

    local u27 = u72(u14, "Mouse Position", "Track the live cursor or lock a saved position")

    u13.AntiAFK.MouseToggle = u27:Right():Toggle({
        Value = u19.MousePosEnabled,
        ValueChanged = function(u30, u31)
            if u13.SyncMouse or not u76 then
                return
            end

            u54(u31, true)
        end,
    })

    u13.AntiAFK.MouseState = u72(u14, "Mouse State", "F5 toggles between tracking and locked"):Right():Label({
        Text = u22(u19.MousePosEnabled, u19.MousePosSaved.X, u19.MousePosSaved.Y),
    })

    local u28 = u85:PageSection({
        Title = "Cooldowns",
        Subtitle = "Exponential scale from 0.01 seconds to 10 minutes",
    }):Form()

    u13.AntiAFK.JumpValue = u72(u28, "Jump Delay"):Right():Label({
        Text = u21(u20.Green, u41(u19.JumpDelay)),
    })

    local u29 = u72(u28, "Jump Cooldown")

    u75(u29, {
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

    u13.AntiAFK.ClickValue = u72(u28, "Click Delay"):Right():Label({
        Text = u21(u20.Orange, u41(u19.ClickDelay)),
    })

    local u30 = u72(u28, "Click Cooldown")

    u75(u30, {
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
    local u14 = u86:PageSection({ Title = "Input" }):Form()

    u13.Spam = {}

    u13.Spam.Interval = u72(u14, "Selected Interval"):Right():Label({
        Text = u21(u20.Yellow, string.format("%.2fs", u19.SpamDelay)),
    })

    local u15 = u72(u14, "Spam Interval", "Delay between each simulated key press")

    u75(u15, {
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

    local u16 = u72(u14, "Target Key", "The key that gets pressed automatically")

    u16:Right():KeybindField({
        Value = Enum.KeyCode[u19.SpamKey] or Enum.KeyCode.Q,
        ValueChanged = function(u30, u31)
            if not u76 then
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

    local u27 = u86:PageSection({ Title = "Control" }):Form()
    local u28 = u72(u27, "Auto Spam", "Repeatedly presses the target key")

    u13.Spam.Toggle = u28:Right():Toggle({
        Value = u19.AutoSpamEnabled,
        ValueChanged = function(u30, u31)
            if u13.SyncSpam or not u76 then
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
    local u14 = u87:PageSection({ Title = "Watcher" }):Form()

    u13.Rejoin = {}

    local u15 = u72(u14, "Auto Rejoin", "Reconnects automatically when disconnected")

    u13.Rejoin.Toggle = u15:Right():Toggle({
        Value = u19.AutoRejoinEnabled,
        ValueChanged = function(u30, u31)
            if not u76 then
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

local u91 = u64.New({
    WindowPill = false,
    Theme = u64.Themes[u19.ThemeMode] or u64.Themes.Dark,
    Accent = u64.Accents[u19.AccentName] or u64.Accents.Blue,
})

_G.UU.EditorApp = u91

do
    local u13 = _G.UU.UI
    local u14 = u88:PageSection({ Title = "Editor" }):Form()

    u13.Loader = { Output = {}, History = {} }

    u13.Loader.AutoLoad = u72(u14, "Auto Load", "Executes the saved code on every injection"):Right():Toggle({
        Value = u19.AutoLoadEnabled,
        ValueChanged = function(u30, u31)
            if not u76 then
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

    local u92 = u65(620, 460)
    local u93 = UDim2.fromScale(0.5, 0.5)

    pcall(function()
        local u94 = u67.Structures.Body.__instance

        if not (u94 and u94.Parent) then
            return
        end

        local u95 = u94.Parent.AbsoluteSize
        local u96 = u94.AbsoluteSize

        if u96.X < 50 or u96.Y < 50 then
            u96 = Vector2.new(u94.Size.X.Offset, u94.Size.Y.Offset)
        end

        if u96.X < 50 or u96.Y < 50 then
            u96 = Vector2.new(math.min(850, u95.X - 24), math.min(530, u95.Y - 64))
        end

        local u97 = u94.Position
        local u98 = u67.Minimized and Vector2.new(u95.X / 2, u95.Y / 2)
            or Vector2.new(u97.X.Offset + u97.X.Scale * u95.X, u97.Y.Offset + u97.Y.Scale * u95.Y)
        local u99 = Vector2.new(u92.X.Offset, u92.Y.Offset)
        local u100 = {
            Vector2.new(u98.X + u96.X / 2 + u99.X / 2 + 12, u98.Y),
            Vector2.new(u98.X - u96.X / 2 - u99.X / 2 - 12, u98.Y),
            Vector2.new(u98.X, u98.Y + u96.Y / 2 + u99.Y / 2 + 12),
            Vector2.new(u98.X, u98.Y - u96.Y / 2 - u99.Y / 2 - 12),
        }

        for u101, u102 in ipairs(u100) do
            if
                u102.X - u99.X / 2 >= 6
                and u102.X + u99.X / 2 <= u95.X - 6
                and u102.Y - u99.Y / 2 >= 6
                and u102.Y + u99.Y / 2 <= u95.Y - 6
            then
                u93 = UDim2.fromOffset(math.floor(u102.X), math.floor(u102.Y))

                return
            end
        end

        u93 = UDim2.fromOffset(
            math.floor(math.clamp(u98.X + 40, u99.X / 2 + 6, math.max(u99.X / 2 + 7, u95.X - u99.X / 2 - 6))),
            math.floor(math.clamp(u98.Y + 40, u99.Y / 2 + 6, math.max(u99.Y / 2 + 7, u95.Y - u99.Y / 2 - 6)))
        )
    end)

    local u15 = u91:Window({
        Title = "Code Editor",
        Subtitle = u10,
        Size = u92,
        Position = u93,
        Searching = false,
        CanExit = false,
        CanMinimize = true,
        CanZoom = true,
        Minimized = true,
    })

    task.delay(0.3, function()
        pcall(function()
            if u15.Minimized then
                u15.Position = u93
                u15.Minimized = true
            end
        end)
    end)

    local u27 = u15:Section({ Title = "Code" })
    local u28 = u74(u27, "Editor", u64.Symbols.docPlaintext)

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

    local u103 = u29:FindFirstChild("Margins") or u29:FindFirstChildOfClass("UIPadding")

    if u103 then
        u103.PaddingTop = UDim.new()
        u103.PaddingBottom = UDim.new()
        u103.PaddingLeft = UDim.new()
        u103.PaddingRight = UDim.new()
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

    local u104 = Instance.new("TextLabel")

    u104.Name = "Numbers"
    u104.Size = UDim2.new(0, 40, 0, 240)
    u104.BackgroundColor3 = Color3.fromRGB(21, 23, 30)
    u104.BorderSizePixel = 0
    u104.FontFace = u31
    u104.TextSize = 14
    u104.TextColor3 = Color3.fromRGB(90, 97, 115)
    u104.TextXAlignment = Enum.TextXAlignment.Right
    u104.TextYAlignment = Enum.TextYAlignment.Top
    u104.Text = "1"
    u104.Parent = u34

    Instance.new("UIPadding", u104).PaddingRight = UDim.new(0, 6)

    local u105 = Instance.new("Frame")

    u105.Name = "TextZone"
    u105.Position = UDim2.new(0, 40, 0, 0)
    u105.Size = UDim2.new(0, 480, 0, 240)
    u105.BackgroundTransparency = 1
    u105.Parent = u34

    local u106 = Instance.new("TextLabel")

    u106.Name = "Highlight"
    u106.Size = UDim2.new(1, 0, 1, 0)
    u106.BackgroundTransparency = 1
    u106.FontFace = u31
    u106.TextSize = 14
    u106.TextColor3 = Color3.fromRGB(233, 234, 238)
    u106.TextXAlignment = Enum.TextXAlignment.Left
    u106.TextYAlignment = Enum.TextYAlignment.Top
    u106.TextWrapped = false
    u106.RichText = true
    u106.Text = ""
    u106.Parent = u105

    local u107 = Instance.new("TextBox")

    u107.Name = "Input"
    u107.Size = UDim2.new(1, 0, 1, 0)
    u107.BackgroundTransparency = 1
    u107.BorderSizePixel = 0
    u107.FontFace = u31
    u107.TextSize = 14
    u107.TextColor3 = Color3.new(0, 0, 0)
    u107.TextTransparency = 1
    u107.TextXAlignment = Enum.TextXAlignment.Left
    u107.TextYAlignment = Enum.TextYAlignment.Top
    u107.TextWrapped = false
    u107.MultiLine = true
    u107.ClearTextOnFocus = false
    u107.Text = ""
    u107.ZIndex = 2
    u107.Parent = u105

    local u108 = Instance.new("Frame")

    u108.Name = "Footer"
    u108.Position = UDim2.new(0, 0, 1, -26)
    u108.Size = UDim2.new(1, 0, 0, 26)
    u108.BackgroundColor3 = Color3.fromRGB(21, 23, 30)
    u108.BorderSizePixel = 0
    u108.Parent = u33

    local u109 = Instance.new("TextLabel")

    u109.Name = "Hint"
    u109.Position = UDim2.new(0, 10, 0, 0)
    u109.Size = UDim2.new(0.62, 0, 1, 0)
    u109.BackgroundTransparency = 1
    u109.FontFace = u31
    u109.TextSize = 12
    u109.TextColor3 = Color3.fromRGB(108, 116, 136)
    u109.TextXAlignment = Enum.TextXAlignment.Left
    u109.Text = "Lua · made for short loadstrings"
    u109.Parent = u108

    local u110 = Instance.new("TextLabel")

    u110.Name = "Count"
    u110.Position = UDim2.new(0.62, 0, 0, 0)
    u110.Size = UDim2.new(0.38, -54, 1, 0)
    u110.BackgroundTransparency = 1
    u110.FontFace = u31
    u110.TextSize = 12
    u110.TextColor3 = Color3.fromRGB(139, 147, 163)
    u110.TextXAlignment = Enum.TextXAlignment.Right
    u110.Text = "1 / 50 lines"
    u110.Parent = u108

    local u111 = Instance.new("TextButton")

    u111.Name = "Run"
    u111.AnchorPoint = Vector2.new(1, 0.5)
    u111.Position = UDim2.new(1, -8, 0.5, 0)
    u111.Size = UDim2.fromOffset(40, 18)
    u111.BackgroundColor3 = Color3.fromRGB(29, 42, 33)
    u111.BorderSizePixel = 0
    u111.FontFace = u31
    u111.TextSize = 12
    u111.TextColor3 = Color3.fromRGB(50, 215, 75)
    u111.Text = "Run"

    Instance.new("UICorner", u111).CornerRadius = UDim.new(0, 5)

    u111.Parent = u108

    local u112 = false
    local u113 = false
    local u114 = false
    local u115 = u107.Text

    local function u116(u117)
        local u118 = select(2, u117:gsub("\n", "")) + 1

        if u118 > 50 then
            local u119, u120 = 0, 0

            for u121 = 1, #u117 do
                if u117:sub(u121, u121) == "\n" then
                    u119 = u119 + 1

                    if u119 == 50 then
                        u120 = u121 - 1

                        break
                    end
                end
            end

            u117 = u117:sub(1, u120)

            if not u113 then
                u113 = true

                if u112 then
                    u50("Editor → 50 line limit reached")
                end
            end

            u107.Text = u117

            return
        end

        if u118 < 50 then
            u113 = false
        end

        local u122 = {}

        for u123 = 1, u118 do
            u122[#u122 + 1] = u123
        end

        u104.Text = table.concat(u122, "\n")

        if u114 then
            u106.Text = ""
        else
            local u124, u125 = pcall(u26, u117)

            if u124 then
                u106.Text = u125
            else
                u106.Text = u24 and u24(u117) or ""
            end
        end

        u110.TextColor3 = u113 and Color3.fromRGB(255, 69, 58)
            or u118 >= 45 and Color3.fromRGB(255, 159, 10)
            or Color3.fromRGB(139, 147, 163)
        u110.Text = u118 .. " / 50 lines"

        local u126 = 0

        for u127 in (u117 .. "\n"):gmatch("(.-)\n") do
            if u127 ~= "" then
                u126 = math.max(u126, u30:GetTextSize(u127, 14, Enum.Font.Code, Vector2.new(10000, 10000)).X)
            end
        end

        local u128 = u34.AbsoluteWindowSize
        local u129 = math.max(u118 * u32 + 12, 240, math.floor(u128.Y))
        local u130 = math.max(u126 + 8, 480, math.floor(u128.X) - 40)

        u104.Size = UDim2.new(0, 40, 0, u129)
        u105.Size = UDim2.new(0, u130, 0, u129)
        u34.CanvasSize = UDim2.fromOffset(u130 + 40, u129)

        if u112 then
            u19.SavedCode = u117

            if u83 then
                pcall(task.cancel, u83)
            end

            u83 = task.delay(0.75, u38)
        end
    end

    u107:GetPropertyChangedSignal("Text"):Connect(function()
        u115 = u107.Text

        u116(u107.Text)
    end)

    u107.FocusLost:Connect(function()
        if not u112 or u107.Text == u19.SavedCode then
            return
        end

        u19.SavedCode = u107.Text
        u38()
    end)

    local function u131()
        local u132 = u29.AbsoluteWindowSize

        u33.Size = UDim2.new(1, 0, 0, math.max(240, math.floor(u132.Y)))

        task.defer(u116, u107.Text)
    end

    u29:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(u131)

    task.defer(u131)

    u111.MouseButton1Click:Connect(function()
        local u133, u134 = u61(u19.SavedCode)

        if u133 then
            u13.Loader.PushOutput("Script executed successfully.", u20.Green)
            u50("Script executed ✓")
        else
            if u134 then
                u13.Loader.PushOutput(tostring(u134), u20.Red)
            end

            u50("Script error: " .. tostring(u134):sub(1, 80))
            u51("Execution failed", tostring(u134):sub(1, 120))
        end
    end)

    u115 = u19.SavedCode or ""
    u107.Text = u115

    pcall(u116, u107.Text)

    u112 = true

    local u125 = u72(u14, "Open Editor", "Popup window with Studio-style colors · 50 lines max")

    u125:Right():Button({
        Label = "Open",
        State = "Primary",
        Pushed = function()
            u15.Minimized = false
        end,
    })

    local u135 = u67.Minimized
    local u136 = not u15.Minimized

    u53("Editor", function()
        while u18() and not _G.UU.Loaded do
            task.wait(0.1)
        end

        while u18() and _G.UU.Loaded do
            pcall(function()
                local u137 = u67.Minimized

                if u137 ~= u135 then
                    u135 = u137

                    if u137 then
                        u136 = not u15.Minimized
                        u15.Minimized = true
                    elseif u136 then
                        u15.Minimized = false
                    end
                end

                if u107.Text ~= u115 then
                    u115 = u107.Text

                    u116(u115)
                end
            end)

            task.wait(0.15)
        end
    end)

    local u128 = u72(u14, "Execute", "Runs the current code immediately")

    u128:Right():Button({
        Label = "Execute",
        State = "Primary",
        Pushed = function()
            local u138, u139 = u61(u19.SavedCode)

            if u138 then
                u13.Loader.PushOutput("Script executed successfully.", u20.Green)
                u50("Script executed ✓")
            else
                if u139 then
                    u13.Loader.PushOutput(tostring(u139), u20.Red)
                end

                u50("Script error: " .. tostring(u139):sub(1, 80))
                u51("Execution failed", tostring(u139):sub(1, 120))
            end
        end,
    })

    local u140 = u72(u14, "Clear Editor", "Empties the code field and the saved config")

    u140:Right():Button({
        Label = "Clear",
        State = "Destructive",
        Pushed = function()
            u107.Text = ""
            u19.SavedCode = ""

            u50("Script Loader → Editor cleared")
            u38()
        end,
    })

    local u141 = u88:Form()

    u72(u141, "Output", "Shows the results of your last script run, newest first"):Right():Button({
        Label = "Clear",
        State = "Destructive",
        Pushed = function()
            u13.Loader.History = {}

            for u142 = 1, 3 do
                local u143 = u13.Loader.Output[u142]

                if u143 then
                    u143.Text = u21(u20.Grey, "—")
                end
            end
        end,
    })

    for u144 = 1, 3 do
        u13.Loader.Output[u144] = u141:Row():Left():Label({
            Text = u21(u20.Grey, "—"),
        })
    end

    u13.Loader.PushOutput = function(u142, u143)
        local u145 = u13.Loader.History

        table.insert(u145, 1, u21(u143 or u20.White, u24(u142)))

        if #u145 > 3 then
            table.remove(u145, 4)
        end

        for u146 = 1, 3 do
            local u147 = u13.Loader.Output[u146]

            if u147 then
                u147.Text = u145[u146] or u21(u20.Grey, "—")
            end
        end
    end

    local u148 = Instance.new("Frame")

    u148.Name = "Caret"
    u148.Size = UDim2.fromOffset(2, math.max(u32 - 4, 10))
    u148.BackgroundColor3 = Color3.fromRGB(240, 241, 245)
    u148.BorderSizePixel = 0
    u148.Visible = false
    u148.ZIndex = 2
    u148.Parent = u105

    local u149 = nil

    local function u150(u13)
        if typeof(u13) == "Vector2" then
            return u13
        end

        if type(u13) ~= "number" or u13 ~= u13 then
            return nil
        end

        local u151 = string.split(u107.Text, "\n")
        local u152, u153

        if u13 < 0 then
            u152 = #u151
            u153 = #(u151[u152] or "") + 1
        else
            local u154 = u107.Text:sub(1, math.clamp(math.floor(u13), 0, #u107.Text))
            local u155 = u154:match(".*\n")

            u152 = select(2, u154:gsub("\n", "")) + 1
            u153 = #u154 - (u155 and #u155 or 0) + 1
        end

        u152 = math.clamp(u152, 1, #u151)

        return { X = math.clamp(u153, 1, #(u151[u152] or "") + 1), Y = u152 }
    end

    local function u156()
        if u114 then
            return
        end

        u114 = true
        u106.Visible = false
        u148.Visible = false
        u107.TextTransparency = 0
        u107.TextColor3 = Color3.fromRGB(233, 234, 238)
    end

    local function u157()
        if u114 then
            u148.Visible = false

            return false
        end

        local u158 = string.split(u107.Text, "\n")
        local u159 = u150(u107.CursorPosition)

        if not u159 then
            u148.Visible = false

            if u107:IsFocused() then
                u156()
            end

            return false
        end

        local u160 = math.clamp(u159.Y, 1, #u158)
        local u161 = u158[u160] or ""
        local u162 = u30:GetTextSize(
            u161:sub(1, math.max(math.min(u159.X - 1, #u161), 0)),
            14,
            Enum.Font.Code,
            Vector2.new(10000, 10000)
        ).X

        u148.Position = UDim2.fromOffset(u162, (u160 - 1) * u32 + 2)

        local u163 = u34.AbsoluteWindowSize

        if u107:IsFocused() and u163.X > 1 then
            local u164 = u34.CanvasPosition

            if u162 < u164.X or u162 > u164.X + u163.X - 60 then
                u34.CanvasPosition = Vector2.new(math.max(u162 - u163.X + 120, 0), u164.Y)
            end

            local u165 = (u160 - 1) * u32

            if u165 < u164.Y or u165 > u164.Y + u163.Y - u32 * 2 - 30 then
                u34.CanvasPosition =
                    Vector2.new(u34.CanvasPosition.X, math.max(u165 - u163.Y + u32 * 2 + 30, 0))
            end
        end

        local u166 = u107:IsFocused()

        u148.Visible = u166

        return u166
    end

    local function u167()
        for u158, u159 in pairs(u105:GetChildren()) do
            if u159.Name == "SelRect" then
                u159:Destroy()
            end
        end

        if u114 then
            return
        end

        local u158 = u107.SelectionStart

        if typeof(u158) == "number" and u158 < 0 then
            return
        end

        u158 = u150(u158)
        local u159 = u150(u107.CursorPosition)

        if not u107:IsFocused() or not u158 or not u159 then
            return
        end

        local u160 = string.split(u107.Text, "\n")
        local u161, u162 = math.min(u158.Y, u159.Y), math.max(u158.Y, u159.Y)

        if u161 < 1 or u161 > #u160 + 1 or (u161 == u162 and u158.X == u159.X) then
            return
        end

        for u163 = math.max(u161, 1), math.min(u162, #u160) do
            local u164, u165 = 0, 0
            local u166 = u160[u163] or ""

            if u163 == u161 and u163 == u162 then
                u164 = math.min(u158.X, u159.X) - 1
                u165 = math.max(u158.X, u159.X) - 1
            elseif u163 == u161 then
                u164 = (u158.Y <= u159.Y and u158.X or u159.X) - 1
                u165 = #u166
            elseif u163 == u162 then
                u165 = (u158.Y <= u159.Y and u159.X or u158.X) - 1
            else
                u165 = #u166
            end

            local u168 = u30:GetTextSize(
                u166:sub(1, math.max(math.min(u164, #u166), 0)),
                14,
                Enum.Font.Code,
                Vector2.new(10000, 10000)
            ).X
            local u169 = u30:GetTextSize(
                u166:sub(1, math.max(math.min(u165, #u166), 0)),
                14,
                Enum.Font.Code,
                Vector2.new(10000, 10000)
            ).X
            local u170 = Instance.new("Frame")

            u170.Name = "SelRect"
            u170.BackgroundColor3 = Color3.fromRGB(58, 110, 180)
            u170.BackgroundTransparency = 0.5
            u170.BorderSizePixel = 0
            u170.Position = UDim2.fromOffset(u168, (u163 - 1) * u32)
            u170.Size = UDim2.fromOffset(math.max(u169 - u168, 5), u32)
            u170.ZIndex = 1
            u170.Parent = u105
        end
    end

    u107.Focused:Connect(function()
        task.defer(function()
            if not u150(u107.CursorPosition) then
                u156()
            end
        end)

        if u149 then
            pcall(task.cancel, u149)

            u149 = nil
        end

        if u157() then
            u149 = task.spawn(function()
                while u148.Parent and u107:IsFocused() do
                    task.wait(0.45)

                    if not (u148.Parent and u107:IsFocused()) then
                        break
                    end

                    u148.Visible = not u148.Visible
                end
            end)
            _G.UU.Threads.Caret = u149
        end

        u167()
    end)

    u107.FocusLost:Connect(function()
        if u149 then
            pcall(task.cancel, u149)

            u149 = nil
        end

        u148.Visible = false
        u167()
    end)

    u107:GetPropertyChangedSignal("CursorPosition"):Connect(function()
        u157()
        u167()
    end)

    u107:GetPropertyChangedSignal("SelectionStart"):Connect(function()
        u167()
    end)

    u107:GetPropertyChangedSignal("Text"):Connect(function()
        u157()
        u167()
    end)

    u34:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
        local u171 = u34.AbsoluteWindowSize

        if u105.Size.Y.Offset < math.floor(u171.Y) or u105.Size.X.Offset < math.floor(u171.X) - 40 then
            u116(u107.Text)
        end
    end)
end

do
    local u13 = _G.UU.UI
    local u14 = u89:PageSection({ Title = "FPS Unlock" }):Form()

    u13.Perf = {}

    u13.Perf.Target = u72(u14, "Selected Limit"):Right():Label({
        Text = u21(u20.Cyan, u19.TargetFPS .. " FPS"),
    })

    local u15 = u72(u14, "Target FPS", "Custom framerate limit from 15 to 360")

    u75(u15, {
        Minimum = 15,
        Maximum = 360,
        Value = u19.TargetFPS,
        ValueChanged = function(u30, u31)
            u19.TargetFPS = math.floor(u31 + 0.5)

            if u13.Perf.Target then
                u13.Perf.Target.Text = u21(u20.Cyan, u19.TargetFPS .. " FPS")
            end

            if u19.FPSUnlockEnabled then
                u63()
            end

            u38()
        end,
    })

    local u16 = u72(u14, "FPS Unlock", "Removes the default 60 FPS cap")

    u13.Perf.Toggle = u16:Right():Toggle({
        Value = u19.FPSUnlockEnabled,
        ValueChanged = function(u30, u31)
            if u13.SyncFps or not u76 then
                return
            end

            if not u62 then
                u13.SyncFps = true
                u30.Value = false
                u13.SyncFps = false

                u50("FPS Unlock → Not supported by executor")
                u51("FPS Unlock", "Not supported by this executor")
                return
            end

            u19.FPSUnlockEnabled = u31
            u63()
            u50("FPS Unlock → " .. (u31 and ("Enabled (" .. u19.TargetFPS .. " FPS)") or "Disabled"))
            u38()
        end,
    })

    local u27 = u89:PageSection({ Title = "Framerate" }):Form()

    u13.Perf.FpsCurrent = u72(u27, "Current"):Right():Label({
        Text = u21(u20.Green, "60"),
    })

    u13.Perf.FpsAvg = u72(u27, "Average"):Right():Label({
        Text = u21(u20.Mint, "60"),
    })

    u13.Perf.FpsRange = u72(u27, "Range"):Right():Label({
        Text = u21(u20.Grey, "Min: 60 | Max: 60"),
    })

    local u28 = u89:PageSection({ Title = "Network" }):Form()

    u13.Perf.PingCurrent = u72(u28, "Current"):Right():Label({
        Text = u21(u20.Green, "0 ms"),
    })

    u13.Perf.PingAvg = u72(u28, "Average"):Right():Label({
        Text = u21(u20.Mint, "0 ms"),
    })

    u13.Perf.PingRange = u72(u28, "Range"):Right():Label({
        Text = u21(u20.Grey, "Min: 0 ms | Max: 0 ms"),
    })

    u13.Perf.Quality = u72(u28, "Connection Quality"):Right():Label({
        Text = u21(u20.Grey, "Measuring..."),
    })

    local u29 = u89:PageSection({ Title = "Memory" }):Form()

    u13.Perf.MemCurrent = u72(u29, "Current"):Right():Label({
        Text = u21(u20.Purple, "0 MB"),
    })

    u13.Perf.MemPeak = u72(u29, "Peak"):Right():Label({
        Text = u21(u20.Pink, "0 MB"),
    })
end

do
    local u13 = _G.UU.UI
    local u14 = u90:PageSection({
        Title = "Appearance",
        Subtitle = "Theme and accent apply instantly across the whole interface",
    }):Form()

    u13.Settings = { Activity = {} }

    local u15 = u72(u14, "Theme", "Pick between the light and the dark appearance")

    local function u16(u27)
        local u28 = game:GetService("TweenService")
        local u29 = Instance.new("Frame")
        local u30 = Instance.new("TextButton")
        local u31 = Instance.new("UICorner")
        local u32 = Instance.new("UIStroke")
        local u33 = Instance.new("TextLabel")
        local u34 = Instance.new("ImageLabel")
        local u104 = Instance.new("CanvasGroup")
        local u105 = Instance.new("UICorner")
        local u106 = Instance.new("UIStroke")
        local u107 = Instance.new("UIPadding")
        local u108 = Instance.new("UIListLayout")

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
        u34.Image = u64.Symbols.chevronDown
        u34.ScaleType = Enum.ScaleType.Fit
        u34.Parent = u30

        u104.AnchorPoint = Vector2.new(1, 0)
        u104.Size = UDim2.fromOffset(150, 14 + #u27.Options * 28 + (#u27.Options - 1) * 3)
        u104.ClipsDescendants = true
        u104.Visible = false
        u104.ZIndex = 50

        u105.CornerRadius = UDim.new(0, 8)
        u105.Parent = u104

        u106.Thickness = 1
        u106.Parent = u104

        u107.PaddingTop = UDim.new(0, 4)
        u107.PaddingBottom = UDim.new(0, 4)
        u107.PaddingLeft = UDim.new(0, 4)
        u107.PaddingRight = UDim.new(0, 4)
        u107.Parent = u104

        u108.Padding = UDim.new(0, 3)
        u108.SortOrder = Enum.SortOrder.LayoutOrder
        u108.Parent = u104

        local u109 = u27.Index
        local u110 = false
        local u111 = {}
        local u112
        local u113
        local u116
        local u130 = u27.Parent.Parent
        local u124
        local u125
        local u141
        local u144
        local u140

        u140 = function()
            local u128 = u130

            while u128 and not u128:IsA("ScrollingFrame") do
                u128 = u128.Parent
            end

            if u128 and u128.Parent then
                u128 = u128.Parent
            else
                u128 = u130

                while u128.Parent and u128.Parent:IsA("GuiObject") do
                    u128 = u128.Parent
                end
            end

            if u128 ~= u125 then
                u125 = u128

                u104.Parent = u125

                u141 = u125:FindFirstChildOfClass("UIPadding")
                u144 = u141 and Vector2.new(u141.PaddingLeft.Offset, u141.PaddingTop.Offset) or Vector2.new()
            end

            local u142 = u30.AbsolutePosition
            local u143 = u30.AbsoluteSize
            local u145 = u142.X + u143.X - u125.AbsolutePosition.X - u144.X
            local u146 = u142.Y + u143.Y - u125.AbsolutePosition.Y - u144.Y
            local u147 = u125.AbsoluteSize.Y - u144.Y - u104.AbsoluteSize.Y

            u104.Position = UDim2.fromOffset(u145, math.max(0, math.min(u146, u147)))
        end

        u30:GetPropertyChangedSignal("AbsolutePosition"):Connect(u140)

        u140()

        u112 = function(u117)
            local u118 = u27.Options[u117]

            u33.Text = u118.Dot and u21(u118.Dot, "●") .. "  " .. u118.Text or u118.Text
        end

        u113 = function(u117)
            if u110 == u117 then
                return
            end

            u110 = u117

            if u124 then
                u124:Cancel()

                u124 = nil
            end

            local u118 = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            u140()

            local u119 = UDim2.fromOffset(u104.Position.X.Offset, u104.Position.Y.Offset)

            if u117 then
                u104.GroupTransparency = 1
                u104.Position = UDim2.fromOffset(u119.X.Offset, u119.Y.Offset - 6)
                u104.Visible = true
            end

            u124 = u28:Create(u104, u118, {
                GroupTransparency = u117 and 0 or 1,
                Position = u117 and u119 or UDim2.fromOffset(u119.X.Offset, u119.Y.Offset - 6),
            })

            u124:Play()

            if u117 then
                u124.Completed:Connect(function(u128)
                    if u128 ~= Enum.PlaybackState.Completed then
                        return
                    end

                    u140()
                end)
            end

            u28:Create(u34, u118, { Rotation = u117 and 180 or 0 }):Play()

            if not u117 then
                u124.Completed:Connect(function(u125)
                    if u125 ~= Enum.PlaybackState.Completed or u110 then
                        return
                    end

                    u104.Visible = false

                    u124 = nil
                end)
            end
        end

        u116 = function(u117)
            local u118 = u66.Theme

            u30.BackgroundColor3 = u118.Controls.Background[1].Value
            u30.BackgroundTransparency = u118.Controls.Background[2].Value
            u32.Color = u118.Text.Quaternary[1].Value
            u32.Transparency = u118.Text.Quaternary[2].Value
            u33.TextColor3 = u118.Text.Primary[1].Value
            u33.TextTransparency = u118.Text.Primary[2].Value
            u34.ImageColor3 = u118.Text.Primary[1].Value
            u34.ImageTransparency = math.min(1, u118.Text.Primary[2].Value + 0.15)
            u104.BackgroundColor3 = u118.Controls.MenuButton.MenuBackground[1].Value
            u104.BackgroundTransparency = u118.Controls.MenuButton.MenuBackground[2].Value
            u106.Color = u118.Text.Quaternary[1].Value
            u106.Transparency = u118.Text.Quaternary[2].Value

            for u119, u120 in ipairs(u111) do
                local u121 = u119 == u117
                local u122 = u27.Colors and u27.Colors(u119) or u20[u19.AccentName] or u20.Grey

                u120.Row.BackgroundColor3 = u118.Text.Primary[1].Value
                u120.Row.BackgroundTransparency = 1
                u120.Label.TextColor3 = u118.Text.Primary[1].Value
                u120.Label.TextTransparency = u121 and 0 or 0.3
                u120.Check.ImageColor3 = Color3.fromHex(u122)
                u120.Check.Visible = u121
            end
        end

        for u117, u118 in ipairs(u27.Options) do
            local u123 = Instance.new("TextButton")
            local u126 = Instance.new("UICorner")
            local u127 = Instance.new("TextLabel")
            local u129 = Instance.new("ImageLabel")

            u123.Size = UDim2.new(1, 0, 0, 28)
            u123.AutoButtonColor = false
            u123.Text = ""
            u123.LayoutOrder = u117
            u123.ZIndex = 2
            u123.Parent = u104

            u126.CornerRadius = UDim.new(0, 6)
            u126.Parent = u123

            u127.BackgroundTransparency = 1
            u127.AnchorPoint = Vector2.new(0, 0.5)
            u127.Position = UDim2.new(0, 9, 0.5, 0)
            u127.Size = UDim2.new(1, -38, 1, 0)
            u127.FontFace = Font.new("rbxassetid://12187365364")
            u127.TextSize = 14
            u127.RichText = true
            u127.TextXAlignment = Enum.TextXAlignment.Left
            u127.TextTruncate = Enum.TextTruncate.AtEnd
            u127.Text = u118.Dot and u21(u118.Dot, "●") .. "  " .. u118.Text or u118.Text
            u127.ZIndex = 2
            u127.Parent = u123

            u129.BackgroundTransparency = 1
            u129.AnchorPoint = Vector2.new(1, 0.5)
            u129.Position = UDim2.new(1, -9, 0.5, 0)
            u129.Size = UDim2.fromOffset(14, 14)
            u129.Image = u64.Symbols.checkmark
            u129.ScaleType = Enum.ScaleType.Fit
            u129.ZIndex = 2
            u129.Parent = u123

            u123.MouseEnter:Connect(function()
                if u109 ~= u117 then
                    u123.BackgroundTransparency = 0.92
                end
            end)

            u123.MouseLeave:Connect(function()
                u123.BackgroundTransparency = 1
            end)

            u123.Activated:Connect(function()
                if u109 == u117 then
                    u113(false)

                    return
                end

                u109 = u117
                u112(u117)
                u113(false)

                task.spawn(u27.OnSelect, u117)
                u116(u117)
            end)

            u111[u117] = { Row = u123, Label = u127, Check = u129 }
        end

        table.insert(
            _G.UU.Connections,
            u3.InputBegan:Connect(function(u117)
                if not u110 then
                    return
                end

                if
                    u117.UserInputType ~= Enum.UserInputType.MouseButton1
                    and u117.UserInputType ~= Enum.UserInputType.Touch
                then
                    return
                end

                local u118 = u117.Position
                local u119 = u30.AbsolutePosition
                local u120 = u30.AbsoluteSize
                local u121 = u104.AbsolutePosition
                local u122 = u104.AbsoluteSize
                local u123 = u118.X >= u119.X
                    and u118.X <= u119.X + u120.X
                    and u118.Y >= u119.Y
                    and u118.Y <= u119.Y + u120.Y
                local u126 = u118.X >= u121.X
                    and u118.X <= u121.X + u122.X
                    and u118.Y >= u121.Y
                    and u118.Y <= u121.Y + u122.Y

                if not u123 and not u126 then
                    u113(false)
                end
            end)
        )

        u30.Activated:Connect(function()
            u113(not u110)
        end)

        u112(u109)
        u116(u109)

        return {
            Refresh = function()
                u116(u109)
            end,
        }
    end

    u13.Settings.Theme = u16({
        Parent = u15.Structures.RightAccessories,
        Options = { { Text = "Light" }, { Text = "Dark" } },
        Index = u19.ThemeMode == "Dark" and 2 or 1,
        OnSelect = function(u27)
            if not u76 then
                return
            end

            local u28 = u27 == 2 and "Dark" or "Light"

            if u28 == u19.ThemeMode then
                return
            end

            u19.ThemeMode = u28
            u66.Theme = u28 == "Dark" and u64.Themes.Dark or u64.Themes.Light
            u91.Theme = u66.Theme

            u50("Theme → " .. u28)
            u38()

            if u13.Settings.Accent and u13.Settings.Accent.Refresh then
                u13.Settings.Accent.Refresh()
            end
        end,
    })

    local u27 = u72(u14, "Accent Color", "Highlight color used by switches, buttons and selections")
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
            if not u76 then
                return
            end

            local u34 = u28[u33]

            if not u34 then
                return
            end

            u19.AccentName = u34
            u66.Accent = u64.Accents[u34]
            u91.Accent = u66.Accent

            u50("Accent → " .. u34)
            u38()

            if u13.Settings.Theme and u13.Settings.Theme.Refresh then
                u13.Settings.Theme.Refresh()
            end
        end,
    })

    local u105 = u90:PageSection({ Title = "Interface" }):Form()

    local u106 = u72(u105, "Toggle Keybind", "Show or hide the window")

    u106:Right():KeybindField({
        Value = u19.Keybind,
        ValueChanged = function(u107, u108)
            if not u76 then
                return
            end

            u19.Keybind = u108
            u50("Keybind → " .. u108.Name)
            u38()
        end,
        BindPressed = function(u107, u108, u109, u110)
            if not u109 or u110 then
                return
            end

            u67.Minimized = not u67.Minimized
        end,
    })

    local u111 = u72(u105, "Auto Hide UI", "Starts minimized on the next injection")

    u111:Right():Toggle({
        Value = u19.AutoHideEnabled,
        ValueChanged = function(u107, u108)
            if not u76 then
                return
            end

            u19.AutoHideEnabled = u108
            u50("Auto Hide UI → " .. (u108 and "Enabled" or "Disabled"))
            u38()
        end,
    })

    local u112 = u90:Form()

    u72(u112, "Activity", "Tracks every action with a timestamp, newest first"):Right():Button({
        Label = "Clear",
        State = "Destructive",
        Pushed = function()
            _G.UU.LogBuffer = {}

            for u116 = 1, 6 do
                local u117 = u13.Settings.Activity[u116]

                if u117 then
                    u117.Text = u21(u20.Grey, "—")
                end
            end
        end,
    })

    for u113 = 1, 6 do
        u13.Settings.Activity[u113] = u112:Row():Left():Label({
            Text = _G.UU.LogBuffer[u113] or u21(u20.Grey, "—"),
        })
    end

    local u116 = u90:PageSection({
        Title = "Danger Zone",
        Subtitle = "Fully removes Universal Utility and stops everything it runs",
    }):Form()

    local u117 = u72(u116, "Uninject", "Press twice to confirm the removal"):Right():Button({
        Label = "Uninject",
        State = "Destructive",
        Pushed = function(u118)
            if not u82 then
                u82 = true
                u118.Label = "Click again to confirm"

                task.delay(3, function()
                    u82 = false

                    if u118.Parent then
                        u118.Label = "Uninject"
                    end
                end)

                return
            end

            u82 = false
            u118.Label = "Uninjecting..."
            u37()

            task.delay(0.15, function()
                if not u18() then
                    return
                end
                if u83 then
                    pcall(task.cancel, u83)
                end
                u52("Click")
                u52("Spam")
                for u119, u120 in pairs(_G.UU.Threads) do
                    if typeof(u120) == "thread" and coroutine.status(u120) ~= "dead" then
                        pcall(task.cancel, u120)
                    end

                    _G.UU.Threads[u119] = nil
                end

                for u119, u120 in pairs(_G.UU.Connections) do
                    pcall(function()
                        u120:Disconnect()
                    end)
                end

                _G.UU.Connections = {}

                if u62 then
                    pcall(setfpscap, 60)
                end

                pcall(function()
                    if typeof(dequeue_on_teleport) == "function" then
                        dequeue_on_teleport()
                    end
                end)

                pcall(u37)

                u91:Destroy()
                u66:Destroy()

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

u76 = true

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
        u79 = u79 + 1
        local u14 = tick()

        if u14 - u80 >= 1 then
            local u15 = math.floor(u79 / (u14 - u80))
            u79 = 0
            u80 = u14

            if #u77 >= 60 then
                table.remove(u77, 1)
            end
            table.insert(u77, u15)

            local u16, u27, u28 = math.huge, 0, 0

            for u29, u30 in ipairs(u77) do
                u16 = math.min(u16, u30)
                u27 = math.max(u27, u30)
                u28 = u28 + u30
            end

            local u31 = math.floor(u28 / #u77)
            local u32 = _G.UU.UI
            local u33 = u8:GetTotalMemoryUsageMb()
            u81 = math.max(u81, u33)

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
                    u32.Perf.MemPeak.Text = u21(u20.Pink, string.format("%.1f MB", u81))
                end
            end
        end

        if tick() - (_G.UU.LastPingTime or 0) >= 2 then
            _G.UU.LastPingTime = tick()

            local u14 = math.floor(u9:GetNetworkPing() * 1000)
            if #u78 >= 60 then
                table.remove(u78, 1)
            end
            table.insert(u78, u14)

            local u15, u16, u27 = math.huge, 0, 0

            for u28, u29 in ipairs(u78) do
                u15 = math.min(u15, u29)
                u16 = math.max(u16, u29)
                u27 = u27 + u29
            end

            local u30 = math.floor(u27 / #u78)
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

if u19.FPSUnlockEnabled and u62 then
    u63()
else
    if u62 then
        pcall(setfpscap, 60)
    end

    if u19.FPSUnlockEnabled and not u62 then
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

u66.Destroying:Connect(function()
    if not u18() then
        return
    end
    pcall(u37)
    _G.UU.Loaded = false
    _G.UU.LoadLock = false
    if u83 then
        pcall(task.cancel, u83)
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
    if u62 then
        pcall(setfpscap, 60)
    end
    pcall(function()
        u91:Destroy()
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

        local u15, u16 = u61(u19.SavedCode)

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
