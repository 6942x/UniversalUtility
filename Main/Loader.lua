_G.UniversalUtility = _G.UniversalUtility or {}

if _G.UniversalUtility.Loaded then
    warn("⚠ Universal Utility is already loaded and running")
    return _G.UniversalUtility
end

if _G.UniversalUtility.LoadLock then
    warn("⚠ Universal Utility is currently loading. Please wait...")
    repeat task.wait() until not _G.UniversalUtility.LoadLock
    return _G.UniversalUtility
end

_G.UniversalUtility.LoadLock = true

local REPO_URL = "https://raw.githubusercontent.com/6942x/UniversalUtility/main/"
local LOADER_SCRIPT = REPO_URL .. "Main/Loader.lua"

local FEATURES = {
    { name = "Configuration",     path = "Core/Config.lua",            critical = true },
    { name = "Helper Functions",  path = "Utils/Helpers.lua",          critical = true },

    { name = "UI Framework",      path = "Ui/Framework.lua",           critical = true },
    { name = "UI Interactions",   path = "Ui/Interactions.lua",        critical = true },
    { name = "Tab Handler",       path = "Ui/TabHandler.lua",          critical = true },

    { name = "Anti-AFK",          path = "Features/Anti-AFK.lua",      critical = true },
    { name = "Auto Rejoin",       path = "Features/Auto-Rejoin.lua",   critical = true },
    { name = "Key Spam",          path = "Features/Key-Spam.lua",      critical = true },
    { name = "Performance Boost", path = "Features/Performance.lua",   critical = true },
    { name = "Script Loader",     path = "Features/Script-Loader.lua", critical = true },

    { name = "Event Handlers",    path = "Init/Handlers.lua",          critical = true },
    { name = "Startup",           path = "Init/Startup.lua",           critical = true },

    { name = "Webhook Logger",    path = "Main/Webhook.lua",           critical = false },
}

local loadedModules = {}
local failedModules = {}

local function loadFeature(feature)
    local success, result = pcall(function()
        local url = REPO_URL .. feature.path
        local source = game:HttpGet(url, true)

        local chunk, err = loadstring(source)
        if not chunk then
            error("Compile error: " .. tostring(err))
        end

        return chunk()
    end)

    if success then
        loadedModules[feature.name] = true
        print("✓ " .. feature.name)
        return true
    else
        failedModules[feature.name] = tostring(result)
        warn("✗ " .. feature.name .. " → " .. tostring(result))
        return false
    end
end

local function setupQueueOnTeleport()
    if not queue_on_teleport then
        return false
    end

    local success = pcall(function()
        queue_on_teleport(
            ('loadstring(game:HttpGet("%s", true))()'):format(LOADER_SCRIPT)
        )
    end)

    if success then
        _G.UniversalUtility.QueuedTeleport = true
        return true
    end

    return false
end

local function validateInitialization()
    local checks = {
        { _G.UniversalUtility.UI, "UI System" },
        { _G.UniversalUtility.UI and _G.UniversalUtility.UI.ScreenGui, "ScreenGui" },
        { _G.UniversalUtility.UI and _G.UniversalUtility.UI.MainFrame, "MainFrame" },
        { _G.UniversalUtility.Config, "Configuration" },
        { _G.UniversalUtility.TabHandler, "Tab Handler" },
    }

    local valid = true
    for _, check in ipairs(checks) do
        if not check[1] then
            warn("✗ Missing: " .. check[2])
            valid = false
        end
    end

    return valid
end

print("============================================")
print("   Universal Utility - Loading System")
print("============================================")

local startTime = tick()
local loadedCount = 0
local hasErrors = false

for _, feature in ipairs(FEATURES) do
    local success = loadFeature(feature)

    if success then
        loadedCount += 1
    else
        hasErrors = true
        if feature.critical then
            warn("CRITICAL FAILURE: " .. feature.name)
        end
    end
end

local loadTime = math.floor((tick() - startTime) * 1000)
local errorCount = #FEATURES - loadedCount

print("============================================")

if loadedCount == #FEATURES then
    print(("✓ ALL FEATURES LOADED (%d/%d)"):format(loadedCount, #FEATURES))
    print("✓ Load Time: " .. loadTime .. "ms")

    task.wait(0.1)

    if validateInitialization() then
        print("✓ Validation Passed")
        _G.UniversalUtility.Loaded = true
        _G.UniversalUtility.LoadLock = nil

        if setupQueueOnTeleport() then
            print("✓ Teleport Queue Enabled")
        end
    else
        warn("✗ Validation Failed")
        _G.UniversalUtility.LoadLock = nil
    end
else
    warn(("✗ Loading finished with %d/%d errors"):format(errorCount, #FEATURES))
    warn("⚠ Please rejoin and execute again. If this continues, report the error.")

    if next(failedModules) then
        warn("Failed Modules:")
        for name, err in pairs(failedModules) do
            warn("  - " .. name .. ": " .. err)
        end
    end

    _G.UniversalUtility.LoadLock = nil
    _G.UniversalUtility.LoadFailed = true
end

print("============================================")

return _G.UniversalUtility
