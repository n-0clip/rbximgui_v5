local ESP = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

ESP.Settings = {
    Enabled = false,
    TeamCheck = false,
    MaxDistance = 2000,
    
    Box = { 
        Enabled = false, 
        Color = Color3.fromRGB(255, 255, 255), 
        Thickness = 1,
        Outline = true
    },
    
    CornerBox = {
        Enabled = false,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Length = 10,
        Outline = true
    },
    
    Name = { 
        Enabled = false, 
        Color = Color3.fromRGB(255, 255, 255), 
        Size = 13,
        ShowDistance = false
    },
    
    Health = { 
        Enabled = false, 
        Position = "Left",
        Outline = true
    },
    
    Distance = { 
        Enabled = false, 
        Color = Color3.fromRGB(200, 200, 200), 
        Size = 11 
    },
    
    Skeleton = { 
        Enabled = false, 
        Color = Color3.fromRGB(255, 255, 255), 
        Thickness = 1
    },
    
    Chams = { 
        Enabled = false, 
        FillColor = Color3.fromRGB(255, 0, 128), 
        OutlineColor = Color3.fromRGB(255, 255, 255), 
        FillTransparency = 0.5
    },
    
    Tracers = { 
        Enabled = false, 
        Color = Color3.fromRGB(255, 255, 255), 
        Thickness = 1,
        Origin = "Bottom" 
    },
    
    HeadDot = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Size = 3,
        Outline = true
    },
    
    OffScreenArrows = {
        Enabled = false,
        Color = Color3.fromRGB(255, 0, 0),
        Size = 15
    },
    
    UseRoleColors = false
}

ESP.Objects = {}
ESP.Chams = {}
ESP.Connection = nil

ESP.MM2 = {
    RoleData = {},
    Murderer = nil,
    Sheriff = nil,
    Hero = nil,
    LastUpdate = 0,
    Colors = {
        Murderer = Color3.fromRGB(255, 0, 0),
        Sheriff = Color3.fromRGB(0, 100, 255),
        Hero = Color3.fromRGB(255, 255, 0),
        Innocent = Color3.fromRGB(0, 255, 0)
    }
}

local SkeletonConnections = {
    R15 = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    },
    R6 = {
        {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
    }
}

local function NewDrawing(class, props)
    local ok, d = pcall(Drawing.new, class)
    if not ok or not d then return nil end
    for k, v in pairs(props or {}) do pcall(function() d[k] = v end) end
    return d
end

local function SafeSet(d, p, v)
    if d then pcall(function() d[p] = v end) end
end

local function SafeRemove(d)
    if d then pcall(function() d:Remove() end) end
end

local function IsAlive(plr)
    if not plr then return false end
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if ESP.MM2.RoleData[plr.Name] then
        local data = ESP.MM2.RoleData[plr.Name]
        if type(data) == "table" and (data.Killed or data.Dead) then return false end
    end
    return true
end

function ESP.UpdateMM2Roles()
    if tick() - ESP.MM2.LastUpdate < 1 then return end
    ESP.MM2.LastUpdate = tick()
    
    pcall(function()
        local data
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote then
            local gameplay = remote:FindFirstChild("Gameplay")
            if gameplay then
                local gpd = gameplay:FindFirstChild("GetPlayerData")
                if gpd then data = gpd:InvokeServer() end
            end
        end
        if not data then
            local gpd = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
            if gpd then data = gpd:InvokeServer() end
        end
        
        if data and type(data) == "table" then
            ESP.MM2.RoleData = data
            ESP.MM2.Murderer, ESP.MM2.Sheriff, ESP.MM2.Hero = nil, nil, nil
            for name, info in pairs(data) do
                if type(info) == "table" and info.Role then
                    if info.Role == "Murderer" then ESP.MM2.Murderer = name
                    elseif info.Role == "Sheriff" then ESP.MM2.Sheriff = name
                    elseif info.Role == "Hero" then ESP.MM2.Hero = name end
                end
            end
        end
    end)
end

function ESP.GetMM2Role(plr)
    if not plr then return "Innocent" end
    local name = plr.Name
    
    if ESP.MM2.RoleData[name] and type(ESP.MM2.RoleData[name]) == "table" then
        if ESP.MM2.RoleData[name].Role then return ESP.MM2.RoleData[name].Role end
    end
    
    if name == ESP.MM2.Murderer then return "Murderer" end
    if name == ESP.MM2.Sheriff then return "Sheriff" end
    if name == ESP.MM2.Hero then return "Hero" end
    
    local char, bp = plr.Character, plr:FindFirstChild("Backpack")
    local function hasWeapon(c, t)
        if not c then return false end
        for _, tool in pairs(c:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if t == "knife" and n:find("knife") then return true end
                if t == "gun" and (n:find("gun") or n:find("revolver")) then return true end
            end
        end
        return false
    end
    
    if hasWeapon(char, "knife") or hasWeapon(bp, "knife") then return "Murderer" end
    if hasWeapon(char, "gun") or hasWeapon(bp, "gun") then
        if ESP.MM2.Sheriff and Players:FindFirstChild(ESP.MM2.Sheriff) then
            if not IsAlive(Players[ESP.MM2.Sheriff]) then return "Hero" end
        end
        return "Sheriff"
    end
    
    return "Innocent"
end

function ESP.GetRoleColor(plr)
    local role = ESP.GetMM2Role(plr)
    return ESP.MM2.Colors[role] or ESP.MM2.Colors.Innocent
end

function ESP.Create(plr)
    if not plr or ESP.Objects[plr] then return end
    
    ESP.Objects[plr] = {
        Box = NewDrawing("Square", {Thickness = 1, Filled = false}),
        BoxOutline = NewDrawing("Square", {Thickness = 3, Filled = false, Color = Color3.new(0,0,0)}),
        
        CornerTL1 = NewDrawing("Line", {}), CornerTL2 = NewDrawing("Line", {}),
        CornerTR1 = NewDrawing("Line", {}), CornerTR2 = NewDrawing("Line", {}),
        CornerBL1 = NewDrawing("Line", {}), CornerBL2 = NewDrawing("Line", {}),
        CornerBR1 = NewDrawing("Line", {}), CornerBR2 = NewDrawing("Line", {}),
        CornerTL1_O = NewDrawing("Line", {Color = Color3.new(0,0,0), Thickness = 3}),
        CornerTL2_O = NewDrawing("Line", {Color = Color3.new(0,0,0), Thickness = 3}),
        CornerTR1_O = NewDrawing("Line", {Color = Color3.new(0,0,0), Thickness = 3}),
        CornerTR2_O = NewDrawing("Line", {Color = Color3.new(0,0,0), Thickness = 3}),
        CornerBL1_O = NewDrawing("Line", {Color = Color3.new(0,0,0), Thickness = 3}),
        CornerBL2_O = NewDrawing("Line", {Color = Color3.new(0,0,0), Thickness = 3}),
        CornerBR1_O = NewDrawing("Line", {Color = Color3.new(0,0,0), Thickness = 3}),
        CornerBR2_O = NewDrawing("Line", {Color = Color3.new(0,0,0), Thickness = 3}),
        
        Name = NewDrawing("Text", {Size = 13, Center = true, Outline = true, Font = 2}),
        Distance = NewDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2}),
        
        HealthBar = NewDrawing("Square", {Filled = true}),
        HealthBarBg = NewDrawing("Square", {Filled = true, Color = Color3.fromRGB(20,20,20)}),
        HealthBarOutline = NewDrawing("Square", {Filled = false, Color = Color3.new(0,0,0), Thickness = 1}),
        
        Tracer = NewDrawing("Line", {}),
        TracerOutline = NewDrawing("Line", {Color = Color3.new(0,0,0), Thickness = 3}),
        
        HeadDot = NewDrawing("Circle", {Filled = true, NumSides = 30}),
        HeadDotOutline = NewDrawing("Circle", {Filled = false, Color = Color3.new(0,0,0), Thickness = 2, NumSides = 30}),
        
        Arrow = NewDrawing("Triangle", {Filled = true}),
        ArrowOutline = NewDrawing("Triangle", {Filled = false, Color = Color3.new(0,0,0), Thickness = 2}),
        
        Skeleton = {}
    }
    
    for i = 1, 14 do ESP.Objects[plr].Skeleton[i] = NewDrawing("Line", {}) end
end

function ESP.Remove(plr)
    local obj = ESP.Objects[plr]
    if obj then
        for k, v in pairs(obj) do
            if type(v) == "table" then
                for _, l in pairs(v) do SafeRemove(l) end
            else SafeRemove(v) end
        end
        ESP.Objects[plr] = nil
    end
    if ESP.Chams[plr] then
        pcall(function() ESP.Chams[plr]:Destroy() end)
        ESP.Chams[plr] = nil
    end
end

function ESP.HideAll(obj)
    if not obj then return end
    for k, v in pairs(obj) do
        if type(v) == "table" then
            for _, i in pairs(v) do SafeSet(i, "Visible", false) end
        else SafeSet(v, "Visible", false) end
    end
end

function ESP.Update()
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    
    if ESP.Settings.UseRoleColors then ESP.UpdateMM2Roles() end
    
    for plr, obj in pairs(ESP.Objects) do
        -- Hide conditions
        if not ESP.Settings.Enabled or plr == LocalPlayer then
            ESP.HideAll(obj)
            if ESP.Chams[plr] then pcall(function() ESP.Chams[plr].Enabled = false end) end
            continue
        end
        
        if not IsAlive(plr) then
            ESP.HideAll(obj)
            if ESP.Chams[plr] then pcall(function() ESP.Chams[plr]:Destroy() end) ESP.Chams[plr] = nil end
            continue
        end
        
        if ESP.Settings.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            ESP.HideAll(obj)
            if ESP.Chams[plr] then pcall(function() ESP.Chams[plr].Enabled = false end) end
            continue
        end
        
        local char = plr.Character
        if not char then ESP.HideAll(obj) continue end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not head or not hum then ESP.HideAll(obj) continue end
        
        local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        
        if dist > ESP.Settings.MaxDistance then
            ESP.HideAll(obj)
            if ESP.Chams[plr] then pcall(function() ESP.Chams[plr].Enabled = false end) end
            continue
        end
        
        -- Role color (only used when UseRoleColors is true)
        local roleColor = ESP.Settings.UseRoleColors and ESP.GetRoleColor(plr) or nil
        
        -- Off screen
        if not onScreen then
            ESP.HideAll(obj)
            if ESP.Chams[plr] then pcall(function() ESP.Chams[plr].Enabled = false end) end
            
            if ESP.Settings.OffScreenArrows.Enabled then
                local arrowColor = roleColor or ESP.Settings.OffScreenArrows.Color
                local vs = Camera.ViewportSize
                local center = vs / 2
                local dir = (Vector2.new(rootPos.X, rootPos.Y) - center).Unit
                local ap = center + dir * math.min(vs.X, vs.Y) * 0.4
                local angle = math.atan2(dir.Y, dir.X)
                local size = ESP.Settings.OffScreenArrows.Size
                local p1 = ap + Vector2.new(math.cos(angle) * size, math.sin(angle) * size)
                local p2 = ap + Vector2.new(math.cos(angle + 2.5) * size * 0.6, math.sin(angle + 2.5) * size * 0.6)
                local p3 = ap + Vector2.new(math.cos(angle - 2.5) * size * 0.6, math.sin(angle - 2.5) * size * 0.6)
                
                SafeSet(obj.ArrowOutline, "PointA", p1) SafeSet(obj.ArrowOutline, "PointB", p2) SafeSet(obj.ArrowOutline, "PointC", p3)
                SafeSet(obj.ArrowOutline, "Visible", true)
                SafeSet(obj.Arrow, "PointA", p1) SafeSet(obj.Arrow, "PointB", p2) SafeSet(obj.Arrow, "PointC", p3)
                SafeSet(obj.Arrow, "Color", arrowColor) SafeSet(obj.Arrow, "Visible", true)
            end
            continue
        end
        
        -- Hide arrow when on screen
        SafeSet(obj.Arrow, "Visible", false)
        SafeSet(obj.ArrowOutline, "Visible", false)
        
        -- Calculate box
        local headTop = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local footBottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        local boxH = math.abs(footBottom.Y - headTop.Y)
        local boxW = boxH * 0.5
        local boxX = rootPos.X - boxW / 2
        local boxY = headTop.Y
        
        -- ═══════════════════════════════════════════════════════════
        -- BOX (uses Box.Color or roleColor)
        -- ═══════════════════════════════════════════════════════════
        if ESP.Settings.Box.Enabled and not ESP.Settings.CornerBox.Enabled then
            local boxColor = roleColor or ESP.Settings.Box.Color
            
            -- Hide corners
            SafeSet(obj.CornerTL1, "Visible", false) SafeSet(obj.CornerTL2, "Visible", false)
            SafeSet(obj.CornerTR1, "Visible", false) SafeSet(obj.CornerTR2, "Visible", false)
            SafeSet(obj.CornerBL1, "Visible", false) SafeSet(obj.CornerBL2, "Visible", false)
            SafeSet(obj.CornerBR1, "Visible", false) SafeSet(obj.CornerBR2, "Visible", false)
            SafeSet(obj.CornerTL1_O, "Visible", false) SafeSet(obj.CornerTL2_O, "Visible", false)
            SafeSet(obj.CornerTR1_O, "Visible", false) SafeSet(obj.CornerTR2_O, "Visible", false)
            SafeSet(obj.CornerBL1_O, "Visible", false) SafeSet(obj.CornerBL2_O, "Visible", false)
            SafeSet(obj.CornerBR1_O, "Visible", false) SafeSet(obj.CornerBR2_O, "Visible", false)
            
            if ESP.Settings.Box.Outline then
                SafeSet(obj.BoxOutline, "Size", Vector2.new(boxW, boxH))
                SafeSet(obj.BoxOutline, "Position", Vector2.new(boxX, boxY))
                SafeSet(obj.BoxOutline, "Visible", true)
            else
                SafeSet(obj.BoxOutline, "Visible", false)
            end
            
            SafeSet(obj.Box, "Size", Vector2.new(boxW, boxH))
            SafeSet(obj.Box, "Position", Vector2.new(boxX, boxY))
            SafeSet(obj.Box, "Color", boxColor)
            SafeSet(obj.Box, "Thickness", ESP.Settings.Box.Thickness)
            SafeSet(obj.Box, "Visible", true)
            
        -- ═══════════════════════════════════════════════════════════
        -- CORNER BOX (uses CornerBox.Color or roleColor)
        -- ═══════════════════════════════════════════════════════════
        elseif ESP.Settings.CornerBox.Enabled then
            local cornerColor = roleColor or ESP.Settings.CornerBox.Color
            local len = ESP.Settings.CornerBox.Length
            local thick = ESP.Settings.CornerBox.Thickness
            local outline = ESP.Settings.CornerBox.Outline
            
            -- Hide regular box
            SafeSet(obj.Box, "Visible", false)
            SafeSet(obj.BoxOutline, "Visible", false)
            
            local corners = {
                {obj.CornerTL1, obj.CornerTL1_O, boxX, boxY, boxX + len, boxY},
                {obj.CornerTL2, obj.CornerTL2_O, boxX, boxY, boxX, boxY + len},
                {obj.CornerTR1, obj.CornerTR1_O, boxX + boxW, boxY, boxX + boxW - len, boxY},
                {obj.CornerTR2, obj.CornerTR2_O, boxX + boxW, boxY, boxX + boxW, boxY + len},
                {obj.CornerBL1, obj.CornerBL1_O, boxX, boxY + boxH, boxX + len, boxY + boxH},
                {obj.CornerBL2, obj.CornerBL2_O, boxX, boxY + boxH, boxX, boxY + boxH - len},
                {obj.CornerBR1, obj.CornerBR1_O, boxX + boxW, boxY + boxH, boxX + boxW - len, boxY + boxH},
                {obj.CornerBR2, obj.CornerBR2_O, boxX + boxW, boxY + boxH, boxX + boxW, boxY + boxH - len},
            }
            
            for _, c in ipairs(corners) do
                local line, out, x1, y1, x2, y2 = c[1], c[2], c[3], c[4], c[5], c[6]
                if outline and out then
                    SafeSet(out, "From", Vector2.new(x1, y1))
                    SafeSet(out, "To", Vector2.new(x2, y2))
                    SafeSet(out, "Visible", true)
                elseif out then
                    SafeSet(out, "Visible", false)
                end
                SafeSet(line, "From", Vector2.new(x1, y1))
                SafeSet(line, "To", Vector2.new(x2, y2))
                SafeSet(line, "Color", cornerColor)
                SafeSet(line, "Thickness", thick)
                SafeSet(line, "Visible", true)
            end
        else
            -- Hide all boxes
            SafeSet(obj.Box, "Visible", false)
            SafeSet(obj.BoxOutline, "Visible", false)
            SafeSet(obj.CornerTL1, "Visible", false) SafeSet(obj.CornerTL2, "Visible", false)
            SafeSet(obj.CornerTR1, "Visible", false) SafeSet(obj.CornerTR2, "Visible", false)
            SafeSet(obj.CornerBL1, "Visible", false) SafeSet(obj.CornerBL2, "Visible", false)
            SafeSet(obj.CornerBR1, "Visible", false) SafeSet(obj.CornerBR2, "Visible", false)
            SafeSet(obj.CornerTL1_O, "Visible", false) SafeSet(obj.CornerTL2_O, "Visible", false)
            SafeSet(obj.CornerTR1_O, "Visible", false) SafeSet(obj.CornerTR2_O, "Visible", false)
            SafeSet(obj.CornerBL1_O, "Visible", false) SafeSet(obj.CornerBL2_O, "Visible", false)
            SafeSet(obj.CornerBR1_O, "Visible", false) SafeSet(obj.CornerBR2_O, "Visible", false)
        end
        
        -- ═══════════════════════════════════════════════════════════
        -- NAME (uses Name.Color or roleColor)
        -- ═══════════════════════════════════════════════════════════
        if ESP.Settings.Name.Enabled then
            local nameColor = roleColor or ESP.Settings.Name.Color
            local txt = plr.DisplayName or plr.Name
            if ESP.Settings.UseRoleColors then
                local role = ESP.GetMM2Role(plr)
                if role ~= "Innocent" then txt = "[" .. role .. "] " .. txt end
            end
            if ESP.Settings.Name.ShowDistance then txt = txt .. " [" .. math.floor(dist) .. "m]" end
            
            SafeSet(obj.Name, "Text", txt)
            SafeSet(obj.Name, "Position", Vector2.new(boxX + boxW / 2, boxY - 16))
            SafeSet(obj.Name, "Color", nameColor)
            SafeSet(obj.Name, "Size", ESP.Settings.Name.Size)
            SafeSet(obj.Name, "Visible", true)
        else
            SafeSet(obj.Name, "Visible", false)
        end
        
        -- ═══════════════════════════════════════════════════════════
        -- DISTANCE (uses Distance.Color or roleColor)
        -- ═══════════════════════════════════════════════════════════
        if ESP.Settings.Distance.Enabled and not ESP.Settings.Name.ShowDistance then
            local distColor = roleColor or ESP.Settings.Distance.Color
            SafeSet(obj.Distance, "Text", math.floor(dist) .. "m")
            SafeSet(obj.Distance, "Position", Vector2.new(boxX + boxW / 2, boxY + boxH + 2))
            SafeSet(obj.Distance, "Color", distColor)
            SafeSet(obj.Distance, "Size", ESP.Settings.Distance.Size)
            SafeSet(obj.Distance, "Visible", true)
        else
            SafeSet(obj.Distance, "Visible", false)
        end
        
        -- ═══════════════════════════════════════════════════════════
        -- HEALTH BAR (always gradient, not affected by colors)
        -- ═══════════════════════════════════════════════════════════
        if ESP.Settings.Health.Enabled then
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barW = 4
            local barX = ESP.Settings.Health.Position == "Left" and (boxX - 7) or (boxX + boxW + 3)
            
            SafeSet(obj.HealthBarBg, "Size", Vector2.new(barW, boxH))
            SafeSet(obj.HealthBarBg, "Position", Vector2.new(barX, boxY))
            SafeSet(obj.HealthBarBg, "Visible", true)
            
            local healthH = boxH * hp
            SafeSet(obj.HealthBar, "Size", Vector2.new(barW - 2, healthH))
            SafeSet(obj.HealthBar, "Position", Vector2.new(barX + 1, boxY + boxH - healthH))
            SafeSet(obj.HealthBar, "Color", Color3.fromRGB(255 * (1 - hp), 255 * hp, 0))
            SafeSet(obj.HealthBar, "Visible", true)
            
            if ESP.Settings.Health.Outline then
                SafeSet(obj.HealthBarOutline, "Size", Vector2.new(barW, boxH))
                SafeSet(obj.HealthBarOutline, "Position", Vector2.new(barX, boxY))
                SafeSet(obj.HealthBarOutline, "Visible", true)
            else
                SafeSet(obj.HealthBarOutline, "Visible", false)
            end
        else
            SafeSet(obj.HealthBar, "Visible", false)
            SafeSet(obj.HealthBarBg, "Visible", false)
            SafeSet(obj.HealthBarOutline, "Visible", false)
        end
        
        -- ═══════════════════════════════════════════════════════════
        -- HEAD DOT (uses HeadDot.Color or roleColor)
        -- ═══════════════════════════════════════════════════════════
        if ESP.Settings.HeadDot.Enabled then
            local dotColor = roleColor or ESP.Settings.HeadDot.Color
            local headScreen = Camera:WorldToViewportPoint(head.Position)
            
            if ESP.Settings.HeadDot.Outline then
                SafeSet(obj.HeadDotOutline, "Position", Vector2.new(headScreen.X, headScreen.Y))
                SafeSet(obj.HeadDotOutline, "Radius", ESP.Settings.HeadDot.Size + 1)
                SafeSet(obj.HeadDotOutline, "Visible", true)
            else
                SafeSet(obj.HeadDotOutline, "Visible", false)
            end
            
            SafeSet(obj.HeadDot, "Position", Vector2.new(headScreen.X, headScreen.Y))
            SafeSet(obj.HeadDot, "Radius", ESP.Settings.HeadDot.Size)
            SafeSet(obj.HeadDot, "Color", dotColor)
            SafeSet(obj.HeadDot, "Visible", true)
        else
            SafeSet(obj.HeadDot, "Visible", false)
            SafeSet(obj.HeadDotOutline, "Visible", false)
        end
        
        -- ═══════════════════════════════════════════════════════════
        -- TRACERS (uses Tracers.Color or roleColor)
        -- ═══════════════════════════════════════════════════════════
        if ESP.Settings.Tracers.Enabled then
            local tracerColor = roleColor or ESP.Settings.Tracers.Color
            local originX = Camera.ViewportSize.X / 2
            local originY = ESP.Settings.Tracers.Origin == "Top" and 0 
                or ESP.Settings.Tracers.Origin == "Center" and Camera.ViewportSize.Y / 2 
                or Camera.ViewportSize.Y
            
            SafeSet(obj.TracerOutline, "From", Vector2.new(originX, originY))
            SafeSet(obj.TracerOutline, "To", Vector2.new(rootPos.X, footBottom.Y))
            SafeSet(obj.TracerOutline, "Visible", true)
            
            SafeSet(obj.Tracer, "From", Vector2.new(originX, originY))
            SafeSet(obj.Tracer, "To", Vector2.new(rootPos.X, footBottom.Y))
            SafeSet(obj.Tracer, "Color", tracerColor)
            SafeSet(obj.Tracer, "Thickness", ESP.Settings.Tracers.Thickness)
            SafeSet(obj.Tracer, "Visible", true)
        else
            SafeSet(obj.Tracer, "Visible", false)
            SafeSet(obj.TracerOutline, "Visible", false)
        end
        
        -- ═══════════════════════════════════════════════════════════
        -- SKELETON (uses Skeleton.Color or roleColor)
        -- ═══════════════════════════════════════════════════════════
        if ESP.Settings.Skeleton.Enabled then
            local skelColor = roleColor or ESP.Settings.Skeleton.Color
            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
            local conns = isR15 and SkeletonConnections.R15 or SkeletonConnections.R6
            
            for i = 1, 14 do
                local line = obj.Skeleton[i]
                if not line then continue end
                local conn = conns[i]
                if not conn then SafeSet(line, "Visible", false) continue end
                
                local p1, p2 = char:FindFirstChild(conn[1]), char:FindFirstChild(conn[2])
                if p1 and p2 then
                    local v1, os1 = Camera:WorldToViewportPoint(p1.Position)
                    local v2, os2 = Camera:WorldToViewportPoint(p2.Position)
                    if os1 and os2 then
                        SafeSet(line, "From", Vector2.new(v1.X, v1.Y))
                        SafeSet(line, "To", Vector2.new(v2.X, v2.Y))
                        SafeSet(line, "Color", skelColor)
                        SafeSet(line, "Thickness", ESP.Settings.Skeleton.Thickness)
                        SafeSet(line, "Visible", true)
                    else
                        SafeSet(line, "Visible", false)
                    end
                else
                    SafeSet(line, "Visible", false)
                end
            end
        else
            for i = 1, 14 do
                if obj.Skeleton[i] then SafeSet(obj.Skeleton[i], "Visible", false) end
            end
        end
        
        -- ═══════════════════════════════════════════════════════════
        -- CHAMS (uses Chams.FillColor or roleColor)
        -- ═══════════════════════════════════════════════════════════
        if ESP.Settings.Chams.Enabled then
            if not ESP.Chams[plr] then
                local hl = Instance.new("Highlight")
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Adornee = char
                pcall(function() hl.Parent = CoreGui end)
                if not hl.Parent then pcall(function() hl.Parent = game:GetService("Lighting") end) end
                ESP.Chams[plr] = hl
            end
            
            local chams = ESP.Chams[plr]
            if chams then
                if chams.Adornee ~= char then chams.Adornee = char end
                local chamsColor = roleColor or ESP.Settings.Chams.FillColor
                chams.FillColor = chamsColor
                chams.OutlineColor = ESP.Settings.Chams.OutlineColor
                chams.FillTransparency = ESP.Settings.Chams.FillTransparency
                chams.Enabled = true
            end
        else
            if ESP.Chams[plr] then pcall(function() ESP.Chams[plr].Enabled = false end) end
        end
    end
end

function ESP.Init()
    Camera = Workspace.CurrentCamera
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then ESP.Create(plr) end
    end
    Players.PlayerAdded:Connect(function(plr) task.wait(0.1) ESP.Create(plr) end)
    Players.PlayerRemoving:Connect(function(plr) ESP.Remove(plr) end)
    if ESP.Connection then pcall(function() ESP.Connection:Disconnect() end) end
    ESP.Connection = RunService.RenderStepped:Connect(function() pcall(ESP.Update) end)
end

function ESP.Destroy()
    if ESP.Connection then pcall(function() ESP.Connection:Disconnect() end) ESP.Connection = nil end
    for plr in pairs(ESP.Objects) do ESP.Remove(plr) end
    ESP.Objects = {}
    ESP.Chams = {}
end

return ESP
