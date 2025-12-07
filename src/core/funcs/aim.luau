local Aim = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

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

Aim.Settings = {
    Enabled = false,
    TeamCheck = true,
    VisibleCheck = true,
    FOV = 100,
    Smoothness = 5,
    AimPart = "Head",
    Prediction = 0,
    StickyAim = false,
    AimType = "Mouse" -- Mouse, Camera
}

Aim.TriggerSettings = {
    Enabled = false,
    TeamCheck = true,
    Delay = 0
}

Aim.LockedTarget = nil
Aim.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
Aim.LastAimTime = 0

function Aim.GetMousePosition()
    if Aim.IsMobile then
        return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    local success, pos = pcall(function() return UserInputService:GetMouseLocation() end)
    return success and pos or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function Aim.IsAlive(plr)
    if not plr or not plr.Character then return false end
    local h = plr.Character:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

function Aim.IsVisible(part)
    if not part then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), params)
    if result then return result.Instance:IsDescendantOf(part.Parent) end
    return true
end

function Aim.GetClosestPlayer()
    Camera = Workspace.CurrentCamera
    local closest, shortestDist = nil, Aim.Settings.FOV
    local mousePos = Aim.GetMousePosition()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or not Aim.IsAlive(player) then continue end
        if Aim.Settings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then continue end
        
        local char = player.Character
        if not char then continue end
        
        local aimPart = char:FindFirstChild(Aim.Settings.AimPart) or char:FindFirstChild("Head")
        if not aimPart then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
        if not onScreen then continue end
        if Aim.Settings.VisibleCheck and not Aim.IsVisible(aimPart) then continue end
        
        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if dist < shortestDist then
            shortestDist = dist
            closest = player
        end
    end
    return closest
end

function Aim.AimAt(player, TargetCircle)
    Camera = Workspace.CurrentCamera
    
    if not player or not Aim.IsAlive(player) then
        Aim.LockedTarget = nil
        return
    end
    
    local char = player.Character
    if not char then return end
    
    local aimPart = char:FindFirstChild(Aim.Settings.AimPart) or char:FindFirstChild("Head")
    if not aimPart then return end
    
    local targetPos = aimPart.Position
    
    if Aim.Settings.Prediction > 0 then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            targetPos = targetPos + (root.AssemblyLinearVelocity * (Aim.Settings.Prediction / 10))
        end
    end
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    if not onScreen then return end
    
    local mousePos = Aim.GetMousePosition()
    
    local smoothness = math.max(Aim.Settings.Smoothness, 0.5)
    
    if Aim.Settings.AimType == "Camera" then
        local direction = (targetPos - Camera.CFrame.Position).Unit
        local targetCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / smoothness)
    else
        if Aim.IsMobile then return end
        
        local deltaX = (screenPos.X - mousePos.X)
        local deltaY = (screenPos.Y - mousePos.Y)
        
        local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
        
        if distance < 1 then return end
        
        local moveX = deltaX / smoothness
        local moveY = deltaY / smoothness
        
        local maxMove = 50
        moveX = math.clamp(moveX, -maxMove, maxMove)
        moveY = math.clamp(moveY, -maxMove, maxMove)
        
        if math.abs(moveX) < 0.1 then moveX = 0 end
        if math.abs(moveY) < 0.1 then moveY = 0 end
        
        if mousemoverel and (moveX ~= 0 or moveY ~= 0) then
            mousemoverel(moveX, moveY)
        end
    end
    
    if TargetCircle then
        pcall(function()
            TargetCircle.Position = Vector2.new(screenPos.X, screenPos.Y)
            TargetCircle.Visible = true
        end)
    end
end

function Aim.GetTriggerTarget()
    Camera = Workspace.CurrentCamera
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local ray = Camera:ViewportPointToRay(center.X, center.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    if result and result.Instance then
        local player = Players:GetPlayerFromCharacter(result.Instance.Parent) or Players:GetPlayerFromCharacter(result.Instance.Parent.Parent)
        if player and player ~= LocalPlayer and Aim.IsAlive(player) then
            if Aim.TriggerSettings.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then
                return nil
            end
            return player
        end
    end
    return nil
end

function Aim.Init() end

return Aim
