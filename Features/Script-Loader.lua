local Config = _G.UniversalUtility.Config

_G.UniversalUtility.ScriptLoader = {}

function _G.UniversalUtility.ScriptLoader.Execute(code)
    if code == "" or code == nil then
        return false, "Empty script"
    end
    
    local success, errorMessage = pcall(function()
        local func, err = loadstring(code)
        if not func then
            error(err)
        end
        func()
    end)
    
    if success then
        return true, "Executed successfully!"
    else
        return false, "Error - " .. tostring(errorMessage):sub(1, 50) .. "..."
    end
end

function _G.UniversalUtility.ScriptLoader.SaveCode(code)
    Config.SavedCode = code
    _G.UniversalUtility.SaveConfig()
end

function _G.UniversalUtility.ScriptLoader.SetAutoLoad(enabled)
    Config.AutoLoadEnabled = enabled
    _G.UniversalUtility.SaveConfig()
    
    if enabled then
        local autoLoadCode = Config.SavedCode
        if autoLoadCode and autoLoadCode ~= "" then
            return true, "Auto-load enabled"
        else
            return false, "No code to auto-load"
        end
    end
    
    return true, "Auto-load disabled"
end

function _G.UniversalUtility.ScriptLoader.GetAutoLoadCode()
    if Config.AutoLoadEnabled and Config.SavedCode and Config.SavedCode ~= "" then
        return Config.SavedCode
    end
    return nil
end

return _G.UniversalUtility.ScriptLoader
