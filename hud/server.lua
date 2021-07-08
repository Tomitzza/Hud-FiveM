local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","hud")
vRPChud = Tunnel.getInterface("hud","hud")
vRPhud = {}
Tunnel.bindInterface("hud",vRPhud)
Proxy.addInterface("hud",vRPhud)

local maxSlots = 128

function vRPhud.getInfoAboutHud()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    if user_id ~= nil then
        local money = vRP.getMoney({user_id})
        local bankmoney = vRP.getBankMoney({user_id})
        local useriOn = vRP.getUsers()
        id = user_id
        countJucatori = 0
        for k,v in pairs(useriOn) do
            countJucatori = countJucatori + 1
        end
        vRPChud.sendInformationsAboutHud(player,{id,countJucatori,maxSlots,money,bankmoney})
    end
end