data = {}
VorpInv = exports.vorp_inventory:vorp_inventoryApi()

RegisterServerEvent("loot:add")
AddEventHandler("loot:add", function(item)
		local _item = item
		local _source = source
		local randomitem =  math.random(1,3)
		VorpInv.addItem(_source, _item, randomitem)
		TriggerClientEvent("vorp:TipRight", _source, _item, 3000)
end)

RegisterServerEvent('loot:addmoney')
AddEventHandler('loot:addmoney', function(price)
	local _source = source
	local _price = tonumber(price)
	TriggerEvent("vorp:addMoney", _source, 0, _price)
	TriggerClientEvent("vorp:TipRight", _source,'$'.._price, 3000)
end)

RegisterServerEvent('loot:addxp')
AddEventHandler('loot:addxp', function(xppay)
	local _source = source
	local _xppay = tonumber(xppay)
	TriggerEvent("vorp:addXp", _source, xppay)
	TriggerClientEvent("vorp:TipRight", _source, '+'..xppay..' XP', 3000)
end)

RegisterNetEvent('loot:giveItem')
AddEventHandler('loot:giveItem', function(item)
	local _item = items -- This just doesnt work?!?!
    local _source = source
	local randomitem =  math.random(0,5)
	VorpInv.addItem(_source, _item, randomitem)
	TriggerClientEvent("vorp:TipRight", _source, item, 3000)
end)