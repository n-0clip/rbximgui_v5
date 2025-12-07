local Arsenal = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local banner = [[
 __   .__.__  .__   _____                 .___
|  | _|__|  | |  |_/ ____\____   ____   __| _/
|  |/ /  |  | |  |\   __\/ __ \_/ __ \ / __ | 
|    <|  |  |_|  |_|  | \  ___/\  ___// /_/ | 
|__|_ \__|____/____/__|  \___  >\___  >____ | 
     \/                      \/     \/     \/ 
]]

Arsenal.Core = nil
Arsenal.Loops = {}

Arsenal.Settings = {
    NoRecoil = false,
    NoSpread = false,
    RapidFire = false,
    InfAmmo = false,
    KillAll = false
}

function Arsenal.NoRecoil(enabled)
    Arsenal.Settings.NoRecoil = enabled
    
    if Arsenal.Loops.NoRecoil then
        Arsenal.Loops.NoRecoil:Disconnect()
        Arsenal.Loops.NoRecoil = nil
    end
    
    if enabled then
        Arsenal.Loops.NoRecoil = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Arsenal.Core.GetCurrentGun()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v:IsA("NumberValue") and v.Name:lower():find("recoil") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end)
    end
end

function Arsenal.NoSpread(enabled)
    Arsenal.Settings.NoSpread = enabled
    
    if Arsenal.Loops.NoSpread then
        Arsenal.Loops.NoSpread:Disconnect()
        Arsenal.Loops.NoSpread = nil
    end
    
    if enabled then
        Arsenal.Loops.NoSpread = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Arsenal.Core.GetCurrentGun()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v:IsA("NumberValue") and v.Name:lower():find("spread") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end)
    end
end

function Arsenal.RapidFire(enabled)
    Arsenal.Settings.RapidFire = enabled
    
    if Arsenal.Loops.RapidFire then
        Arsenal.Loops.RapidFire:Disconnect()
        Arsenal.Loops.RapidFire = nil
    end
    
    if enabled then
        Arsenal.Loops.RapidFire = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Arsenal.Core.GetCurrentGun()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v:IsA("NumberValue") and (v.Name:lower():find("firerate") or v.Name:lower():find("fire")) then
                            v.Value = 0
                        end
                    end
                end
            end)
        end)
    end
end

function Arsenal.InfAmmo(enabled)
    Arsenal.Settings.InfAmmo = enabled
    
    if Arsenal.Loops.InfAmmo then
        Arsenal.Loops.InfAmmo:Disconnect()
        Arsenal.Loops.InfAmmo = nil
    end
    
    if enabled then
        Arsenal.Loops.InfAmmo = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Arsenal.Core.GetCurrentGun()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v:IsA("NumberValue") and v.Name:lower():find("ammo") then
                            v.Value = 999
                        end
                    end
                end
            end)
        end)
    end
end

function Arsenal.Init(Core)
    Arsenal.Core = Core
end

function Arsenal.Cleanup()
    for _, conn in pairs(Arsenal.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    Arsenal.Loops = {}
end

return Arsenal
