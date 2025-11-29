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
    Size = UDim2.fromOffset(580, 450)
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

local FOVCircle = Core.CreateDrawing("Circle", {Thickness = 1, Filled = false, Transparency = 1, Visible = false, ZIndex = 999})
local TargetCircle = Core.CreateDrawing("Circle", {Thickness = 2, Filled = false, Radius = 5, Visible = false, ZIndex = 999, Color = Color3.new(1,0,0)})
local SilentFOVCircle = Core.CreateDrawing("Circle", {Thickness = 1, Filled = false, Transparency = 1, Visible = false, ZIndex = 998, Color = Color3.new(1,0,0)})

local AimGroup = Tabs.Combat:AddLeftGroupbox("Aimbot")
AimGroup:AddToggle("Aim_On", {Text = "Enabled", Default = false, Callback = function(v) Core.AimbotSettings.Enabled = v end}):AddKeyPicker("Aim_Key", {Default = "MB2", Mode = "Hold", Text = "Aim Key"})
AimGroup:AddToggle("Aim_Sticky", {Text = "Sticky Aim", Default = false, Callback = function(v) Core.AimbotSettings.StickyAim = v end})
AimGroup:AddToggle("Aim_Vis", {Text = "Visibility Check", Default = true, Callback = function(v) Core.AimbotSettings.VisibleCheck = v end})
AimGroup:AddToggle("Aim_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.AimbotSettings.TeamCheck = v end})
AimGroup:AddDropdown("Aim_Part", {Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = 1, Text = "Aim Part", Callback = function(v) Core.AimbotSettings.AimPart = v end})
AimGroup:AddSlider("Aim_FOV", {Text = "FOV", Default = 100, Min = 10, Max = 500, Rounding = 0, Callback = function(v) Core.AimbotSettings.FOV = v end})
AimGroup:AddSlider("Aim_Smooth", {Text = "Smoothness", Default = 5, Min = 1, Max = 20, Rounding = 1, Callback = function(v) Core.AimbotSettings.Smoothness = v end})
AimGroup:AddSlider("Aim_Pred", {Text = "Prediction", Default = 0, Min = 0, Max = 20, Rounding = 1, Callback = function(v) Core.AimbotSettings.Prediction = v end})

local SilentGroup = Tabs.Combat:AddLeftGroupbox("Silent Aim")
SilentGroup:AddToggle("Silent_On", {Text = "Enabled", Default = false, Callback = function(v) Core.SilentAimSettings.Enabled = v end})
SilentGroup:AddToggle("Silent_Vis", {Text = "Visibility Check", Default = true, Callback = function(v) Core.SilentAimSettings.VisibleCheck = v end})
SilentGroup:AddToggle("Silent_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.SilentAimSettings.TeamCheck = v end})
SilentGroup:AddDropdown("Silent_Part", {Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, Default = 1, Text = "Aim Part", Callback = function(v) Core.SilentAimSettings.AimPart = v end})
SilentGroup:AddSlider("Silent_FOV", {Text = "FOV", Default = 100, Min = 10, Max = 500, Rounding = 0, Callback = function(v) Core.SilentAimSettings.FOV = v end})
SilentGroup:AddSlider("Silent_Pred", {Text = "Prediction", Default = 0, Min = 0, Max = 20, Rounding = 1, Callback = function(v) Core.SilentAimSettings.Prediction = v end})

local TriggerGroup = Tabs.Combat:AddRightGroupbox("Triggerbot")
TriggerGroup:AddToggle("Trigger_On", {Text = "Enabled", Default = false, Callback = function(v) Core.TriggerSettings.Enabled = v end}):AddKeyPicker("Trigger_Key", {Default = "MB2", Mode = "Hold", Text = "Trigger Key"})
TriggerGroup:AddToggle("Trigger_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.TriggerSettings.TeamCheck = v end})
TriggerGroup:AddSlider("Trigger_Delay", {Text = "Delay (ms)", Default = 0, Min = 0, Max = 500, Rounding = 0, Callback = function(v) Core.TriggerSettings.Delay = v end})

local AimVis = Tabs.Combat:AddRightGroupbox("Visuals")
AimVis:AddToggle("Aim_DrawFOV", {Text = "Draw FOV", Default = true}):AddColorPicker("Aim_FOVCol", {Default = Color3.new(1,1,1)})
AimVis:AddToggle("Silent_DrawFOV", {Text = "Draw Silent FOV", Default = false}):AddColorPicker("Silent_FOVCol", {Default = Color3.new(1,0,0)})
AimVis:AddLabel("Target Color"):AddColorPicker("Aim_TargetCol", {Default = Color3.new(1,0,0)})

local EspMain = Tabs.Visuals:AddLeftGroupbox("ESP")
EspMain:AddToggle("ESP_On", {Text = "Enabled", Default = false, Callback = function(v) Core.ESPSettings.Enabled = v end})
EspMain:AddToggle("ESP_Team", {Text = "Team Check", Default = false, Callback = function(v) Core.ESPSettings.TeamCheck = v end})
EspMain:AddToggle("ESP_Rainbow", {Text = "Rainbow", Default = false, Callback = function(v) Core.ESPSettings.Rainbow.On = v end})
EspMain:AddSlider("ESP_RainbowSpeed", {Text = "Rainbow Speed", Default = 1, Min = 0.1, Max = 5, Rounding = 1, Callback = function(v) Core.ESPSettings.Rainbow.Speed = v end})
EspMain:AddToggle("ESP_Box", {Text = "Box", Default = false, Callback = function(v) Core.ESPSettings.Box.On = v end}):AddColorPicker("ESP_BoxCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Box.Color = v end})
EspMain:AddToggle("ESP_Name", {Text = "Name", Default = false, Callback = function(v) Core.ESPSettings.Name.On = v end}):AddColorPicker("ESP_NameCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Name.Color = v end})
EspMain:AddToggle("ESP_Health", {Text = "Health", Default = false, Callback = function(v) Core.ESPSettings.Health.On = v end})
EspMain:AddToggle("ESP_Dist", {Text = "Distance", Default = false, Callback = function(v) Core.ESPSettings.Distance.On = v end}):AddColorPicker("ESP_DistCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Distance.Color = v end})
EspMain:AddToggle("ESP_Skel", {Text = "Skeleton", Default = false, Callback = function(v) Core.ESPSettings.Skeleton.On = v end}):AddColorPicker("ESP_SkelCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Skeleton.Color = v end})

local EspExtra = Tabs.Visuals:AddRightGroupbox("Extra")
EspExtra:AddToggle("ESP_Head", {Text = "Head Dot", Default = false, Callback = function(v) Core.ESPSettings.HeadDot.On = v end}):AddColorPicker("ESP_HeadCol", {Default = Color3.new(1,0,0), Callback = function(v) Core.ESPSettings.HeadDot.Color = v end})
EspExtra:AddToggle("ESP_Chams", {Text = "Chams", Default = false, Callback = function(v) Core.ESPSettings.Chams.On = v end}):AddColorPicker("ESP_ChamsCol", {Default = Color3.fromRGB(212,133,240), Callback = function(v) Core.ESPSettings.Chams.Color = v end})
EspExtra:AddSlider("ESP_ChamsTrans", {Text = "Chams Transparency", Default = 0.5, Min = 0, Max = 1, Rounding = 2, Callback = function(v) Core.ESPSettings.Chams.Transparency = v end})
EspExtra:AddToggle("ESP_Tracer", {Text = "Tracers", Default = false, Callback = function(v) Core.ESPSettings.Tracers.On = v end}):AddColorPicker("ESP_TracerCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Tracers.Color = v end})
EspExtra:AddDropdown("ESP_TracerOrig", {Values = {"Bottom", "Center", "Top", "Mouse"}, Default = 1, Text = "Tracer Origin", Callback = function(v) Core.ESPSettings.Tracers.Origin = v end})
EspExtra:AddSlider("ESP_MaxDist", {Text = "Max Distance", Default = 2000, Min = 100, Max = 5000, Rounding = 0, Callback = function(v) Core.ESPSettings.MaxDist = v end})

local MoveBox = Tabs.World:AddLeftGroupbox("Movement")
MoveBox:AddToggle("Move_Speed", {Text = "Speed", Default = false})
MoveBox:AddSlider("Move_SpeedVal", {Text = "Speed Value", Default = 16, Min = 16, Max = 150})
MoveBox:AddToggle("Move_Jump", {Text = "Infinite Jump", Default = false})
MoveBox:AddSlider("Move_JumpVal", {Text = "Jump Power", Default = 50, Min = 50, Max = 200})

local WorldVis = Tabs.World:AddRightGroupbox("Visuals")
WorldVis:AddToggle("World_Bright", {Text = "Fullbright", Default = false, Callback = function(v) Core.SetFullbright(v) end})
WorldVis:AddToggle("World_NoFog", {Text = "No Fog", Default = false, Callback = function(v) Core.SetNoFog(v) end})

local GameUniv = Tabs.Game:AddLeftGroupbox("Universal")
GameUniv:AddButton({Text = "Rejoin Server", Func = function() Core.Rejoin() end})
GameUniv:AddButton({Text = "Server Hop", Func = function() Core.ServerHop() end})
GameUniv:AddButton({Text = "Copy Join Script", Func = function()
    setclipboard(Core.GetJoinScript())
    Library:Notify("Copied to clipboard")
end})

if Core.GameName == "Counter Blox" then
    local CBWeapon = Tabs.Game:AddLeftGroupbox("Weapon Mods")
    CBWeapon:AddToggle("CB_NoSpread", {Text = "No Spread", Default = false, Callback = function(v) Core.CBNoSpread(v) end})
    CBWeapon:AddToggle("CB_NoRecoil", {Text = "No Recoil", Default = false, Callback = function(v) Core.CBNoRecoil(v) end})
    CBWeapon:AddToggle("CB_RapidFire", {Text = "Rapid Fire", Default = false, Callback = function(v) Core.CBRapidFire(v) end})
    CBWeapon:AddToggle("CB_InfAmmo", {Text = "Infinite Ammo", Default = false, Callback = function(v) Core.CBInfAmmo(v) end})
    
    local CBExploit = Tabs.Game:AddRightGroupbox("Exploits")
    CBExploit:AddToggle("CB_KillAll", {Text = "Kill All", Default = false, Callback = function(v) Core.CBKillAll(v) end})
    CBExploit:AddToggle("CB_InfCash", {Text = "Infinite Cash", Default = false, Callback = function(v) Core.CBInfCash(v) end})
    CBExploit:AddToggle("CB_BHop", {Text = "Bunny Hop", Default = false, Callback = function(v) Core.CBBHop(v) end})
    
    local CBAntiAim = Tabs.Game:AddRightGroupbox("Anti-Aimbot")
    CBAntiAim:AddToggle("CB_AntiAim", {Text = "Enabled", Default = false, Callback = function(v) Core.CBAntiAimbot(v) end})
    CBAntiAim:AddDropdown("CB_AAYaw", {Values = {"Default", "Backward", "Left", "Right", "Spin", "Random"}, Default = 1, Text = "Yaw", Callback = function(v) Core.CBSettings.AntiAimbotYaw = v end})
    CBAntiAim:AddSlider("CB_AASpeed", {Text = "Spin Speed", Default = 50, Min = 1, Max = 100, Rounding = 0, Callback = function(v) Core.CBSettings.AntiAimbotSpeed = v end})
    CBAntiAim:AddToggle("CB_RemoveHead", {Text = "Remove Head Hitbox", Default = false, Callback = function(v) Core.CBSettings.RemoveHeadHitbox = v end})
    
    local CBEffects = Tabs.Visuals:AddRightGroupbox("Remove Effects")
    CBEffects:AddToggle("CB_NoScope", {Text = "No Scope Overlay", Default = false, Callback = function(v) Core.CBNoScope(v) end})
    CBEffects:AddToggle("CB_NoFlash", {Text = "No Flash", Default = false, Callback = function(v) Core.CBNoFlash(v) end})
    CBEffects:AddToggle("CB_NoSmoke", {Text = "No Smoke", Default = false, Callback = function(v) Core.CBNoSmoke(v) end})
    CBEffects:AddToggle("CB_NoBullets", {Text = "No Bullet Holes", Default = false, Callback = function(v) Core.CBNoBulletHoles(v) end})
    CBEffects:AddToggle("CB_NoBlood", {Text = "No Blood", Default = false, Callback = function(v) Core.CBNoBlood(v) end})
end

if Core.GameName == "Murder Mystery 2" then
    local MM2Box = Tabs.Game:AddRightGroupbox("Murder Mystery 2")
    MM2Box:AddToggle("MM2_Role", {Text = "Show Roles", Default = true, Callback = function(v) Core.ESPSettings.ShowRole = v end})
    MM2Box:AddLabel("Murderer"):AddColorPicker("MM2_Murd", {Default = Color3.fromRGB(255,0,0), Callback = function(v) Core.ESPSettings.MurdererColor = v end})
    MM2Box:AddLabel("Sheriff"):AddColorPicker("MM2_Sher", {Default = Color3.fromRGB(0,100,255), Callback = function(v) Core.ESPSettings.SheriffColor = v end})
    MM2Box:AddLabel("Innocent"):AddColorPicker("MM2_Inno", {Default = Color3.fromRGB(0,255,0), Callback = function(v) Core.ESPSettings.InnocentColor = v end})
end

local ScriptsAdmin = Tabs.Scripts:AddLeftGroupbox("Admin Scripts")
ScriptsAdmin:AddButton({Text = "Infinite Yield", Func = function()
    Library:Notify("Loading Infinite Yield...")
    Core.LoadInfYield()
end})
ScriptsAdmin:AddButton({Text = "Nameless Admin", Func = function()
    Library:Notify("Loading Nameless Admin...")
    Core.LoadNamelessAdmin()
end})

local ScriptsUtil = Tabs.Scripts:AddRightGroupbox("Utilities")
ScriptsUtil:AddButton({Text = "Dex Explorer", Func = function()
    Library:Notify("Loading Dex Explorer...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end})
ScriptsUtil:AddButton({Text = "Remote Spy", Func = function()
    Library:Notify("Loading Remote Spy...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
end})

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Toggles.Aim_DrawFOV.Value and Core.AimbotSettings.Enabled
    FOVCircle.Radius = Core.AimbotSettings.FOV
    FOVCircle.Color = Options.Aim_FOVCol.Value
    FOVCircle.Position = UserInputService:GetMouseLocation()
    
    SilentFOVCircle.Visible = Toggles.Silent_DrawFOV.Value and Core.SilentAimSettings.Enabled
    SilentFOVCircle.Radius = Core.SilentAimSettings.FOV
    SilentFOVCircle.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)
    SilentFOVCircle.Color = Options.Silent_FOVCol.Value
    
    if Core.AimbotSettings.Enabled and Options.Aim_Key:GetState() then
        if Core.AimbotSettings.StickyAim and Core.LockedTarget and Core.IsAlive(Core.LockedTarget) then
            Core.AimAt(Core.LockedTarget, TargetCircle)
        else
            local target = Core.GetClosestPlayer()
            if target then
                Core.LockedTarget = target
                Core.AimAt(target, TargetCircle)
            else
                TargetCircle.Visible = false
            end
        end
    else
        Core.LockedTarget = nil
        TargetCircle.Visible = false
    end
    
    if Core.TriggerSettings.Enabled and Options.Trigger_Key:GetState() then
        local target = Core.GetTriggerTarget()
        if target then
            if Core.TriggerSettings.Delay > 0 then
                task.wait(Core.TriggerSettings.Delay / 1000)
            end
            if mouse1click then mouse1click() end
        end
    end
    
    TargetCircle.Color = Options.Aim_TargetCol.Value
    
    Core.UpdateESP()
    
    if Core.IsAlive(LocalPlayer) then
        if Toggles.Move_Speed.Value then
            LocalPlayer.Character.Humanoid.WalkSpeed = Options.Move_SpeedVal.Value
        end
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
