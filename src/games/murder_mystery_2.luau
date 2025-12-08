local MM2 = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

MM2.Core = nil
MM2.Loops = {}
MM2.Roles = {}
MM2.RoleData = {}
MM2.Murderer = nil
MM2.Sheriff = nil
MM2.Hero = nil

MM2.Settings = {
    ShowRoles = true,
    AutoPickupGun = false,
    AutoPickupKnife = false,
    GrabRange = 15,
    TeleportPickup = false,
    MurdererColor = Color3.fromRGB(255, 0, 0),
    SheriffColor = Color3.fromRGB(0, 100, 255),
    InnocentColor = Color3.fromRGB(0, 255, 0),
    HeroColor = Color3.fromRGB(255, 255, 0)
}

function MM2.GetPlayerData()
    local success, data = pcall(function()
        local getPlayerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
        if getPlayerData then
            return getPlayerData:InvokeServer()
        end
        return nil
    end)
    
    if success and data then
        MM2.RoleData = data
        
        for playerName, info in pairs(data) do
            if info.Role == "Murderer" then
                MM2.Murderer = playerName
            elseif info.Role == "Sheriff" then
                MM2.Sheriff = playerName
            elseif info.Role == "Hero" then
                MM2.Hero = playerName
            end
        end
        
        return data
    end
    
    return {}
end

function MM2.IsAlive(player)
    if not player then return false end
    
    local playerName = type(player) == "string" and player or player.Name
    
    if MM2.RoleData[playerName] then
        local data = MM2.RoleData[playerName]
        if data.Killed or data.Dead then
            return false
        end
    end
    
    local plr = type(player) == "string" and Players:FindFirstChild(player) or player
    if plr and plr.Character then
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            return true
        end
    end
    
    return false
end

function MM2.HasGun(player)
    if not player then return false end
    
    local playerName = type(player) == "string" and player or player.Name
    
    if MM2.RoleData[playerName] and MM2.RoleData[playerName].HasGun then
        return true
    end
    
    local plr = type(player) == "string" and Players:FindFirstChild(player) or player
    if plr then
        local char = plr.Character
        local backpack = plr:FindFirstChild("Backpack")
        
        local function checkForGun(container)
            if not container then return false end
            for _, tool in pairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    if name:find("gun") or name:find("revolver") then
                        return true
                    end
                end
            end
            return false
        end
        
        if checkForGun(char) or checkForGun(backpack) then
            return true
        end
    end
    
    return false
end

function MM2.GetRole(player)
    if not player then return "Innocent" end
    
    local playerName = type(player) == "string" and player or player.Name
    
    if MM2.RoleData[playerName] then
        local role = MM2.RoleData[playerName].Role
        if role then
            return role
        end
    end
    
    if playerName == MM2.Murderer and MM2.IsAlive(player) then
        return "Murderer"
    elseif playerName == MM2.Sheriff and MM2.IsAlive(player) then
        return "Sheriff"
    elseif playerName == MM2.Hero and MM2.IsAlive(player) then
        return "Hero"
    elseif MM2.HasGun(player) and MM2.IsAlive(player) then
        return "Hero"
    end
    
    return "Innocent"
end

function MM2.GetRoleColor(player)
    if not player then return MM2.Settings.InnocentColor end
    
    local role = MM2.GetRole(player)
    
    if role == "Murderer" then
        return MM2.Settings.MurdererColor
    elseif role == "Sheriff" then
        return MM2.Settings.SheriffColor
    elseif role == "Hero" then
        return MM2.Settings.HeroColor
    end
    
    return MM2.Settings.InnocentColor
end

function MM2.GetDrops()
    local drops = {}
    
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Tool") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("gun") or name:find("revolver") or name == "gundrop" then
                table.insert(drops, {Object = obj, Type = "Gun"})
            elseif name:find("knife") or name == "knifedrop" then
                table.insert(drops, {Object = obj, Type = "Knife"})
            end
        end
    end
    
    local droppedItems = Workspace:FindFirstChild("DroppedItems")
    if droppedItems then
        for _, obj in pairs(droppedItems:GetChildren()) do
            local name = obj.Name:lower()
            if name:find("gun") or name:find("revolver") then
                table.insert(drops, {Object = obj, Type = "Gun"})
            elseif name:find("knife") then
                table.insert(drops, {Object = obj, Type = "Knife"})
            end
        end
    end
    
    return drops
end

function MM2.GetDropPosition(drop)
    if not drop then return nil end
    
    local handle = drop:FindFirstChild("Handle") or drop:FindFirstChildOfClass("BasePart")
    if handle then return handle.Position end
    if drop:IsA("BasePart") then return drop.Position end
    if drop:IsA("Model") and drop.PrimaryPart then return drop.PrimaryPart.Position end
    
    return nil
end

function MM2.GrabDrop(drop)
    if not MM2.Core then return end
    if not MM2.Core.IsAlive then return end
    if not MM2.Core.IsAlive(LocalPlayer) then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local handle = drop:FindFirstChild("Handle") or drop:FindFirstChildOfClass("BasePart")
    if not handle then
        if drop:IsA("BasePart") then
            handle = drop
        elseif drop:IsA("Model") and drop.PrimaryPart then
            handle = drop.PrimaryPart
        else
            return
        end
    end
    
    if MM2.Settings.TeleportPickup then
        local oldCFrame = hrp.CFrame
        hrp.CFrame = handle.CFrame * CFrame.new(0, 3, 0)
        task.wait(0.1)
        hrp.CFrame = oldCFrame
    else
        pcall(function()
            if firetouchinterest then
                firetouchinterest(hrp, handle, 0)
                task.defer(function()
                    firetouchinterest(hrp, handle, 1)
                end)
            end
        end)
    end
end

function MM2.AutoPickupGun(enabled)
    MM2.Settings.AutoPickupGun = enabled
    
    if MM2.Loops.AutoPickupGun then
        pcall(function() MM2.Loops.AutoPickupGun:Disconnect() end)
        MM2.Loops.AutoPickupGun = nil
    end
    
    if enabled then
        MM2.Loops.AutoPickupGun = RunService.Heartbeat:Connect(function()
            if not MM2.Core or not MM2.Core.IsAlive then return end
            if not MM2.Core.IsAlive(LocalPlayer) then return end
            
            local myRole = MM2.GetRole(LocalPlayer)
            if myRole == "Murderer" then return end
            
            local char = LocalPlayer.Character
            if not char then return end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            if MM2.HasGun(LocalPlayer) then return end
            
            for _, drop in pairs(MM2.GetDrops()) do
                if drop.Type == "Gun" then
                    local pos = MM2.GetDropPosition(drop.Object)
                    if pos then
                        local dist = (hrp.Position - pos).Magnitude
                        if dist <= MM2.Settings.GrabRange or MM2.Settings.TeleportPickup then
                            MM2.GrabDrop(drop.Object)
                            break
                        end
                    end
                end
            end
        end)
    end
end

function MM2.AutoPickupKnife(enabled)
    MM2.Settings.AutoPickupKnife = enabled
    
    if MM2.Loops.AutoPickupKnife then
        pcall(function() MM2.Loops.AutoPickupKnife:Disconnect() end)
        MM2.Loops.AutoPickupKnife = nil
    end
    
    if enabled then
        MM2.Loops.AutoPickupKnife = RunService.Heartbeat:Connect(function()
            if not MM2.Core or not MM2.Core.IsAlive then return end
            if not MM2.Core.IsAlive(LocalPlayer) then return end
            
            local char = LocalPlayer.Character
            if not char then return end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            for _, drop in pairs(MM2.GetDrops()) do
                if drop.Type == "Knife" then
                    local pos = MM2.GetDropPosition(drop.Object)
                    if pos then
                        local dist = (hrp.Position - pos).Magnitude
                        if dist <= MM2.Settings.GrabRange or MM2.Settings.TeleportPickup then
                            MM2.GrabDrop(drop.Object)
                            break
                        end
                    end
                end
            end
        end)
    end
end

function MM2.SetGrabRange(range)
    MM2.Settings.GrabRange = range
end

function MM2.SetTeleportPickup(enabled)
    MM2.Settings.TeleportPickup = enabled
end

function MM2.RefreshRoles()
    MM2.Roles = {}
    MM2.RoleData = {}
    MM2.Murderer = nil
    MM2.Sheriff = nil
    MM2.Hero = nil
    MM2.GetPlayerData()
end

function MM2.Init(Core)
    MM2.Core = Core
    
    if MM2.Loops.RoleRefresh then
        pcall(function() MM2.Loops.RoleRefresh:Disconnect() end)
    end
    
    MM2.GetPlayerData()
    
    MM2.Loops.RoleRefresh = RunService.Heartbeat:Connect(function()
        if not MM2._lastRefresh then MM2._lastRefresh = 0 end
        
        if tick() - MM2._lastRefresh >= 2 then
            MM2._lastRefresh = tick()
            MM2.GetPlayerData()
        end
    end)
end

function MM2.Cleanup()
    for name, conn in pairs(MM2.Loops) do
        if conn then
            pcall(function() conn:Disconnect() end)
        end
    end
    MM2.Loops = {}
    MM2.Roles = {}
    MM2.RoleData = {}
    MM2.Murderer = nil
    MM2.Sheriff = nil
    MM2.Hero = nil
end

return MM2
