ESX = nil
local StatePlayers = {}

--===============================================
--==                  CLIENT                   ==
--===============================================

Citizen.CreateThread(function()
	while ESX == nil do
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	  Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent("play_instance:player")
end)

AddEventHandler('onResourceStart', function(resourceName)
	Citizen.Wait(100)
    TriggerServerEvent("play_instance:player")
end)

RegisterCommand(Config.Command, function(source, args, raw)
    local id = tonumber(args[1])
    local state = tonumber(args[2])
    TriggerServerEvent("play_instance:instance", id, state)
end, true)

RegisterCommand("player_instances", function(source, args, rawCommand)
	StateMenu()
end, true)

--===============================================
--==                 FUNCTIONS                 ==
--===============================================

StateMenu = function()
    ESX.UI.Menu.CloseAll()

    ESX.TriggerServerCallback('play_instance:getPlayers', function(players)
		StatePlayers = players
	end)

	local list = {}

	Citizen.Wait(100)

	for i = 1, #StatePlayers, 1 do
        table.insert(list, {
		    ["label"] = 'Player: <span style="color:green">' .. StatePlayers[i].id .. "</span> - State: " .. StatePlayers[i].state
	    })
    end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "state_menu",
	{
		["title"] = "States Players",
		["align"] = "right",
		["elements"] = list

	}, function(data, menu)
		
	end, function(data, menu)
		menu.close()
	end)
end
