local canCarryWeapon = false

RegisterNetEvent('Ori-WeaponPerm:setPermission', function(state)
    canCarryWeapon = state
end)

CreateThread(function()
    while true do
        Wait(200)
        if not canCarryWeapon then
            local playerPed = PlayerPedId()
            if IsPedArmed(playerPed, 6) then
                RemoveAllPedWeapons(playerPed, true)

                local message = Config.Messages[Config.Locale].NoPermission or "No permission!"
                lib.notify({
                    title = Config.Messages[Config.Locale].TitleCheck or "אזהרה",
                    description = message,
                    type = "error"
                })
            end
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('Ori-WeaponPerm:requestPermission')

    if Config.AutoCheck then
        StartAutoCheck()
    end
end)

local HasWeaponPermission = false

function StartAutoCheck()
    CreateThread(function()
        while true do
            Wait(Config.CheckCheck * 1000)
            TriggerServerEvent('Ori-WeaponPerm:requestPermission')
        end
    end)
end

RegisterNetEvent('Ori-WeaponPerm:setPermission', function(state)
    HasWeaponPermission = state
end)

function CanUseWeapon()
    return HasWeaponPermission
end

