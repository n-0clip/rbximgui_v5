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
ESP.GetColorCallback = nil

-- MM2 Role Data
ESP.MM2 = {
    RoleData = {},
    Murderer = nil,
    Sheriff = nil,
    Hero = nil,
    LastUpdate = 0
}

local SkeletonConnections = {
    R15 = {
        {"Head", "UpperTorso"}, 
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, 
        {"LeftUpperArm", "LeftLowerArm"}, 
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, 
        {"RightUpperArm", "RightLowerArm"}, 
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, 
        {"LeftUpperLeg", "LeftLowerLeg"}, 
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, 
        {"RightUpperLeg", "RightLowerLeg"}, 
        {"RightLowerLeg", "RightFoot"}
    },
    R6 = {
        {"Head", "Torso"}, 
        {"Torso", "Left Arm"}, 
        {"Torso", "Right Arm"}, 
        {"Torso", "Left Leg"}, 
        {"Torso", "Right Leg"}
    }
}

local function NewDrawing(class, props)
    local success, drawing = pcall(function()
        return Drawing.new(class)
    end)
    
    if not success or not drawing then 
        return nil
    end
    
    for key, value in pairs(props or {}) do 
        pcall(function() drawing[key] = value end) 
    end
    
    return drawing
end

local function SafeRemove(drawing)
    if drawing then
        pcall(function() drawing:Remove() end)
    end
end

local function SafeSet(drawing, prop, value)
    if drawing then
        pcall(function() drawing[prop] = value end)
    end
end

local function IsAlive(plr)
    if not plr then return false end
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health <= 0 then return false end
    
    -- Check MM2 role data
    if ESP.MM2.RoleData[plr.Name] then
        local data = ESP.MM2.RoleData[plr.Name]
        if type(data) == "table" and (data.Killed or data.Dead) then
            return false
        end
    end
    
    return true
end

-- MM2 Functions
function ESP.UpdateMM2Roles()
    if tick() - ESP.MM2.LastUpdate < 1 then return end
    ESP.MM2.LastUpdate = tick()
    
    local success, data = pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote then
            local gameplay = remote:FindFirstChild("Gameplay")
            if gameplay then
                local getPlayerData = gameplay:FindFirstChild("GetPlayerData")
                if getPlayerData then
                    return getPlayerData:InvokeServer()
                end
            end
        end
        
        local getPlayerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
        if getPlayerData then
            return getPlayerData:InvokeServer()
        end
        
        return nil
    end)
    
    if success and data and type(data) == "table" then
        ESP.MM2.RoleData = data
        ESP.MM2.Murderer = nil
        ESP.MM2.Sheriff = nil
        ESP.MM2.Hero = nil
        
        for playerName, info in pairs(data) do
            if type(info) == "table" and info.Role then
                if info.Role == "Murderer" then
                    ESP.MM2.Murderer = playerName
                elseif info.Role == "Sheriff" then
                    ESP.MM2.Sheriff = playerName
                elseif info.Role == "Hero" then
                    ESP.MM2.Hero = playerName
                end
            end
        end
    end
end

function ESP.GetMM2Role(plr)
    if not plr then return "Innocent" end
    
    local playerName = plr.Name
    
    -- Check from server data
    if ESP.MM2.RoleData[playerName] then
        local data = ESP.MM2.RoleData[playerName]
        if type(data) == "table" and data.Role then
            return data.Role
        end
    end
    
    -- Check by role name cache
    if playerName == ESP.MM2.Murderer then return "Murderer" end
    if playerName == ESP.MM2.Sheriff then return "Sheriff" end
    if playerName == ESP.MM2.Hero then return "Hero" end
    
    -- Check by weapon in inventory
    local char = plr.Character
    local backpack = plr:FindFirstChild("Backpack")
    
    local function hasWeapon(container, weaponType)
        if not container then return false end
        for _, tool in pairs(container:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if weaponType == "knife" and name:find("knife") then return true end
                if weaponType == "gun" and (name:find("gun") or name:find("revolver")) then return true end
            end
        end
        return false
    end
    
    if hasWeapon(char, "knife") or hasWeapon(backpack, "knife") then
        return "Murderer"
    end
    
    if hasWeapon(char, "gun") or hasWeapon(backpack, "gun") then
        -- Check if original sheriff is dead
        if ESP.MM2.Sheriff then
            local sheriff = Players:FindFirstChild(ESP.MM2.Sheriff)
            if sheriff and not IsAlive(sheriff) then
                return "Hero"
            end
        end
        return "Sheriff"
    end
    
    -- Check HasGun from server data
    if ESP.MM2.RoleData[playerName] then
        local data = ESP.MM2.RoleData[playerName]
        if type(data) == "table" and data.HasGun then
            return "Hero"
        end
    end
    
    return "Innocent"
end

function ESP.GetMM2Color(plr)
    local role = ESP.GetMM2Role(plr)
    
    if role == "Murderer" then
        return Color3.fromRGB(255, 0, 0)
    elseif role == "Sheriff" then
        return Color3.fromRGB(0, 100, 255)
    elseif role == "Hero" then
        return Color3.fromRGB(255, 255, 0)
    end
    
    return Color3.fromRGB(0, 255, 0)
end

function ESP.GetColor(plr)
    if ESP.GetColorCallback then
        local success, color = pcall(ESP.GetColorCallback, plr)
        if success and color then
            return color
        end
    end
    
    if ESP.Settings.UseRoleColors then
        return ESP.GetMM2Color(plr)
    end
    
    return ESP.Settings.Box.Color
end

function ESP.GetHealthColor(percent)
    local r = math.floor(255 * (1 - percent))
    local g = math.floor(255 * percent)
    return Color3.fromRGB(r, g, 0)
end

function ESP.Create(plr)
    if not plr or ESP.Objects[plr] then return end
    
    local obj = {
        Box = NewDrawing("Square", {Thickness = 1, Filled = false}),
        BoxOutline = NewDrawing("Square", {Thickness = 3, Filled = false, Color = Color3.new(0, 0, 0)}),
        
        CornerTL1 = NewDrawing("Line", {Thickness = 1}),
        CornerTL2 = NewDrawing("Line", {Thickness = 1}),
        CornerTR1 = NewDrawing("Line", {Thickness = 1}),
        CornerTR2 = NewDrawing("Line", {Thickness = 1}),
        CornerBL1 = NewDrawing("Line", {Thickness = 1}),
        CornerBL2 = NewDrawing("Line", {Thickness = 1}),
        CornerBR1 = NewDrawing("Line", {Thickness = 1}),
        CornerBR2 = NewDrawing("Line", {Thickness = 1}),
        
        CornerTL1_O = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        CornerTL2_O = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        CornerTR1_O = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        CornerTR2_O = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        CornerBL1_O = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        CornerBL2_O = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        CornerBR1_O = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        CornerBR2_O = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        
        Name = NewDrawing("Text", {Size = 13, Center = true, Outline = true, Font = 2}),
        Distance = NewDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2}),
        
        HealthBar = NewDrawing("Square", {Filled = true}),
        HealthBarBg = NewDrawing("Square", {Filled = true, Color = Color3.fromRGB(20, 20, 20)}),
        HealthBarOutline = NewDrawing("Square", {Filled = false, Color = Color3.new(0, 0, 0), Thickness = 1}),
        
        Tracer = NewDrawing("Line", {Thickness = 1}),
        TracerOutline = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        
        HeadDot = NewDrawing("Circle", {Filled = true, NumSides = 30}),
        HeadDotOutline = NewDrawing("Circle", {Filled = false, Color = Color3.new(0, 0, 0), Thickness = 2, NumSides = 30}),
        
        Arrow = NewDrawing("Triangle", {Filled = true}),
        ArrowOutline = NewDrawing("Triangle", {Filled = false, Color = Color3.new(0, 0, 0), Thickness = 2}),
        
        Skeleton = {}
    }
    
    for i = 1, 14 do
        obj.Skeleton[i] = NewDrawing("Line", {Thickness = 1})
    end
    
    ESP.Objects[plr] = obj
end

function ESP.Remove(plr)
    local obj = ESP.Objects[plr]
    if obj then
        for key, value in pairs(obj) do
            if type(value) == "table" then
                for _, line in pairs(value) do
                    SafeRemove(line)
                end
            else
                SafeRemove(value)
            end
        end
        ESP.Objects[plr] = nil
    end
    
    ESP.RemoveChams(plr)
end

function ESP.RemoveChams(plr)
    if ESP.Chams[plr] then
        pcall(function() ESP.Chams[plr]:Destroy() end)
        ESP.Chams[plr] = nil
    end
end

function ESP.HideAll(obj)
    if not obj then return end
    
    SafeSet(obj.Box, "Visible", false)
    SafeSet(obj.BoxOutline, "Visible", false)
    SafeSet(obj.Name, "Visible", false)
    SafeSet(obj.Distance, "Visible", false)
    SafeSet(obj.HealthBar, "Visible", false)
    SafeSet(obj.HealthBarBg, "Visible", false)
    SafeSet(obj.HealthBarOutline, "Visible", false)
    SafeSet(obj.Tracer, "Visible", false)
    SafeSet(obj.TracerOutline, "Visible", false)
    SafeSet(obj.HeadDot, "Visible", false)
    SafeSet(obj.HeadDotOutline, "Visible", false)
    SafeSet(obj.Arrow, "Visible", false)
    SafeSet(obj.ArrowOutline, "Visible", false)
    
    SafeSet(obj.CornerTL1, "Visible", false)
    SafeSet(obj.CornerTL2, "Visible", false)
    SafeSet(obj.CornerTR1, "Visible", false)
    SafeSet(obj.CornerTR2, "Visible", false)
    SafeSet(obj.CornerBL1, "Visible", false)
    SafeSet(obj.CornerBL2, "Visible", false)
    SafeSet(obj.CornerBR1, "Visible", false)
    SafeSet(obj.CornerBR2, "Visible", false)
    SafeSet(obj.CornerTL1_O, "Visible", false)
    SafeSet(obj.CornerTL2_O, "Visible", false)
    SafeSet(obj.CornerTR1_O, "Visible", false)
    SafeSet(obj.CornerTR2_O, "Visible", false)
    SafeSet(obj.CornerBL1_O, "Visible", false)
    SafeSet(obj.CornerBL2_O, "Visible", false)
    SafeSet(obj.CornerBR1_O, "Visible", false)
    SafeSet(obj.CornerBR2_O, "Visible", false)
    
    for i = 1, 14 do
        if obj.Skeleton[i] then
            SafeSet(obj.Skeleton[i], "Visible", false)
        end
    end
end

function ESP.HideChams(plr)
    if ESP.Chams[plr] then
        pcall(function() ESP.Chams[plr].Enabled = false end)
    end
end

function ESP.DrawCornerBox(obj, x, y, w, h, color, thickness, length, outline)
    local corners = {
        {obj.CornerTL1, obj.CornerTL1_O, x, y, x + length, y},
        {obj.CornerTL2, obj.CornerTL2_O, x, y, x, y + length},
        {obj.CornerTR1, obj.CornerTR1_O, x + w, y, x + w - length, y},
        {obj.CornerTR2, obj.CornerTR2_O, x + w, y, x + w, y + length},
        {obj.CornerBL1, obj.CornerBL1_O, x, y + h, x + length, y + h},
        {obj.CornerBL2, obj.CornerBL2_O, x, y + h, x, y + h - length},
        {obj.CornerBR1, obj.CornerBR1_O, x + w, y + h, x + w - length, y + h},
        {obj.CornerBR2, obj.CornerBR2_O, x + w, y + h, x + w, y + h - length},
    }
    
    for _, c in ipairs(corners) do
        local line, outLine, x1, y1, x2, y2 = c[1], c[2], c[3], c[4], c[5], c[6]
        
        if outline and outLine then
            SafeSet(outLine, "From", Vector2.new(x1, y1))
            SafeSet(outLine, "To", Vector2.new(x2, y2))
            SafeSet(outLine, "Visible", true)
        elseif outLine then
            SafeSet(outLine, "Visible", false)
        end
        
        if line then
            SafeSet(line, "From", Vector2.new(x1, y1))
            SafeSet(line, "To", Vector2.new(x2, y2))
            SafeSet(line, "Color", color)
            SafeSet(line, "Thickness", thickness)
            SafeSet(line, "Visible", true)
        end
    end
end

function ESP.DrawArrow(obj, targetPos, color, size)
    local viewportSize = Camera.ViewportSize
    local center = viewportSize / 2
    
    local direction = (Vector2.new(targetPos.X, targetPos.Y) - center).Unit
    local arrowPos = center + direction * math.min(viewportSize.X, viewportSize.Y) * 0.4
    
    local angle = math.atan2(direction.Y, direction.X)
    
    local p1 = arrowPos + Vector2.new(math.cos(angle) * size, math.sin(angle) * size)
    local p2 = arrowPos + Vector2.new(math.cos(angle + 2.5) * size * 0.6, math.sin(angle + 2.5) * size * 0.6)
    local p3 = arrowPos + Vector2.new(math.cos(angle - 2.5) * size * 0.6, math.sin(angle - 2.5) * size * 0.6)
    
    if obj.ArrowOutline then
        SafeSet(obj.ArrowOutline, "PointA", p1)
        SafeSet(obj.ArrowOutline, "PointB", p2)
        SafeSet(obj.ArrowOutline, "PointC", p3)
        SafeSet(obj.ArrowOutline, "Visible", true)
    end
    
    if obj.Arrow then
        SafeSet(obj.Arrow, "PointA", p1)
        SafeSet(obj.Arrow, "PointB", p2)
        SafeSet(obj.Arrow, "PointC", p3)
        SafeSet(obj.Arrow, "Color", color)
        SafeSet(obj.Arrow, "Visible", true)
    end
end

function ESP.Update()
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    
    -- Update MM2 roles
    if ESP.Settings.UseRoleColors then
        ESP.UpdateMM2Roles()
    end
    
    for plr, obj in pairs(ESP.Objects) do
        -- Skip conditions
        if not ESP.Settings.Enabled or plr == LocalPlayer or not IsAlive(plr) then
            ESP.HideAll(obj)
            if not IsAlive(plr) then ESP.RemoveChams(plr) end
            ESP.HideChams(plr)
            continue
        end
        
        if ESP.Settings.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            ESP.HideAll(obj)
            ESP.HideChams(plr)
            continue
        end
        
        local char = plr.Character
        if not char then 
            ESP.HideAll(obj)
            ESP.HideChams(plr)
            continue 
        end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if not root or not head or not hum then 
            ESP.HideAll(obj)
            ESP.HideChams(plr)
            continue 
        end
        
        local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        
        -- Distance check
        if dist > ESP.Settings.MaxDistance then
            ESP.HideAll(obj)
            ESP.HideChams(plr)
            continue
        end
        
        local espColor = ESP.GetColor(plr)
        
        -- Off screen - hide everything except arrow
        if not onScreen then
            ESP.HideAll(obj)
            ESP.HideChams(plr)
            
            if ESP.Settings.OffScreenArrows.Enabled then
                ESP.DrawArrow(obj, rootPos, ESP.Settings.OffScreenArrows.Color, ESP.Settings.OffScreenArrows.Size)
            end
            continue
        end
        
        -- On screen - hide arrow
        SafeSet(obj.Arrow, "Visible", false)
        SafeSet(obj.ArrowOutline, "Visible", false)
        
        -- Calculate box dimensions
        local headTop = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local footBottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        
        local boxH = math.abs(footBottom.Y - headTop.Y)
        local boxW = boxH * 0.5
        local boxX = rootPos.X - boxW / 2
        local boxY = headTop.Y
        
        -- Corner Box
        if ESP.Settings.CornerBox.Enabled then
            SafeSet(obj.Box, "Visible", false)
            SafeSet(obj.BoxOutline, "Visible", false)
            
            ESP.DrawCornerBox(obj, boxX, boxY, boxW, boxH,
                espColor,
                ESP.Settings.CornerBox.Thickness,
                ESP.Settings.CornerBox.Length,
                ESP.Settings.CornerBox.Outline
            )
        -- Regular Box
        elseif ESP.Settings.Box.Enabled then
            -- Hide corners
            SafeSet(obj.CornerTL1, "Visible", false)
            SafeSet(obj.CornerTL2, "Visible", false)
            SafeSet(obj.CornerTR1, "Visible", false)
            SafeSet(obj.CornerTR2, "Visible", false)
            SafeSet(obj.CornerBL1, "Visible", false)
            SafeSet(obj.CornerBL2, "Visible", false)
            SafeSet(obj.CornerBR1, "Visible", false)
            SafeSet(obj.CornerBR2, "Visible", false)
            SafeSet(obj.CornerTL1_O, "Visible", false)
            SafeSet(obj.CornerTL2_O, "Visible", false)
            SafeSet(obj.CornerTR1_O, "Visible", false)
            SafeSet(obj.CornerTR2_O, "Visible", false)
            SafeSet(obj.CornerBL1_O, "Visible", false)
            SafeSet(obj.CornerBL2_O, "Visible", false)
            SafeSet(obj.CornerBR1_O, "Visible", false)
            SafeSet(obj.CornerBR2_O, "Visible", false)
            
            if ESP.Settings.Box.Outline then
                SafeSet(obj.BoxOutline, "Size", Vector2.new(boxW, boxH))
                SafeSet(obj.BoxOutline, "Position", Vector2.new(boxX, boxY))
                SafeSet(obj.BoxOutline, "Visible", true)
            else
                SafeSet(obj.BoxOutline, "Visible", false)
            end
            
            SafeSet(obj.Box, "Size", Vector2.new(boxW, boxH))
            SafeSet(obj.Box, "Position", Vector2.new(boxX, boxY))
            SafeSet(obj.Box, "Color", espColor)
            SafeSet(obj.Box, "Thickness", ESP.Settings.Box.Thickness)
            SafeSet(obj.Box, "Visible", true)
        else
            SafeSet(obj.Box, "Visible", false)
            SafeSet(obj.BoxOutline, "Visible", false)
            SafeSet(obj.CornerTL1, "Visible", false)
            SafeSet(obj.CornerTL2, "Visible", false)
            SafeSet(obj.CornerTR1, "Visible", false)
            SafeSet(obj.CornerTR2, "Visible", false)
            SafeSet(obj.CornerBL1, "Visible", false)
            SafeSet(obj.CornerBL2, "Visible", false)
            SafeSet(obj.CornerBR1, "Visible", false)
            SafeSet(obj.CornerBR2, "Visible", false)
            SafeSet(obj.CornerTL1_O, "Visible", false)
            SafeSet(obj.CornerTL2_O, "Visible", false)
            SafeSet(obj.CornerTR1_O, "Visible", false)
            SafeSet(obj.CornerTR2_O, "Visible", false)
            SafeSet(obj.CornerBL1_O, "Visible", false)
            SafeSet(obj.CornerBL2_O, "Visible", false)
            SafeSet(obj.CornerBR1_O, "Visible", false)
            SafeSet(obj.CornerBR2_O, "Visible", false)
        end
        
        -- Name
        if ESP.Settings.Name.Enabled then
            local nameText = plr.DisplayName or plr.Name
            
            -- Add role to name for MM2
            if ESP.Settings.UseRoleColors then
                local role = ESP.GetMM2Role(plr)
                if role ~= "Innocent" then
                    nameText = "[" .. role .. "] " .. nameText
                end
            end
            
            if ESP.Settings.Name.ShowDistance then
                nameText = nameText .. " [" .. math.floor(dist) .. "m]"
            end
            
            SafeSet(obj.Name, "Text", nameText)
            SafeSet(obj.Name, "Position", Vector2.new(boxX + boxW / 2, boxY - 16))
            SafeSet(obj.Name, "Color", espColor)
            SafeSet(obj.Name, "Size", ESP.Settings.Name.Size)
            SafeSet(obj.Name, "Visible", true)
        else
            SafeSet(obj.Name, "Visible", false)
        end
        
        -- Distance
        if ESP.Settings.Distance.Enabled and not ESP.Settings.Name.ShowDistance then
            SafeSet(obj.Distance, "Text", math.floor(dist) .. "m")
            SafeSet(obj.Distance, "Position", Vector2.new(boxX + boxW / 2, boxY + boxH + 2))
            SafeSet(obj.Distance, "Color", ESP.Settings.Distance.Color)
            SafeSet(obj.Distance, "Size", ESP.Settings.Distance.Size)
            SafeSet(obj.Distance, "Visible", true)
        else
            SafeSet(obj.Distance, "Visible", false)
        end
        
        -- Health Bar
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
            SafeSet(obj.HealthBar, "Color", ESP.GetHealthColor(hp))
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
        
        -- Head Dot
        if ESP.Settings.HeadDot.Enabled then
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
            SafeSet(obj.HeadDot, "Color", espColor)
            SafeSet(obj.HeadDot, "Visible", true)
        else
            SafeSet(obj.HeadDot, "Visible", false)
            SafeSet(obj.HeadDotOutline, "Visible", false)
        end
        
        -- Tracers
        if ESP.Settings.Tracers.Enabled then
            local originX = Camera.ViewportSize.X / 2
            local originY = ESP.Settings.Tracers.Origin == "Top" and 0 
                or ESP.Settings.Tracers.Origin == "Center" and Camera.ViewportSize.Y / 2 
                or Camera.ViewportSize.Y
            
            SafeSet(obj.TracerOutline, "From", Vector2.new(originX, originY))
            SafeSet(obj.TracerOutline, "To", Vector2.new(rootPos.X, footBottom.Y))
            SafeSet(obj.TracerOutline, "Visible", true)
            
            SafeSet(obj.Tracer, "From", Vector2.new(originX, originY))
            SafeSet(obj.Tracer, "To", Vector2.new(rootPos.X, footBottom.Y))
            SafeSet(obj.Tracer, "Color", espColor)
            SafeSet(obj.Tracer, "Thickness", ESP.Settings.Tracers.Thickness)
            SafeSet(obj.Tracer, "Visible", true)
        else
            SafeSet(obj.Tracer, "Visible", false)
            SafeSet(obj.TracerOutline, "Visible", false)
        end
        
        -- Skeleton
        if ESP.Settings.Skeleton.Enabled then
            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
            local connections = isR15 and SkeletonConnections.R15 or SkeletonConnections.R6
            
            for i = 1, 14 do
                local line = obj.Skeleton[i]
                if not line then continue end
                
                local conn = connections[i]
                if not conn then
                    SafeSet(line, "Visible", false)
                    continue
                end
                
                local p1 = char:FindFirstChild(conn[1])
                local p2 = char:FindFirstChild(conn[2])
                
                if p1 and p2 then
                    local v1, os1 = Camera:WorldToViewportPoint(p1.Position)
                    local v2, os2 = Camera:WorldToViewportPoint(p2.Position)
                    
                    if os1 and os2 then
                        SafeSet(line, "From", Vector2.new(v1.X, v1.Y))
                        SafeSet(line, "To", Vector2.new(v2.X, v2.Y))
                        SafeSet(line, "Color", ESP.Settings.Skeleton.Color)
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
                if obj.Skeleton[i] then
                    SafeSet(obj.Skeleton[i], "Visible", false)
                end
            end
        end
        
        -- Chams
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
                chams.FillColor = ESP.Settings.UseRoleColors and espColor or ESP.Settings.Chams.FillColor
                chams.OutlineColor = ESP.Settings.Chams.OutlineColor
                chams.FillTransparency = ESP.Settings.Chams.FillTransparency
                chams.Enabled = true
            end
        else
            ESP.HideChams(plr)
        end
    end
end

function ESP.Init()
    Camera = Workspace.CurrentCamera
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then 
            ESP.Create(plr) 
        end
    end
    
    Players.PlayerAdded:Connect(function(plr) 
        task.wait(0.1)
        ESP.Create(plr) 
    end)
    
    Players.PlayerRemoving:Connect(function(plr) 
        ESP.Remove(plr) 
    end)
    
    if ESP.Connection then
        pcall(function() ESP.Connection:Disconnect() end)
    end
    
    ESP.Connection = RunService.RenderStepped:Connect(function()
        pcall(ESP.Update)
    end)
end

function ESP.Destroy()
    if ESP.Connection then 
        pcall(function() ESP.Connection:Disconnect() end)
        ESP.Connection = nil
    end
    
    for plr in pairs(ESP.Objects) do 
        ESP.Remove(plr) 
    end
    
    for plr in pairs(ESP.Chams) do
        ESP.RemoveChams(plr)
    end
    
    ESP.Objects = {}
    ESP.Chams = {}
end

return ESP
