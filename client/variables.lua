RS           = {}
RS.Framework = Utils.Functions:GetFramework()
RS.Utils     = Utils.Functions
RS.Callbacks = {}
RS.Client    = {
    HUD = {
        data = {
            isVisible = true,
            bars = {
                voice = {
                    microphone = false,
                    radio = false,
                    isTalking = false,
                    range = 1,
                },
                health = nil,
                armor = nil,
                hunger = nil,
                thirst = nil,
                oxygen = nil,
                stamina = nil,
                stress = nil,
                terminal = nil,
                leaf = nil,
            },
            vehicle = {
                thick = {
                    wait = 500
                },
                entity = nil,
                kmH = Config.Settings.VehicleHUD.kmH,
                show = nil,
                isSeatbeltOn = false,
                isPassenger = false,
                cruiseControlStatus = nil,
                inVehicle = nil,
                speed = 0,
                fuel = {
                    level = 0,
                    max_level = 0,
                    type = nil,
                },
                heat = {
                    level = 0,
                    max_level = 1000,
                    type = nil,
                },
                rpm = 0,
                gear = nil,
                miniMap = {
                    style = "square"
                },
                speedoMeter = {
                    fps = 60
                }
            },
            compass = {
                show = false,
                heading = 0,
                lastCrossRoadCheck = -1,
                crossRoad = {
                    street1 = nil,
                    street2 = nil
                },
            }
        },
    }
}
