local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Config = _G.UniversalUtility.Config
local ActiveThreads = _G.UniversalUtility.ActiveThreads

_G.UniversalUtility.AntiAFK = {}

local function StopThread(threadType)
    if ActiveThreads[threadType] then
        local thread = ActiveThreads[threadType]
        ActiveThreads[threadType] = nil
        if coroutine.status(thread) ~= "dead" then
            task.cancel(thread)
        end
    end
end

function _G.UniversalUtility.AntiAFK.StopJumpThread()
    StopThread("Jump")
end

function _G.UniversalUtility.AntiAFK.StopClickThread()
    StopThread("Click")
end

function _G.UniversalUtility.AntiAFK.StartJumpThread()
    _G.UniversalUtility.AntiAFK.StopJumpThread()
    ActiveThreads.Jump = task.spawn(function()
        while Config.JumpEnabled do
            task.wait(Config.JumpDelay)
            if Config.JumpEnabled and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
        ActiveThreads.Jump = nil
    end)
end

function _G.UniversalUtility.AntiAFK.StartClickThread()
    _G.UniversalUtility.AntiAFK.StopClickThread()
    ActiveThreads.Click = task.spawn(function()
        while Config.ClickEnabled do
            task.wait(Config.ClickDelay)
            if Config.ClickEnabled then
                local x, y
                if Config.ClickType == "Current" then
                    local mousePos = UserInputService:GetMouseLocation()
                    x, y = mousePos.X, mousePos.Y
                elseif Config.ClickType == "Center" then
                    local viewport = workspace.CurrentCamera.ViewportSize
                    x, y = viewport.X/2, viewport.Y/2
                else
                    local viewport = workspace.CurrentCamera.ViewportSize
                    x, y = math.random(100, viewport.X - 100), math.random(100, viewport.Y - 100)
                end
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
            end
        end
        ActiveThreads.Click = nil
    end)
end

return _G.UniversalUtility.AntiAFK
