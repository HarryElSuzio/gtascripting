ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('tm1_empresa:addItem')
AddEventHandler('tm1_empresa:addItem', function(name,price)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(name,price)
end)

RegisterServerEvent('tm1_empresa:removeItem')
AddEventHandler('tm1_empresa:removeItem', function(price)
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("hw",price)
	local source = source
	xPlayer.addAccountMoney('black_money', price * 550)
end)