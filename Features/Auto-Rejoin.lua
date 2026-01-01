local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Config = _G.UniversalUtility.Config

_G.UniversalUtility.AutoRejoin = {}
_G.UniversalUtility.AutoRejoin.Teleporting = false

function _G.UniversalUtility.AutoRejoin.Setup()
    if Config.AutoRejoinEnabled then
        local PromptGui = CoreGui:WaitForChild("RobloxPromptGui")
        local PromptOverlay = PromptGui:WaitForChild("promptOverlay")
        PromptOverlay.ChildAdded:Connect(function(child)
            if child.Name == "ErrorPrompt" and Config.AutoRejoinEnabled and not _G.UniversalUtility.AutoRejoin.Teleporting then
                _G.UniversalUtility.AutoRejoin.Teleporting = true
                task.spawn(function()
                    while Config.AutoRejoinEnabled and _G.UniversalUtility.AutoRejoin.Teleporting do
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                        task.wait(2)
                    end
                end)
            end
        end)
    end
end

function _G.UniversalUtility.AutoRejoin.Stop()
    _G.UniversalUtility.AutoRejoin.Teleporting = false
end

return _G.UniversalUtility.AutoRejoin
