local LoadStartTime = tick()

local repo = "https://raw.githubusercontent.com/n-0clip/killfeed-lib/main/"
local coreRepo = "https://raw.githubusercontent.com/n-0clip/killfeed.cc/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Core = loadstring(game:HttpGet(coreRepo .. "src/core/core.luau"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local platform = IsMobile and "Mobile" or "PC"

Core.Init()

local Options = Library.Options
local Toggles = Library.Toggles

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 30

Library.ForceCheckbox = false 
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "killfeed.cc",
    Footer = Core.GameName,
    Icon = 95816097006870,
    NotifySide = "Right",
    IconSize = UDim2.fromOffset(35, 35),
    AutoShow = true,
    Center = true,
    ShowCustomCursor = false,
    Resizable = true,
    CornerRadius = 9,
    GlobalSearch = true,
    Size = UDim2.fromOffset(IsMobile and 500 or 600, IsMobile and 400 or 480),
    SearchbarSize = UDim2.new(1, 5, 1, 5),
    ToggleKeybind = Enum.KeyCode.RightShift
})

Library:SetWatermarkVisibility(true)
Window:SetSidebarWidth(50)

local LoadTime = tick() - LoadStartTime

task.wait(0.5)

Library:Notify("loaded killfeed.cc | " .. platform .. " | " .. string.format("%.2f", LoadTime) .. "s", 5)

local WatermarkConnection = RunService.RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
 
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    
    Library:SetWatermark(string.format('%s (%s) | %s fps | %s ms',
        LocalPlayer.Name,
        identifyexecutor(),
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

local Tabs = {
    Combat = Window:AddTab("Combat", "crosshair"),
    Visuals = Window:AddTab("Visuals", "eye"),
    World = Window:AddTab("World", "globe"),
    Game = Window:AddTab("Game", "gamepad-2"),
    Settings = Window:AddTab("Settings", "settings")
}

local FOVCircle = Core.CreateDrawing("Circle", {Thickness = 1, Filled = false, Transparency = 1, Visible = false})
local TargetCircle = Core.CreateDrawing("Circle", {Thickness = 2, Filled = false, Radius = 5, Visible = false, Color = Color3.new(1,0,0)})

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

-- Combat Tab
local CombatTabBox = Tabs.Combat:AddLeftTabbox("Combat")
local AimTab = CombatTabBox:AddTab("Aimbot")
local TriggerTab = CombatTabBox:AddTab("Trigger")

AimTab:AddToggle("Aim_On", {Text = "Enabled", Default = false, Callback = function(v) Core.AimbotSettings.Enabled = v end}):AddKeyPicker("Aim_Key", {Default = IsMobile and "Q" or "MB2", Mode = "Hold", Text = "Aim Key"})
AimTab:AddToggle("Aim_Sticky", {Text = "Sticky Aim", Default = false, Callback = function(v) Core.AimbotSettings.StickyAim = v end})
AimTab:AddToggle("Aim_Vis", {Text = "Visibility Check", Default = true, Callback = function(v) Core.AimbotSettings.VisibleCheck = v end})
AimTab:AddToggle("Aim_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.AimbotSettings.TeamCheck = v end})
AimTab:AddDropdown("Aim_Part", {Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = 1, Text = "Aim Part", Callback = function(v) Core.AimbotSettings.AimPart = v end})
AimTab:AddSlider("Aim_FOV", {Text = "FOV", Default = 100, Min = 10, Max = 500, Rounding = 0, Callback = function(v) Core.AimbotSettings.FOV = v end})
AimTab:AddSlider("Aim_Smooth", {Text = "Smoothness", Default = 5, Min = 1, Max = 20, Rounding = 1, Callback = function(v) Core.AimbotSettings.Smoothness = v end})
AimTab:AddSlider("Aim_Pred", {Text = "Prediction", Default = 0, Min = 0, Max = 20, Rounding = 1, Callback = function(v) Core.AimbotSettings.Prediction = v end})

TriggerTab:AddToggle("Trigger_On", {Text = "Enabled", Default = false, Callback = function(v) Core.TriggerSettings.Enabled = v end}):AddKeyPicker("Trigger_Key", {Default = IsMobile and "E" or "MB2", Mode = "Hold", Text = "Trigger Key"})
TriggerTab:AddToggle("Trigger_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.TriggerSettings.TeamCheck = v end})
TriggerTab:AddSlider("Trigger_Delay", {Text = "Delay (ms)", Default = 0, Min = 0, Max = 500, Rounding = 0, Callback = function(v) Core.TriggerSettings.Delay = v end})

local AimVis = Tabs.Combat:AddRightGroupbox("Visuals")
AimVis:AddToggle("Aim_DrawFOV", {Text = "Draw FOV", Default = not IsMobile}):AddColorPicker("Aim_FOVCol", {Default = Color3.new(1,1,1)})
AimVis:AddLabel("Target Color"):AddColorPicker("Aim_TargetCol", {Default = Color3.new(1,0,0)})

-- Visuals Tab
local ESPTabBox = Tabs.Visuals:AddLeftTabbox("ESP")
local ESPMain = ESPTabBox:AddTab("Main")
local ESPExtra = ESPTabBox:AddTab("Extra")
local ESPSettings = ESPTabBox:AddTab("Settings")

ESPMain:AddToggle("ESP_On", {Text = "Enabled", Default = false, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Enabled = v end 
end})
ESPMain:AddToggle("ESP_Team", {Text = "Team Check", Default = true, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.TeamCheck = v end 
end})
ESPMain:AddToggle("ESP_Box", {Text = "Box", Default = false, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Box.Enabled = v end 
end}):AddColorPicker("ESP_BoxCol", {Default = Color3.new(1,1,1), Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Box.Color = v end 
end})
ESPMain:AddToggle("ESP_Name", {Text = "Name", Default = false, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Name.Enabled = v end 
end}):AddColorPicker("ESP_NameCol", {Default = Color3.new(1,1,1), Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Name.Color = v end 
end})
ESPMain:AddToggle("ESP_Health", {Text = "Health Bar", Default = false, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Health.Enabled = v end 
end})
ESPMain:AddToggle("ESP_Dist", {Text = "Distance", Default = false, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Distance.Enabled = v end 
end}):AddColorPicker("ESP_DistCol", {Default = Color3.new(1,1,1), Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Distance.Color = v end 
end})

ESPExtra:AddToggle("ESP_Skel", {Text = "Skeleton", Default = false, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Skeleton.Enabled = v end 
end}):AddColorPicker("ESP_SkelCol", {Default = Color3.new(1,1,1), Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Skeleton.Color = v end 
end})
ESPExtra:AddToggle("ESP_Tracer", {Text = "Tracers", Default = false, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Tracers.Enabled = v end 
end}):AddColorPicker("ESP_TracerCol", {Default = Color3.new(1,1,1), Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Tracers.Color = v end 
end})
ESPExtra:AddDropdown("ESP_TracerOrig", {Values = {"Bottom", "Center", "Top"}, Default = 1, Text = "Tracer Origin", Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Tracers.Origin = v end 
end})

ESPSettings:AddSlider("ESP_MaxDist", {Text = "Max Distance", Default = 2000, Min = 100, Max = 5000, Rounding = 0, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.MaxDistance = v end 
end})

local ChamsBox = Tabs.Visuals:AddRightGroupbox("Chams")
ChamsBox:AddToggle("ESP_Chams", {Text = "Enabled", Default = false, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Chams.Enabled = v end 
end})
ChamsBox:AddLabel("Fill Color"):AddColorPicker("ESP_ChamsCol", {Default = Color3.fromRGB(212,133,240), Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Chams.FillColor = v end 
end})
ChamsBox:AddSlider("ESP_ChamsTrans", {Text = "Transparency", Default = 0.5, Min = 0, Max = 1, Rounding = 2, Callback = function(v) 
    if Core.ESP then Core.ESP.Settings.Chams.FillTransparency = v end 
end})

-- World Tab
local WorldBox = Tabs.World:AddLeftGroupbox("Lighting")
WorldBox:AddToggle("World_Bright", {Text = "Fullbright", Default = false, Callback = function(v) Core.SetFullbright(v) end})
WorldBox:AddToggle("World_NoFog", {Text = "No Fog", Default = false, Callback = function(v) Core.SetNoFog(v) end})
WorldBox:AddSlider("World_Time", {Text = "Time", Default = 12, Min = 0, Max = 24, Rounding = 1, Callback = function(v) Core.SetTime(v) end})

local MoveBox = Tabs.World:AddRightGroupbox("Movement")
MoveBox:AddToggle("Move_Speed", {Text = "Speed", Default = false})
MoveBox:AddSlider("Move_SpeedVal", {Text = "Speed Value", Default = 16, Min = 16, Max = 150})
MoveBox:AddToggle("Move_Jump", {Text = "Infinite Jump", Default = false})
MoveBox:AddSlider("Move_JumpVal", {Text = "Jump Power", Default = 50, Min = 50, Max = 200})
MoveBox:AddToggle("Move_Noclip", {Text = "Noclip", Default = false}):AddKeyPicker("Move_NoclipKey", {Default = "N", Mode = "Toggle", Text = "Noclip Key"})

-- Game Tab
local GameUniv = Tabs.Game:AddLeftGroupbox("Universal")
GameUniv:AddButton({Text = "Rejoin Server", Func = function() Core.Rejoin() end})
GameUniv:AddButton({Text = "Copy Join Script", Func = function() 
    pcall(function() setclipboard(Core.GetJoinScript()) end)
    Library:Notify("Copied to clipboard") 
end})

-- Counter Blox
local CBTabBox = Tabs.Game:AddRightTabbox("Counter Blox")
local CBWeapon = CBTabBox:AddTab("Weapon")
local CBMove = CBTabBox:AddTab("Movement")
local CBCamera = CBTabBox:AddTab("Camera")

CBWeapon:AddToggle("CB_NoSpread", {Text = "No Spread", Default = false, Callback = function(v) Core.CBNoSpread(v) end})
CBWeapon:AddToggle("CB_NoRecoil", {Text = "No Recoil", Default = false, Callback = function(v) Core.CBNoRecoil(v) end})
CBWeapon:AddToggle("CB_RapidFire", {Text = "Rapid Fire", Default = false, Callback = function(v) Core.CBRapidFire(v) end})
CBWeapon:AddToggle("CB_InfAmmo", {Text = "Infinite Ammo", Default = false, Callback = function(v) Core.CBInfAmmo(v) end})

CBMove:AddToggle("CB_BHop", {Text = "Bunny Hop", Default = false, Callback = function(v) Core.CBBHop(v) end})
CBMove:AddSlider("CB_BHopSpeed", {Text = "BHop Speed", Default = 20, Min = 0, Max = 100, Rounding = 0, Callback = function(v) Core.CBSettings.BHopSpeed = v end})
CBMove:AddToggle("CB_Spinbot", {Text = "Spinbot", Default = false, Callback = function(v) Core.CBSpinbot(v) end})
CBMove:AddSlider("CB_SpinSpeed", {Text = "Spin Speed", Default = 50, Min = 10, Max = 100, Rounding = 0, Callback = function(v) Core.CBSettings.SpinSpeed = v end})

CBCamera:AddToggle("CB_ThirdPerson", {Text = "Third Person", Default = false, Callback = function(v) Core.CBThirdPerson(v) end}):AddKeyPicker("CB_TPKey", {Default = "V", Mode = "Toggle", Text = "Third Person Key"})
CBCamera:AddSlider("CB_TPDistance", {Text = "Distance", Default = 10, Min = 5, Max = 30, Rounding = 0, Callback = function(v) Core.CBSetThirdPersonDistance(v) end})

-- Main Loops
RunService.RenderStepped:Connect(function()
    pcall(function() 
        FOVCircle.Visible = Toggles.Aim_DrawFOV and Toggles.Aim_DrawFOV.Value and Core.AimbotSettings.Enabled 
        FOVCircle.Radius = Core.AimbotSettings.FOV
        FOVCircle.Color = Options.Aim_FOVCol and Options.Aim_FOVCol.Value or Color3.new(1,1,1)
        FOVCircle.Position = UserInputService:GetMouseLocation()
        TargetCircle.Color = Options.Aim_TargetCol and Options.Aim_TargetCol.Value or Color3.new(1,0,0)
    end)
    
    -- Third Person Keybind
    if Options.CB_TPKey and Options.CB_TPKey:GetState() then
        if not Core.CBSettings.ThirdPerson then
            Core.CBThirdPerson(true)
            if Toggles.CB_ThirdPerson then Toggles.CB_ThirdPerson:SetValue(true) end
        end
    else
        if Core.CBSettings.ThirdPerson and Options.CB_TPKey then
            Core.CBThirdPerson(false)
            if Toggles.CB_ThirdPerson then Toggles.CB_ThirdPerson:SetValue(false) end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    -- Aimbot
    if Core.AimbotSettings.Enabled and Options.Aim_Key and Options.Aim_Key:GetState() then
        if Core.AimbotSettings.StickyAim and Core.LockedTarget and Core.IsAlive(Core.LockedTarget) then
            Core.AimAt(Core.LockedTarget, TargetCircle)
        else
            local target = Core.GetClosestPlayer()
            if target then 
                Core.LockedTarget = target 
                Core.AimAt(target, TargetCircle)
            else 
                pcall(function() TargetCircle.Visible = false end) 
            end
        end
    else 
        Core.LockedTarget = nil 
        pcall(function() TargetCircle.Visible = false end) 
    end
    
    -- Trigger Bot
    if Core.TriggerSettings.Enabled and Options.Trigger_Key and Options.Trigger_Key:GetState() then
        local target = Core.GetTriggerTarget()
        if target then 
            if Core.TriggerSettings.Delay > 0 then 
                task.delay(Core.TriggerSettings.Delay / 1000, SafeClick)
            else
                SafeClick()
            end
        end
    end
    
    -- Movement
    if Core.IsAlive(LocalPlayer) then
        if Toggles.Move_Speed and Toggles.Move_Speed.Value then 
            pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = Options.Move_SpeedVal.Value end)
        end
        if Toggles.Move_Noclip and Toggles.Move_Noclip.Value then 
            pcall(function()
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do 
                    if v:IsA("BasePart") then v.CanCollide = false end 
                end 
            end)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Toggles.Move_Jump and Toggles.Move_Jump.Value and Core.IsAlive(LocalPlayer) then
        pcall(function()
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            LocalPlayer.Character.Humanoid.JumpPower = Options.Move_JumpVal.Value
        end)
    end
end)

-- Settings
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("killfeed")
SaveManager:SetFolder("killfeed/cfg")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

local MenuBind = Tabs.Settings:AddRightGroupbox("Menu")
MenuBind:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
Library.ToggleKeybind = Options.MenuKeybind
