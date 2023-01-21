ESX = nil
Zones = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    TriggerServerEvent("sct_curfew:Req:SyncZone")
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        ESX.PlayerData.playerPed = PlayerPedId()
        ESX.PlayerData.playerCoords = GetEntityCoords(ESX.PlayerData.playerPed)
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 5000
        for key, value in pairs(Zones) do
            local dist = #(vector3(value.coords.x, value.coords.y, value.coords.z) - ESX.PlayerData.playerCoords)
            if dist <= 300 then
                sleep = 5
                if value.readyEnter then
                    DrawMarker(28, value.coords.x, value.coords.y, value.coords.z, 0, 0, 0, 0, 0, 0, Config.Zones.Radius, Config.Zones.Radius, Config.Zones.Radius, 255, 0, 0, 120, 255, 120, 155, 0)
                else
                    DrawMarker(28, value.coords.x, value.coords.y, value.coords.z, 0, 0, 0, 0, 0, 0, Config.Zones.Radius, Config.Zones.Radius, Config.Zones.Radius, 0, 255, 0, 120, 255, 120, 155, 0)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function ReqGetZone()
    return Zones
end

function ReqCreateZone()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local streetIndex = GetZoneAtCoords(playerCoords)
    local streetName = GetNameOfZone(streetIndex)

    local data = {
        streetName = streetName,
        coords = playerCoords
    }

    TriggerServerEvent("sct_curfew:Req:CreateZone", data)
end

function ResCreateZone(data)
    Zones[data.id] = {}
    Zones[data.id] = data

    Zones[data.id].blipsRadius = AddBlipForRadius(data.coords.x, data.coords.y, data.coords.z, Config.Zones.Radius)
    SetBlipColour(Zones[data.id].blipsRadius, 2)
    SetBlipAlpha(Zones[data.id].blipsRadius, 100)
    
    SendNUIMessage({
        action = "CREATE_ZONES",
        data = data
    })
end

function ReqSyncZone()
    TriggerServerEvent("sct_curfew:Req:SyncZone")
end

function ResSyncZone(data)
    for key, value in pairs(data) do
        Zones[value.id] = {}
        Zones[value.id] = value
        Zones[value.id].blipsRadius = AddBlipForRadius(value.coords.x, value.coords.y, value.coords.z,
            Config.Zones.Radius)
        if Zones[value.id].readyEnter then
            SetBlipColour(Zones[value.id].blipsRadius, 1)
        else
            SetBlipColour(Zones[value.id].blipsRadius, 2)
        end

        SetBlipAlpha(Zones[value.id].blipsRadius, 100)
    end

    SendNUIMessage({
        action = "SYNC_ZONES",
        data = data
    })

end

function ReqRemoveZone(id)
    if Zones[id] then
        TriggerServerEvent("sct_curfew:Req:RemoveZone", id)
    end
end

function ResRemoveZone(id)
    if Zones[id] then
        RemoveBlip(Zones[id].blipsRadius)
        SendNUIMessage({
            action = "REMOVE_ZONES",
            data = {
                id = id
            }
        })
        Zones[id] = nil
    end
end

function ReqUpdateZone(id)
    TriggerServerEvent("sct_curfew:Req:UpdateZone", id)
end

function ResUpdateZone(id)
    Zones[id].readyEnter = true
    SetBlipColour(Zones[id].blipsRadius, 1)
end

function ActionCoolDown(data, cb)
    TriggerServerEvent("sct_curfew:Req:UpdateZone", data.id)
    cb("OK")
end

RegisterNetEvent("sct_curfew:Res:CreateZone", ResCreateZone)
RegisterNetEvent("sct_curfew:Res:SyncZone", ResSyncZone)
RegisterNetEvent("sct_curfew:Res:RemoveZone", ResRemoveZone)
RegisterNetEvent("sct_curfew:Res:UpdateZone", ResUpdateZone)

RegisterNUICallback("ActionCoolDown", ActionCoolDown)

if Config.Debug then
    RegisterCommand("get_zone", function()
        print(json.encode(ReqGetZone()))
        for key, value in pairs(ReqGetZone()) do
            print("key = " .. key)
            print("value = " .. json.encode(value))
        end
    end, false)

    RegisterCommand("add_zone", function()
        ReqCreateZone()
    end, false)

    RegisterCommand("remove_zone", function(source, args, rawCommand)
        if Zones[args[1]] then
            ReqRemoveZone(tostring(args[1]))
        end
    end)

    RegisterCommand("sync_zone", function(source, args, rawCommand)
        ReqSyncZone()
    end)
end
