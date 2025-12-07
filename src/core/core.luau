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
Core.Hooks = {}

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
-- СЕРВЕРНЫЕ ЭКСПЛОИТЫ (NAMECALL HOOK)
-- ============================================

Core.OriginalNamecall = nil
Core.HookEnabled = false

function Core.SetupServerHook()
    if Core.HookEnabled then return true end
    
    -- Проверяем наличие нужных функций
    if not getrawmetatable or not setreadonly or not newcclosure then
        warn("[Core] Executor doesn't support metatable hooks")
        return false
    end
    
    local mt = getrawmetatable(game)
    if not mt then return false end
    
    Core.OriginalNamecall = mt.__namecall
    
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        -- Hook FireServer для модификации данных стрельбы
        if method == "FireServer" then
            local remoteName = self.Name
            
            -- Counter Blox использует разные remote для стрельбы
            -- Нужно найти правильные названия через RemoteSpy
            
            -- No Spread - модифицируем данные spread в аргументах
            if Core.CBSettings.NoSpread then
                if remoteName == "ShootEvent" or remoteName == "Fire" or remoteName == "Shoot" or remoteName:find("Shoot") or remoteName:find("Fire") then
                    -- Ищем spread в аргументах и обнуляем
                    for i, arg in pairs(args) do
                        if type(arg) == "table" then
                            if arg.Spread then arg.Spread = 0 end
                            if arg.spread then arg.spread = 0 end
                            if arg.SpreadAngle then arg.SpreadAngle = 0 end
                        end
                        if type(arg) == "number" and i > 1 then
                            -- Может быть spread как отдельный аргумент
                        end
                    end
                end
            end
            
            -- No Recoil - блокируем recoil events
            if Core.CBSettings.NoRecoil then
                if remoteName:find("Recoil") or remoteName == "CameraRecoil" then
                    return nil -- Блокируем
                end
            end
            
            -- Rapid Fire - модифицируем cooldown/firerate
            if Core.CBSettings.RapidFire then
                if remoteName:find("Fire") or remoteName:find("Shoot") then
                    for i, arg in pairs(args) do
                        if type(arg) == "table" then
                            if arg.FireRate then arg.FireRate = 0 end
                            if arg.Cooldown then arg.Cooldown = 0 end
                            if arg.Delay then arg.Delay = 0 end
                        end
                    end
                end
            end
        end
        
        -- Hook InvokeServer
        if method == "InvokeServer" then
            local remoteName = self.Name
            
            -- Infinite Ammo - модифицируем ammo checks
            if Core.CBSettings.InfAmmo then
                if remoteName:find("Ammo") or remoteName:find("Reload") then
                    for i, arg in pairs(args) do
                        if type(arg) == "table" then
                            if arg.Ammo then arg.Ammo = 999 end
                            if arg.CurrentAmmo then arg.CurrentAmmo = 999 end
                        end
                    end
                end
            end
        end
        
        return Core.OriginalNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    Core.HookEnabled = true
    
    return true
end

-- Альтернативный метод - hookfunction для конкретных remote
function Core.HookRemote(remote, callback)
    if not hookfunction then
        warn("[Core] hookfunction not available")
        return
    end
    
    local oldFunc
    oldFunc = hookfunction(remote.FireServer, function(...)
        local args = {...}
        local modifiedArgs = callback(args)
        return oldFunc(unpack(modifiedArgs or args))
    end)
    
    Core.Hooks[remote] = oldFunc
end

-- ============================================
-- COUNTER BLOX FUNCTIONS (SERVER-SIDE)
-- ============================================

function Core.CBNoSpread(enabled)
    Core.CBSettings.NoSpread = enabled
    
    if enabled and not Core.HookEnabled then
        Core.SetupServerHook()
    end
    
    -- Также клиентский fallback
    if Core.Loops.NoSpread then
        Core.Loops.NoSpread:Disconnect()
        Core.Loops.NoSpread = nil
    end
    
    if enabled then
        Core.Loops.NoSpread = RunService.RenderStepped:Connect(function()
            if not Core.IsAlive(LocalPlayer) then return end
            local tool = Core.GetCurrentGun()
            if not tool then return end
            
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("NumberValue") and child.Name:lower():find("spread") then
                    if not Core.OriginalValues[child] then
                        Core.OriginalValues[child] = child.Value
                    end
                    child.Value = 0
                end
            end
        end)
    end
end

function Core.CBNoRecoil(enabled)
    Core.CBSettings.NoRecoil = enabled
    
    if enabled and not Core.HookEnabled then
        Core.SetupServerHook()
    end
    
    if Core.Loops.NoRecoil then
        Core.Loops.NoRecoil:Disconnect()
        Core.Loops.NoRecoil = nil
    end
    
    if enabled then
        Core.Loops.NoRecoil = RunService.RenderStepped:Connect(function()
            if not Core.IsAlive(LocalPlayer) then return end
            local tool = Core.GetCurrentGun()
            if not tool then return end
            
            local recoilNames = {"Recoil", "CamRecoil", "KickBack", "Kick", "CameraRecoil"}
            for _, name in pairs(recoilNames) do
                local recoil = tool:FindFirstChild(name)
                if recoil and recoil:IsA("NumberValue") then
                    if not Core.OriginalValues[recoil] then
                        Core.OriginalValues[recoil] = recoil.Value
                    end
                    recoil.Value = 0
                end
            end
        end)
    end
end

function Core.CBRapidFire(enabled)
    Core.CBSettings.RapidFire = enabled
    
    if enabled and not Core.HookEnabled then
        Core.SetupServerHook()
    end
    
    if Core.Loops.RapidFire then
        Core.Loops.RapidFire:Disconnect()
        Core.Loops.RapidFire = nil
    end
    
    if enabled then
        Core.Loops.RapidFire = RunService.RenderStepped:Connect(function()
            if not Core.IsAlive(LocalPlayer) then return end
            local tool = Core.GetCurrentGun()
            if not tool then return end
            
            local fireRate = tool:FindFirstChild("FireRate")
            if fireRate and fireRate:IsA("NumberValue") then
                if not Core.OriginalValues[fireRate] then
                    Core.OriginalValues[fireRate] = fireRate.Value
                end
                fireRate.Value = 0.01
            end
        end)
    end
end

function Core.CBInfAmmo(enabled)
    Core.CBSettings.InfAmmo = enabled
    
    if enabled and not Core.HookEnabled then
        Core.SetupServerHook()
    end
    
    if Core.Loops.InfAmmo then
        Core.Loops.InfAmmo:Disconnect()
        Core.Loops.InfAmmo = nil
    end
    
    if enabled then
        Core.Loops.InfAmmo = RunService.RenderStepped:Connect(function()
            if not Core.IsAlive(LocalPlayer) then return end
            local tool = Core.GetCurrentGun()
            if not tool then return end
            
            local ammo = tool:FindFirstChild("Ammo")
            local storedAmmo = tool:FindFirstChild("StoredAmmo")
            
            if ammo and ammo:IsA("NumberValue") then
                ammo.Value = 999
            end
            if storedAmmo and storedAmmo:IsA("NumberValue") then
                storedAmmo.Value = 999
            end
        end)
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
    
    -- Автоматически настраиваем hook
    pcall(Core.SetupServerHook)
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
    
    -- Восстанавливаем metatable
    if Core.OriginalNamecall and Core.HookEnabled then
        pcall(function()
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            mt.__namecall = Core.OriginalNamecall
            setreadonly(mt, true)
        end)
    end
    
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
