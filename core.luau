-- v3

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
local VirtualInputManager = game:GetService("VirtualInputManager")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

Core.SupportedGames = {
    [301549746] = "Counter Blox",
    [292439477] = "Phantom Forces",
    [17625359962] = "Rivals",
    [286090429] = "Arsenal",
    [142823291] = "Murder Mystery 2",
    [3837841034] = "Bad Business"
}

Core.PlaceId = game.PlaceId
Core.GameName = Core.SupportedGames[Core.PlaceId] or "Universal"

Core.ESPSettings = {
    Enabled = false,
    Box = {On = false, Color = Color3.new(1,1,1)},
    Name = {On = false, Color = Color3.new(1,1,1)},
    Health = {On = false},
    Distance = {On = false, Color = Color3.new(1,1,1)},
    Skeleton = {On = false, Color = Color3.new(1,1,1)},
    Chams = {On = false, Color = Color3.fromRGB(212,133,240), Transparency = 0.5},
    Tracers = {On = false, Origin = "Bottom", Color = Color3.new(1,1,1)},
    HeadDot = {On = false, Color = Color3.new(1,0,0)},
    MaxDist = 2000,
    TeamCheck = false,
    ShowRole = true,
    Rainbow = {On = false, Speed = 1},
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

Core.CBSettings = {
    NoSpread = false,
    NoRecoil = false,
    InfAmmo = false,
    RapidFire = false,
    Wallbang = false,
    KillAll = false,
    InfCash = false,
    InfHP = false,
    BHop = false,
    AntiAimbot = false,
    AntiAimbotYaw = "Default",
    AntiAimbotPitch = "Default",
    AntiAimbotSpeed = 50,
    RemoveHeadHitbox = false,
    NoScope = false,
    NoFlash = false,
    NoSmoke = false,
    NoBulletHoles = false,
    NoBlood = false
}

Core.CBLoops = {}
Core.ESPObjects = {}
Core.ChamsObjects = {}
Core.Connections = {}
Core.MM2Roles = {}
Core.LockedTarget = nil
Core.RainbowHue = 0
Core.SilentAimTarget = nil

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
        Name = Core.CreateDrawing("Text", {Size = 13, Center = true, Outline = true, Font = 2, ZIndex = 3}),
        Health = Core.CreateDrawing("Square", {Filled = true, ZIndex = 2}),
        HealthOutline = Core.CreateDrawing("Square", {Filled = true, Color = Color3.new(0,0,0), ZIndex = 1}),
        Distance = Core.CreateDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2, ZIndex = 3}),
        HeadDot = Core.CreateDrawing("Circle", {Filled = true, Radius = 3, ZIndex = 3}),
        Tracer = Core.CreateDrawing("Line", {Thickness = 1, ZIndex = 1}),
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
    esp.Name.Visible = false
    esp.Health.Visible = false
    esp.HealthOutline.Visible = false
    esp.Distance.Visible = false
    esp.HeadDot.Visible = false
    esp.Tracer.Visible = false
    for _, line in pairs(esp.Skeleton) do line.Visible = false end
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
        
        if not onScreen or dist > Core.ESPSettings.MaxDist then
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
            esp.BoxOutline.Size = Vector2.new(width, height)
            esp.BoxOutline.Position = Vector2.new(x, y)
            esp.BoxOutline.Visible = true
            esp.Box.Size = Vector2.new(width, height)
            esp.Box.Position = Vector2.new(x, y)
            esp.Box.Color = color
            esp.Box.Visible = true
        else
            esp.Box.Visible = false
            esp.BoxOutline.Visible = false
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
            esp.HealthOutline.Size = Vector2.new(4, height)
            esp.HealthOutline.Position = Vector2.new(x - 6, y)
            esp.HealthOutline.Visible = true
            esp.Health.Size = Vector2.new(2, barH)
            esp.Health.Position = Vector2.new(x - 5, y + height - barH)
            esp.Health.Color = Color3.fromRGB(255 - 255 * hp, 255 * hp, 0)
            esp.Health.Visible = true
        else
            esp.Health.Visible = false
            esp.HealthOutline.Visible = false
        end
        
        if Core.ESPSettings.Distance.On then
            esp.Distance.Text = math.floor(dist) .. "m"
            esp.Distance.Position = Vector2.new(x + width / 2, y + height + 2)
            esp.Distance.Color = Core.ESPSettings.Distance.Color
            esp.Distance.Visible = true
        else
            esp.Distance.Visible = false
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
        if v:IsA("Tool") and v:FindFirstChild("Ammo") then
            return v
        end
    end
    return nil
end

function Core.ModifyWeaponValues(weapon, modifications)
    if not weapon then return end
    for valueName, newValue in pairs(modifications) do
        local value = weapon:FindFirstChild(valueName)
        if value and value:IsA("NumberValue") then
            if not value:GetAttribute("Original_" .. valueName) then
                value:SetAttribute("Original_" .. valueName, value.Value)
            end
            value.Value = newValue
        end
    end
end

function Core.RestoreWeaponValues(weapon, valueNames)
    if not weapon then return end
    for _, valueName in ipairs(valueNames) do
        local value = weapon:FindFirstChild(valueName)
        if value and value:IsA("NumberValue") then
            local orig = value:GetAttribute("Original_" .. valueName)
            if orig then value.Value = orig end
        end
    end
end

function Core.ApplyToAllWeapons(modifications, restore)
    local WeaponsFolder = ReplicatedStorage:FindFirstChild("Weapons")
    if WeaponsFolder then
        for _, weapon in ipairs(WeaponsFolder:GetChildren()) do
            if restore then
                Core.RestoreWeaponValues(weapon, modifications)
            else
                Core.ModifyWeaponValues(weapon, modifications)
            end
        end
    end
    
    local currentGun = Core.GetCurrentGun()
    if currentGun then
        if restore then
            Core.RestoreWeaponValues(currentGun, modifications)
        else
            Core.ModifyWeaponValues(currentGun, modifications)
        end
    end
end

function Core.CBNoSpread(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoSpread = enabled
    
    if enabled then
        Core.ApplyToAllWeapons({
            Spread = 0,
            SpreadReduc = 0,
            MinSpread = 0,
            MaxSpread = 0
        }, false)
    else
        Core.ApplyToAllWeapons({"Spread", "SpreadReduc", "MinSpread", "MaxSpread"}, true)
    end
end

function Core.CBNoRecoil(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoRecoil = enabled
    
    if enabled then
        Core.ApplyToAllWeapons({
            Recoil = 0,
            RecoilReduc = 0,
            MinRecoil = 0,
            MaxRecoil = 0,
            CamRecoil = 0,
            KickBack = 0
        }, false)
    else
        Core.ApplyToAllWeapons({"Recoil", "RecoilReduc", "MinRecoil", "MaxRecoil", "CamRecoil", "KickBack"}, true)
    end
end

function Core.CBRapidFire(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.RapidFire = enabled
    
    if enabled then
        Core.ApplyToAllWeapons({FireRate = 0.01}, false)
    else
        Core.ApplyToAllWeapons({"FireRate"}, true)
    end
end

function Core.CBInfAmmo(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.InfAmmo = enabled
    
    if enabled then
        Core.ApplyToAllWeapons({
            Ammo = 999,
            StoredAmmo = 999,
            MaxAmmo = 999
        }, false)
        
        if Core.CBLoops.InfAmmo then Core.CBLoops.InfAmmo:Disconnect() end
        Core.CBLoops.InfAmmo = RunService.RenderStepped:Connect(function()
            local gun = Core.GetCurrentGun()
            if gun then
                local ammo = gun:FindFirstChild("Ammo")
                if ammo and ammo.Value < 999 then
                    ammo.Value = 999
                end
            end
        end)
    else
        if Core.CBLoops.InfAmmo then
            Core.CBLoops.InfAmmo:Disconnect()
            Core.CBLoops.InfAmmo = nil
        end
        Core.ApplyToAllWeapons({"Ammo", "StoredAmmo", "MaxAmmo"}, true)
    end
end

function Core.CBWallbang(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.Wallbang = enabled
    
    if enabled then
        Core.ApplyToAllWeapons({
            Penetration = 999,
            Range = 9999
        }, false)
    else
        Core.ApplyToAllWeapons({"Penetration", "Range"}, true)
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
                local gun = LocalPlayer.Character:FindFirstChild("Gun")
                
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and Core.IsAlive(v) then
                        if Core.AimbotSettings.TeamCheck and v.Team == LocalPlayer.Team and v.Team ~= nil then continue end
                        
                        local args = {
                            [1] = v.Character.Head,
                            [2] = v.Character.Head.Position,
                            [3] = "Banana",
                            [4] = 100,
                            [5] = gun,
                            [8] = 100,
                            [9] = false,
                            [10] = false,
                            [11] = Vector3.new(),
                            [12] = 100,
                            [13] = Vector3.new()
                        }
                        
                        local hitPartEvent = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("HitPart")
                        if hitPartEvent then
                            hitPartEvent:FireServer(unpack(args))
                        end
                    end
                end
            end)
            task.wait(0.1)
        end)
    else
        if Core.CBLoops.KillAll then
            Core.CBLoops.KillAll:Disconnect()
            Core.CBLoops.KillAll = nil
        end
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
                Core.CBLoops.InfCash = cash:GetPropertyChangedSignal("Value"):Connect(function()
                    cash.Value = 16000
                end)
            end
        end)
    else
        if Core.CBLoops.InfCash then
            Core.CBLoops.InfCash:Disconnect()
            Core.CBLoops.InfCash = nil
        end
    end
end

function Core.CBInfHP(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.InfHP = enabled
    
    if enabled then
        pcall(function()
            local fallDamage = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("FallDamage")
            if fallDamage then
                fallDamage:FireServer(0/0)
            end
            
            if Core.IsAlive(LocalPlayer) then
                if Core.CBLoops.InfHP then Core.CBLoops.InfHP:Disconnect() end
                Core.CBLoops.InfHP = LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    LocalPlayer.Character.Humanoid.Health = 100
                end)
            end
        end)
    else
        if Core.CBLoops.InfHP then
            Core.CBLoops.InfHP:Disconnect()
            Core.CBLoops.InfHP = nil
        end
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
        if Core.CBLoops.BHop then
            Core.CBLoops.BHop:Disconnect()
            Core.CBLoops.BHop = nil
        end
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
                local head = char:FindFirstChild("Head")
                if head and head.Transparency ~= 0 then
                    head.Transparency = 0
                end
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
                end
            else
                hum.AutoRotate = true
            end
        end)
    else
        if Core.CBLoops.AntiAimbot then
            Core.CBLoops.AntiAimbot:Disconnect()
            Core.CBLoops.AntiAimbot = nil
        end
        if Core.IsAlive(LocalPlayer) then
            LocalPlayer.Character.Humanoid.AutoRotate = true
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
        
        if enabled then
            scope.ImageTransparency = 1
            if scope:FindFirstChild("Scope") then
                scope.Scope.ImageTransparency = 1
                scope.Scope.Size = UDim2.new(2,0,2,0)
                scope.Scope.Position = UDim2.new(-0.5,0,-0.5,0)
                if scope.Scope:FindFirstChild("Blur") then
                    scope.Scope.Blur.ImageTransparency = 1
                    if scope.Scope.Blur:FindFirstChild("Blur") then
                        scope.Scope.Blur.Blur.ImageTransparency = 1
                    end
                end
            end
            for i = 1, 4 do
                local frame = crosshairs:FindFirstChild("Frame" .. i)
                if frame then frame.Transparency = 1 end
            end
        else
            scope.ImageTransparency = 0
            if scope:FindFirstChild("Scope") then
                scope.Scope.ImageTransparency = 0
                scope.Scope.Size = UDim2.new(1,0,1,0)
                scope.Scope.Position = UDim2.new(0,0,0,0)
                if scope.Scope:FindFirstChild("Blur") then
                    scope.Scope.Blur.ImageTransparency = 0
                    if scope.Scope.Blur:FindFirstChild("Blur") then
                        scope.Scope.Blur.Blur.ImageTransparency = 0
                    end
                end
            end
            for i = 1, 4 do
                local frame = crosshairs:FindFirstChild("Frame" .. i)
                if frame then frame.Transparency = 0 end
            end
        end
    end)
end

function Core.CBNoFlash(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoFlash = enabled
    
    pcall(function()
        local blnd = LocalPlayer.PlayerGui:FindFirstChild("Blnd")
        if blnd then
            blnd.Enabled = not enabled
        end
    end)
end

function Core.CBNoSmoke(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.NoSmoke = enabled
    
    if enabled then
        if Core.CBLoops.NoSmoke then Core.CBLoops.NoSmoke:Disconnect() end
        Core.CBLoops.NoSmoke = RunService.RenderStepped:Connect(function()
            pcall(function()
                local smokes = Workspace:FindFirstChild("Ray_Ignore") and Workspace.Ray_Ignore:FindFirstChild("Smokes")
                if smokes then
                    for _, v in pairs(smokes:GetChildren()) do
                        if v.Name == "Smoke" then
                            v:Destroy()
                        end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.NoSmoke then
            Core.CBLoops.NoSmoke:Disconnect()
            Core.CBLoops.NoSmoke = nil
        end
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
                if debris then
                    for _, v in pairs(debris:GetChildren()) do
                        if v.Name == "Bullet" then
                            v:Destroy()
                        end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.NoBulletHoles then
            Core.CBLoops.NoBulletHoles:Disconnect()
            Core.CBLoops.NoBulletHoles = nil
        end
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
                if debris then
                    for _, v in pairs(debris:GetChildren()) do
                        if v.Name == "SurfaceGui" or v:IsA("SurfaceGui") then
                            v:Destroy()
                        end
                    end
                end
            end)
        end)
    else
        if Core.CBLoops.NoBlood then
            Core.CBLoops.NoBlood:Disconnect()
            Core.CBLoops.NoBlood = nil
        end
    end
end

function Core.SilentAimCameraMethod()
    if not Core.SilentAimSettings.Enabled then return end
    Core.SilentAimTarget = Core.GetSilentAimTarget()
end

function Core.GetSilentAimPosition()
    if not Core.SilentAimSettings.Enabled or not Core.SilentAimTarget then
        return nil
    end
    
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

function Core.SetFullbright(enabled)
    if enabled then 
        Lighting.Brightness = 2 
        Lighting.ClockTime = 14 
        Lighting.FogEnd = 100000 
        Lighting.GlobalShadows = false
    else 
        Lighting.Brightness = 1 
        Lighting.GlobalShadows = true 
    end
end

function Core.SetNoFog(enabled)
    Lighting.FogEnd = enabled and 100000 or 1000
end

function Core.LoadInfYield()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end

function Core.LoadNamelessAdmin()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
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
                if key == "Hit" then
                    return CFrame.new(targetPos)
                elseif key == "Target" then
                    if Core.SilentAimTarget and Core.SilentAimTarget.Part then
                        return Core.SilentAimTarget.Part
                    end
                elseif key == "X" then
                    return Camera:WorldToViewportPoint(targetPos).X
                elseif key == "Y" then
                    return Camera:WorldToViewportPoint(targetPos).Y
                elseif key == "UnitRay" then
                    local origin = Camera.CFrame.Position
                    return Ray.new(origin, (targetPos - origin).Unit)
                end
            end
        end
        return oldIndex(self, key)
    end
    
    if newcclosure then
        mt.__index = newcclosure(newIndex)
    else
        mt.__index = newIndex
    end
    
    if setreadonly then setreadonly(mt, true) end
    
    return true
end

function Core.Init()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then Core.CreateESP(plr) end
    end
    
    Players.PlayerAdded:Connect(function(plr) Core.CreateESP(plr) end)
    Players.PlayerRemoving:Connect(function(plr) Core.RemoveESP(plr) end)
    
    if Core.GameName == "Murder Mystery 2" then
        task.spawn(function()
            while task.wait(2) do
                Core.MM2Roles = {}
            end
        end)
    end
    
    if getrawmetatable then
        Core.SetupSilentAim()
    end
    
    RunService.RenderStepped:Connect(function()
        Core.SilentAimCameraMethod()
        
        if Core.GameName == "Counter Blox" then
            if Core.CBSettings.NoSpread or Core.CBSettings.NoRecoil or Core.CBSettings.RapidFire then
                local gun = Core.GetCurrentGun()
                if gun then
                    if Core.CBSettings.NoSpread then
                        Core.ModifyWeaponValues(gun, {Spread = 0, SpreadReduc = 0, MinSpread = 0, MaxSpread = 0})
                    end
                    if Core.CBSettings.NoRecoil then
                        Core.ModifyWeaponValues(gun, {Recoil = 0, RecoilReduc = 0, MinRecoil = 0, MaxRecoil = 0, CamRecoil = 0, KickBack = 0})
                    end
                    if Core.CBSettings.RapidFire then
                        Core.ModifyWeaponValues(gun, {FireRate = 0.01})
                    end
                end
            end
        end
    end)
end

return Core
