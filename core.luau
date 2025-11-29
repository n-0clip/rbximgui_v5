-- v3 cb func
local Core = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

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

Core.ESPObjects = {}
Core.ChamsObjects = {}
Core.Connections = {}
Core.MM2Roles = {}
Core.LockedTarget = nil

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
    
    mousemoverel(delta.X, delta.Y)
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
end

return Core
