local ESP = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

ESP.Settings = {
    Enabled = false,
    TeamCheck = true,
    MaxDistance = 2000,
    
    Box = { 
        Enabled = true, 
        Color = Color3.fromRGB(255, 255, 255), 
        Thickness = 1.5, 
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0)
    },
    
    CornerBox = { 
        Enabled = false, 
        Color = Color3.fromRGB(255, 255, 255), 
        Thickness = 1.5, 
        Length = 8,
        Outline = true
    },
    
    Name = { 
        Enabled = true, 
        Color = Color3.fromRGB(255, 255, 255), 
        Size = 13, 
        ShowDistance = false,
        Font = 2,
        Outline = true
    },
    
    Health = { 
        Enabled = true, 
        Position = "Left",
        Width = 2,
        Outline = true,
        Gradient = true
    },
    
    Distance = { 
        Enabled = false, 
        Color = Color3.fromRGB(200, 200, 200), 
        Size = 11 
    },
    
    Skeleton = { 
        Enabled = false, 
        Color = Color3.fromRGB(255, 255, 255), 
        Thickness = 1.5 
    },
    
    Chams = { 
        Enabled = false, 
        FillColor = Color3.fromRGB(255, 0, 128), 
        OutlineColor = Color3.fromRGB(255, 255, 255), 
        FillTransparency = 0.5,
        OutlineTransparency = 0
    },
    
    Tracers = { 
        Enabled = false, 
        Color = Color3.fromRGB(255, 255, 255), 
        Thickness = 1.5, 
        Origin = "Bottom" 
    },
    
    HeadDot = { 
        Enabled = false, 
        Color = Color3.fromRGB(255, 0, 0), 
        Size = 3, 
        Filled = true,
        Outline = true
    },
    
    Weapon = {
        Enabled = false,
        Color = Color3.fromRGB(255, 200, 100),
        Size = 11
    },
    
    VisibleCheck = false,
    VisibleColor = Color3.fromRGB(0, 255, 0),
    InvisibleColor = Color3.fromRGB(255, 0, 0),
    
    UseRoleColors = false,
    
    Rainbow = { Enabled = false, Speed = 1 }
}

ESP.Objects = {}
ESP.Chams = {}
ESP.Connection = nil
ESP.RainbowHue = 0
ESP.GetColorCallback = nil

local SkeletonR15 = {
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
}

local SkeletonR6 = {
    {"Head", "Torso"}, 
    {"Torso", "Left Arm"}, 
    {"Torso", "Right Arm"}, 
    {"Torso", "Left Leg"}, 
    {"Torso", "Right Leg"}
}

local function NewDrawing(class, props)
    local success, drawing = pcall(function()
        return Drawing.new(class)
    end)
    
    if not success or not drawing then 
        return { 
            Visible = false, 
            Remove = function() end,
            Destroy = function() end
        } 
    end
    
    for key, value in pairs(props or {}) do 
        pcall(function() 
            drawing[key] = value 
        end) 
    end
    
    return drawing
end

local function IsAlive(plr)
    if not plr then return false end
    if typeof(plr) ~= "Instance" then return false end
    
    local char = plr.Character
    if not char then return false end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    return humanoid.Health > 0
end

local function IsVisible(part)
    if not part then return false end
    
    Camera = Workspace.CurrentCamera
    if not Camera then return true end
    
    local localChar = LocalPlayer.Character
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {localChar, Camera}
    params.IgnoreWater = true
    
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    
    local result = Workspace:Raycast(origin, direction, params)
    
    if not result then return true end
    
    if result.Instance and part.Parent then
        return result.Instance:IsDescendantOf(part.Parent)
    end
    
    return false
end

local function GetWeaponName(player)
    if not player then return nil end
    
    local char = player.Character
    if not char then return nil end
    
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("Tool") then
            return child.Name
        end
    end
    
    return nil
end

function ESP.GetRainbowColor()
    ESP.RainbowHue = (ESP.RainbowHue + ESP.Settings.Rainbow.Speed / 360) % 1
    return Color3.fromHSV(ESP.RainbowHue, 1, 1)
end

function ESP.GetColor(plr, part)
    if ESP.Settings.Rainbow.Enabled then
        return ESP.GetRainbowColor()
    end
    
    if ESP.GetColorCallback then
        local success, color = pcall(function()
            return ESP.GetColorCallback(plr)
        end)
        if success and color then
            return color
        end
    end
    
    if ESP.Settings.VisibleCheck and part then
        if IsVisible(part) then
            return ESP.Settings.VisibleColor
        else
            return ESP.Settings.InvisibleColor
        end
    end
    
    return ESP.Settings.Box.Color
end

function ESP.GetHealthColor(healthPercent)
    if ESP.Settings.Health.Gradient then
        local r = math.floor(255 * (1 - healthPercent))
        local g = math.floor(255 * healthPercent)
        return Color3.fromRGB(r, g, 0)
    end
    return Color3.fromRGB(0, 255, 0)
end

function ESP.Create(plr)
    if not plr then return end
    if ESP.Objects[plr] then return end
    
    local obj = {
        Box = NewDrawing("Square", { Thickness = 1.5, Filled = false }),
        BoxOutline = NewDrawing("Square", { Thickness = 3, Filled = false, Color = Color3.new(0, 0, 0) }),
        
        CornerTL = NewDrawing("Line", { Thickness = 1.5 }),
        CornerTL2 = NewDrawing("Line", { Thickness = 1.5 }),
        CornerTLO = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) }),
        CornerTL2O = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) }),
        
        CornerTR = NewDrawing("Line", { Thickness = 1.5 }),
        CornerTR2 = NewDrawing("Line", { Thickness = 1.5 }),
        CornerTRO = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) }),
        CornerTR2O = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) }),
        
        CornerBL = NewDrawing("Line", { Thickness = 1.5 }),
        CornerBL2 = NewDrawing("Line", { Thickness = 1.5 }),
        CornerBLO = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) }),
        CornerBL2O = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) }),
        
        CornerBR = NewDrawing("Line", { Thickness = 1.5 }),
        CornerBR2 = NewDrawing("Line", { Thickness = 1.5 }),
        CornerBRO = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) }),
        CornerBR2O = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) }),
        
        Name = NewDrawing("Text", { Size = 13, Center = true, Outline = true, Font = 2 }),
        Distance = NewDrawing("Text", { Size = 11, Center = true, Outline = true, Font = 2 }),
        Weapon = NewDrawing("Text", { Size = 11, Center = true, Outline = true, Font = 2 }),
        
        HealthBar = NewDrawing("Square", { Filled = true }),
        HealthBarBg = NewDrawing("Square", { Filled = true, Color = Color3.fromRGB(30, 30, 30) }),
        HealthBarOutline = NewDrawing("Square", { Filled = false, Color = Color3.new(0, 0, 0), Thickness = 1 }),
        HealthText = NewDrawing("Text", { Size = 10, Center = true, Outline = true, Font = 2 }),
        
        Tracer = NewDrawing("Line", { Thickness = 1.5 }),
        TracerOutline = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) }),
        
        HeadDot = NewDrawing("Circle", { Filled = true }),
        HeadDotOutline = NewDrawing("Circle", { Filled = false, Color = Color3.new(0, 0, 0), Thickness = 2 }),
        
        Skeleton = {},
        SkeletonOutline = {}
    }
    
    for i = 1, 14 do
        obj.Skeleton[i] = NewDrawing("Line", { Thickness = 1.5 })
        obj.SkeletonOutline[i] = NewDrawing("Line", { Thickness = 3, Color = Color3.new(0, 0, 0) })
    end
    
    ESP.Objects[plr] = obj
end

function ESP.Remove(plr)
    local obj = ESP.Objects[plr]
    if obj then
        for key, value in pairs(obj) do
            if type(value) == "table" then
                if value.Remove then
                    pcall(function() value:Remove() end)
                else
                    for _, item in pairs(value) do
                        pcall(function() item:Remove() end)
                    end
                end
            end
        end
        ESP.Objects[plr] = nil
    end
    
    if ESP.Chams[plr] then
        pcall(function() ESP.Chams[plr]:Destroy() end)
        ESP.Chams[plr] = nil
    end
end

function ESP.Hide(obj)
    if not obj then return end
    
    for key, value in pairs(obj) do
        if type(value) == "table" then
            if value.Visible ~= nil then
                pcall(function() value.Visible = false end)
            else
                for _, item in pairs(value) do
                    pcall(function() item.Visible = false end)
                end
            end
        end
    end
end

function ESP.UpdateCornerBox(obj, x, y, w, h, color, thickness, length)
    local corners = {
        {obj.CornerTL, obj.CornerTLO, Vector2.new(x, y), Vector2.new(x + length, y)},
        {obj.CornerTL2, obj.CornerTL2O, Vector2.new(x, y), Vector2.new(x, y + length)},
        {obj.CornerTR, obj.CornerTRO, Vector2.new(x + w, y), Vector2.new(x + w - length, y)},
        {obj.CornerTR2, obj.CornerTR2O, Vector2.new(x + w, y), Vector2.new(x + w, y + length)},
        {obj.CornerBL, obj.CornerBLO, Vector2.new(x, y + h), Vector2.new(x + length, y + h)},
        {obj.CornerBL2, obj.CornerBL2O, Vector2.new(x, y + h), Vector2.new(x, y + h - length)},
        {obj.CornerBR, obj.CornerBRO, Vector2.new(x + w, y + h), Vector2.new(x + w - length, y + h)},
        {obj.CornerBR2, obj.CornerBR2O, Vector2.new(x + w, y + h), Vector2.new(x + w, y + h - length)},
    }
    
    for _, corner in ipairs(corners) do
        local line, outline, from, to = corner[1], corner[2], corner[3], corner[4]
        
        if ESP.Settings.CornerBox.Outline and outline then
            outline.From = from
            outline.To = to
            outline.Visible = true
        elseif outline then
            outline.Visible = false
        end
        
        line.From = from
        line.To = to
        line.Color = color
        line.Thickness = thickness
        line.Visible = true
    end
end

function ESP.HideCornerBox(obj)
    local corners = {
        obj.CornerTL, obj.CornerTL2, obj.CornerTLO, obj.CornerTL2O,
        obj.CornerTR, obj.CornerTR2, obj.CornerTRO, obj.CornerTR2O,
        obj.CornerBL, obj.CornerBL2, obj.CornerBLO, obj.CornerBL2O,
        obj.CornerBR, obj.CornerBR2, obj.CornerBRO, obj.CornerBR2O,
    }
    
    for _, corner in ipairs(corners) do
        if corner then
            pcall(function() corner.Visible = false end)
        end
    end
end

function ESP.Update()
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    
    for plr, obj in pairs(ESP.Objects) do
        if not ESP.Settings.Enabled then
            ESP.Hide(obj)
            if ESP.Chams[plr] then 
                pcall(function() ESP.Chams[plr].Enabled = false end) 
            end
            continue
        end
        
        if not IsAlive(plr) or plr == LocalPlayer then
            ESP.Hide(obj)
            if ESP.Chams[plr] then 
                pcall(function() ESP.Chams[plr].Enabled = false end) 
            end
            continue
        end
        
        if ESP.Settings.TeamCheck then
            if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                ESP.Hide(obj)
                if ESP.Chams[plr] then 
                    pcall(function() ESP.Chams[plr].Enabled = false end) 
                end
                continue
            end
        end
        
        local char = plr.Character
        if not char then 
            ESP.Hide(obj) 
            continue 
        end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if not root or not head or not humanoid then 
            ESP.Hide(obj) 
            continue 
        end
        
        local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        
        if not onScreen or dist > ESP.Settings.MaxDistance then
            ESP.Hide(obj)
            if ESP.Chams[plr] then 
                pcall(function() ESP.Chams[plr].Enabled = false end) 
            end
            continue
        end
        
        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local footPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        
        local boxHeight = math.abs(footPos.Y - headPos.Y)
        local boxWidth = boxHeight * 0.55
        local boxX = rootPos.X - boxWidth / 2
        local boxY = headPos.Y
        
        local espColor = ESP.GetColor(plr, head)
        
        if ESP.Settings.Box.Enabled and not ESP.Settings.CornerBox.Enabled then
            if ESP.Settings.Box.Outline then
                obj.BoxOutline.Size = Vector2.new(boxWidth, boxHeight)
                obj.BoxOutline.Position = Vector2.new(boxX, boxY)
                obj.BoxOutline.Color = ESP.Settings.Box.OutlineColor
                obj.BoxOutline.Visible = true
            else
                obj.BoxOutline.Visible = false
            end
            
            obj.Box.Size = Vector2.new(boxWidth, boxHeight)
            obj.Box.Position = Vector2.new(boxX, boxY)
            obj.Box.Color = espColor
            obj.Box.Thickness = ESP.Settings.Box.Thickness
            obj.Box.Visible = true
        else
            obj.Box.Visible = false
            obj.BoxOutline.Visible = false
        end
        
        if ESP.Settings.CornerBox.Enabled then
            ESP.UpdateCornerBox(
                obj, 
                boxX, boxY, boxWidth, boxHeight,
                ESP.Settings.CornerBox.Color,
                ESP.Settings.CornerBox.Thickness,
                ESP.Settings.CornerBox.Length
            )
            obj.Box.Visible = false
            obj.BoxOutline.Visible = false
        else
            ESP.HideCornerBox(obj)
        end
        
        if ESP.Settings.Name.Enabled then
            local nameText = plr.DisplayName or plr.Name
            if ESP.Settings.Name.ShowDistance then
                nameText = nameText .. " [" .. math.floor(dist) .. "m]"
            end
            
            obj.Name.Text = nameText
            obj.Name.Position = Vector2.new(boxX + boxWidth / 2, boxY - ESP.Settings.Name.Size - 4)
            obj.Name.Color = ESP.Settings.Name.Color
            obj.Name.Size = ESP.Settings.Name.Size
            obj.Name.Font = ESP.Settings.Name.Font
            obj.Name.Outline = ESP.Settings.Name.Outline
            obj.Name.Visible = true
        else
            obj.Name.Visible = false
        end
        
        if ESP.Settings.Distance.Enabled and not ESP.Settings.Name.ShowDistance then
            obj.Distance.Text = math.floor(dist) .. "m"
            obj.Distance.Position = Vector2.new(boxX + boxWidth / 2, boxY + boxHeight + 2)
            obj.Distance.Color = ESP.Settings.Distance.Color
            obj.Distance.Size = ESP.Settings.Distance.Size
            obj.Distance.Visible = true
        else
            obj.Distance.Visible = false
        end
        
        if ESP.Settings.Weapon.Enabled then
            local weaponName = GetWeaponName(plr)
            if weaponName then
                local yOffset = ESP.Settings.Distance.Enabled and 14 or 2
                obj.Weapon.Text = "[" .. weaponName .. "]"
                obj.Weapon.Position = Vector2.new(boxX + boxWidth / 2, boxY + boxHeight + yOffset)
                obj.Weapon.Color = ESP.Settings.Weapon.Color
                obj.Weapon.Size = ESP.Settings.Weapon.Size
                obj.Weapon.Visible = true
            else
                obj.Weapon.Visible = false
            end
        else
            obj.Weapon.Visible = false
        end
        
        if ESP.Settings.Health.Enabled then
            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            local barWidth = ESP.Settings.Health.Width + 2
            local barHeight = boxHeight
            local barX
            
            if ESP.Settings.Health.Position == "Left" then
                barX = boxX - barWidth - 3
            else
                barX = boxX + boxWidth + 3
            end
            
            obj.HealthBarBg.Size = Vector2.new(barWidth, barHeight)
            obj.HealthBarBg.Position = Vector2.new(barX, boxY)
            obj.HealthBarBg.Visible = true
            
            local healthBarHeight = barHeight * healthPercent
            obj.HealthBar.Size = Vector2.new(barWidth - 2, healthBarHeight)
            obj.HealthBar.Position = Vector2.new(barX + 1, boxY + barHeight - healthBarHeight)
            obj.HealthBar.Color = ESP.GetHealthColor(healthPercent)
            obj.HealthBar.Visible = true
            
            if ESP.Settings.Health.Outline then
                obj.HealthBarOutline.Size = Vector2.new(barWidth, barHeight)
                obj.HealthBarOutline.Position = Vector2.new(barX, boxY)
                obj.HealthBarOutline.Visible = true
            else
                obj.HealthBarOutline.Visible = false
            end
        else
            obj.HealthBar.Visible = false
            obj.HealthBarBg.Visible = false
            obj.HealthBarOutline.Visible = false
        end
        
        if ESP.Settings.Tracers.Enabled then
            local originX = Camera.ViewportSize.X / 2
            local originY
            
            if ESP.Settings.Tracers.Origin == "Bottom" then
                originY = Camera.ViewportSize.Y
            elseif ESP.Settings.Tracers.Origin == "Top" then
                originY = 0
            elseif ESP.Settings.Tracers.Origin == "Center" then
                originY = Camera.ViewportSize.Y / 2
            else
                originY = Camera.ViewportSize.Y
            end
            
            obj.TracerOutline.From = Vector2.new(originX, originY)
            obj.TracerOutline.To = Vector2.new(rootPos.X, rootPos.Y)
            obj.TracerOutline.Visible = true
            
            obj.Tracer.From = Vector2.new(originX, originY)
            obj.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            obj.Tracer.Color = ESP.Settings.Tracers.Color
            obj.Tracer.Thickness = ESP.Settings.Tracers.Thickness
            obj.Tracer.Visible = true
        else
            obj.Tracer.Visible = false
            obj.TracerOutline.Visible = false
        end
        
        if ESP.Settings.HeadDot.Enabled then
            local headScreen = Camera:WorldToViewportPoint(head.Position)
            
            if ESP.Settings.HeadDot.Outline then
                obj.HeadDotOutline.Position = Vector2.new(headScreen.X, headScreen.Y)
                obj.HeadDotOutline.Radius = ESP.Settings.HeadDot.Size + 1
                obj.HeadDotOutline.Visible = true
            else
                obj.HeadDotOutline.Visible = false
            end
            
            obj.HeadDot.Position = Vector2.new(headScreen.X, headScreen.Y)
            obj.HeadDot.Radius = ESP.Settings.HeadDot.Size
            obj.HeadDot.Color = ESP.Settings.HeadDot.Color
            obj.HeadDot.Filled = ESP.Settings.HeadDot.Filled
            obj.HeadDot.Visible = true
        else
            obj.HeadDot.Visible = false
            obj.HeadDotOutline.Visible = false
        end
        
        if ESP.Settings.Skeleton.Enabled then
            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
            local connections = isR15 and SkeletonR15 or SkeletonR6
            
            for i, conn in ipairs(connections) do
                local line = obj.Skeleton[i]
                local outline = obj.SkeletonOutline[i]
                
                if line then
                    local part1 = char:FindFirstChild(conn[1])
                    local part2 = char:FindFirstChild(conn[2])
                    
                    if part1 and part2 then
                        local pos1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
                        local pos2, onScreen2 = Camera:WorldToViewportPoint(part2.Position)
                        
                        if onScreen1 and onScreen2 then
                            if outline then
                                outline.From = Vector2.new(pos1.X, pos1.Y)
                                outline.To = Vector2.new(pos2.X, pos2.Y)
                                outline.Visible = true
                            end
                            
                            line.From = Vector2.new(pos1.X, pos1.Y)
                            line.To = Vector2.new(pos2.X, pos2.Y)
                            line.Color = ESP.Settings.Skeleton.Color
                            line.Thickness = ESP.Settings.Skeleton.Thickness
                            line.Visible = true
                        else
                            line.Visible = false
                            if outline then outline.Visible = false end
                        end
                    else
                        line.Visible = false
                        if outline then outline.Visible = false end
                    end
                end
            end
        else
            for i, line in pairs(obj.Skeleton) do
                pcall(function() line.Visible = false end)
            end
            for i, outline in pairs(obj.SkeletonOutline) do
                pcall(function() outline.Visible = false end)
            end
        end
        
        if ESP.Settings.Chams.Enabled then
            if not ESP.Chams[plr] then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = char
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                
                pcall(function()
                    highlight.Parent = CoreGui
                end)
                
                if not highlight.Parent then
                    pcall(function()
                        highlight.Parent = game:GetService("Lighting")
                    end)
                end
                
                ESP.Chams[plr] = highlight
            end
            
            local chams = ESP.Chams[plr]
            if chams then
                chams.FillColor = ESP.Settings.Chams.FillColor
                chams.OutlineColor = ESP.Settings.Chams.OutlineColor
                chams.FillTransparency = ESP.Settings.Chams.FillTransparency
                chams.OutlineTransparency = ESP.Settings.Chams.OutlineTransparency or 0
                chams.Enabled = true
            end
        elseif ESP.Chams[plr] then
            pcall(function() ESP.Chams[plr].Enabled = false end)
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
    
    ESP.Objects = {}
    ESP.Chams = {}
end

return ESP
