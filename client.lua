QBCore = exports['qb-core']:GetCoreObject()
local cooldown = {}

function isOfficer()
    local playerData = QBCore.Functions.GetPlayerData()
    return playerData.job.name == 'police' or playerData.job.name == 'fbi'
end

function isInVehicle()
    local ped = PlayerPedId()
    return IsPedInAnyVehicle(ped, false)
end

function getNearestVehicle()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicles = QBCore.Functions.GetVehiclesInArea(pos, 50.0)
    local closestVehicle = nil
    local minDist = 1000

    for _, vehicle in ipairs(vehicles) do
        local dist = #(pos - GetEntityCoords(vehicle))
        if dist < minDist and vehicle ~= GetVehiclePedIsIn(ped, false) then
            minDist = dist
            closestVehicle = vehicle
        end
    end

    return closestVehicle, minDist
end

RegisterCommand('engineblock', function()
    if isOfficer() and isInVehicle() then
        local playerId = GetPlayerServerId(PlayerId())
        if cooldown[playerId] and (GetGameTimer() - cooldown[playerId]) < 1200000 then
            QBCore.Functions.Notify("You need to wait before using this again.")
            return
        end

        local nearestVehicle, dist = getNearestVehicle()
        if nearestVehicle and dist < 50.0 then
            local speed = GetEntitySpeed(nearestVehicle) * 3.6
            QBCore.Functions.Notify(string.format("Nearest vehicle speed: %.2f km/h", speed))

            local driver = GetPedInVehicleSeat(nearestVehicle, -1)
            if driver ~= 0 then
                TriggerServerEvent('blockEngine', GetPlayerServerId(NetworkGetEntityOwner(driver)), NetworkGetNetworkIdFromEntity(nearestVehicle))
                cooldown[playerId] = GetGameTimer()
            end
        else
            QBCore.Functions.Notify("No vehicle nearby.")
        end
    else
        QBCore.Functions.Notify("You need to be a police or fbi officer in a vehicle.")
    end
end, false)

RegisterKeyMapping('engineblock', 'Block Engine', 'keyboard', 'B')

RegisterNetEvent('engineBlocked')
AddEventHandler('engineBlocked', function(vehicleNetId)
    local vehicle = NetToVeh(vehicleNetId)
    SetVehicleEngineOn(vehicle, false, true, true)
    QBCore.Functions.Notify("Your engine has been blocked by an officer.")
    Citizen.Wait(10000)
    SetVehicleEngineOn(vehicle, true, true, true)
    QBCore.Functions.Notify("Your engine is now unblocked.")
end)

RegisterNetEvent('antiEngineBlock')
AddEventHandler('antiEngineBlock', function()
    QBCore.Functions.Notify("You have the anti-engine block item. Engine block failed.")
end)

RegisterNetEvent('notifyOfficer')
AddEventHandler('notifyOfficer', function(message)
    QBCore.Functions.Notify(message)
end)
