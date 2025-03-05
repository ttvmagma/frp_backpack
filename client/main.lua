Citizen.CreateThread(function()
    while not ESX do
        Citizen.Wait(10)
    end

    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(10)
    end

    TriggerServerEvent('frp_backpack:setWeight')
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    TriggerServerEvent('frp_backpack:setWeight')
end)

RegisterNetEvent('frp_backpack:neuerBackpack')
AddEventHandler('frp_backpack:neuerBackpack', function() 
    TriggerServerEvent('frp_backpack:setWeight')
end)

RegisterNetEvent('frp_backpack:loadBackpack')
AddEventHandler('frp_backpack:loadBackpack', function()
    local playerPed = PlayerPedId()
    local genderProps = {
        [0] = FUTURE.Settings.malebagProp,
        [1] = FUTURE.Settings.femalebagProp
    }

    TriggerEvent('skinchanger:getSkin', function(skin)
        local bagModel = genderProps[skin.sex] or 0
        TriggerEvent('skinchanger:change', "bags_1", bagModel)
    end)
end)
