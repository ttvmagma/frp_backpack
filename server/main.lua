RegisterServerEvent('frp_backpack:setWeight')
AddEventHandler('frp_backpack:setWeight', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        return 
    end

    MySQL.Async.fetchScalar('SELECT backpack FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(backpackLevel)
        backpackLevel = tonumber(backpackLevel) or 0
        local newWeight = FUTURE.backpacklvl[backpackLevel] or ESX.GetConfig().MaxWeight

        xPlayer.setMaxWeight(newWeight)
        TriggerClientEvent('frp_hud:notify', source, "info", "Inventar", ('Inventargröße auf %s gesetzt'):format(newWeight), 5000)
    end)
end)

RegisterServerEvent('frp_backpack:updateBackpack')
AddEventHandler('frp_backpack:updateBackpack', function(playerId, backpackLevel)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then
        print(('Spieler-ID %s nicht gefunden'):format(playerId))
        return
    end

    MySQL.Async.execute('UPDATE users SET backpack = @backpack WHERE identifier = @identifier', {
        ['@backpack'] = backpackLevel,
        ['@identifier'] = xPlayer.identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('frp_backpack:neuerBackpack', playerId)
            TriggerClientEvent('frp_backpack:loadBackpack', playerId)
            TriggerEvent('frp_backpack:setWeight', playerId)
        end
    end)
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
        else
            TriggerClientEvent('frp_hud:notify', playerId, "error", "Inventar", "Du hast keinen Rucksack!", 5000)
        end
    end)
end