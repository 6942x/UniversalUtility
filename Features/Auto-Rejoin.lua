local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Config = _G.UniversalUtility.Config

local AutoRejoin = {}
_G.UniversalUtility.AutoRejoin = AutoRejoin

AutoRejoin.Teleporting = false

function AutoRejoin.Setup()
    if Config.AutoRejoinEnabled then
        local PromptGui = CoreGui:WaitForChild("RobloxPromptGui")
        local PromptOverlay = PromptGui:WaitForChild("promptOverlay")
        PromptOverlay.ChildAdded:Connect(function(child)
            if child.Name == "ErrorPrompt" and Config.AutoRejoinEnabled and not AutoRejoin.Teleporting then
                AutoRejoin.Teleporting = true
                task.spawn(function()
                    while Config.AutoRejoinEnabled and AutoRejoin.Teleporting do
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                        task.wait(2)
                    end
                end)
            end
        end)
    end
end

function AutoRejoin.Stop()
    AutoRejoin.Teleporting = false
end

return AutoRejoin
