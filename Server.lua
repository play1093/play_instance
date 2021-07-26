ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local play_players = {}

RegisterServerEvent('play_instance:player')
AddEventHandler('play_instance:player',function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	  
	table.insert(play_players, {id = GetPlayerName(_source), state = 0})	
end)

local dimensiones = {}

RegisterServerEvent('play_instance:instance')
AddEventHandler('play_instance:instance',function(id, state)

    local nombre = GetPlayerName(id)

    if state > 0 then
        dimensiones[id] = GetPlayerRoutingBucket(id)
        SetPlayerRoutingBucket(id, state)

        for i = 1, #play_players, 1 do
            if play_players[i].id == nombre then
                play_players[i].state = state
            end
        end
    else
        SetPlayerRoutingBucket(id, 0)
        dimensiones[id] = 0

        for i = 1, #play_players, 1 do
            if play_players[i].id == nombre then
                play_players[i].state = state
            end
        end
    end
end)

ESX.RegisterServerCallback('play_instance:getPlayers', function(source, cb)
	cb(play_players)
end)

AddEventHandler('playerDropped', function ()

    local nombre = GetPlayerName(source)

	for i = 1, #play_players, 1 do
		if play_players[i].id == nombre then
			table.remove(play_players, i)
            print(play_players[i])
            print("Lo he borrado")
		end
	end
end)


