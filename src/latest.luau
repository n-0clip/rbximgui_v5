local LoadStartTime = tick()

local repo = "https://raw.githubusercontent.com/n-0clip/killfeed-lib/main/"
local coreRepo = "https://raw.githubusercontent.com/n-0clip/killfeed.cc/main/"

local banner = [[
 __   .__.__  .__   _____                 .___
|  | _|__|  | |  |_/ ____\____   ____   __| _/
|  |/ /  |  | |  |\   __\/ __ \_/ __ \ / __ | 
|    <|  |  |_|  |_|  | \  ___/\  ___// /_/ | 
|__|_ \__|____/____/__|  \___  >\___  >____ | 
     \/                      \/     \/     \/ 
]]

local Compkiller = loadstring(game:HttpGet(coreRepo .. "src/lib/lib_v2.luau"))()

local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Core = loadstring(game:HttpGet(coreRepo .. "src/core/core.luau"))()

Compkiller:Loader("rbxassetid://95816097006870", 2.5).yield()
Core.Init(coreRepo)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local platform = IsMobile and "Mobile" or "PC"

local Options = {}
local Toggles = {}

local function getElementValue(name)
    local element = Compkiller.Elements[name]
    if element and element.GetValue then
        return element:GetValue()
    end
    return {Value = false, GetState = function() return false end} 
end
setmetatable(Options, {__index = function(t, k) return getElementValue(k) end})
setmetatable(Toggles, {__index = function(t, k) return getElementValue(k) end})

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 30

local ConfigManager = Compkiller:ConfigManager({
    Directory = "killfeed_cc",
    Config = "default"
})

local Window = Compkiller.new({
    Name = "killfeed.cc",
    Keybind = "RightShift",
    Logo = 95816097006870,
    Scale = Compkiller.Scale.Window,
    TextSize = 15,
})

local Notifier = Compkiller.newNotify()

Notifier.new({
    Title = "killfeed",
    Content = "loaded killfeed.cc | "..Core.GameName,
    Duration = 5,
    Icon = "rbxassetid://95816097006870"
})

local ExecutorName = "Unknown"
pcall(function()
    if identifyexecutor then
        ExecutorName = identifyexecutor() or "Unknown"
    elseif getexecutorname then
        ExecutorName = getexecutorname() or "Unknown"
    end
end)

local Watermark = Window:Watermark()

Watermark:AddText({
    Icon = "user",
    Text = LocalPlayer.Name,
})

Watermark:AddText({
    Icon = "code",
    Text = ExecutorName,
})

local TimeText = Watermark:AddText({Icon = "timer", Text = "TIME"})

task.spawn(function()
    while true do task.wait(1)
        TimeText:SetText(Compkiller:GetTimeNow())
    end
end)

Watermark:AddText({
    Icon = "server",
    Text = Core.GameName,
})

local FPSPingText = Watermark:AddText({
    Icon = "cpu",
    Text = "0 fps | 0 ms"
})

local WatermarkConnection = RunService.RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
        
        pcall(function()
            FPSPingText:SetText(string.format('%s fps | %s ms',
                math.floor(FPS),
                math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
            ))
        end)
    end
end)

local FOVCircle = Core.CreateDrawing("Circle", {Thickness = 1, Filled = false, Transparency = 1, Visible = false})
local TargetCircle = Core.CreateDrawing("Circle", {Thickness = 2, Filled = false, Radius = 5, Visible = false, Color = Color3.new(1, 0, 0)})

local function SafeClick()
    if IsMobile then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.defer(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end)
        end)
    else
        pcall(function()
            if mouse1click then mouse1click() end
        end)
    end
end

Window:DrawCategory({Name = "Aimbot"})
local CombatTab = Window:DrawContainerTab({Name = "Combat"})

local AimTab = CombatTab:DrawTab({
    Name = "Aimbot",
    Type = "Double",
})

local AimSection = AimTab:DrawSection({
    Name = "AIM",
    Position = 'left',
})

local VisSection = AimTab:DrawSection({
    Name = "VISUALS",
    Position = 'right',
})

AimSection:AddToggle({
    Name = "AimEnabled", Text = "Enabled", Default = false, Callback = function(v) Core.Aim.Settings.Enabled = v end
}).Link:AddKeybind({
    Name = "AimKey", Default = IsMobile and "Q" or "MB2", Mode = "Hold"
})

AimSection:AddToggle({Name = "StickyAim", Text = "Sticky Aim", Default = false, Callback = function(v) Core.Aim.Settings.StickyAim = v end})
AimSection:AddToggle({Name = "VisibilityCheck", Text = "Visibility Check", Default = true, Callback = function(v) Core.Aim.Settings.VisibleCheck = v end})
AimSection:AddToggle({Name = "AimTeamCheck", Text = "Team Check", Default = true, Callback = function(v) Core.Aim.Settings.TeamCheck = v end})
AimSection:AddDropdown({Name = "AimPart", Text = "Aim Part", Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "Head", Callback = function(v) Core.Aim.Settings.AimPart = v end})
AimSection:AddSlider({Name = "AimFOV", Text = "FOV", Default = 100, Min = 10, Max = 500, Round = 0, Callback = function(v) Core.Aim.Settings.FOV = v end})
AimSection:AddSlider({Name = "Smoothness", Text = "Smoothness", Default = 5, Min = 1, Max = 20, Round = 1, Callback = function(v) Core.Aim.Settings.Smoothness = v end})
AimSection:AddSlider({Name = "Prediction", Text = "Prediction", Default = 0, Min = 0, Max = 20, Round = 1, Callback = function(v) Core.Aim.Settings.Prediction = v end})

local TriggerSection = CombatTab:DrawTab({
    Name = "Trigger",
    Type = "Single",
})

local TriggerSec = TriggerSection:DrawSection({
    Name = "TRIGGERBOT",
    Position = 'left',
})

TriggerSec:AddToggle({
    Name = "TriggerEnabled", Text = "Enabled", Default = false, Callback = function(v) Core.Aim.TriggerSettings.Enabled = v end
}).Link:AddKeybind({
    Name = "TriggerKey", Default = IsMobile and "E" or "MB2", Mode = "Hold"
})
TriggerSec:AddToggle({Name = "TriggerTeamCheck", Text = "Team Check", Default = true, Callback = function(v) Core.Aim.TriggerSettings.TeamCheck = v end})
TriggerSec:AddSlider({Name = "TriggerDelay", Text = "Delay (ms)", Default = 0, Min = 0, Max = 500, Round = 0, Callback = function(v) Core.Aim.TriggerSettings.Delay = v end})

local DrawFOV = VisSection:AddToggle({Name = "DrawFOV", Text = "Draw FOV", Default = not IsMobile})
DrawFOV.Link:AddColorPicker({Name = "FOVColor", Default = Color3.new(1, 1, 1)})
VisSection:AddColorPicker({Name = "TargetColor", Default = Color3.new(1, 0, 0)})

Window:DrawCategory({Name = "Visuals"})
local VisualsTab = Window:DrawContainerTab({Name = "Visuals"})

local ESPTab = VisualsTab:DrawTab({
    Name = "ESP",
    Type = "Double",
})

local ESPMain = ESPTab:DrawSection({Name = "MAIN", Position = 'left'})
local ESPExtra = ESPTab:DrawSection({Name = "EXTRA", Position = 'right'})

ESPMain:AddToggle({Name = "ESPEnabled", Text = "Enabled", Default = false, Callback = function(v) Core.ESP.Settings.Enabled = v end})
ESPMain:AddToggle({Name = "ESPTeamCheck", Text = "Team Check", Default = true, Callback = function(v) Core.ESP.Settings.TeamCheck = v end})

ESPMain:AddToggle({Name = "Box", Text = "Box", Default = false, Callback = function(v) Core.ESP.Settings.Box.Enabled = v end}).Link:AddColorPicker({Name = "BoxColor", Default = Color3.new(1, 1, 1), Callback = function(v) Core.ESP.Settings.Box.Color = v end})
ESPMain:AddToggle({Name = "Name", Text = "Name", Default = false, Callback = function(v) Core.ESP.Settings.Name.Enabled = v end}).Link:AddColorPicker({Name = "NameColor", Default = Color3.new(1, 1, 1), Callback = function(v) Core.ESP.Settings.Name.Color = v end})
ESPMain:AddToggle({Name = "HealthBar", Text = "Health Bar", Default = false, Callback = function(v) Core.ESP.Settings.Health.Enabled = v end})
ESPMain:AddToggle({Name = "Distance", Text = "Distance", Default = false, Callback = function(v) Core.ESP.Settings.Distance.Enabled = v end})

ESPExtra:AddToggle({Name = "Skeleton", Text = "Skeleton", Default = false, Callback = function(v) Core.ESP.Settings.Skeleton.Enabled = v end}).Link:AddColorPicker({Name = "SkeletonColor", Default = Color3.new(1, 1, 1), Callback = function(v) Core.ESP.Settings.Skeleton.Color = v end})
ESPExtra:AddToggle({Name = "Tracers", Text = "Tracers", Default = false, Callback = function(v) Core.ESP.Settings.Tracers.Enabled = v end}).Link:AddColorPicker({Name = "TracersColor", Default = Color3.new(1, 1, 1), Callback = function(v) Core.ESP.Settings.Tracers.Color = v end})
ESPExtra:AddSlider({Name = "MaxDistance", Text = "Max Distance", Default = 2000, Min = 100, Max = 5000, Round = 0, Callback = function(v) Core.ESP.Settings.MaxDistance = v end})

local ChamsSection = VisualsTab:DrawTab({
    Name = "Chams",
    Type = "Single",
})

local ChamsBox = ChamsSection:DrawSection({Name = "CHAMS", Position = 'left'})
ChamsBox:AddToggle({Name = "Chams", Text = "Enabled", Default = false, Callback = function(v) Core.ESP.Settings.Chams.Enabled = v end})
ChamsBox:AddColorPicker({Name = "ChamsColor", Text = "Fill Color", Default = Color3.fromRGB(212, 133, 240), Callback = function(v) Core.ESP.Settings.Chams.FillColor = v end})
ChamsBox:AddSlider({Name = "ChamsTransparency", Text = "Transparency", Default = 0.5, Min = 0, Max = 1, Round = 2, Callback = function(v) Core.ESP.Settings.Chams.FillTransparency = v end})

Window:DrawCategory({Name = "World"})
local WorldTab = Window:DrawContainerTab({Name = "World"})

local LightingSection = WorldTab:DrawTab({
    Name = "Environment",
    Type = "Single",
})
local WorldBox = LightingSection:DrawSection({Name = "LIGHTING", Position = 'left'})
WorldBox:AddToggle({Name = "Fullbright", Text = "Fullbright", Default = false, Callback = function(v) Core.SetFullbright(v) end})
WorldBox:AddToggle({Name = "NoFog", Text = "No Fog", Default = false, Callback = function(v) Core.SetNoFog(v) end})
WorldBox:AddSlider({Name = "Time", Text = "Time", Default = 12, Min = 0, Max = 24, Round = 1, Callback = function(v) Core.SetTime(v) end})

local MoveSection = WorldTab:DrawTab({
    Name = "Movement",
    Type = "Single",
})
local MoveBox = MoveSection:DrawSection({Name = "MOVEMENT", Position = 'left'})
MoveBox:AddToggle({Name = "Speed", Text = "Speed", Default = false, Callback = function(v) if Core.Game and Core.Game.SetSpeed then Core.Game.SetSpeed(v, Options.SpeedValue.Value) end end})
MoveBox:AddSlider({Name = "SpeedValue", Text = "Speed Value", Default = 16, Min = 16, Max = 150, Callback = function(v) if Core.Game and Core.Game.Settings and Core.Game.Settings.Speed then Core.Game.Settings.Speed.Value = v end end})

MoveBox:AddToggle({Name = "HighJump", Text = "High Jump", Default = false, Callback = function(v) if Core.Game and Core.Game.SetJump then Core.Game.SetJump(v, Options.JumpPower.Value) end end})
MoveBox:AddSlider({Name = "JumpPower", Text = "Jump Power", Default = 50, Min = 50, Max = 200, Callback = function(v) if Core.Game and Core.Game.Settings and Core.Game.Settings.Jump then Core.Game.Settings.Jump.Value = v end end})

MoveBox:AddToggle({Name = "Noclip", Text = "Noclip", Default = false, Callback = function(v) if Core.Game and Core.Game.SetNoclip then Core.Game.SetNoclip(v) end end}).Link:AddKeybind({Name = "NoclipKey", Default = "N", Mode = "Toggle"})

Window:DrawCategory({Name = "Game"})
local GameTab = Window:DrawContainerTab({Name = "Game"})

local GameUnivSection = GameTab:DrawTab({Name = "Universal"})
local GameUniv = GameUnivSection:DrawSection({Name = "SERVER", Position = 'left'})
GameUniv:AddButton({Name = "Rejoin Server", Text = "Rejoin Server", Callback = function() Core.Rejoin() end})
GameUniv:AddButton({Name = "Copy Join Script", Text = "Copy Join Script", Callback = function()
    if setclipboard then setclipboard(Core.GetJoinScript()) end
    Notifier.new({Title = "Notification", Content = "Copied to clipboard"})
end})

if Core.GameId == "counter-blox" then
    local CBTab = GameTab:DrawTab({Name = "Counter Blox", Type = "Double"})
    local CBWeapon = CBTab:DrawSection({Name = "WEAPON", Position = 'left'})
    local CBMove = CBTab:DrawSection({Name = "MOVEMENT", Position = 'center'})
    local CBCamera = CBTab:DrawSection({Name = "CAMERA", Position = 'right'})

    CBWeapon:AddToggle({Name = "NoSpread", Text = "No Spread", Default = false, Callback = function(v) Core.Game.NoSpread(v) end})
    CBWeapon:AddToggle({Name = "NoRecoil", Text = "No Recoil", Default = false, Callback = function(v) Core.Game.NoRecoil(v) end})
    CBWeapon:AddToggle({Name = "RapidFire", Text = "Rapid Fire", Default = false, Callback = function(v) Core.Game.RapidFire(v) end})
    CBWeapon:AddToggle({Name = "InfiniteAmmo", Text = "Infinite Ammo", Default = false, Callback = function(v) Core.Game.InfAmmo(v) end})

    CBMove:AddToggle({Name = "BunnyHop", Text = "Bunny Hop", Default = false, Callback = function(v) Core.Game.BHop(v) end})
    CBMove:AddSlider({Name = "BHopSpeed", Text = "BHop Speed", Default = 20, Min = 0, Max = 100, Round = 0, Callback = function(v) Core.Game.SetBHopSpeed(v) end})
    CBMove:AddToggle({Name = "Spinbot", Text = "Spinbot", Default = false, Callback = function(v) Core.Game.Spinbot(v) end})
    CBMove:AddSlider({Name = "SpinSpeed", Text = "Spin Speed", Default = 50, Min = 10, Max = 100, Round = 0, Callback = function(v) Core.Game.SetSpinSpeed(v) end})

    CBCamera:AddToggle({Name = "ThirdPerson", Text = "Third Person", Default = false, Callback = function(v) Core.Game.ThirdPerson(v) end}).Link:AddKeybind({Name = "ThirdPersonKey", Default = "V", Mode = "Toggle"})
    CBCamera:AddSlider({Name = "TPDistance", Text = "Distance", Default = 10, Min = 5, Max = 30, Round = 0, Callback = function(v) Core.Game.SetThirdPersonDistance(v) end})
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        local drawFOV = Options.DrawFOV and Options.DrawFOV.Value
        
        FOVCircle.Visible = drawFOV and Options.AimEnabled and Options.AimEnabled.Value
        FOVCircle.Radius = Options.AimFOV and Options.AimFOV.Value or 0
        FOVCircle.Color = Options.FOVColor and Options.FOVColor.Value or Color3.new(1, 1, 1)
        FOVCircle.Position = UserInputService:GetMouseLocation()
        TargetCircle.Color = Options.TargetColor and Options.TargetColor.Value or Color3.new(1, 0, 0)
    end)
end)

RunService.Heartbeat:Connect(function()
    if Options.AimEnabled and Options.AimEnabled.Value and Options.AimKey and Options.AimKey:GetState() then
        if Options.StickyAim and Options.StickyAim.Value and Core.Aim.LockedTarget and Core.Aim.IsAlive(Core.Aim.LockedTarget) then
            Core.Aim.AimAt(Core.Aim.LockedTarget, TargetCircle)
        else
            local target = Core.Aim.GetClosestPlayer()
            if target then
                Core.Aim.LockedTarget = target
                Core.Aim.AimAt(target, TargetCircle)
            else
                pcall(function() TargetCircle.Visible = false end)
            end
        end
    else
        Core.Aim.LockedTarget = nil
        pcall(function() TargetCircle.Visible = false end)
    end
    
    if Options.TriggerEnabled and Options.TriggerEnabled.Value and Options.TriggerKey and Options.TriggerKey:GetState() then
        local target = Core.Aim.GetTriggerTarget()
        if target then
            if Options.TriggerDelay and Options.TriggerDelay.Value > 0 then
                task.delay(Options.TriggerDelay.Value / 1000, SafeClick)
            else
                SafeClick()
            end
        end
    end
end)

local SettingsTab = Window:DrawContainerTab({Name = "Settings"})

local SettingTab = SettingsTab:DrawTab({
    Icon = "settings-3",
    Name = "Settings",
    Type = "Single",
    EnableScrolling = true
})

local ThemeTab = SettingsTab:DrawTab({
    Icon = "paintbrush",
    Name = "Themes",
    Type = "Single"
})

local ConfigTab = SettingsTab:DrawTab({
    Icon = "folder",
    Name = "Config",
    Type = "Single"
})

local Settings = SettingTab:DrawSection({
    Name = "UI Settings",
    Position = 'left'
})

Settings:AddToggle({
    Name = "AlwayShowFrame",
    Default = false,
    Callback = function(v)
        Window.AlwayShowTab = v
    end,
})

Settings:AddColorPicker({Name = "Highlight", Default = Compkiller.Colors.Highlight, Callback = function(v) Compkiller.Colors.Highlight = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "ToggleColor", Default = Compkiller.Colors.Toggle, Callback = function(v) Compkiller.Colors.Toggle = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "DropColor", Default = Compkiller.Colors.DropColor, Callback = function(v) Compkiller.Colors.DropColor = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "Risky", Default = Compkiller.Colors.Risky, Callback = function(v) Compkiller.Colors.Risky = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "MouseEnter", Default = Compkiller.Colors.MouseEnter, Callback = function(v) Compkiller.Colors.MouseEnter = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "BlockColor", Default = Compkiller.Colors.BlockColor, Callback = function(v) Compkiller.Colors.BlockColor = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "BackgroundColor", Default = Compkiller.Colors.BGDBColor, Callback = function(v) Compkiller.Colors.BGDBColor = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "BlockBackgroundColor", Default = Compkiller.Colors.BlockBackground, Callback = function(v) Compkiller.Colors.BlockBackground = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "StrokeColor", Default = Compkiller.Colors.StrokeColor, Callback = function(v) Compkiller.Colors.StrokeColor = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "HighStrokeColor", Default = Compkiller.Colors.HighStrokeColor, Callback = function(v) Compkiller.Colors.HighStrokeColor = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "SwitchColor", Default = Compkiller.Colors.SwitchColor, Callback = function(v) Compkiller.Colors.SwitchColor = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "LineColor", Default = Compkiller.Colors.LineColor, Callback = function(v) Compkiller.Colors.LineColor = v Compkiller:RefreshCurrentColor() end})

Settings:AddButton({
    Name = "GetTheme",
    Callback = function()
        print(Compkiller:GetTheme())
        
        Notifier.new({
            Title = "Notification",
            Content = "Copied Theme Color to your clipboard",
            Duration = 5,
            Icon = "rbxassetid://95816097006870"
        })
    end,
})

ThemeTab:DrawSection({
    Name = "UI Themes",
    Position = 'left'
}):AddDropdown({
    Name = "SelectTheme",
    Default = "Default",
    Values = {
        "Default",
        "Dark Green",
        "Dark Blue",
        "Purple Rose",
        "Skeet"
    },
    Callback = function(v)
        Compkiller:SetTheme(v)
    end,
})

local ConfigUI = Window:DrawConfig({
    Name = "Config",
    Icon = "folder",
    Config = ConfigManager
})

ConfigUI:Init()
