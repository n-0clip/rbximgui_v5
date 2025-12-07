local ESP = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local banner = [[
 __   .__.__  .__   _____                 .___
|  | _|__|  | |  |_/ ____\____   ____   __| _/
|  |/ /  |  | |  |\   __\/ __ \_/ __ \ / __ | 
|    <|  |  |_|  |_|  | \  ___/\  ___// /_/ | 
|__|_ \__|____/____/__|  \___  >\___  >____ | 
     \/                      \/     \/     \/ 
]]

ESP.Settings = {
    Enabled = false,
    TeamCheck = true,
    MaxDistance = 2000,
    
    Box = { Enabled = true, Color = Color3.new(1, 1, 1), Thickness = 1, Outline = true },
    CornerBox = { Enabled = false, Color = Color3.new(1, 1, 1), Thickness = 1, Length = 10 },
    Name = { Enabled = true, Color = Color3.new(1, 1, 1), Size = 13, ShowDistance = false },
    Health = { Enabled = true, Position = "Left" },
    Distance = { Enabled = false, Color = Color3.new(1, 1, 1), Size = 11 },
    Skeleton = { Enabled = false, Color = Color3.new(1, 1, 1), Thickness = 1 },
    Chams = { Enabled = false, FillColor = Color3.new(1, 0, 0), OutlineColor = Color3.new(1, 1, 1), FillTransparency = 0.5 },
    Tracers = { Enabled = false, Color = Color3.new(1, 1, 1), Thickness = 1, Origin = "Bottom" },
    HeadDot = { Enabled = false, Color = Color3.new(1, 0, 0), Size = 3, Filled = true },
    
    VisibleCheck = false,
    VisibleColor = Color3.new(0, 1, 0),
    InvisibleColor = Color3.new(1, 0, 0),
    
    Rainbow = { Enabled = false, Speed = 1 }
}

ESP.Objects = {}
ESP.Chams = {}
ESP.Connection = nil
ESP.RainbowHue = 0

local SkeletonR15 = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

local SkeletonR6 = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

local function NewDrawing(class, props)
    local s, d = pcall(Drawing.new, class)
    if not s or not d then return { Visible = false, Remove = function() end } end
    for k, v in pairs(props or {}) do pcall(function() d[k] = v end) end
    return d
end

local function IsAlive(plr)
    if not plr or not plr.Character then return false end
    local h = plr.Character:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

local function IsVisible(part)
    if not part then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), params)
    if result then return result.Instance:IsDescendantOf(part.Parent) end
    return true
end

function ESP.GetRainbowColor()
    ESP.RainbowHue = (ESP.RainbowHue + ESP.Settings.Rainbow.Speed / 360) % 1
    return Color3.fromHSV(ESP.RainbowHue, 1, 1)
end

function ESP.GetColor(plr, part)
    if ESP.Settings.Rainbow.Enabled then
        return ESP.GetRainbowColor()
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

function ESP.Create(plr)
    if ESP.Objects[plr] then return end
    
    ESP.Objects[plr] = {
        Box = NewDrawing("Square", { Thickness = 1, Filled = false }),
        BoxOutline = NewDrawing("Square", { Thickness = 3, Filled = false, Color = Color3.new(0, 0, 0) }),
        
        CornerTL = NewDrawing("Line", { Thickness = 1 }),
        CornerTL2 = NewDrawing("Line", { Thickness = 1 }),
        CornerTR = NewDrawing("Line", { Thickness = 1 }),
        CornerTR2 = NewDrawing("Line", { Thickness = 1 }),
        CornerBL = NewDrawing("Line", { Thickness = 1 }),
        CornerBL2 = NewDrawing("Line", { Thickness = 1 }),
        CornerBR = NewDrawing("Line", { Thickness = 1 }),
        CornerBR2 = NewDrawing("Line", { Thickness = 1 }),
        
        Name = NewDrawing("Text", { Size = 13, Center = true, Outline = true, Font = 2 }),
        Distance = NewDrawing("Text", { Size = 11, Center = true, Outline = true, Font = 2 }),
        
        HealthBar = NewDrawing("Square", { Filled = true }),
        HealthBarBg = NewDrawing("Square", { Filled = true, Color = Color3.new(0, 0, 0) }),
        HealthBarOutline = NewDrawing("Square", { Filled = false, Color = Color3.new(0, 0, 0), Thickness = 1 }),
        HealthText = NewDrawing("Text", { Size = 10, Center = true, Outline = true, Font = 2 }),
        
        Tracer = NewDrawing("Line", { Thickness = 1 }),
        
        HeadDot = NewDrawing("Circle", { Filled = true }),
        HeadDotOutline = NewDrawing("Circle", { Filled = false, Color = Color3.new(0, 0, 0), Thickness = 1 }),
        
        Skeleton = {}
    }
    
    for i = 1, 14 do
        ESP.Objects[plr].Skeleton[i] = NewDrawing("Line", { Thickness = 1 })
    end
end

function ESP.Remove(plr)
    local obj = ESP.Objects[plr]
    if obj then
        for _, v in pairs(obj) do
            if type(v) == "table" and v.Remove then
                pcall(v.Remove, v)
            elseif type(v) == "table" then
                for _, l in pairs(v) do pcall(function() l:Remove() end) end
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
    for _, v in pairs(obj) do
        if type(v) == "table" and v.Visible ~= nil then
            pcall(function() v.Visible = false end)
        elseif type(v) == "table" then
            for _, l in pairs(v) do pcall(function() l.Visible = false end) end
        end
    end
end

function ESP.Update()
    Camera = Workspace.CurrentCamera
    
    for plr, obj in pairs(ESP.Objects) do
        if not ESP.Settings.Enabled or not IsAlive(plr) or plr == LocalPlayer then
            ESP.Hide(obj)
            if ESP.Chams[plr] then pcall(function() ESP.Chams[plr].Enabled = false end) end
            continue
        end
        
        if ESP.Settings.TeamCheck and plr.Team == LocalPlayer.Team and plr.Team ~= nil then
            ESP.Hide(obj)
            if ESP.Chams[plr] then pcall(function() ESP.Chams[plr].Enabled = false end) end
            continue
        end
        
        local char = plr.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChild("Humanoid")
        if not root or not head or not hum then ESP.Hide(obj) continue end
        
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        if not onScreen or dist > ESP.Settings.MaxDistance then
            ESP.Hide(obj)
            if ESP.Chams[plr] then pcall(function() ESP.Chams[plr].Enabled = false end) end
            continue
        end
        
        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local footPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        local h = math.abs(footPos.Y - headPos.Y)
        local w = h * 0.6
        local x, y = pos.X - w / 2, headPos.Y
        
        local color = ESP.GetColor(plr, head)
        
        if ESP.Settings.Box.Enabled and not ESP.Settings.CornerBox.Enabled then
            if ESP.Settings.Box.Outline then
                obj.BoxOutline.Size = Vector2.new(w, h)
                obj.BoxOutline.Position = Vector2.new(x, y)
                obj.BoxOutline.Visible = true
            else
                obj.BoxOutline.Visible = false
            end
            obj.Box.Size = Vector2.new(w, h)
            obj.Box.Position = Vector2.new(x, y)
            obj.Box.Color = color
            obj.Box.Thickness = ESP.Settings.Box.Thickness
            obj.Box.Visible = true
        else
            obj.Box.Visible = false
            obj.BoxOutline.Visible = false
        end
        
        if ESP.Settings.CornerBox.Enabled then
            local len = ESP.Settings.CornerBox.Length
            local c = ESP.Settings.CornerBox.Color
            
            obj.CornerTL.From = Vector2.new(x, y)
            obj.CornerTL.To = Vector2.new(x + len, y)
            obj.CornerTL.Color = c
            obj.CornerTL.Visible = true
            
            obj.CornerTL2.From = Vector2.new(x, y)
            obj.CornerTL2.To = Vector2.new(x, y + len)
            obj.CornerTL2.Color = c
            obj.CornerTL2.Visible = true
            
            obj.CornerTR.From = Vector2.new(x + w, y)
            obj.CornerTR.To = Vector2.new(x + w - len, y)
            obj.CornerTR.Color = c
            obj.CornerTR.Visible = true
            
            obj.CornerTR2.From = Vector2.new(x + w, y)
            obj.CornerTR2.To = Vector2.new(x + w, y + len)
            obj.CornerTR2.Color = c
            obj.CornerTR2.Visible = true
            
            obj.CornerBL.From = Vector2.new(x, y + h)
            obj.CornerBL.To = Vector2.new(x + len, y + h)
            obj.CornerBL.Color = c
            obj.CornerBL.Visible = true
            
            obj.CornerBL2.From = Vector2.new(x, y + h)
            obj.CornerBL2.To = Vector2.new(x, y + h - len)
            obj.CornerBL2.Color = c
            obj.CornerBL2.Visible = true
            
            obj.CornerBR.From = Vector2.new(x + w, y + h)
            obj.CornerBR.To = Vector2.new(x + w - len, y + h)
            obj.CornerBR.Color = c
            obj.CornerBR.Visible = true
            
            obj.CornerBR2.From = Vector2.new(x + w, y + h)
            obj.CornerBR2.To = Vector2.new(x + w, y + h - len)
            obj.CornerBR2.Color = c
            obj.CornerBR2.Visible = true
        else
            obj.CornerTL.Visible = false
            obj.CornerTL2.Visible = false
            obj.CornerTR.Visible = false
            obj.CornerTR2.Visible = false
            obj.CornerBL.Visible = false
            obj.CornerBL2.Visible = false
            obj.CornerBR.Visible = false
            obj.CornerBR2.Visible = false
        end
        
        if ESP.Settings.Name.Enabled then
            local nameText = plr.Name
            if ESP.Settings.Name.ShowDistance then
                nameText = nameText .. " [" .. math.floor(dist) .. "m]"
            end
            obj.Name.Text = nameText
            obj.Name.Position = Vector2.new(x + w / 2, y - ESP.Settings.Name.Size - 2)
            obj.Name.Color = ESP.Settings.Name.Color
            obj.Name.Size = ESP.Settings.Name.Size
            obj.Name.Visible = true
        else
            obj.Name.Visible = false
        end
        
        if ESP.Settings.Distance.Enabled and not ESP.Settings.Name.ShowDistance then
            obj.Distance.Text = math.floor(dist) .. "m"
            obj.Distance.Position = Vector2.new(x + w / 2, y + h + 2)
            obj.Distance.Color = ESP.Settings.Distance.Color
            obj.Distance.Size = ESP.Settings.Distance.Size
            obj.Distance.Visible = true
        else
            obj.Distance.Visible = false
        end
        
        if ESP.Settings.Health.Enabled then
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barHeight = h
            local barWidth = 3
            local barX = ESP.Settings.Health.Position == "Left" and (x - 6) or (x + w + 3)
            
            obj.HealthBarBg.Size = Vector2.new(barWidth, barHeight)
            obj.HealthBarBg.Position = Vector2.new(barX, y)
            obj.HealthBarBg.Visible = true
            
            obj.HealthBar.Size = Vector2.new(barWidth - 2, barHeight * hp)
            obj.HealthBar.Position = Vector2.new(barX + 1, y + barHeight - barHeight * hp)
            obj.HealthBar.Color = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
            obj.HealthBar.Visible = true
            
            obj.HealthBarOutline.Size = Vector2.new(barWidth, barHeight)
            obj.HealthBarOutline.Position = Vector2.new(barX, y)
            obj.HealthBarOutline.Visible = true
        else
            obj.HealthBar.Visible = false
            obj.HealthBarBg.Visible = false
            obj.HealthBarOutline.Visible = false
        end
        
        if ESP.Settings.Tracers.Enabled then
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
            
            obj.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, originY)
            obj.Tracer.To = Vector2.new(pos.X, pos.Y)
            obj.Tracer.Color = ESP.Settings.Tracers.Color
            obj.Tracer.Thickness = ESP.Settings.Tracers.Thickness
            obj.Tracer.Visible = true
        else
            obj.Tracer.Visible = false
        end
        
        if ESP.Settings.HeadDot.Enabled then
            local headScreen = Camera:WorldToViewportPoint(head.Position)
            obj.HeadDotOutline.Position = Vector2.new(headScreen.X, headScreen.Y)
            obj.HeadDotOutline.Radius = ESP.Settings.HeadDot.Size + 1
            obj.HeadDotOutline.Visible = true
            
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
            local parts = char:FindFirstChild("UpperTorso") and SkeletonR15 or SkeletonR6
            for i, conn in ipairs(parts) do
                local line = obj.Skeleton[i]
                if line then
                    local p1, p2 = char:FindFirstChild(conn[1]), char:FindFirstChild(conn[2])
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
            end
        else
            for _, l in pairs(obj.Skeleton) do pcall(function() l.Visible = false end) end
        end
        
        if ESP.Settings.Chams.Enabled then
            if not ESP.Chams[plr] then
                local hl = Instance.new("Highlight")
                hl.Adornee = char
                hl.Parent = CoreGui
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                ESP.Chams[plr] = hl
            end
            ESP.Chams[plr].FillColor = ESP.Settings.Chams.FillColor
            ESP.Chams[plr].OutlineColor = ESP.Settings.Chams.OutlineColor
            ESP.Chams[plr].FillTransparency = ESP.Settings.Chams.FillTransparency
            ESP.Chams[plr].Enabled = true
        elseif ESP.Chams[plr] then
            ESP.Chams[plr].Enabled = false
        end
    end
end

function ESP.Init()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then ESP.Create(plr) end
    end
    
    Players.PlayerAdded:Connect(function(plr) ESP.Create(plr) end)
    Players.PlayerRemoving:Connect(function(plr) ESP.Remove(plr) end)
    
    ESP.Connection = RunService.RenderStepped:Connect(ESP.Update)
end

function ESP.Destroy()
    if ESP.Connection then ESP.Connection:Disconnect() end
    for plr in pairs(ESP.Objects) do ESP.Remove(plr) end
    ESP.Objects = {}
    ESP.Chams = {}
end

return ESP
