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
    lib.registerContext({
        id = 'hud_menu',
        title = 'BT PvP HUD',
        options = {
            {
                title = 'Presunout HUD',
                description = 'Klikni a tahni HUD levym tlacitkem. Pravym tlacitkem pozici ulozis.',
                icon = 'arrows-up-down-left-right',
                onSelect = function()
                    SendNUIMessage({ action = 'enterMoveMode' })
                    SetNuiFocus(true, true)
                end
            },
            {
                title = 'Velikost',
                description = 'Aktualni: ' .. hudScale .. '%',
                icon = 'maximize',
                onSelect = function()
                    local input = lib.inputDialog('Nastaveni velikosti', {
                        { 
                            type = 'slider', 
                            label = 'Meritko HUDu v %', 
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
                description = 'Resetovat pozici a velikost',
                icon = 'rotate-left',
                onSelect = function()
                    hudPosition = { x = nil, y = 30 }
                    hudScale = 100
                    SendNUIMessage({ action = 'resetAll', scale = 100 })
                    lib.notify({ description = 'Resetovano', type = 'success' })
                end
            },
            {
                title = hudVisible and 'Skryt HUD' or 'Zobrazit HUD',
                description = 'Zapne nebo vypne zobrazeni HUDu',
                icon = hudVisible and 'eye-slash' or 'eye',
                onSelect = function()
                    hudVisible = not hudVisible
                    SendNUIMessage({ action = 'toggleHUD', visible = hudVisible })
                end
            }
        }
    })
    lib.showContext('hud_menu')
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