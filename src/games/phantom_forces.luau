local PhantomForces = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local banner = [[
 __   .__.__  .__   _____                 .___
|  | _|__|  | |  |_/ ____\____   ____   __| _/
|  |/ /  |  | |  |\   __\/ __ \_/ __ \ / __ | 
|    <|  |  |_|  |_|  | \  ___/\  ___// /_/ | 
|__|_ \__|____/____/__|  \___  >\___  >____ | 
     \/                      \/     \/     \/ 
]]

PhantomForces.Core = nil
PhantomForces.Loops = {}

PhantomForces.Settings = {
    NoRecoil = false,
    NoSpread = false,
    NoSway = false,
    InfAmmo = false,
    RapidFire = false,
    NoFlash = false,
    FullAuto = false
}

function PhantomForces.GetGunModule()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    local gun = char:FindFirstChildOfClass("Tool")
    if not gun then return nil end
    
    return gun
end

function PhantomForces.NoRecoil(enabled)
    PhantomForces.Settings.NoRecoil = enabled
    
    if PhantomForces.Loops.NoRecoil then
        PhantomForces.Loops.NoRecoil:Disconnect()
        PhantomForces.Loops.NoRecoil = nil
    end
    
    if enabled then
        PhantomForces.Loops.NoRecoil = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = PhantomForces.GetGunModule()
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

function PhantomForces.NoSpread(enabled)
    PhantomForces.Settings.NoSpread = enabled
    
    if PhantomForces.Loops.NoSpread then
        PhantomForces.Loops.NoSpread:Disconnect()
        PhantomForces.Loops.NoSpread = nil
    end
    
    if enabled then
        PhantomForces.Loops.NoSpread = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = PhantomForces.GetGunModule()
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

function PhantomForces.NoSway(enabled)
    PhantomForces.Settings.NoSway = enabled
    
    if PhantomForces.Loops.NoSway then
        PhantomForces.Loops.NoSway:Disconnect()
        PhantomForces.Loops.NoSway = nil
    end
    
    if enabled then
        PhantomForces.Loops.NoSway = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = PhantomForces.GetGunModule()
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

function PhantomForces.InfAmmo(enabled)
    PhantomForces.Settings.InfAmmo = enabled
    
    if PhantomForces.Loops.InfAmmo then
        PhantomForces.Loops.InfAmmo:Disconnect()
        PhantomForces.Loops.InfAmmo = nil
    end
    
    if enabled then
        PhantomForces.Loops.InfAmmo = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = PhantomForces.GetGunModule()
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

function PhantomForces.RapidFire(enabled)
    PhantomForces.Settings.RapidFire = enabled
    
    if PhantomForces.Loops.RapidFire then
        PhantomForces.Loops.RapidFire:Disconnect()
        PhantomForces.Loops.RapidFire = nil
    end
    
    if enabled then
        PhantomForces.Loops.RapidFire = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = PhantomForces.GetGunModule()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v:IsA("NumberValue") and (v.Name:lower():find("firerate") or v.Name:lower():find("rpm")) then
                            v.Value = 9999
                        end
                    end
                end
            end)
        end)
    end
end

function PhantomForces.NoFlash(enabled)
    PhantomForces.Settings.NoFlash = enabled
    
    if enabled then
        pcall(function()
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, v in pairs(playerGui:GetDescendants()) do
                    if v.Name:lower():find("flash") or v.Name:lower():find("blind") then
                        if v:IsA("GuiObject") then
                            v.Visible = false
                        end
                    end
                end
            end
        end)
    end
end

function PhantomForces.FullAuto(enabled)
    PhantomForces.Settings.FullAuto = enabled
    
    if PhantomForces.Loops.FullAuto then
        PhantomForces.Loops.FullAuto:Disconnect()
        PhantomForces.Loops.FullAuto = nil
    end
    
    if enabled then
        PhantomForces.Loops.FullAuto = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = PhantomForces.GetGunModule()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v:IsA("StringValue") and v.Name:lower():find("firemode") then
                            v.Value = "Auto"
                        end
                        if v:IsA("BoolValue") and v.Name:lower():find("auto") then
                            v.Value = true
                        end
                    end
                end
            end)
        end)
    end
end

function PhantomForces.Init(Core)
    PhantomForces.Core = Core
end

function PhantomForces.Cleanup()
    for _, conn in pairs(PhantomForces.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    PhantomForces.Loops = {}
end

return PhantomForces
