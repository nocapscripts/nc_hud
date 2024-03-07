RS = {}
RS.Framework = Utils.Functions:GetFramework()
RS.Utils = Utils.Functions
RS.Server = {
    MySQL = {
        Async = {},
        Sync = {}
    },
    HUD = {}
}
RS.Callbacks = {}

RS.Server.RegisterServerCallback = function(key, func)
    RS.Callbacks[key] = func
end

RS.Server.TriggerCallback = function(key, source, payload, cb)
    if not cb then
        cb = function() end
    end

    if RS.Callbacks[key] then
        RS.Callbacks[key](source, payload, cb)
    end
end
