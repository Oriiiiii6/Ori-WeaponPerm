local BotToken = "Your_Bot_Token"

function CheckDiscordRole(src, cb)
    local ids = GetPlayerIdentifiers(src)
    local discordId

    for _, v in ipairs(ids) do
        if string.sub(v, 1, 8) == "discord:" then
            discordId = string.sub(v, 9)
            break
        end
    end

    if not discordId then
        cb(false)
        return
    end

    PerformHttpRequest(("https://discord.com/api/guilds/%s/members/%s"):format(Config.DiscordGuildId, discordId), function(errorCode, resultData, resultHeaders)
        if errorCode ~= 200 then
            print('[Ori-WeaponPerm] Discord API error: ' .. errorCode)
            cb(false)
            return
        end

        local data = json.decode(resultData)
        for _, role in ipairs(data.roles) do
            if role == Config.AllowedRoleId then
                cb(true)
                return
            end
        end
        cb(false)
    end, "GET", "", {
        ["Authorization"] = "Bot " .. BotToken,
        ["Content-Type"] = "application/json"
    })
end

RegisterNetEvent('Ori-WeaponPerm:requestPermission', function()
    local src = source
    CheckDiscordRole(src, function(hasRole)
        TriggerClientEvent('Ori-WeaponPerm:setPermission', src, hasRole)
    end)
end)

function RefreshPlayerRoleCheck(playerId)
    CheckDiscordRole(playerId, function(hasRole)
        TriggerClientEvent('Ori-WeaponPerm:setPermission', playerId, hasRole)
    end)
end

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    deferrals.update("בודק הרשאות נשק...")

    CheckDiscordRole(src, function(hasRole)
        TriggerClientEvent('Ori-WeaponPerm:setPermission', src, hasRole)
        deferrals.done()
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for _, playerId in ipairs(GetPlayers()) do
        RefreshPlayerRoleCheck(tonumber(playerId))
    end
end)

CreateThread(function()
    while true do
        Wait(Config.RefreshCheck * Config.TimeUnit)
        for _, playerId in ipairs(GetPlayers()) do
            RefreshPlayerRoleCheck(tonumber(playerId))
        end
    end
end)
