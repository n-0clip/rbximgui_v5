local MM2 = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

MM2.Core = nil
MM2.Loops = {}
MM2.RoleData = {}
MM2.Murderer = nil
MM2.Sheriff = nil
MM2.Hero = nil
MM2.LastRefresh = 0

MM2.Settings = {
    ShowRoles = false,
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
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote then
            local getPlayerData = remote:FindFirstChild("Gameplay"):FindFirstChild("GetPlayerData")
            if getPlayerData then
                return getPlayerData:InvokeServer()
            end
        end
        
        local getPlayerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
        if getPlayerData then
            return getPlayerData:InvokeServer()
        end
        
        return nil
    end)
    
    if success and data then
        MM2.RoleData = data
        MM2.Murderer = nil
        MM2.Sheriff = nil
        MM2.Hero = nil
        
        for playerName, info in pairs(data) do
            if type(info) == "table" then
                if info.Role == "Murderer" then
                    MM2.Murderer = playerName
                elseif info.Role == "Sheriff" then
                    MM2.Sheriff = playerName
                elseif info.Role == "Hero" then
                    MM2.Hero = playerName
                end
            end
        end
        
        return data
    end
    
    return {}
end

function MM2.IsPlayerAlive(player)
    if not player then return false end
    
    local playerName = type(player) == "string" and player or player.Name
    
    if MM2.RoleData[playerName] then
        local data = MM2.RoleData[playerName]
        if type(data) == "table" and (data.Killed or data.Dead) then
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
    
    if MM2.RoleData[playerName] then
        local data = MM2.RoleData[playerName]
        if type(data) == "table" and data.HasGun then
            return true
        end
    end
    
    local plr = type(player) == "string" and Players:FindFirstChild(player) or player
    if plr then
        local function checkContainer(container)
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
        
        if plr.Character and checkContainer(plr.Character) then return true end
        if plr:FindFirstChild("Backpack") and checkContainer(plr.Backpack) then return true end
    end
    
    return false
end

function MM2.HasKnife(player)
    if not player then return false end
    
    local plr = type(player) == "string" and Players:FindFirstChild(player) or player
    if plr then
        local function checkContainer(container)
            if not container then return false end
            for _, tool in pairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    if name:find("knife") then
                        return true
                    end
                end
            end
            return false
        end
        
        if plr.Character and checkContainer(plr.Character) then return true end
        if plr:FindFirstChild("Backpack") and checkContainer(plr.Backpack) then return true end
    end
    
    return false
end

function MM2.GetRole(player)
    if not player then return "Innocent" end
    
    local playerName = type(player) == "string" and player or player.Name
    
    if MM2.RoleData[playerName] then
        local data = MM2.RoleData[playerName]
        if type(data) == "table" and data.Role then
            return data.Role
        end
    end
    
    if playerName == MM2.Murderer then
        return "Murderer"
    elseif playerName == MM2.Sheriff then
        return "Sheriff"
    elseif playerName == MM2.Hero then
        return "Hero"
    end
    
    if MM2.HasKnife(player) then
        return "Murderer"
    elseif MM2.HasGun(player) then
        if MM2.Sheriff and not MM2.IsPlayerAlive(MM2.Sheriff) then
            return "Hero"
        end
        return "Sheriff"
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
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and obj:FindFirstChild("Handle")) then
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
    
    if drop:IsA("BasePart") then
        return drop.Position
    end
    
    local handle = drop:FindFirstChild("Handle")
    if handle then return handle.Position end
    
    local part = drop:FindFirstChildOfClass("BasePart")
    if part then return part.Position end
    
    if drop:IsA("Model") and drop.PrimaryPart then
        return drop.PrimaryPart.Position
    end
    
    return nil
end

function MM2.GrabDrop(drop)
    if not LocalPlayer.Character then return end
    
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local handle = drop:FindFirstChild("Handle") or drop:FindFirstChildOfClass("BasePart")
    if not handle then return end
    
    if MM2.Settings.TeleportPickup then
        local oldCFrame = hrp.CFrame
        hrp.CFrame = handle.CFrame * CFrame.new(0, 3, 0)
        task.wait(0.15)
        hrp.CFrame = oldCFrame
    else
        pcall(function()
            if firetouchinterest then
                firetouchinterest(hrp, handle, 0)
                task.wait()
                firetouchinterest(hrp, handle, 1)
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
            if not LocalPlayer.Character then return end
            
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local myRole = MM2.GetRole(LocalPlayer)
            if myRole == "Murderer" then return end
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
            if not LocalPlayer.Character then return end
            
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
        if tick() - MM2.LastRefresh >= 2 then
            MM2.LastRefresh = tick()
            MM2.GetPlayerData()
        end
    end)
end

function MM2.Cleanup()
    for _, conn in pairs(MM2.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    MM2.Loops = {}
    MM2.RoleData = {}
end

return MM2
