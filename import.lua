QBCore = {}
QBCore.PlayerData = {}
QBCore.Settings = QBConfig


QBCore.Shared = QBShared
QBCore.CallBacks = QBCore.CallBacks


-- NEW ONES
--QBCore.DB = {}
--QBCore.Util = QBCore.Util
--QBCore.Database = QBCore.Database
--QBCore.DataControls = DataControls
--QBCore.Controls = Controls


QBCore.Functions = QBCore.Functions

exports('GetCoreObject', function()
    return QBCore
end)

QBCore = exports['qb-core']:GetCoreObject()