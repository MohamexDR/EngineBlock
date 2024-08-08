QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('blockEngine')
AddEventHandler('blockEngine', function(targetId, vehicleNetId)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    if targetPlayer then
        TriggerClientEvent('engineBlocked', targetId, vehicleNetId)
        TriggerClientEvent('notifyOfficer', src, "The target vehicle's engine has been blocked.")
    end
end)
