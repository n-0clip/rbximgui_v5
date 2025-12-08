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
    
    Name = { 
        Enabled = false, 
        Color = Color3.fromRGB(255, 255, 255), 
        Size = 13,
        ShowDistance = false
    },
    
    Health = { 
        Enabled = false, 
        Position = "Left"
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

function ESP.Create(plr)
    if not plr or ESP.Objects[plr] then return end
    
    local obj = {
        Box = NewDrawing("Square", {Thickness = 1, Filled = false}),
        BoxOutline = NewDrawing("Square", {Thickness = 3, Filled = false, Color = Color3.new(0, 0, 0)}),
        
        Name = NewDrawing("Text", {Size = 13, Center = true, Outline = true, Font = 2}),
        Distance = NewDrawing("Text", {Size = 11, Center = true, Outline = true, Font = 2}),
        
        HealthBar = NewDrawing("Square", {Filled = true}),
        HealthBarBg = NewDrawing("Square", {Filled = true, Color = Color3.fromRGB(40, 40, 40)}),
        HealthBarOutline = NewDrawing("Square", {Filled = false, Color = Color3.new(0, 0, 0), Thickness = 1}),
        
        Tracer = NewDrawing("Line", {Thickness = 1}),
        TracerOutline = NewDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0)}),
        
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
        SafeRemove(obj.Box)
        SafeRemove(obj.BoxOutline)
        SafeRemove(obj.Name)
        SafeRemove(obj.Distance)
        SafeRemove(obj.HealthBar)
        SafeRemove(obj.HealthBarBg)
        SafeRemove(obj.HealthBarOutline)
        SafeRemove(obj.Tracer)
        SafeRemove(obj.TracerOutline)
        
        for _, line in pairs(obj.Skeleton) do
            SafeRemove(line)
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
    
    SafeSet(obj.Box, "Visible", false)
    SafeSet(obj.BoxOutline, "Visible", false)
    SafeSet(obj.Name, "Visible", false)
    SafeSet(obj.Distance, "Visible", false)
    SafeSet(obj.HealthBar, "Visible", false)
    SafeSet(obj.HealthBarBg, "Visible", false)
    SafeSet(obj.HealthBarOutline, "Visible", false)
    SafeSet(obj.Tracer, "Visible", false)
    SafeSet(obj.TracerOutline, "Visible", false)
    
    for _, line in pairs(obj.Skeleton) do
        SafeSet(line, "Visible", false)
    end
end

function ESP.HideChams(plr)
    if ESP.Chams[plr] then
        pcall(function() 
            ESP.Chams[plr].Enabled = false 
        end)
    end
end

function ESP.RemoveChams(plr)
    if ESP.Chams[plr] then
        pcall(function() ESP.Chams[plr]:Destroy() end)
        ESP.Chams[plr] = nil
    end
end

function ESP.Update()
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    
    for plr, obj in pairs(ESP.Objects) do
        local shouldHide = false
        
        if not ESP.Settings.Enabled then
            shouldHide = true
        elseif plr == LocalPlayer then
            shouldHide = true
        elseif not IsAlive(plr) then
            shouldHide = true
            ESP.RemoveChams(plr)
        elseif ESP.Settings.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
            shouldHide = true
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
        
        if not onScreen or dist > ESP.Settings.MaxDistance then
            ESP.Hide(obj)
            ESP.HideChams(plr)
            continue
        end
        
        local headTop = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local footBottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        
        local boxH = math.abs(footBottom.Y - headTop.Y)
        local boxW = boxH * 0.55
        local boxX = rootPos.X - boxW / 2
        local boxY = headTop.Y
        
        local espColor = ESP.GetColor(plr)
        
        if ESP.Settings.Box.Enabled and obj.Box then
            if ESP.Settings.Box.Outline and obj.BoxOutline then
                obj.BoxOutline.Size = Vector2.new(boxW, boxH)
                obj.BoxOutline.Position = Vector2.new(boxX, boxY)
                obj.BoxOutline.Visible = true
            elseif obj.BoxOutline then
                obj.BoxOutline.Visible = false
            end
            
            obj.Box.Size = Vector2.new(boxW, boxH)
            obj.Box.Position = Vector2.new(boxX, boxY)
            obj.Box.Color = espColor
            obj.Box.Thickness = ESP.Settings.Box.Thickness
            obj.Box.Visible = true
        else
            SafeSet(obj.Box, "Visible", false)
            SafeSet(obj.BoxOutline, "Visible", false)
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
        
        if ESP.Settings.Health.Enabled and obj.HealthBar then
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barW = 3
            local barX = ESP.Settings.Health.Position == "Left" and (boxX - 6) or (boxX + boxW + 3)
            
            obj.HealthBarBg.Size = Vector2.new(barW, boxH)
            obj.HealthBarBg.Position = Vector2.new(barX, boxY)
            obj.HealthBarBg.Visible = true
            
            local healthH = boxH * hp
            obj.HealthBar.Size = Vector2.new(barW - 2, healthH)
            obj.HealthBar.Position = Vector2.new(barX + 1, boxY + boxH - healthH)
            obj.HealthBar.Color = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
            obj.HealthBar.Visible = true
            
            obj.HealthBarOutline.Size = Vector2.new(barW, boxH)
            obj.HealthBarOutline.Position = Vector2.new(barX, boxY)
            obj.HealthBarOutline.Visible = true
        else
            SafeSet(obj.HealthBar, "Visible", false)
            SafeSet(obj.HealthBarBg, "Visible", false)
            SafeSet(obj.HealthBarOutline, "Visible", false)
        end
        
        if ESP.Settings.Tracers.Enabled and obj.Tracer then
            local originX = Camera.ViewportSize.X / 2
            local originY = ESP.Settings.Tracers.Origin == "Top" and 0 
                or ESP.Settings.Tracers.Origin == "Center" and Camera.ViewportSize.Y / 2 
                or Camera.ViewportSize.Y
            
            obj.TracerOutline.From = Vector2.new(originX, originY)
            obj.TracerOutline.To = Vector2.new(rootPos.X, rootPos.Y)
            obj.TracerOutline.Visible = true
            
            obj.Tracer.From = Vector2.new(originX, originY)
            obj.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            obj.Tracer.Color = ESP.Settings.Tracers.Color
            obj.Tracer.Thickness = ESP.Settings.Tracers.Thickness
            obj.Tracer.Visible = true
        else
            SafeSet(obj.Tracer, "Visible", false)
            SafeSet(obj.TracerOutline, "Visible", false)
        end
        
        if ESP.Settings.Skeleton.Enabled then
            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
            local connections = isR15 and SkeletonConnections.R15 or SkeletonConnections.R6
            
            for i, conn in ipairs(connections) do
                local line = obj.Skeleton[i]
                if line then
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
            end
            
            for i = #connections + 1, 14 do
                local line = obj.Skeleton[i]
                if line then line.Visible = false end
            end
        else
            for _, line in pairs(obj.Skeleton) do
                SafeSet(line, "Visible", false)
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
