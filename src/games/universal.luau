-- this will be open src
-- soon will be more 

local Universal = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local DEFAULT_WALKSPEED = 16
local DEFAULT_JUMPPOWER = 50
local ORIGINAL_GRAVITY = Workspace.Gravity

local banner = [[
 __   .__.__  .__   _____                 .___
|  | _|__|  | |  |_/ ____\____   ____   __| _ /
|  |/ /  |  | |  |\   __\/ __ \_/ __ \ / __ | 
|    <|  |  |_|  |_|  | \  ___/\  ___// /_/ | 
|__|_ \__|____/____/__|  \___  >\___  >____ | 
     \/                      \/     \/     \/ 
]]

Universal.Core = nil
Universal.Loops = {}
Universal.Originals = {}
Universal.Originals.Gravity = ORIGINAL_GRAVITY

Universal.Settings = {
    Speed = {
        Enabled = false,
        Value = 50 
    },
    Jump = {
        Enabled = false,
        Value = 100
    },
    Noclip = {
        Enabled = false
    },
    Fly = {
        Enabled = false,
        Speed = 30
    },
    InfJump = {
        Enabled = false
    }
}

function Universal.SetSpeed(enabled, value)
    Universal.Settings.Speed.Enabled = enabled
    if value then Universal.Settings.Speed.Value = value end
    
    if not enabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and hum.WalkSpeed ~= (Universal.Originals.WalkSpeed or DEFAULT_WALKSPEED) then
             hum.WalkSpeed = Universal.Originals.WalkSpeed or DEFAULT_WALKSPEED
        end
    end
end

function Universal.SetJump(enabled, value)
    Universal.Settings.Jump.Enabled = enabled
    if value then Universal.Settings.Jump.Value = value end
    
    if not enabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum and hum.JumpPower ~= (Universal.Originals.JumpPower or DEFAULT_JUMPPOWER) then
             hum.JumpPower = Universal.Originals.JumpPower or DEFAULT_JUMPPOWER
        end
    end
end

function Universal.SetNoclip(enabled)
    Universal.Settings.Noclip.Enabled = enabled
    
    if not enabled and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end

function Universal.SetFly(enabled, speed)
    Universal.Settings.Fly.Enabled = enabled
    if speed then Universal.Settings.Fly.Speed = speed end
    
    if not enabled then
        Workspace.Gravity = Universal.Originals.Gravity
    else
        Universal.Originals.Gravity = Workspace.Gravity
    end
end

function Universal.SetInfJump(enabled)
    Universal.Settings.InfJump.Enabled = enabled
end

function Universal.SetupOriginals(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        Universal.Originals.WalkSpeed = hum.WalkSpeed
        Universal.Originals.JumpPower = hum.JumpPower
    else
        Universal.Originals.WalkSpeed = DEFAULT_WALKSPEED
        Universal.Originals.JumpPower = DEFAULT_JUMPPOWER
    end
end

function Universal.Init(Core)
    Universal.Core = Core
    
    Universal.SetupOriginals(LocalPlayer.Character)
    
    Universal.Loops.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(char)
        Universal.SetupOriginals(char)
        
        if Universal.Settings.Noclip.Enabled then
             Universal.SetNoclip(true)
        end
    end)

    Universal.Loops.Main = RunService.Heartbeat:Connect(function(dt)
        if not Core.IsAlive(LocalPlayer) then 
            if Universal.Settings.Fly.Enabled then
                Workspace.Gravity = Universal.Originals.Gravity
            end
            return 
        end
        
        local char = LocalPlayer.Character
        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        
        if not hum or not root then return end
        
        if Universal.Settings.Speed.Enabled then
            hum.WalkSpeed = Universal.Settings.Speed.Value
        elseif hum.WalkSpeed ~= Universal.Originals.WalkSpeed then
            hum.WalkSpeed = Universal.Originals.WalkSpeed or DEFAULT_WALKSPEED
        end
        
        if Universal.Settings.Noclip.Enabled then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
        
        if Universal.Settings.Fly.Enabled then
            Workspace.Gravity = 0
            
            local direction = hum.MoveDirection
            local speed = Universal.Settings.Fly.Speed
            
            if direction.Magnitude > 0 then
                root.CFrame = root.CFrame + direction * speed * dt
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                root.CFrame = root.CFrame + Vector3.new(0, speed * dt, 0)
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                root.CFrame = root.CFrame - Vector3.new(0, speed * dt, 0)
            end
            
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        if Universal.Settings.InfJump.Enabled then
            if hum:GetState() == Enum.HumanoidStateType.Landed or hum:GetState() == Enum.HumanoidStateType.Freefall then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)
    
    UserInputService.JumpRequest:Connect(function()
        if Universal.Settings.Jump.Enabled and Core.IsAlive(LocalPlayer) then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.JumpPower = Universal.Settings.Jump.Value
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    
    Universal.Loops.JumpReset = RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and not Universal.Settings.Jump.Enabled then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            local originalJump = Universal.Originals.JumpPower or DEFAULT_JUMPPOWER
            if hum and hum.JumpPower ~= originalJump then
                hum.JumpPower = originalJump
            end
        end
    end)
end

function Universal.Cleanup()
    
    local originalSpeed = Universal.Originals.WalkSpeed or DEFAULT_WALKSPEED
    local originalJump = Universal.Originals.JumpPower or DEFAULT_JUMPPOWER
    
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = originalSpeed
            hum.JumpPower = originalJump
        end
        
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
    
    Workspace.Gravity = Universal.Originals.Gravity
    
    for _, conn in pairs(Universal.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    
    Universal.Loops = {}
    Universal.Originals = {}
    Universal.Originals.Gravity = ORIGINAL_GRAVITY
    
    Universal.Settings.Speed.Enabled = false
    Universal.Settings.Jump.Enabled = false
    Universal.Settings.Noclip.Enabled = false
    Universal.Settings.Fly.Enabled = false
    Universal.Settings.InfJump.Enabled = false
end

return Universal
