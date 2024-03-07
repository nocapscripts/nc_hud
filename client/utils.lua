function Utils.Functions:CustomFuelExport()
    --[[
       Add custom fuel export event here
    --]]
    TriggerServerEvent("rs_hud:Server:ErrorHandle", _t("hud.export.fuel_missing"))
    return false
end

function Utils.Functions:CustomVoiceResource()
    -- Add your custom voice resource here.
    --[[
        AddEventHandler("customVoice:setVoiceRange", function(mode)
            RS.Client.HUD.data.bars.voice.range = mode
        end)

        AddEventHandler("customVoice:setRadioTalking", function(radioTalking)
            RS.Client.HUD.data.bars.voice.radio = radioTalking
        end)
    --]]
end

local function SetVehicleCruiseControlState(state)
    RS.Client.HUD.data.vehicle.cruiseControlStatus = state
end
local function SetVehicleSeatbeltState(state)
    RS.Client.HUD.data.vehicle.isSeatbeltOn = state
end

function Utils.Functions:GetPedVehicleSeat(ped, vehicle)
    for i = -1, 16 do
        if (GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -1
end

exports("CruiseControlState", function(...)
    SetVehicleCruiseControlState(...)
end)
exports("SeatbeltState", function(...)
    SetVehicleSeatbeltState(...)
end)
