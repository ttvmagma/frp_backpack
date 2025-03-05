RegisterServerEvent('frp_backpack:setWeight')
AddEventHandler('frp_backpack:setWeight', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer then
        MySQL.Async.fetchScalar('SELECT backpack FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(backpackLevel)
            local newWeight = 0
            if backpackLevel then
                if tonumber(backpackLevel) > 0 then
                    newWeight = FUTURE.backpacklvl[tonumber(backpackLevel)] or 0
                else
                    newWeight = ESX.GetConfig().MaxWeight
                end
            end
            xPlayer.setMaxWeight(newWeight)
            TriggerClientEvent('frp_hud:notify', _source, "info", "Information", ('Inventargröße auf %s gesetzt'):format(newWeight), 5000)
        end)
    end
end)

RegisterServerEvent('frp_backpack:updateBackpack')
AddEventHandler('frp_backpack:updateBackpack', function(playerId, backpackLevel)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        MySQL.Async.execute('UPDATE users SET backpack = @backpack WHERE identifier = @identifier', {
            ['@backpack'] = backpackLevel,
            ['@identifier'] = xPlayer.identifier
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('frp_backpack:neuerBackpack', playerId)
                TriggerEvent('frp_backpack:setWeight', playerId)
            end
        end)
    else
        print(('Die Spieler-ID %s wurde nicht gefunden'):format(playerId))
    end
end)

for level, itemName in pairs(FUTURE.backpackItems) do
    ESX.RegisterUsableItem(itemName, function(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if not xPlayer then
            print(('Spieler-ID %s nicht gefunden'):format(playerId))
            return
        end

        local item = xPlayer.getInventoryItem(itemName)
        if item.count > 0 then
            xPlayer.removeInventoryItem(itemName, 1)
            TriggerEvent('frp_backpack:updateBackpack', playerId, level)
            TriggerClientEvent("frp_backpack:loadBackpack", playerId)
        else
            TriggerClientEvent('frp_hud:notify', playerId, "error", "Inventar", "Du hast keinen Rucksack!", 5000)
        end
    end)
end
