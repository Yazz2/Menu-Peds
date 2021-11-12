ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

-- Menu --
local open = false
local main = RageUI.CreateMenu("Menu Peds", "Intéractions disponibles")
local PedMenu = RageUI.CreateSubMenu(main, "Peds", "Intéractions disponibles")
local AddonMenu = RageUI.CreateSubMenu(main, "AddonPeds", "Intéractions disponibles")
main.Display.Header = true
main.Closed = function()
    open = false
end

function OpenMenuPed() 
    if open then 
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        RageUI.Visible(main, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(main, function()

                    RageUI.Checkbox("Ouvrir | Fermer du Menu Peds", false, Config.ouvert, {}, {
                        onChecked = function()
                            ouvert = true 
                        end,
                        onUnChecked = function()
                            ouvert = false
                        end,
                        onSelected = function(Index)
                            Config.ouvert = Index
                        end
                    }) 
                    if ouvert then
                        RageUI.Separator("↓     ~b~Reprendre son apparence~s~    ↓")
                        RageUI.Button("Redevenir Normal", false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                    local isMale = skin.sex == 0
                                    TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                            TriggerEvent('skinchanger:loadSkin', skin)
                                        end)
                                    end)
                                end)
                            end
                        })
                        RageUI.Separator("↓     ~g~Peds     ~s~↓")

                        RageUI.Button("AddonPeds", "⚠️ ~r~si vous vous mettez en ped vous n'aurai plus d'arme(s)", {RightLabel = "→→"}, true, {}, AddonMenu)
                        RageUI.Button("Peds", "⚠️ ~r~si vous vous mettez en ped vous n'aurai plus d'arme(s)", {RightLabel = "→→"}, true, {}, PedMenu)

                        
                        RageUI.Button("Fermer", nil, {Color = {BackgroundColor = {255, 0, 0, 50}}, RightLabel = "→→"}, true , {
                            onSelected = function()
                                RageUI.CloseAll()
                            end
                        })
                    end
                end)

                RageUI.IsVisible(PedMenu, function()
                    
                    RageUI.Separator("↓ ~b~Liste des peds~s~ ↓")
                    for k,v in pairs(Config.PedMenu) do
                        RageUI.Button(v.label, false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local Ped = GetHashKey(v.hash)
                                RequestModel(Ped)
                                while not HasModelLoaded(Ped) do
                                    Wait(100)
                                end
                                SetPlayerModel(PlayerId(), Ped)
                                SetModelAsNoLongerNeeded(Ped)
                            end
                        })
                    end
                    
                    RageUI.Separator("     ~b~...     ~s~")
                   

                    
                    RageUI.Button("Fermer", nil, {Color = {BackgroundColor = {255, 0, 0, 50}}, RightLabel = "→→"}, true , {
                        onSelected = function()
                            RageUI.CloseAll()
                        end
                    })
                end)

                RageUI.IsVisible(AddonMenu, function()
                    RageUI.Separator("↓ ~y~Liste des Peds Addons~s~ ↓")
                    for k,v in pairs(Config.AddonPedMenu) do
                        RageUI.Button(v.label, false, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local Ped = GetHashKey(v.hash)
                                RequestModel(Ped)
                                while not HasModelLoaded(Ped) do
                                    Wait(100)
                                end
                                SetPlayerModel(PlayerId(), Ped)
                                SetModelAsNoLongerNeeded(Ped)
                            end
                        })
                    end

                       RageUI.Separator("     ~b~...     ~s~")


                    
                    RageUI.Button("Fermer", nil, {Color = {BackgroundColor = {255, 0, 0, 50}}, RightLabel = "→→"}, true , {
                        onSelected = function()
                            RageUI.CloseAll()
                        end
                    })
                end)
            Wait(0)
            end
        end)
    end
end





Keys.Register('F7','F7', 'Menu Personnel ', function()
    OpenMenuPed()
end)

RegisterCommand("menuped", function()

    OpenMenuPed()

end, false)