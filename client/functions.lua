

function RS.Client:TriggerServerCallback(key, payload, func)
    if not func then
        func = function() end
    end
    RS.Callbacks[key] = func
    TriggerServerEvent("rs_hud:Server:HandleCallback", key, payload)
end

function RS.Client:SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end


function RS.Client:SendNotify(title, type, duration, icon, text)
    system = Config.NotifyType
    if system == "ESX" then
        if Config.FrameWork == "ESX" then
            RS.Framework.ShowNotification(title, type, duration)
        end
    elseif system == "QB" then
        if Config.FrameWork == "QB" then
            RS.Framework.Functions.Notify(title, type)
        end
    elseif system == "custom" then
        Utils.Functions:CustomNotify(nil, title, type, text, duration, icon)
    end
end


DisplayRadar(false)


function RS.Client:GetPlayerData()
    if Config.FrameWork == "ESX" then
        return RS.Framework.GetPlayerData()
    elseif Config.FrameWork == "QB" then
        return RS.Framework.Functions.GetPlayerData()
    end
end



function playerLoaded()
    return LocalPlayer.state.isLoggedIn
end

function RS.Client.HUD:Start(xPlayer)
    if not xPlayer then
        xPlayer = RS.Client:GetPlayerData()
    end
    self:MainThick()
    DisplayRadar(false)
    self:SetMiniMap(self.data.vehicle.miniMap.style)
    self.data.vehicle.kmh = Config.Settings.VehicleHUD.kmH
    RS.Client:SendReactMessage("SET_HUD_STATUS_BARS_ACTIVE", Config.Settings.StatusBars)
    RS.Client:SendReactMessage("SET_HUD_VEHICLE_ACTIVE", Config.Settings.VehicleHUD)
    RS.Client:SendReactMessage("SET_HUD_SETTINGS_HELP_GUIDES", Config.HelpGuides)
    Wait(500)
    RS.Client:SendReactMessage("LOAD_HUD_STORAGE")
    Wait(500)
    RS.Client:SendReactMessage("setVisible", true)
end

function RS.Client.HUD:Toggle(state)
    if state == nil then
        self.data.isVisible = not self.data.isVisible
    else
        self.data.isVisible = state
    end
    RS.Client:SendReactMessage("setVisible", self.data.isVisible)
end

function RS.Client.HUD:SetMiniMap(_type)
    Wait(1000)
    local defaultAspectRatio = 1920 / 1080
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end
    local defaultAspectRatio = 1920 / 1080
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end
    local minimap = RequestScaleformMovie("minimap")
    if not HasScaleformMovieLoaded(minimap) then
        RequestScaleformMovie(minimap)
        while not HasScaleformMovieLoaded(minimap) do
            Wait(1)
        end
    end
    if _type == "square" then
        RequestStreamedTextureDict("squaremap", false)
        if not HasStreamedTextureDictLoaded("squaremap") then
            Wait(150)
        end
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
        AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")
    else
        RequestStreamedTextureDict("circlemap", false)
        if not HasStreamedTextureDictLoaded("circlemap") then
            Wait(150)
        end
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
        AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "circlemap", "radarmasksm")
    end
    SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.047, 0.1638, 0.183)
    SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.00, 0.128, 0.20)
    SetMinimapComponentPosition("minimap_blur", "L", "B", -0.01 + minimapOffset, 0.025, 0.262, 0.300)
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetRadarBigmapEnabled(true, false)
    SetMinimapClipType(_type == "square" and 0 or 1)
    Wait(500)
    SetRadarBigmapEnabled(false, false)
end

function RS.Client.HUD:GetFuelExport()
    if GetResourceState("ox_fuel") == "started" then
        if Entity(self.data.vehicle.entity) then
            local ent = Entity(self.data.vehicle.entity).state.fuel or 0
            if Config.FrameWork == "ESX" then
                return RS.Framework.Math.Round(ent, 2)
            elseif Config.FrameWork == "QB" then
                return RS.Framework.Shared.Round(ent, 2)
            end
        else
            return false
        end
    elseif GetResourceState("LegacyFuel") == "started" then
        if Config.FrameWork == "ESX" then
            return RS.Framework.Math.Round(Entity(self.data.vehicle.entity).state.fuel or 0, 2)
        elseif Config.FrameWork == "QB" then
            return RS.Framework.Shared.Round(exports["LegacyFuel"]:GetFuel(self.data.vehicle.entity) or 0, 2)
        end
    else
        local response = RS.Utils:CustomFuelExport()
        return response
    end
end

function RS.Client.HUD:VehicleDriverCheck(vehicle)
    if not DoesEntityExist(vehicle) then
        return false
    end
    if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        return true
    end
    return false
end

function RS.Client.HUD:ActivateVehicleHud(veh)
    self.data.vehicle.show = true
    self:fVehicleInfoThick(veh)
    self:LowFuelThread(veh)
    self:fVehicleCompassThick(veh)
end

function RS.Client.HUD:UpdateVehicleHud(data)
    if self.data.vehicle.miniMap.style ~= data.miniMap.style then
        self.data.vehicle.miniMap.style = data.miniMap.style
        self:SetMiniMap(data.miniMap.style)
    end
    if self.data.vehicle.speedoMeter.fps ~= data.speedoMeter.fps then
        self.data.vehicle.speedoMeter.fps = data.speedoMeter.fps
        local w = 200
        if data.speedoMeter.fps == 15 then
            w = 200
        elseif data.speedoMeter.fps == 30 then
            w = 150
        elseif data.speedoMeter.fps == 60 then
            w = 100
        end
        self.data.vehicle.thick.wait = w
    end
end

function RS.Client.HUD:CheckCrossRoads(entity)
    local updateTick = GetGameTimer()
    if self.data.compass.lastCrossRoadCheck == -1 or updateTick - self.data.compass.lastCrossRoadCheck > 1500 then
        local pos = GetEntityCoords(entity)
        local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
        self.data.compass.lastCrossRoadCheck = updateTick
        self.data.compass.crossRoad = {
            street1 = GetStreetNameFromHashKey(street1),
            street2 = GetStreetNameFromHashKey(street2)
        }
    end
end

function RS.Client.HUD:HeadUpdate(entity)
    local camRot = GetGameplayCamRot(0)
    local heading = string.format("%.0f", (360.0 - ((camRot.z + 360.0) % 360.0)))
    heading = tonumber(heading)
    if heading == 360 then heading = 0 end
    if heading ~= lastHeading then
        self.data.compass.heading = heading
    end
    lastHeading = heading
end

function RS.Client.HUD:CheckVehicleFuelType(vehicle)
    for k, v in pairs(Config.ElectricVehicles) do
        if vehicle == GetHashKey(v) then
            return "electric"
        end
    end
    return "gasoline"
end


