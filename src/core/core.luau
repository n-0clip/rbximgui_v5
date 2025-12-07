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

-- ============================================
-- EXECUTOR COMPATIBILITY LAYER
-- ============================================

Core.Executor = {
    Name = "Unknown",
    Level = 0, -- 0 = basic, 1 = medium, 2 = full
    Features = {}
}

function Core.DetectExecutor()
    local executor = "Unknown"
    
    -- Detect executor name
    if identifyexecutor then
        executor = identifyexecutor()
    elseif getexecutorname then
        executor = getexecutorname()
    elseif KRNL_LOADED then
        executor = "Krnl"
    elseif syn then
        executor = "Synapse"
    elseif fluxus then
        executor = "Fluxus"
    end
    
    Core.Executor.Name = executor
    
    -- Detect available features
    Core.Executor.Features = {
        -- Basic functions
        HttpGet = game.HttpGet ~= nil or request ~= nil or http_request ~= nil,
        SetClipboard = setclipboard ~= nil or toclipboard ~= nil,
        
        -- Drawing
        Drawing = Drawing ~= nil and Drawing.new ~= nil,
        
        -- Input
        MouseMoveRel = mousemoverel ~= nil or Input ~= nil,
        Mouse1Click = mouse1click ~= nil,
        Mouse1Press = mouse1press ~= nil,
        
        -- Metatable hooks (for server-side exploits)
        GetRawMetatable = getrawmetatable ~= nil,
        SetReadOnly = setreadonly ~= nil,
        NewCClosure = newcclosure ~= nil,
        GetNamecallMethod = getnamecallmethod ~= nil,
        
        -- Function hooks
        HookFunction = hookfunction ~= nil or replaceclosure ~= nil,
        HookMetamethod = hookmetamethod ~= nil,
        
        -- Other
        FireClickDetector = fireclickdetector ~= nil,
        FireTouchInterest = firetouchinterest ~= nil,
        GetGC = getgc ~= nil,
        GetConnections = getconnections ~= nil,
        GetHiddenProperty = gethiddenproperty ~= nil,
        SetHiddenProperty = sethiddenproperty ~= nil,
        
        -- File system
        ReadFile = readfile ~= nil,
        WriteFile = writefile ~= nil,
        IsFile = isfile ~= nil,
        MakeFolder = makefolder ~= nil
    }
    
    -- Determine executor level
    local level = 0
    
    if Core.Executor.Features.GetRawMetatable and 
       Core.Executor.Features.SetReadOnly and 
       Core.Executor.Features.NewCClosure then
        level = 2 -- Full support (can do server hooks)
    elseif Core.Executor.Features.Drawing and Core.Executor.Features.MouseMoveRel then
        level = 1 -- Medium support (ESP, Aimbot work)
    end
    
    Core.Executor.Level = level
    
    -- Executor-specific fixes
    Core.ApplyExecutorFixes()
    
    return executor, level
end

function Core.ApplyExecutorFixes()
    local name = Core.Executor.Name:lower()
    
    -- Xeno fixes
    if name:find("xeno") then
        -- Xeno uses different function names sometimes
        if not mousemoverel and Input then
            mousemoverel = function(x, y)
                Input.MouseMove(x, y)
            end
        end
    end
    
    -- Solara fixes
    if name:find("solara") then
        -- Solara specific
        if not newcclosure and function_closure then
            newcclosure = function_closure
        end
    end
    
    -- Luna fixes
    if name:find("luna") then
        -- Luna specific fixes
    end
    
    -- Fluxus fixes
    if name:find("fluxus") then
        -- Fluxus has limited metatable access
    end
    
    -- Delta fixes
    if name:find("delta") then
        -- Delta (mobile) fixes
        if not mousemoverel then
            Core.Executor.Features.MouseMoveRel = false
        end
    end
    
    -- Arceus X fixes
    if name:find("arceus") then
        -- Arceus X (mobile)
        Core.IsMobile = true
    end
end

-- ============================================
-- UNIVERSAL FUNCTION WRAPPERS
-- ============================================

function Core.SafeGetRawMetatable(obj)
    if getrawmetatable then
        return getrawmetatable(obj)
    elseif debug and debug.getmetatable then
        return debug.getmetatable(obj)
    end
    return nil
end

function Core.SafeSetReadOnly(tbl, value)
    if setreadonly then
        setreadonly(tbl, value)
        return true
    elseif make_readonly then
        if value then
            make_readonly(tbl)
        end
        return true
    end
    return false
end

function Core.SafeNewCClosure(fn)
    if newcclosure then
        return newcclosure(fn)
    elseif clonefunction then
        return clonefunction(fn)
    end
    return fn
end

function Core.SafeHookFunction(target, hook)
    if hookfunction then
        return hookfunction(target, hook)
    elseif replaceclosure then
        return replaceclosure(target, hook)
    elseif detour_function then
        return detour_function(target, hook)
    end
    return nil
end

function Core.SafeHookMetamethod(obj, method, hook)
    if hookmetamethod then
        return hookmetamethod(obj, method, hook)
    end
    
    -- Fallback: manual metatable hook
    local mt = Core.SafeGetRawMetatable(obj)
    if mt and Core.SafeSetReadOnly(mt, false) then
        local old = mt[method]
        mt[method] = Core.SafeNewCClosure(function(...)
            return hook(old, ...)
        end)
        Core.SafeSetReadOnly(mt, true)
        return old
    end
    
    return nil
end

function Core.SafeMouseMoveRel(x, y)
    if mousemoverel then
        mousemoverel(x, y)
    elseif Input and Input.MouseMove then
        Input.MouseMove(x, y)
    elseif mouse_move then
        mouse_move(x, y)
    end
end

function Core.SafeClick()
    if mouse1click then
        mouse1click()
    elseif mouse1press and mouse1release then
        mouse1press()
        task.defer(mouse1release)
    elseif Input and Input.MouseClick then
        Input.MouseClick()
    elseif clickmouse then
        clickmouse()
    end
end

function Core.SafeSetClipboard(text)
    if setclipboard then
        setclipboard(text)
    elseif toclipboard then
        toclipboard(text)
    elseif Clipboard and Clipboard.set then
        Clipboard.set(text)
    end
end

-- ============================================
-- SETTINGS
-- ============================================

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
Core.HookEnabled = false
Core.OriginalNamecall = nil

-- ============================================
-- DRAWING
-- ============================================

function Core.CreateDrawing(t, props)
    if not Core.Executor.Features.Drawing then
        -- Return dummy object for executors without Drawing
        return {
            Visible = false, 
            Remove = function() end, 
            Destroy = function() end,
            Position = Vector2.new(), 
            Radius = 0, 
            Color = Color3.new(),
            From = Vector2.new(),
            To = Vector2.new(),
            Thickness = 1,
            Filled = false,
            Transparency = 1,
            Size = Vector2.new(),
            Text = "",
            Center = true,
            Outline = false
        }
    end
    
    local success, d = pcall(function() return Drawing.new(t) end)
    if not success or not d then
        return {Visible = false, Remove = function() end}
    end
    for k, v in pairs(props or {}) do pcall(function() d[k] = v end) end
    return d
end

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

-- ============================================
-- UTILITY
-- ============================================

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

-- ============================================
-- AIMBOT
-- ============================================

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
    if not Core.Executor.Features.MouseMoveRel then return end
    
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
    
    Core.SafeMouseMoveRel(delta.X, delta.Y)
    
    if TargetCircle then 
        pcall(function() 
            TargetCircle.Position = Vector2.new(screenPos.X, screenPos.Y) 
            TargetCircle.Visible = true 
        end) 
    end
end

-- ============================================
-- TRIGGER BOT
-- ============================================

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

-- ============================================
-- WORLD
-- ============================================

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

function Core.SetNoFog(enabled) 
    Lighting.FogEnd = enabled and 100000 or 1000 
end

-- ============================================
-- SERVER HOOK SYSTEM (Level 2 executors only)
-- ============================================

function Core.SetupServerHook()
    if Core.HookEnabled then return true end
    if Core.Executor.Level < 2 then 
        warn("[Core] Server hooks not supported on " .. Core.Executor.Name)
        return false 
    end
    
    local mt = Core.SafeGetRawMetatable(game)
    if not mt then return false end
    
    Core.OriginalNamecall = mt.__namecall
    
    if not Core.SafeSetReadOnly(mt, false) then return false end
    
    mt.__namecall = Core.SafeNewCClosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == "FireServer" then
            local remoteName = self.Name
            
            -- No Spread hook
            if Core.CBSettings.NoSpread then
                if remoteName:find("Shoot") or remoteName:find("Fire") or remoteName == "ShootEvent" then
                    for i, arg in pairs(args) do
                        if type(arg) == "table" then
                            if arg.Spread then arg.Spread = 0 end
                            if arg.spread then arg.spread = 0 end
                        end
                    end
                end
            end
            
            -- No Recoil hook
            if Core.CBSettings.NoRecoil then
                if remoteName:find("Recoil") then
                    return nil
                end
            end
        end
        
        return Core.OriginalNamecall(self, ...)
    end)
    
    Core.SafeSetReadOnly(mt, true)
    Core.HookEnabled = true
    
    return true
end

-- ============================================
-- COUNTER BLOX FUNCTIONS
-- ============================================

function Core.CBNoSpread(enabled)
    Core.CBSettings.NoSpread = enabled
    
    -- Try server hook first (if available)
    if enabled and Core.Executor.Level >= 2 then
        Core.SetupServerHook()
    end
    
    -- Client-side fallback
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
    
    if enabled and Core.Executor.Level >= 2 then
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

-- ============================================
-- MISC
-- ============================================

function Core.Rejoin() 
    TeleportService:TeleportToPlaceInstance(Core.PlaceId, game.JobId, LocalPlayer) 
end

function Core.GetJoinScript() 
    return 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. Core.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)' 
end

-- ============================================
-- INIT & CLEANUP
-- ============================================

function Core.Init(espUrl)
    -- Detect executor and its capabilities
    local execName, execLevel = Core.DetectExecutor()
    print("[Core] Detected executor: " .. execName .. " (Level " .. execLevel .. ")")
    
    -- Load ESP
    Core.LoadESP(espUrl)
    if Core.ESP then 
        Core.ESP.Init() 
    end
end

function Core.Cleanup()
    for _, conn in pairs(Core.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    Core.Loops = {}
    
    for obj, val in pairs(Core.OriginalValues) do
        pcall(function() obj.Value = val end)
    end
    Core.OriginalValues = {}
    
    -- Restore metatable
    if Core.OriginalNamecall and Core.HookEnabled then
        pcall(function()
            local mt = Core.SafeGetRawMetatable(game)
            Core.SafeSetReadOnly(mt, false)
            mt.__namecall = Core.OriginalNamecall
            Core.SafeSetReadOnly(mt, true)
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

-- ============================================
-- GET INFO (for UI)
-- ============================================

function Core.GetExecutorInfo()
    return {
        Name = Core.Executor.Name,
        Level = Core.Executor.Level,
        Features = Core.Executor.Features,
        ServerHooksSupported = Core.Executor.Level >= 2
    }
end

return Core
