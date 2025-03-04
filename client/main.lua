Citizen.CreateThread(function()
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
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