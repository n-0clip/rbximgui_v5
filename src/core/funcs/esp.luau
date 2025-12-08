local ESP = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

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
    return hum and hum.Health > 0
end

function ESP.GetColor(plr)
    if ESP.GetColorCallback then
        local success, color = pcall(ESP.GetColorCallback, plr)
        if success and color then
            return color
        end
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

function ESP.HideCornerBox(obj)
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

function ESP.Hide(obj)
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
    
    ESP.HideCornerBox(obj)
    
    for _, line in pairs(obj.Skeleton) do
        SafeSet(line, "Visible", false)
    end
end

function ESP.HideChams(plr)
    if ESP.Chams[plr] then
        pcall(function() ESP.Chams[plr].Enabled = false end)
    end
end

function ESP.DrawCornerBox(obj, x, y, w, h, color, thickness, length, outline)
    if outline then
        SafeSet(obj.CornerTL1_O, "From", Vector2.new(x, y))
        SafeSet(obj.CornerTL1_O, "To", Vector2.new(x + length, y))
        SafeSet(obj.CornerTL1_O, "Visible", true)
        
        SafeSet(obj.CornerTL2_O, "From", Vector2.new(x, y))
        SafeSet(obj.CornerTL2_O, "To", Vector2.new(x, y + length))
        SafeSet(obj.CornerTL2_O, "Visible", true)
        
        SafeSet(obj.CornerTR1_O, "From", Vector2.new(x + w, y))
        SafeSet(obj.CornerTR1_O, "To", Vector2.new(x + w - length, y))
        SafeSet(obj.CornerTR1_O, "Visible", true)
        
        SafeSet(obj.CornerTR2_O, "From", Vector2.new(x + w, y))
        SafeSet(obj.CornerTR2_O, "To", Vector2.new(x + w, y + length))
        SafeSet(obj.CornerTR2_O, "Visible", true)
        
        SafeSet(obj.CornerBL1_O, "From", Vector2.new(x, y + h))
        SafeSet(obj.CornerBL1_O, "To", Vector2.new(x + length, y + h))
        SafeSet(obj.CornerBL1_O, "Visible", true)
        
        SafeSet(obj.CornerBL2_O, "From", Vector2.new(x, y + h))
        SafeSet(obj.CornerBL2_O, "To", Vector2.new(x, y + h - length))
        SafeSet(obj.CornerBL2_O, "Visible", true)
        
        SafeSet(obj.CornerBR1_O, "From", Vector2.new(x + w, y + h))
        SafeSet(obj.CornerBR1_O, "To", Vector2.new(x + w - length, y + h))
        SafeSet(obj.CornerBR1_O, "Visible", true)
        
        SafeSet(obj.CornerBR2_O, "From", Vector2.new(x + w, y + h))
        SafeSet(obj.CornerBR2_O, "To", Vector2.new(x + w, y + h - length))
        SafeSet(obj.CornerBR2_O, "Visible", true)
    else
        SafeSet(obj.CornerTL1_O, "Visible", false)
        SafeSet(obj.CornerTL2_O, "Visible", false)
        SafeSet(obj.CornerTR1_O, "Visible", false)
        SafeSet(obj.CornerTR2_O, "Visible", false)
        SafeSet(obj.CornerBL1_O, "Visible", false)
        SafeSet(obj.CornerBL2_O, "Visible", false)
        SafeSet(obj.CornerBR1_O, "Visible", false)
        SafeSet(obj.CornerBR2_O, "Visible", false)
    end
    
    SafeSet(obj.CornerTL1, "From", Vector2.new(x, y))
    SafeSet(obj.CornerTL1, "To", Vector2.new(x + length, y))
    SafeSet(obj.CornerTL1, "Color", color)
    SafeSet(obj.CornerTL1, "Thickness", thickness)
    SafeSet(obj.CornerTL1, "Visible", true)
    
    SafeSet(obj.CornerTL2, "From", Vector2.new(x, y))
    SafeSet(obj.CornerTL2, "To", Vector2.new(x, y + length))
    SafeSet(obj.CornerTL2, "Color", color)
    SafeSet(obj.CornerTL2, "Thickness", thickness)
    SafeSet(obj.CornerTL2, "Visible", true)
    
    SafeSet(obj.CornerTR1, "From", Vector2.new(x + w, y))
    SafeSet(obj.CornerTR1, "To", Vector2.new(x + w - length, y))
    SafeSet(obj.CornerTR1, "Color", color)
    SafeSet(obj.CornerTR1, "Thickness", thickness)
    SafeSet(obj.CornerTR1, "Visible", true)
    
    SafeSet(obj.CornerTR2, "From", Vector2.new(x + w, y))
    SafeSet(obj.CornerTR2, "To", Vector2.new(x + w, y + length))
    SafeSet(obj.CornerTR2, "Color", color)
    SafeSet(obj.CornerTR2, "Thickness", thickness)
    SafeSet(obj.CornerTR2, "Visible", true)
    
    SafeSet(obj.CornerBL1, "From", Vector2.new(x, y + h))
    SafeSet(obj.CornerBL1, "To", Vector2.new(x + length, y + h))
    SafeSet(obj.CornerBL1, "Color", color)
    SafeSet(obj.CornerBL1, "Thickness", thickness)
    SafeSet(obj.CornerBL1, "Visible", true)
    
    SafeSet(obj.CornerBL2, "From", Vector2.new(x, y + h))
    SafeSet(obj.CornerBL2, "To", Vector2.new(x, y + h - length))
    SafeSet(obj.CornerBL2, "Color", color)
    SafeSet(obj.CornerBL2, "Thickness", thickness)
    SafeSet(obj.CornerBL2, "Visible", true)
    
    SafeSet(obj.CornerBR1, "From", Vector2.new(x + w, y + h))
    SafeSet(obj.CornerBR1, "To", Vector2.new(x + w - length, y + h))
    SafeSet(obj.CornerBR1, "Color", color)
    SafeSet(obj.CornerBR1, "Thickness", thickness)
    SafeSet(obj.CornerBR1, "Visible", true)
    
    SafeSet(obj.CornerBR2, "From", Vector2.new(x + w, y + h))
    SafeSet(obj.CornerBR2, "To", Vector2.new(x + w, y + h - length))
    SafeSet(obj.CornerBR2, "Color", color)
    SafeSet(obj.CornerBR2, "Thickness", thickness)
    SafeSet(obj.CornerBR2, "Visible", true)
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
        obj.ArrowOutline.PointA = p1
        obj.ArrowOutline.PointB = p2
        obj.ArrowOutline.PointC = p3
        obj.ArrowOutline.Visible = true
    end
    
    if obj.Arrow then
        obj.Arrow.PointA = p1
        obj.Arrow.PointB = p2
        obj.Arrow.PointC = p3
        obj.Arrow.Color = color
        obj.Arrow.Visible = true
    end
end

function ESP.Update()
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    
    for plr, obj in pairs(ESP.Objects) do
        local shouldHide = false
        local isDead = false
        
        if not ESP.Settings.Enabled then
            shouldHide = true
        elseif plr == LocalPlayer then
            shouldHide = true
        elseif not IsAlive(plr) then
            shouldHide = true
            isDead = true
        elseif ESP.Settings.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            shouldHide = true
        end
        
        if isDead then
            ESP.RemoveChams(plr)
        end
        
        if shouldHide then
            ESP.Hide(obj)
            ESP.HideChams(plr)
            continue
        end
        
        local char = plr.Character
        if not char then 
            ESP.Hide(obj)
            ESP.HideChams(plr)
            continue 
        end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if not root or not head or not hum then 
            ESP.Hide(obj)
            ESP.HideChams(plr)
            continue 
        end
        
        local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        
        if dist > ESP.Settings.MaxDistance then
            ESP.Hide(obj)
            ESP.HideChams(plr)
            continue
        end
        
        local espColor = ESP.GetColor(plr)
        
        if not onScreen then
            ESP.Hide(obj)
            
            if ESP.Settings.OffScreenArrows.Enabled then
                ESP.DrawArrow(obj, rootPos, ESP.Settings.OffScreenArrows.Color, ESP.Settings.OffScreenArrows.Size)
            end
            
            ESP.HideChams(plr)
            continue
        end
        
        SafeSet(obj.Arrow, "Visible", false)
        SafeSet(obj.ArrowOutline, "Visible", false)
        
        local headTop = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local footBottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        
        local boxH = math.abs(footBottom.Y - headTop.Y)
        local boxW = boxH * 0.5
        local boxX = rootPos.X - boxW / 2
        local boxY = headTop.Y
        
        if ESP.Settings.CornerBox.Enabled then
            SafeSet(obj.Box, "Visible", false)
            SafeSet(obj.BoxOutline, "Visible", false)
            
            ESP.DrawCornerBox(
                obj, boxX, boxY, boxW, boxH,
                ESP.Settings.CornerBox.Color,
                ESP.Settings.CornerBox.Thickness,
                ESP.Settings.CornerBox.Length,
                ESP.Settings.CornerBox.Outline
            )
        elseif ESP.Settings.Box.Enabled then
            ESP.HideCornerBox(obj)
            
            if ESP.Settings.Box.Outline and obj.BoxOutline then
                obj.BoxOutline.Size = Vector2.new(boxW, boxH)
                obj.BoxOutline.Position = Vector2.new(boxX, boxY)
                obj.BoxOutline.Visible = true
            else
                SafeSet(obj.BoxOutline, "Visible", false)
            end
            
            if obj.Box then
                obj.Box.Size = Vector2.new(boxW, boxH)
                obj.Box.Position = Vector2.new(boxX, boxY)
                obj.Box.Color = espColor
                obj.Box.Thickness = ESP.Settings.Box.Thickness
                obj.Box.Visible = true
            end
        else
            SafeSet(obj.Box, "Visible", false)
            SafeSet(obj.BoxOutline, "Visible", false)
            ESP.HideCornerBox(obj)
        end
        
        if ESP.Settings.Name.Enabled and obj.Name then
            local nameText = plr.DisplayName or plr.Name
            if ESP.Settings.Name.ShowDistance then
                nameText = nameText .. " [" .. math.floor(dist) .. "m]"
            end
            
            obj.Name.Text = nameText
            obj.Name.Position = Vector2.new(boxX + boxW / 2, boxY - 16)
            obj.Name.Color = ESP.Settings.Name.Color
            obj.Name.Size = ESP.Settings.Name.Size
            obj.Name.Visible = true
        else
            SafeSet(obj.Name, "Visible", false)
        end
        
        if ESP.Settings.Distance.Enabled and not ESP.Settings.Name.ShowDistance and obj.Distance then
            obj.Distance.Text = math.floor(dist) .. "m"
            obj.Distance.Position = Vector2.new(boxX + boxW / 2, boxY + boxH + 2)
            obj.Distance.Color = ESP.Settings.Distance.Color
            obj.Distance.Size = ESP.Settings.Distance.Size
            obj.Distance.Visible = true
        else
            SafeSet(obj.Distance, "Visible", false)
        end
        
        if ESP.Settings.Health.Enabled then
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barW = 4
            local barX = ESP.Settings.Health.Position == "Left" and (boxX - 7) or (boxX + boxW + 3)
            
            if obj.HealthBarBg then
                obj.HealthBarBg.Size = Vector2.new(barW, boxH)
                obj.HealthBarBg.Position = Vector2.new(barX, boxY)
                obj.HealthBarBg.Visible = true
            end
            
            local healthH = boxH * hp
            if obj.HealthBar then
                obj.HealthBar.Size = Vector2.new(barW - 2, healthH)
                obj.HealthBar.Position = Vector2.new(barX + 1, boxY + boxH - healthH)
                obj.HealthBar.Color = ESP.GetHealthColor(hp)
                obj.HealthBar.Visible = true
            end
            
            if ESP.Settings.Health.Outline and obj.HealthBarOutline then
                obj.HealthBarOutline.Size = Vector2.new(barW, boxH)
                obj.HealthBarOutline.Position = Vector2.new(barX, boxY)
                obj.HealthBarOutline.Visible = true
            else
                SafeSet(obj.HealthBarOutline, "Visible", false)
            end
        else
            SafeSet(obj.HealthBar, "Visible", false)
            SafeSet(obj.HealthBarBg, "Visible", false)
            SafeSet(obj.HealthBarOutline, "Visible", false)
        end
        
        if ESP.Settings.HeadDot.Enabled then
            local headScreen = Camera:WorldToViewportPoint(head.Position)
            
            if ESP.Settings.HeadDot.Outline and obj.HeadDotOutline then
                obj.HeadDotOutline.Position = Vector2.new(headScreen.X, headScreen.Y)
                obj.HeadDotOutline.Radius = ESP.Settings.HeadDot.Size + 1
                obj.HeadDotOutline.Visible = true
            else
                SafeSet(obj.HeadDotOutline, "Visible", false)
            end
            
            if obj.HeadDot then
                obj.HeadDot.Position = Vector2.new(headScreen.X, headScreen.Y)
                obj.HeadDot.Radius = ESP.Settings.HeadDot.Size
                obj.HeadDot.Color = ESP.Settings.HeadDot.Color
                obj.HeadDot.Visible = true
            end
        else
            SafeSet(obj.HeadDot, "Visible", false)
            SafeSet(obj.HeadDotOutline, "Visible", false)
        end
        
        if ESP.Settings.Tracers.Enabled then
            local originX = Camera.ViewportSize.X / 2
            local originY = ESP.Settings.Tracers.Origin == "Top" and 0 
                or ESP.Settings.Tracers.Origin == "Center" and Camera.ViewportSize.Y / 2 
                or Camera.ViewportSize.Y
            
            if obj.TracerOutline then
                obj.TracerOutline.From = Vector2.new(originX, originY)
                obj.TracerOutline.To = Vector2.new(rootPos.X, footBottom.Y)
                obj.TracerOutline.Visible = true
            end
            
            if obj.Tracer then
                obj.Tracer.From = Vector2.new(originX, originY)
                obj.Tracer.To = Vector2.new(rootPos.X, footBottom.Y)
                obj.Tracer.Color = ESP.Settings.Tracers.Color
                obj.Tracer.Thickness = ESP.Settings.Tracers.Thickness
                obj.Tracer.Visible = true
            end
        else
            SafeSet(obj.Tracer, "Visible", false)
            SafeSet(obj.TracerOutline, "Visible", false)
        end
        
        if ESP.Settings.Skeleton.Enabled then
            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
            local connections = isR15 and SkeletonConnections.R15 or SkeletonConnections.R6
            
            for i = 1, 14 do
                local line = obj.Skeleton[i]
                if not line then continue end
                
                local conn = connections[i]
                if not conn then
                    line.Visible = false
                    continue
                end
                
                local p1 = char:FindFirstChild(conn[1])
                local p2 = char:FindFirstChild(conn[2])
                
                if p1 and p2 then
                    local v1, os1 = Camera:WorldToViewportPoint(p1.Position)
                    local v2, os2 = Camera:WorldToViewportPoint(p2.Position)
                    
                    if os1 and os2 then
                        line.From = Vector2.new(v1.X, v1.Y)
                        line.To = Vector2.new(v2.X, v2.Y)
                        line.Color = ESP.Settings.Skeleton.Color
                        line.Thickness = ESP.Settings.Skeleton.Thickness
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        else
            for i = 1, 14 do
                local line = obj.Skeleton[i]
                if line then line.Visible = false end
            end
        end
        
        if ESP.Settings.Chams.Enabled then
            if not ESP.Chams[plr] then
                local hl = Instance.new("Highlight")
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Adornee = char
                
                pcall(function() hl.Parent = CoreGui end)
                if not hl.Parent then
                    pcall(function() hl.Parent = game:GetService("Lighting") end)
                end
                
                ESP.Chams[plr] = hl
            end
            
            local chams = ESP.Chams[plr]
            if chams then
                if chams.Adornee ~= char then
                    chams.Adornee = char
                end
                chams.FillColor = ESP.Settings.Chams.FillColor
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
