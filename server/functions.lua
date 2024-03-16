
RS.Server.ExecuteSQLQuery = function(query, params, type)
    if type == "insert" then
        return MySQL.insert.await(query, params)
    elseif type == "update" then
        return MySQL.update.await(query, params)
    elseif type == "query" then
        return MySQL.query.await(query, params)
    elseif type == "scalar" then
        return MySQL.scalar.await(query, params)
    elseif type == "single" then
        return MySQL.single.await(query, params)
    elseif type == "prepare" then
        return MySQL.prepare.await(query, params)
    else
        error("Invalid queryType: " .. tostring(type or "?"))
    end
end


RS.Server.SendNotify = function(source, type, title, text, duration, icon)
    system = Config.NotifyType
    if not duration then duration = 1000 end
    if system == "QB" then
        if Config.FrameWork == "QB" then
            TriggerClientEvent("NPX:Notify", source, title, type)
        else
            Utils.Functions:debugPrint("error", "QB not found.")
        end
    elseif system == "ESX" then
        if Config.FrameWork == "ESX" then
            TriggerClientEvent("esx:showNotification", source, title, type, duration)
        else
            Utils.Functions:debugPrint("error", "ESX not found.")
        end
    elseif system == "custom" then
        Utils.Functions:CustomNotify(source, title, type, text, duration, icon)
    else
        Utils.Functions:debugPrint("error", "An error occurred.")
    end
end


RS.Server.GetPlayerBySource = function(source)
    if Config.FrameWork == "ESX" then
        return RS.Framework.GetPlayerFromId(source)
    elseif Config.FrameWork == "QB" then
        return RS.Framework.Functions.GetPlayer(source)
    end
end
