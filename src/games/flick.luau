local Flick = {}

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

Flick.Core = nil
Flick.Loops = {}

Flick.Settings = {
    NoRecoil = false,
    NoSpread = false,
    RapidFire = false,
    InfAmmo = false,
    NoSway = false
}

function Flick.NoRecoil(enabled)
    Flick.Settings.NoRecoil = enabled
    
    if Flick.Loops.NoRecoil then
        Flick.Loops.NoRecoil:Disconnect()
        Flick.Loops.NoRecoil = nil
    end
    
    if enabled then
        Flick.Loops.NoRecoil = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Flick.Core.GetCurrentGun()
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

function Flick.NoSpread(enabled)
    Flick.Settings.NoSpread = enabled
    
    if Flick.Loops.NoSpread then
        Flick.Loops.NoSpread:Disconnect()
        Flick.Loops.NoSpread = nil
    end
    
    if enabled then
        Flick.Loops.NoSpread = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Flick.Core.GetCurrentGun()
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

function Flick.RapidFire(enabled)
    Flick.Settings.RapidFire = enabled
    
    if Flick.Loops.RapidFire then
        Flick.Loops.RapidFire:Disconnect()
        Flick.Loops.RapidFire = nil
    end
    
    if enabled then
        Flick.Loops.RapidFire = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Flick.Core.GetCurrentGun()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v:IsA("NumberValue") and v.Name:lower():find("fire") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end)
    end
end

function Flick.InfAmmo(enabled)
    Flick.Settings.InfAmmo = enabled
    
    if Flick.Loops.InfAmmo then
        Flick.Loops.InfAmmo:Disconnect()
        Flick.Loops.InfAmmo = nil
    end
    
    if enabled then
        Flick.Loops.InfAmmo = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Flick.Core.GetCurrentGun()
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

function Flick.NoSway(enabled)
    Flick.Settings.NoSway = enabled
    
    if Flick.Loops.NoSway then
        Flick.Loops.NoSway:Disconnect()
        Flick.Loops.NoSway = nil
    end
    
    if enabled then
        Flick.Loops.NoSway = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Flick.Core.GetCurrentGun()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v:IsA("NumberValue") and v.Name:lower():find("sway") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end)
    end
end

function Flick.Init(Core)
    Flick.Core = Core
end

function Flick.Cleanup()
    for _, conn in pairs(Flick.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    Flick.Loops = {}
end

return Flick
