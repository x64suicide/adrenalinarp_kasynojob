ESX = exports['es_extended']:getSharedObject()

local PlayerData = {}
local LastZone = nil
local InMarker = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
    while PlayerData.job == nil do
        PlayerData = ESX.GetPlayerData()
        Citizen.Wait(1000)
    end

    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local currentZone, letSleep = nil, true

        for k,v in pairs(Config.Zones) do
            if v.Ranga == 'brak' then
                if #(coords - v.Marker) <= v.DrawDistance.marker then
                    ESX.DrawMarker(v.Marker)
                    letSleep, currentZone = false, k
                end
                if #(coords - v.Marker) <= v.DrawDistance.msg then
                    if currentZone ~= nil and LastZone ~= currentZone then
                        ESX.ShowHelpNotification(v.Msg)
                        if not InMarker then
                            InMarker = true
                        end
                    end
                    
                    if IsControlJustPressed(0,  38) then
                        LastZone = currentZone
                        if LastZone == 'Kupzetony' then
                            openzetony()
                        else
                            print('Błąd w Configu!')
                        end
                    end
                else
                    if InMarker and LastZone == k then
                        ESX.UI.Menu.CloseAll()
                        LastZone = nil
                        InMarker = false
                    end
                end
            end
        end
        if letSleep then
            Citizen.Wait(1000)
        end
    end
end)

function openzetony()
    ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'kasynojob_menuszefa', {
		title    = 'Sklep - Kasyno',
		align    = 'center',
		elements = {
            {label = '1 żeton = 10$', value = 'kupcia'},
			{label = 'Kup żetony', value = 'kup'},
			{label = 'Wymień', value = 'wymien'}
		}
	}, function(data, menu)

	if data.current.value == 'kup' then
        menu.close()
        platnosc()
	elseif data.current.value == 'wymien' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'adrenalinarp_kasynojob', {
            title = 'Ile żetonów chcesz wymienić?'
        }, function(data2, menu2)
            menu.close()
            local amount = tonumber(data2.value)

            if amount == nil then
                ESX.ShowNotification('Błędna ilość')
                ESX.UI.Menu.CloseAll()
                LastZone = nil
            else
                TriggerServerEvent('adrenalinarp_kasyno:zetony2', amount)
                ESX.UI.Menu.CloseAll()
                LastZone = nil
            end
        end, function(data2, menu2)
            menu2.close()
        end)
	end
	end, function(data, menu)
		menu.close()
        LastZone = nil
	end)
end

function platnosc()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'kasynojob_menuszefa', {
        title    = 'Jaka płatność?',
        align    = 'center',
        elements = {
          {label = 'Gotówka', value = 'gotowka'},
          {label = 'Karta', value = 'karta'},
        }
    }, function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'adrenalinarp_kasynojobplatnosc', {
            title = 'Ile żetonów chcesz kupić?'
        }, function(data2, menu2)
            menu.close()
            local amount = tonumber(data2.value)

            if amount == nil then
                ESX.ShowNotification('Błędna ilość')
                ESX.UI.Menu.CloseAll()
                LastZone = nil
            else
                TriggerServerEvent('adrenalinarp_kasyno:zetony1', data.current.value, amount)
                ESX.UI.Menu.CloseAll()
                LastZone = nil
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
		menu.close()
        LastZone = nil
	end)
end