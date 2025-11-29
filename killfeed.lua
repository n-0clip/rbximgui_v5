local repo = "https://raw.githubusercontent.com/n-0clip/killfeed-lib/main/"
local coreRepo = "https://raw.githubusercontent.com/n-0clip/killfeed.cc/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Core = loadstring(game:HttpGet(coreRepo .. "core.luau"))()

Core.Init()

local Options = Library.Options
local Toggles = Library.Toggles

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

Library.ForceCheckbox = false 
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "killfeed.cc",
    Footer = Core.GameName,
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Resizable = true,
    Size = UDim2.fromOffset(600, 480)
})

Window:SetSidebarWidth(50)

local Tabs = {
    Combat = Window:AddTab("Combat", "crosshair"),
    Visuals = Window:AddTab("Visuals", "eye"),
    World = Window:AddTab("World", "globe"),
    Game = Window:AddTab("Game", "gamepad-2"),
    Scripts = Window:AddTab("Scripts", "code"),
    Settings = Window:AddTab("Settings", "settings")
}

local FOVCircle = Core.CreateDrawing("Circle", {Thickness = 1, Filled = false, Transparency = 1, Visible = false})
local TargetCircle = Core.CreateDrawing("Circle", {Thickness = 2, Filled = false, Radius = 5, Visible = false, Color = Color3.new(1,0,0)})
local SilentFOVCircle = Core.CreateDrawing("Circle", {Thickness = 1, Filled = false, Transparency = 1, Visible = false, Color = Color3.new(1,0,0)})

local CombatTabBox = Tabs.Combat:AddLeftTabbox("Combat")
local AimTab = CombatTabBox:AddTab("Aimbot")
local SilentTab = CombatTabBox:AddTab("Silent")
local TriggerTab = CombatTabBox:AddTab("Trigger")

AimTab:AddToggle("Aim_On", {Text = "Enabled", Default = false, Callback = function(v) Core.AimbotSettings.Enabled = v end}):AddKeyPicker("Aim_Key", {Default = "MB2", Mode = "Hold", Text = "Aim Key"})
AimTab:AddToggle("Aim_Sticky", {Text = "Sticky Aim", Default = false, Callback = function(v) Core.AimbotSettings.StickyAim = v end})
AimTab:AddToggle("Aim_Vis", {Text = "Visibility Check", Default = true, Callback = function(v) Core.AimbotSettings.VisibleCheck = v end})
AimTab:AddToggle("Aim_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.AimbotSettings.TeamCheck = v end})
AimTab:AddDropdown("Aim_Part", {Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = 1, Text = "Aim Part", Callback = function(v) Core.AimbotSettings.AimPart = v end})
AimTab:AddSlider("Aim_FOV", {Text = "FOV", Default = 100, Min = 10, Max = 500, Rounding = 0, Callback = function(v) Core.AimbotSettings.FOV = v end})
AimTab:AddSlider("Aim_Smooth", {Text = "Smoothness", Default = 5, Min = 1, Max = 20, Rounding = 1, Callback = function(v) Core.AimbotSettings.Smoothness = v end})
AimTab:AddSlider("Aim_Pred", {Text = "Prediction", Default = 0, Min = 0, Max = 20, Rounding = 1, Callback = function(v) Core.AimbotSettings.Prediction = v end})

SilentTab:AddToggle("Silent_On", {Text = "Enabled", Default = false, Callback = function(v) Core.SilentAimSettings.Enabled = v end})
SilentTab:AddToggle("Silent_Vis", {Text = "Visibility Check", Default = true, Callback = function(v) Core.SilentAimSettings.VisibleCheck = v end})
SilentTab:AddToggle("Silent_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.SilentAimSettings.TeamCheck = v end})
SilentTab:AddDropdown("Silent_Part", {Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = 1, Text = "Aim Part", Callback = function(v) Core.SilentAimSettings.AimPart = v end})
SilentTab:AddSlider("Silent_FOV", {Text = "FOV", Default = 100, Min = 10, Max = 500, Rounding = 0, Callback = function(v) Core.SilentAimSettings.FOV = v end})
SilentTab:AddSlider("Silent_Pred", {Text = "Prediction", Default = 0, Min = 0, Max = 20, Rounding = 1, Callback = function(v) Core.SilentAimSettings.Prediction = v end})

TriggerTab:AddToggle("Trigger_On", {Text = "Enabled", Default = false, Callback = function(v) Core.TriggerSettings.Enabled = v end}):AddKeyPicker("Trigger_Key", {Default = "MB2", Mode = "Hold", Text = "Trigger Key"})
TriggerTab:AddToggle("Trigger_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.TriggerSettings.TeamCheck = v end})
TriggerTab:AddSlider("Trigger_Delay", {Text = "Delay (ms)", Default = 0, Min = 0, Max = 500, Rounding = 0, Callback = function(v) Core.TriggerSettings.Delay = v end})

local AimVis = Tabs.Combat:AddRightGroupbox("Visuals")
AimVis:AddToggle("Aim_DrawFOV", {Text = "Draw FOV", Default = true}):AddColorPicker("Aim_FOVCol", {Default = Color3.new(1,1,1)})
AimVis:AddToggle("Silent_DrawFOV", {Text = "Draw Silent FOV", Default = false}):AddColorPicker("Silent_FOVCol", {Default = Color3.new(1,0,0)})
AimVis:AddLabel("Target Color"):AddColorPicker("Aim_TargetCol", {Default = Color3.new(1,0,0)})

local ESPTabBox = Tabs.Visuals:AddLeftTabbox("ESP")
local ESPMain = ESPTabBox:AddTab("Main")
local ESPExtra = ESPTabBox:AddTab("Extra")
local ESPSettings = ESPTabBox:AddTab("Settings")

ESPMain:AddToggle("ESP_On", {Text = "Enabled", Default = false, Callback = function(v) Core.ESPSettings.Enabled = v end})
ESPMain:AddToggle("ESP_Team", {Text = "Team Check", Default = false, Callback = function(v) Core.ESPSettings.TeamCheck = v end})
ESPMain:AddToggle("ESP_Box", {Text = "Box", Default = false, Callback = function(v) Core.ESPSettings.Box.On = v end}):AddColorPicker("ESP_BoxCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Box.Color = v end})
ESPMain:AddToggle("ESP_BoxOutline", {Text = "Box Outline", Default = true, Callback = function(v) Core.ESPSettings.Box.Outline = v end})
ESPMain:AddToggle("ESP_Corner", {Text = "Corner Box", Default = false, Callback = function(v) Core.ESPSettings.CornerBox.On = v end}):AddColorPicker("ESP_CornerCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.CornerBox.Color = v end})
ESPMain:AddToggle("ESP_Name", {Text = "Name", Default = false, Callback = function(v) Core.ESPSettings.Name.On = v end}):AddColorPicker("ESP_NameCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Name.Color = v end})
ESPMain:AddToggle("ESP_DisplayName", {Text = "Display Name", Default = false, Callback = function(v) Core.ESPSettings.Name.DisplayName = v end})
ESPMain:AddToggle("ESP_Health", {Text = "Health Bar", Default = false, Callback = function(v) Core.ESPSettings.Health.On = v end})
ESPMain:AddDropdown("ESP_HealthPos", {Values = {"Left", "Right"}, Default = 1, Text = "Health Position", Callback = function(v) Core.ESPSettings.Health.Position = v end})
ESPMain:AddToggle("ESP_Weapon", {Text = "Weapon", Default = false, Callback = function(v) Core.ESPSettings.Weapon.On = v end}):AddColorPicker("ESP_WeaponCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Weapon.Color = v end})
ESPMain:AddToggle("ESP_Dist", {Text = "Distance", Default = false, Callback = function(v) Core.ESPSettings.Distance.On = v end}):AddColorPicker("ESP_DistCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Distance.Color = v end})

ESPExtra:AddToggle("ESP_Skel", {Text = "Skeleton", Default = false, Callback = function(v) Core.ESPSettings.Skeleton.On = v end}):AddColorPicker("ESP_SkelCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Skeleton.Color = v end})
ESPExtra:AddToggle("ESP_Head", {Text = "Head Dot", Default = false, Callback = function(v) Core.ESPSettings.HeadDot.On = v end}):AddColorPicker("ESP_HeadCol", {Default = Color3.new(1,0,0), Callback = function(v) Core.ESPSettings.HeadDot.Color = v end})
ESPExtra:AddToggle("ESP_HeadFilled", {Text = "Head Dot Filled", Default = true, Callback = function(v) Core.ESPSettings.HeadDot.Filled = v end})
ESPExtra:AddToggle("ESP_Tracer", {Text = "Tracers", Default = false, Callback = function(v) Core.ESPSettings.Tracers.On = v end}):AddColorPicker("ESP_TracerCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Tracers.Color = v end})
ESPExtra:AddDropdown("ESP_TracerOrig", {Values = {"Bottom", "Center", "Top", "Mouse"}, Default = 1, Text = "Tracer Origin", Callback = function(v) Core.ESPSettings.Tracers.Origin = v end})
ESPExtra:AddToggle("ESP_Arrow", {Text = "Off-Screen Arrows", Default = false, Callback = function(v) Core.ESPSettings.OffScreenArrows.On = v end}):AddColorPicker("ESP_ArrowCol", {Default = Color3.new(1,0,0), Callback = function(v) Core.ESPSettings.OffScreenArrows.Color = v end})
ESPExtra:AddSlider("ESP_ArrowSize", {Text = "Arrow Size", Default = 15, Min = 5, Max = 30, Rounding = 0, Callback = function(v) Core.ESPSettings.OffScreenArrows.Size = v end})
ESPExtra:AddSlider("ESP_ArrowRadius", {Text = "Arrow Radius", Default = 150, Min = 50, Max = 300, Rounding = 0, Callback = function(v) Core.ESPSettings.OffScreenArrows.Radius = v end})

ESPSettings:AddToggle("ESP_Rainbow", {Text = "Rainbow", Default = false, Callback = function(v) Core.ESPSettings.Rainbow.On = v end})
ESPSettings:AddSlider("ESP_RainbowSpeed", {Text = "Rainbow Speed", Default = 1, Min = 0.1, Max = 5, Rounding = 1, Callback = function(v) Core.ESPSettings.Rainbow.Speed = v end})
ESPSettings:AddToggle("ESP_VisCheck", {Text = "Visible Check Color", Default = false, Callback = function(v) Core.ESPSettings.VisibleCheck = v end}):AddColorPicker("ESP_VisCol", {Default = Color3.new(0,1,0), Callback = function(v) Core.ESPSettings.VisibleColor = v end})
ESPSettings:AddSlider("ESP_MaxDist", {Text = "Max Distance", Default = 2000, Min = 100, Max = 5000, Rounding = 0, Callback = function(v) Core.ESPSettings.MaxDist = v end})
ESPSettings:AddSlider("ESP_FontSize", {Text = "Font Size", Default = 13, Min = 8, Max = 20, Rounding = 0, Callback = function(v) Core.ESPSettings.FontSize = v end})

local ChamsBox = Tabs.Visuals:AddRightGroupbox("Chams")
ChamsBox:AddToggle("ESP_Chams", {Text = "Enabled", Default = false, Callback = function(v) Core.ESPSettings.Chams.On = v end})
ChamsBox:AddLabel("Fill Color"):AddColorPicker("ESP_ChamsCol", {Default = Color3.fromRGB(212,133,240), Callback = function(v) Core.ESPSettings.Chams.Color = v end})
ChamsBox:AddLabel("Outline Color"):AddColorPicker("ESP_ChamsOutline", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Chams.OutlineColor = v end})
ChamsBox:AddSlider("ESP_ChamsTrans", {Text = "Transparency", Default = 0.5, Min = 0, Max = 1, Rounding = 2, Callback = function(v) Core.ESPSettings.Chams.Transparency = v end})

local WorldTabBox = Tabs.World:AddLeftTabbox("World")
local WorldMain = WorldTabBox:AddTab("Lighting")
local WorldSky = WorldTabBox:AddTab("Skybox")

WorldMain:AddToggle("World_Bright", {Text = "Fullbright", Default = false, Callback = function(v) Core.SetFullbright(v) end})
WorldMain:AddToggle("World_NoFog", {Text = "No Fog", Default = false, Callback = function(v) Core.SetNoFog(v) end})
WorldMain:AddSlider("World_Time", {Text = "Time", Default = 12, Min = 0, Max = 24, Rounding = 1, Callback = function(v) Core.SetTime(v) end})
WorldMain:AddSlider("World_Brightness", {Text = "Brightness", Default = 1, Min = 0, Max = 5, Rounding = 1, Callback = function(v) Core.SetBrightness(v) end})
WorldMain:AddLabel("Ambient"):AddColorPicker("World_Ambient", {Default = Color3.fromRGB(127,127,127), Callback = function(v) Core.SetAmbient(v) end})

WorldSky:AddDropdown("World_Skybox", {Values = {"Default", "Night", "Sunset", "Galaxy", "Cloudy", "Pink", "Vaporwave"}, Default = 1, Text = "Skybox", Callback = function(v) Core.SetSkybox(v) end})

local MoveBox = Tabs.World:AddRightGroupbox("Movement")
MoveBox:AddToggle("Move_Speed", {Text = "Speed", Default = false})
MoveBox:AddSlider("Move_SpeedVal", {Text = "Speed Value", Default = 16, Min = 16, Max = 150})
MoveBox:AddToggle("Move_Jump", {Text = "Infinite Jump", Default = false})
MoveBox:AddSlider("Move_JumpVal", {Text = "Jump Power", Default = 50, Min = 50, Max = 200})
MoveBox:AddToggle("Move_Noclip", {Text = "Noclip", Default = false}):AddKeyPicker("Move_NoclipKey", {Default = "N", Mode = "Toggle", Text = "Noclip Key"})

local GameUniv = Tabs.Game:AddLeftGroupbox("Universal")
GameUniv:AddButton({Text = "Rejoin Server", Func = function() Core.Rejoin() end})
GameUniv:AddButton({Text = "Copy Join Script", Func = function() setclipboard(Core.GetJoinScript()) Library:Notify("Copied to clipboard") end})

if Core.GameName == "Counter Blox" then
    local CBTabBox = Tabs.Game:AddLeftTabbox("Counter Blox")
    local CBWeapon = CBTabBox:AddTab("Weapon")
    local CBExploit = CBTabBox:AddTab("Exploits")
    local CBAntiAim = CBTabBox:AddTab("Anti-Aim")
    
    CBWeapon:AddToggle("CB_NoSpread", {Text = "No Spread", Default = false, Callback = function(v) Core.CBNoSpread(v) end})
    CBWeapon:AddToggle("CB_NoRecoil", {Text = "No Recoil", Default = false, Callback = function(v) Core.CBNoRecoil(v) end})
    CBWeapon:AddToggle("CB_RapidFire", {Text = "Rapid Fire", Default = false, Callback = function(v) Core.CBRapidFire(v) end})
    CBWeapon:AddToggle("CB_InfAmmo", {Text = "Infinite Ammo", Default = false, Callback = function(v) Core.CBInfAmmo(v) end})
    
    CBExploit:AddToggle("CB_KillAll", {Text = "Kill All", Default = false, Callback = function(v) Core.CBKillAll(v) end})
    CBExploit:AddToggle("CB_InfCash", {Text = "Infinite Cash", Default = false, Callback = function(v) Core.CBInfCash(v) end})
    CBExploit:AddToggle("CB_BHop", {Text = "Bunny Hop", Default = false, Callback = function(v) Core.CBBHop(v) end})
    
    CBAntiAim:AddToggle("CB_AntiAim", {Text = "Enabled", Default = false, Callback = function(v) Core.CBAntiAimbot(v) end})
    CBAntiAim:AddDropdown("CB_AAYaw", {Values = {"Default", "Backward", "Left", "Right", "Spin", "Random"}, Default = 1, Text = "Yaw", Callback = function(v) Core.CBSettings.AntiAimbotYaw = v end})
    CBAntiAim:AddSlider("CB_AASpeed", {Text = "Spin Speed", Default = 50, Min = 1, Max = 100, Rounding = 0, Callback = function(v) Core.CBSettings.AntiAimbotSpeed = v end})
    CBAntiAim:AddToggle("CB_RemoveHead", {Text = "Remove Head Hitbox", Default = false, Callback = function(v) Core.CBSettings.RemoveHeadHitbox = v end})
    
    local CBEffects = Tabs.Game:AddRightGroupbox("Effects")
    CBEffects:AddToggle("CB_NoScope", {Text = "No Scope", Default = false, Callback = function(v) Core.CBNoScope(v) end})
    CBEffects:AddToggle("CB_NoFlash", {Text = "No Flash", Default = false, Callback = function(v) Core.CBNoFlash(v) end})
    CBEffects:AddToggle("CB_NoSmoke", {Text = "No Smoke", Default = false, Callback = function(v) Core.CBNoSmoke(v) end})
end

if Core.GameName == "Arsenal" then
    local ArsenalTabBox = Tabs.Game:AddLeftTabbox("Arsenal")
    local ArsenalWeapon = ArsenalTabBox:AddTab("Weapon")
    local ArsenalMisc = ArsenalTabBox:AddTab("Misc")
    
    ArsenalWeapon:AddToggle("Arsenal_NoRecoil", {Text = "No Recoil", Default = false, Callback = function(v) Core.ArsenalNoRecoil(v) end})
    ArsenalWeapon:AddToggle("Arsenal_NoSpread", {Text = "No Spread", Default = false, Callback = function(v) Core.ArsenalNoSpread(v) end})
    ArsenalWeapon:AddToggle("Arsenal_RapidFire", {Text = "Rapid Fire", Default = false, Callback = function(v) Core.ArsenalRapidFire(v) end})
    ArsenalWeapon:AddButton({Text = "Infinite Ammo", Func = function() Core.ArsenalInfAmmo(true) Library:Notify("Infinite Ammo Applied") end})
    ArsenalWeapon:AddButton({Text = "Infinite Range", Func = function() Core.ArsenalInfRange(true) Library:Notify("Infinite Range Applied") end})
    ArsenalWeapon:AddButton({Text = "100% Accuracy", Func = function() Core.ArsenalFullAccuracy(true) Library:Notify("Full Accuracy Applied") end})
    ArsenalWeapon:AddButton({Text = "Auto Weapons", Func = function() Core.ArsenalAutoWeapons(true) Library:Notify("All Weapons Auto") end})
    
    ArsenalMisc:AddButton({Text = "Instant Reload", Func = function() Core.ArsenalInstantReload(true) Library:Notify("Instant Reload Applied") end})
    ArsenalMisc:AddButton({Text = "Apply Everything", Func = function()
        Core.ArsenalNoRecoil(true)
        Core.ArsenalNoSpread(true)
        Core.ArsenalRapidFire(true)
        Core.ArsenalInfAmmo(true)
        Core.ArsenalInfRange(true)
        Core.ArsenalFullAccuracy(true)
        Core.ArsenalAutoWeapons(true)
        Core.ArsenalInstantReload(true)
        Library:Notify("All Arsenal Mods Applied!")
    end})
end

if Core.GameName == "Murder Mystery 2" then
    local MM2Box = Tabs.Game:AddLeftGroupbox("Murder Mystery 2")
    MM2Box:AddToggle("MM2_Role", {Text = "Show Roles", Default = true, Callback = function(v) Core.ESPSettings.ShowRole = v end})
    MM2Box:AddLabel("Murderer"):AddColorPicker("MM2_Murd", {Default = Color3.fromRGB(255,0,0), Callback = function(v) Core.ESPSettings.MurdererColor = v end})
    MM2Box:AddLabel("Sheriff"):AddColorPicker("MM2_Sher", {Default = Color3.fromRGB(0,100,255), Callback = function(v) Core.ESPSettings.SheriffColor = v end})
    MM2Box:AddLabel("Innocent"):AddColorPicker("MM2_Inno", {Default = Color3.fromRGB(0,255,0), Callback = function(v) Core.ESPSettings.InnocentColor = v end})
end

local ScriptsBox = Tabs.Scripts:AddLeftGroupbox("Admin Scripts")
ScriptsBox:AddButton({Text = "Infinite Yield", Func = function() Library:Notify("Loading...") Core.LoadScript("Infinite Yield") end})
ScriptsBox:AddButton({Text = "Nameless Admin", Func = function() Library:Notify("Loading...") Core.LoadScript("Nameless Admin") end})

local ScriptsUtil = Tabs.Scripts:AddRightGroupbox("Utilities")
ScriptsUtil:AddButton({Text = "Dex Explorer", Func = function() Library:Notify("Loading...") Core.LoadScript("Dex Explorer") end})
ScriptsUtil:AddButton({Text = "Dark Dex", Func = function() Library:Notify("Loading...") Core.LoadScript("Dark Dex") end})
ScriptsUtil:AddButton({Text = "Remote Spy", Func = function() Library:Notify("Loading...") Core.LoadScript("Remote Spy") end})
ScriptsUtil:AddButton({Text = "Chat Spy", Func = function() Library:Notify("Loading...") Core.LoadScript("Chat Spy") end})
ScriptsUtil:AddButton({Text = "Anti AFK", Func = function() Library:Notify("Loading...") Core.LoadScript("Anti AFK") end})

RunService.RenderStepped:Connect(function()
    pcall(function() FOVCircle.Visible = Toggles.Aim_DrawFOV.Value and Core.AimbotSettings.Enabled end)
    pcall(function() FOVCircle.Radius = Core.AimbotSettings.FOV end)
    pcall(function() FOVCircle.Color = Options.Aim_FOVCol.Value end)
    pcall(function() FOVCircle.Position = UserInputService:GetMouseLocation() end)
    
    pcall(function() SilentFOVCircle.Visible = Toggles.Silent_DrawFOV.Value and Core.SilentAimSettings.Enabled end)
    pcall(function() SilentFOVCircle.Radius = Core.SilentAimSettings.FOV end)
    pcall(function() SilentFOVCircle.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2) end)
    pcall(function() SilentFOVCircle.Color = Options.Silent_FOVCol.Value end)
    
    if Core.AimbotSettings.Enabled and Options.Aim_Key:GetState() then
        if Core.AimbotSettings.StickyAim and Core.LockedTarget and Core.IsAlive(Core.LockedTarget) then
            Core.AimAt(Core.LockedTarget, TargetCircle)
        else
            local target = Core.GetClosestPlayer()
            if target then Core.LockedTarget = target Core.AimAt(target, TargetCircle)
            else pcall(function() TargetCircle.Visible = false end) end
        end
    else Core.LockedTarget = nil pcall(function() TargetCircle.Visible = false end) end
    
    if Core.TriggerSettings.Enabled and Options.Trigger_Key:GetState() then
        local target = Core.GetTriggerTarget()
        if target then if Core.TriggerSettings.Delay > 0 then task.wait(Core.TriggerSettings.Delay / 1000) end if mouse1click then mouse1click() end end
    end
    
    pcall(function() TargetCircle.Color = Options.Aim_TargetCol.Value end)
    
    Core.UpdateESP()
    
    if Core.IsAlive(LocalPlayer) then
        if Toggles.Move_Speed.Value then LocalPlayer.Character.Humanoid.WalkSpeed = Options.Move_SpeedVal.Value end
        if Toggles.Move_Noclip.Value then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Toggles.Move_Jump.Value and Core.IsAlive(LocalPlayer) then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        LocalPlayer.Character.Humanoid.JumpPower = Options.Move_JumpVal.Value
    end
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("killfeed")
SaveManager:SetFolder("killfeed/cfg")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

Library.Theme.Accent = Color3.fromRGB(212,133,240)
Library:UpdateColorsUsingTheme()

Library:Notify("killfeed.cc | " .. Core.GameName, 5)
