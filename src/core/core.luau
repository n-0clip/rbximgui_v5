local Core = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

Core.ESP = nil
Core.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

Core.SupportedGames = {
    [301549746] = "Counter Blox"
}

Core.PlaceId = game.PlaceId
Core.GameName = Core.SupportedGames[Core.PlaceId] or "Universal"

Core.AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    VisibleCheck = true,
    FOV = 100,
    Smoothness = 5,
    AimPart = "Head",
    Prediction = 0,
    StickyAim = false
}

Core.TriggerSettings = {
    Enabled = false,
    TeamCheck = true,
    Delay = 0
}

Core.CBSettings = {
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

Core.Loops = {}
Core.OriginalValues = {}
Core.LockedTarget = nil

-- Load ESP
function Core.LoadESP(url)
    local espUrl = url or "https://raw.githubusercontent.com/n-0clip/killfeed.cc/main/src/core/esp.luau"
    local success, result = pcall(function()
        return loadstring(game:HttpGet(espUrl))()
    end)
    if success and result then
        Core.ESP = result
        return Core.ESP
    end
    warn("[Core] Failed to load ESP")
    return nil
end

-- Drawing Helper
function Core.CreateDrawing(t, props)
    local success, d = pcall(function() return Drawing.new(t) end)
    if not success or not d then
        return {Visible = false, Remove = function() end, Position = Vector2.new(), Radius = 0, Color = Color3.new()}
    end
    for k, v in pairs(props or {}) do pcall(function() d[k] = v end) end
    return d
end

-- Utility
function Core.GetMousePosition()
    if Core.IsMobile then
        return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    local success, pos = pcall(function() return UserInputService:GetMouseLocation() end)
    return success and pos or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function Core.IsAlive(plr)
    if not plr or not plr.Character then return false end
    local h = plr.Character:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

function Core.IsVisible(part)
    if not part then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), params)
    if result then return result.Instance:IsDescendantOf(part.Parent) end
    return true
end

function Core.GetCurrentGun()
    if not Core.IsAlive(LocalPlayer) then return nil end
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") then return v end
    end
    return nil
end

-- Aimbot
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

function Core.AimAt(player, TargetCircle)
    if not player or not Core.IsAlive(player) then Core.LockedTarget = nil return end
    if Core.IsMobile then return end
    
    local char = player.Character
    if not char then return end
    
    local aimPart = char:FindFirstChild(Core.AimbotSettings.AimPart) or char:FindFirstChild("Head")
    if not aimPart then return end
    
    local targetPos = aimPart.Position
    if Core.AimbotSettings.Prediction > 0 then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then targetPos = targetPos + (root.AssemblyLinearVelocity * (Core.AimbotSettings.Prediction / 10)) end
    end
    
    local screenPos = Camera:WorldToViewportPoint(targetPos)
    local mousePos = Core.GetMousePosition()
    local delta = (Vector2.new(screenPos.X, screenPos.Y) - mousePos) / math.max(Core.AimbotSettings.Smoothness, 1)
    
    if mousemoverel then mousemoverel(delta.X, delta.Y) end
    if TargetCircle then 
        pcall(function() 
            TargetCircle.Position = Vector2.new(screenPos.X, screenPos.Y) 
            TargetCircle.Visible = true 
        end) 
    end
end

-- Trigger Bot
function Core.GetTriggerTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local ray = Camera:ViewportPointToRay(center.X, center.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    if result and result.Instance then
        local player = Players:GetPlayerFromCharacter(result.Instance.Parent) or Players:GetPlayerFromCharacter(result.Instance.Parent.Parent)
        if player and player ~= LocalPlayer and Core.IsAlive(player) then
            if Core.TriggerSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then return nil end
            return player
        end
    end
    return nil
end

-- World
function Core.SetTime(time) Lighting.ClockTime = time end
function Core.SetFullbright(enabled)
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1,1,1)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(127,127,127)
    end
end
function Core.SetNoFog(enabled) Lighting.FogEnd = enabled and 100000 or 1000 end

-- ============================================
-- COUNTER BLOX FUNCTIONS (FIXED)
-- ============================================

function Core.CBNoSpread(enabled)
    Core.CBSettings.NoSpread = enabled
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        -- Direct Spread value
        local spread = weapon:FindFirstChild("Spread")
        if spread and spread:IsA("NumberValue") then
            if enabled then
                if not Core.OriginalValues[spread] then 
                    Core.OriginalValues[spread] = spread.Value 
                end
                spread.Value = 0
            else
                if Core.OriginalValues[spread] then 
                    spread.Value = Core.OriginalValues[spread] 
                end
            end
        end
        
        -- Also check SpreadAim, SpreadHip etc
        for _, child in ipairs(weapon:GetChildren()) do
            if child.Name:lower():find("spread") and child:IsA("NumberValue") then
                if enabled then
                    if not Core.OriginalValues[child] then 
                        Core.OriginalValues[child] = child.Value 
                    end
                    child.Value = 0
                else
                    if Core.OriginalValues[child] then 
                        child.Value = Core.OriginalValues[child] 
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
        for _, name in ipairs({"Recoil", "CamRecoil", "KickBack", "Kick", "CameraRecoil"}) do
            local recoil = weapon:FindFirstChild(name)
            if recoil and recoil:IsA("NumberValue") then
                if enabled then
                    if not Core.OriginalValues[recoil] then 
                        Core.OriginalValues[recoil] = recoil.Value 
                    end
                    recoil.Value = 0
                else
                    if Core.OriginalValues[recoil] then 
                        recoil.Value = Core.OriginalValues[recoil] 
                    end
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
                if not Core.OriginalValues[fireRate] then 
                    Core.OriginalValues[fireRate] = fireRate.Value 
                end
                fireRate.Value = 0
            else
                if Core.OriginalValues[fireRate] then 
                    fireRate.Value = Core.OriginalValues[fireRate] 
                end
            end
        end
    end
end

function Core.CBInfAmmo(enabled)
    Core.CBSettings.InfAmmo = enabled
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

function Core.CBBHop(enabled)
    Core.CBSettings.BHop = enabled
    
    if Core.Loops.BHop then 
        Core.Loops.BHop:Disconnect() 
        Core.Loops.BHop = nil 
    end
    
    if enabled then
        Core.Loops.BHop = RunService.RenderStepped:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) and Core.IsAlive(LocalPlayer) then
                local char = LocalPlayer.Character
                local hum = char:FindFirstChild("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                
                if hum and hrp then
                    hum.Jump = true
                    local moveDirection = hrp.CFrame.LookVector * Core.CBSettings.BHopSpeed
                    hrp.Velocity = Vector3.new(moveDirection.X, hrp.Velocity.Y, moveDirection.Z)
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
        Core.Loops.Spinbot = RunService.RenderStepped:Connect(function()
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

function Core.CBSetThirdPersonDistance(dist)
    Core.CBSettings.ThirdPersonDistance = dist
    if Core.CBSettings.ThirdPerson then
        LocalPlayer.CameraMinZoomDistance = dist
        LocalPlayer.CameraMaxZoomDistance = dist
    end
end

-- Misc
function Core.Rejoin() 
    TeleportService:TeleportToPlaceInstance(Core.PlaceId, game.JobId, LocalPlayer) 
end

function Core.GetJoinScript() 
    return 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. Core.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)' 
end

-- Init
function Core.Init(espUrl)
    Core.LoadESP(espUrl)
    if Core.ESP then 
        Core.ESP.Init() 
    end
end

-- Cleanup
function Core.Cleanup()
    for _, conn in pairs(Core.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    Core.Loops = {}
    
    for obj, val in pairs(Core.OriginalValues) do
        pcall(function() obj.Value = val end)
    end
    Core.OriginalValues = {}
    
    if Core.IsAlive(LocalPlayer) then
        LocalPlayer.Character.Humanoid.AutoRotate = true
    end
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 0.5
    
    if Core.ESP then
        pcall(function() Core.ESP.Destroy() end)
    end
end

return Core
