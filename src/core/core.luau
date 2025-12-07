local Core = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

Core.ESP = nil
Core.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

Core.AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    VisibleCheck = true,
    FOV = 150,
    Smoothness = 5,
    AimPart = "Head",
    Prediction = 0
}

Core.CBSettings = {
    NoSpread = false,
    NoRecoil = false,
    RapidFire = false,
    InfAmmo = false,
    BHop = false,
    BHopKey = Enum.KeyCode.Space,
    Spinbot = false,
    SpinSpeed = 50,
    ThirdPerson = false,
    ThirdPersonDistance = 10
}

Core.Loops = {}
Core.OriginalValues = {}
Core.LockedTarget = nil

-- Load ESP Module
function Core.LoadESP(url)
    local espUrl = url or "https://raw.githubusercontent.com/n-0clip/killfeed.cc/main/src/core/esp.luau"
    local success, result = pcall(function()
        return loadstring(game:HttpGet(espUrl))()
    end)
    
    if success and result then
        Core.ESP = result
        return Core.ESP
    else
        warn("[Core] Failed to load ESP: " .. tostring(result))
        return nil
    end
end

-- Utility Functions
function Core.GetMousePosition()
    if Core.IsMobile then
        return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    local success, pos = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    return success and pos or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function Core.IsAlive(plr)
    if not plr or not plr.Character then return false end
    local h = plr.Character:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

function Core.IsVisible(part)
    if not part then return false end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(origin, direction, params)
    if result then
        return result.Instance:IsDescendantOf(part.Parent)
    end
    return true
end

function Core.GetCurrentGun()
    if not Core.IsAlive(LocalPlayer) then return nil end
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") then return v end
    end
    return nil
end

-- Aimbot Functions
function Core.GetClosestPlayer()
    local closest, shortestDist = nil, Core.AimbotSettings.FOV
    local mousePos = Core.GetMousePosition()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or not Core.IsAlive(player) then continue end
        if Core.AimbotSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then continue end
        
        local char = player.Character
        if not char then continue end
        
        local aimPart = char:FindFirstChild(Core.AimbotSettings.AimPart) or char:FindFirstChild("Head")
        if not aimPart then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
        if not onScreen then continue end
        
        if Core.AimbotSettings.VisibleCheck and not Core.IsVisible(aimPart) then continue end
        
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if dist < shortestDist then
            shortestDist = dist
            closest = player
        end
    end
    return closest
end

function Core.AimAt(player)
    if not player or not Core.IsAlive(player) then
        Core.LockedTarget = nil
        return
    end
    if Core.IsMobile then return end
    
    local char = player.Character
    if not char then return end
    
    local aimPart = char:FindFirstChild(Core.AimbotSettings.AimPart) or char:FindFirstChild("Head")
    if not aimPart then return end
    
    local targetPos = aimPart.Position
    
    if Core.AimbotSettings.Prediction > 0 then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            targetPos = targetPos + (root.AssemblyLinearVelocity * (Core.AimbotSettings.Prediction / 10))
        end
    end
    
    local screenPos = Camera:WorldToViewportPoint(targetPos)
    local mousePos = Core.GetMousePosition()
    local delta = (Vector2.new(screenPos.X, screenPos.Y) - mousePos) / math.max(Core.AimbotSettings.Smoothness, 1)
    
    if mousemoverel then
        mousemoverel(delta.X, delta.Y)
    end
end

-- Counter Blox Functions
function Core.CBNoSpread(enabled)
    Core.CBSettings.NoSpread = enabled
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local spread = weapon:FindFirstChild("Spread")
        if spread then
            if spread:IsA("NumberValue") then
                if enabled then
                    if not Core.OriginalValues[spread] then Core.OriginalValues[spread] = spread.Value end
                    spread.Value = 0
                else
                    if Core.OriginalValues[spread] then spread.Value = Core.OriginalValues[spread] end
                end
            else
                for _, v in ipairs(spread:GetDescendants()) do
                    if v:IsA("NumberValue") then
                        if enabled then
                            if not Core.OriginalValues[v] then Core.OriginalValues[v] = v.Value end
                            v.Value = 0
                        else
                            if Core.OriginalValues[v] then v.Value = Core.OriginalValues[v] end
                        end
                    end
                end
            end
        end
    end
end

function Core.CBNoRecoil(enabled)
    Core.CBSettings.NoRecoil = enabled
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        for _, name in ipairs({"Recoil", "CamRecoil", "KickBack", "Kick"}) do
            local recoil = weapon:FindFirstChild(name)
            if recoil and recoil:IsA("NumberValue") then
                if enabled then
                    if not Core.OriginalValues[recoil] then Core.OriginalValues[recoil] = recoil.Value end
                    recoil.Value = 0
                else
                    if Core.OriginalValues[recoil] then recoil.Value = Core.OriginalValues[recoil] end
                end
            end
        end
    end
end

function Core.CBRapidFire(enabled)
    Core.CBSettings.RapidFire = enabled
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local fireRate = weapon:FindFirstChild("FireRate")
        if fireRate and fireRate:IsA("NumberValue") then
            if enabled then
                if not Core.OriginalValues[fireRate] then Core.OriginalValues[fireRate] = fireRate.Value end
                fireRate.Value = 0.01
            else
                if Core.OriginalValues[fireRate] then fireRate.Value = Core.OriginalValues[fireRate] end
            end
        end
    end
end

function Core.CBInfAmmo(enabled)
    Core.CBSettings.InfAmmo = enabled
    
    if Core.Loops.InfAmmo then
        Core.Loops.InfAmmo:Disconnect()
        Core.Loops.InfAmmo = nil
    end
    
    if enabled then
        Core.Loops.InfAmmo = RunService.Heartbeat:Connect(function()
            local gun = Core.GetCurrentGun()
            if gun then
                local ammo = gun:FindFirstChild("Ammo")
                local storedAmmo = gun:FindFirstChild("StoredAmmo")
                if ammo and ammo:IsA("NumberValue") then ammo.Value = 999 end
                if storedAmmo and storedAmmo:IsA("NumberValue") then storedAmmo.Value = 999 end
            end
        end)
    end
end

function Core.CBBHop(enabled)
    Core.CBSettings.BHop = enabled
    
    if Core.Loops.BHopInput then Core.Loops.BHopInput:Disconnect() end
    if Core.Loops.BHopInputEnd then Core.Loops.BHopInputEnd:Disconnect() end
    if Core.Loops.BHop then Core.Loops.BHop:Disconnect() end
    
    if enabled then
        local holding = false
        
        Core.Loops.BHopInput = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Core.CBSettings.BHopKey then
                holding = true
            end
        end)
        
        Core.Loops.BHopInputEnd = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Core.CBSettings.BHopKey then
                holding = false
            end
        end)
        
        Core.Loops.BHop = RunService.Heartbeat:Connect(function()
            if holding and Core.IsAlive(LocalPlayer) then
                local hum = LocalPlayer.Character.Humanoid
                if hum.FloorMaterial ~= Enum.Material.Air then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end

function Core.CBSpinbot(enabled)
    Core.CBSettings.Spinbot = enabled
    
    if Core.Loops.Spinbot then
        Core.Loops.Spinbot:Disconnect()
        Core.Loops.Spinbot = nil
    end
    
    if enabled then
        Core.Loops.Spinbot = RunService.Heartbeat:Connect(function()
            if Core.IsAlive(LocalPlayer) then
                local char = LocalPlayer.Character
                char.Humanoid.AutoRotate = false
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Core.CBSettings.SpinSpeed), 0)
            end
        end)
    else
        if Core.IsAlive(LocalPlayer) then
            LocalPlayer.Character.Humanoid.AutoRotate = true
        end
    end
end

function Core.CBThirdPerson(enabled)
    Core.CBSettings.ThirdPerson = enabled
    
    if Core.Loops.ThirdPerson then
        Core.Loops.ThirdPerson:Disconnect()
        Core.Loops.ThirdPerson = nil
    end
    
    if enabled then
        Core.Loops.ThirdPerson = RunService.Heartbeat:Connect(function()
            LocalPlayer.CameraMinZoomDistance = Core.CBSettings.ThirdPersonDistance
            LocalPlayer.CameraMaxZoomDistance = Core.CBSettings.ThirdPersonDistance
        end)
    else
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 0.5
    end
end

function Core.CBSetThirdPersonDistance(distance)
    Core.CBSettings.ThirdPersonDistance = distance
end

-- Initialize
function Core.Init(espUrl)
    -- Load ESP
    Core.LoadESP(espUrl)
    
    if Core.ESP then
        Core.ESP.Init()
    end
    
    -- Aimbot loop
    Core.Loops.Aimbot = RunService.RenderStepped:Connect(function()
        Camera = Workspace.CurrentCamera
        if Core.AimbotSettings.Enabled then
            local target = Core.GetClosestPlayer()
            if target then
                Core.AimAt(target)
            end
        end
    end)
end

-- Cleanup
function Core.Cleanup()
    for _, connection in pairs(Core.Loops) do
        if connection then
            pcall(function() connection:Disconnect() end)
        end
    end
    Core.Loops = {}
    
    for obj, val in pairs(Core.OriginalValues) do
        pcall(function() obj.Value = val end)
    end
    Core.OriginalValues = {}
    
    if Core.ESP then
        pcall(function() Core.ESP.Destroy() end)
    end
    
    if Core.IsAlive(LocalPlayer) then
        LocalPlayer.Character.Humanoid.AutoRotate = true
    end
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 0.5
end

return Core
