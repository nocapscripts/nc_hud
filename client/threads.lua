CreateThread(function()
    while RS.Framework == nil do
        RS.Framework = Utils.Functions:GetFramework()
        Wait(350)
    end
end)

function RS.Client.HUD:MainThick()
    local playerId = PlayerId()
    --local playerPedId = PlayerPedId()
    CreateThread(function()
        while not playerLoaded() do
            Wait(500)
        end
        while playerLoaded() do
            local oxygen, stamina
            local isTalking = NetworkIsPlayerTalking(playerId)
            self.data.bars.voice.isTalking = isTalking
            self.data.bars.voice.microphone = isTalking
            oxygen = math.floor(GetPlayerUnderwaterTimeRemaining(playerId) * 10)
            stamina = math.floor(100 - GetPlayerSprintStaminaRemaining(playerId))
            self.data.bars.oxygen = IsPedSwimmingUnderWater(PlayerPedId()) and oxygen or 100
            self.data.bars.stamina = stamina or 0
            self.data.bars.terminal = 100 -- ?
            self.data.bars.leaf = 100     -- ?
            if Config.FrameWork == "qb" then
                local _Player = RS.Client:GetPlayerData()
                local health = math.floor(
                    (GetEntityHealth(PlayerPedId()) - 100) /
                    (GetEntityMaxHealth(PlayerPedId()) - 100) *
                    100
                )
                if health > 100 then
                    health = 100
                elseif health < 0 then
                    health = 0
                end
                self.data.bars.health = health
                self.data.bars.armor = GetPedArmour(PlayerPedId())
                if IsPedInAnyVehicle(playerId, false) then
                    local veh = GetVehiclePedIsIn(playerId, false)
                    local speed = math.floor(GetEntitySpeed(veh) * 3.0)
                    local vehHash = GetEntityModel(veh)
                    local stressSpeed
                    if speed > 120 then -- Bike func
                        stressSpeed = 120
                    else
                        stressSpeed = 50
                    end
                    if speed > stressSpeed then
                        TriggerServerEvent('hud:server:GainStress', math.random(1, 10))
                    end
                end
                self.data.bars.stress = _Player.metadata["stress"]
                

                -- Pause
                if IsPauseMenuActive() then
                    local isVisible = self.data.isVisible
                    if isVisible then
                        RS.Client.HUD:Toggle(false)
                    end
                else
                    local isVisible = self.data.isVisible
                    if not isVisible then
                        RS.Client.HUD:Toggle(true)
                    end
                end
            end

            -- Vehicle HUD
            if Config.Settings.VehicleHUD.active then
                if IsPedInAnyVehicle(PlayerPedId()) then
                    if not self.data.vehicle.inVehicle then
                        local vehicle = GetVehiclePedIsIn(PlayerPedId())
                        if DoesEntityExist(vehicle) then
                            if not IsThisModelABicycle(vehicle) then
                                self.data.vehicle.inVehicle = true
                                self.data.vehicle.entity = vehicle
                                self.data.vehicle.fuel.type = self:CheckVehicleFuelType(GetEntityModel(vehicle))
                                self.data.compass.show = true
                                self:ActivateVehicleHud(vehicle)
                                DisplayRadar(true)
                            end
                        end
                    end
                elseif self.data.vehicle.inVehicle then
                    self.data.vehicle.inVehicle = false
                    self.data.vehicle.entity = nil
                    self.data.vehicle.isPassenger = false
                    self.data.vehicle.show = false
                    self.data.vehicle.isSeatbeltOn = false
                    self.data.vehicle.cruiseControlStatus = false
                    self.data.compass.show = false
                    RS.Client:SendReactMessage(
                        "UPDATE_HUD_VEHICLE",
                        self.data.vehicle
                    )
                    RS.Client:SendReactMessage(
                        "UPDATE_HUD_COMPASS",
                        self.data.compass
                    )
                    DisplayRadar(false)
                end
            end
            RS.Client:SendReactMessage(
                "UPDATE_HUD_STATUS_BARS",
                self.data.bars
            )
            Wait(1000)
        end
    end)
end

function RS.Client.HUD:fVehicleInfoThick(vehicle)
    --local playerPedId = PlayerPedId()
    SetVehicleEngineTemperature(vehicle, 100, 1)
    CreateThread(function()
        while self.data.vehicle.inVehicle and DoesEntityExist(vehicle) do
            self.data.vehicle.isPassenger = GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId()
            if not self.data.vehicle.isPassenger then
                local currentSpeed =  math.floor(GetEntitySpeed(vehicle) * 3.0)
                local engineRunning = GetIsVehicleEngineRunning(vehicle)
                local rpm = engineRunning and GetVehicleCurrentRpm(vehicle) or 0
                local gear = engineRunning and GetVehicleCurrentGear(vehicle) or "N"
                local temp = 0
                local temperature = GetVehicleEngineTemperature(vehicle)
                local engineHealth = engineRunning and math.floor(GetVehicleEngineHealth(vehicle)) or 1000
                if engineHealth < 0 then
                    engineHealth = 0
                end
                if gear == 0 then
                    gear = "R"
                end
                self.data.vehicle.speed = currentSpeed
                if rpm > 0.5 and self.data.vehicle.speed == 0 then
                    self.data.vehicle.speed = 1
                end
                self.data.vehicle.fuel.level = self:GetFuelExport() or 100
                self.data.vehicle.heat.level = math.floor(temperature)
                self.data.vehicle.heat.max_level = 1000
                self.data.vehicle.fuel.max_level = 100
                self.data.vehicle.rpm = rpm
                self.data.vehicle.gear = gear
                self.data.vehicle.engineHealth = engineHealth
                RS.Client:SendReactMessage(
                    "UPDATE_HUD_VEHICLE",
                    self.data.vehicle
                )
                Wait(self.data.vehicle.thick.wait)
            else
                Wait(1000)
            end
        end
    end)
end

function RS.Client.HUD:fVehicleCompassThick(vehicle)
    if Config.Settings.Compass.active then
        --local playerPedId = PlayerPedId()
        CreateThread(function()
            while self.data.vehicle.inVehicle and DoesEntityExist(vehicle) do
                RS.Client.HUD:CheckCrossRoads(PlayerPedId())
                RS.Client.HUD:HeadUpdate(PlayerPedId())
                RS.Client:SendReactMessage(
                    "UPDATE_HUD_COMPASS",
                    self.data.compass
                )
                Wait(1000)
            end
        end)
    end
end

function RS.Client.HUD:LowFuelThread(vehicle)
    if Config.Settings.VehicleHUD.lowFuelNotify then
        --local playerPedId = PlayerPedId()
        CreateThread(function()
            while self.data.vehicle.inVehicle and DoesEntityExist(vehicle) do
                if playerLoaded() then
                    if IsPedInAnyVehicle(PlayerPedId(), false) and not IsThisModelABicycle(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) then
                        if self:GetFuelExport() <= 20 then -- At 20% fuel left.
                            RS.Client:SendNotify(_t("notify.low_fuel"), "error")
                            Wait(60000)
                        end
                    end
                end
                Wait(10000)
            end
        end)
    end
end

if not Config.DisableStress then
    CreateThread(function() -- Speeding
        while true do
            if LocalPlayer.state.isLoggedIn then
                local ped = PlayerPedId()
                if IsPedInAnyVehicle(ped, false) then
                    local veh = GetVehiclePedIsIn(ped, false)
                    local vehClass = GetVehicleClass(veh)
                    local speed = math.floor(GetEntitySpeed(veh) * 3.0)
                    local vehHash = GetEntityModel(veh)
                    local stressSpeed
                    if vehClass == 8 then -- Bike func
                        stressSpeed = Config.MinimumSpeed
                    else
                        stressSpeed = Config.MinimumSpeed or Config.MinimumSpeedUnbuckled
                    end
                    if speed >= stressSpeed then
                        TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                    end
                end
            end
            Wait(10000)
        end
    end)
end



-- Stress effect

local function GetBlurIntensity(stresslevel)
    for _, v in pairs(Config.Intensity['blur']) do
        if stresslevel >= v.min and stresslevel <= v.max then
            return v.intensity
        end
    end
    return 1500
end

local function GetEffectInterval(stresslevel)
    for _, v in pairs(Config.EffectInterval) do
        if stresslevel >= v.min and stresslevel <= v.max then
            return v.timeout
        end
    end
    return 60000
end


if not Config.Settings.Hud.Ammohud then
    HideHudComponentThisFrame(2)
else 
    print("Ammo hud enabled")
end

-- Bhoping rule
Citizen.CreateThread( function()

	local resetcounter = 0
	local jumpDisabled = false
  	
  	while true do 
    Citizen.Wait(100)

  

		if jumpDisabled and resetcounter > 0 and IsPedJumping(PlayerPedId()) then
			
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)

			resetcounter = 0
		end

		if not jumpDisabled and IsPedJumping(PlayerPedId()) then

			jumpDisabled = true
			resetcounter = 10
			Citizen.Wait(1200)
		end

		if resetcounter > 0 then
			resetcounter = resetcounter - 1
		else
			if jumpDisabled then
				resetcounter = 0
				jumpDisabled = false
			end
		end
	end
end)
