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

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

Core.SupportedGames = {
    [301549746] = "Counter Blox",
    [292439477] = "Phantom Forces",
    [17625359962] = "Rivals",
    [286090429] = "Arsenal",
    [142823291] = "Murder Mystery 2",
    [3837841034] = "Bad Business",
    [7839390065] = "Flick"
}

Core.PlaceId = game.PlaceId
Core.GameName = Core.SupportedGames[Core.PlaceId] or "Universal"

Core.ESPSettings = {
    Enabled = false,
    Box = {On = false, Color = Color3.new(1,1,1), Type = "Full"},
    Name = {On = false, Color = Color3.new(1,1,1)},
    Health = {On = false, Position = "Left"},
    Distance = {On = false, Color = Color3.new(1,1,1)},
    Skeleton = {On = false, Color = Color3.new(1,1,1)},
    Chams = {On = false, Color = Color3.fromRGB(212,133,240), Transparency = 0.5},
    Tracers = {On = false, Origin = "Bottom", Color = Color3.new(1,1,1)},
    HeadDot = {On = false, Color = Color3.new(1,0,0)},
    Weapon = {On = false, Color = Color3.new(1,1,1)},
    Flags = {On = false, Color = Color3.new(1,1,1)},
    OffScreenArrows = {On = false, Color = Color3.new(1,0,0), Size = 15},
    MaxDist = 2000,
    TeamCheck = false,
    ShowRole = true,
    Rainbow = {On = false, Speed = 1},
    OutlineThickness = 1,
    BoxThickness = 1,
    MurdererColor = Color3.fromRGB(255,0,0),
    SheriffColor = Color3.fromRGB(0,100,255),
    InnocentColor = Color3.fromRGB(0,255,0)
}

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

Core.SilentAimSettings = {
    Enabled = false,
    TeamCheck = true,
    VisibleCheck = true,
    FOV = 100,
    AimPart = "Head",
    Prediction = 0
}

Core.TriggerSettings = {
    Enabled = false,
    TeamCheck = true,
    Delay = 0
}

Core.WorldSettings = {
    Time = 14,
    Brightness = 1,
    Ambient = Color3.fromRGB(127, 127, 127),
    OutdoorAmbient = Color3.fromRGB(127, 127, 127),
    FogEnd = 100000,
    FogColor = Color3.new(1,1,1),
    Skybox = "Default"
}

Core.Skyboxes = {
    Default = nil,
    Night = {
        SkyboxBk = "rbxassetid://12064107",
        SkyboxDn = "rbxassetid://12064152",
        SkyboxFt = "rbxassetid://12064121",
        SkyboxLf = "rbxassetid://12064115",
        SkyboxRt = "rbxassetid://12064134",
        SkyboxUp = "rbxassetid://12064131"
    },
    Galaxy = {
        SkyboxBk = "rbxassetid://159454299",
        SkyboxDn = "rbxassetid://159454296",
        SkyboxFt = "rbxassetid://159454293",
        SkyboxLf = "rbxassetid://159454286",
        SkyboxRt = "rbxassetid://159454300",
        SkyboxUp = "rbxassetid://159454288"
    },
    Sunset = {
        SkyboxBk = "rbxassetid://1012890",
        SkyboxDn = "rbxassetid://1012891",
        SkyboxFt = "rbxassetid://1012887",
        SkyboxLf = "rbxassetid://1012889",
        SkyboxRt = "rbxassetid://1012888",
        SkyboxUp = "rbxassetid://1014449"
    },
    Cloudy = {
        SkyboxBk = "rbxassetid://552628637",
        SkyboxDn = "rbxassetid://552628637",
        SkyboxFt = "rbxassetid://552628637",
        SkyboxLf = "rbxassetid://552628637",
        SkyboxRt = "rbxassetid://552628637",
        SkyboxUp = "rbxassetid://552628637"
    },
    Pink = {
        SkyboxBk = "rbxassetid://2909673068",
        SkyboxDn = "rbxassetid://2909673068",
        SkyboxFt = "rbxassetid://2909673068",
        SkyboxLf = "rbxassetid://2909673068",
        SkyboxRt = "rbxassetid://2909673068",
        SkyboxUp = "rbxassetid://2909673068"
    },
    Vaporwave = {
        SkyboxBk = "rbxassetid://1417494030",
        SkyboxDn = "rbxassetid://1417494146",
        SkyboxFt = "rbxassetid://1417494253",
        SkyboxLf = "rbxassetid://1417494402",
        SkyboxRt = "rbxassetid://1417494499",
        SkyboxUp = "rbxassetid://1417494643"
    }
}

Core.CBSettings = {
    NoSpread = false,
    NoRecoil = false,
    InfAmmo = false,
    RapidFire = false,
    KillAll = false,
    InfCash = false,
    BHop = false,
    AntiAimbot = false,
    AntiAimbotYaw = "Default",
    AntiAimbotSpeed = 50,
    RemoveHeadHitbox = false,
    NoScope = false,
    NoFlash = false,
    NoSmoke = false,
    NoBulletHoles = false,
    NoBlood = false
}

Core.ArsenalSettings = {
    InfAmmo = false,
    NoRecoil = false,
    NoSpread = false,
    RapidFire = false,
    AutoKill = false
}

Core.PFSettings = {
    NoRecoil = false,
    NoSpread = false,
    NoSway = false,
    InstaReload = false,
    NoFlash = false,
    NoSmoke = false,
    RapidFire = false
}

Core.RivalsSettings = {
    NoRecoil = false,
    NoSpread = false,
    InfAmmo = false,
    AutoWin = false
}

Core.FlickSettings = {
    AutoClick = false,
    ClickDelay = 0,
    AutoBuy = false
}

Core.CBLoops = {}
Core.CBOriginalValues = {}
Core.ESPObjects = {}
Core.ChamsObjects = {}
Core.Connections = {}
Core.MM2Roles = {}
Core.LockedTarget = nil
Core.RainbowHue = 0
Core.SilentAimTarget = nil
Core.OriginalSkybox = nil
Core.OriginalLighting = {}

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

function Core.CreateDrawing(t, props)
    local d = Drawing.new(t)
    for k, v in pairs(props) do d[k] = v end
    return d
end

function Core.IsAlive(plr)
    if not plr or not plr.Character then return false end
    local h = plr.Character:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

function Core.IsVisible(part)
    if not part then return false end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 1000
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(origin, direction, params)
    if result then
        return result.Instance:IsDescendantOf(part.Parent)
    end
    return true
end

function Core.GetRainbowColor()
    Core.RainbowHue = (Core.RainbowHue + Core.ESPSettings.Rainbow.Speed / 360) % 1
    return Color3.fromHSV(Core.RainbowHue, 1, 1)
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
    if Core.ESPSettings.Rainbow.On then
        return Core.GetRainbowColor()
    end
    if Core.GameName == "Murder Mystery 2" and Core.ESPSettings.ShowRole then
        local role = Core.GetMM2Role(player)
        if role == "Murderer" then return Core.ESPSettings.MurdererColor end
        if role == "Sheriff" then return Core.ESPSettings.SheriffColor end
        return Core.ESPSettings.InnocentColor
    end
    return Core.ESPSettings.Box.Color
end

function Core.GetPlayerWeapon(player)
    if not player.Character then return "None" end
    for _, v in pairs(player.Character:GetChildren()) do
        if v:IsA("Tool") then
            return v.Name
        end
    end
    return "None"
end

function Core.GetPlayerFlags(player)
    local flags = {}
    if not player.Character then return flags end
    
    local hum = player.Character:FindFirstChild("Humanoid")
    if hum then
        if hum.Health < hum.MaxHealth * 0.3 then
            table.insert(flags, "LOW HP")
        end
    end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and hrp.AssemblyLinearVelocity.Magnitude > 50 then
        table.insert(flags, "FAST")
    end
    
    if Core.GameName == "Murder Mystery 2" then
        local role = Core.GetMM2Role(player)
        if role ~= "Innocent" then
            table.insert(flags, role:upper())
        end
    end
    
    return flags
end

function Core.GetClosestPlayer()
    local closest, shortestDist = nil, Core.AimbotSettings.FOV
    local mousePos = UserInputService:GetMouseLocation()
    
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

function Core.GetSilentAimTarget()
    local closest, shortestDist = nil, Core.SilentAimSettings.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or not Core.IsAlive(player) then continue end
        if Core.SilentAimSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then continue end
        
        local char = player.Character
        if not char then continue end
        
        local aimPart = char:FindFirstChild(Core.SilentAimSettings.AimPart) or char:FindFirstChild("Head")
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
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    if result and result.Instance then
        local player = Players:GetPlayerFromCharacter(result.Instance.Parent)
        if not player then
            player = Players:GetPlayerFromCharacter(result.Instance.Parent.Parent)
        end
        if player and player ~= LocalPlayer and Core.IsAlive(player) then
            if Core.TriggerSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then
                return nil
            end
            return player
        end
    end
    return nil
end

function Core.AimAt(player, TargetCircle)
    if not player or not Core.IsAlive(player) then 
        Core.LockedTarget = nil 
        return 
    end
    
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
    local mousePos = UserInputService:GetMouseLocation()
    local delta = (Vector2.new(screenPos.X, screenPos.Y) - mousePos) / math.max(Core.AimbotSettings.Smoothness, 1)
    
    if mousemoverel then
        mousemoverel(delta.X, delta.Y)
    end
    
    if TargetCircle then
        TargetCircle.Position = Vector2.new(screenPos.X, screenPos.Y)
        TargetCircle.Visible = true
    end
end

function Core.CreateESP(plr)
    if Core.ESPObjects[plr] then return end
    
    Core.ESPObjects[plr] = {
        Box = Core.CreateDrawing("Square", {Thickness = 1, Filled = false, ZIndex = 2}),
        BoxOutline = Core.CreateDrawing("Square", {Thickness = 3, Filled = false, Color = Color3.new(0,0,0), ZIndex = 1}),
        BoxFill = Core.CreateDrawing("Square", {Filled = true, Transparency = 0.5, ZIndex = 0}),
        CornerTL = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 2}),
        CornerTR = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 2}),
        CornerBL = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 2}),
        CornerBR = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 2}),
        CornerTLV = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 2}),
        CornerTRV = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 2}),
        CornerBLV = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 2}),
        CornerBRV = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 2}),
        Name = Core.CreateDrawing("Text", {Size = 13, Center = true, Outline = true, Font = 2, ZIndex = 3}),
        Health = Core.CreateDrawing("Square", {Filled = true, ZIndex = 2}),
        HealthOutline = Core.CreateDrawing("Square", {Filled = true, Color = Color3.new(0,0,0), ZIndex = 1}),
        HealthText = Core.CreateDrawing("Text", {Size = 10, Center = true, Outline = true, Font = 2, ZIndex = 3}),
        Distance = Core.CreateDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2, ZIndex = 3}),
        HeadDot = Core.CreateDrawing("Circle", {Filled = true, Radius = 3, ZIndex = 3}),
        Tracer = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 1}),
        Weapon = Core.CreateDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2, ZIndex = 3}),
        Flags = Core.CreateDrawing("Text", {Size = 10, Center = false, Outline = true, Font = 2, ZIndex = 3}),
        Arrow = Core.CreateDrawing("Triangle", {Filled = true, ZIndex = 5}),
        Skeleton = {}
    }
    
    for i = 1, 14 do
        Core.ESPObjects[plr].Skeleton[i] = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 2})
    end
end

function Core.RemoveESP(plr)
    local esp = Core.ESPObjects[plr]
    if esp then
        for _, v in pairs(esp) do
            if type(v) == "table" then
                for _, line in pairs(v) do pcall(function() line:Remove() end) end
            else
                pcall(function() v:Remove() end)
            end
        end
        Core.ESPObjects[plr] = nil
    end
    
    if Core.ChamsObjects[plr] then
        Core.ChamsObjects[plr]:Destroy()
        Core.ChamsObjects[plr] = nil
    end
    
    Core.MM2Roles[plr] = nil
end

function Core.HideESP(esp)
    esp.Box.Visible = false
    esp.BoxOutline.Visible = false
    esp.BoxFill.Visible = false
    esp.CornerTL.Visible = false
    esp.CornerTR.Visible = false
    esp.CornerBL.Visible = false
    esp.CornerBR.Visible = false
    esp.CornerTLV.Visible = false
    esp.CornerTRV.Visible = false
    esp.CornerBLV.Visible = false
    esp.CornerBRV.Visible = false
    esp.Name.Visible = false
    esp.Health.Visible = false
    esp.HealthOutline.Visible = false
    esp.HealthText.Visible = false
    esp.Distance.Visible = false
    esp.HeadDot.Visible = false
    esp.Tracer.Visible = false
    esp.Weapon.Visible = false
    esp.Flags.Visible = false
    esp.Arrow.Visible = false
    for _, line in pairs(esp.Skeleton) do line.Visible = false end
end

function Core.DrawCornerBox(esp, x, y, width, height, color, thickness)
    local cornerSize = math.min(width, height) / 4
    
    esp.CornerTL.From = Vector2.new(x, y)
    esp.CornerTL.To = Vector2.new(x + cornerSize, y)
    esp.CornerTL.Color = color
    esp.CornerTL.Thickness = thickness
    esp.CornerTL.Visible = true
    
    esp.CornerTLV.From = Vector2.new(x, y)
    esp.CornerTLV.To = Vector2.new(x, y + cornerSize)
    esp.CornerTLV.Color = color
    esp.CornerTLV.Thickness = thickness
    esp.CornerTLV.Visible = true
    
    esp.CornerTR.From = Vector2.new(x + width, y)
    esp.CornerTR.To = Vector2.new(x + width - cornerSize, y)
    esp.CornerTR.Color = color
    esp.CornerTR.Thickness = thickness
    esp.CornerTR.Visible = true
    
    esp.CornerTRV.From = Vector2.new(x + width, y)
    esp.CornerTRV.To = Vector2.new(x + width, y + cornerSize)
    esp.CornerTRV.Color = color
    esp.CornerTRV.Thickness = thickness
    esp.CornerTRV.Visible = true
    
    esp.CornerBL.From = Vector2.new(x, y + height)
    esp.CornerBL.To = Vector2.new(x + cornerSize, y + height)
    esp.CornerBL.Color = color
    esp.CornerBL.Thickness = thickness
    esp.CornerBL.Visible = true
    
    esp.CornerBLV.From = Vector2.new(x, y + height)
    esp.CornerBLV.To = Vector2.new(x, y + height - cornerSize)
    esp.CornerBLV.Color = color
    esp.CornerBLV.Thickness = thickness
    esp.CornerBLV.Visible = true
    
    esp.CornerBR.From = Vector2.new(x + width, y + height)
    esp.CornerBR.To = Vector2.new(x + width - cornerSize, y + height)
    esp.CornerBR.Color = color
    esp.CornerBR.Thickness = thickness
    esp.CornerBR.Visible = true
    
    esp.CornerBRV.From = Vector2.new(x + width, y + height)
    esp.CornerBRV.To = Vector2.new(x + width, y + height - cornerSize)
    esp.CornerBRV.Color = color
    esp.CornerBRV.Thickness = thickness
    esp.CornerBRV.Visible = true
end

function Core.HideCornerBox(esp)
    esp.CornerTL.Visible = false
    esp.CornerTR.Visible = false
    esp.CornerBL.Visible = false
    esp.CornerBR.Visible = false
    esp.CornerTLV.Visible = false
    esp.CornerTRV.Visible = false
    esp.CornerBLV.Visible = false
    esp.CornerBRV.Visible = false
end

function Core.DrawOffScreenArrow(esp, targetPos, color, size)
    local screenCenter = Camera.ViewportSize / 2
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    
    if onScreen then
        esp.Arrow.Visible = false
        return
    end
    
    local direction = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Unit
    local arrowPos = screenCenter + direction * (math.min(screenCenter.X, screenCenter.Y) - 50)
    
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
        if not Core.ESPSettings.Enabled or not Core.IsAlive(plr) or plr == LocalPlayer then
            Core.HideESP(esp)
            if Core.ChamsObjects[plr] then Core.ChamsObjects[plr].Enabled = false end
            continue
        end
        
        if Core.ESPSettings.TeamCheck and plr.Team == LocalPlayer.Team and plr.Team ~= nil then
            Core.HideESP(esp)
            if Core.ChamsObjects[plr] then Core.ChamsObjects[plr].Enabled = false end
            continue
        end
        
        local char = plr.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChild("Humanoid")
        
        if not root or not head or not hum then
            Core.HideESP(esp)
            continue
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        
        if not onScreen then
            if Core.ESPSettings.OffScreenArrows.On then
                Core.DrawOffScreenArrow(esp, root.Position, Core.ESPSettings.OffScreenArrows.Color, Core.ESPSettings.OffScreenArrows.Size)
            else
                esp.Arrow.Visible = false
            end
            Core.HideESP(esp)
            esp.Arrow.Visible = Core.ESPSettings.OffScreenArrows.On
            if Core.ChamsObjects[plr] then Core.ChamsObjects[plr].Enabled = false end
            continue
        end
        
        esp.Arrow.Visible = false
        
        if dist > Core.ESPSettings.MaxDist then
            Core.HideESP(esp)
            if Core.ChamsObjects[plr] then Core.ChamsObjects[plr].Enabled = false end
            continue
        end
        
        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        local height = math.abs(legPos.Y - headPos.Y)
        local width = height * 0.6
        local x, y = pos.X - width / 2, headPos.Y
        local color = Core.GetESPColor(plr)
        
        if Core.ESPSettings.Box.On then
            local boxType = Core.ESPSettings.Box.Type
            
            if boxType == "Full" then
                Core.HideCornerBox(esp)
                esp.BoxOutline.Size = Vector2.new(width, height)
                esp.BoxOutline.Position = Vector2.new(x, y)
                esp.BoxOutline.Thickness = Core.ESPSettings.OutlineThickness + 2
                esp.BoxOutline.Visible = true
                esp.Box.Size = Vector2.new(width, height)
                esp.Box.Position = Vector2.new(x, y)
                esp.Box.Color = color
                esp.Box.Thickness = Core.ESPSettings.BoxThickness
                esp.Box.Visible = true
                esp.BoxFill.Visible = false
            elseif boxType == "Corner" then
                esp.Box.Visible = false
                esp.BoxOutline.Visible = false
                esp.BoxFill.Visible = false
                Core.DrawCornerBox(esp, x, y, width, height, color, Core.ESPSettings.BoxThickness)
            elseif boxType == "Filled" then
                Core.HideCornerBox(esp)
                esp.BoxOutline.Size = Vector2.new(width, height)
                esp.BoxOutline.Position = Vector2.new(x, y)
                esp.BoxOutline.Visible = true
                esp.Box.Size = Vector2.new(width, height)
                esp.Box.Position = Vector2.new(x, y)
                esp.Box.Color = color
                esp.Box.Visible = true
                esp.BoxFill.Size = Vector2.new(width, height)
                esp.BoxFill.Position = Vector2.new(x, y)
                esp.BoxFill.Color = color
                esp.BoxFill.Transparency = 0.7
                esp.BoxFill.Visible = true
            end
        else
            esp.Box.Visible = false
            esp.BoxOutline.Visible = false
            esp.BoxFill.Visible = false
            Core.HideCornerBox(esp)
        end
        
        if Core.ESPSettings.Name.On then
            local txt = plr.Name
            if Core.GameName == "Murder Mystery 2" and Core.ESPSettings.ShowRole then
                txt = txt .. " [" .. Core.GetMM2Role(plr) .. "]"
            end
            esp.Name.Text = txt
            esp.Name.Position = Vector2.new(x + width / 2, y - 16)
            esp.Name.Color = color
            esp.Name.Visible = true
        else
            esp.Name.Visible = false
        end
        
        if Core.ESPSettings.Health.On then
            local hp = hum.Health / hum.MaxHealth
            local barH = height * hp
            local healthX = Core.ESPSettings.Health.Position == "Left" and (x - 6) or (x + width + 2)
            
            esp.HealthOutline.Size = Vector2.new(4, height)
            esp.HealthOutline.Position = Vector2.new(healthX, y)
            esp.HealthOutline.Visible = true
            esp.Health.Size = Vector2.new(2, barH)
            esp.Health.Position = Vector2.new(healthX + 1, y + height - barH)
            esp.Health.Color = Color3.fromRGB(255 - 255 * hp, 255 * hp, 0)
            esp.Health.Visible = true
            
            esp.HealthText.Text = math.floor(hum.Health)
            esp.HealthText.Position = Vector2.new(healthX + 2, y + height - barH - 10)
            esp.HealthText.Color = Color3.new(1,1,1)
            esp.HealthText.Visible = hp < 1
        else
            esp.Health.Visible = false
            esp.HealthOutline.Visible = false
            esp.HealthText.Visible = false
        end
        
        if Core.ESPSettings.Distance.On then
            esp.Distance.Text = math.floor(dist) .. "m"
            esp.Distance.Position = Vector2.new(x + width / 2, y + height + 2)
            esp.Distance.Color = Core.ESPSettings.Distance.Color
            esp.Distance.Visible = true
        else
            esp.Distance.Visible = false
        end
        
        if Core.ESPSettings.Weapon.On then
            local weapon = Core.GetPlayerWeapon(plr)
            esp.Weapon.Text = weapon
            esp.Weapon.Position = Vector2.new(x + width / 2, y + height + (Core.ESPSettings.Distance.On and 14 or 2))
            esp.Weapon.Color = Core.ESPSettings.Weapon.Color
            esp.Weapon.Visible = true
        else
            esp.Weapon.Visible = false
        end
        
        if Core.ESPSettings.Flags.On then
            local flags = Core.GetPlayerFlags(plr)
            esp.Flags.Text = table.concat(flags, "\n")
            esp.Flags.Position = Vector2.new(x + width + 4, y)
            esp.Flags.Color = Core.ESPSettings.Flags.Color
            esp.Flags.Visible = #flags > 0
        else
            esp.Flags.Visible = false
        end
        
        if Core.ESPSettings.HeadDot.On then
            local hp = Camera:WorldToViewportPoint(head.Position)
            esp.HeadDot.Position = Vector2.new(hp.X, hp.Y)
            esp.HeadDot.Color = Core.ESPSettings.HeadDot.Color
            esp.HeadDot.Visible = true
        else
            esp.HeadDot.Visible = false
        end
        
        if Core.ESPSettings.Tracers.On then
            local origin = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            if Core.ESPSettings.Tracers.Origin == "Center" then origin = Camera.ViewportSize / 2
            elseif Core.ESPSettings.Tracers.Origin == "Mouse" then origin = UserInputService:GetMouseLocation()
            elseif Core.ESPSettings.Tracers.Origin == "Top" then origin = Vector2.new(Camera.ViewportSize.X / 2, 0) end
            esp.Tracer.From = origin
            esp.Tracer.To = Vector2.new(x + width / 2, y + height)
            esp.Tracer.Color = color
            esp.Tracer.Visible = true
        else
            esp.Tracer.Visible = false
        end
        
        if Core.ESPSettings.Skeleton.On then
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
        else
            for _, line in pairs(esp.Skeleton) do line.Visible = false end
        end
        
        if Core.ESPSettings.Chams.On then
            if not Core.ChamsObjects[plr] then
                local hl = Instance.new("Highlight")
                hl.Adornee = char
                hl.Parent = CoreGui
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Core.ChamsObjects[plr] = hl
            end
            local hl = Core.ChamsObjects[plr]
            hl.FillColor = color
            hl.FillTransparency = Core.ESPSettings.Chams.Transparency
            hl.OutlineTransparency = 0
            hl.Enabled = true
        else
            if Core.ChamsObjects[plr] then Core.ChamsObjects[plr].Enabled = false end
        end
    end
end

function Core.GetCurrentGun()
    if not Core.IsAlive(LocalPlayer) then return nil end
    local char = LocalPlayer.Character
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") then
            return v
        end
    end
    return nil
end

function Core.SaveLighting()
    Core.OriginalLighting = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogEnd = Lighting.FogEnd,
        FogColor = Lighting.FogColor,
        GlobalShadows = Lighting.GlobalShadows
    }
    
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        Core.OriginalSkybox = sky:Clone()
    end
end

function Core.SetTime(value)
    Core.WorldSettings.Time = value
    Lighting.ClockTime = value
end

function Core.SetBrightness(value)
    Core.WorldSettings.Brightness = value
    Lighting.Brightness = value
end

function Core.SetAmbient(color)
    Core.WorldSettings.Ambient = color
    Lighting.Ambient = color
end

function Core.SetOutdoorAmbient(color)
    Core.WorldSettings.OutdoorAmbient = color
    Lighting.OutdoorAmbient = color
end

function Core.SetFogEnd(value)
    Core.WorldSettings.FogEnd = value
    Lighting.FogEnd = value
end

function Core.SetFogColor(color)
    Core.WorldSettings.FogColor = color
    Lighting.FogColor = color
end

function Core.SetSkybox(name)
    Core.WorldSettings.Skybox = name
    
    local existingSky = Lighting:FindFirstChildOfClass("Sky")
    if existingSky then existingSky:Destroy() end
    
    if name == "Default" then
        if Core.OriginalSkybox then
            Core.OriginalSkybox:Clone().Parent = Lighting
        end
        return
    end
    
    local skyData = Core.Skyboxes[name]
    if skyData then
        local sky = Instance.new("Sky")
        sky.SkyboxBk = skyData.SkyboxBk
        sky.SkyboxDn = skyData.SkyboxDn
        sky.SkyboxFt = skyData.SkyboxFt
        sky.SkyboxLf = skyData.SkyboxLf
        sky.SkyboxRt = skyData.SkyboxRt
        sky.SkyboxUp = skyData.SkyboxUp
        sky.Parent = Lighting
    end
end

function Core.SetFullbright(enabled)
    if enabled then 
        Lighting.Brightness = 2 
        Lighting.ClockTime = 14 
        Lighting.FogEnd = 100000 
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else 
        Lighting.Brightness = Core.OriginalLighting.Brightness or 1
        Lighting.GlobalShadows = Core.OriginalLighting.GlobalShadows or true
        Lighting.Ambient = Core.OriginalLighting.Ambient or Color3.fromRGB(127,127,127)
        Lighting.OutdoorAmbient = Core.OriginalLighting.OutdoorAmbient or Color3.fromRGB(127,127,127)
    end
end

function Core.SetNoFog(enabled)
    Lighting.FogEnd = enabled and 100000 or (Core.OriginalLighting.FogEnd or 1000)
end

function Core.CBNoSpread(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoSpread = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    if enabled then
        for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
            local spread = weapon:FindFirstChild("Spread")
            if spread then
                for _, v in ipairs(spread:GetDescendants()) do
                    if v:IsA("NumberValue") then
                        if not Core.CBOriginalValues[v] then
                            Core.CBOriginalValues[v] = v.Value
                        end
                        v.Value = 0
                    end
                end
            end
        end
    else
        for v, originalValue in pairs(Core.CBOriginalValues) do
            if v and v.Parent and v:IsA("NumberValue") then
                v.Value = originalValue
            end
        end
    end
end

function Core.CBNoRecoil(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoRecoil = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    local recoilNames = {"Recoil", "CamRecoil", "KickBack", "RecoilUp", "RecoilSide"}
    
    if enabled then
        for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
            for _, name in ipairs(recoilNames) do
                local recoil = weapon:FindFirstChild(name)
                if recoil then
                    if recoil:IsA("NumberValue") then
                        if not Core.CBOriginalValues[recoil] then
                            Core.CBOriginalValues[recoil] = recoil.Value
                        end
                        recoil.Value = 0
                    elseif recoil:IsA("Folder") or recoil:IsA("Configuration") then
                        for _, v in ipairs(recoil:GetDescendants()) do
                            if v:IsA("NumberValue") then
                                if not Core.CBOriginalValues[v] then
                                    Core.CBOriginalValues[v] = v.Value
                                end
                                v.Value = 0
                            end
                        end
                    end
                end
            end
        end
    else
        for v, originalValue in pairs(Core.CBOriginalValues) do
            if v and v.Parent and v:IsA("NumberValue") then
                v.Value = originalValue
            end
        end
    end
end

function Core.CBRapidFire(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.RapidFire = enabled
    
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if not WeaponsFolder then return end
    
    if enabled then
        for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
            local fireRate = weapon:FindFirstChild("FireRate")
            if fireRate and fireRate:IsA("NumberValue") then
                if not Core.CBOriginalValues[fireRate] then
                    Core.CBOriginalValues[fireRate] = fireRate.Value
                end
                fireRate.Value = 0.01
            end
        end
    else
        for v, originalValue in pairs(Core.CBOriginalValues) do
            if v and v.Parent and v:IsA("NumberValue") then
                v.Value = originalValue
            end
        end
    end
end

function Core.CBInfAmmo(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.InfAmmo = enabled
    
    if enabled then
        if Core.CBLoops.InfAmmo then Core.CBLoops.InfAmmo:Disconnect() end
        Core.CBLoops.InfAmmo = RunService.RenderStepped:Connect(function()
            local gun = Core.GetCurrentGun()
            if gun then
                local ammo = gun:FindFirstChild("Ammo")
                local storedAmmo = gun:FindFirstChild("StoredAmmo")
                if ammo and ammo:IsA("NumberValue") then ammo.Value = 999 end
                if storedAmmo and storedAmmo:IsA("NumberValue") then storedAmmo.Value = 999 end
            end
        end)
    else
        if Core.CBLoops.InfAmmo then Core.CBLoops.InfAmmo:Disconnect() Core.CBLoops.InfAmmo = nil end
    end
end

function Core.CBKillAll(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.KillAll = enabled
    
    if enabled then
        if Core.CBLoops.KillAll then Core.CBLoops.KillAll:Disconnect() end
        Core.CBLoops.KillAll = RunService.RenderStepped:Connect(function()
            pcall(function()
                if not Core.IsAlive(LocalPlayer) then return end
                local gun = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if not gun then return end
                
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and Core.IsAlive(v) then
                        if Core.AimbotSettings.TeamCheck and v.Team == LocalPlayer.Team and v.Team ~= nil then continue end
                        
                        local head = v.Character:FindFirstChild("Head")
                        if head then
                            local args = {[1] = head, [2] = head.Position, [3] = "Banana", [4] = 100, [5] = gun, [8] = 100, [9] = false, [10] = false, [11] = Vector3.new(), [12] = 100, [13] = Vector3.new()}
                            local hitEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("HitPart")
                            if hitEvent then hitEvent:FireServer(unpack(args)) end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end)
    else
        if Core.CBLoops.KillAll then Core.CBLoops.KillAll:Disconnect() Core.CBLoops.KillAll = nil end
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
                if Core.CBLoops.InfCash then Core.CBLoops.InfCash:Disconnect() end
                Core.CBLoops.InfCash = cash:GetPropertyChangedSignal("Value"):Connect(function() cash.Value = 16000 end)
            end
        end)
    else
        if Core.CBLoops.InfCash then Core.CBLoops.InfCash:Disconnect() Core.CBLoops.InfCash = nil end
    end
end

function Core.CBBHop(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.BHop = enabled
    
    if enabled then
        if Core.CBLoops.BHop then Core.CBLoops.BHop:Disconnect() end
        Core.CBLoops.BHop = RunService.RenderStepped:Connect(function()
            if Core.IsAlive(LocalPlayer) then
                local hum = LocalPlayer.Character.Humanoid
                if hum.FloorMaterial ~= Enum.Material.Air then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if Core.CBLoops.BHop then Core.CBLoops.BHop:Disconnect() Core.CBLoops.BHop = nil end
    end
end

function Core.CBAntiAimbot(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.AntiAimbot = enabled
    
    if enabled then
        if Core.CBLoops.AntiAimbot then Core.CBLoops.AntiAimbot:Disconnect() end
        Core.CBLoops.AntiAimbot = RunService.RenderStepped:Connect(function()
            if not Core.IsAlive(LocalPlayer) then return end
            local char = LocalPlayer.Character
            local hum = char.Humanoid
            local hrp = char.HumanoidRootPart
            
            if Core.CBSettings.RemoveHeadHitbox then
                local headHB = char:FindFirstChild("HeadHB")
                if headHB then headHB:Destroy() end
                local fakeHead = char:FindFirstChild("FakeHead")
                if fakeHead then fakeHead:Destroy() end
            end
            
            local yaw = Core.CBSettings.AntiAimbotYaw
            if yaw ~= "Default" then
                hum.AutoRotate = false
                if yaw == "Backward" then hrp.CFrame = CFrame.new(hrp.Position, hrp.Position - Camera.CFrame.LookVector)
                elseif yaw == "Left" then hrp.CFrame = CFrame.new(hrp.Position, hrp.Position - Camera.CFrame.RightVector)
                elseif yaw == "Right" then hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.RightVector)
                elseif yaw == "Spin" then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Core.CBSettings.AntiAimbotSpeed), 0)
                elseif yaw == "Random" then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(-180, 180)), 0) end
            else
                hum.AutoRotate = true
            end
        end)
    else
        if Core.CBLoops.AntiAimbot then Core.CBLoops.AntiAimbot:Disconnect() Core.CBLoops.AntiAimbot = nil end
        if Core.IsAlive(LocalPlayer) then LocalPlayer.Character.Humanoid.AutoRotate = true end
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
            scope.Scope.Size = enabled and UDim2.new(2,0,2,0) or UDim2.new(1,0,1,0)
            scope.Scope.Position = enabled and UDim2.new(-0.5,0,-0.5,0) or UDim2.new(0,0,0,0)
        end
    end)
end

function Core.CBNoFlash(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoFlash = enabled
    pcall(function()
        local blnd = LocalPlayer.PlayerGui:FindFirstChild("Blnd")
        if blnd then blnd.Enabled = not enabled end
    end)
end

function Core.CBNoSmoke(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoSmoke = enabled
    if enabled then
        if Core.CBLoops.NoSmoke then Core.CBLoops.NoSmoke:Disconnect() end
        Core.CBLoops.NoSmoke = RunService.RenderStepped:Connect(function()
            pcall(function()
                local rayIgnore = Workspace:FindFirstChild("Ray_Ignore")
                if rayIgnore and rayIgnore:FindFirstChild("Smokes") then
                    for _, v in pairs(rayIgnore.Smokes:GetChildren()) do
                        if v.Name == "Smoke" then v:Destroy() end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.NoSmoke then Core.CBLoops.NoSmoke:Disconnect() Core.CBLoops.NoSmoke = nil end
    end
end

function Core.CBNoBulletHoles(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoBulletHoles = enabled
    if enabled then
        if Core.CBLoops.NoBulletHoles then Core.CBLoops.NoBulletHoles:Disconnect() end
        Core.CBLoops.NoBulletHoles = RunService.RenderStepped:Connect(function()
            pcall(function()
                local debris = Workspace:FindFirstChild("Debris")
                if debris then for _, v in pairs(debris:GetChildren()) do if v.Name == "Bullet" then v:Destroy() end end end
            end)
        end)
    else
        if Core.CBLoops.NoBulletHoles then Core.CBLoops.NoBulletHoles:Disconnect() Core.CBLoops.NoBulletHoles = nil end
    end
end

function Core.CBNoBlood(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoBlood = enabled
    if enabled then
        if Core.CBLoops.NoBlood then Core.CBLoops.NoBlood:Disconnect() end
        Core.CBLoops.NoBlood = RunService.RenderStepped:Connect(function()
            pcall(function()
                local debris = Workspace:FindFirstChild("Debris")
                if debris then for _, v in pairs(debris:GetChildren()) do if v:IsA("SurfaceGui") then v:Destroy() end end end
            end)
        end)
    else
        if Core.CBLoops.NoBlood then Core.CBLoops.NoBlood:Disconnect() Core.CBLoops.NoBlood = nil end
    end
end

function Core.ArsenalNoRecoil(enabled)
    if Core.GameName ~= "Arsenal" then return end
    Core.ArsenalSettings.NoRecoil = enabled
    if enabled then
        if Core.CBLoops.ArsenalRecoil then Core.CBLoops.ArsenalRecoil:Disconnect() end
        Core.CBLoops.ArsenalRecoil = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Core.GetCurrentGun()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v.Name:lower():find("recoil") and v:IsA("NumberValue") then v.Value = 0 end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.ArsenalRecoil then Core.CBLoops.ArsenalRecoil:Disconnect() Core.CBLoops.ArsenalRecoil = nil end
    end
end

function Core.ArsenalNoSpread(enabled)
    if Core.GameName ~= "Arsenal" then return end
    Core.ArsenalSettings.NoSpread = enabled
    if enabled then
        if Core.CBLoops.ArsenalSpread then Core.CBLoops.ArsenalSpread:Disconnect() end
        Core.CBLoops.ArsenalSpread = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Core.GetCurrentGun()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if v.Name:lower():find("spread") and v:IsA("NumberValue") then v.Value = 0 end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.ArsenalSpread then Core.CBLoops.ArsenalSpread:Disconnect() Core.CBLoops.ArsenalSpread = nil end
    end
end

function Core.ArsenalRapidFire(enabled)
    if Core.GameName ~= "Arsenal" then return end
    Core.ArsenalSettings.RapidFire = enabled
    if enabled then
        if Core.CBLoops.ArsenalRapid then Core.CBLoops.ArsenalRapid:Disconnect() end
        Core.CBLoops.ArsenalRapid = RunService.RenderStepped:Connect(function()
            pcall(function()
                local gun = Core.GetCurrentGun()
                if gun then
                    for _, v in pairs(gun:GetDescendants()) do
                        if (v.Name:lower():find("firerate") or v.Name:lower():find("fire_rate") or v.Name:lower():find("cooldown")) and v:IsA("NumberValue") then
                            v.Value = 0.01
                        end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.ArsenalRapid then Core.CBLoops.ArsenalRapid:Disconnect() Core.CBLoops.ArsenalRapid = nil end
    end
end

function Core.PFNoRecoil(enabled)
    if Core.GameName ~= "Phantom Forces" then return end
    Core.PFSettings.NoRecoil = enabled
    if enabled then
        if Core.CBLoops.PFRecoil then Core.CBLoops.PFRecoil:Disconnect() end
        Core.CBLoops.PFRecoil = RunService.RenderStepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local gun = char:FindFirstChildOfClass("Tool")
                    if gun then
                        for _, v in pairs(gun:GetDescendants()) do
                            if v:IsA("NumberValue") and (v.Name:find("Recoil") or v.Name:find("Kick") or v.Name:find("Sway")) then
                                v.Value = 0
                            end
                        end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.PFRecoil then Core.CBLoops.PFRecoil:Disconnect() Core.CBLoops.PFRecoil = nil end
    end
end

function Core.PFNoSpread(enabled)
    if Core.GameName ~= "Phantom Forces" then return end
    Core.PFSettings.NoSpread = enabled
    if enabled then
        if Core.CBLoops.PFSpread then Core.CBLoops.PFSpread:Disconnect() end
        Core.CBLoops.PFSpread = RunService.RenderStepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local gun = char:FindFirstChildOfClass("Tool")
                    if gun then
                        for _, v in pairs(gun:GetDescendants()) do
                            if v:IsA("NumberValue") and v.Name:find("Spread") then
                                v.Value = 0
                            end
                        end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.PFSpread then Core.CBLoops.PFSpread:Disconnect() Core.CBLoops.PFSpread = nil end
    end
end

function Core.RivalsNoRecoil(enabled)
    if Core.GameName ~= "Rivals" then return end
    Core.RivalsSettings.NoRecoil = enabled
    if enabled then
        if Core.CBLoops.RivalsRecoil then Core.CBLoops.RivalsRecoil:Disconnect() end
        Core.CBLoops.RivalsRecoil = RunService.RenderStepped:Connect(function()
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, v in pairs(playerGui:GetDescendants()) do
                        if v:IsA("NumberValue") and v.Name:lower():find("recoil") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.RivalsRecoil then Core.CBLoops.RivalsRecoil:Disconnect() Core.CBLoops.RivalsRecoil = nil end
    end
end

function Core.RivalsNoSpread(enabled)
    if Core.GameName ~= "Rivals" then return end
    Core.RivalsSettings.NoSpread = enabled
    if enabled then
        if Core.CBLoops.RivalsSpread then Core.CBLoops.RivalsSpread:Disconnect() end
        Core.CBLoops.RivalsSpread = RunService.RenderStepped:Connect(function()
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, v in pairs(playerGui:GetDescendants()) do
                        if v:IsA("NumberValue") and v.Name:lower():find("spread") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.RivalsSpread then Core.CBLoops.RivalsSpread:Disconnect() Core.CBLoops.RivalsSpread = nil end
    end
end

function Core.FlickAutoClick(enabled)
    if Core.GameName ~= "Flick" then return end
    Core.FlickSettings.AutoClick = enabled
    if enabled then
        if Core.CBLoops.FlickClick then Core.CBLoops.FlickClick:Disconnect() end
        Core.CBLoops.FlickClick = RunService.RenderStepped:Connect(function()
            if mouse1click then mouse1click() end
            task.wait(Core.FlickSettings.ClickDelay / 1000)
        end)
    else
        if Core.CBLoops.FlickClick then Core.CBLoops.FlickClick:Disconnect() Core.CBLoops.FlickClick = nil end
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
        if root then targetPos = targetPos + (root.AssemblyLinearVelocity * (Core.SilentAimSettings.Prediction / 10)) end
    end
    return targetPos
end

function Core.Rejoin()
    TeleportService:TeleportToPlaceInstance(Core.PlaceId, game.JobId, LocalPlayer)
end

function Core.ServerHop()
    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. Core.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and servers.data then
        for _, v in pairs(servers.data) do
            if v.id ~= game.JobId and v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(Core.PlaceId, v.id, LocalPlayer)
                break
            end
        end
    end
end

function Core.GetJoinScript()
    return 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. Core.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)'
end

function Core.LoadInfYield()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end

function Core.LoadNamelessAdmin()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
end

function Core.LoadDex()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end

function Core.LoadRemoteSpy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
end

function Core.LoadCmd()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CommandDev/Toh-Admin/main/Source.lua"))()
end

function Core.LoadDarkDex()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/FullDarkDex.lua"))()
end

function Core.LoadServerSide()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynworken/Vynwhirl-VynAdmin/refs/heads/main/VynAdmin.lua"))()
end

function Core.LoadOhio()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/ohio/main/NewOhio"))()
end

function Core.SetupSilentAim()
    if not getrawmetatable then return false end
    local mouse = LocalPlayer:GetMouse()
    local mt = getrawmetatable(mouse)
    if not mt then return false end
    local oldIndex = mt.__index
    if setreadonly then setreadonly(mt, false) end
    local newIndex = function(self, key)
        if Core.SilentAimSettings.Enabled then
            local targetPos = Core.GetSilentAimPosition()
            if targetPos then
                if key == "Hit" then return CFrame.new(targetPos)
                elseif key == "Target" then if Core.SilentAimTarget and Core.SilentAimTarget.Part then return Core.SilentAimTarget.Part end
                elseif key == "X" then return Camera:WorldToViewportPoint(targetPos).X
                elseif key == "Y" then return Camera:WorldToViewportPoint(targetPos).Y
                elseif key == "UnitRay" then return Ray.new(Camera.CFrame.Position, (targetPos - Camera.CFrame.Position).Unit) end
            end
        end
        return oldIndex(self, key)
    end
    if newcclosure then mt.__index = newcclosure(newIndex) else mt.__index = newIndex end
    if setreadonly then setreadonly(mt, true) end
    return true
end

function Core.Init()
    Core.SaveLighting()
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then Core.CreateESP(plr) end
    end
    
    Players.PlayerAdded:Connect(function(plr) Core.CreateESP(plr) end)
    Players.PlayerRemoving:Connect(function(plr) Core.RemoveESP(plr) end)
    
    if Core.GameName == "Murder Mystery 2" then
        task.spawn(function() while task.wait(2) do Core.MM2Roles = {} end end)
    end
    
    if getrawmetatable then Core.SetupSilentAim() end
    
    RunService.RenderStepped:Connect(function() Core.SilentAimCameraMethod() end)
end

return Core
