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
    [4924922222] = "Brookhaven",
    [142823291] = "Murder Mystery 2"
}

Core.PlaceId = game.PlaceId
Core.GameName = Core.SupportedGames[Core.PlaceId] or "Universal"

Core.ESPSettings = {
    Enabled = false,
    Box = {On = false, Color = Color3.new(1,1,1), Outline = true},
    CornerBox = {On = false, Color = Color3.new(1,1,1)},
    Name = {On = false, Color = Color3.new(1,1,1), DisplayName = false},
    Health = {On = false, Position = "Left"},
    Weapon = {On = false, Color = Color3.new(1,1,1)},
    Distance = {On = false, Color = Color3.new(1,1,1)},
    Skeleton = {On = false, Color = Color3.new(1,1,1)},
    Chams = {On = false, Color = Color3.fromRGB(212,133,240), Transparency = 0.5, OutlineColor = Color3.new(1,1,1)},
    Tracers = {On = false, Origin = "Bottom", Color = Color3.new(1,1,1)},
    HeadDot = {On = false, Color = Color3.new(1,0,0), Filled = true},
    OffScreenArrows = {On = false, Color = Color3.new(1,0,0), Size = 15, Radius = 150},
    MaxDist = 2000,
    TeamCheck = false,
    VisibleCheck = false,
    VisibleColor = Color3.new(0,1,0),
    ShowRole = true,
    Rainbow = {On = false, Speed = 1},
    MurdererColor = Color3.fromRGB(255,0,0),
    SheriffColor = Color3.fromRGB(0,100,255),
    InnocentColor = Color3.fromRGB(0,255,0),
    FontSize = 13
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
    Time = 12,
    Brightness = 1,
    Ambient = Color3.fromRGB(127,127,127),
    Skybox = "Default",
    NoFog = false,
    Fullbright = false
}

Core.Skyboxes = {
    Default = {},
    Night = {SkyboxBk = "rbxassetid://1001657105", SkyboxDn = "rbxassetid://1001657105", SkyboxFt = "rbxassetid://1001657105", SkyboxLf = "rbxassetid://1001657105", SkyboxRt = "rbxassetid://1001657105", SkyboxUp = "rbxassetid://1001657105"},
    Galaxy = {SkyboxBk = "rbxassetid://159454299", SkyboxDn = "rbxassetid://159454299", SkyboxFt = "rbxassetid://159454299", SkyboxLf = "rbxassetid://159454299", SkyboxRt = "rbxassetid://159454299", SkyboxUp = "rbxassetid://159454299"},
    Pink = {SkyboxBk = "rbxassetid://2542891783", SkyboxDn = "rbxassetid://2542891783", SkyboxFt = "rbxassetid://2542891783", SkyboxLf = "rbxassetid://2542891783", SkyboxRt = "rbxassetid://2542891783", SkyboxUp = "rbxassetid://2542891783"},
    Vaporwave = {SkyboxBk = "rbxassetid://1417494030", SkyboxDn = "rbxassetid://1417494030", SkyboxFt = "rbxassetid://1417494030", SkyboxLf = "rbxassetid://1417494030", SkyboxRt = "rbxassetid://1417494030", SkyboxUp = "rbxassetid://1417494030"}
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
    NoSmoke = false
}

Core.MM2Settings = {
    ShowRole = true
}

Core.BrookhavenSettings = {
    SpamChat = false,
    SpamMessage = "killfeed.cc on top",
    SpamDelay = 1,
    SoundSpam = false,
    SoundID = 142376088,
    Fling = false,
    SpamEmotes = false,
    SpamTools = false,
    KickAll = false,
    TPAll = false,
    ExplodeAll = false,
    FreezePlayers = false,
    RemoveHouses = false,
    SpamVehicles = false,
    FloodServer = false
}

Core.Loops = {}
Core.OriginalValues = {}
Core.ESPObjects = {}
Core.ChamsObjects = {}
Core.MM2Roles = {}
Core.LockedTarget = nil
Core.RainbowHue = 0
Core.SilentAimTarget = nil
Core.OriginalSky = nil

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
    local success, d = pcall(function() return Drawing.new(t) end)
    if not success or not d or type(d) == "number" then
        return {Visible = false, Color = Color3.new(1,1,1), Thickness = 1, Filled = false, Transparency = 1, Size = Vector2.new(0,0), Position = Vector2.new(0,0), From = Vector2.new(0,0), To = Vector2.new(0,0), Center = true, Outline = true, Text = "", Radius = 5, PointA = Vector2.new(0,0), PointB = Vector2.new(0,0), PointC = Vector2.new(0,0), Font = 2, Remove = function() end}
    end
    for k, v in pairs(props or {}) do pcall(function() d[k] = v end) end
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
    local direction = (part.Position - origin).Unit * (part.Position - origin).Magnitude
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(origin, direction, params)
    if result then return result.Instance:IsDescendantOf(part.Parent) end
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
    if checkForWeapon(char, "knife") or checkForWeapon(backpack, "knife") then Core.MM2Roles[player] = "Murderer"
    elseif checkForWeapon(char, "gun") or checkForWeapon(backpack, "gun") then Core.MM2Roles[player] = "Sheriff"
    else Core.MM2Roles[player] = "Innocent" end
    return Core.MM2Roles[player]
end

function Core.GetESPColor(player)
    if Core.ESPSettings.Rainbow.On then return Core.GetRainbowColor() end
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

function Core.GetClosestPlayer()
    local closest, shortestDist = nil, Core.AimbotSettings.FOV
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or not Core.IsAlive(player) then continue end
        if Core.AimbotSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then continue end
        local char = player.Character if not char then continue end
        local aimPart = char:FindFirstChild(Core.AimbotSettings.AimPart) or char:FindFirstChild("Head")
        if not aimPart then continue end
        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
        if not onScreen then continue end
        if Core.AimbotSettings.VisibleCheck and not Core.IsVisible(aimPart) then continue end
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if dist < shortestDist then shortestDist = dist closest = player end
    end
    return closest
end

function Core.GetSilentAimTarget()
    local closest, shortestDist = nil, Core.SilentAimSettings.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or not Core.IsAlive(player) then continue end
        if Core.SilentAimSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then continue end
        local char = player.Character if not char then continue end
        local aimPart = char:FindFirstChild(Core.SilentAimSettings.AimPart) or char:FindFirstChild("Head")
        if not aimPart then continue end
        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
        if not onScreen then continue end
        if Core.SilentAimSettings.VisibleCheck and not Core.IsVisible(aimPart) then continue end
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if dist < shortestDist then shortestDist = dist closest = {Player = player, Part = aimPart} end
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
        if not player then player = Players:GetPlayerFromCharacter(result.Instance.Parent.Parent) end
        if player and player ~= LocalPlayer and Core.IsAlive(player) then
            if Core.TriggerSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then return nil end
            return player
        end
    end
    return nil
end

function Core.AimAt(player, TargetCircle)
    if not player or not Core.IsAlive(player) then Core.LockedTarget = nil return end
    local char = player.Character if not char then return end
    local aimPart = char:FindFirstChild(Core.AimbotSettings.AimPart) or char:FindFirstChild("Head")
    if not aimPart then return end
    local targetPos = aimPart.Position
    if Core.AimbotSettings.Prediction > 0 then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then targetPos = targetPos + (root.AssemblyLinearVelocity * (Core.AimbotSettings.Prediction / 10)) end
    end
    local screenPos = Camera:WorldToViewportPoint(targetPos)
    local mousePos = UserInputService:GetMouseLocation()
    local delta = (Vector2.new(screenPos.X, screenPos.Y) - mousePos) / math.max(Core.AimbotSettings.Smoothness, 1)
    if mousemoverel then mousemoverel(delta.X, delta.Y) end
    if TargetCircle then pcall(function() TargetCircle.Position = Vector2.new(screenPos.X, screenPos.Y) TargetCircle.Visible = true end) end
end

function Core.CreateESP(plr)
    if Core.ESPObjects[plr] then return end
    Core.ESPObjects[plr] = {
        Box = Core.CreateDrawing("Square", {Thickness = 1, Filled = false}),
        BoxOutline = Core.CreateDrawing("Square", {Thickness = 3, Filled = false, Color = Color3.new(0,0,0)}),
        Name = Core.CreateDrawing("Text", {Size = 13, Center = true, Outline = true, Font = 2}),
        Health = Core.CreateDrawing("Square", {Filled = true}),
        HealthOutline = Core.CreateDrawing("Square", {Filled = true, Color = Color3.new(0,0,0)}),
        Distance = Core.CreateDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2}),
        Skeleton = {}
    }
    for i = 1, 14 do Core.ESPObjects[plr].Skeleton[i] = Core.CreateDrawing("Line", {Thickness = 1}) end
end

function Core.RemoveESP(plr)
    local esp = Core.ESPObjects[plr]
    if esp then
        for _, v in pairs(esp) do
            if type(v) == "table" then for _, line in pairs(v) do pcall(function() if line.Remove then line:Remove() end end) end end
        end
        Core.ESPObjects[plr] = nil
    end
    if Core.ChamsObjects[plr] then pcall(function() Core.ChamsObjects[plr]:Destroy() end) Core.ChamsObjects[plr] = nil end
    Core.MM2Roles[plr] = nil
end

function Core.HideESP(esp)
    if not esp then return end
    pcall(function() esp.Box.Visible = false esp.BoxOutline.Visible = false esp.Name.Visible = false esp.Health.Visible = false esp.HealthOutline.Visible = false esp.Distance.Visible = false end)
    if esp.Skeleton then for _, line in pairs(esp.Skeleton) do pcall(function() line.Visible = false end) end end
end

function Core.UpdateESP()
    Camera = Workspace.CurrentCamera
    for plr, esp in pairs(Core.ESPObjects) do
        if not esp or not Core.ESPSettings.Enabled or not Core.IsAlive(plr) or plr == LocalPlayer then Core.HideESP(esp) if Core.ChamsObjects[plr] then pcall(function() Core.ChamsObjects[plr].Enabled = false end) end continue end
        if Core.ESPSettings.TeamCheck and plr.Team == LocalPlayer.Team and plr.Team ~= nil then Core.HideESP(esp) if Core.ChamsObjects[plr] then pcall(function() Core.ChamsObjects[plr].Enabled = false end) end continue end
        local char = plr.Character if not char then Core.HideESP(esp) continue end
        local root = char:FindFirstChild("HumanoidRootPart") local head = char:FindFirstChild("Head")
        if not root or not head then Core.HideESP(esp) continue end
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        if not onScreen or dist > Core.ESPSettings.MaxDist then Core.HideESP(esp) if Core.ChamsObjects[plr] then pcall(function() Core.ChamsObjects[plr].Enabled = false end) end continue end
        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        local height = math.abs(legPos.Y - headPos.Y) local width = height * 0.6 local x, y = pos.X - width / 2, headPos.Y
        local color = Core.GetESPColor(plr)
        if Core.ESPSettings.Box.On then pcall(function() esp.Box.Size = Vector2.new(width, height) esp.Box.Position = Vector2.new(x, y) esp.Box.Color = color esp.Box.Visible = true esp.BoxOutline.Size = Vector2.new(width, height) esp.BoxOutline.Position = Vector2.new(x, y) esp.BoxOutline.Visible = true end) else pcall(function() esp.Box.Visible = false esp.BoxOutline.Visible = false end) end
        if Core.ESPSettings.Name.On then pcall(function() local txt = plr.Name if Core.GameName == "Murder Mystery 2" and Core.MM2Settings.ShowRole then txt = txt .. " [" .. Core.GetMM2Role(plr) .. "]" end esp.Name.Text = txt esp.Name.Position = Vector2.new(x + width / 2, y - 16) esp.Name.Color = color esp.Name.Visible = true end) else pcall(function() esp.Name.Visible = false end) end
        if Core.ESPSettings.Skeleton.On then pcall(function() local parts = char:FindFirstChild("UpperTorso") and Core.SkeletonParts or Core.SkeletonPartsR6 for i, conn in ipairs(parts) do local p1, p2 = char:FindFirstChild(conn[1]), char:FindFirstChild(conn[2]) local line = esp.Skeleton[i] if p1 and p2 and line then local v1, os1 = Camera:WorldToViewportPoint(p1.Position) local v2, os2 = Camera:WorldToViewportPoint(p2.Position) if os1 and os2 then line.From = Vector2.new(v1.X, v1.Y) line.To = Vector2.new(v2.X, v2.Y) line.Color = Core.ESPSettings.Skeleton.Color line.Visible = true else line.Visible = false end elseif line then line.Visible = false end end end) else if esp.Skeleton then for _, line in pairs(esp.Skeleton) do pcall(function() line.Visible = false end) end end end
        if Core.ESPSettings.Chams.On then pcall(function() if not Core.ChamsObjects[plr] then local hl = Instance.new("Highlight") hl.Adornee = char hl.Parent = CoreGui hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop Core.ChamsObjects[plr] = hl end Core.ChamsObjects[plr].FillColor = color Core.ChamsObjects[plr].OutlineColor = Core.ESPSettings.Chams.OutlineColor Core.ChamsObjects[plr].FillTransparency = Core.ESPSettings.Chams.Transparency Core.ChamsObjects[plr].Enabled = true end) else if Core.ChamsObjects[plr] then pcall(function() Core.ChamsObjects[plr].Enabled = false end) end end
    end
end

function Core.SetTime(time) Lighting.ClockTime = time end
function Core.SetBrightness(brightness) Lighting.Brightness = brightness end
function Core.SetAmbient(color) Lighting.Ambient = color Lighting.OutdoorAmbient = color end
function Core.SetSkybox(name) local sky = Lighting:FindFirstChildOfClass("Sky") if name == "Default" then if sky and Core.OriginalSky then for prop, val in pairs(Core.OriginalSky) do pcall(function() sky[prop] = val end) end end return end local skyData = Core.Skyboxes[name] if not skyData then return end if not sky then sky = Instance.new("Sky") sky.Parent = Lighting end if not Core.OriginalSky and sky then Core.OriginalSky = {SkyboxBk = sky.SkyboxBk, SkyboxDn = sky.SkyboxDn, SkyboxFt = sky.SkyboxFt, SkyboxLf = sky.SkyboxLf, SkyboxRt = sky.SkyboxRt, SkyboxUp = sky.SkyboxUp} end for prop, val in pairs(skyData) do pcall(function() sky[prop] = val end) end end
function Core.SetFullbright(enabled) if enabled then Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.FogEnd = 100000 Lighting.GlobalShadows = false Lighting.Ambient = Color3.new(1,1,1) Lighting.OutdoorAmbient = Color3.new(1,1,1) else Lighting.Brightness = 1 Lighting.GlobalShadows = true end end
function Core.SetNoFog(enabled) Lighting.FogEnd = enabled and 100000 or 1000 end
function Core.GetCurrentGun() if not Core.IsAlive(LocalPlayer) then return nil end for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") then return v end end return nil end

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
                    if enabled then if not Core.OriginalValues[v] then Core.OriginalValues[v] = v.Value end v.Value = 0
                    else if Core.OriginalValues[v] then v.Value = Core.OriginalValues[v] end end
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
                if enabled then if not Core.OriginalValues[recoil] then Core.OriginalValues[recoil] = recoil.Value end recoil.Value = 0
                else if Core.OriginalValues[recoil] then recoil.Value = Core.OriginalValues[recoil] end end
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
            if enabled then if not Core.OriginalValues[fireRate] then Core.OriginalValues[fireRate] = fireRate.Value end fireRate.Value = 0.01
            else if Core.OriginalValues[fireRate] then fireRate.Value = Core.OriginalValues[fireRate] end end
        end
    end
end

function Core.CBInfAmmo(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.InfAmmo = enabled
    if enabled then
        if Core.Loops.CBInfAmmo then Core.Loops.CBInfAmmo:Disconnect() end
        Core.Loops.CBInfAmmo = RunService.RenderStepped:Connect(function()
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
        Core.Loops.CBKillAll = RunService.RenderStepped:Connect(function()
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
                            if hitEvent then hitEvent:FireServer(head, head.Position, "Banana", 100, gun, nil, nil, 100, false, false, Vector3.new(), 100, Vector3.new()) end
                        end
                    end
                end
            end)
            task.wait(0.1)
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
                Core.Loops.CBInfCash = cash:GetPropertyChangedSignal("Value"):Connect(function() cash.Value = 16000 end)
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
        if Core.Loops.CBBHop then Core.Loops.CBBHop:Disconnect() end
        Core.Loops.CBBHop = RunService.RenderStepped:Connect(function()
            if Core.IsAlive(LocalPlayer) then
                local hum = LocalPlayer.Character.Humanoid
                if hum.FloorMaterial ~= Enum.Material.Air then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    else
        if Core.Loops.CBBHop then Core.Loops.CBBHop:Disconnect() Core.Loops.CBBHop = nil end
    end
end

function Core.CBAntiAimbot(enabled)
    if Core.GameName ~= "Counter Blox" then return end
    Core.CBSettings.AntiAimbot = enabled
    if enabled then
        if Core.Loops.CBAntiAimbot then Core.Loops.CBAntiAimbot:Disconnect() end
        Core.Loops.CBAntiAimbot = RunService.RenderStepped:Connect(function()
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
        if Core.Loops.CBAntiAimbot then Core.Loops.CBAntiAimbot:Disconnect() Core.Loops.CBAntiAimbot = nil end
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
            if enabled then scope.Scope.Size = UDim2.new(2,0,2,0) scope.Scope.Position = UDim2.new(-0.5,0,-0.5,0)
            else scope.Scope.Size = UDim2.new(1,0,1,0) scope.Scope.Position = UDim2.new(0,0,0,0) end
            if scope.Scope:FindFirstChild("Blur") then
                scope.Scope.Blur.ImageTransparency = enabled and 1 or 0
                if scope.Scope.Blur:FindFirstChild("Blur") then scope.Scope.Blur.Blur.ImageTransparency = enabled and 1 or 0 end
            end
        end
        for i = 1, 4 do
            local frame = crosshairs:FindFirstChild("Frame" .. i)
            if frame then frame.Transparency = enabled and 1 or 0 end
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
        if Core.Loops.CBNoSmoke then Core.Loops.CBNoSmoke:Disconnect() end
        Core.Loops.CBNoSmoke = RunService.RenderStepped:Connect(function()
            pcall(function()
                local rayIgnore = Workspace:FindFirstChild("Ray_Ignore")
                if rayIgnore then
                    local smokes = rayIgnore:FindFirstChild("Smokes")
                    if smokes then
                        for _, v in pairs(smokes:GetChildren()) do
                            if v.Name == "Smoke" then v:Destroy() end
                        end
                    end
                end
            end)
        end)
    else
        if Core.Loops.CBNoSmoke then Core.Loops.CBNoSmoke:Disconnect() Core.Loops.CBNoSmoke = nil end
    end
end

function Core.BrookhavenSpamChat(enabled)
    if Core.GameName ~= "Brookhaven" then return end
    Core.BrookhavenSettings.SpamChat = enabled
    if enabled then
        if Core.Loops.BHSpamChat then Core.Loops.BHSpamChat:Disconnect() end
        Core.Loops.BHSpamChat = task.spawn(function()
            while Core.BrookhavenSettings.SpamChat do
                pcall(function()
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Core.BrookhavenSettings.SpamMessage, "All")
                end)
                task.wait(Core.BrookhavenSettings.SpamDelay)
            end
        end)
    else
        if Core.Loops.BHSpamChat then task.cancel(Core.Loops.BHSpamChat) Core.Loops.BHSpamChat = nil end
    end
end

function Core.BrookhavenSoundSpam()
    if Core.GameName ~= "Brookhaven" then return end
    pcall(function()
        local player = LocalPlayer
        local soundId = Core.BrookhavenSettings.SoundID
        local duration = 300
        
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0.5
        sound.Looped = true
        sound.Parent = player:WaitForChild("PlayerGui")
        sound:Play()
        
        task.delay(duration, function()
            sound:Stop()
            sound:Destroy()
        end)
        
        local remoteFolder = ReplicatedStorage:WaitForChild("RE", 5)
        if remoteFolder then
            local remote = remoteFolder:FindFirstChild("1Gu1nSound1s")
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer(soundId, duration)
            end
        end
    end)
end

function Core.BrookhavenFling(enabled)
    if Core.GameName ~= "Brookhaven" then return end
    Core.BrookhavenSettings.Fling = enabled
    if enabled then
        pcall(function()
            local BV = Instance.new("BodyAngularVelocity")
            BV.MaxTorque = Vector3.new(9e9,9e9,9e9)
            BV.AngularVelocity = Vector3.new(0,99999,0)
            BV.Parent = LocalPlayer.Character.HumanoidRootPart
            Core.BrookhavenSettings.FlingObject = BV
        end)
    else
        if Core.BrookhavenSettings.FlingObject then
            Core.BrookhavenSettings.FlingObject:Destroy()
            Core.BrookhavenSettings.FlingObject = nil
        end
    end
end

function Core.BrookhavenSpamEmotes(enabled)
    if Core.GameName ~= "Brookhaven" then return end
    Core.BrookhavenSettings.SpamEmotes = enabled
    if enabled then
        if Core.Loops.BHSpamEmotes then Core.Loops.BHSpamEmotes:Disconnect() end
        Core.Loops.BHSpamEmotes = task.spawn(function()
            local emotes = {"dance1", "dance2", "dance3"}
            while Core.BrookhavenSettings.SpamEmotes do
                pcall(function()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                    if hum then
                        hum:PlayEmote(emotes[math.random(#emotes)])
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        if Core.Loops.BHSpamEmotes then task.cancel(Core.Loops.BHSpamEmotes) Core.Loops.BHSpamEmotes = nil end
    end
end

function Core.BrookhavenKickAll()
    if Core.GameName ~= "Brookhaven" then return end
    pcall(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local event = ReplicatedStorage:FindFirstChild("KickPlayer")
                if event then event:FireServer(plr) end
            end
        end
    end)
end

function Core.BrookhavenTPAll()
    if Core.GameName ~= "Brookhaven" then return end
    pcall(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end)
end

function Core.BrookhavenExplodeAll()
    if Core.GameName ~= "Brookhaven" then return end
    pcall(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local exp = Instance.new("Explosion")
                exp.Position = plr.Character.HumanoidRootPart.Position
                exp.BlastRadius = 10
                exp.BlastPressure = 500000
                exp.Parent = Workspace
            end
        end
    end)
end

function Core.BrookhavenFreezePlayers(enabled)
    if Core.GameName ~= "Brookhaven" then return end
    Core.BrookhavenSettings.FreezePlayers = enabled
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Anchored = enabled
        end
    end
end

function Core.BrookhavenRemoveHouses()
    if Core.GameName ~= "Brookhaven" then return end
    pcall(function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and (v.Name:find("House") or v.Name:find("Building")) then
                v:Destroy()
            end
        end
    end)
end

function Core.BrookhavenSpamVehicles(enabled)
    if Core.GameName ~= "Brookhaven" then return end
    Core.BrookhavenSettings.SpamVehicles = enabled
    if enabled then
        if Core.Loops.BHSpamVehicles then Core.Loops.BHSpamVehicles:Disconnect() end
        Core.Loops.BHSpamVehicles = task.spawn(function()
            while Core.BrookhavenSettings.SpamVehicles do
                pcall(function()
                    local spawnVeh = ReplicatedStorage:FindFirstChild("SpawnVehicle")
                    if spawnVeh then spawnVeh:FireServer("Car", LocalPlayer.Character.HumanoidRootPart.Position) end
                end)
                task.wait(0.1)
            end
        end)
    else
        if Core.Loops.BHSpamVehicles then task.cancel(Core.Loops.BHSpamVehicles) Core.Loops.BHSpamVehicles = nil end
    end
end

function Core.BrookhavenFloodServer()
    if Core.GameName ~= "Brookhaven" then return end
    pcall(function()
        Workspace.Terrain:FillBlock(CFrame.new(0,0,0), Vector3.new(2048, 2048, 2048), Enum.Material.Water)
    end)
end

function Core.Rejoin() TeleportService:TeleportToPlaceInstance(Core.PlaceId, game.JobId, LocalPlayer) end
function Core.GetJoinScript() return 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. Core.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)' end
function Core.LoadScript(name)
    local scripts = {
        ["Infinite Yield"] = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
        ["Nameless Admin"] = "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source",
        ["Dex Explorer"] = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua",
        ["Remote Spy"] = "https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"
    }
    if scripts[name] then loadstring(game:HttpGet(scripts[name]))() end
end

function Core.SilentAimCameraMethod() if not Core.SilentAimSettings.Enabled then return end Core.SilentAimTarget = Core.GetSilentAimTarget() end
function Core.GetSilentAimPosition() if not Core.SilentAimSettings.Enabled or not Core.SilentAimTarget then return nil end local target = Core.SilentAimTarget if not target.Player or not Core.IsAlive(target.Player) or not target.Part then Core.SilentAimTarget = nil return nil end local targetPos = target.Part.Position if Core.SilentAimSettings.Prediction > 0 then local root = target.Player.Character:FindFirstChild("HumanoidRootPart") if root then targetPos = targetPos + (root.AssemblyLinearVelocity * (Core.SilentAimSettings.Prediction / 10)) end end return targetPos end

function Core.Init()
    for _, plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer then Core.CreateESP(plr) end end
    Players.PlayerAdded:Connect(function(plr) Core.CreateESP(plr) end)
    Players.PlayerRemoving:Connect(function(plr) Core.RemoveESP(plr) end)
    if Core.GameName == "Murder Mystery 2" then task.spawn(function() while task.wait(2) do Core.MM2Roles = {} end end) end
    RunService.RenderStepped:Connect(function() Core.SilentAimCameraMethod() end)
end

return Core
