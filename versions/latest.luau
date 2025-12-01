local LoadStartTime = tick()

local repo = "https://raw.githubusercontent.com/n-0clip/killfeed-lib/main/"
local coreRepo = "https://raw.githubusercontent.com/n-0clip/killfeed.cc/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Core = loadstring(game:HttpGet(coreRepo .. "core/core.luau"))()
local HWID_System = loadstring(game:HttpGet(coreRepo .. "hwid/hwid.luau"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local platform = IsMobile and "Mobile" or "PC"

HWID_System.WhitelistURL = "https://raw.githubusercontent.com/n-0clip/killfeed.cc/main/hwid/hwids"
HWID_System.Enabled = true

Core.Init()

local Options = Library.Options
local Toggles = Library.Toggles

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
local Ping = 0

local verified, hwid = HWID_System.Verify()

if not verified then
    setclipboard(hwid)
    return
end

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
    ShowCustomCursor = not IsMobile,
    Resizable = true,
    CornerRadius = 9,
    GlobalSearch = true,
    Size = UDim2.fromOffset(IsMobile and 500 or 600, IsMobile and 400 or 480),
    SearchbarSize = UDim2.new(1, 5, 1, 5),
    ToggleKeybind = Enum.KeyCode.RightShift
})

Core.NotifyCallback = function(msg, duration)
    Library:Notify(msg, duration or 3)
end

Library:SetWatermarkVisibility(true)
Window:SetSidebarWidth(50)

local LoadTime = tick() - LoadStartTime

Library:Notify("loaded killfeed.cc /|\** " .. Core.GameName .. "** /|\ " .. platform .. " /|\ " .. "loaded in " .. string.format("%.2f", LoadTime) .. "s", 5)

if platform == "Mobile" then
    Library:Notify({
        Title = "Warning", 
        Description = "I want to say, that i didnt tested this script on android, if you found bug dm me in ds (izdcg)", 
        Time = 7
    })
end

local WatermarkConnection = RunService.RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    
    pcall(function()
        Ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    
    Library:SetWatermark(string.format("%s (%s) | %d fps | %d ms",
        LocalPlayer.Name,
        identifyexecutor(),
        FPS,
        Ping
    ))
end)

local Tabs = {
    Combat = Window:AddTab("Combat", "crosshair"),
    Visuals = Window:AddTab("Visuals", "eye"),
    World = Window:AddTab("World", "globe"),
    Game = Window:AddTab("Game", "gamepad-2"),
    Players = Window:AddTab("Players", "users"),
    Scripts = Window:AddTab("Scripts", "code"),
    Settings = Window:AddTab("Settings", "settings")
}

local DrawingCache = {
    FOVCircle = Core.CreateDrawing("Circle", {Thickness = 1, Filled = false, Transparency = 1, Visible = false}),
    TargetCircle = Core.CreateDrawing("Circle", {Thickness = 2, Filled = false, Radius = 5, Visible = false, Color = Color3.new(1,0,0)}),
    SilentFOVCircle = Core.CreateDrawing("Circle", {Thickness = 1, Filled = false, Transparency = 1, Visible = false, Color = Color3.new(1,0,0)}),
    AimLine = Core.CreateDrawing("Line", {Thickness = 1, Visible = false, Color = Color3.new(1,1,1)})
}

local PlayerList = {
    Selected = nil,
    SelectedName = ""
}

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

local function GetPlayerNames()
    local names = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local function TeleportToPlayer(player)
    if not player or not player.Character then return end
    local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if targetHRP and localHRP then
        localHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
    end
end

local function SpectatePlayer(player)
    if not player or not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        Workspace.CurrentCamera.CameraSubject = humanoid
    end
end

local function StopSpectating()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            Workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

local CombatTabBox = Tabs.Combat:AddLeftTabbox("Combat")
local AimTab = CombatTabBox:AddTab("Aimbot")
local SilentTab = CombatTabBox:AddTab("Silent")
local TriggerTab = CombatTabBox:AddTab("Trigger")

AimTab:AddToggle("Aim_On", {Text = "Enabled", Default = false, Callback = function(v) Core.AimbotSettings.Enabled = v end}):AddKeyPicker("Aim_Key", {Default = IsMobile and "Q" or "MB2", Mode = "Hold", Text = "Aim Key"})
AimTab:AddToggle("Aim_Sticky", {Text = "Sticky Aim", Default = false, Callback = function(v) Core.AimbotSettings.StickyAim = v end})
AimTab:AddToggle("Aim_AutoShoot", {Text = "Auto Shoot", Default = false, Callback = function(v) Core.AimbotSettings.AutoShoot = v end})
AimTab:AddToggle("Aim_AutoWall", {Text = "Auto Wall", Default = false, Callback = function(v) Core.AimbotSettings.AutoWall = v end})
AimTab:AddToggle("Aim_Vis", {Text = "Visibility Check", Default = true, Callback = function(v) Core.AimbotSettings.VisibleCheck = v end})
AimTab:AddToggle("Aim_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.AimbotSettings.TeamCheck = v end})
AimTab:AddToggle("Aim_IgnoreWhitelist", {Text = "Ignore Whitelisted", Default = true, Callback = function(v) Core.AimbotSettings.IgnoreWhitelist = v end})
AimTab:AddDropdown("Aim_Part", {Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Random"}, Default = 1, Text = "Aim Part", Callback = function(v) Core.AimbotSettings.AimPart = v end})
AimTab:AddDropdown("Aim_Priority", {Values = {"Distance", "Health", "Threat"}, Default = 1, Text = "Target Priority", Callback = function(v) Core.AimbotSettings.Priority = v end})
AimTab:AddSlider("Aim_FOV", {Text = "FOV", Default = 100, Min = 10, Max = 500, Rounding = 0, Callback = function(v) Core.AimbotSettings.FOV = v end})
AimTab:AddSlider("Aim_Smooth", {Text = "Smoothness", Default = 5, Min = 1, Max = 20, Rounding = 1, Callback = function(v) Core.AimbotSettings.Smoothness = v end})
AimTab:AddSlider("Aim_Pred", {Text = "Prediction", Default = 0, Min = 0, Max = 20, Rounding = 1, Callback = function(v) Core.AimbotSettings.Prediction = v end})

SilentTab:AddToggle("Silent_On", {Text = "Enabled", Default = false, Callback = function(v) Core.SilentAimSettings.Enabled = v end})
SilentTab:AddToggle("Silent_Vis", {Text = "Visibility Check", Default = true, Callback = function(v) Core.SilentAimSettings.VisibleCheck = v end})
SilentTab:AddToggle("Silent_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.SilentAimSettings.TeamCheck = v end})
SilentTab:AddToggle("Silent_HitChance", {Text = "Hit Chance", Default = false, Callback = function(v) Core.SilentAimSettings.HitChanceEnabled = v end})
SilentTab:AddSlider("Silent_HitChanceVal", {Text = "Hit Chance %", Default = 100, Min = 1, Max = 100, Rounding = 0, Callback = function(v) Core.SilentAimSettings.HitChance = v end})
SilentTab:AddDropdown("Silent_Part", {Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Random"}, Default = 1, Text = "Aim Part", Callback = function(v) Core.SilentAimSettings.AimPart = v end})
SilentTab:AddSlider("Silent_FOV", {Text = "FOV", Default = 100, Min = 10, Max = 500, Rounding = 0, Callback = function(v) Core.SilentAimSettings.FOV = v end})
SilentTab:AddSlider("Silent_Pred", {Text = "Prediction", Default = 0, Min = 0, Max = 20, Rounding = 1, Callback = function(v) Core.SilentAimSettings.Prediction = v end})

TriggerTab:AddToggle("Trigger_On", {Text = "Enabled", Default = false, Callback = function(v) Core.TriggerSettings.Enabled = v end}):AddKeyPicker("Trigger_Key", {Default = IsMobile and "E" or "MB2", Mode = "Hold", Text = "Trigger Key"})
TriggerTab:AddToggle("Trigger_Team", {Text = "Team Check", Default = true, Callback = function(v) Core.TriggerSettings.TeamCheck = v end})
TriggerTab:AddToggle("Trigger_HeadOnly", {Text = "Head Only", Default = false, Callback = function(v) Core.TriggerSettings.HeadOnly = v end})
TriggerTab:AddSlider("Trigger_Delay", {Text = "Delay (ms)", Default = 0, Min = 0, Max = 500, Rounding = 0, Callback = function(v) Core.TriggerSettings.Delay = v end})
TriggerTab:AddSlider("Trigger_Hitchance", {Text = "Hit Chance %", Default = 100, Min = 1, Max = 100, Rounding = 0, Callback = function(v) Core.TriggerSettings.HitChance = v end})

local AimVis = Tabs.Combat:AddRightGroupbox("Visuals")
AimVis:AddToggle("Aim_DrawFOV", {Text = "Draw FOV", Default = not IsMobile}):AddColorPicker("Aim_FOVCol", {Default = Color3.new(1,1,1)})
AimVis:AddToggle("Silent_DrawFOV", {Text = "Draw Silent FOV", Default = false}):AddColorPicker("Silent_FOVCol", {Default = Color3.new(1,0,0)})
AimVis:AddToggle("Aim_DrawLine", {Text = "Draw Aim Line", Default = false}):AddColorPicker("Aim_LineCol", {Default = Color3.new(0,1,0)})
AimVis:AddLabel("Target Color"):AddColorPicker("Aim_TargetCol", {Default = Color3.new(1,0,0)})

local AntiAimBox = Tabs.Combat:AddRightGroupbox("Anti-Aim")
AntiAimBox:AddToggle("AA_Enabled", {Text = "Enabled", Default = false, Callback = function(v) Core.AntiAimSettings.Enabled = v end})
AntiAimBox:AddDropdown("AA_Type", {Values = {"Spin", "Jitter", "Random", "Backward"}, Default = 1, Text = "Type", Callback = function(v) Core.AntiAimSettings.Type = v end})
AntiAimBox:AddSlider("AA_Speed", {Text = "Speed", Default = 10, Min = 1, Max = 50, Rounding = 0, Callback = function(v) Core.AntiAimSettings.Speed = v end})

local ESPTabBox = Tabs.Visuals:AddLeftTabbox("ESP")
local ESPMain = ESPTabBox:AddTab("Main")
local ESPExtra = ESPTabBox:AddTab("Extra")
local ESPSettings = ESPTabBox:AddTab("Settings")

ESPMain:AddToggle("ESP_On", {Text = "Enabled", Default = false, Callback = function(v) Core.ESPSettings.Enabled = v end})
ESPMain:AddToggle("ESP_Team", {Text = "Team Check", Default = false, Callback = function(v) Core.ESPSettings.TeamCheck = v end})
ESPMain:AddToggle("ESP_Box", {Text = "Box", Default = false, Callback = function(v) Core.ESPSettings.Box.On = v end}):AddColorPicker("ESP_BoxCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Box.Color = v end})
ESPMain:AddToggle("ESP_BoxOutline", {Text = "Box Outline", Default = true, Callback = function(v) Core.ESPSettings.Box.Outline = v end})
ESPMain:AddDropdown("ESP_BoxType", {Values = {"2D", "3D", "Corner"}, Default = 1, Text = "Box Type", Callback = function(v) Core.ESPSettings.Box.Type = v end})
ESPMain:AddToggle("ESP_Name", {Text = "Name", Default = false, Callback = function(v) Core.ESPSettings.Name.On = v end}):AddColorPicker("ESP_NameCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Name.Color = v end})
ESPMain:AddToggle("ESP_DisplayName", {Text = "Display Name", Default = false, Callback = function(v) Core.ESPSettings.Name.DisplayName = v end})
ESPMain:AddToggle("ESP_Health", {Text = "Health Bar", Default = false, Callback = function(v) Core.ESPSettings.Health.On = v end})
ESPMain:AddToggle("ESP_HealthText", {Text = "Health Text", Default = false, Callback = function(v) Core.ESPSettings.Health.Text = v end})
ESPMain:AddDropdown("ESP_HealthPos", {Values = {"Left", "Right", "Top", "Bottom"}, Default = 1, Text = "Health Position", Callback = function(v) Core.ESPSettings.Health.Position = v end})
ESPMain:AddToggle("ESP_Weapon", {Text = "Weapon", Default = false, Callback = function(v) Core.ESPSettings.Weapon.On = v end}):AddColorPicker("ESP_WeaponCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Weapon.Color = v end})
ESPMain:AddToggle("ESP_Dist", {Text = "Distance", Default = false, Callback = function(v) Core.ESPSettings.Distance.On = v end}):AddColorPicker("ESP_DistCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Distance.Color = v end})

ESPExtra:AddToggle("ESP_Skel", {Text = "Skeleton", Default = false, Callback = function(v) Core.ESPSettings.Skeleton.On = v end}):AddColorPicker("ESP_SkelCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Skeleton.Color = v end})
ESPExtra:AddToggle("ESP_Head", {Text = "Head Dot", Default = false, Callback = function(v) Core.ESPSettings.HeadDot.On = v end}):AddColorPicker("ESP_HeadCol", {Default = Color3.new(1,0,0), Callback = function(v) Core.ESPSettings.HeadDot.Color = v end})
ESPExtra:AddToggle("ESP_HeadFilled", {Text = "Head Dot Filled", Default = true, Callback = function(v) Core.ESPSettings.HeadDot.Filled = v end})
ESPExtra:AddToggle("ESP_Tracer", {Text = "Tracers", Default = false, Callback = function(v) Core.ESPSettings.Tracers.On = v end}):AddColorPicker("ESP_TracerCol", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Tracers.Color = v end})
ESPExtra:AddDropdown("ESP_TracerOrig", {Values = {"Bottom", "Center", "Top", "Mouse"}, Default = 1, Text = "Tracer Origin", Callback = function(v) Core.ESPSettings.Tracers.Origin = v end})
ESPExtra:AddToggle("ESP_Arrow", {Text = "Off-Screen Arrows", Default = false, Callback = function(v) Core.ESPSettings.OffScreenArrows.On = v end}):AddColorPicker("ESP_ArrowCol", {Default = Color3.fromRGB(255,0,0), Callback = function(v) Core.ESPSettings.OffScreenArrows.Color = v end})
ESPExtra:AddSlider("ESP_ArrowSize", {Text = "Arrow Size", Default = 15, Min = 5, Max = 30, Rounding = 0, Callback = function(v) Core.ESPSettings.OffScreenArrows.Size = v end})
ESPExtra:AddSlider("ESP_ArrowRadius", {Text = "Arrow Radius", Default = 150, Min = 50, Max = 300, Rounding = 0, Callback = function(v) Core.ESPSettings.OffScreenArrows.Radius = v end})
ESPExtra:AddToggle("ESP_LookDir", {Text = "Look Direction", Default = false, Callback = function(v) Core.ESPSettings.LookDirection.On = v end}):AddColorPicker("ESP_LookCol", {Default = Color3.new(0,1,0), Callback = function(v) Core.ESPSettings.LookDirection.Color = v end})

ESPSettings:AddToggle("ESP_Rainbow", {Text = "Rainbow", Default = false, Callback = function(v) Core.ESPSettings.Rainbow.On = v end})
ESPSettings:AddSlider("ESP_RainbowSpeed", {Text = "Rainbow Speed", Default = 1, Min = 0.1, Max = 5, Rounding = 1, Callback = function(v) Core.ESPSettings.Rainbow.Speed = v end})
ESPSettings:AddToggle("ESP_VisCheck", {Text = "Visible Check Color", Default = false, Callback = function(v) Core.ESPSettings.VisibleCheck = v end}):AddColorPicker("ESP_VisCol", {Default = Color3.new(0,1,0), Callback = function(v) Core.ESPSettings.VisibleColor = v end})
ESPSettings:AddToggle("ESP_TeamColor", {Text = "Use Team Colors", Default = false, Callback = function(v) Core.ESPSettings.UseTeamColor = v end})
ESPSettings:AddSlider("ESP_MaxDist", {Text = "Max Distance", Default = 2000, Min = 100, Max = 5000, Rounding = 0, Callback = function(v) Core.ESPSettings.MaxDist = v end})
ESPSettings:AddSlider("ESP_FontSize", {Text = "Font Size", Default = 13, Min = 8, Max = 20, Rounding = 0, Callback = function(v) Core.ESPSettings.FontSize = v end})

local ChamsBox = Tabs.Visuals:AddRightGroupbox("Chams")
ChamsBox:AddToggle("ESP_Chams", {Text = "Enabled", Default = false, Callback = function(v) Core.ESPSettings.Chams.On = v end})
ChamsBox:AddLabel("Fill Color"):AddColorPicker("ESP_ChamsCol", {Default = Color3.fromRGB(212,133,240), Callback = function(v) Core.ESPSettings.Chams.Color = v end})
ChamsBox:AddLabel("Outline Color"):AddColorPicker("ESP_ChamsOutline", {Default = Color3.new(1,1,1), Callback = function(v) Core.ESPSettings.Chams.OutlineColor = v end})
ChamsBox:AddSlider("ESP_ChamsTrans", {Text = "Transparency", Default = 0.5, Min = 0, Max = 1, Rounding = 2, Callback = function(v) Core.ESPSettings.Chams.Transparency = v end})
ChamsBox:AddToggle("ESP_ChamsVisible", {Text = "Visible Only", Default = false, Callback = function(v) Core.ESPSettings.Chams.VisibleOnly = v end})

local WorldTabBox = Tabs.World:AddLeftTabbox("World")
local WorldMain = WorldTabBox:AddTab("Lighting")
local WorldSky = WorldTabBox:AddTab("Skybox")
local WorldEffects = WorldTabBox:AddTab("Effects")

WorldMain:AddToggle("World_Bright", {Text = "Fullbright", Default = false, Callback = function(v) Core.SetFullbright(v) end})
WorldMain:AddToggle("World_NoFog", {Text = "No Fog", Default = false, Callback = function(v) Core.SetNoFog(v) end})
WorldMain:AddToggle("World_NoShadows", {Text = "No Shadows", Default = false, Callback = function(v) Core.SetNoShadows(v) end})
WorldMain:AddSlider("World_Time", {Text = "Time", Default = 12, Min = 0, Max = 24, Rounding = 1, Callback = function(v) Core.SetTime(v) end})
WorldMain:AddSlider("World_Brightness", {Text = "Brightness", Default = 1, Min = 0, Max = 5, Rounding = 1, Callback = function(v) Core.SetBrightness(v) end})
WorldMain:AddSlider("World_Contrast", {Text = "Contrast", Default = 0, Min = -1, Max = 1, Rounding = 2, Callback = function(v) Core.SetContrast(v) end})
WorldMain:AddSlider("World_Saturation", {Text = "Saturation", Default = 0, Min = -1, Max = 1, Rounding = 2, Callback = function(v) Core.SetSaturation(v) end})
WorldMain:AddLabel("Ambient"):AddColorPicker("World_Ambient", {Default = Color3.fromRGB(127,127,127), Callback = function(v) Core.SetAmbient(v) end})
WorldMain:AddLabel("Outdoor Ambient"):AddColorPicker("World_OutdoorAmbient", {Default = Color3.fromRGB(127,127,127), Callback = function(v) Core.SetOutdoorAmbient(v) end})

WorldSky:AddDropdown("World_Skybox", {Values = {"Default", "Night", "Sunset", "Galaxy", "Cloudy", "Pink", "Vaporwave", "Blood Moon"}, Default = 1, Text = "Skybox", Callback = function(v) Core.SetSkybox(v) end})
WorldSky:AddToggle("World_Stars", {Text = "Show Stars", Default = true, Callback = function(v) Core.SetStars(v) end})

WorldEffects:AddToggle("World_NoParticles", {Text = "No Particles", Default = false, Callback = function(v) Core.SetNoParticles(v) end})
WorldEffects:AddToggle("World_NoPostEffects", {Text = "No Post Effects", Default = false, Callback = function(v) Core.SetNoPostEffects(v) end})
WorldEffects:AddToggle("World_LowGraphics", {Text = "Low Graphics Mode", Default = false, Callback = function(v) Core.SetLowGraphics(v) end})

local MoveBox = Tabs.World:AddRightGroupbox("Movement")
MoveBox:AddToggle("Move_Speed", {Text = "Speed", Default = false})
MoveBox:AddSlider("Move_SpeedVal", {Text = "Speed Value", Default = 16, Min = 16, Max = 150, Rounding = 0})
MoveBox:AddToggle("Move_Jump", {Text = "Infinite Jump", Default = false})
MoveBox:AddSlider("Move_JumpVal", {Text = "Jump Power", Default = 50, Min = 50, Max = 200, Rounding = 0})
MoveBox:AddToggle("Move_Noclip", {Text = "Noclip", Default = false}):AddKeyPicker("Move_NoclipKey", {Default = "N", Mode = "Toggle", Text = "Noclip Key"})
MoveBox:AddToggle("Move_Fly", {Text = "Fly", Default = false}):AddKeyPicker("Move_FlyKey", {Default = "F", Mode = "Toggle", Text = "Fly Key"})
MoveBox:AddSlider("Move_FlySpeed", {Text = "Fly Speed", Default = 50, Min = 10, Max = 200, Rounding = 0})

local MiscMovement = Tabs.World:AddRightGroupbox("Misc Movement")
MiscMovement:AddToggle("Move_BHop", {Text = "Bunny Hop", Default = false})
MiscMovement:AddToggle("Move_NoSlowdown", {Text = "No Slowdown", Default = false})

local PlayerBox = Tabs.Players:AddLeftGroupbox("Player List")

local playerDropdown
local function UpdatePlayerDropdown()
    if playerDropdown then
        playerDropdown:SetValues(GetPlayerNames())
    end
end

playerDropdown = PlayerBox:AddDropdown("Players_List", {
    Values = GetPlayerNames(),
    Default = 1,
    Text = "Select Player",
    Callback = function(v)
        PlayerList.Selected = Players:FindFirstChild(v)
        PlayerList.SelectedName = v
    end
})

PlayerBox:AddButton({Text = "Refresh List", Func = UpdatePlayerDropdown})
PlayerBox:AddButton({Text = "Teleport To", Func = function()
    if PlayerList.Selected then
        TeleportToPlayer(PlayerList.Selected)
        Library:Notify("Teleported to " .. PlayerList.SelectedName)
    end
end})
PlayerBox:AddButton({Text = "Spectate", Func = function()
    if PlayerList.Selected then
        SpectatePlayer(PlayerList.Selected)
        Library:Notify("Spectating " .. PlayerList.SelectedName)
    end
end})
PlayerBox:AddButton({Text = "Stop Spectating", Func = function()
    StopSpectating()
    Library:Notify("Stopped spectating")
end})

local PlayerActions = Tabs.Players:AddRightGroupbox("Player Actions")
PlayerActions:AddButton({Text = "Add to Whitelist", Func = function()
    if PlayerList.Selected then
        Core.Whitelist[PlayerList.Selected.Name] = true
        Library:Notify(PlayerList.SelectedName .. " added to whitelist")
    end
end})
PlayerActions:AddButton({Text = "Remove from Whitelist", Func = function()
    if PlayerList.Selected then
        Core.Whitelist[PlayerList.Selected.Name] = nil
        Library:Notify(PlayerList.SelectedName .. " removed from whitelist")
    end
end})
PlayerActions:AddButton({Text = "Add to Blacklist", Func = function()
    if PlayerList.Selected then
        Core.Blacklist[PlayerList.Selected.Name] = true
        Library:Notify(PlayerList.SelectedName .. " added to blacklist")
    end
end})
PlayerActions:AddButton({Text = "Remove from Blacklist", Func = function()
    if PlayerList.Selected then
        Core.Blacklist[PlayerList.Selected.Name] = nil
        Library:Notify(PlayerList.SelectedName .. " removed from blacklist")
    end
end})
PlayerActions:AddButton({Text = "Copy User ID", Func = function()
    if PlayerList.Selected then
        pcall(function() setclipboard(tostring(PlayerList.Selected.UserId)) end)
        Library:Notify("Copied User ID: " .. PlayerList.Selected.UserId)
    end
end})

Players.PlayerAdded:Connect(UpdatePlayerDropdown)
Players.PlayerRemoving:Connect(UpdatePlayerDropdown)

local GameUniv = Tabs.Game:AddLeftGroupbox("Universal")
GameUniv:AddButton({Text = "Rejoin Server", Func = function() Core.Rejoin() end})
GameUniv:AddButton({Text = "Server Hop", Func = function() 
    Library:Notify("Finding new server...")
    Core.ServerHop() 
end})
GameUniv:AddButton({Text = "Copy Join Script", Func = function() 
    pcall(function() setclipboard(Core.GetJoinScript()) end)
    Library:Notify("Copied to clipboard") 
end})
GameUniv:AddButton({Text = "Copy Game Link", Func = function()
    pcall(function() setclipboard("https://www.roblox.com/games/" .. game.PlaceId) end)
    Library:Notify("Copied game link")
end})

if Core.GameName == "Counter Blox" then
    local CBTabBox = Tabs.Game:AddLeftTabbox("Counter Blox")
    local CBWeapon = CBTabBox:AddTab("Weapon")
    local CBExploit = CBTabBox:AddTab("Exploits")
    local CBAntiAim = CBTabBox:AddTab("Anti-Aim")
    local CBCamera = CBTabBox:AddTab("Camera")
    
    CBWeapon:AddToggle("CB_NoSpread", {Text = "No Spread", Default = false, Callback = function(v) Core.CBNoSpread(v) end})
    CBWeapon:AddToggle("CB_NoRecoil", {Text = "No Recoil", Default = false, Callback = function(v) Core.CBNoRecoil(v) end})
    CBWeapon:AddToggle("CB_RapidFire", {Text = "Rapid Fire", Default = false, Callback = function(v) Core.CBRapidFire(v) end})
    CBWeapon:AddToggle("CB_InfAmmo", {Text = "Infinite Ammo", Default = false, Callback = function(v) Core.CBInfAmmo(v) end})
    CBWeapon:AddToggle("CB_InstantReload", {Text = "Instant Reload", Default = false, Callback = function(v) Core.CBInstantReload(v) end})
    
    CBExploit:AddToggle("CB_KillAll", {Text = "Kill All", Default = false, Callback = function(v) Core.CBKillAll(v) end})
    CBExploit:AddToggle("CB_InfCash", {Text = "Infinite Cash", Default = false, Callback = function(v) Core.CBInfCash(v) end})
    CBExploit:AddToggle("CB_BHop", {Text = "Bunny Hop (Hold Space)", Default = false, Callback = function(v) Core.CBBHop(v) end})
    CBExploit:AddToggle("CB_AutoDefuse", {Text = "Auto Defuse", Default = false, Callback = function(v) Core.CBAutoDefuse(v) end})
    
    CBAntiAim:AddToggle("CB_AntiAim", {Text = "Enabled", Default = false, Callback = function(v) Core.CBAntiAimbot(v) end})
    CBAntiAim:AddDropdown("CB_AAYaw", {Values = {"Default", "Backward", "Left", "Right", "Spin", "Random", "Jitter"}, Default = 1, Text = "Yaw", Callback = function(v) Core.CBSettings.AntiAimbotYaw = v end})
    CBAntiAim:AddSlider("CB_AASpeed", {Text = "Spin Speed", Default = 50, Min = 1, Max = 100, Rounding = 0, Callback = function(v) Core.CBSettings.AntiAimbotSpeed = v end})
    CBAntiAim:AddToggle("CB_RemoveHead", {Text = "Remove Head Hitbox", Default = false, Callback = function(v) Core.CBSettings.RemoveHeadHitbox = v end})
    CBAntiAim:AddToggle("CB_FakeAngle", {Text = "Fake Angle", Default = false, Callback = function(v) Core.CBSettings.FakeAngle = v end})
    
    CBCamera:AddToggle("CB_ThirdPerson", {Text = "Third Person", Default = false, Callback = function(v) Core.CBThirdPerson(v) end})
    CBCamera:AddSlider("CB_TPDistance", {Text = "Distance", Default = 10, Min = 5, Max = 30, Rounding = 0, Callback = function(v) Core.CBSetThirdPersonDistance(v) end})
    CBCamera:AddToggle("CB_NoScope", {Text = "No Scope Overlay", Default = false, Callback = function(v) Core.CBNoScope(v) end})
    CBCamera:AddToggle("CB_FreeCam", {Text = "Free Cam", Default = false, Callback = function(v) Core.CBFreeCam(v) end})
    
    local CBEffects = Tabs.Game:AddRightGroupbox("Remove Effects")
    CBEffects:AddDropdown("CB_RemoveEffects", {
        Values = {"Flash", "Smoke", "Blood", "Tracers", "MuzzleFlash", "Decals"},
        Default = {},
        Multi = true,
        Text = "Effects to Remove",
        Callback = function(v)
            local effects = {
                Flash = v["Flash"] or false,
                Smoke = v["Smoke"] or false,
                Blood = v["Blood"] or false,
                Tracers = v["Tracers"] or false,
                MuzzleFlash = v["MuzzleFlash"] or false,
                Decals = v["Decals"] or false
            }
            Core.CBRemoveEffects(effects)
        end
    })
end

if Core.GameName == "Murder Mystery 2" then
    local MM2Box = Tabs.Game:AddLeftGroupbox("Murder Mystery 2")
    MM2Box:AddToggle("MM2_Role", {Text = "Show Roles", Default = true, Callback = function(v) Core.ESPSettings.ShowRole = v end})
    MM2Box:AddLabel("Murderer"):AddColorPicker("MM2_Murd", {Default = Color3.fromRGB(255,0,0), Callback = function(v) Core.ESPSettings.MurdererColor = v end})
    MM2Box:AddLabel("Sheriff"):AddColorPicker("MM2_Sher", {Default = Color3.fromRGB(0,100,255), Callback = function(v) Core.ESPSettings.SheriffColor = v end})
    MM2Box:AddLabel("Innocent"):AddColorPicker("MM2_Inno", {Default = Color3.fromRGB(0,255,0), Callback = function(v) Core.ESPSettings.InnocentColor = v end})
    MM2Box:AddLabel("Hero"):AddColorPicker("MM2_Hero", {Default = Color3.fromRGB(255,215,0), Callback = function(v) Core.ESPSettings.HeroColor = v end})
    
    MM2Box:AddDivider()
    
    MM2Box:AddToggle("MM2_AutoGun", {Text = "Auto-Pickup Gun", Default = false, Callback = function(v) 
        Core.MM2Settings.AutoPickupGun = v
        Core.MM2AutoPickup(v, "Gun")
    end})
    MM2Box:AddToggle("MM2_AutoKnife", {Text = "Auto-Pickup Knife", Default = false, Callback = function(v) 
        Core.MM2Settings.AutoPickupKnife = v
        Core.MM2AutoPickup(v, "Knife")
    end})
    MM2Box:AddSlider("MM2_GrabRadius", {Text = "Grab Radius", Default = 25, Min = 10, Max = 50, Rounding = 0, Callback = function(v)
        Core.MM2Settings.GunGrabRadius = v
    end})
    MM2Box:AddToggle("MM2_NotifyPickup", {Text = "Notify Weapon Pickup", Default = true, Callback = function(v) 
        Core.MM2Settings.NotifyOnPickup = v 
    end})
end

local ScriptsBox = Tabs.Scripts:AddLeftGroupbox("Admin Scripts")
ScriptsBox:AddButton({Text = "Infinite Yield", Func = function() Library:Notify("Loading...") Core.LoadScript("Infinite Yield") end})
ScriptsBox:AddButton({Text = "Nameless Admin", Func = function() Library:Notify("Loading...") Core.LoadScript("Nameless Admin") end})
ScriptsBox:AddButton({Text = "CMD-X", Func = function() Library:Notify("Loading...") Core.LoadScript("CMD-X") end})

local ScriptsUtil = Tabs.Scripts:AddRightGroupbox("Utilities")
ScriptsUtil:AddButton({Text = "Dex Explorer", Func = function() Library:Notify("Loading...") Core.LoadScript("Dex Explorer") end})
ScriptsUtil:AddButton({Text = "Remote Spy", Func = function() Library:Notify("Loading...") Core.LoadScript("Remote Spy") end})
ScriptsUtil:AddButton({Text = "Script Dumper", Func = function() Library:Notify("Loading...") Core.LoadScript("Script Dumper") end})
ScriptsUtil:AddButton({Text = "Save Instance", Func = function() Library:Notify("Loading...") Core.LoadScript("Save Instance") end})

local ScriptsExtra = Tabs.Scripts:AddRightGroupbox("Extra")
ScriptsExtra:AddButton({Text = "Chat Bypass", Func = function() Library:Notify("Loading...") Core.LoadScript("Chat Bypass") end})
ScriptsExtra:AddButton({Text = "Anti AFK", Func = function() Library:Notify("Loading...") Core.LoadScript("Anti AFK") end})

local mobileAimEnabled = false

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    local viewportCenter = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)
    
    pcall(function() 
        DrawingCache.FOVCircle.Visible = Toggles.Aim_DrawFOV and Toggles.Aim_DrawFOV.Value and Core.AimbotSettings.Enabled 
        DrawingCache.FOVCircle.Radius = Core.AimbotSettings.FOV
        DrawingCache.FOVCircle.Color = Options.Aim_FOVCol and Options.Aim_FOVCol.Value or Color3.new(1,1,1)
        DrawingCache.FOVCircle.Position = mousePos
    end)
    
    pcall(function() 
        DrawingCache.SilentFOVCircle.Visible = Toggles.Silent_DrawFOV and Toggles.Silent_DrawFOV.Value and Core.SilentAimSettings.Enabled 
        DrawingCache.SilentFOVCircle.Radius = Core.SilentAimSettings.FOV
        DrawingCache.SilentFOVCircle.Position = viewportCenter
        DrawingCache.SilentFOVCircle.Color = Options.Silent_FOVCol and Options.Silent_FOVCol.Value or Color3.new(1,0,0)
    end)
    
    pcall(function() 
        DrawingCache.TargetCircle.Color = Options.Aim_TargetCol and Options.Aim_TargetCol.Value or Color3.new(1,0,0) 
    end)
    
    pcall(function()
        DrawingCache.AimLine.Color = Options.Aim_LineCol and Options.Aim_LineCol.Value or Color3.new(0,1,0)
        if Toggles.Aim_DrawLine and Toggles.Aim_DrawLine.Value and Core.LockedTarget and Core.IsAlive(Core.LockedTarget) then
            local targetPart = Core.LockedTarget.Character and Core.LockedTarget.Character:FindFirstChild(Core.AimbotSettings.AimPart)
            if not targetPart then
                targetPart = Core.LockedTarget.Character and Core.LockedTarget.Character:FindFirstChild("Head")
            end
            if targetPart then
                local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    DrawingCache.AimLine.From = mousePos
                    DrawingCache.AimLine.To = Vector2.new(screenPos.X, screenPos.Y)
                    DrawingCache.AimLine.Visible = true
                else
                    DrawingCache.AimLine.Visible = false
                end
            else
                DrawingCache.AimLine.Visible = false
            end
        else
            DrawingCache.AimLine.Visible = false
        end
    end)
    
    Core.UpdateESP()
end)

RunService.Heartbeat:Connect(function()
    local aimKeyState = (Options.Aim_Key and Options.Aim_Key:GetState()) or mobileAimEnabled
    
    if Core.AimbotSettings.Enabled and aimKeyState then
        if Core.AimbotSettings.StickyAim and Core.LockedTarget and Core.IsAlive(Core.LockedTarget) then
            if not Core.AimbotSettings.IgnoreWhitelist or not Core.IsWhitelisted(Core.LockedTarget) then
                Core.AimAt(Core.LockedTarget, DrawingCache.TargetCircle)
            else
                Core.LockedTarget = nil
                DrawingCache.TargetCircle.Visible = false
            end
        else
            local target = Core.GetClosestPlayer(function(plr)
                if Core.AimbotSettings.IgnoreWhitelist and Core.IsWhitelisted(plr) then
                    return false
                end
                return true
            end)
            if target then 
                Core.LockedTarget = target 
                Core.AimAt(target, DrawingCache.TargetCircle)
            else 
                pcall(function() DrawingCache.TargetCircle.Visible = false end) 
            end
        end
    else 
        Core.LockedTarget = nil 
        pcall(function() DrawingCache.TargetCircle.Visible = false end) 
    end
    
    if Core.TriggerSettings.Enabled and Options.Trigger_Key and Options.Trigger_Key:GetState() then
        local target = Core.GetTriggerTarget()
        if target then
            local shouldShoot = true
            if Core.TriggerSettings.HitChance < 100 then
                shouldShoot = math.random(1, 100) <= Core.TriggerSettings.HitChance
            end
            if shouldShoot then
                if Core.TriggerSettings.Delay > 0 then 
                    task.delay(Core.TriggerSettings.Delay / 1000, SafeClick)
                else
                    SafeClick()
                end
            end
        end
    end
    
    if Core.IsAlive(LocalPlayer) then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if humanoid then
            if Toggles.Move_Speed and Toggles.Move_Speed.Value then 
                humanoid.WalkSpeed = Options.Move_SpeedVal.Value 
            end
            
            if Toggles.Move_BHop and Toggles.Move_BHop.Value then
                if humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
            
            if Toggles.Move_NoSlowdown and Toggles.Move_NoSlowdown.Value then
                humanoid.WalkSpeed = math.max(humanoid.WalkSpeed, 16)
            end
        end
        
        if Toggles.Move_Noclip and Toggles.Move_Noclip.Value then 
            for _, v in pairs(character:GetDescendants()) do 
                if v:IsA("BasePart") then 
                    v.CanCollide = false 
                end 
            end 
        end
        
        if Toggles.Move_Fly and Toggles.Move_Fly.Value and hrp then
            local camera = Workspace.CurrentCamera
            local moveDirection = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            
            hrp.Velocity = moveDirection * (Options.Move_FlySpeed and Options.Move_FlySpeed.Value or 50)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Toggles.Move_Jump and Toggles.Move_Jump.Value and Core.IsAlive(LocalPlayer) then
        pcall(function()
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                humanoid.JumpPower = Options.Move_JumpVal.Value
            end
        end)
    end
end)

if IsMobile then
    UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
        if gameProcessed then return end
        if Core.AimbotSettings.Enabled then
            mobileAimEnabled = true
        end
    end)
    
    UserInputService.TouchEnded:Connect(function()
        mobileAimEnabled = false
    end)
end

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("killfeed")
SaveManager:SetFolder("killfeed/cfg")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

local MenuBind = Tabs.Settings:AddRightGroupbox("Menu")

MenuBind:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind"
})

MenuBind:AddButton({Text = "Unload Script", Func = function()
    Library:Notify("Unloading...")
    
    if WatermarkConnection then
        WatermarkConnection:Disconnect()
    end
    
    for _, drawing in pairs(DrawingCache) do
        pcall(function() drawing:Remove() end)
    end
    
    Core.Cleanup()
    Library:Unload()
end})

Library.ToggleKeybind = Options.MenuKeybind
