local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1455709133373440140/tA9TlaElO60FrdmhPIWSC1mFCSRpvH-80dt0kIVJDRwXaTkIqP4m1OKP8jmqlJcNbs7A"
local LocalPlayer = Players.LocalPlayer

local function getExecutor()
    return (identifyexecutor and identifyexecutor()) or 
           (getexecutorname and getexecutorname()) or 
           "Unknown Executor"
end

local function getGameInfo()
    local success, gameInfo = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    
    return {
        Name = (success and gameInfo and gameInfo.Name) or "Unknown Game",
        Id = game.PlaceId
    }
end

local function formatConfig()
    local Config = _G.UniversalUtility and _G.UniversalUtility.Config
    if not Config then return "```Config not loaded```" end
    
    return string.format(
        "```yaml\nAnti-AFK:\n  Jump: %s (%.1fs)\n  Click: %s (%.1fs)\n  Click Type: %s\n\n" ..
        "Key Spam:\n  Status: %s\n  Key: %s\n  Delay: %.2fs\n\n" ..
        "Performance:\n  FPS Unlock: %s\n  Target: %d FPS\n\n" ..
        "Features:\n  Auto Rejoin: %s\n  Auto Load: %s\n```",
        Config.JumpEnabled and "ON" or "OFF", Config.JumpDelay or 10,
        Config.ClickEnabled and "ON" or "OFF", Config.ClickDelay or 3,
        Config.ClickType or "Current",
        Config.AutoSpamEnabled and "ON" or "OFF",
        Config.SpamKey or "E",
        Config.SpamDelay or 0.1,
        Config.FPSUnlockEnabled and "ON" or "OFF",
        Config.TargetFPS or 60,
        Config.AutoRejoinEnabled and "ON" or "OFF",
        Config.AutoLoadEnabled and "ON" or "OFF"
    )
end

local function sendWebhook()
    local gameInfo = getGameInfo()
    local executor = getExecutor()
    
    local embed = {
        title = "🎮 Universal Utility Execution",
        color = 5814783,
        fields = {
            {
                name = "👤 Player",
                value = string.format("**%s** (@%s)\n`User ID: %d`\n[Profile](https://www.roblox.com/users/%d/profile)",
                    LocalPlayer.Name, LocalPlayer.DisplayName, LocalPlayer.UserId, LocalPlayer.UserId),
                inline = false
            },
            {
                name = "🎯 Game",
                value = string.format("**%s**\n`Place ID: %d`\n`Job ID: %s`",
                    gameInfo.Name, gameInfo.Id, game.JobId),
                inline = false
            },
            {
                name = "⚙️ Executor",
                value = "```" .. executor .. "```",
                inline = true
            },
            {
                name = "👥 Players",
                value = "```" .. #Players:GetPlayers() .. " player(s)```",
                inline = true
            },
            {
                name = "⚙️ Configuration",
                value = formatConfig(),
                inline = false
            }
        },
        footer = {
            text = "Universal Utility v1.0"
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
    }
    
    local payload = {
        username = "Universal Utility Logger",
        embeds = {embed}
    }
    
    local success = pcall(function()
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)
    
    if success then
        print("✓ Webhook sent successfully")
    else
        warn("✗ Failed to send webhook")
    end
end

task.spawn(function()
    task.wait(2)
    sendWebhook()
end)

return true
