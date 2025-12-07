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
    
    Box = { Enabled = true, Color = Color3.new(1, 1, 1), Thickness = 1 },
    Name = { Enabled = true, Color = Color3.new(1, 1, 1), Size = 13 },
    Health = { Enabled = true },
    Distance = { Enabled = false, Color = Color3.new(1, 1, 1) },
    Skeleton = { Enabled = false, Color = Color3.new(1, 1, 1) },
    Chams = { Enabled = false, FillColor = Color3.new(1, 0, 0), FillTransparency = 0.5 },
    Tracers = { Enabled = false, Color = Color3.new(1, 1, 1), Origin = "Bottom" }
}

ESP.Objects = {}
ESP.Chams = {}
ESP.Connection = nil

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

function ESP.Create(plr)
    if ESP.Objects[plr] then return end
    ESP.Objects[plr] = {
        Box = NewDrawing("Square", { Thickness = 1, Filled = false }),
        BoxOutline = NewDrawing("Square", { Thickness = 3, Filled = false, Color = Color3.new(0, 0, 0) }),
        Name = NewDrawing("Text", { Size = 13, Center = true, Outline = true, Font = 2 }),
        Distance = NewDrawing("Text", { Size = 11, Center = true, Outline = true, Font = 2 }),
        HealthBar = NewDrawing("Square", { Filled = true }),
        HealthOutline = NewDrawing("Square", { Filled = false, Color = Color3.new(0, 0, 0) }),
        Tracer = NewDrawing("Line", { Thickness = 1 }),
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
        local color = ESP.Settings.Box.Color
        
        if ESP.Settings.Box.Enabled then
            obj.BoxOutline.Size = Vector2.new(w, h)
            obj.BoxOutline.Position = Vector2.new(x, y)
            obj.BoxOutline.Visible = true
            obj.Box.Size = Vector2.new(w, h)
            obj.Box.Position = Vector2.new(x, y)
            obj.Box.Color = color
            obj.Box.Visible = true
        else
            obj.Box.Visible = false
            obj.BoxOutline.Visible = false
        end
        
        if ESP.Settings.Name.Enabled then
            obj.Name.Text = plr.Name
            obj.Name.Position = Vector2.new(x + w / 2, y - 15)
            obj.Name.Color = ESP.Settings.Name.Color
            obj.Name.Visible = true
        else
            obj.Name.Visible = false
        end
        
        if ESP.Settings.Distance.Enabled then
            obj.Distance.Text = math.floor(dist) .. "m"
            obj.Distance.Position = Vector2.new(x + w / 2, y + h + 2)
            obj.Distance.Color = ESP.Settings.Distance.Color
            obj.Distance.Visible = true
        else
            obj.Distance.Visible = false
        end
        
        if ESP.Settings.Health.Enabled then
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            obj.HealthOutline.Size = Vector2.new(3, h)
            obj.HealthOutline.Position = Vector2.new(x - 5, y)
            obj.HealthOutline.Visible = true
            obj.HealthBar.Size = Vector2.new(1, h * hp)
            obj.HealthBar.Position = Vector2.new(x - 4, y + h - h * hp)
            obj.HealthBar.Color = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
            obj.HealthBar.Visible = true
        else
            obj.HealthBar.Visible = false
            obj.HealthOutline.Visible = false
        end
        
        if ESP.Settings.Tracers.Enabled then
            local originY = ESP.Settings.Tracers.Origin == "Bottom" and Camera.ViewportSize.Y or
                           (ESP.Settings.Tracers.Origin == "Top" and 0 or Camera.ViewportSize.Y / 2)
            obj.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, originY)
            obj.Tracer.To = Vector2.new(pos.X, pos.Y)
            obj.Tracer.Color = ESP.Settings.Tracers.Color
            obj.Tracer.Visible = true
        else
            obj.Tracer.Visible = false
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
            ESP.Chams[plr].FillTransparency = ESP.Settings.Chams.FillTransparency
            ESP.Chams[plr].Enabled = true
        elseif ESP.Chams[plr] then
            ESP.Chams[plr].Enabled = false
        end
    end
end

function ESP.Init()
    print("[ESP] Initialized")
    
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
