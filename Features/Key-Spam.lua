local VirtualInputManager = game:GetService("VirtualInputManager")

local Config = _G.UniversalUtility.Config
local ActiveThreads = _G.UniversalUtility.ActiveThreads
local KeyCodeMap = _G.UniversalUtility.KeyCodeMap

local KeySpam = {}
_G.UniversalUtility.KeySpam = KeySpam

local function StopThread(threadType)
    if ActiveThreads[threadType] then
        local thread = ActiveThreads[threadType]
        ActiveThreads[threadType] = nil
        if coroutine.status(thread) ~= "dead" then
            task.cancel(thread)
        end
    end
end

function KeySpam.StopSpamThread()
    StopThread("Spam")
end

function KeySpam.StartSpamThread()
    KeySpam.StopSpamThread()
    local keyText = Config.SpamKey:upper()
    local keyCode = KeyCodeMap[keyText]
    if not keyCode then return end
    
    ActiveThreads.Spam = task.spawn(function()
        while Config.AutoSpamEnabled do
            task.wait(Config.SpamDelay)
            if Config.AutoSpamEnabled then
                VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
            end
        end
        ActiveThreads.Spam = nil
    end)
end

return KeySpam
