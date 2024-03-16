Utils = {}
Utils.Functions = {}

function Utils.Functions:printTable(table, indent)
    indent = indent or 0
    if type(table) == "table" then
        for k, v in pairs(table) do
            local tblType = type(v)
            local formatting = ("%s ^3%s:^0"):format(string.rep("  ", indent), k)
            if tblType == "table" then
                print(formatting)
                Utils.Functions:printTable(v, indent + 1)
            elseif tblType == "boolean" then
                print(("%s^1 %s ^0"):format(formatting, v))
            elseif tblType == "function" then
                print(("%s^9 %s ^0"):format(formatting, v))
            elseif tblType == "number" then
                print(("%s^5 %s ^0"):format(formatting, v))
            elseif tblType == "string" then
                print(("%s ^2%s ^0"):format(formatting, v))
            else
                print(("%s^2 %s ^0"):format(formatting, v))
            end
        end
    else
        print(("%s ^0%s"):format(string.rep("  ", indent), table))
    end
end


function Utils.Functions:debugPrint(tbl, indent)
    if not Config.DebugPrint then return end
    print(("\x1b[ %s : DEBUG]\x1b"):format(GetInvokingResource() or "rs_hud"))
    Utils.Functions:printTable(tbl, indent)
    print("\x1b[ END DEBUG ]\x1b")
end


function Utils.Functions:hasResource(name)
    return GetResourceState(name):find("start") ~= nil
end


function Utils.Functions:GetFramework()
    if Config.FrameWork == "QB" then
        if not Utils.Functions:hasResource(Config.FrameworkName) then
            Utils.Functions:debugPrint("NPX Framework not working or not installed!")
            return false
        end
        return exports[Config.FrameworkName]:GetCoreObject()
    elseif Config.FrameWork == "ESX" then
        if not Utils.Functions:hasResource(Config.FrameworkName) then
            Utils.Functions:debugPrint("ES_CORE Framework not working or not installed!")
            return false
        end
        return exports[Config.FrameworkName]:getSharedObject()
    end
end


function Utils.Functions:CustomNotify(source, title, type, text, duration, icon)
    -- 1.Server notify 
    -- 2.Client notify
    if source and source > 0 then 
        -- TriggerClientEvent("EventName", source, ?, ?, ?, ?)
    else                          
        -- exports["ExportName"]:Alert(?, ?, ?, ?)
    end
end

function Utils.Functions:HUD_CodeToElement(code)
    if code == 1 then
        return "voice"
    elseif code == 2 then
        return "health"
    elseif code == 3 then
        return "armor"
    elseif code == 4 then
        return "hunger"
    elseif code == 5 then
        return "thirst"
    elseif code == 6 then
        return "oxygen"
    elseif code == 7 then
        return "stamina"
    elseif code == 8 then
        return "stress"
    elseif code == 9 then
        return "terminal"
    elseif code == 10 then
        return "leaf"
    elseif code == 11 then
        return "vehicle"
    end
    return "voice"
end
