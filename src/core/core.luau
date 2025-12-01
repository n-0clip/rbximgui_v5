local Core = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

Core.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

Core.SupportedGames = {
    [301549746] = "Counter Blox",
    [142823291] = "Murder Mystery 2",
}

Core.PlaceId = game.PlaceId
Core.GameName = Core.SupportedGames[Core.PlaceId] or "Universal"

Core.ESPSettings = {
    Enabled = false,
    Box = {On = false, Color = Color3.new(1,1,1), Outline = true, Type = "2D"},
    CornerBox = {On = false, Color = Color3.new(1,1,1)},
    Name = {On = false, Color = Color3.new(1,1,1), DisplayName = false},
    Health = {On = false, Position = "Left", Text = false},
    Armor = {On = false},
    Weapon = {On = false, Color = Color3.new(1,1,1)},
    Distance = {On = false, Color = Color3.new(1,1,1)},
    Skeleton = {On = false, Color = Color3.new(1,1,1)},
    Chams = {On = false, Color = Color3.fromRGB(212,133,240), Transparency = 0.5, OutlineColor = Color3.new(1,1,1), Type = "Highlight", VisibleOnly = false},
    Tracers = {On = false, Origin = "Bottom", Color = Color3.new(1,1,1)},
    HeadDot = {On = false, Color = Color3.new(1,0,0), Filled = true},
    OffScreenArrows = {On = false, Color = Color3.new(1,0,0), Size = 15, Radius = 150},
    LookDirection = {On = false, Color = Color3.new(0,1,0)},
    Flags = {On = false},
    Items = {On = false, Color = Color3.fromRGB(255,255,0)},
    NPCs = {On = false, Color = Color3.fromRGB(255,165,0)},
    Vehicles = {On = false, Color = Color3.fromRGB(0,255,255)},
    MaxDist = 2000,
    TeamCheck = false,
    UseTeamColor = false,
    VisibleCheck = false,
    VisibleColor = Color3.new(0,1,0),
    ShowRole = true,
    Rainbow = {On = false, Speed = 1},
    MurdererColor = Color3.fromRGB(255,0,0),
    SheriffColor = Color3.fromRGB(0,100,255),
    InnocentColor = Color3.fromRGB(0,255,0),
    HeroColor = Color3.fromRGB(255,215,0),
    FontSize = 13,
    Font = "UI",
    MM2GunESP = false
}

Core.AimbotSettings = {
    Enabled = false,
    TeamCheck = true,
    VisibleCheck = true,
    FOV = 100,
    Smoothness = 5,
    AimPart = "Head",
    Prediction = 0,
    StickyAim = false,
    AutoShoot = false,
    AutoWall = false,
    IgnoreWhitelist = true,
    Priority = "Distance"
}

Core.SilentAimSettings = {
    Enabled = false,
    TeamCheck = true,
    VisibleCheck = true,
    FOV = 100,
    AimPart = "Head",
    Prediction = 0,
    HitChanceEnabled = false,
    HitChance = 100
}

Core.TriggerSettings = {
    Enabled = false,
    TeamCheck = true,
    Delay = 0,
    HeadOnly = false,
    HitChance = 100
}

Core.AntiAimSettings = {
    Enabled = false,
    Type = "Spin",
    Speed = 10
}

Core.WorldSettings = {
    Time = 12,
    Brightness = 1,
    Contrast = 0,
    Saturation = 0,
    Ambient = Color3.fromRGB(127,127,127),
    OutdoorAmbient = Color3.fromRGB(127,127,127),
    Skybox = "Default",
    NoFog = false,
    Fullbright = false,
    NoShadows = false,
    NoParticles = false,
    NoPostEffects = false,
    LowGraphics = false,
    Stars = true
}

Core.Skyboxes = {
    Default = {},
    Night = {SkyboxBk = "rbxassetid://1001657105", SkyboxDn = "rbxassetid://1001657105", SkyboxFt = "rbxassetid://1001657105", SkyboxLf = "rbxassetid://1001657105", SkyboxRt = "rbxassetid://1001657105", SkyboxUp = "rbxassetid://1001657105"},
    Sunset = {SkyboxBk = "rbxassetid://1001657105", SkyboxDn = "rbxassetid://1001657105", SkyboxFt = "rbxassetid://1001657105", SkyboxLf = "rbxassetid://1001657105", SkyboxRt = "rbxassetid://1001657105", SkyboxUp = "rbxassetid://1001657105"},
    Galaxy = {SkyboxBk = "rbxassetid://159454299", SkyboxDn = "rbxassetid://159454299", SkyboxFt = "rbxassetid://159454299", SkyboxLf = "rbxassetid://159454299", SkyboxRt = "rbxassetid://159454299", SkyboxUp = "rbxassetid://159454299"},
    Cloudy = {SkyboxBk = "rbxassetid://158926942", SkyboxDn = "rbxassetid://158926942", SkyboxFt = "rbxassetid://158926942", SkyboxLf = "rbxassetid://158926942", SkyboxRt = "rbxassetid://158926942", SkyboxUp = "rbxassetid://158926942"},
    Pink = {SkyboxBk = "rbxassetid://2542891783", SkyboxDn = "rbxassetid://2542891783", SkyboxFt = "rbxassetid://2542891783", SkyboxLf = "rbxassetid://2542891783", SkyboxRt = "rbxassetid://2542891783", SkyboxUp = "rbxassetid://2542891783"},
    Vaporwave = {SkyboxBk = "rbxassetid://1417494030", SkyboxDn = "rbxassetid://1417494030", SkyboxFt = "rbxassetid://1417494030", SkyboxLf = "rbxassetid://1417494030", SkyboxRt = "rbxassetid://1417494030", SkyboxUp = "rbxassetid://1417494030"},
    ["Blood Moon"] = {SkyboxBk = "rbxassetid://129733373", SkyboxDn = "rbxassetid://129733373", SkyboxFt = "rbxassetid://129733373", SkyboxLf = "rbxassetid://129733373", SkyboxRt = "rbxassetid://129733373", SkyboxUp = "rbxassetid://129733373"}
}

Core.CBSettings = {
    NoSpread = false,
    NoRecoil = false,
    InfAmmo = false,
    RapidFire = false,
    InstantReload = false,
    KillAll = false,
    InfCash = false,
    BHop = false,
    BHopKey = Enum.KeyCode.Space,
    AntiAimbot = false,
    AntiAimbotYaw = "Default",
    AntiAimbotSpeed = 50,
    RemoveHeadHitbox = false,
    FakeAngle = false,
    NoScope = false,
    FreeCam = false,
    AutoDefuse = false,
    AutoPlant = false,
    RemoveEffects = {
        Flash = false,
        Smoke = false,
        Blood = false,
        Tracers = false,
        MuzzleFlash = false,
        Decals = false
    },
    ThirdPerson = false,
    ThirdPersonDistance = 10
}

Core.MM2Settings = {
    ShowRole = true,
    AutoPickupGun = false,
    AutoPickupKnife = false,
    NotifyOnPickup = true,
    GunGrabRadius = 25,
    CoinCollector = false,
    TrapDetector = false
}

Core.Loops = {}
Core.OriginalValues = {}
Core.ESPObjects = {}
Core.ChamsObjects = {}
Core.ObjectESPCache = {}
Core.MM2Roles = {}
Core.MM2TrackedDrops = {}
Core.LockedTarget = nil
Core.RainbowHue = 0
Core.SilentAimTarget = nil
Core.OriginalSky = nil
Core.OriginalLighting = {}
Core.BHopHolding = false
Core.AutoShootConnection = nil
Core.NotifyCallback = nil
Core.Whitelist = {}
Core.Blacklist = {}

Core.SkeletonParts = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

Core.SkeletonPartsR6 = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

Core.AimParts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}

function Core.GetMousePosition()
    if Core.IsMobile then
        return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    local success, pos = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if success then
        return pos
    end
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function Core.SafeClick()
    if Core.IsMobile then return end
    pcall(function()
        if mouse1click then
            mouse1click()
        end
    end)
end

function Core.SafeMouseMove(deltaX, deltaY)
    if Core.IsMobile then return end
    pcall(function()
        if mousemoverel then
            mousemoverel(deltaX, deltaY)
        end
    end)
end

function Core.SafeFireProximityPrompt(prompt)
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        elseif prompt and prompt.Enabled then
            prompt:InputHoldBegin()
            task.delay(prompt.HoldDuration or 0.5, function()
                pcall(function() prompt:InputHoldEnd() end)
            end)
        end
    end)
end

function Core.CreateDrawing(t, props)
    local success, d = pcall(function() return Drawing.new(t) end)
    if not success or not d or type(d) == "number" then
        return {
            Visible = false, Color = Color3.new(1,1,1), Thickness = 1, Filled = false, 
            Transparency = 1, Size = Vector2.new(0,0), Position = Vector2.new(0,0), 
            From = Vector2.new(0,0), To = Vector2.new(0,0), Center = true, Outline = true, 
            Text = "", Radius = 5, PointA = Vector2.new(0,0), PointB = Vector2.new(0,0), 
            PointC = Vector2.new(0,0), Font = 2, Remove = function() end
        }
    end
    for k, v in pairs(props or {}) do pcall(function() d[k] = v end) end
    return d
end

function Core.IsAlive(plr)
    if not plr or not plr.Character then return false end
    local h = plr.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

function Core.IsVisible(part)
    if not part then return false end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * (part.Position - origin).Magnitude
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(origin, direction, params)
    if result then return result.Instance:IsDescendantOf(part.Parent) end
    return true
end

function Core.CanShootThrough(origin, target)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(origin, (target - origin).Unit * (target - origin).Magnitude, params)
    if not result then return true end
    local material = result.Instance.Material
    local penetrableMaterials = {
        Enum.Material.Glass,
        Enum.Material.Wood,
        Enum.Material.WoodPlanks,
        Enum.Material.Plastic
    }
    for _, mat in pairs(penetrableMaterials) do
        if material == mat then return true end
    end
    if result.Instance.Transparency > 0.5 then return true end
    return false
end

function Core.GetRainbowColor()
    Core.RainbowHue = (Core.RainbowHue + Core.ESPSettings.Rainbow.Speed / 360) % 1
    return Color3.fromHSV(Core.RainbowHue, 1, 1)
end

function Core.GetRandomAimPart(char)
    local validParts = {}
    for _, partName in ipairs(Core.AimParts) do
        local part = char:FindFirstChild(partName)
        if part then
            table.insert(validParts, part)
        end
    end
    if #validParts > 0 then
        return validParts[math.random(1, #validParts)]
    end
    return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

function Core.GetAimPart(char, aimPartSetting)
    if aimPartSetting == "Random" then
        return Core.GetRandomAimPart(char)
    end
    return char:FindFirstChild(aimPartSetting) or char:FindFirstChild("Head")
end

function Core.IsWhitelisted(player)
    return Core.Whitelist[player.Name] or Core.Whitelist[player.UserId]
end

function Core.IsBlacklisted(player)
    return Core.Blacklist[player.Name] or Core.Blacklist[player.UserId]
end

function Core.GetMM2Role(player)
    if Core.GameName ~= "Murder Mystery 2" then return "Innocent" end
    if Core.MM2Roles[player] then return Core.MM2Roles[player] end
    
    local function checkForWeapon(container, weaponType)
        if not container then return false end
        for _, v in pairs(container:GetChildren()) do
            if v:IsA("Tool") then
                local name = v.Name:lower()
                if weaponType == "knife" and (name:find("knife") or name == "knife") then return true end
                if weaponType == "gun" and (name:find("gun") or name:find("revolver")) then return true end
            end
        end
        return false
    end
    
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    if checkForWeapon(char, "knife") or checkForWeapon(backpack, "knife") then 
        Core.MM2Roles[player] = "Murderer"
    elseif checkForWeapon(char, "gun") or checkForWeapon(backpack, "gun") then 
        Core.MM2Roles[player] = "Sheriff"
    else 
        Core.MM2Roles[player] = "Innocent" 
    end
    
    return Core.MM2Roles[player]
end

function Core.GetESPColor(player)
    if Core.ESPSettings.Rainbow.On then return Core.GetRainbowColor() end
    
    if Core.ESPSettings.UseTeamColor and player.Team then
        return player.TeamColor.Color
    end
    
    if Core.ESPSettings.VisibleCheck then
        local head = player.Character and player.Character:FindFirstChild("Head")
        if head and Core.IsVisible(head) then return Core.ESPSettings.VisibleColor end
    end
    
    if Core.GameName == "Murder Mystery 2" and Core.ESPSettings.ShowRole then
        local role = Core.GetMM2Role(player)
        if role == "Murderer" then return Core.ESPSettings.MurdererColor end
        if role == "Sheriff" then return Core.ESPSettings.SheriffColor end
        return Core.ESPSettings.InnocentColor
    end
    
    return Core.ESPSettings.Box.Color
end

function Core.GetPlayerThreat(player)
    local threat = 0
    if not Core.IsAlive(player) then return 0 end
    
    local char = player.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        threat = threat + (100 - humanoid.Health)
    end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        threat = threat + 50
    end
    
    if Core.GameName == "Murder Mystery 2" then
        local role = Core.GetMM2Role(player)
        if role == "Murderer" then threat = threat + 100 end
        if role == "Sheriff" then threat = threat + 50 end
    end
    
    return threat
end

function Core.GetClosestPlayer(filterFunc)
    local closest, shortestValue = nil, math.huge
    local mousePos = Core.GetMousePosition()
    local priority = Core.AimbotSettings.Priority
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or not Core.IsAlive(player) then continue end
        if Core.AimbotSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then continue end
        if Core.IsBlacklisted(player) then continue end
        if filterFunc and not filterFunc(player) then continue end
        
        local char = player.Character
        if not char then continue end
        
        local aimPart = Core.GetAimPart(char, Core.AimbotSettings.AimPart)
        if not aimPart then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
        if not onScreen then continue end
        
        local fovDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if fovDist > Core.AimbotSettings.FOV then continue end
        
        if Core.AimbotSettings.VisibleCheck and not Core.IsVisible(aimPart) then
            if Core.AimbotSettings.AutoWall then
                if not Core.CanShootThrough(Camera.CFrame.Position, aimPart.Position) then continue end
            else
                continue
            end
        end
        
        local value
        if priority == "Distance" then
            value = fovDist
        elseif priority == "Health" then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            value = humanoid and humanoid.Health or 100
        elseif priority == "Threat" then
            value = -Core.GetPlayerThreat(player)
        else
            value = fovDist
        end
        
        if value < shortestValue then 
            shortestValue = value 
            closest = player 
        end
    end
    
    return closest
end

function Core.GetSilentAimTarget()
    local closest, shortestDist = nil, Core.SilentAimSettings.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    if Core.SilentAimSettings.HitChanceEnabled then
        if math.random(1, 100) > Core.SilentAimSettings.HitChance then
            return nil
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or not Core.IsAlive(player) then continue end
        if Core.SilentAimSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then continue end
        if Core.IsBlacklisted(player) then continue end
        
        local char = player.Character
        if not char then continue end
        
        local aimPart = Core.GetAimPart(char, Core.SilentAimSettings.AimPart)
        if not aimPart then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
        if not onScreen then continue end
        if Core.SilentAimSettings.VisibleCheck and not Core.IsVisible(aimPart) then continue end
        
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if dist < shortestDist then 
            shortestDist = dist 
            closest = {Player = player, Part = aimPart} 
        end
    end
    
    return closest
end

function Core.GetTriggerTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local ray = Camera:ViewportPointToRay(center.X, center.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    if result and result.Instance then
        local player = Players:GetPlayerFromCharacter(result.Instance.Parent)
        if not player then player = Players:GetPlayerFromCharacter(result.Instance.Parent.Parent) end
        
        if player and player ~= LocalPlayer and Core.IsAlive(player) then
            if Core.TriggerSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then return nil end
            if Core.IsBlacklisted(player) then return nil end
            
            if Core.TriggerSettings.HeadOnly then
                if result.Instance.Name ~= "Head" then return nil end
            end
            
            return player
        end
    end
    
    return nil
end

function Core.AutoShoot()
    if not Core.AimbotSettings.AutoShoot then return end
    if not Core.IsAlive(LocalPlayer) then return end
    if Core.IsMobile then return end
    
    local gun = Core.GetCurrentGun()
    if not gun then return end
    
    local target = Core.GetClosestPlayer()
    if target and Core.IsAlive(target) then
        local char = target.Character
        local aimPart = Core.GetAimPart(char, Core.AimbotSettings.AimPart)
        if aimPart then
            local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
            if onScreen then
                local mousePos = Core.GetMousePosition()
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < Core.AimbotSettings.FOV then
                    Core.SafeClick()
                end
            end
        end
    end
end

function Core.AimAt(player, TargetCircle)
    if not player or not Core.IsAlive(player) then 
        Core.LockedTarget = nil 
        return 
    end
    if Core.IsMobile then return end
    
    local char = player.Character
    if not char then return end
    
    local aimPart = Core.GetAimPart(char, Core.AimbotSettings.AimPart)
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
    
    Core.SafeMouseMove(delta.X, delta.Y)
    
    if TargetCircle then 
        pcall(function() 
            TargetCircle.Position = Vector2.new(screenPos.X, screenPos.Y) 
            TargetCircle.Visible = true 
        end) 
    end
    
    if Core.AimbotSettings.AutoShoot then
        Core.AutoShoot()
    end
end

function Core.UpdateAntiAim()
    if not Core.AntiAimSettings.Enabled then return end
    if not Core.IsAlive(LocalPlayer) then return end
    
    local char = LocalPlayer.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end
    
    humanoid.AutoRotate = false
    
    local aaType = Core.AntiAimSettings.Type
    local speed = Core.AntiAimSettings.Speed
    
    if aaType == "Spin" then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(speed), 0)
    elseif aaType == "Jitter" then
        local angle = math.random(-180, 180)
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(angle), 0)
    elseif aaType == "Random" then
        if math.random(1, 10) == 1 then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(-180, 180)), 0)
        end
    elseif aaType == "Backward" then
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position - Camera.CFrame.LookVector)
    end
end

function Core.CreateESP(plr)
    if Core.ESPObjects[plr] then return end
    Core.ESPObjects[plr] = {
        Box = Core.CreateDrawing("Square", {Thickness = 1, Filled = false}),
        BoxOutline = Core.CreateDrawing("Square", {Thickness = 3, Filled = false, Color = Color3.new(0,0,0)}),
        Name = Core.CreateDrawing("Text", {Size = 13, Center = true, Outline = true, Font = 2}),
        Health = Core.CreateDrawing("Square", {Filled = true}),
        HealthOutline = Core.CreateDrawing("Square", {Filled = true, Color = Color3.new(0,0,0)}),
        HealthText = Core.CreateDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2}),
        Distance = Core.CreateDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2}),
        Weapon = Core.CreateDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2}),
        Tracer = Core.CreateDrawing("Line", {Thickness = 1}),
        HeadDot = Core.CreateDrawing("Circle", {Thickness = 1}),
        LookLine = Core.CreateDrawing("Line", {Thickness = 2}),
        Arrow = Core.CreateDrawing("Triangle", {Filled = true}),
        Flags = Core.CreateDrawing("Text", {Size = 11, Outline = true, Font = 2}),
        Skeleton = {},
        CornerLines = {}
    }
    
    for i = 1, 14 do 
        Core.ESPObjects[plr].Skeleton[i] = Core.CreateDrawing("Line", {Thickness = 1}) 
    end
    
    for i = 1, 8 do
        Core.ESPObjects[plr].CornerLines[i] = Core.CreateDrawing("Line", {Thickness = 1})
    end
end

function Core.RemoveESP(plr)
    local esp = Core.ESPObjects[plr]
    if esp then
        for key, v in pairs(esp) do
            if type(v) == "table" then 
                for _, item in pairs(v) do 
                    pcall(function() if item.Remove then item:Remove() end end) 
                end 
            else
                pcall(function() if v.Remove then v:Remove() end end)
            end
        end
        Core.ESPObjects[plr] = nil
    end
    
    if Core.ChamsObjects[plr] then 
        pcall(function() Core.ChamsObjects[plr]:Destroy() end) 
        Core.ChamsObjects[plr] = nil 
    end
    
    Core.MM2Roles[plr] = nil
end

function Core.HideESP(esp)
    if not esp then return end
    pcall(function() 
        esp.Box.Visible = false 
        esp.BoxOutline.Visible = false 
        esp.Name.Visible = false 
        esp.Health.Visible = false 
        esp.HealthOutline.Visible = false 
        esp.HealthText.Visible = false
        esp.Distance.Visible = false 
        esp.Weapon.Visible = false
        esp.Tracer.Visible = false
        esp.HeadDot.Visible = false
        esp.LookLine.Visible = false
        esp.Arrow.Visible = false
        esp.Flags.Visible = false
    end)
    
    if esp.Skeleton then 
        for _, line in pairs(esp.Skeleton) do 
            pcall(function() line.Visible = false end) 
        end 
    end
    
    if esp.CornerLines then
        for _, line in pairs(esp.CornerLines) do
            pcall(function() line.Visible = false end)
        end
    end
end

function Core.DrawCornerBox(esp, x, y, width, height, color)
    local cornerLength = math.min(width, height) * 0.25
    local lines = esp.CornerLines
    
    lines[1].From = Vector2.new(x, y)
    lines[1].To = Vector2.new(x + cornerLength, y)
    lines[2].From = Vector2.new(x, y)
    lines[2].To = Vector2.new(x, y + cornerLength)
    
    lines[3].From = Vector2.new(x + width, y)
    lines[3].To = Vector2.new(x + width - cornerLength, y)
    lines[4].From = Vector2.new(x + width, y)
    lines[4].To = Vector2.new(x + width, y + cornerLength)
    
    lines[5].From = Vector2.new(x, y + height)
    lines[5].To = Vector2.new(x + cornerLength, y + height)
    lines[6].From = Vector2.new(x, y + height)
    lines[6].To = Vector2.new(x, y + height - cornerLength)
    
    lines[7].From = Vector2.new(x + width, y + height)
    lines[7].To = Vector2.new(x + width - cornerLength, y + height)
    lines[8].From = Vector2.new(x + width, y + height)
    lines[8].To = Vector2.new(x + width, y + height - cornerLength)
    
    for i = 1, 8 do
        lines[i].Color = color
        lines[i].Visible = true
    end
end

function Core.GetTracerOrigin(origin)
    local viewportSize = Camera.ViewportSize
    if origin == "Bottom" then
        return Vector2.new(viewportSize.X / 2, viewportSize.Y)
    elseif origin == "Center" then
        return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    elseif origin == "Top" then
        return Vector2.new(viewportSize.X / 2, 0)
    elseif origin == "Mouse" then
        return Core.GetMousePosition()
    end
    return Vector2.new(viewportSize.X / 2, viewportSize.Y)
end

function Core.DrawOffScreenArrow(esp, targetPos, color)
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    if onScreen then
        esp.Arrow.Visible = false
        return
    end
    
    local viewportSize = Camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local direction = (Vector2.new(screenPos.X, screenPos.Y) - center).Unit
    local radius = Core.ESPSettings.OffScreenArrows.Radius
    local size = Core.ESPSettings.OffScreenArrows.Size
    
    local arrowPos = center + direction * radius
    local angle = math.atan2(direction.Y, direction.X)
    
    local p1 = arrowPos + Vector2.new(math.cos(angle) * size, math.sin(angle) * size)
    local p2 = arrowPos + Vector2.new(math.cos(angle + 2.5) * size * 0.5, math.sin(angle + 2.5) * size * 0.5)
    local p3 = arrowPos + Vector2.new(math.cos(angle - 2.5) * size * 0.5, math.sin(angle - 2.5) * size * 0.5)
    
    esp.Arrow.PointA = p1
    esp.Arrow.PointB = p2
    esp.Arrow.PointC = p3
    esp.Arrow.Color = color
    esp.Arrow.Visible = true
end

function Core.UpdateESP()
    Camera = Workspace.CurrentCamera
    
    for plr, esp in pairs(Core.ESPObjects) do
        if not esp or not Core.ESPSettings.Enabled or not Core.IsAlive(plr) or plr == LocalPlayer then 
            Core.HideESP(esp) 
            if Core.ChamsObjects[plr] then 
                pcall(function() Core.ChamsObjects[plr].Enabled = false end) 
            end 
            continue 
        end
        
        if Core.ESPSettings.TeamCheck and plr.Team == LocalPlayer.Team and plr.Team ~= nil then 
            Core.HideESP(esp) 
            if Core.ChamsObjects[plr] then 
                pcall(function() Core.ChamsObjects[plr].Enabled = false end) 
            end 
            continue 
        end
        
        local char = plr.Character
        if not char then Core.HideESP(esp) continue end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if not root or not head then Core.HideESP(esp) continue end
        
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        
        if dist > Core.ESPSettings.MaxDist then 
            Core.HideESP(esp) 
            if Core.ChamsObjects[plr] then 
                pcall(function() Core.ChamsObjects[plr].Enabled = false end) 
            end 
            continue 
        end
        
        local color = Core.GetESPColor(plr)
        
        if Core.ESPSettings.OffScreenArrows.On and not onScreen then
            Core.DrawOffScreenArrow(esp, root.Position, Core.ESPSettings.OffScreenArrows.Color)
        else
            esp.Arrow.Visible = false
        end
        
        if not onScreen then 
            Core.HideESP(esp)
            if Core.ChamsObjects[plr] then
                pcall(function() Core.ChamsObjects[plr].Enabled = Core.ESPSettings.Chams.On end)
            end
            continue 
        end
        
        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        local height = math.abs(legPos.Y - headPos.Y)
        local width = height * 0.6
        local x, y = pos.X - width / 2, headPos.Y
        
        if Core.ESPSettings.Box.On then
            if Core.ESPSettings.Box.Type == "Corner" then
                esp.Box.Visible = false
                esp.BoxOutline.Visible = false
                Core.DrawCornerBox(esp, x, y, width, height, color)
            else
                for _, line in pairs(esp.CornerLines) do
                    line.Visible = false
                end
                
                pcall(function() 
                    esp.Box.Size = Vector2.new(width, height) 
                    esp.Box.Position = Vector2.new(x, y) 
                    esp.Box.Color = color 
                    esp.Box.Visible = true 
                    
                    if Core.ESPSettings.Box.Outline then
                        esp.BoxOutline.Size = Vector2.new(width, height) 
                        esp.BoxOutline.Position = Vector2.new(x, y) 
                        esp.BoxOutline.Visible = true 
                    else
                        esp.BoxOutline.Visible = false
                    end
                end)
            end
        else 
            pcall(function() 
                esp.Box.Visible = false 
                esp.BoxOutline.Visible = false 
            end)
            for _, line in pairs(esp.CornerLines) do
                line.Visible = false
            end
        end
        
        if Core.ESPSettings.Name.On then 
            pcall(function() 
                local txt = Core.ESPSettings.Name.DisplayName and plr.DisplayName or plr.Name
                if Core.GameName == "Murder Mystery 2" and Core.ESPSettings.ShowRole then 
                    txt = txt .. " [" .. Core.GetMM2Role(plr) .. "]" 
                end 
                esp.Name.Text = txt 
                esp.Name.Position = Vector2.new(x + width / 2, y - 16) 
                esp.Name.Color = color
                esp.Name.Size = Core.ESPSettings.FontSize
                esp.Name.Visible = true 
            end) 
        else 
            pcall(function() esp.Name.Visible = false end) 
        end
        
        if Core.ESPSettings.Health.On and humanoid then
            local health = humanoid.Health
            local maxHealth = humanoid.MaxHealth
            local healthPercent = math.clamp(health / maxHealth, 0, 1)
            local healthColor = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
            
            local barWidth = 3
            local barHeight = height * healthPercent
            local barX, barY
            
            local healthPos = Core.ESPSettings.Health.Position
            if healthPos == "Left" then
                barX = x - barWidth - 3
                barY = y + height - barHeight
            elseif healthPos == "Right" then
                barX = x + width + 3
                barY = y + height - barHeight
            elseif healthPos == "Top" then
                barWidth = width * healthPercent
                barHeight = 3
                barX = x
                barY = y - barHeight - 3
            else
                barWidth = width * healthPercent
                barHeight = 3
                barX = x
                barY = y + height + 3
            end
            
            pcall(function()
                esp.HealthOutline.Size = Vector2.new(barWidth + 2, height + 2)
                esp.HealthOutline.Position = Vector2.new(barX - 1, y - 1)
                esp.HealthOutline.Visible = healthPos == "Left" or healthPos == "Right"
                
                esp.Health.Size = Vector2.new(barWidth, barHeight)
                esp.Health.Position = Vector2.new(barX, barY)
                esp.Health.Color = healthColor
                esp.Health.Visible = true
            end)
            
            if Core.ESPSettings.Health.Text then
                pcall(function()
                    esp.HealthText.Text = tostring(math.floor(health))
                    esp.HealthText.Position = Vector2.new(barX + barWidth / 2, barY - 12)
                    esp.HealthText.Color = healthColor
                    esp.HealthText.Visible = true
                end)
            else
                esp.HealthText.Visible = false
            end
        else
            pcall(function() 
                esp.Health.Visible = false 
                esp.HealthOutline.Visible = false 
                esp.HealthText.Visible = false
            end)
        end
        
        if Core.ESPSettings.Distance.On then
            pcall(function()
                esp.Distance.Text = string.format("[%dm]", math.floor(dist))
                esp.Distance.Position = Vector2.new(x + width / 2, y + height + 2)
                esp.Distance.Color = Core.ESPSettings.Distance.Color
                esp.Distance.Visible = true
            end)
        else
            esp.Distance.Visible = false
        end
        
        if Core.ESPSettings.Weapon.On then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    esp.Weapon.Text = tool.Name
                    esp.Weapon.Position = Vector2.new(x + width / 2, y + height + (Core.ESPSettings.Distance.On and 14 or 2))
                    esp.Weapon.Color = Core.ESPSettings.Weapon.Color
                    esp.Weapon.Visible = true
                end)
            else
                esp.Weapon.Visible = false
            end
        else
            esp.Weapon.Visible = false
        end
        
        if Core.ESPSettings.Tracers.On then
            local origin = Core.GetTracerOrigin(Core.ESPSettings.Tracers.Origin)
            pcall(function()
                esp.Tracer.From = origin
                esp.Tracer.To = Vector2.new(pos.X, legPos.Y)
                esp.Tracer.Color = Core.ESPSettings.Tracers.Color
                esp.Tracer.Visible = true
            end)
        else
            esp.Tracer.Visible = false
        end
        
        if Core.ESPSettings.HeadDot.On and head then
            local headScreenPos = Camera:WorldToViewportPoint(head.Position)
            pcall(function()
                esp.HeadDot.Position = Vector2.new(headScreenPos.X, headScreenPos.Y)
                esp.HeadDot.Radius = math.clamp(1000 / dist, 2, 10)
                esp.HeadDot.Color = Core.ESPSettings.HeadDot.Color
                esp.HeadDot.Filled = Core.ESPSettings.HeadDot.Filled
                esp.HeadDot.Visible = true
            end)
        else
            esp.HeadDot.Visible = false
        end
        
        if Core.ESPSettings.LookDirection.On and head then
            local lookVector = head.CFrame.LookVector
            local lookEnd = head.Position + lookVector * 5
            local lookEndScreen, lookOnScreen = Camera:WorldToViewportPoint(lookEnd)
            local headScreen = Camera:WorldToViewportPoint(head.Position)
            
            if lookOnScreen then
                pcall(function()
                    esp.LookLine.From = Vector2.new(headScreen.X, headScreen.Y)
                    esp.LookLine.To = Vector2.new(lookEndScreen.X, lookEndScreen.Y)
                    esp.LookLine.Color = Core.ESPSettings.LookDirection.Color
                    esp.LookLine.Visible = true
                end)
            else
                esp.LookLine.Visible = false
            end
        else
            esp.LookLine.Visible = false
        end
        
        if Core.ESPSettings.Skeleton.On then 
            pcall(function() 
                local parts = char:FindFirstChild("UpperTorso") and Core.SkeletonParts or Core.SkeletonPartsR6 
                for i, conn in ipairs(parts) do 
                    local p1, p2 = char:FindFirstChild(conn[1]), char:FindFirstChild(conn[2]) 
                    local line = esp.Skeleton[i] 
                    if p1 and p2 and line then 
                        local v1, os1 = Camera:WorldToViewportPoint(p1.Position) 
                        local v2, os2 = Camera:WorldToViewportPoint(p2.Position) 
                        if os1 and os2 then 
                            line.From = Vector2.new(v1.X, v1.Y) 
                            line.To = Vector2.new(v2.X, v2.Y) 
                            line.Color = Core.ESPSettings.Skeleton.Color 
                            line.Visible = true 
                        else 
                            line.Visible = false 
                        end 
                    elseif line then 
                        line.Visible = false 
                    end 
                end 
            end) 
        else 
            if esp.Skeleton then 
                for _, line in pairs(esp.Skeleton) do 
                    pcall(function() line.Visible = false end) 
                end 
            end 
        end
        
        if Core.ESPSettings.Chams.On then 
            pcall(function() 
                if not Core.ChamsObjects[plr] then 
                    local hl = Instance.new("Highlight") 
                    hl.Adornee = char 
                    hl.Parent = CoreGui 
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
                    Core.ChamsObjects[plr] = hl 
                end 
                
                local shouldShow = true
                if Core.ESPSettings.Chams.VisibleOnly then
                    shouldShow = head and Core.IsVisible(head)
                end
                
                Core.ChamsObjects[plr].FillColor = color 
                Core.ChamsObjects[plr].OutlineColor = Core.ESPSettings.Chams.OutlineColor 
                Core.ChamsObjects[plr].FillTransparency = Core.ESPSettings.Chams.Transparency 
                Core.ChamsObjects[plr].Enabled = shouldShow
            end) 
        else 
            if Core.ChamsObjects[plr] then 
                pcall(function() Core.ChamsObjects[plr].Enabled = false end) 
            end 
        end
    end
    
    if Core.AntiAimSettings.Enabled then
        Core.UpdateAntiAim()
    end
end

function Core.SetTime(time) 
    Lighting.ClockTime = time 
end

function Core.SetBrightness(brightness) 
    Lighting.Brightness = brightness 
end

function Core.SetContrast(contrast)
    local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Parent = Lighting
    end
    cc.Contrast = contrast
end

function Core.SetSaturation(saturation)
    local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Parent = Lighting
    end
    cc.Saturation = saturation
end

function Core.SetAmbient(color) 
    Lighting.Ambient = color 
end

function Core.SetOutdoorAmbient(color)
    Lighting.OutdoorAmbient = color
end

function Core.SetSkybox(name) 
    local sky = Lighting:FindFirstChildOfClass("Sky") 
    
    if name == "Default" then 
        if sky and Core.OriginalSky then 
            for prop, val in pairs(Core.OriginalSky) do 
                pcall(function() sky[prop] = val end) 
            end 
        end 
        return 
    end 
    
    local skyData = Core.Skyboxes[name] 
    if not skyData then return end 
    
    if not sky then 
        sky = Instance.new("Sky") 
        sky.Parent = Lighting 
    end 
    
    if not Core.OriginalSky and sky then 
        Core.OriginalSky = {
            SkyboxBk = sky.SkyboxBk, 
            SkyboxDn = sky.SkyboxDn, 
            SkyboxFt = sky.SkyboxFt, 
            SkyboxLf = sky.SkyboxLf, 
            SkyboxRt = sky.SkyboxRt, 
            SkyboxUp = sky.SkyboxUp
        } 
    end 
    
    for prop, val in pairs(skyData) do 
        pcall(function() sky[prop] = val end) 
    end 
end

function Core.SetStars(enabled)
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        sky.StarCount = enabled and 3000 or 0
    end
end

function Core.SetFullbright(enabled) 
    if enabled then 
        if not Core.OriginalLighting.Brightness then
            Core.OriginalLighting = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient
            }
        end
        
        Lighting.Brightness = 2 
        Lighting.ClockTime = 14 
        Lighting.FogEnd = 100000 
        Lighting.GlobalShadows = false 
        Lighting.Ambient = Color3.new(1,1,1) 
        Lighting.OutdoorAmbient = Color3.new(1,1,1) 
    else 
        if Core.OriginalLighting.Brightness then
            Lighting.Brightness = Core.OriginalLighting.Brightness
            Lighting.ClockTime = Core.OriginalLighting.ClockTime
            Lighting.FogEnd = Core.OriginalLighting.FogEnd
            Lighting.GlobalShadows = Core.OriginalLighting.GlobalShadows
            Lighting.Ambient = Core.OriginalLighting.Ambient
            Lighting.OutdoorAmbient = Core.OriginalLighting.OutdoorAmbient
        else
            Lighting.Brightness = 1 
            Lighting.GlobalShadows = true 
        end
    end 
end

function Core.SetNoFog(enabled) 
    if enabled then
        if not Core.OriginalLighting.FogEnd then
            Core.OriginalLighting.FogEnd = Lighting.FogEnd
            Core.OriginalLighting.FogStart = Lighting.FogStart
        end
        Lighting.FogEnd = 100000 
        Lighting.FogStart = 100000
    else
        Lighting.FogEnd = Core.OriginalLighting.FogEnd or 1000
        Lighting.FogStart = Core.OriginalLighting.FogStart or 0
    end
end

function Core.SetNoShadows(enabled)
    Lighting.GlobalShadows = not enabled
end

function Core.SetNoParticles(enabled)
    if enabled then
        if Core.Loops.NoParticles then Core.Loops.NoParticles:Disconnect() end
        Core.Loops.NoParticles = RunService.Heartbeat:Connect(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end
        end)
    else
        if Core.Loops.NoParticles then
            Core.Loops.NoParticles:Disconnect()
            Core.Loops.NoParticles = nil
        end
    end
end

function Core.SetNoPostEffects(enabled)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then
            v.Enabled = not enabled
        end
    end
end

function Core.SetLowGraphics(enabled)
    if enabled then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end
end

function Core.GetCurrentGun() 
    if not Core.IsAlive(LocalPlayer) then return nil end 
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do 
        if v:IsA("Tool") then return v end 
    end 
    return nil 
end

function Core.MM2GetClosestDrop(dropType)
    if Core.GameName ~= "Murder Mystery 2" then return nil, math.huge end
    if not Core.IsAlive(LocalPlayer) then return nil, math.huge end
    
    local char = LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    
    local closest, closestDist = nil, math.huge
    
    for _, v in pairs(Workspace:GetChildren()) do
        local isValidDrop = false
        if dropType == "Gun" and v.Name == "GunDrop" then
            isValidDrop = true
        elseif dropType == "Knife" and v.Name == "KnifeDrop" then
            isValidDrop = true
        elseif dropType == "Any" and (v.Name == "GunDrop" or v.Name == "KnifeDrop") then
            isValidDrop = true
        end
        
        if isValidDrop then
            local handle = v:FindFirstChild("Handle") or v:FindFirstChildOfClass("BasePart")
            if handle then
                local dist = (handle.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = v
                end
            end
        end
    end
    
    return closest, closestDist
end

function Core.MM2PickupDrop(drop)
    if not drop then return false end
    if not Core.IsAlive(LocalPlayer) then return false end
    
    local char = LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local handle = drop:FindFirstChild("Handle") or drop:FindFirstChildOfClass("BasePart")
    if not handle then return false end
    
    pcall(function()
        hrp.CFrame = handle.CFrame * CFrame.new(0, 3, 0)
    end)
    
    local prompt = drop:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        Core.SafeFireProximityPrompt(prompt)
    end
    
    local clickDetector = drop:FindFirstChildOfClass("ClickDetector")
    if clickDetector then
        pcall(function()
            fireclickdetector(clickDetector)
        end)
    end
    
    return true
end

function Core.MM2AutoPickup(enabled, dropType)
    if Core.GameName ~= "Murder Mystery 2" then return end
    
    if dropType == "Gun" then
        Core.MM2Settings.AutoPickupGun = enabled
    elseif dropType == "Knife" then
        Core.MM2Settings.AutoPickupKnife = enabled
    end
    
    if Core.Loops.MM2AutoPickup then
        Core.Loops.MM2AutoPickup:Disconnect()
        Core.Loops.MM2AutoPickup = nil
    end
    
    if Core.MM2Settings.AutoPickupGun or Core.MM2Settings.AutoPickupKnife then
        local lastPickupTime = 0
        Core.Loops.MM2AutoPickup = RunService.Heartbeat:Connect(function()
            if tick() - lastPickupTime < 0.5 then return end
            if not Core.IsAlive(LocalPlayer) then return end
            
            local myRole = Core.GetMM2Role(LocalPlayer)
            
            if Core.MM2Settings.AutoPickupGun and myRole ~= "Murderer" then
                local hasGun = false
                for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("revolver")) then
                        hasGun = true
                        break
                    end
                end
                
                if not hasGun then
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    if backpack then
                        for _, tool in pairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("revolver")) then
                                hasGun = true
                                break
                            end
                        end
                    end
                end
                
                if not hasGun then
                    local gunDrop, dist = Core.MM2GetClosestDrop("Gun")
                    if gunDrop and dist < Core.MM2Settings.GunGrabRadius then
                        Core.MM2PickupDrop(gunDrop)
                        lastPickupTime = tick()
                        return
                    end
                end
            end
            
            if Core.MM2Settings.AutoPickupKnife then
                local knifeDrop, dist = Core.MM2GetClosestDrop("Knife")
                if knifeDrop and dist < 500 then
                    Core.MM2PickupDrop(knifeDrop)
                    lastPickupTime = tick()
                end
            end
        end)
    end
end

function Core.MM2SetupPickupNotifications()
    if Core.GameName ~= "Murder Mystery 2" then return end
    
    if Core.Loops.MM2DropAdded then
        Core.Loops.MM2DropAdded:Disconnect()
        Core.Loops.MM2DropAdded = nil
    end
    if Core.Loops.MM2DropRemoved then
        Core.Loops.MM2DropRemoved:Disconnect()
        Core.Loops.MM2DropRemoved = nil
    end
    
    Core.MM2TrackedDrops = {}
    
    for _, v in pairs(Workspace:GetChildren()) do
        if v.Name == "GunDrop" or v.Name == "KnifeDrop" then
            Core.MM2TrackedDrops[v] = {
                Name = v.Name,
                Position = v:FindFirstChild("Handle") and v.Handle.Position or v:GetPivot().Position,
                Time = tick()
            }
        end
    end
    
    Core.Loops.MM2DropAdded = Workspace.ChildAdded:Connect(function(child)
        task.defer(function()
            if child.Name == "GunDrop" or child.Name == "KnifeDrop" then
                local handle = child:WaitForChild("Handle", 1) or child:FindFirstChildOfClass("BasePart")
                Core.MM2TrackedDrops[child] = {
                    Name = child.Name,
                    Position = handle and handle.Position or Vector3.new(0, 0, 0),
                    Time = tick()
                }
                
                if Core.MM2Settings.NotifyOnPickup and Core.NotifyCallback then
                    local weaponType = child.Name == "GunDrop" and "Gun" or "Knife"
                    Core.NotifyCallback("A " .. weaponType .. " has been dropped!", 3)
                end
            end
        end)
    end)
    
    Core.Loops.MM2DropRemoved = Workspace.ChildRemoved:Connect(function(child)
        if Core.MM2TrackedDrops[child] then
            local dropData = Core.MM2TrackedDrops[child]
            Core.MM2TrackedDrops[child] = nil
            
            if not Core.MM2Settings.NotifyOnPickup then return end
            
            local closestPlayer, closestDist = nil, 25
            local dropPos = dropData.Position
            
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - dropPos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = plr
                    end
                end
            end
            
            if closestPlayer and Core.NotifyCallback then
                local weaponType = dropData.Name == "GunDrop" and "Gun" or "Knife"
                Core.MM2Roles[closestPlayer] = nil
                task.defer(function()
                    local role = Core.GetMM2Role(closestPlayer)
                    local roleIcon = role == "Murderer" and "🔴" or (role == "Sheriff" and "🔵" or "🟢")
                    Core.NotifyCallback(roleIcon .. " " .. closestPlayer.Name .. " picked up the " .. weaponType .. "!", 5)
                end)
            end
        end
    end)
end

function Core.CBNoSpread(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoSpread = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local spread = weapon:FindFirstChild("Spread")
        if spread then
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

function Core.CBNoRecoil(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoRecoil = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        for _, name in ipairs({"Recoil", "CamRecoil", "KickBack"}) do
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
    if Core.GameName ~= "Counter Blox" then return end
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

function Core.CBInstantReload(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.InstantReload = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
        local reloadTime = weapon:FindFirstChild("ReloadTime")
        if reloadTime and reloadTime:IsA("NumberValue") then
            if enabled then
                if not Core.OriginalValues[reloadTime] then Core.OriginalValues[reloadTime] = reloadTime.Value end
                reloadTime.Value = 0.01
            else
                if Core.OriginalValues[reloadTime] then reloadTime.Value = Core.OriginalValues[reloadTime] end
            end
        end
    end
end

function Core.CBInfAmmo(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.InfAmmo = enabled
    
    if enabled then
        if Core.Loops.CBInfAmmo then Core.Loops.CBInfAmmo:Disconnect() end
        Core.Loops.CBInfAmmo = RunService.Heartbeat:Connect(function()
            local gun = Core.GetCurrentGun()
            if gun then
                local ammo = gun:FindFirstChild("Ammo")
                local storedAmmo = gun:FindFirstChild("StoredAmmo")
                if ammo and ammo:IsA("NumberValue") then ammo.Value = 999 end
                if storedAmmo and storedAmmo:IsA("NumberValue") then storedAmmo.Value = 999 end
            end
        end)
    else
        if Core.Loops.CBInfAmmo then Core.Loops.CBInfAmmo:Disconnect() Core.Loops.CBInfAmmo = nil end
    end
end

function Core.CBKillAll(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.KillAll = enabled
    
    if enabled then
        if Core.Loops.CBKillAll then Core.Loops.CBKillAll:Disconnect() end
        local lastKill = 0
        Core.Loops.CBKillAll = RunService.Heartbeat:Connect(function()
            if tick() - lastKill < 0.1 then return end
            pcall(function()
                if not Core.IsAlive(LocalPlayer) then return end
                local gun = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if not gun then return end
                
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and Core.IsAlive(v) then
                        if Core.AimbotSettings.TeamCheck and v.Team == LocalPlayer.Team and v.Team ~= nil then continue end
                        local head = v.Character:FindFirstChild("Head")
                        if head then
                            local hitEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("HitPart")
                            if hitEvent then 
                                hitEvent:FireServer(head, head.Position, "Banana", 100, gun, nil, nil, 100, false, false, Vector3.new(), 100, Vector3.new()) 
                            end
                        end
                    end
                end
                lastKill = tick()
            end)
        end)
    else
        if Core.Loops.CBKillAll then Core.Loops.CBKillAll:Disconnect() Core.Loops.CBKillAll = nil end
    end
end

function Core.CBInfCash(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.InfCash = enabled
    
    if enabled then
        pcall(function()
            local cash = LocalPlayer:FindFirstChild("Cash")
            if cash then
                cash.Value = 16000
                if Core.Loops.CBInfCash then Core.Loops.CBInfCash:Disconnect() end
                Core.Loops.CBInfCash = cash:GetPropertyChangedSignal("Value"):Connect(function() 
                    cash.Value = 16000 
                end)
            end
        end)
    else
        if Core.Loops.CBInfCash then Core.Loops.CBInfCash:Disconnect() Core.Loops.CBInfCash = nil end
    end
end

function Core.CBBHop(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.BHop = enabled
    
    if enabled then
        if Core.Loops.CBBHopInput then Core.Loops.CBBHopInput:Disconnect() end
        if Core.Loops.CBBHopInputEnd then Core.Loops.CBBHopInputEnd:Disconnect() end
        if Core.Loops.CBBHop then Core.Loops.CBBHop:Disconnect() end
        
        Core.Loops.CBBHopInput = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Core.CBSettings.BHopKey or input.UserInputType == Enum.UserInputType.Touch then
                Core.BHopHolding = true
            end
        end)
        
        Core.Loops.CBBHopInputEnd = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Core.CBSettings.BHopKey or input.UserInputType == Enum.UserInputType.Touch then
                Core.BHopHolding = false
            end
        end)
        
        Core.Loops.CBBHop = RunService.Heartbeat:Connect(function()
            if Core.BHopHolding and Core.IsAlive(LocalPlayer) then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.FloorMaterial ~= Enum.Material.Air then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        Core.BHopHolding = false
        if Core.Loops.CBBHopInput then Core.Loops.CBBHopInput:Disconnect() Core.Loops.CBBHopInput = nil end
        if Core.Loops.CBBHopInputEnd then Core.Loops.CBBHopInputEnd:Disconnect() Core.Loops.CBBHopInputEnd = nil end
        if Core.Loops.CBBHop then Core.Loops.CBBHop:Disconnect() Core.Loops.CBBHop = nil end
    end
end

function Core.CBAutoDefuse(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.AutoDefuse = enabled
    
    if enabled then
        if Core.Loops.CBAutoDefuse then Core.Loops.CBAutoDefuse:Disconnect() end
        Core.Loops.CBAutoDefuse = RunService.Heartbeat:Connect(function()
            if not Core.IsAlive(LocalPlayer) then return end
            
            local bomb = Workspace:FindFirstChild("Bomb") or Workspace:FindFirstChild("C4")
            if bomb then
                local prompt = bomb:FindFirstChildOfClass("ProximityPrompt")
                if prompt and prompt.Enabled then
                    Core.SafeFireProximityPrompt(prompt)
                end
            end
        end)
    else
        if Core.Loops.CBAutoDefuse then Core.Loops.CBAutoDefuse:Disconnect() Core.Loops.CBAutoDefuse = nil end
    end
end

function Core.CBAutoPlant(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.AutoPlant = enabled
end

function Core.CBThirdPerson(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.ThirdPerson = enabled
    
    if enabled then
        if Core.Loops.CBThirdPerson then Core.Loops.CBThirdPerson:Disconnect() end
        Core.Loops.CBThirdPerson = RunService.Heartbeat:Connect(function()
            if Core.IsAlive(LocalPlayer) then
                LocalPlayer.CameraMinZoomDistance = Core.CBSettings.ThirdPersonDistance
                LocalPlayer.CameraMaxZoomDistance = Core.CBSettings.ThirdPersonDistance
            end
        end)
    else
        if Core.Loops.CBThirdPerson then Core.Loops.CBThirdPerson:Disconnect() Core.Loops.CBThirdPerson = nil end
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 0.5
    end
end

function Core.CBSetThirdPersonDistance(distance)
    Core.CBSettings.ThirdPersonDistance = distance
    if Core.CBSettings.ThirdPerson then
                LocalPlayer.CameraMinZoomDistance = distance
        LocalPlayer.CameraMaxZoomDistance = distance
    end
end

function Core.CBFreeCam(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.FreeCam = enabled
    
    if enabled then
        if Core.Loops.CBFreeCam then Core.Loops.CBFreeCam:Disconnect() end
        
        local freeCamPos = Camera.CFrame
        local freeCamSpeed = 1
        
        Core.Loops.CBFreeCam = RunService.RenderStepped:Connect(function(dt)
            local moveVector = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                freeCamSpeed = 3
            else
                freeCamSpeed = 1
            end
            
            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * 50 * freeCamSpeed * dt
            end
            
            freeCamPos = freeCamPos + moveVector
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = CFrame.new(freeCamPos.Position) * (Camera.CFrame - Camera.CFrame.Position)
        end)
    else
        if Core.Loops.CBFreeCam then 
            Core.Loops.CBFreeCam:Disconnect() 
            Core.Loops.CBFreeCam = nil 
        end
        Camera.CameraType = Enum.CameraType.Custom
        if Core.IsAlive(LocalPlayer) then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                Camera.CameraSubject = humanoid
            end
        end
    end
end

function Core.CBAntiAimbot(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.AntiAimbot = enabled
    
    if enabled then
        if Core.Loops.CBAntiAimbot then Core.Loops.CBAntiAimbot:Disconnect() end
        Core.Loops.CBAntiAimbot = RunService.Heartbeat:Connect(function()
            if not Core.IsAlive(LocalPlayer) then return end
            
            local char = LocalPlayer.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if not hum or not hrp then return end
            
            if Core.CBSettings.RemoveHeadHitbox then
                local headHB = char:FindFirstChild("HeadHB")
                if headHB then headHB:Destroy() end
                local fakeHead = char:FindFirstChild("FakeHead")
                if fakeHead then fakeHead:Destroy() end
            end
            
            local yaw = Core.CBSettings.AntiAimbotYaw
            if yaw ~= "Default" then
                hum.AutoRotate = false
                
                if yaw == "Backward" then 
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position - Camera.CFrame.LookVector)
                elseif yaw == "Left" then 
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position - Camera.CFrame.RightVector)
                elseif yaw == "Right" then 
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.RightVector)
                elseif yaw == "Spin" then 
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Core.CBSettings.AntiAimbotSpeed), 0)
                elseif yaw == "Random" then 
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(-180, 180)), 0)
                elseif yaw == "Jitter" then
                    local jitterAngle = math.random() > 0.5 and 90 or -90
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(jitterAngle), 0)
                end
            else
                hum.AutoRotate = true
            end
            
            if Core.CBSettings.FakeAngle then
                local head = char:FindFirstChild("Head")
                if head then
                    local fakeAngle = CFrame.Angles(0, math.rad(180), 0)
                    pcall(function()
                        head.CFrame = head.CFrame * fakeAngle
                    end)
                end
            end
        end)
    else
        if Core.Loops.CBAntiAimbot then 
            Core.Loops.CBAntiAimbot:Disconnect() 
            Core.Loops.CBAntiAimbot = nil 
        end
        if Core.IsAlive(LocalPlayer) then 
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.AutoRotate = true 
            end
        end
    end
end

function Core.CBNoScope(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoScope = enabled
    
    pcall(function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("GUI")
        if not gui then return end
        
        local crosshairs = gui:FindFirstChild("Crosshairs")
        if not crosshairs then return end
        
        local scope = crosshairs:FindFirstChild("Scope")
        if not scope then return end
        
        scope.ImageTransparency = enabled and 1 or 0
        
        if scope:FindFirstChild("Scope") then
            scope.Scope.ImageTransparency = enabled and 1 or 0
            if enabled then 
                scope.Scope.Size = UDim2.new(2,0,2,0) 
                scope.Scope.Position = UDim2.new(-0.5,0,-0.5,0)
            else 
                scope.Scope.Size = UDim2.new(1,0,1,0) 
                scope.Scope.Position = UDim2.new(0,0,0,0) 
            end
            
            if scope.Scope:FindFirstChild("Blur") then
                scope.Scope.Blur.ImageTransparency = enabled and 1 or 0
                if scope.Scope.Blur:FindFirstChild("Blur") then 
                    scope.Scope.Blur.Blur.ImageTransparency = enabled and 1 or 0 
                end
            end
        end
        
        for i = 1, 4 do
            local frame = crosshairs:FindFirstChild("Frame" .. i)
            if frame then frame.Transparency = enabled and 1 or 0 end
        end
    end)
end

function Core.CBRemoveEffects(effects)
    if Core.GameName ~= "Counter Blox" then return end
    
    for effectName, enabled in pairs(effects) do
        Core.CBSettings.RemoveEffects[effectName] = enabled
    end
    
    if Core.Loops.CBRemoveEffects then Core.Loops.CBRemoveEffects:Disconnect() end
    
    local anyEnabled = false
    for _, v in pairs(Core.CBSettings.RemoveEffects) do
        if v then anyEnabled = true break end
    end
    
    if anyEnabled then
        Core.Loops.CBRemoveEffects = RunService.Heartbeat:Connect(function()
            pcall(function()
                if Core.CBSettings.RemoveEffects.Flash then
                    local blnd = LocalPlayer.PlayerGui:FindFirstChild("Blnd")
                    if blnd then blnd.Enabled = false end
                end
                
                local rayIgnore = Workspace:FindFirstChild("Ray_Ignore")
                
                if Core.CBSettings.RemoveEffects.Smoke and rayIgnore then
                    local smokes = rayIgnore:FindFirstChild("Smokes")
                    if smokes then
                        for _, v in pairs(smokes:GetChildren()) do
                            if v.Name == "Smoke" then v:Destroy() end
                        end
                    end
                end
                
                if Core.CBSettings.RemoveEffects.Blood and rayIgnore then
                    for _, v in pairs(rayIgnore:GetDescendants()) do
                        if v.Name:lower():find("blood") or v.Name:lower():find("decal") then
                            v:Destroy()
                        end
                    end
                end
                
                if Core.CBSettings.RemoveEffects.Tracers and rayIgnore then
                    local tracers = rayIgnore:FindFirstChild("Tracers")
                    if tracers then
                        for _, v in pairs(tracers:GetChildren()) do
                            v:Destroy()
                        end
                    end
                end
                
                if Core.CBSettings.RemoveEffects.MuzzleFlash then
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr.Character then
                            for _, v in pairs(plr.Character:GetDescendants()) do
                                if v:IsA("ParticleEmitter") or v:IsA("PointLight") then
                                    if v.Name:lower():find("muzzle") or v.Name:lower():find("flash") then
                                        v.Enabled = false
                                    end
                                end
                            end
                        end
                    end
                end
                
                if Core.CBSettings.RemoveEffects.Decals then
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v:IsA("Decal") and (v.Name:lower():find("bullet") or v.Name:lower():find("hole")) then
                            v:Destroy()
                        end
                    end
                end
            end)
        end)
    end
end

function Core.Rejoin() 
    TeleportService:TeleportToPlaceInstance(Core.PlaceId, game.JobId, LocalPlayer) 
end

function Core.ServerHop()
    local servers = {}
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", Core.PlaceId)
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(Core.PlaceId, randomServer, LocalPlayer)
        end
    end
end

function Core.GetJoinScript() 
    return 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. Core.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)' 
end

function Core.LoadScript(name)
    local scripts = {
        ["Infinite Yield"] = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
        ["Nameless Admin"] = "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source",
        ["CMD-X"] = "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source",
        ["Dex Explorer"] = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua",
        ["Remote Spy"] = "https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua",
        ["Script Dumper"] = "https://raw.githubusercontent.com/infyiff/backup/main/script-dumper.lua",
        ["Save Instance"] = "https://raw.githubusercontent.com/mstudio45/MSTUDIO45/main/saveinstance.lua",
        ["Chat Bypass"] = "https://raw.githubusercontent.com/infyiff/backup/main/chatbypass.lua",
        ["Anti AFK"] = "https://raw.githubusercontent.com/infyiff/backup/main/antiafk.lua"
    }
    
    if scripts[name] then 
        local success, err = pcall(function()
            loadstring(game:HttpGet(scripts[name]))()
        end)
        
        if not success and Core.NotifyCallback then
            Core.NotifyCallback("Failed to load " .. name .. ": " .. tostring(err), 5)
        end
    end
end

function Core.SilentAimCameraMethod() 
    if not Core.SilentAimSettings.Enabled then return end 
    Core.SilentAimTarget = Core.GetSilentAimTarget() 
end

function Core.GetSilentAimPosition() 
    if not Core.SilentAimSettings.Enabled or not Core.SilentAimTarget then return nil end 
    
    local target = Core.SilentAimTarget 
    if not target.Player or not Core.IsAlive(target.Player) or not target.Part then 
        Core.SilentAimTarget = nil 
        return nil 
    end 
    
    local targetPos = target.Part.Position 
    if Core.SilentAimSettings.Prediction > 0 then 
        local root = target.Player.Character:FindFirstChild("HumanoidRootPart") 
        if root then 
            targetPos = targetPos + (root.AssemblyLinearVelocity * (Core.SilentAimSettings.Prediction / 10)) 
        end 
    end 
    
    return targetPos 
end

function Core.Cleanup()
    for name, connection in pairs(Core.Loops) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    Core.Loops = {}
    
    for plr, _ in pairs(Core.ESPObjects) do
        Core.RemoveESP(plr)
    end
    
    for plr, chams in pairs(Core.ChamsObjects) do
        pcall(function() chams:Destroy() end)
    end
    Core.ChamsObjects = {}
    
    for obj, originalValue in pairs(Core.OriginalValues) do
        pcall(function()
            if typeof(obj) == "Instance" and obj:IsA("NumberValue") then
                obj.Value = originalValue
            end
        end)
    end
    Core.OriginalValues = {}
    
    if Core.OriginalLighting.Brightness then
        pcall(function()
            Lighting.Brightness = Core.OriginalLighting.Brightness
            Lighting.ClockTime = Core.OriginalLighting.ClockTime
            Lighting.FogEnd = Core.OriginalLighting.FogEnd
            Lighting.GlobalShadows = Core.OriginalLighting.GlobalShadows
            Lighting.Ambient = Core.OriginalLighting.Ambient
            Lighting.OutdoorAmbient = Core.OriginalLighting.OutdoorAmbient
        end)
    end
    
    if Core.IsAlive(LocalPlayer) then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
        end
    end
    
    Camera.CameraType = Enum.CameraType.Custom
end

function Core.Init()
    for _, plr in pairs(Players:GetPlayers()) do 
        if plr ~= LocalPlayer then 
            Core.CreateESP(plr) 
        end 
    end
    
    Players.PlayerAdded:Connect(function(plr) 
        Core.CreateESP(plr) 
    end)
    
    Players.PlayerRemoving:Connect(function(plr) 
        Core.RemoveESP(plr) 
    end)
    
    if Core.GameName == "Murder Mystery 2" then
        local lastRoleRefresh = 0
        RunService.Heartbeat:Connect(function()
            if tick() - lastRoleRefresh >= 2 then
                Core.MM2Roles = {}
                lastRoleRefresh = tick()
            end
        end)
        
        Core.MM2SetupPickupNotifications()
    end
    
    RunService.Heartbeat:Connect(function() 
        Core.SilentAimCameraMethod() 
    end)
end

return Core
