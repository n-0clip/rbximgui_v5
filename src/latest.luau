local LoadStartTime = tick()

local repo = "https://raw.githubusercontent.com/n-0clip/killfeed-lib/main/"
local coreRepo = "https://raw.githubusercontent.com/n-0clip/killfeed.cc/main/"

if getgenv().KillfeedLoaded then
    local TempNotifier = loadstring(game:HttpGet(coreRepo .. "src/lib/lib_v2.luau"))().newNotify()
    TempNotifier.new({
        Title = "killfeed.cc",
        Content = "killfeed.cc is already running!",
        Duration = 5,
        Icon = "rbxassetid://95816097006870"
    })
    return
end
getgenv().KillfeedLoaded = true

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

local FrameTimer, FrameCounter, FPS = tick(), 0, 30

local ConfigManager = Compkiller:ConfigManager({
    Directory = "killfeed_cc",
    Config = "default"
})

local Window = Compkiller.new({
    Name = "killfeed.cc",
    Keybind = "RightShift",
    Logo = "rbxassetid://95816097006870",
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
    ExecutorName = identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "Unknown"
end)

local Watermark = Window:Watermark()
Watermark:AddText({Icon = "user", Text = LocalPlayer.Name})
Watermark:AddText({Icon = "terminal", Text = ExecutorName})
local TimeText = Watermark:AddText({Icon = "clock", Text = "TIME"})
task.spawn(function() while true do task.wait(1) TimeText:SetText(Compkiller:GetTimeNow()) end end)
Watermark:AddText({Icon = "gamepad-2", Text = Core.GameName})
local FPSPingText = Watermark:AddText({Icon = "activity", Text = "0 fps | 0 ms"})

RunService.RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
        pcall(function()
            FPSPingText:SetText(string.format('%s fps | %s ms', math.floor(FPS), math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())))
        end)
    end
end)

local FOVCircle = Core.CreateDrawing("Circle", {Thickness = 1, Filled = false, Transparency = 1, Visible = false})
local TargetCircle = Core.CreateDrawing("Circle", {Thickness = 2, Filled = false, Radius = 5, Visible = false, Color = Color3.new(1, 0, 0)})

local function SafeClick()
    if IsMobile then
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.defer(function() VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1) end)
        end)
    else
        pcall(function() if mouse1click then mouse1click() end end)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- COMBAT TAB
-- ═══════════════════════════════════════════════════════════════

Window:DrawCategory({Name = "Combat", Icon = "swords"})
local CombatTab = Window:DrawContainerTab({Name = "Combat", Icon = "swords"})

local AimTab = CombatTab:DrawTab({Name = "Aimbot", Icon = "crosshair", Type = "Double"})
local AimSection = AimTab:DrawSection({Name = "Aimbot", Position = 'left', Icon = "target"})
local AimVisSection = AimTab:DrawSection({Name = "FOV Circle", Position = 'right', Icon = "circle"})

AimSection:AddToggle({
    Name = "Aim Enabled", Text = "Enabled", Default = false, 
    Callback = function(v) Core.Aim.Settings.Enabled = v end
}).Link:AddKeybind({Name = "Aim Key", Default = IsMobile and "Q" or "MB2", Mode = "Hold"})

AimSection:AddToggle({Name = "Sticky Aim", Text = "Sticky Aim", Default = false, Callback = function(v) Core.Aim.Settings.StickyAim = v end})
AimSection:AddToggle({Name = "Visibility Check", Text = "Visibility Check", Default = true, Callback = function(v) Core.Aim.Settings.VisibleCheck = v end})
AimSection:AddToggle({Name = "Aim Team Check", Text = "Team Check", Default = true, Callback = function(v) Core.Aim.Settings.TeamCheck = v end})
AimSection:AddDropdown({Name = "Aim Part", Text = "Aim Part", Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = "Head", Callback = function(v) Core.Aim.Settings.AimPart = v end})
AimSection:AddSlider({Name = "Aim FOV", Text = "FOV", Default = 100, Min = 10, Max = 500, Round = 0, Callback = function(v) Core.Aim.Settings.FOV = v end})
AimSection:AddSlider({Name = "Smoothness", Text = "Smoothness", Default = 5, Min = 1, Max = 20, Round = 1, Callback = function(v) Core.Aim.Settings.Smoothness = v end})
AimSection:AddSlider({Name = "Prediction", Text = "Prediction", Default = 0, Min = 0, Max = 20, Round = 1, Callback = function(v) Core.Aim.Settings.Prediction = v end})

local DrawFOV = AimVisSection:AddToggle({Name = "Draw FOV", Text = "Draw FOV", Default = not IsMobile})
DrawFOV.Link:AddColorPicker({Name = "FOV Color", Default = Color3.new(1, 1, 1)})
AimVisSection:AddColorPicker({Name = "Target Color", Text = "Target Color", Default = Color3.new(1, 0, 0)})

local TriggerSection = CombatTab:DrawTab({Name = "Triggerbot", Icon = "zap", Type = "Single"})
local TriggerSec = TriggerSection:DrawSection({Name = "Triggerbot", Position = 'left', Icon = "bolt"})

TriggerSec:AddToggle({
    Name = "Trigger Enabled", Text = "Enabled", Default = false, 
    Callback = function(v) Core.Aim.TriggerSettings.Enabled = v end
}).Link:AddKeybind({Name = "Trigger Key", Default = IsMobile and "E" or "MB2", Mode = "Hold"})
TriggerSec:AddToggle({Name = "Trigger Team Check", Text = "Team Check", Default = true, Callback = function(v) Core.Aim.TriggerSettings.TeamCheck = v end})
TriggerSec:AddSlider({Name = "Trigger Delay", Text = "Delay (ms)", Default = 0, Min = 0, Max = 500, Round = 0, Callback = function(v) Core.Aim.TriggerSettings.Delay = v end})

-- ═══════════════════════════════════════════════════════════════
-- VISUALS TAB
-- ═══════════════════════════════════════════════════════════════

Window:DrawCategory({Name = "Visuals", Icon = "scan"})
local VisualsTab = Window:DrawContainerTab({Name = "Visuals", Icon = "scan"})

local ESPTab = VisualsTab:DrawTab({Name = "ESP", Icon = "scan-eye", Type = "Double"})
local ESPMain = ESPTab:DrawSection({Name = "Players", Position = 'left', Icon = "users"})
local ESPExtra = ESPTab:DrawSection({Name = "Extras", Position = 'right', Icon = "sparkles"})

ESPMain:AddToggle({Name = "ESP Enabled", Text = "Enabled", Default = false, Callback = function(v) Core.ESP.Settings.Enabled = v end})
ESPMain:AddToggle({Name = "ESP Team Check", Text = "Team Check", Default = false, Callback = function(v) Core.ESP.Settings.TeamCheck = v end})
ESPMain:AddToggle({Name = "Box", Text = "Box", Default = false, Callback = function(v) Core.ESP.Settings.Box.Enabled = v end}).Link:AddColorPicker({Name = "Box Color", Default = Color3.new(1, 1, 1), Callback = function(v) Core.ESP.Settings.Box.Color = v end})
ESPMain:AddToggle({Name = "Corner Box", Text = "Corner Box", Default = false, Callback = function(v) Core.ESP.Settings.CornerBox.Enabled = v end}).Link:AddColorPicker({Name = "Corner Color", Default = Color3.new(1, 1, 1), Callback = function(v) Core.ESP.Settings.CornerBox.Color = v end})
ESPMain:AddToggle({Name = "Name ESP", Text = "Name", Default = false, Callback = function(v) Core.ESP.Settings.Name.Enabled = v end}).Link:AddColorPicker({Name = "Name Color", Default = Color3.new(1, 1, 1), Callback = function(v) Core.ESP.Settings.Name.Color = v end})
ESPMain:AddToggle({Name = "Health Bar", Text = "Health Bar", Default = false, Callback = function(v) Core.ESP.Settings.Health.Enabled = v end})
ESPMain:AddToggle({Name = "Distance ESP", Text = "Distance", Default = false, Callback = function(v) Core.ESP.Settings.Distance.Enabled = v end})

ESPExtra:AddToggle({Name = "Skeleton", Text = "Skeleton", Default = false, Callback = function(v) Core.ESP.Settings.Skeleton.Enabled = v end}).Link:AddColorPicker({Name = "Skeleton Color", Default = Color3.new(1, 1, 1), Callback = function(v) Core.ESP.Settings.Skeleton.Color = v end})
ESPExtra:AddToggle({Name = "Tracers", Text = "Tracers", Default = false, Callback = function(v) Core.ESP.Settings.Tracers.Enabled = v end}).Link:AddColorPicker({Name = "Tracers Color", Default = Color3.new(1, 1, 1), Callback = function(v) Core.ESP.Settings.Tracers.Color = v end})
ESPExtra:AddToggle({Name = "Head Dot", Text = "Head Dot", Default = false, Callback = function(v) Core.ESP.Settings.HeadDot.Enabled = v end}).Link:AddColorPicker({Name = "Head Dot Color", Default = Color3.new(1, 0, 0), Callback = function(v) Core.ESP.Settings.HeadDot.Color = v end})
ESPExtra:AddToggle({Name = "Off Screen Arrows", Text = "Off Screen Arrows", Default = false, Callback = function(v) Core.ESP.Settings.OffScreenArrows.Enabled = v end}).Link:AddColorPicker({Name = "Arrow Color", Default = Color3.new(1, 0, 0), Callback = function(v) Core.ESP.Settings.OffScreenArrows.Color = v end})
ESPExtra:AddSlider({Name = "Max Distance", Text = "Max Distance", Default = 2000, Min = 100, Max = 5000, Round = 0, Callback = function(v) Core.ESP.Settings.MaxDistance = v end})

local ChamsSection = VisualsTab:DrawTab({Name = "Chams", Icon = "box", Type = "Single"})
local ChamsBox = ChamsSection:DrawSection({Name = "Chams", Position = 'left', Icon = "box"})
ChamsBox:AddToggle({Name = "Chams Enabled", Text = "Enabled", Default = false, Callback = function(v) Core.ESP.Settings.Chams.Enabled = v end})
ChamsBox:AddColorPicker({Name = "Chams Fill", Text = "Fill Color", Default = Color3.fromRGB(212, 133, 240), Callback = function(v) Core.ESP.Settings.Chams.FillColor = v end})
ChamsBox:AddColorPicker({Name = "Chams Outline", Text = "Outline Color", Default = Color3.fromRGB(255, 255, 255), Callback = function(v) Core.ESP.Settings.Chams.OutlineColor = v end})
ChamsBox:AddSlider({Name = "Chams Transparency", Text = "Transparency", Default = 0.5, Min = 0, Max = 1, Round = 2, Callback = function(v) Core.ESP.Settings.Chams.FillTransparency = v end})

-- ═══════════════════════════════════════════════════════════════
-- WORLD TAB
-- ═══════════════════════════════════════════════════════════════

Window:DrawCategory({Name = "World", Icon = "globe"})
local WorldTab = Window:DrawContainerTab({Name = "World", Icon = "globe"})

local LightingSection = WorldTab:DrawTab({Name = "Environment", Icon = "sun", Type = "Single"})
local WorldBox = LightingSection:DrawSection({Name = "Lighting", Position = 'left', Icon = "lightbulb"})
WorldBox:AddToggle({Name = "Fullbright", Text = "Fullbright", Default = false, Callback = function(v) Core.SetFullbright(v) end})
WorldBox:AddToggle({Name = "No Fog", Text = "No Fog", Default = false, Callback = function(v) Core.SetNoFog(v) end})
WorldBox:AddSlider({Name = "Time", Text = "Time", Default = 12, Min = 0, Max = 24, Round = 1, Callback = function(v) Core.SetTime(v) end})

local MoveSection = WorldTab:DrawTab({Name = "Movement", Icon = "footprints", Type = "Single"})
local MoveBox = MoveSection:DrawSection({Name = "Movement", Position = 'left', Icon = "person-running"})
MoveBox:AddToggle({Name = "Speed", Text = "Speed", Default = false, Callback = function(v) if Core.Game and Core.Game.SetSpeed then Core.Game.SetSpeed(v, Options["Speed Value"].Value) end end})
MoveBox:AddSlider({Name = "Speed Value", Text = "Speed Value", Default = 16, Min = 16, Max = 150, Callback = function(v) if Core.Game and Core.Game.Settings and Core.Game.Settings.Speed then Core.Game.Settings.Speed.Value = v end end})
MoveBox:AddToggle({Name = "High Jump", Text = "High Jump", Default = false, Callback = function(v) if Core.Game and Core.Game.SetJump then Core.Game.SetJump(v, Options["Jump Power"].Value) end end})
MoveBox:AddSlider({Name = "Jump Power", Text = "Jump Power", Default = 50, Min = 50, Max = 200, Callback = function(v) if Core.Game and Core.Game.Settings and Core.Game.Settings.Jump then Core.Game.Settings.Jump.Value = v end end})
MoveBox:AddToggle({Name = "Noclip", Text = "Noclip", Default = false, Callback = function(v) if Core.Game and Core.Game.SetNoclip then Core.Game.SetNoclip(v) end end}).Link:AddKeybind({Name = "Noclip Key", Default = "N", Mode = "Toggle"})

-- ═══════════════════════════════════════════════════════════════
-- GAME TAB
-- ═══════════════════════════════════════════════════════════════

Window:DrawCategory({Name = "Game", Icon = "gamepad-2"})
local GameTab = Window:DrawContainerTab({Name = "Game", Icon = "gamepad-2"})

local GameUnivSection = GameTab:DrawTab({Name = "Universal", Icon = "home"})
local GameUniv = GameUnivSection:DrawSection({Name = "Server", Position = 'left', Icon = "server"})
GameUniv:AddButton({Name = "Rejoin", Text = "Rejoin Server", Callback = function() Core.Rejoin() end})
GameUniv:AddButton({Name = "Copy Join", Text = "Copy Join Script", Callback = function()
    if setclipboard then setclipboard(Core.GetJoinScript()) end
    Notifier.new({Title = "Copied", Content = "Join script copied to clipboard"})
end})

if Core.GameId == "counter-blox" then
    local CBTab = GameTab:DrawTab({Name = "Counter Blox", Icon = "gun", Type = "Double"})
    local CBWeapon = CBTab:DrawSection({Name = "Weapon", Position = 'left', Icon = "crosshair"})
    local CBMove = CBTab:DrawSection({Name = "Movement", Position = 'center', Icon = "footprints"})
    local CBCamera = CBTab:DrawSection({Name = "Camera", Position = 'right', Icon = "video"})

    CBWeapon:AddToggle({Name = "No Spread", Text = "No Spread", Default = false, Callback = function(v) Core.Game.NoSpread(v) end})
    CBWeapon:AddToggle({Name = "No Recoil", Text = "No Recoil", Default = false, Callback = function(v) Core.Game.NoRecoil(v) end})
    CBWeapon:AddToggle({Name = "Rapid Fire", Text = "Rapid Fire", Default = false, Callback = function(v) Core.Game.RapidFire(v) end})
    CBWeapon:AddToggle({Name = "Infinite Ammo", Text = "Infinite Ammo", Default = false, Callback = function(v) Core.Game.InfAmmo(v) end})

    CBMove:AddToggle({Name = "Bunny Hop", Text = "Bunny Hop", Default = false, Callback = function(v) Core.Game.BHop(v) end})
    CBMove:AddSlider({Name = "BHop Speed", Text = "Speed", Default = 20, Min = 0, Max = 100, Round = 0, Callback = function(v) Core.Game.SetBHopSpeed(v) end})
    CBMove:AddToggle({Name = "Spinbot", Text = "Spinbot", Default = false, Callback = function(v) Core.Game.Spinbot(v) end})
    CBMove:AddSlider({Name = "Spin Speed", Text = "Spin Speed", Default = 50, Min = 10, Max = 100, Round = 0, Callback = function(v) Core.Game.SetSpinSpeed(v) end})

    CBCamera:AddToggle({Name = "Third Person", Text = "Third Person", Default = false, Callback = function(v) Core.Game.ThirdPerson(v) end}).Link:AddKeybind({Name = "TP Key", Default = "V", Mode = "Toggle"})
    CBCamera:AddSlider({Name = "TP Distance", Text = "Distance", Default = 10, Min = 5, Max = 30, Round = 0, Callback = function(v) Core.Game.SetThirdPersonDistance(v) end})
end

if Core.GameId == "murder-mystery-2" then
    local MM2 = Core.Game
    
    if MM2 then
        MM2.Init(Core)
        
        local MM2Tab = GameTab:DrawTab({Name = "Murder Mystery 2", Icon = "skull", Type = "Double"})
        local MM2Roles = MM2Tab:DrawSection({Name = "Roles", Position = 'left', Icon = "users"})
        local MM2Pickup = MM2Tab:DrawSection({Name = "Pickup", Position = 'center', Icon = "hand"})
        local MM2Colors = MM2Tab:DrawSection({Name = "Colors", Position = 'right', Icon = "palette"})

		MM2Roles:AddToggle({Name = "Role Colors", Text = "Role Colors ESP", Default = false, Callback = function(v) 
			Core.ESP.Settings.UseRoleColors = v
		end})
        
        MM2Roles:AddButton({Name = "Refresh", Text = "Refresh Roles", Callback = function() 
            MM2.RefreshRoles()
            Notifier.new({Title = "MM2", Content = "Roles refreshed!", Duration = 3})
        end})

        MM2Pickup:AddToggle({Name = "Auto Gun", Text = "Auto Pickup Gun", Default = false, Callback = function(v) MM2.AutoPickupGun(v) end})
        MM2Pickup:AddToggle({Name = "Auto Knife", Text = "Auto Pickup Knife", Default = false, Callback = function(v) MM2.AutoPickupKnife(v) end})
        MM2Pickup:AddToggle({Name = "TP Pickup", Text = "Teleport Pickup", Default = false, Callback = function(v) MM2.SetTeleportPickup(v) end})
        MM2Pickup:AddSlider({Name = "Grab Range", Text = "Grab Range", Default = 15, Min = 5, Max = 50, Round = 0, Callback = function(v) MM2.SetGrabRange(v) end})
		MM2Colors:AddColorPicker({Name = "Murderer", Text = "Murderer", Default = Color3.fromRGB(255, 0, 0), Callback = function(v) 
			Core.ESP.MM2.Colors.Murderer = v 
		end})
		MM2Colors:AddColorPicker({Name = "Sheriff", Text = "Sheriff", Default = Color3.fromRGB(0, 100, 255), Callback = function(v) 
			Core.ESP.MM2.Colors.Sheriff = v 
		end})
		MM2Colors:AddColorPicker({Name = "Innocent", Text = "Innocent", Default = Color3.fromRGB(0, 255, 0), Callback = function(v) 
			Core.ESP.MM2.Colors.Innocent = v 
		end})
		MM2Colors:AddColorPicker({Name = "Hero", Text = "Hero", Default = Color3.fromRGB(255, 255, 0), Callback = function(v) 
			Core.ESP.MM2.Colors.Hero = v 
		end})
    end
end

-- ═══════════════════════════════════════════════════════════════
-- LOOPS
-- ═══════════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    pcall(function()
        local drawFOV = Options["Draw FOV"] and Options["Draw FOV"].Value
        local aimEnabled = Options["Aim Enabled"] and Options["Aim Enabled"].Value
        
        FOVCircle.Visible = drawFOV and aimEnabled
        FOVCircle.Radius = Options["Aim FOV"] and Options["Aim FOV"].Value or 100
        FOVCircle.Color = Options["FOV Color"] and Options["FOV Color"].Value or Color3.new(1, 1, 1)
        FOVCircle.Position = UserInputService:GetMouseLocation()
        TargetCircle.Color = Options["Target Color"] and Options["Target Color"].Value or Color3.new(1, 0, 0)
    end)
end)

RunService.Heartbeat:Connect(function()
    local aimEnabled = Options["Aim Enabled"] and Options["Aim Enabled"].Value
    local aimKeyHeld = Options["Aim Key"] and Options["Aim Key"]:GetState()
    
    if aimEnabled and aimKeyHeld then
        local stickyAim = Options["Sticky Aim"] and Options["Sticky Aim"].Value
        
        if stickyAim and Core.Aim.LockedTarget and Core.Aim.IsAlive(Core.Aim.LockedTarget) then
            Core.Aim.AimAt(Core.Aim.LockedTarget, TargetCircle)
        else
            local target = Core.Aim.GetClosestPlayer()
            if target then
                Core.Aim.LockedTarget = target
                Core.Aim.AimAt(target, TargetCircle)
            else
                Core.Aim.LockedTarget = nil
                pcall(function() TargetCircle.Visible = false end)
            end
        end
    else
        Core.Aim.LockedTarget = nil
        pcall(function() TargetCircle.Visible = false end)
    end
    
    local triggerEnabled = Options["Trigger Enabled"] and Options["Trigger Enabled"].Value
    local triggerKeyHeld = Options["Trigger Key"] and Options["Trigger Key"]:GetState()
    
    if triggerEnabled and triggerKeyHeld then
        local target = Core.Aim.GetTriggerTarget()
        if target then
            local delay = Options["Trigger Delay"] and Options["Trigger Delay"].Value or 0
            if delay > 0 then
                task.delay(delay / 1000, SafeClick)
            else
                SafeClick()
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════

local SettingsTab = Window:DrawContainerTab({Name = "Settings", Icon = "settings"})

local SettingTab = SettingsTab:DrawTab({Icon = "sliders-horizontal", Name = "Settings", Type = "Single", EnableScrolling = true})
local ThemeTab = SettingsTab:DrawTab({Icon = "palette", Name = "Themes", Type = "Single"})

local Settings = SettingTab:DrawSection({Name = "UI Settings", Position = 'left', Icon = "wrench"})

Settings:AddToggle({Name = "Always Show", Text = "Always Show Frame", Default = false, Callback = function(v) Window.AlwayShowTab = v end})

Settings:AddColorPicker({Name = "Highlight", Text = "Highlight", Default = Compkiller.Colors.Highlight, Callback = function(v) Compkiller.Colors.Highlight = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "Toggle Color", Text = "Toggle Color", Default = Compkiller.Colors.Toggle, Callback = function(v) Compkiller.Colors.Toggle = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "Drop Color", Text = "Drop Color", Default = Compkiller.Colors.DropColor, Callback = function(v) Compkiller.Colors.DropColor = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "Block Color", Text = "Block Color", Default = Compkiller.Colors.BlockColor, Callback = function(v) Compkiller.Colors.BlockColor = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "Background", Text = "Background", Default = Compkiller.Colors.BGDBColor, Callback = function(v) Compkiller.Colors.BGDBColor = v Compkiller:RefreshCurrentColor() end})
Settings:AddColorPicker({Name = "Stroke", Text = "Stroke", Default = Compkiller.Colors.StrokeColor, Callback = function(v) Compkiller.Colors.StrokeColor = v Compkiller:RefreshCurrentColor() end})

Settings:AddButton({Name = "Get Theme", Text = "Copy Theme", Callback = function()
    print(Compkiller:GetTheme())
    Notifier.new({Title = "Theme", Content = "Theme copied to clipboard", Duration = 3})
end})

ThemeTab:DrawSection({Name = "Themes", Position = 'left', Icon = "brush"}):AddDropdown({
    Name = "Theme", Text = "Select Theme", Default = "Default",
    Values = {"Default", "Dark Green", "Dark Blue", "Purple Rose", "Skeet"},
    Callback = function(v) Compkiller:SetTheme(v) end
})

local ConfigUI = Window:DrawConfig({Name = "Config", Icon = "folder", Config = ConfigManager})
ConfigUI:Init()
