local Core = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

Core.Aim = nil
Core.ESP = nil
Core.Game = nil

Core.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

Core.SupportedGames = {
    [301549746] = "counter-blox"
}

Core.PlaceId = game.PlaceId
Core.GameId = Core.SupportedGames[Core.PlaceId] or "universal"
Core.GameName = Core.GameId == "counter-blox" and "Counter Blox" or "Universal"

Core.Loops = {}
Core.LockedTarget = nil

function Core.LoadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success and result then
        return result
    end
    warn("[Core] Failed to load: " .. url)
    return nil
end

function Core.CreateDrawing(t, props)
    local success, d = pcall(function() return Drawing.new(t) end)
    if not success or not d then
        return {Visible = false, Remove = function() end, Position = Vector2.new(), Radius = 0, Color = Color3.new()}
    end
    for k, v in pairs(props or {}) do pcall(function() d[k] = v end) end
    return d
end

function Core.GetMousePosition()
    if Core.IsMobile then
        return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    local success, pos = pcall(function() return UserInputService:GetMouseLocation() end)
    return success and pos or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

function Core.IsAlive(plr)
    if not plr or not plr.Character then return false end
    local h = plr.Character:FindFirstChild("Humanoid")
    return h and h.Health > 0
end

function Core.IsVisible(part)
    if not part then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), params)
    if result then return result.Instance:IsDescendantOf(part.Parent) end
    return true
end

function Core.GetCurrentGun()
    if not Core.IsAlive(LocalPlayer) then return nil end
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") then return v end
    end
    return nil
end

function Core.SetTime(time)
    Lighting.ClockTime = time
end

function Core.SetFullbright(enabled)
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
    end
end

function Core.SetNoFog(enabled)
    Lighting.FogEnd = enabled and 100000 or 1000
end

function Core.Rejoin()
    TeleportService:TeleportToPlaceInstance(Core.PlaceId, game.JobId, LocalPlayer)
end

function Core.GetJoinScript()
    return 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. Core.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)'
end

function Core.Init(baseUrl)
    print(banner)
    
    local funcsUrl = baseUrl .. "src/core/funcs/"
    local gamesUrl = baseUrl .. "src/games/"
    
    Core.Aim = Core.LoadModule(funcsUrl .. "aim.luau")
    Core.ESP = Core.LoadModule(funcsUrl .. "esp.luau")
    
    local gameFile = Core.GameId .. ".luau"
    Core.Game = Core.LoadModule(gamesUrl .. gameFile)
    
    if Core.ESP then
        Core.ESP.Init()
    end
    
    if Core.Aim then
        Core.Aim.Init()
    end
    
    if Core.Game then
        Core.Game.Init(Core)
    end
end

function Core.Cleanup()
    for _, conn in pairs(Core.Loops) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    Core.Loops = {}
    
    if Core.IsAlive(LocalPlayer) then
        LocalPlayer.Character.Humanoid.AutoRotate = true
    end
    LocalPlayer.CameraMinZoomDistance = 0.5
    LocalPlayer.CameraMaxZoomDistance = 0.5
    
    if Core.ESP then
        pcall(function() Core.ESP.Destroy() end)
    end
end

return Core
