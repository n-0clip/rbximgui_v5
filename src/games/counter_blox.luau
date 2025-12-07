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
CounterBlox.OriginalValues = {}

CounterBlox.Settings = {
    NoSpread = false,
    NoRecoil = false,
    RapidFire = false,
    InfAmmo = false,
    BHop = false,
    BHopSpeed = 50,
    Spinbot = false,
    SpinSpeed = 15,
    ThirdPerson = false,
    ThirdPersonDistance = 10
}

function CounterBlox.NoSpread(enabled)
    CounterBlox.Settings.NoSpread = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local spread = weapon:FindFirstChild("Spread")
        if spread and spread:IsA("NumberValue") then
            if enabled then
                if not CounterBlox.OriginalValues[spread] then
                    CounterBlox.OriginalValues[spread] = spread.Value
                end
                spread.Value = 0
            else
                if CounterBlox.OriginalValues[spread] then
                    spread.Value = CounterBlox.OriginalValues[spread]
                end
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
        
        if recoil and recoil:IsA("NumberValue") then
            if enabled then
                if not CounterBlox.OriginalValues[recoil] then
                    CounterBlox.OriginalValues[recoil] = recoil.Value
                end
                recoil.Value = 0
            else
                if CounterBlox.OriginalValues[recoil] then
                    recoil.Value = CounterBlox.OriginalValues[recoil]
                end
            end
        end
        
        if camRecoil and camRecoil:IsA("NumberValue") then
            if enabled then
                if not CounterBlox.OriginalValues[camRecoil] then
                    CounterBlox.OriginalValues[camRecoil] = camRecoil.Value
                end
                camRecoil.Value = 0
            else
                if CounterBlox.OriginalValues[camRecoil] then
                    camRecoil.Value = CounterBlox.OriginalValues[camRecoil]
                end
            end
        end
        
        if kickBack and kickBack:IsA("NumberValue") then
            if enabled then
                if not CounterBlox.OriginalValues[kickBack] then
                    CounterBlox.OriginalValues[kickBack] = kickBack.Value
                end
                kickBack.Value = 0
            else
                if CounterBlox.OriginalValues[kickBack] then
                    kickBack.Value = CounterBlox.OriginalValues[kickBack]
                end
            end
        end
    end
end

function CounterBlox.RapidFire(enabled)
    CounterBlox.Settings.RapidFire = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local fireRate = weapon:FindFirstChild("FireRate")
        if fireRate and fireRate:IsA("NumberValue") then
            if enabled then
                if not CounterBlox.OriginalValues[fireRate] then
                    CounterBlox.OriginalValues[fireRate] = fireRate.Value
                end
                fireRate.Value = 0
            else
                if CounterBlox.OriginalValues[fireRate] then
                    fireRate.Value = CounterBlox.OriginalValues[fireRate]
                end
            end
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
        
        if ammo and ammo:IsA("NumberValue") then
            ammo.Value = 999999
        end
        if storedAmmo and storedAmmo:IsA("NumberValue") then
            storedAmmo.Value = 999999
        end
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
            if not CounterBlox.Core.IsAlive(LocalPlayer) then return end
            if not UserInputService:IsKeyDown(Enum.KeyCode.Space) then return end
            
            local char = LocalPlayer.Character
            local hum = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if hum and hrp then
                if hum.FloorMaterial ~= Enum.Material.Air then
                    hum.Jump = true
                end
                
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    hrp.Velocity = Vector3.new(
                        moveDir.X * CounterBlox.Settings.BHopSpeed,
                        hrp.Velocity.Y,
                        moveDir.Z * CounterBlox.Settings.BHopSpeed
                    )
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
        CounterBlox.Loops.Spinbot = RunService.Heartbeat:Connect(function()
            if not CounterBlox.Core.IsAlive(LocalPlayer) then return end
            
            local char = LocalPlayer.Character
            local hum = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if hum and hrp then
                hum.AutoRotate = false
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(CounterBlox.Settings.SpinSpeed), 0)
            end
        end)
    else
        if CounterBlox.Core.IsAlive(LocalPlayer) then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.AutoRotate = true
            end
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
        LocalPlayer.CameraMinZoomDistance = CounterBlox.Settings.ThirdPersonDistance
        LocalPlayer.CameraMaxZoomDistance = CounterBlox.Settings.ThirdPersonDistance
        
        CounterBlox.Loops.ThirdPerson = RunService.RenderStepped:Connect(function()
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
    
    for obj, val in pairs(CounterBlox.OriginalValues) do
        pcall(function() obj.Value = val end)
    end
    CounterBlox.OriginalValues = {}
    
    if CounterBlox.Core.IsAlive(LocalPlayer) then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.AutoRotate = true
        end
    end
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 0.5
end

return CounterBlox
