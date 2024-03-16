NPX = {}
NPX.PlayerData = {}
NPX.Settings = QBConfig


NPX.Shared = QBShared
NPX.CallBacks = NPX.CallBacks


-- NEW ONES
--NPX.DB = {}
--NPX.Util = NPX.Util
--NPX.Database = NPX.Database
--NPX.DataControls = DataControls
--NPX.Controls = Controls


NPX.Functions = NPX.Functions

exports('GetCoreObject', function()
    return NPX
end)

NPX = exports['qb-core']:GetCoreObject()