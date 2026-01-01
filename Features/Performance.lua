local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Config = _G.UniversalUtility.Config
local FPS_SUPPORTED = typeof(setfpscap) == "function"

_G.UniversalUtility.Performance = {}
_G.UniversalUtility.Performance.FPS_SUPPORTED = FPS_SUPPORTED

local FPSHistory = {}
local PingHistory = {}
local MAX_POINTS = 60
for i = 1, MAX_POINTS do
    table.insert(FPSHistory, 60)
    table.insert(PingHistory, 0)
end

local lastTime, frameCount, currentFPS = tick(), 0, 60
local updateInterval = 1

function _G.UniversalUtility.Performance.UpdateFPSStats(fps, labels)
    table.remove(FPSHistory, 1)
    table.insert(FPSHistory, fps)
    local minFPS, maxFPS, totalFPS = math.huge, 0, 0
    for _, fpsVal in ipairs(FPSHistory) do
        minFPS = math.min(minFPS, fpsVal)
        maxFPS = math.max(maxFPS, fpsVal)
        totalFPS = totalFPS + fpsVal
    end
    local avgFPS = math.floor(totalFPS / #FPSHistory)
    if labels then
        labels.Current.Text = "Current: " .. fps
        labels.Avg.Text = "Average: " .. avgFPS
        labels.MinMax.Text = string.format("Min: %d | Max: %d", minFPS, maxFPS)
    end
end

function _G.UniversalUtility.Performance.UpdatePingStats(ping, labels)
    table.remove(PingHistory, 1)
    table.insert(PingHistory, ping)
    local minPing, maxPing, totalPing = math.huge, 0, 0
    for _, pingVal in ipairs(PingHistory) do
        minPing = math.min(minPing, pingVal)
        maxPing = math.max(maxPing, pingVal)
        totalPing = totalPing + pingVal
    end
    local avgPing = math.floor(totalPing / #PingHistory)
    
    if labels then
        labels.Current.Text = "Current: " .. ping .. "ms"
        labels.Avg.Text = "Average: " .. avgPing .. "ms"
        labels.MinMax.Text = string.format("Min: %dms | Max: %dms", minPing, maxPing)
        
        local qualityText, qualityColor
        if ping < 50 then
            qualityText, qualityColor = "Excellent", Color3.fromRGB(50, 220, 100)
        elseif ping < 100 then
            qualityText, qualityColor = "Good", Color3.fromRGB(100, 200, 255)
        elseif ping < 200 then
            qualityText, qualityColor = "Fair", Color3.fromRGB(255, 200, 100)
        elseif ping < 300 then
            qualityText, qualityColor = "Poor", Color3.fromRGB(255, 150, 50)
        else
            qualityText, qualityColor = "Very Poor", Color3.fromRGB(220, 50, 50)
        end
        labels.Quality.Text = qualityText
        labels.Quality.TextColor3 = qualityColor
    end
end

function _G.UniversalUtility.Performance.StartMonitoring(uiElements)
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= updateInterval then
            currentFPS = math.floor(frameCount / (currentTime - lastTime))
            frameCount = 0
            lastTime = currentTime
            if uiElements and uiElements.FPSLabel then
                uiElements.FPSLabel.Text = "FPS: " .. currentFPS
            end
            if uiElements and uiElements.FPSStats then
                _G.UniversalUtility.Performance.UpdateFPSStats(currentFPS, uiElements.FPSStats)
            end
        end
        
        if frameCount % 30 == 0 then
            local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            if uiElements and uiElements.PingLabel then
                uiElements.PingLabel.Text = "Ping: " .. ping .. " ms"
                if ping < 100 then
                    uiElements.PingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                elseif ping < 200 then
                    uiElements.PingLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                else
                    uiElements.PingLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
            if uiElements and uiElements.PingStats then
                _G.UniversalUtility.Performance.UpdatePingStats(ping, uiElements.PingStats)
            end
        end
    end)
end

function _G.UniversalUtility.Performance.ToggleFPSUnlock()
    if not FPS_SUPPORTED then
        return false, "FPS Unlock not supported"
    end
    
    Config.FPSUnlockEnabled = not Config.FPSUnlockEnabled
    
    if Config.FPSUnlockEnabled then
        setfpscap(Config.TargetFPS)
    else
        setfpscap(60)
    end
    
    _G.UniversalUtility.SaveConfig()
    return true, Config.FPSUnlockEnabled
end

function _G.UniversalUtility.Performance.SetTargetFPS(fps)
    Config.TargetFPS = fps
    if Config.FPSUnlockEnabled and FPS_SUPPORTED then
        setfpscap(Config.TargetFPS)
    end
    _G.UniversalUtility.SaveConfig()
end

return _G.UniversalUtility.Performance
