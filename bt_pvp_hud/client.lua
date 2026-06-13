local hudVisible = true
local hudPosition = { x = nil, y = 30 }
local hudScale = 100

RegisterNUICallback('getPosition', function(_, cb) cb(hudPosition) end)
RegisterNUICallback('savePosition', function(data, cb) hudPosition = { x = data.x, y = data.y } cb('ok') end)
RegisterNUICallback('getScale', function(_, cb) cb(hudScale) end)
RegisterNUICallback('saveScale', function(data, cb) hudScale = data.scale cb('ok') end)

function SendHUDData()
    local health = GetEntityHealth(PlayerPedId()) - 100
    local armor = GetPedArmour(PlayerPedId())
    if health < 0 then health = 0 elseif health > 100 then health = 100 end
    if armor < 0 then armor = 0 elseif armor > 100 then armor = 100 end
    SendNUIMessage({ action = 'updateHUD', health = health, armor = armor })
end

RegisterCommand('togglehud', function()
    hudVisible = not hudVisible
    SendNUIMessage({ action = 'toggleHUD', visible = hudVisible })
end)

RegisterCommand('hud', function()
    exports.ox_lib:registerContext({
        id = 'hud_menu',
        title = 'BT PvP HUD',
        options = {
            {
                title = 'Move HUD',
                description = 'Click and drag HUD with left click. Right click to save position.',
                icon = 'arrows-up-down-left-right',
                onSelect = function()
                    SendNUIMessage({ action = 'enterMoveMode' })
                    SetNuiFocus(true, true)
                end
            },
            {
                title = 'Scale',
                description = string.format('Current: %s%%', hudScale),
                icon = 'maximize',
                onSelect = function()
                    local input = exports.ox_lib:inputDialog('Scale Settings', {
                        { 
                            type = 'slider', 
                            label = 'HUD scale in %', 
                            default = hudScale, 
                            min = 50, 
                            max = 150, 
                            step = 5 
                        }
                    })
                    
                    if input and input[1] then
                        hudScale = input[1]
                        SendNUIMessage({ action = 'updateScale', scale = hudScale })
                    end
                end
            },
            {
                title = 'Reset',
                description = 'Reset position and scale',
                icon = 'rotate-left',
                onSelect = function()
                    hudPosition = { x = nil, y = 30 }
                    hudScale = 100
                    SendNUIMessage({ action = 'resetAll', scale = 100 })
                    exports.ox_lib:notify({ description = 'Reset successful', type = 'success' })
                end
            },
            {
                title = hudVisible and 'Hide HUD' or 'Show HUD',
                description = 'Toggle HUD visibility on screen',
                icon = hudVisible and 'eye-slash' or 'eye',
                onSelect = function()
                    hudVisible = not hudVisible
                    SendNUIMessage({ action = 'toggleHUD', visible = hudVisible })
                end
            }
        }
    })
    exports.ox_lib:showContext('hud_menu')
end)

RegisterNUICallback('disableFocus', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        if hudVisible then SendHUDData() end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DisplayRadar(false)
        HideMinimapInteriorMapThisFrame()
        SetRadarBigmapEnabled(false, false)
    end
end)

RegisterNetEvent('esx:playerLoaded', function() SendNUIMessage({ action = 'show' }) end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if NetworkIsPlayerActive(PlayerId()) then
            SendNUIMessage({ action = 'show' })
            break
        end
    end
end)