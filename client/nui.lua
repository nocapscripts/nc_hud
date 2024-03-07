RegisterNUICallback("OnHideSettingsMenu", function(_, cb)
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNUICallback("loadLocaleFile", function(_, cb)
    Wait(1)
    RS.Client:SendReactMessage("setLocale", locales.ui)
    cb(true)
end)

RegisterNUICallback("OnSettingsSaved", function(data, cb)
    if data then
        RS.Client:SendNotify(_t("hud.settings.saved"))
        local newVH = data.newVH
        RS.Client.HUD:UpdateVehicleHud(newVH)
    else
        RS.Client:SendNotify(_t("hud.settings.not_saved"))
    end
    cb(true)
end)

RegisterNUICallback("openBigMap", function(_, cb)
    SetNuiFocus(false, false)
    ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), 0, -1)
    cb(true)
end)

RegisterNUICallback("openPauseMenu", function(_, cb)
    SetNuiFocus(false, false)
    ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_LANDING_MENU"), 0, -1)
    cb(true)
end)