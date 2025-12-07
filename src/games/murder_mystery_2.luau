local MM2 = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local banner = [[
 __   .__.__  .__   _____                 .___
|  | _|__|  | |  |_/ ____\____   ____   __| _/
|  |/ /  |  | |  |\   __\/ __ \_/ __ \ / __ | 
|    <|  |  |_|  |_|  | \  ___/\  ___// /_/ | 
|__|_ \__|____/____/__|  \___  >\___  >____ | 
     \/                      \/     \/     \/ 
]]

MM2.Core = nil
MM2.Loops = {}
MM2.Roles = {}

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

function MM2.GetRole(player)
    if MM2.Roles[player] then return MM2.Roles[player] end
    
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    local function hasWeapon(container, weaponType)
        if not container then return false end
        for _, v in pairs(container:GetChildren()) do
            if v:IsA("Tool") then
                local name = v.Name:lower()
                if weaponType == "knife" and (name:find("knife") or name == "knife") then return true end
                if weaponType == "gun" and (name:find("gun") or name:find("revolver")) then return true end
            end
        end
        return false
    end
    
    if hasWeapon(char, "knife") or hasWeapon(backpack, "knife") then
        MM2.Roles[player] = "Murderer"
    elseif hasWeapon(char, "gun") or hasWeapon(backpack, "gun") then
        MM2.Roles[player] = "Sheriff"
    else
        MM2.Roles[player] = "Innocent"
    end
    
    return MM2.Roles[player]
end

function MM2.GetRoleColor(player)
    local role = MM2.GetRole(player)
    if role == "Murderer" then return MM2.Settings.MurdererColor end
    if role == "Sheriff" then return MM2.Settings.SheriffColor end
    if role == "Hero" then return MM2.Settings.HeroColor end
    return MM2.Settings.InnocentColor
end

function MM2.GetDrops()
    local drops = {}
    
    for _, obj in pairs(Workspace:GetChildren()) do
        local name = obj.Name:lower()
        if name:find("gun") or name:find("revolver") or name == "gundrop" then
            table.insert(drops, {Object = obj, Type = "Gun"})
        elseif name:find("knife") or name == "knifedrop" then
            table.insert(drops, {Object = obj, Type = "Knife"})
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
    local handle = drop:FindFirstChild("Handle") or drop:FindFirstChildOfClass("BasePart")
    if handle then return handle.Position end
    if drop:IsA("BasePart") then return drop.Position end
    return nil
end

function MM2.GrabDrop(drop)
    if not MM2.Core.IsAlive(LocalPlayer) then return end
    
    local char = LocalPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local handle = drop:FindFirstChild("Handle") or drop:FindFirstChildOfClass("BasePart")
    if not handle then return end
    
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
        MM2.Loops.AutoPickupGun:Disconnect()
        MM2.Loops.AutoPickupGun = nil
    end
    
    if enabled then
        MM2.Loops.AutoPickupGun = RunService.Heartbeat:Connect(function()
            if not MM2.Core.IsAlive(LocalPlayer) then return end
            
            local myRole = MM2.GetRole(LocalPlayer)
            if myRole == "Murderer" then return end
            
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local hasGun = false
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("revolver")) then
                    hasGun = true
                    break
                end
            end
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("revolver")) then
                    hasGun = true
                    break
                end
            end
            
            if hasGun then return end
            
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
        MM2.Loops.AutoPickupKnife:Disconnect()
        MM2.Loops.AutoPickupKnife = nil
    end
    
    if enabled then
        MM2.Loops.AutoPickupKnife = RunService.Heartbeat:Connect(function()
            if not MM2.Core.IsAlive(LocalPlayer) then return end
            
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
    MM2.Roles = {}
end

function MM2.Init(Core)
    MM2.Core = Core
    
    MM2.Loops.RoleRefresh = RunService.Heartbeat:Connect(function()
        task.wait(3)
        MM2.Roles = {}
    end)
end

function MM2.Cleanup()
    for _, conn in pairs(MM2.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    MM2.Loops = {}
    MM2.Roles = {}
end

return MM2
