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
    
    Box = { Enabled = true, Color = Color3.new(1, 1, 1), Thickness = 1, Outline = true },
    Name = { Enabled = true, Color = Color3.new(1, 1, 1), Size = 13 },
    Health = { Enabled = true, Position = "Left" },
    Distance = { Enabled = false, Color = Color3.new(1, 1, 1), Size = 11 },
    Skeleton = { Enabled = false, Color = Color3.new(1, 1, 1), Thickness = 1 },
    Chams = { Enabled = false, FillColor = Color3.new(1, 0, 0), OutlineColor = Color3.new(1, 1, 1), FillTransparency = 0.5 },
    Tracers = { Enabled = false, Color = Color3.new(1, 1, 1), Origin = "Bottom", Thickness = 1 },
    HeadDot = { Enabled = false, Color = Color3.new(1, 0, 0), Size = 4, Filled = true }
}

ESP.Objects = {}
ESP.Chams = {}
ESP.RenderConnection = nil

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

-- Drawing Helper
local function NewDrawing(class, properties)
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
    
    for prop, value in pairs(properties or {}) do
        pcall(function()
            drawing[prop] = value
        end)
    end
    
    return drawing
end

-- Utility
local function IsAlive(player)
    if not player or not player.Character then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function IsOnScreen(position)
    local _, onScreen = Camera:WorldToViewportPoint(position)
    return onScreen
end

-- ESP Object Management
function ESP.Create(player)
    if ESP.Objects[player] then return end
    
    local obj = {
        Box = NewDrawing("Square", { Thickness = 1, Filled = false }),
        BoxOutline = NewDrawing("Square", { Thickness = 3, Filled = false, Color = Color3.new(0, 0, 0) }),
        
        Name = NewDrawing("Text", { Size = 13, Center = true, Outline = true, Font = 2 }),
        Distance = NewDrawing("Text", { Size = 11, Center = true, Outline = true, Font = 2 }),
        
        HealthBar = NewDrawing("Square", { Filled = true }),
        HealthBarOutline = NewDrawing("Square", { Filled = false, Color = Color3.new(0, 0, 0), Thickness = 1 }),
        
        Tracer = NewDrawing("Line", { Thickness = 1 }),
        HeadDot = NewDrawing("Circle", { Filled = true }),
        
        Skeleton = {}
    }
    
    for i = 1, 14 do
        obj.Skeleton[i] = NewDrawing("Line", { Thickness = 1 })
    end
    
    ESP.Objects[player] = obj
end

function ESP.Remove(player)
    local obj = ESP.Objects[player]
    if obj then
        for key, drawing in pairs(obj) do
            if type(drawing) == "table" and drawing.Remove then
                pcall(function() drawing:Remove() end)
            elseif type(drawing) == "table" then
                for _, line in pairs(drawing) do
                    pcall(function() line:Remove() end)
                end
            end
        end
        ESP.Objects[player] = nil
    end
    
    if ESP.Chams[player] then
        pcall(function() ESP.Chams[player]:Destroy() end)
        ESP.Chams[player] = nil
    end
end

function ESP.Hide(obj)
    if not obj then return end
    
    for key, drawing in pairs(obj) do
        if type(drawing) == "table" and drawing.Visible ~= nil then
            pcall(function() drawing.Visible = false end)
        elseif type(drawing) == "table" then
            for _, line in pairs(drawing) do
                pcall(function() line.Visible = false end)
            end
        end
    end
end

function ESP.Update()
    Camera = Workspace.CurrentCamera
    
    for player, obj in pairs(ESP.Objects) do
        if not ESP.Settings.Enabled or not IsAlive(player) or player == LocalPlayer then
            ESP.Hide(obj)
            if ESP.Chams[player] then
                pcall(function() ESP.Chams[player].Enabled = false end)
            end
            continue
        end
        
        if ESP.Settings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then
            ESP.Hide(obj)
            if ESP.Chams[player] then
                pcall(function() ESP.Chams[player].Enabled = false end)
            end
            continue
        end
        
        local character = player.Character
        local root = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if not root or not head or not humanoid then
            ESP.Hide(obj)
            continue
        end
        
        local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local distance = (root.Position - Camera.CFrame.Position).Magnitude
        
        if not onScreen or distance > ESP.Settings.MaxDistance then
            ESP.Hide(obj)
            if ESP.Chams[player] then
                pcall(function() ESP.Chams[player].Enabled = false end)
            end
            continue
        end
        
        -- Calculate box dimensions
        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local footPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        local boxHeight = math.abs(footPos.Y - headPos.Y)
        local boxWidth = boxHeight * 0.6
        local boxX = rootPos.X - boxWidth / 2
        local boxY = headPos.Y
        
        local color = ESP.Settings.Box.Color
        
        -- Box ESP
        if ESP.Settings.Box.Enabled then
            if ESP.Settings.Box.Outline then
                obj.BoxOutline.Size = Vector2.new(boxWidth, boxHeight)
                obj.BoxOutline.Position = Vector2.new(boxX, boxY)
                obj.BoxOutline.Visible = true
            else
                obj.BoxOutline.Visible = false
            end
            
            obj.Box.Size = Vector2.new(boxWidth, boxHeight)
            obj.Box.Position = Vector2.new(boxX, boxY)
            obj.Box.Color = color
            obj.Box.Thickness = ESP.Settings.Box.Thickness
            obj.Box.Visible = true
        else
            obj.Box.Visible = false
            obj.BoxOutline.Visible = false
        end
        
        -- Name ESP
        if ESP.Settings.Name.Enabled then
            obj.Name.Text = player.Name
            obj.Name.Position = Vector2.new(boxX + boxWidth / 2, boxY - ESP.Settings.Name.Size - 2)
            obj.Name.Color = ESP.Settings.Name.Color
            obj.Name.Size = ESP.Settings.Name.Size
            obj.Name.Visible = true
        else
            obj.Name.Visible = false
        end
        
        -- Distance ESP
        if ESP.Settings.Distance.Enabled then
            obj.Distance.Text = math.floor(distance) .. "m"
            obj.Distance.Position = Vector2.new(boxX + boxWidth / 2, boxY + boxHeight + 2)
            obj.Distance.Color = ESP.Settings.Distance.Color
            obj.Distance.Size = ESP.Settings.Distance.Size
            obj.Distance.Visible = true
        else
            obj.Distance.Visible = false
        end
        
        -- Health Bar
        if ESP.Settings.Health.Enabled then
            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            local barHeight = boxHeight * healthPercent
            local barX = ESP.Settings.Health.Position == "Left" and (boxX - 5) or (boxX + boxWidth + 2)
            
            obj.HealthBarOutline.Size = Vector2.new(3, boxHeight)
            obj.HealthBarOutline.Position = Vector2.new(barX, boxY)
            obj.HealthBarOutline.Visible = true
            
            obj.HealthBar.Size = Vector2.new(1, barHeight)
            obj.HealthBar.Position = Vector2.new(barX + 1, boxY + boxHeight - barHeight)
            obj.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
            obj.HealthBar.Visible = true
        else
            obj.HealthBar.Visible = false
            obj.HealthBarOutline.Visible = false
        end
        
        -- Tracers
        if ESP.Settings.Tracers.Enabled then
            local originY = ESP.Settings.Tracers.Origin == "Bottom" and Camera.ViewportSize.Y or 
                           (ESP.Settings.Tracers.Origin == "Top" and 0 or Camera.ViewportSize.Y / 2)
            
            obj.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, originY)
            obj.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            obj.Tracer.Color = ESP.Settings.Tracers.Color
            obj.Tracer.Thickness = ESP.Settings.Tracers.Thickness
            obj.Tracer.Visible = true
        else
            obj.Tracer.Visible = false
        end
        
        -- Head Dot
        if ESP.Settings.HeadDot.Enabled then
            local headScreen = Camera:WorldToViewportPoint(head.Position)
            obj.HeadDot.Position = Vector2.new(headScreen.X, headScreen.Y)
            obj.HeadDot.Radius = ESP.Settings.HeadDot.Size
            obj.HeadDot.Color = ESP.Settings.HeadDot.Color
            obj.HeadDot.Filled = ESP.Settings.HeadDot.Filled
            obj.HeadDot.Visible = true
        else
            obj.HeadDot.Visible = false
        end
        
        -- Skeleton
        if ESP.Settings.Skeleton.Enabled then
            local parts = character:FindFirstChild("UpperTorso") and SkeletonR15 or SkeletonR6
            
            for i, connection in ipairs(parts) do
                local line = obj.Skeleton[i]
                if line then
                    local p1 = character:FindFirstChild(connection[1])
                    local p2 = character:FindFirstChild(connection[2])
                    
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
            for _, line in pairs(obj.Skeleton) do
                pcall(function() line.Visible = false end)
            end
        end
        
        -- Chams (Highlight)
        if ESP.Settings.Chams.Enabled then
            if not ESP.Chams[player] then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = character
                highlight.Parent = CoreGui
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                ESP.Chams[player] = highlight
            end
            
            ESP.Chams[player].FillColor = ESP.Settings.Chams.FillColor
            ESP.Chams[player].OutlineColor = ESP.Settings.Chams.OutlineColor
            ESP.Chams[player].FillTransparency = ESP.Settings.Chams.FillTransparency
            ESP.Chams[player].Enabled = true
        else
            if ESP.Chams[player] then
                ESP.Chams[player].Enabled = false
            end
        end
    end
end

function ESP.Init()
    -- Create ESP for existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ESP.Create(player)
        end
    end
    
    -- Listen for new players
    Players.PlayerAdded:Connect(function(player)
        ESP.Create(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        ESP.Remove(player)
    end)
    
    -- Start render loop
    ESP.RenderConnection = RunService.RenderStepped:Connect(function()
        ESP.Update()
    end)
end

function ESP.Destroy()
    if ESP.RenderConnection then
        ESP.RenderConnection:Disconnect()
        ESP.RenderConnection = nil
    end
    
    for player in pairs(ESP.Objects) do
        ESP.Remove(player)
    end
    
    ESP.Objects = {}
    ESP.Chams = {}
end

return ESP
