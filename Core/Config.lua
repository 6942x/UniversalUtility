local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if _G.UniversalUtility and _G.UniversalUtility.ActiveThreads then
    for threadType, thread in pairs(_G.UniversalUtility.ActiveThreads) do
        if thread and typeof(thread) == "thread" then
            pcall(function()
                task.cancel(thread)
            end)
        end
    end
    _G.UniversalUtility.ActiveThreads = {}
end

_G.UniversalUtility = _G.UniversalUtility or {}
_G.UniversalUtility.ActiveThreads = {}
_G.UniversalUtility.Config = {
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
    UIPosition = {X = 0.5, Y = 0.5},
    ReopenPosition = {X = 0.5, Y = 30}
}

local Config = _G.UniversalUtility.Config

local function GetConfigFileName()
    return "UniversalUtilityConfig-" .. LocalPlayer.UserId .. ".json"
end

function _G.UniversalUtility.SaveConfig()
    if writefile then
        local mainFrame = _G.UniversalUtility.UI and _G.UniversalUtility.UI.MainFrame
        local reopenButton = _G.UniversalUtility.UI and _G.UniversalUtility.UI.ReopenButton
        
        if mainFrame then
            Config.UIPosition = {
                X = mainFrame.Position.X.Scale + (mainFrame.Position.X.Offset / mainFrame.Parent.AbsoluteSize.X),
                Y = mainFrame.Position.Y.Scale + (mainFrame.Position.Y.Offset / mainFrame.Parent.AbsoluteSize.Y)
            }
        end
        
        if reopenButton then
            Config.ReopenPosition = {
                X = reopenButton.Position.X.Scale + (reopenButton.Position.X.Offset / reopenButton.Parent.AbsoluteSize.X),
                Y = reopenButton.Position.Y.Offset
            }
        end
        
        local configData = HttpService:JSONEncode({
            UserId = LocalPlayer.UserId,
            Username = LocalPlayer.Name,
            Keybind = Config.Keybind.Name,
            ClickType = Config.ClickType,
            JumpEnabled = Config.JumpEnabled,
            ClickEnabled = Config.ClickEnabled,
            AutoRejoinEnabled = Config.AutoRejoinEnabled,
            FPSUnlockEnabled = Config.FPSUnlockEnabled,
            AutoSpamEnabled = Config.AutoSpamEnabled,
            AutoLoadEnabled = Config.AutoLoadEnabled,
            TargetFPS = Config.TargetFPS,
            JumpDelay = Config.JumpDelay,
            ClickDelay = Config.ClickDelay,
            SpamDelay = Config.SpamDelay,
            SpamKey = Config.SpamKey,
            SavedCode = Config.SavedCode,
            CurrentTab = Config.CurrentTab,
            UIPosition = Config.UIPosition,
            ReopenPosition = Config.ReopenPosition
        })
        writefile(GetConfigFileName(), configData)
    end
end

function _G.UniversalUtility.LoadConfig()
    if readfile and isfile and isfile(GetConfigFileName()) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(GetConfigFileName()))
        end)
        if success and data then
            if data.UserId == LocalPlayer.UserId then
                Config.Keybind = Enum.KeyCode[data.Keybind] or Enum.KeyCode.G
                Config.ClickType = data.ClickType or "Current"
                Config.JumpEnabled = data.JumpEnabled or false
                Config.ClickEnabled = data.ClickEnabled or false
                Config.AutoRejoinEnabled = data.AutoRejoinEnabled or false
                Config.FPSUnlockEnabled = data.FPSUnlockEnabled or false
                Config.AutoSpamEnabled = data.AutoSpamEnabled or false
                Config.AutoLoadEnabled = data.AutoLoadEnabled or false
                Config.TargetFPS = data.TargetFPS or 60
                Config.JumpDelay = data.JumpDelay or 10.0
                Config.ClickDelay = data.ClickDelay or 3.0
                Config.SpamDelay = data.SpamDelay or 0.1
                Config.SpamKey = data.SpamKey or "Q"
                Config.SavedCode = data.SavedCode or ""
                Config.CurrentTab = data.CurrentTab or "Home"
                Config.UIPosition = data.UIPosition or {X = 0.5, Y = 0.5}
                Config.ReopenPosition = data.ReopenPosition or {X = 0.5, Y = 30}
                return true
            else
                warn("Config file belongs to different user (ID: " .. tostring(data.UserId) .. ")")
                return false
            end
        end
    end
    return false
end

return _G.UniversalUtility.Config
