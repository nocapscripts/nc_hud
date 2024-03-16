if Config.FrameWork == "ESX" then
    
    RS.Framework.RegisterCommand("hud", "user", function(xPlayer, args, showError)
        xPlayer.triggerEvent("rs_hud:Client:OpenHudSettings")
    end, true, {
        help = _t("hud.commands.hudsettings.help"),
        validate = true,
    })
    
    RS.Framework.RegisterCommand("hudclose", "user", function(xPlayer, args, showError)
        local code = tonumber(args.code)
        local element = Utils.Functions:HUD_CodeToElement(code)
        xPlayer.triggerEvent("rs_hud:Client:HiddenHudElement", element, code)
    end, true, {
        help = _t("hud.commands.hodclose.help"),
        validate = true,
        arguments = {
            { name = "code", help = _t("hud.commands.hudclose.code.arguments.code.help"), type = "number" }
        }
    })
    
    RS.Framework.RegisterCommand("hudopen", "user", function(xPlayer, args, showError)
        local code = tonumber(args.code)
        local element = Utils.Functions:HUD_CodeToElement(code)
        xPlayer.triggerEvent("rs_hud:Client:ShowHudElement", element, code)
    end, true, {
        help = _t("hud.commands.hodclose.help"),
        validate = true,
        arguments = {
            { name = "code", help = _t("hud.commands.hudclose.code.arguments.code.help"), type = "number" }
        }
    })
    
elseif Config.FrameWork == "QB" then
    
    RS.Framework.Commands.Add("hud", _t("hud.commands.hudsettings.help"), {}, false, function(source, args)
        local src = source
        TriggerClientEvent("rs_hud:Client:OpenHudSettings", src)
    end)
    
    RS.Framework.Commands.Add("hudclose", _t("hud.commands.hudsettings.help"), {
        {
            name = "code",
            help = _t("hud.commands.hudclose.arguments.code.help"),
        }
    }, false, function(source, args)
        local src = source
        local code = tonumber(args[1])
        local element = Utils.Functions:HUD_CodeToElement(code)
        TriggerClientEvent("rs_hud:Client:HiddenHudElement", src, element, code)
    end)
    
    RS.Framework.Commands.Add("hudopen", _t("hud.commands.hudsettings.help"), {
        {
            name = "code",
            help = _t("hud.commands.hudopen.arguments.code.help"),
        }
    }, false, function(source, args)
        local src = source
        local code = tonumber(args[1])
        local element = Utils.Functions:HUD_CodeToElement(code)
        TriggerClientEvent("rs_hud:Client:ShowHudElement", src, element, code)
    end)
end
