-- this will be open src
-- soon will be more 

local Universal = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local banner = [[
 __   .__.__  .__   _____                 .___
|  | _|__|  | |  |_/ ____\____   ____   __| _/
|  |/ /  |  | |  |\   __\/ __ \_/ __ \ / __ | 
|    <|  |  |_|  |_|  | \  ___/\  ___// /_/ | 
|__|_ \__|____/____/__|  \___  >\___  >____ | 
     \/                      \/     \/     \/ 
]]

Universal.Core = nil
Universal.Loops = {}

Universal.Settings = {
    Speed = {
        Enabled = false,
        Value = 16
    },
    Jump = {
        Enabled = false,
        Value = 50
    },
    Noclip = {
        Enabled = false
    }
}

function Universal.SetSpeed(enabled, value)
    Universal.Settings.Speed.Enabled = enabled
    if value then Universal.Settings.Speed.Value = value end
end

function Universal.SetJump(enabled, value)
    Universal.Settings.Jump.Enabled = enabled
    if value then Universal.Settings.Jump.Value = value end
end

function Universal.SetNoclip(enabled)
    Universal.Settings.Noclip.Enabled = enabled
end

function Universal.Init(Core)
    print("[Universal] Initialized")
    Universal.Core = Core
    
    Universal.Loops.Main = RunService.Heartbeat:Connect(function()
        if not Core.IsAlive(LocalPlayer) then return end
        
        local char = LocalPlayer.Character
        local hum = char:FindFirstChild("Humanoid")
        
        if Universal.Settings.Speed.Enabled and hum then
            hum.WalkSpeed = Universal.Settings.Speed.Value
        end
        
        if Universal.Settings.Noclip.Enabled then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
    
    UserInputService.JumpRequest:Connect(function()
        if Universal.Settings.Jump.Enabled and Core.IsAlive(LocalPlayer) then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                hum.JumpPower = Universal.Settings.Jump.Value
            end
        end
    end)
end

function Universal.Cleanup()
    for _, conn in pairs(Universal.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    Universal.Loops = {}
end

return Universal
