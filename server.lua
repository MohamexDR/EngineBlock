ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('blockEngine')
AddEventHandler('blockEngine', function(targetId, vehicleNetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(targetId)
        TriggerClientEvent('engineBlocked', targetId, vehicleNetId)
        TriggerClientEvent('notifyOfficer', source, "The target vehicle's engine has been blocked.")
end)
