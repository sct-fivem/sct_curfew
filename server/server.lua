ESX = nil

Zones = {}

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent("sct_curfew:Req:CreateZone", function(data)
    local _source = source

    local _id = tostring(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)

    Zones[_id] = {}
    Zones[_id].id = _id
    Zones[_id].readyEnter = false
    Zones[_id].whoCreate = xPlayer.getName()
    Zones[_id].startTime = os.date("%c")
    Zones[_id].endTime = os.date("%c", os.time() + 20)
    Zones[_id].streetName = data.streetName
    Zones[_id].coords = data.coords

    TriggerClientEvent("sct_curfew:Res:CreateZone", -1, Zones[_id])
end)

RegisterNetEvent("sct_curfew:Req:RemoveZone", function(id)
    local _source = source
    if Zones[id] then
        Zones[id] = nil
        TriggerClientEvent("sct_curfew:Res:RemoveZone", -1, id)
    end
end)

RegisterNetEvent("sct_curfew:Req:SyncZone", function()
    local _source = source
    TriggerClientEvent("sct_curfew:Res:SyncZone", _source, Zones)
end)

RegisterNetEvent("sct_curfew:Req:UpdateZone", function(id)
    local _source = source
    if Zones[id] and not Zones[id].readyEnter then
        Zones[id].readyEnter = true
        TriggerClientEvent("sct_curfew:Res:UpdateZone", -1, id)
    end
end)

