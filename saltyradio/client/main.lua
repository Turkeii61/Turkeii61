local ESX = nil
local radioMenu = false

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(50)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:setJob", function(job)
    ESX.PlayerData.job = job
end)

function enableRadio(enable)
    SetNuiFocus(true, true)
    radioMenu = enable

    SendNUIMessage({
        action = "show",
        state = enable
    })
end

RegisterNetEvent("openradio2", function()
    enableRadio(true)
end)

RegisterKeyMapping("openradio2", "Funkgerät öffnen", "keyboard", "F1")

RegisterNUICallback("joinRadio",function(data, cb)
    local getPlayerRadioChannel = exports['saltychat']:GetRadioChannel(true)
    local playerJob = ESX.GetPlayerData().job

    if playerJob == nil or playerJob.name == nil then
        return
    end

    if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
        exports['saltychat']:SetRadioChannel(tonumber(data.channel), true)

        SendNUIMessage({
            action = "changeChannel",
            value = tonumber(data.channel)
        })

        SendNUIMessage({
            action = "addHistory",
            channel = tonumber(data.channel)
        })
    end

    cb("ok")
end)

RegisterNUICallback("leaveRadio",function(data, cb)
    local playerName = GetPlayerName(PlayerId())
    local getPlayerRadioChannel = exports['saltychat']:GetRadioChannel(true)

    if getPlayerRadioChannel == nil or getPlayerRadioChannel == "" then
    else
        exports['saltychat']:SetRadioChannel("", true)
        SendNUIMessage({
            action = "changeChannel",
            value = -1
        })
    end

    cb("ok")
end)

RegisterNUICallback("escape", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNetEvent("saltyradio:use", function()
    enableRadio(true)
end)

RegisterCommand("openradio2", function(source, args, rawCmd)
    enableRadio(true)
end)

RegisterNetEvent("saltyradio:onRadioDrop", function(source)
    local playerName = GetPlayerName(source)
    local getPlayerRadioChannel = exports['saltychat']:GetRadioChannel(true)

    if getPlayerRadioChannel ~= "" then
        exports['saltychat']:SetRadioChannel("", true)
        
        SendNUIMessage({
            action = "changeChannel",
            value = -1
        })
    end
end)