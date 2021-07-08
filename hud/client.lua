vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP","hud")
vRPhud = Tunnel.getInterface("hud","hud")
vRPhudC = {}
Tunnel.bindInterface("hud",vRPhudC)
vRPserver = Tunnel.getInterface("hud","hud")


local hudInchis = false
local isPauseMenu = false
CreateThread(function()
    while true do 
        Wait(2000)
        if hudInchis == false and not isPauseMenu then
            vRPserver.getInfoAboutHud({})
        end
    end
end)

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function vRPhudC.sendInformationsAboutHud(id,users,maxSlots,money,bankmoney)
    SendNUIMessage({
        action = "deschideHud",
        id = id,
        users = users,
        maxslots = maxSlots,
        money = comma_value(money),
        bankmoney = comma_value(bankmoney)
    })
end

-- SAFEZONE

local aparut = false

local safezones = {
    {-44.322448730469,-1099.0786132813,26.422380447388, 30}
}

CreateThread(function()
    while true do
        Wait(350)
        for k,v in pairs(safezones) do
            if(GetDistanceBetweenCoords(v[1],v[2],v[3], GetEntityCoords(GetPlayerPed(-1))) < v[4])then
                if aparut == false then
                    aparut = true
                    SendNUIMessage({
                        action = "safezone",
                        stil = 'block'
                    })
                end
            else
                if aparut == true then
                    aparut = false
                    SendNUIMessage({
                        action = "safezone",
                        stil = 'none'
                    })
                end
            end
        end
    end
end)


voiceEnabled = true

Citizen.CreateThread(function()

	    RequestAnimDict('facials@gen_male@variations@normal')
	    RequestAnimDict('mp_facial')

	    while true do
	        Citizen.Wait(300)
	        local playerID = PlayerId()

	        for _,player in ipairs(GetActivePlayers()) do
	            local boolTalking = NetworkIsPlayerTalking(player)

	            if player ~= playerID then
	                if boolTalking then
	                    PlayFacialAnim(GetPlayerPed(player), 'mic_chatter', 'mp_facial')
	                elseif not boolTalking then
	                    PlayFacialAnim(GetPlayerPed(player), 'mood_normal_1', 'facials@gen_male@variations@normal')
	                end
                end
                SendNUIMessage({
                    action = "voicechat",
                    toggle = boolTalking
                })
	        end
	    end


end)



-- VEHICLE

local time = 500
local invehicle = false
local seatbelt = 0

local prevSpeed = 0
local currSpeed = 0
local seatbeltEjectSpeed = 110.0
local seatbeltEjectAccel = 80.0  


function IsCar(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
  end	

CreateThread(function()
    while GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= nil do
        Wait(time)
        if GetVehiclePedIsIn(PlayerPedId()) ~= 0 and IsCar(GetVehiclePedIsIn(PlayerPedId())) then
            Wait(0)
            time = 150
            SendNUIMessage({
                action = "carhud",
                toggle = 1,
                viteza = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6),
                fuel = math.ceil(GetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId()))),
                seatbelt = seatbelt
            })
        else
            time = 500
            seatbelt = 0
            SendNUIMessage({
                action = "carhud",
                toggle = 0
            })
        end
    end
end)



CreateThread(function()
    while true  do
        Wait(0)
        if GetVehiclePedIsIn(PlayerPedId()) ~= 0 and IsCar(GetVehiclePedIsIn(PlayerPedId())) and IsControlJustReleased(0,51) then    
            if seatbelt == 0 then
                seatbelt = 1
            else 
                seatbelt = 0
            end
        end
        if GetVehiclePedIsIn(PlayerPedId()) ~= 0 and IsCar(GetVehiclePedIsIn(PlayerPedId())) then
            if seatbelt == 1 then
                DisableControlAction(0, 75)
            end   

            local player = GetPlayerPed(-1)
            local position = GetEntityCoords(player)
            local vehicle = GetVehiclePedIsIn(player, false)

            local prevSpeed = currSpeed
            currSpeed = GetEntitySpeed(vehicle)
            if seatbelt == 0 then
                vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()           
                if (vehIsMovingFwd and (prevSpeed*3.6 > (seatbeltEjectSpeed)) and (vehAcc > (seatbeltEjectAccel*7.20))) then           
                    SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                    SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                else
                    prevVelocity = GetEntityVelocity(vehicle)
                end
            end
        end
    end
end)


Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)

		if IsPauseMenuActive() then
			if not isPauseMenu then
				isPauseMenu = not isPauseMenu
                SendNUIMessage({ action = 'hud', value = 'none' })
			end
		else
			if isPauseMenu then
				isPauseMenu = not isPauseMenu
                SendNUIMessage({ action = 'hud', value = 'block' })
			end
		end
	end
end)