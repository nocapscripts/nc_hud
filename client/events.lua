

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1000)
        RS.Client.HUD:Start()
        DisplayRadar(false)
    end
end)

RegisterNetEvent("rs_hud:Client:HandleCallback", function(key, data)
    if RS.Callbacks[key] then
        RS.Callbacks[key](data)
        RS.Callbacks[key] = nil
    end
end)

RegisterNetEvent("rs_hud:Client:OpenHudSettings", function()
    SetNuiFocus(true, true)
    RS.Client:SendReactMessage("setRouter", "settings")
end)
RegisterNetEvent("rs_hud:Client:HiddenHudElement", function(element, code)
    RS.Client:SendReactMessage("HIDDEN_HUD_ELEMENT", {
        element = element,
        code = code
    })
end)
RegisterNetEvent("rs_hud:Client:ShowHudElement", function(element, code)
    RS.Client:SendReactMessage("SHOW_HUD_ELEMENT", {
        element = element,
        code = code
    })
end)
-- @ --

if GetResourceState(Config.Voice) == "started" then
    AddEventHandler(Config.SetTalkingMode, function(mode)
        RS.Client.HUD.data.bars.voice.range = mode
    end)

    AddEventHandler(Config.RadioActive, function(radioTalking)
        RS.Client.HUD.data.bars.voice.radio = radioTalking
    end)

    AddEventHandler("onResourceStart", function(resourceName)
        if not resourceName == Config.Voice then
            return
        end
        Wait(1000)
        RS.Client.HUD.data.bars.voice.range = LocalPlayer.state.proximity.index
    end)
elseif GetResourceState("saltychat") == "started" then
    AddEventHandler("SaltyChat_VoiceRangeChanged", function(range, index, availableVoiceRanges)
        RS.Client.HUD.data.bars.voice.range = index
    end)
    AddEventHandler("SaltyChat_RadioTrafficStateChanged",
        function(primaryReceive, primaryTransmit, secondaryReceive, secondaryTransmit)
            RS.Client.HUD.data.bars.voice.radio = primaryTransmit or secondaryTransmit
        end
    )
else
    TriggerServerEvent("rs_hud:Server:ErrorHandle", "Setup your custom voice resource at: client/utils.lua")
    RS.Utils:CustomVoiceResource()
end

if Config.FrameWork == "ESX" then
    RegisterNetEvent("esx:playerLoaded", function(xPlayer)
        Wait(1000)
        RS.Client.HUD:Start(xPlayer)
    end)

    RegisterNetEvent("esx:pauseMenuActive", function(state)
        if RS.Client.HUD.isHidden then
            return
        end
        RS.Client.HUD:Toggle(not state)
    end)

    RegisterNetEvent("esx_status:onTick", function(data)
        local hunger, thirst, stress
        for i = 1, #data do
            if data[i].name == "thirst" then
                thirst = math.floor(data[i].percent)
            end
            if data[i].name == "hunger" then
                hunger = math.floor(data[i].percent)
            end
            if data[i].name == "stress" then
                stress = math.floor(data[i].percent)
            end
        end
        local ped = PlayerPedId()
        local health = math.floor((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100) * 100)
        if health > 100 then
            health = 100
        end
        if health < 0 then
            health = 0
        end
        RS.Client.HUD.data.bars.health = health
        RS.Client.HUD.data.bars.armor = GetPedArmour(ped)
        RS.Client.HUD.data.bars.hunger = hunger
        RS.Client.HUD.data.bars.thirst = thirst
        RS.Client.HUD.data.bars.stress = stress
    end)
end
if Config.FrameWork == "QB" then
    RegisterNetEvent(Config.PlayerLoaded, function()
        Wait(1000)
        RS.Client:SendReactMessage("LOAD_HUD_STORAGE")
        RS.Client.HUD:Start(xPlayer)
    end)

    RegisterNetEvent(Config.PlayerUnload, function()
        Wait(1000)
        RS.Client.HUD:Toggle(false)
    end)

    RegisterNetEvent("hud:client:UpdateNeeds", function(newHunger, newThirst)
        RS.Client.HUD.data.bars.hunger = newHunger
        RS.Client.HUD.data.bars.thirst = newThirst
    end)

    RegisterNetEvent("hud:client:UpdateStress", function(newStress)
        RS.Client.HUD.data.bars.stress = newStress
    end)
    
    
end


RegisterNetEvent("seatbelt:client:ToggleSeatbelt", function(belt)
 
    RS.Client.HUD.data.vehicle.isSeatbeltOn = belt

end)


RegisterNetEvent("seatbelt:client:ToggleCruise", function()
    RS.Client.HUD.data.vehicle.cruiseControlStatus = not RS.Client.HUD.data.vehicle.cruiseControlStatus
end)


local function toggleSeatbelt()
    SeatBeltLoop()
    
    
end

-- NB! Here you can add your own progressbar export with seatbelt event!
function SeatbeltOn()
    exports['rs_taskbar']:Progress({
        name = "random_task",
        duration = 2000,
        label = "Paned vöö peale . . .",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = nil,
            anim = nil,
            flags = nil,
        },
        prop = {},
        propTwo = {}
     }, function(cancelled)
        if not cancelled then
            RS.Client.HUD.data.vehicle.isSeatbeltOn = true
            TriggerEvent("seatbelt:client:ToggleSeatbelt",true)
            TriggerEvent("InteractSound_CL:PlayOnOne","carbuckle", 0.25)
            TriggerEvent(Config.NotifyName,'Vöö peal!', 'info')
            toggleSeatbelt()
        else
            TriggerEvent(Config.NotifyName,'Loobusid', 'error')
        end
    end)
    

end

-- NB! Here you can add your own progressbar export with seatbelt event!
function SeatbeltOff()
    exports['rs_taskbar']:Progress({
        name = "random_task",
        duration = 1500,
        label = "Võtad vöö maha . . .",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = nil,
            anim = nil,
            flags = nil,
        },
        prop = {},
        propTwo = {}
     }, function(cancelled)
        if not cancelled then
            RS.Client.HUD.data.vehicle.isSeatbeltOn = false
            TriggerEvent("seatbelt:client:ToggleSeatbelt", false)
            TriggerEvent("InteractSound_CL:PlayOnOne","carunbuckle", 0.25)
            TriggerEvent(Config.NotifyName,'Vöö maas', 'warning')
            toggleSeatbelt()
            --SeatBeltLoop()
        else
            TriggerEvent(Config.NotifyName,'Declined', 'error')
        end
    end)
    

end

function SeatBeltLoop()
    CreateThread(function()
        while true do
            local sleep = 0
            if RS.Client.HUD.data.vehicle.isSeatbeltOn then
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 75, true)
            end
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                RS.Client.HUD.data.vehicle.isSeatbeltOn = false
                --harnessOn = false
                TriggerEvent("seatbelt:client:ToggleSeatbelt", false)
                break
            end
            if not RS.Client.HUD.data.vehicle.isSeatbeltOn then break end
            Wait(sleep)
        end
    end)
end








ServerBinds = function()

    Controlkey = {["seatbelt"] = {29,"B"}} 
    RegisterNetEvent('event:control:update')
    AddEventHandler('event:control:update', function(table)
        Controlkey["seatbelt"] = table["seatbelt"]
        print("Done")
    end)
    
    RegisterNetEvent('event:control:SeatBelt')
    AddEventHandler('event:control:SeatBelt', function(useID)
        if useID == 1 then
            if not IsPedInAnyVehicle(PlayerPedId(), false) or IsPauseMenuActive() then return end
            local class = GetVehicleClass(GetVehiclePedIsUsing(PlayerPedId()))
            if class == 8 or class == 13 or class == 14 then return end
           
            if RS.Client.HUD.data.vehicle.isSeatbeltOn then 
                SeatbeltOff()
            else 
                SeatbeltOn()
            end
            print("Seatbelt")
        end 
    
    end)


end



if Config.ServerSidedBinds then
    ServerBinds()

else 
    RegisterCommand('+seatbelt', function()
        if not IsPedInAnyVehicle(PlayerPedId(), false) or IsPauseMenuActive() then return end
        local class = GetVehicleClass(GetVehiclePedIsUsing(PlayerPedId()))
        if class == 8 or class == 13 or class == 14 then return end
   
        if RS.Client.HUD.data.vehicle.isSeatbeltOn then 
            SeatbeltOff()
        else 
            SeatbeltOn()
        end
        print("Seatbelt client side")
    
    end)
    RegisterKeyMapping('+seatbelt', 'Seatbelt', 'keyboard', Config.SeatBeltKey)
end

RegisterNetEvent('hud:client:UpdateStress', function(newStress) -- Add this event with adding stress elsewhere
    stress = newStress
end)













