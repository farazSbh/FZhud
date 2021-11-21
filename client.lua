ESX, PlayerData = nil, {}
local PlayerInfoLoaded = false
local wmug, hmug, xmug, ymug = 0.0, 0.0, 0.0, 0.0
local mugshot, mugTxd = nil, nil
local isPaused, ToggleHUD = true, true

function SetDisplay(opacity)
	SendNUIMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

function SetName(name)
	SendNUIMessage({
		action  = 'setHUDName',
		name = name
	})
end

function SetID(data)
	SendNUIMessage({
		action  = 'setHUDID',
		source = data
	})
end

function SetJob(data)
	SendNUIMessage({
		action  = 'setHUDJob',
		data = data
	})
end

function SetGang(data)
	SendNUIMessage({
		action  = 'setHUDGang',
		value = 'hide',
		data = data
	})
end

function SetPing(ping)
	SendNUIMessage({
		action  = 'setHUDPing',
		ping = ping
	})
end

function SetData(data)
	SendNUIMessage({
		action  = 'setHUDData',
		data = data
	})
end

function SetStatus(data)
	SendNUIMessage({
		action  = 'setHUDStatus',
		data = data
	})
end


CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(1)
	end
end)

-- Designed BY Milad >>> Discord:MiLaD#0125

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	SetJob({job = PlayerData.job})
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
	SetGang({gang = PlayerData.gang})
end)

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SetStatus(status)
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
  	SendNUIMessage({action = "setHUDCash", money = ESX.Math.GroupDigits(money)})
end)

-- Update HUD Data
CreateThread(function()
	while not PlayerData.name do
		Wait(300)
	end

	while true do
		Wait(1000)
		local playerPed  = PlayerPedId()
		local prevHealth = (GetEntityHealth(playerPed)-100)
		local armor = GetPedArmour(playerPed)

		SetData({health = prevHealth, armor = armor})
	end
end)

-- Pause Menu
CreateThread(function()
	while true do
		Wait(300)

		if IsPauseMenuActive() and not isPaused and ToggleHUD then
			isPaused = true
			SetDisplay(0.0)
		elseif not IsPauseMenuActive() and isPaused and ToggleHUD then
			isPaused = false
			SetDisplay(1.0)
		end
	end
end)

-- Update MugShot
CreateThread(function()
    while not PlayerData.name do
        Wait(5000)
    end

    while true do
		Wait(1)

		if not IsPedheadshotValid(mugshot) or not ToggleHUD then
			goto skin_mugshot
		end

		DrawSprite(mugTxd, mugTxd, xmug, ymug, wmug, hmug, 0.0, 255, 255, 255, 255);
		::skin_mugshot::
    end
end)


AddEventHandler('skinchanger:modelLoaded', function()
	while not PlayerData.name do
		Wait(1000)
	end

	Wait(5000)

	while not HasPedHeadBlendFinished(PlayerPedId()) do
		Wait(1000)
	end

	if not PlayerInfoLoaded then
		SetName((PlayerData.name):gsub('_', ' '))
		SetID(tostring(GetPlayerServerId(PlayerId())))
		SetJob({job = PlayerData.job})
		SetGang({gang = PlayerData.gang})
		SendNUIMessage({action = "setHUDCash", money = ESX.Math.GroupDigits(PlayerData.money)})
		PlayerInfoLoaded = true
	end
	mugshot, mugTxd = ESX.Game.GetPedMugshot(PlayerPedId(), true)
end)

RegisterNUICallback('setMugShotPos', function(data)
	wmug = data.w
	hmug = data.h
	xmug = data.x + (data.w/2)
	ymug = data.y + (data.h/2)
end)

-- Designed BY Milad >>> Discord:MiLaD#0125
RegisterNetEvent('sr:toggleHUD')
AddEventHandler('sr:toggleHUD', function()
	if not isPaused then
		ToggleHUD = not ToggleHUD
		if ToggleHUD then
			SetDisplay(1.0)
		else
			SetDisplay(0.0)
		end
	end
end)

RegisterNetEvent('status:updatePing')
AddEventHandler('status:updatePing', function(ping)
  SendNUIMessage({action = "ping", value = ping})
end)


AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for i=1, 35 do
			UnregisterPedheadshot(i)
		end
	end
end)