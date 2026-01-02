local UI = _G.UniversalUtility.UI
local Helpers = _G.UniversalUtility.Helpers

_G.UniversalUtility.TabHandler = {}

local REPO_URL = "https://raw.githubusercontent.com/PeuEU/Uu/main/"

local TAB_CONFIGS = {
    {name = "Home", icon = "🏠", order = 1, path = "Ui/Tabs/Home_Tab.lua"},
    {name = "Anti-AFK", icon = "⚡", order = 2, path = "Ui/Tabs/Anti-AFK_Tab.lua"},
    {name = "KeySpam", icon = "⌨️", order = 3, path = "Ui/Tabs/Key-Spam_Tab.lua"},
    {name = "Performance Status", icon = "📊", order = 4, path = "Ui/Tabs/Performance_Tab.lua"},
    {name = "Auto Rejoin", icon = "🔄", order = 5, path = "Ui/Tabs/Rejoin_Tab.lua"},
    {name = "Script Loader", icon = "💾", order = 6, path = "Ui/Tabs/Script-Loader_Tab.lua"},
    {name = "Settings", icon = "⚙️", order = 7, path = "Ui/Tabs/Settings_Tab.lua"}
}

function _G.UniversalUtility.TabHandler.Initialize()
    for _, tab in ipairs(TAB_CONFIGS) do
        Helpers.CreateTabButton(tab.name, tab.icon, UDim2.new(0, 5, 0, 5 + ((tab.order - 1) * 60)))
        Helpers.CreateTabContent(tab.name)
    end
end

function _G.UniversalUtility.TabHandler.LoadTabModules()
    local loadedTabs = {}
    
    for _, tab in ipairs(TAB_CONFIGS) do
        local success, result = pcall(function()
            local url = REPO_URL .. tab.path
            local source = game:HttpGet(url, true)
            local chunk, err = loadstring(source)
            if not chunk then
                error("Compile error: " .. tostring(err))
            end
            local moduleFunc = chunk()
            if type(moduleFunc) == "function" then
                return moduleFunc()
            else
                return moduleFunc
            end
        end)
        
        if success then
            loadedTabs[tab.name] = result
            print("✓ " .. tab.name .. " Tab")
        else
            warn("✗ " .. tab.name .. " Tab → " .. tostring(result))
            return false, tab.name
        end
    end
    
    return true, loadedTabs
end

return _G.UniversalUtility.TabHandler
