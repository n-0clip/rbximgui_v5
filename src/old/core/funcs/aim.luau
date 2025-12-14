local Aim = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

Aim.Settings = {
    Enabled = false,
    TeamCheck = true,
    VisibleCheck = true,
    FOV = 100,
    Smoothness = 5,
    AimPart = "Head",
    Prediction = 0,
    StickyAim = false,
    AimType = "Mouse"
}

Aim.TriggerSettings = {
    Enabled = false,
    TeamCheck = true,
    Delay = 0
}

Aim.LockedTarget = nil
Aim.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
Aim.LastAimTime = 0
Aim.GetColorCallback = nil

function Aim.GetMousePosition()
    Camera = Workspace.CurrentCamera
    if Aim.IsMobile then
        return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    local success, pos = pcall(function() 
        return UserInputService:GetMouseLocation() 
    end)
    if success and pos then
        return pos
    end
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function Aim.IsAlive(plr)
    if not plr then return false end
    if typeof(plr) ~= "Instance" then return false end
    if not plr:IsA("Player") then return false end
    
    local char = plr.Character
    if not char then return false end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    return humanoid.Health > 0
end

function Aim.IsVisible(part)
    if not part then return false end
    
    Camera = Workspace.CurrentCamera
    if not Camera then return false end
    
    local localChar = LocalPlayer.Character
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {localChar, Camera}
    params.IgnoreWater = true
    
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    
    local result = Workspace:Raycast(origin, direction, params)
    
    if not result then
        return true
    end
    
    if result.Instance then
        local hitParent = result.Instance.Parent
        if hitParent and part.Parent then
            return hitParent == part.Parent or result.Instance:IsDescendantOf(part.Parent)
        end
    end
    
    return false
end

function Aim.GetClosestPlayer()
    Camera = Workspace.CurrentCamera
    if not Camera then return nil end
    
    local closest = nil
    local shortestDist = Aim.Settings.FOV
    local mousePos = Aim.GetMousePosition()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not Aim.IsAlive(player) then continue end
        
        if Aim.Settings.TeamCheck then
            if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                continue
            end
        end
        
        local char = player.Character
        if not char then continue end
        
        local aimPart = char:FindFirstChild(Aim.Settings.AimPart)
        if not aimPart then
            aimPart = char:FindFirstChild("Head")
        end
        if not aimPart then continue end
        
        local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
        if not onScreen then continue end
        
        if Aim.Settings.VisibleCheck then
            if not Aim.IsVisible(aimPart) then continue end
        end
        
        local screenVec = Vector2.new(screenPos.X, screenPos.Y)
        local dist = (screenVec - mousePos).Magnitude
        
        if dist < shortestDist then
            shortestDist = dist
            closest = player
        end
    end
    
    return closest
end

function Aim.AimAt(player, targetCircle)
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    
    if not player then
        Aim.LockedTarget = nil
        if targetCircle then
            pcall(function() targetCircle.Visible = false end)
        end
        return
    end
    
    if not Aim.IsAlive(player) then
        Aim.LockedTarget = nil
        if targetCircle then
            pcall(function() targetCircle.Visible = false end)
        end
        return
    end
    
    local char = player.Character
    if not char then return end
    
    local aimPart = char:FindFirstChild(Aim.Settings.AimPart)
    if not aimPart then
        aimPart = char:FindFirstChild("Head")
    end
    if not aimPart then return end
    
    local targetPos = aimPart.Position
    
    if Aim.Settings.Prediction > 0 then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and root:IsA("BasePart") then
            local velocity = root.AssemblyLinearVelocity
            if velocity then
                targetPos = targetPos + (velocity * (Aim.Settings.Prediction / 10))
            end
        end
    end
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
    if not onScreen then
        if targetCircle then
            pcall(function() targetCircle.Visible = false end)
        end
        return
    end
    
    local mousePos = Aim.GetMousePosition()
    local smoothness = math.max(Aim.Settings.Smoothness, 0.1)
    
    if Aim.Settings.AimType == "Camera" then
        local direction = (targetPos - Camera.CFrame.Position).Unit
        local targetCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / smoothness)
    else
        if not Aim.IsMobile then
            local deltaX = screenPos.X - mousePos.X
            local deltaY = screenPos.Y - mousePos.Y
            
            local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
            
            if distance > 0.5 then
                local moveX = deltaX / smoothness
                local moveY = deltaY / smoothness
                
                local maxMove = math.max(50, distance / 2)
                moveX = math.clamp(moveX, -maxMove, maxMove)
                moveY = math.clamp(moveY, -maxMove, maxMove)
                
                if math.abs(moveX) > 0.01 or math.abs(moveY) > 0.01 then
                    if mousemoverel then
                        pcall(function()
                            mousemoverel(moveX, moveY)
                        end)
                    end
                end
            end
        end
    end
    
    if targetCircle then
        pcall(function()
            targetCircle.Position = Vector2.new(screenPos.X, screenPos.Y)
            targetCircle.Visible = true
        end)
    end
end

function Aim.GetTriggerTarget()
    Camera = Workspace.CurrentCamera
    if not Camera then return nil end
    
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local ray = Camera:ViewportPointToRay(center.X, center.Y)
    
    local localChar = LocalPlayer.Character
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {localChar}
    params.IgnoreWater = true
    
    local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    
    if result and result.Instance then
        local hitInstance = result.Instance
        local player = Players:GetPlayerFromCharacter(hitInstance.Parent)
        
        if not player then
            player = Players:GetPlayerFromCharacter(hitInstance.Parent.Parent)
        end
        
        if player and player ~= LocalPlayer then
            if Aim.IsAlive(player) then
                if Aim.TriggerSettings.TeamCheck then
                    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                        return nil
                    end
                end
                return player
            end
        end
    end
    
    return nil
end

function Aim.Init()
    Camera = Workspace.CurrentCamera
end

return Aim
