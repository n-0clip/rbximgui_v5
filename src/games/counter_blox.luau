local CounterBlox = {}

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

CounterBlox.Core = nil
CounterBlox.Loops = {}

CounterBlox.Settings = {
    NoSpread = false,
    NoRecoil = false,
    RapidFire = false,
    InfAmmo = false,
    BHop = false,
    BHopSpeed = 20,
    Spinbot = false,
    SpinSpeed = 50,
    ThirdPerson = false,
    ThirdPersonDistance = 10
}

function CounterBlox.NoSpread(enabled)
    CounterBlox.Settings.NoSpread = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local spread = weapon:FindFirstChild("Spread")
        if spread then
            if enabled then
                spread.Value = 0
            end
        end
    end
end

function CounterBlox.NoRecoil(enabled)
    CounterBlox.Settings.NoRecoil = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local recoil = weapon:FindFirstChild("Recoil")
        local camRecoil = weapon:FindFirstChild("CamRecoil")
        local kickBack = weapon:FindFirstChild("KickBack")
        
        if recoil and enabled then recoil.Value = 0 end
        if camRecoil and enabled then camRecoil.Value = 0 end
        if kickBack and enabled then kickBack.Value = 0 end
    end
end

function CounterBlox.RapidFire(enabled)
    CounterBlox.Settings.RapidFire = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local fireRate = weapon:FindFirstChild("FireRate")
        if fireRate and enabled then
            fireRate.Value = 0
        end
    end
end

function CounterBlox.InfAmmo(enabled)
    CounterBlox.Settings.InfAmmo = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local ammo = weapon:FindFirstChild("Ammo")
        local storedAmmo = weapon:FindFirstChild("StoredAmmo")
        
        if ammo then ammo.Value = 999999 end
        if storedAmmo then storedAmmo.Value = 999999 end
    end
end

function CounterBlox.BHop(enabled)
    CounterBlox.Settings.BHop = enabled
    
    if CounterBlox.Loops.BHop then
        CounterBlox.Loops.BHop:Disconnect()
        CounterBlox.Loops.BHop = nil
    end
    
    if enabled then
        CounterBlox.Loops.BHop = RunService.RenderStepped:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) and CounterBlox.Core.IsAlive(LocalPlayer) then
                local char = LocalPlayer.Character
                local hum = char:FindFirstChild("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                
                if hum and hrp then
                    hum.Jump = true
                    local moveDirection = hrp.CFrame.LookVector * CounterBlox.Settings.BHopSpeed
                    hrp.Velocity = Vector3.new(moveDirection.X, hrp.Velocity.Y, moveDirection.Z)
                end
            end
        end)
    end
end

function CounterBlox.Spinbot(enabled)
    CounterBlox.Settings.Spinbot = enabled
    
    if CounterBlox.Loops.Spinbot then
        CounterBlox.Loops.Spinbot:Disconnect()
        CounterBlox.Loops.Spinbot = nil
    end
    
    if enabled then
        CounterBlox.Loops.Spinbot = RunService.RenderStepped:Connect(function()
            if CounterBlox.Core.IsAlive(LocalPlayer) then
                LocalPlayer.Character.Humanoid.AutoRotate = false
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(CounterBlox.Settings.SpinSpeed), 0)
            end
        end)
    else
        if CounterBlox.Core.IsAlive(LocalPlayer) then
            LocalPlayer.Character.Humanoid.AutoRotate = true
        end
    end
end

function CounterBlox.ThirdPerson(enabled)
    CounterBlox.Settings.ThirdPerson = enabled
    
    if CounterBlox.Loops.ThirdPerson then
        CounterBlox.Loops.ThirdPerson:Disconnect()
        CounterBlox.Loops.ThirdPerson = nil
    end
    
    if enabled then
        CounterBlox.Loops.ThirdPerson = RunService.Heartbeat:Connect(function()
            LocalPlayer.CameraMinZoomDistance = CounterBlox.Settings.ThirdPersonDistance
            LocalPlayer.CameraMaxZoomDistance = CounterBlox.Settings.ThirdPersonDistance
        end)
    else
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 0.5
    end
end

function CounterBlox.SetThirdPersonDistance(dist)
    CounterBlox.Settings.ThirdPersonDistance = dist
    if CounterBlox.Settings.ThirdPerson then
        LocalPlayer.CameraMinZoomDistance = dist
        LocalPlayer.CameraMaxZoomDistance = dist
    end
end

function CounterBlox.SetBHopSpeed(speed)
    CounterBlox.Settings.BHopSpeed = speed
end

function CounterBlox.SetSpinSpeed(speed)
    CounterBlox.Settings.SpinSpeed = speed
end

function CounterBlox.Init(Core)
    CounterBlox.Core = Core
end

function CounterBlox.Cleanup()
    for _, conn in pairs(CounterBlox.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    CounterBlox.Loops = {}
    
    if CounterBlox.Core.IsAlive(LocalPlayer) then
        LocalPlayer.Character.Humanoid.AutoRotate = true
    end
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 0.5
end

return CounterBlox
