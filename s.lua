ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('adrenalinarp_kasyno:zetony2')
AddEventHandler('adrenalinarp_kasyno:zetony2', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local cena = 10 * amount
    xPlayer.removeInventoryItem('zeton', amount)
    xPlayer.addAccountMoney('money', cena)
    xPlayer.showNotification("Wymieniłeś ~b~x".. amount .. " ~w~żetonów")
end)

RegisterNetEvent('adrenalinarp_kasyno:zetony1')
AddEventHandler('adrenalinarp_kasyno:zetony1', function(paymethod, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local cena = 10 * amount
    if (paymethod == 'gotowka') then 
        if (xPlayer.getAccount('money').money =~ cena) then
            xPlayer.removeAccountMoney('money', cena)
            xPlayer.addInventoryItem('zeton', amount)
            xPlayer.showNotification("Zakupiłeś ~b~x".. amount .. " ~w~żetonów")
        elseif (xPlayer.getAccount().money > cena) then
            xPlayer.removeAccountMoney('money', cena)
            xPlayer.addInventoryItem('zeton', amount)
            xPlayer.showNotification("Zakupiłeś ~b~x".. amount .. " ~w~żetonów")
        else
            xPlayer.showNotification("Nie posiadasz tyle pieniędzy w gotówce")
        end
    elseif (paymethod == 'karta')
        if (xPlayer.getAccount('bank').money =~ cena) then
            xPlayer.removeAccountMoney('bank', cena)
            xPlayer.addInventoryItem('zeton', amount)
            xPlayer.showNotification("Zakupiłeś ~b~x".. amount .. " ~w~żetonów")
        elseif (xPlayer.getAccount('bank').money > cena) then
            xPlayer.removeAccountMoney('bank', cena)
            xPlayer.addInventoryItem('zeton', amount)
            xPlayer.showNotification("Zakupiłeś ~b~x".. amount .. " ~w~żetonów")
        else
            xPlayer.showNotification("Nie posiadasz tyle pieniędzy na karcie!")
        end
    end
end)
