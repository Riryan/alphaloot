local collected, active = false, false
local skinnable = true
local skinPrompt , pickupPrompt
local skingroup = promptgroup
local prompt, prompt2  =  false, false

Citizen.CreateThread(function()
	SetupskinPrompt() 
	--SetuppickupPrompt()

    while true do
	Wait(0)
	local player = PlayerPedId()
	local coords = GetEntityCoords(player)
	local entityHit = 0
	local shapeTest = StartShapeTestBox(coords.x, coords.y, coords.z, 2.0, 2.0, 2.0, 0.0, 0.0, 0.0, true, 10, player)
	local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
	local type = GetPedType(entityHit)
	local dead = IsEntityDead(entityHit)
	local entity = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
	local model = GetEntityModel(entityHit)
	local quality = Citizen.InvokeNative(0x7BCC6087D130312A,  entityHit) 

	if type == 28 and not IsPedInAnyVehicle(player, true) then
			for i, row in pairs(Animal)do	
				if skinnable and dead then
					if model == Animal[i]["model"] then
						PromptSetEnabled(skinPrompt, true) --skinning prompt
						PromptSetVisible(skinPrompt, true)
						--PromptSetEnabled(pickupPrompt, true) --pickup prompt disabled for now
						--PromptSetVisible(pickupPrompt, true)
						if PromptHasHoldModeCompleted(skinPrompt) then 
								PromptSetEnabled(skinPrompt, false)
								PromptSetVisible(skinPrompt, false)
								PromptSetEnabled(pickupPrompt, false)
								PromptSetVisible(pickupPrompt, false)
								AnimLooting()
								TriggerServerEvent("loot:addxp", 20) -- once there is a Cores system then this needs to be changed to DeadEye

							if quality == 0 then 
								TriggerServerEvent("loot:add", Animal[i]["item"]) -- should be basic Item
							elseif quality == 1 then
								TriggerServerEvent("loot:add", Animal[i]["item"])
								qualityHide1 = Animal[i]["poor"] -- modelHASH
								local object1 = CreateObject(qualityHide1, coords.x -1, coords.y -1, coords.z, true, true, false)
								--local object1 = CreatePortablePickup(pickupHash, coords.x, coords.y, coords.z, 0, quality1)
								--AttachPortablePickupToPed(object1, player)
								--PlaceObjectOnGroundProperly(object1)

								print("Hide 1", qualityHide1)
							elseif quality == 2 then
								TriggerServerEvent("loot:add", Animal[i]["item"])
								TriggerServerEvent("loot:add", Animal[i]["item2"])
								qualityHide2 = Animal[i]["good"]
								local object2 = CreateObject(qualityHide2, coords.x -1, coords.y -1, coords.z, true, true, false)
								--local object2 = CreatePortablePickup(pickupHash, coords.x, coords.y, coords.z, 0, quality2)
								--PlaceObjectOnGroundProperly(object2)

								print("hide 2", qualityHide2)
							elseif quality == 3 then
								TriggerServerEvent("loot:add", Animal[i]["item"])
								TriggerServerEvent("loot:add", Animal[i]["item2"])									
								qualityHide3 =  Animal[i]["perfect"]
								local object3 = CreateObject(qualityHide3, coords.x -1, coords.y -1, coords.z, true, true, false)
								--local object3 = CreatePortablePickup(pickupHash, coords.x, coords.y, coords.z, 0, quality3)
								--PlaceObjectOnGroundProperly(object3)
								--TaskPickupCarriableEntity(player,object3)

								print("hide 3", qualityHide3)
							end
							SetEntityAsMissionEntity(entityHit)
							DeleteEntity(entityHit)  
							carcuss = Animal[i]["carcuss"]
							Citizen.CreateThread(function()
							    local object = CreateObject(carcuss, coords.x +1, coords.y +1, coords.z, true, true, false)
									PlaceObjectOnGroundProperly(object)
									Citizen.Wait(20000)
									DeleteObject(object)
							end)
							prompt,prompt2 = false, false
							break
						end
						--start of pickup
						if PromptHasHoldModeCompleted(pickPrompt) then
							PromptSetEnabled(skinPrompt, false)
							PromptSetVisible(skinPrompt, false)
							PromptSetEnabled(pickupPrompt, false)
							PromptSetVisible(pickupPrompt, false)
							print("pickup carcass")
						end
					end
				end
			end
		end
	end
end)


function AnimLooting()-- do cleaner anims 

	TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true, false, false, false)
	Wait(2000) -- it doesnt work?
	TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('MECH_SKIN@DEER@DRESS_FIELD_MG2'), 10000, true, false, false, false)	--mech_skin@deer@dress_field_mg2
	Wait(2000)
	TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_STAND_WAITING'), 10000, true, false, false, false)
	Wait(2000)
	ClearPedTasksImmediately(PlayerPedId())
end

function SetupskinPrompt()
	Citizen.CreateThread(function()
        local str = 'SKIN'
		skinPrompt = PromptRegisterBegin()
		PromptSetGroup(promptgroup)
        PromptSetControlAction(skinPrompt, 0xDFF812F9) --[[E]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(skinPrompt, str)
        PromptSetEnabled(skinPrompt, false)
        PromptSetVisible(skinPrompt, false)
        PromptSetHoldMode(skinPrompt, true)
		PromptRegisterEnd(skinPrompt)
    end)
end
-- kinda useless once its gutted and skinned
function SetuppickupPrompt()
	Citizen.CreateThread(function()
        local str = 'PICKUP'
		pickupPrompt = PromptRegisterBegin()
		PromptSetGroup(promptgroup)
        PromptSetControlAction(pickupPrompt, 0xE30CD707)--[[R]]
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(pickupPrompt, str)
        PromptSetEnabled(pickupPrompt, false)
        PromptSetVisible(pickupPrompt, false)
        PromptSetHoldMode(pickupPrompt, true)
        PromptRegisterEnd(pickupPrompt)
    end)
end

-- if Need be I can add a trapper-butcher NPC to this
TaskPickupCarriableEntity(	ped --[[ Ped ]], 	entity --[[ Entity ]])