-- scythexlol v2.14 deobfucated

-- filename: 
-- version: lua51
-- line: [0, 0] id: 0
local r0_0 = game:GetService("RbxAnalyticsService"):GetClientId()
local r1_0 = {
  "7FE33B87-668D-44DC-8B30-CFC3DCB34D6F",
  "AE3088C9-64CF-4E29-9323-6A5CF708C737",
  "DCECAB0B-AFC7-4B1B-BAAD-D3F48B7C08AD",
  "1512977E-5D3B-43D7-A21C-28BCCC38479D"
}
local r2_0 = false
function CheckForSkid(r0_16)
  -- line: [0, 0] id: 16
  for r4_16, r5_16 in pairs(r1_0) do
    if r0_16 == r5_16 then
      return true
    end
    if r0_16 ~= r5_16 then
      return false
    end
  end
end
if CheckForSkid(r0_0) == true then
  r1_0 = {
    "7FE33B87-668D-44DC-8B30-CFC3DCB34D6F",
    "AE3088C9-64CF-4E29-9323-6A5CF708C737",
    "DCECAB0B-AFC7-4B1B-BAAD-D3F48B7C08AD",
    "1512977E-5D3B-43D7-A21C-28BCCC38479D"
  }
  r2_0 = false
  local r3_0 = CheckForSkid(r0_0)
  if r3_0 == true then
    r3_0 = game:GetService("HttpService")
    local r4_0 = game:GetService("Players")
    local r5_0 = game:GetService("UserInputService")
    local r6_0 = game:GetService("RunService")
    local r7_0 = game:GetService("TweenService")
    local r8_0 = game.GameId
    local r9_0 = game:GetService("TextChatService")
    local r10_0 = {
      "Get killfeed.gg here -> .gg/aUQwEr5e"
    }
    local r11_0 = {
      TabWidth = 160,
      Size = {
        360,
        360
      },
      Theme = "Darker",
      Acrylic = false,
      Transparency = true,
      MinimizeKey = "VSC Dark High Contrast",
      ShowNotifications = true,
      ShowWarnings = true,
      RenderingMode = "RenderStepped",
      AutoImport = true,
    }
    local r12_0 = {
      ImportSettings = function(r0_72)
        -- line: [0, 0] id: 72
        pcall(function()
          -- line: [0, 0] id: 73
          if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().isfile("UISettings.ttwizz") and getfenv().readfile("UISettings.ttwizz") then
            local r0_73 = next
            local r1_73, r2_73 = r3_0:JSONDecode(getfenv().readfile("UISettings.ttwizz"))
            for r3_73, r4_73 in r0_73, r1_73, r2_73 do
              r11_0[r3_73] = r4_73
            end
          end
        end)
      end,
      ExportSettings = function(r0_97)
        -- line: [0, 0] id: 97
        pcall(function()
          -- line: [0, 0] id: 98
          if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().writefile then
            getfenv().writefile("UISettings.ttwizz", r3_0:JSONEncode(r11_0))
          end
        end)
      end,
    }
    r12_0:ImportSettings()
    r11_0.__LAST_RUN__ = os.date()
    r12_0:ExportSettings()
    local r13_0 = {
      PackColour = function(r0_152, r1_152)
        -- line: [0, 0] id: 152
        local r2_152 = typeof(r1_152)
        if r2_152 == "Color3" then
          r2_152 = {}
          r2_152.R = r1_152.R * 255
          r2_152.G = r1_152.G * 255
          r2_152.B = r1_152.B * 255
          if not r2_152 then
            ::label_17::
            r2_152 = typeof(r1_152)
            if r2_152 == "table" then
              r2_152 = r1_152
              if r2_152 then
                ::label_24::
                r2_152 = {}
                r2_152.R = 255
                r2_152.G = 255
                r2_152.B = 255
              end
            else
              goto label_24	-- block#4 is visited secondly
            end
          end
        else
          goto label_17	-- block#2 is visited secondly
        end
        return r2_152
      end,
      UnpackColour = function(r0_10, r1_10)
        -- line: [0, 0] id: 10
        local r2_10 = typeof(r1_10)
        if r2_10 == "table" then
          r2_10 = Color3.fromRGB(r1_10.R, r1_10.G, r1_10.B)
          if not r2_10 then
            ::label_13::
            r2_10 = typeof(r1_10)
            if r2_10 == "Color3" then
              r2_10 = r1_10 or Color3.fromRGB(255, 255, 255)
            else
              goto label_20	-- block#4 is visited secondly
            end
          end
        else
          goto label_13	-- block#2 is visited secondly
        end
        return r2_10
      end,
    }
    local r14_0 = {}
    pcall(function()
      -- line: [0, 0] id: 107
      if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().isfile(string.format("%s.ttwizz", game.GameId)) and getfenv().readfile(string.format("%s.ttwizz", game.GameId)) and r11_0.AutoImport then
        r14_0 = r3_0:JSONDecode(getfenv().readfile(string.format("%s.ttwizz", game.GameId)))
        for r3_107, r4_107 in next, r14_0, nil do
          if r3_107 == "FoVColour" or r3_107 == "NameESPOutlineColour" or r3_107 == "ESPColour" then
            r14_0[r3_107] = r13_0:UnpackColour(r4_107)
          end
        end
      end
    end)
    local r15_0 = {
      Aimbot = r14_0.Aimbot or false,
      OnePressAimingMode = r14_0.OnePressAimingMode or false,
      AimKey = r14_0.AimKey or "RMB",
      AimMode = r14_0.AimMode or "Camera",
      OffAimbotAfterKill = r14_0.OffAimbotAfterKill or false,
    }
    local r16_0 = r14_0.AimPartDropdownValues
    if not r16_0 then
      r16_0 = {}
      local r17_0 = "Head"
      local r18_0 = "HumanoidRootPart"
      -- setlist for #16 failed
    end
    r15_0.AimPartDropdownValues = r16_0
    r15_0.AimPart = r14_0.AimPart or "HumanoidRootPart"
    r15_0.RandomAimPart = r14_0.RandomAimPart or false
    r15_0.UseOffset = r14_0.UseOffset or false
    r15_0.OffsetType = r14_0.OffsetType or "Static"
    r15_0.StaticOffsetIncrement = r14_0.StaticOffsetIncrement or 10
    r15_0.DynamicOffsetIncrement = r14_0.DynamicOffsetIncrement or 10
    r15_0.AutoOffset = r14_0.AutoOffset or false
    r15_0.MaxAutoOffset = r14_0.MaxAutoOffset or 50
    r15_0.UseSensitivity = r14_0.UseSensitivity or false
    r15_0.Sensitivity = r14_0.Sensitivity or 50
    r15_0.UseNoise = r14_0.UseNoise or false
    r15_0.NoiseFrequency = r14_0.NoiseFrequency or 50
    r15_0.SpinBot = r14_0.SpinBot or false
    r15_0.OnePressSpinningMode = r14_0.OnePressSpinningMode or false
    r15_0.SpinKey = r14_0.SpinKey or "Q"
    r15_0.SpinBotVelocity = r14_0.SpinBotVelocity or 50
    r16_0 = r14_0.SpinPartDropdownValues
    if not r16_0 then
      r16_0 = {}
      local r17_0 = "Head"
      local r18_0 = "HumanoidRootPart"
      -- setlist for #16 failed
    end
    r15_0.SpinPartDropdownValues = r16_0
    r15_0.SpinPart = r14_0.SpinPart or "HumanoidRootPart"
    r15_0.RandomSpinPart = r14_0.RandomSpinPart or false
    r15_0.TriggerBot = r14_0.TriggerBot or false
    r15_0.OnePressTriggeringMode = r14_0.OnePressTriggeringMode or false
    r15_0.SmartTriggerBot = r14_0.SmartTriggerBot or false
    r15_0.TriggerKey = r14_0.TriggerKey or "E"
    r15_0.TriggerBotChance = r14_0.TriggerBotChance or 100
    r15_0.AliveCheck = r14_0.AliveCheck or false
    r15_0.GodCheck = r14_0.GodCheck or false
    r15_0.TeamCheck = r14_0.TeamCheck or false
    r15_0.FriendCheck = r14_0.FriendCheck or false
    r15_0.FollowCheck = r14_0.FollowCheck or false
    r15_0.VerifiedBadgeCheck = r14_0.VerifiedBadgeCheck or false
    r15_0.WallCheck = r14_0.WallCheck or false
    r15_0.WaterCheck = r14_0.WaterCheck or false
    r15_0.FoVCheck = r14_0.FoVCheck or false
    r15_0.FoVRadius = r14_0.FoVRadius or 100
    r15_0.MagnitudeCheck = r14_0.MagnitudeCheck or false
    r15_0.TriggerMagnitude = r14_0.TriggerMagnitude or 500
    r15_0.TransparencyCheck = r14_0.TransparencyCheck or false
    r15_0.IgnoredTransparency = r14_0.IgnoredTransparency or 0.5
    r15_0.WhitelistedGroupCheck = r14_0.WhitelistedGroupCheck or false
    r15_0.WhitelistedGroup = r14_0.WhitelistedGroup or 0
    r15_0.BlacklistedGroupCheck = r14_0.BlacklistedGroupCheck or false
    r15_0.BlacklistedGroup = r14_0.BlacklistedGroup or 0
    r15_0.IgnoredPlayersCheck = r14_0.IgnoredPlayersCheck or false
    r15_0.IgnoredPlayersDropdownValues = r14_0.IgnoredPlayersDropdownValues or {}
    r15_0.IgnoredPlayers = r14_0.IgnoredPlayers or {}
    r15_0.TargetPlayersCheck = r14_0.TargetPlayersCheck or false
    r15_0.TargetPlayersDropdownValues = r14_0.TargetPlayersDropdownValues or {}
    r15_0.TargetPlayers = r14_0.TargetPlayers or {}
    r15_0.FoV = r14_0.FoV or false
    r15_0.FoVKey = r14_0.FoVKey or "R"
    r15_0.FoVThickness = r14_0.FoVThickness or 2
    r15_0.FoVOpacity = r14_0.FoVOpacity or 0.8
    r15_0.FoVFilled = r14_0.FoVFilled or false
    r15_0.FoVColour = r14_0.FoVColour or Color3.fromRGB(255, 255, 255)
    r15_0.SmartESP = r14_0.SmartESP or false
    r15_0.ESPKey = r14_0.ESPKey or "T"
    r15_0.ESPBox = r14_0.ESPBox or false
    r15_0.ESPBoxFilled = r14_0.ESPBoxFilled or false
    r15_0.NameESP = r14_0.NameESP or false
    r15_0.NameESPFont = r14_0.NameESPFont or "Monospace"
    r15_0.NameESPSize = r14_0.NameESPSize or 16
    r15_0.NameESPOutlineColour = r14_0.NameESPOutlineColour or Color3.fromRGB(0, 0, 0)
    r15_0.HealthESP = r14_0.HealthESP or false
    r15_0.MagnitudeESP = r14_0.MagnitudeESP or false
    r15_0.TracerESP = r14_0.TracerESP or false
    r15_0.ESPThickness = r14_0.ESPThickness or 2
    r15_0.ESPOpacity = r14_0.ESPOpacity or 0.8
    r15_0.ESPColour = r14_0.ESPColour or Color3.fromRGB(255, 255, 255)
    r15_0.ESPUseTeamColour = r14_0.ESPUseTeamColour or false
    r15_0.RainbowVisuals = r14_0.RainbowVisuals or false
    r15_0.RainbowDelay = r14_0.RainbowDelay or 5
    r16_0 = r4_0.LocalPlayer
    local r17_0 = r16_0:GetMouse()
    local r18_0 = r5_0.KeyboardEnabled and r5_0.MouseEnabled
    local function r19_0(r0_50)
      -- line: [0, 0] id: 50
      if typeof(r0_50) == "string" and 0 < #r0_50 then
        local r1_50 = next
        local r2_50, r3_50 = r4_0:GetPlayers()
        for r4_50, r5_50 in r1_50, r2_50, r3_50 do
          if string.sub(string.lower(r5_50.Name), 1, #string.lower(r0_50)) == string.lower(r0_50) then
            return r5_50.Name
          end
        end
      end
      return ""
    end
    local r20_0 = ""
    local r21_0 = nil
    local r22_0 = false
    local r23_0 = true
    local r24_0 = os.clock()
    local r25_0 = false
    local r26_0 = nil
    local r27_0 = nil
    local r28_0 = r5_0.MouseDeltaSensitivity
    local r29_0 = false
    local r30_0 = false
    local r31_0 = false
    local r32_0 = false
    if typeof(script) == "Instance" and script:FindFirstChild("Fluent") and script:FindFirstChild("Fluent"):IsA("ModuleScript") then
      r21_0 = require(script:FindFirstChild("Fluent"))
    else
      local r33_0, r34_0 = pcall(function()
        -- line: [0, 0] id: 134
        return game:HttpGet("https://twix.cyou/Fluent.txt", true)
      end)
      if r33_0 and typeof(r34_0) == "string" and string.find(r34_0, "dawid") then
        r21_0 = getfenv().loadstring(r34_0)()
        if r21_0.Premium then
          return getfenv().loadstring(game:HttpGet("https://raw.githubusercontent.com/scytheXlol/64ware.cc-Premium-V2/refs/heads/main/V2", true))()
        end
        local r35_0, r36_0 = pcall(function()
          -- line: [0, 0] id: 76
          return game:HttpGet("https://twix.cyou/AimbotStatus.json", true)
        end)
        if r35_0 and typeof(r36_0) == "string" and pcall(r3_0.JSONDecode, r3_0, r36_0) and typeof(r3_0:JSONDecode(r36_0).message) == "string" then
          r20_0 = r3_0:JSONDecode(r36_0).message
        end
      else
        return 
      end
    end
    local r33_0 = nil
    r33_0 = r5_0:GetPropertyChangedSignal("MouseDeltaSensitivity"):Connect(function()
      -- line: [0, 0] id: 63
      if not r21_0 then
        r33_0:Disconnect()
      elseif not r25_0 or not DEBUG and (getfenv().mousemoverel and r18_0 and r15_0.AimMode == "Mouse" or getfenv().hookmetamethod and getfenv().newcclosure and getfenv().checkcaller and getfenv().getnamecallmethod and r15_0.AimMode == "Silent") then
        r28_0 = r5_0.MouseDeltaSensitivity
      end
    end)
    local r34_0 = r21_0:CreateWindow({
      Title = string.format("KILLFEED.GG"),
      SubTitle = " V2.14",
      TabWidth = r11_0.TabWidth,
      Size = UDim2.fromOffset(table.unpack(r11_0.Size)),
      Theme = r11_0.Theme,
      Acrylic = r11_0.Acrylic,
      MinimizeKey = r11_0.MinimizeKey,
    })
    local r35_0 = {
      Aimbot = r34_0:AddTab({
        Title = "Aimbot",
        Icon = "crosshair",
      }),
    }
    r34_0:SelectTab(1)
    local r36_0 = r35_0.Aimbot:AddSection("Aimbot")
    local r37_0 = r36_0:AddToggle("Aimbot", {
      Title = "Aimbot",
      Description = "Toggles the Aimbot",
      Default = r15_0.Aimbot,
    })
    r37_0:OnChanged(function(r0_82)
      -- line: [0, 0] id: 82
      r15_0.Aimbot = r0_82
      if not r18_0 then
        r25_0 = r0_82
      end
    end)
    if r18_0 then
      r36_0:AddToggle("OnePressAimingMode", {
        Title = "One-Press Mode",
        Description = "Uses the One-Press Mode instead of the Holding Mode",
        Default = r15_0.OnePressAimingMode,
      }):OnChanged(function(r0_135)
        -- line: [0, 0] id: 135
        r15_0.OnePressAimingMode = r0_135
      end)
      local r39_0 = r36_0:AddKeybind("AimKey", {
        Title = "Aim Key",
        Description = "Changes the Aim Key",
        Default = r15_0.AimKey,
        ChangedCallback = function(r0_83)
          -- line: [0, 0] id: 83
          r15_0.AimKey = r0_83
        end,
      })
      local r40_0 = r39_0.Value
      if r40_0 ~= "RMB" then
        r40_0 = Enum.KeyCode[r39_0.Value] or Enum.UserInputType.MouseButton2
      else
        goto label_739	-- block#176 is visited secondly
      end
      r15_0.AimKey = r40_0
    end
    local r38_0 = r36_0:AddDropdown("AimMode", {
      Title = "Aim Mode",
      Description = "Changes the Aim Mode",
      Values = {
        "Camera"
      },
      Default = r15_0.AimMode,
      Callback = function(r0_143)
        -- line: [0, 0] id: 143
        r15_0.AimMode = r0_143
      end,
    })
    r36_0:AddToggle("OffAimbotAfterKill", {
      Title = "Off After Kill",
      Description = "Disables the Aiming Mode after killing a Target",
      Default = r15_0.OffAimbotAfterKill,
    }):OnChanged(function(r0_27)
      -- line: [0, 0] id: 27
      r15_0.OffAimbotAfterKill = r0_27
    end)
    local r40_0 = r36_0:AddDropdown("AimPart", {
      Title = "Aim Part",
      Description = "Changes the Aim Part",
      Values = r15_0.AimPartDropdownValues,
      Default = r15_0.AimPart,
      Callback = function(r0_101)
        -- line: [0, 0] id: 101
        r15_0.AimPart = r0_101
      end,
    })
    r36_0:AddToggle("RandomAimPart", {
      Title = "Random Aim Part",
      Description = "Selects every second a Random Aim Part from Dropdown",
      Default = r15_0.RandomAimPart,
    }):OnChanged(function(r0_67)
      -- line: [0, 0] id: 67
      r15_0.RandomAimPart = r0_67
    end)
    r36_0:AddInput("AddAimPart", {
      Title = "Add Aim Part",
      Description = "After typing, press Enter",
      Finished = true,
      Placeholder = "Part Name",
      Callback = function(r0_5)
        -- line: [0, 0] id: 5
        if 0 < #r0_5 and not table.find(r15_0.AimPartDropdownValues, r0_5) then
          table.insert(r15_0.AimPartDropdownValues, r0_5)
          r40_0:SetValue(r0_5)
        end
      end,
    })
    r36_0:AddInput("RemoveAimPart", {
      Title = "Remove Aim Part",
      Description = "After typing, press Enter",
      Finished = true,
      Placeholder = "Part Name",
      Callback = function(r0_108)
        -- line: [0, 0] id: 108
        if 0 < #r0_108 and table.find(r15_0.AimPartDropdownValues, r0_108) then
          if r15_0.AimPart == r0_108 then
            r40_0:SetValue(nil)
          end
          table.remove(r15_0.AimPartDropdownValues, table.find(r15_0.AimPartDropdownValues, r0_108))
          r40_0:SetValues(r15_0.AimPartDropdownValues)
        end
      end,
    })
    r36_0:AddButton({
      Title = "Clear All Items",
      Description = "Removes All Elements",
      Callback = function()
        -- line: [0, 0] id: 20
        local r0_20 = #r15_0.AimPartDropdownValues
        r40_0:SetValue(nil)
        r15_0.AimPartDropdownValues = {}
        r40_0:SetValues(r15_0.AimPartDropdownValues)
        local r1_20 = r34_0
        local r3_20 = {}
        local r4_20 = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")
        r3_20.Title = r4_20
        if r0_20 == 0 then
          r4_20 = "Nothing has been cleared!"
          if not r4_20 then
            ::label_35::
            if r0_20 == 1 then
              r4_20 = "1 Item has been cleared!" or string.format("%s Items have been cleared!", r0_20)
            else
              goto label_40	-- block#4 is visited secondly
            end
          end
        else
          goto label_35	-- block#2 is visited secondly
        end
        r3_20.Content = r4_20
        r3_20.Buttons = {
          {
            Title = "Confirm",
          }
        }
        r1_20:Dialog(r3_20)
      end,
    })
    local r42_0 = r35_0.Aimbot:AddSection("Aim Offset")
    r42_0:AddToggle("UseOffset", {
      Title = "Use Offset",
      Description = "Toggles the Offset",
      Default = r15_0.UseOffset,
    }):OnChanged(function(r0_37)
      -- line: [0, 0] id: 37
      r15_0.UseOffset = r0_37
    end)
    r42_0:AddDropdown("OffsetType", {
      Title = "Offset Type",
      Description = "Changes the Offset Type",
      Values = {
        "Static",
        "Dynamic",
        "Static & Dynamic"
      },
      Default = r15_0.OffsetType,
      Callback = function(r0_104)
        -- line: [0, 0] id: 104
        r15_0.OffsetType = r0_104
      end,
    })
    r42_0:AddSlider("StaticOffsetIncrement", {
      Title = "Static Offset Increment",
      Description = "Changes the Static Offset Increment",
      Default = r15_0.StaticOffsetIncrement,
      Min = 1,
      Max = 50,
      Rounding = 1,
      Callback = function(r0_15)
        -- line: [0, 0] id: 15
        r15_0.StaticOffsetIncrement = r0_15
      end,
    })
    r42_0:AddSlider("DynamicOffsetIncrement", {
      Title = "Dynamic Offset Increment",
      Description = "Changes the Dynamic Offset Increment",
      Default = r15_0.DynamicOffsetIncrement,
      Min = 1,
      Max = 50,
      Rounding = 1,
      Callback = function(r0_138)
        -- line: [0, 0] id: 138
        r15_0.DynamicOffsetIncrement = r0_138
      end,
    })
    r42_0:AddToggle("AutoOffset", {
      Title = "Auto Offset",
      Description = "Toggles the Auto Offset",
      Default = r15_0.AutoOffset,
    }):OnChanged(function(r0_118)
      -- line: [0, 0] id: 118
      r15_0.AutoOffset = r0_118
    end)
    r42_0:AddSlider("MaxAutoOffset", {
      Title = "Max Auto Offset",
      Description = "Changes the Max Auto Offset",
      Default = r15_0.MaxAutoOffset,
      Min = 1,
      Max = 50,
      Rounding = 1,
      Callback = function(r0_146)
        -- line: [0, 0] id: 146
        r15_0.MaxAutoOffset = r0_146
      end,
    })
    local r45_0 = r35_0.Aimbot:AddSection("Sensitivity & Noise")
    r45_0:AddToggle("UseSensitivity", {
      Title = "Use Sensitivity",
      Description = "Toggles the Sensitivity",
      Default = r15_0.UseSensitivity,
    }):OnChanged(function(r0_84)
      -- line: [0, 0] id: 84
      r15_0.UseSensitivity = r0_84
    end)
    r45_0:AddSlider("Sensitivity", {
      Title = "Sensitivity",
      Description = "Smoothes out the Mouse / Camera Movements when Aiming",
      Default = r15_0.Sensitivity,
      Min = 0,
      Max = 100,
      Rounding = 0.1,
      Callback = function(r0_42)
        -- line: [0, 0] id: 42
        r15_0.Sensitivity = r0_42
      end,
    })
    r45_0:AddToggle("UseNoise", {
      Title = "Use Noise",
      Description = "Toggles the Camera Shaking when Aiming",
      Default = r15_0.UseNoise,
    }):OnChanged(function(r0_106)
      -- line: [0, 0] id: 106
      r15_0.UseNoise = r0_106
    end)
    r45_0:AddSlider("NoiseFrequency", {
      Title = "Noise Frequency",
      Description = "Changes the Noise Frequency",
      Default = r15_0.NoiseFrequency,
      Min = 1,
      Max = 100,
      Rounding = 1,
      Callback = function(r0_137)
        -- line: [0, 0] id: 137
        r15_0.NoiseFrequency = r0_137
      end,
    })
    r35_0.Bots = r34_0:AddTab({
      Title = "Bots",
      Icon = "bot",
    })
    local r48_0 = r35_0.Bots:AddSection("SpinBot")
    local r51_0 = "AddParagraph"
    r51_0 = {
      Title = "NOTE",
      Content = "SpinBot does not function normally in RenderStepped Rendering Mode. Set a different Rendering Mode value than RenderStepped to solve this problem.",
    }
    r48_0:[r51_0](r51_0)
    r48_0:AddToggle("SpinBot", {
      Title = "SpinBot",
      Description = "Toggles the SpinBot",
      Default = r15_0.SpinBot,
    }):OnChanged(function(r0_93)
      -- line: [0, 0] id: 93
      r15_0.SpinBot = r0_93
      if not r18_0 then
        r29_0 = r0_93
      end
    end)
    if r18_0 then
      r48_0:AddToggle("OnePressSpinningMode", {
        Title = "One-Press Mode",
        Description = "Uses the One-Press Mode instead of the Holding Mode",
        Default = r15_0.OnePressSpinningMode,
      }):OnChanged(function(r0_57)
        -- line: [0, 0] id: 57
        r15_0.OnePressSpinningMode = r0_57
      end)
      r51_0 = r48_0:AddKeybind("SpinKey", {
        Title = "Spin Key",
        Description = "Changes the Spin Key",
        Default = r15_0.SpinKey,
        ChangedCallback = function(r0_58)
          -- line: [0, 0] id: 58
          r15_0.SpinKey = r0_58
        end,
      })
      local r52_0 = r51_0.Value
      if r52_0 ~= "RMB" then
        r52_0 = Enum.KeyCode[r51_0.Value] or Enum.UserInputType.MouseButton2
      else
        goto label_1043	-- block#181 is visited secondly
      end
      r15_0.SpinKey = r52_0
    end
    r48_0:AddSlider("SpinBotVelocity", {
      Title = "SpinBot Velocity",
      Description = "Changes the SpinBot Velocity",
      Default = r15_0.SpinBotVelocity,
      Min = 1,
      Max = 50,
      Rounding = 1,
      Callback = function(r0_39)
        -- line: [0, 0] id: 39
        r15_0.SpinBotVelocity = r0_39
      end,
    })
    local r50_0 = r48_0:AddDropdown("SpinPart", {
      Title = "Spin Part",
      Description = "Changes the Spin Part",
      Values = r15_0.SpinPartDropdownValues,
      Default = r15_0.SpinPart,
      Callback = function(r0_34)
        -- line: [0, 0] id: 34
        r15_0.SpinPart = r0_34
      end,
    })
    r48_0:AddToggle("RandomSpinPart", {
      Title = "Random Spin Part",
      Description = "Selects every second a Random Spin Part from Dropdown",
      Default = r15_0.RandomSpinPart,
    }):OnChanged(function(r0_79)
      -- line: [0, 0] id: 79
      r15_0.RandomSpinPart = r0_79
    end)
    r48_0:AddInput("AddSpinPart", {
      Title = "Add Spin Part",
      Description = "After typing, press Enter",
      Finished = true,
      Placeholder = "Part Name",
      Callback = function(r0_110)
        -- line: [0, 0] id: 110
        if 0 < #r0_110 and not table.find(r15_0.SpinPartDropdownValues, r0_110) then
          table.insert(r15_0.SpinPartDropdownValues, r0_110)
          r50_0:SetValue(r0_110)
        end
      end,
    })
    r48_0:AddInput("RemoveSpinPart", {
      Title = "Remove Spin Part",
      Description = "After typing, press Enter",
      Finished = true,
      Placeholder = "Part Name",
      Callback = function(r0_122)
        -- line: [0, 0] id: 122
        if 0 < #r0_122 and table.find(r15_0.SpinPartDropdownValues, r0_122) then
          if r15_0.SpinPart == r0_122 then
            r50_0:SetValue(nil)
          end
          table.remove(r15_0.SpinPartDropdownValues, table.find(r15_0.SpinPartDropdownValues, r0_122))
          r50_0:SetValues(r15_0.SpinPartDropdownValues)
        end
      end,
    })
    r48_0:AddButton({
      Title = "Clear All Items",
      Description = "Removes All Elements",
      Callback = function()
        -- line: [0, 0] id: 51
        local r0_51 = #r15_0.SpinPartDropdownValues
        r50_0:SetValue(nil)
        r15_0.SpinPartDropdownValues = {}
        r50_0:SetValues(r15_0.SpinPartDropdownValues)
        local r1_51 = r34_0
        local r3_51 = {}
        local r4_51 = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")
        r3_51.Title = r4_51
        if r0_51 == 0 then
          r4_51 = "Nothing has been cleared!"
          if not r4_51 then
            ::label_35::
            if r0_51 == 1 then
              r4_51 = "1 Item has been cleared!" or string.format("%s Items have been cleared!", r0_51)
            else
              goto label_40	-- block#4 is visited secondly
            end
          end
        else
          goto label_35	-- block#2 is visited secondly
        end
        r3_51.Content = r4_51
        r3_51.Buttons = {
          {
            Title = "Confirm",
          }
        }
        r1_51:Dialog(r3_51)
      end,
    })
    if getfenv().mouse1click and r18_0 then
      local r52_0 = r35_0.Bots:AddSection("TriggerBot")
      r52_0:AddToggle("TriggerBot", {
        Title = "TriggerBot",
        Description = "Toggles the TriggerBot",
        Default = r15_0.TriggerBot,
      }):OnChanged(function(r0_128)
        -- line: [0, 0] id: 128
        r15_0.TriggerBot = r0_128
      end)
      r52_0:AddToggle("OnePressTriggeringMode", {
        Title = "One-Press Mode",
        Description = "Uses the One-Press Mode instead of the Holding Mode",
        Default = r15_0.OnePressTriggeringMode,
      }):OnChanged(function(r0_127)
        -- line: [0, 0] id: 127
        r15_0.OnePressTriggeringMode = r0_127
      end)
      r52_0:AddToggle("SmartTriggerBot", {
        Title = "Smart TriggerBot",
        Description = "Uses the TriggerBot only when Aiming",
        Default = r15_0.SmartTriggerBot,
      }):OnChanged(function(r0_124)
        -- line: [0, 0] id: 124
        r15_0.SmartTriggerBot = r0_124
      end)
      local r56_0 = r52_0:AddKeybind("TriggerKey", {
        Title = "Trigger Key",
        Description = "Changes the Trigger Key",
        Default = r15_0.TriggerKey,
        ChangedCallback = function(r0_142)
          -- line: [0, 0] id: 142
          r15_0.TriggerKey = r0_142
        end,
      })
      local r57_0 = r56_0.Value
      if r57_0 ~= "RMB" then
        r57_0 = Enum.KeyCode[r56_0.Value] or Enum.UserInputType.MouseButton2
      else
        goto label_1206	-- block#187 is visited secondly
      end
      r15_0.TriggerKey = r57_0
      r52_0:AddSlider("TriggerBotChance", {
        Title = "TriggerBot Chance",
        Description = "Changes the Hit Chance for TriggerBot",
        Default = r15_0.TriggerBotChance,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Callback = function(r0_144)
          -- line: [0, 0] id: 144
          r15_0.TriggerBotChance = r0_144
        end,
      })
    else
      r22_0 = true
    end
    r35_0.Checks = r34_0:AddTab({
      Title = "Checks",
      Icon = "list-checks",
    })
    local r52_0 = r35_0.Checks:AddSection("Simple Checks")
    r52_0:AddToggle("AliveCheck", {
      Title = "Alive Check",
      Description = "Toggles the Alive Check",
      Default = r15_0.AliveCheck,
    }):OnChanged(function(r0_7)
      -- line: [0, 0] id: 7
      r15_0.AliveCheck = r0_7
    end)
    r52_0:AddToggle("GodCheck", {
      Title = "God Check",
      Description = "Toggles the God Check",
      Default = r15_0.GodCheck,
    }):OnChanged(function(r0_32)
      -- line: [0, 0] id: 32
      r15_0.GodCheck = r0_32
    end)
    r52_0:AddToggle("TeamCheck", {
      Title = "Team Check",
      Description = "Toggles the Team Check",
      Default = r15_0.TeamCheck,
    }):OnChanged(function(r0_88)
      -- line: [0, 0] id: 88
      r15_0.TeamCheck = r0_88
    end)
    r52_0:AddToggle("FriendCheck", {
      Title = "Friend Check",
      Description = "Toggles the Friend Check",
      Default = r15_0.FriendCheck,
    }):OnChanged(function(r0_12)
      -- line: [0, 0] id: 12
      r15_0.FriendCheck = r0_12
    end)
    r52_0:AddToggle("FollowCheck", {
      Title = "Follow Check",
      Description = "Toggles the Follow Check",
      Default = r15_0.FollowCheck,
    }):OnChanged(function(r0_26)
      -- line: [0, 0] id: 26
      r15_0.FollowCheck = r0_26
    end)
    r52_0:AddToggle("VerifiedBadgeCheck", {
      Title = "Verified Badge Check",
      Description = "Toggles the Verified Badge Check",
      Default = r15_0.VerifiedBadgeCheck,
    }):OnChanged(function(r0_141)
      -- line: [0, 0] id: 141
      r15_0.VerifiedBadgeCheck = r0_141
    end)
    r52_0:AddToggle("WallCheck", {
      Title = "Wall Check",
      Description = "Toggles the Wall Check",
      Default = r15_0.WallCheck,
    }):OnChanged(function(r0_19)
      -- line: [0, 0] id: 19
      r15_0.WallCheck = r0_19
    end)
    r52_0:AddToggle("WaterCheck", {
      Title = "Water Check",
      Description = "Toggles the Water Check if Wall Check is enabled",
      Default = r15_0.WaterCheck,
    }):OnChanged(function(r0_109)
      -- line: [0, 0] id: 109
      r15_0.WaterCheck = r0_109
    end)
    local r61_0 = r35_0.Checks:AddSection("Advanced Checks")
    r61_0:AddToggle("FoVCheck", {
      Title = "FoV Check",
      Description = "Toggles the FoV Check",
      Default = r15_0.FoVCheck,
    }):OnChanged(function(r0_45)
      -- line: [0, 0] id: 45
      r15_0.FoVCheck = r0_45
    end)
    r61_0:AddSlider("FoVRadius", {
      Title = "FoV Radius",
      Description = "Changes the FoV Radius",
      Default = r15_0.FoVRadius,
      Min = 10,
      Max = 1000,
      Rounding = 1,
      Callback = function(r0_13)
        -- line: [0, 0] id: 13
        r15_0.FoVRadius = r0_13
      end,
    })
    r61_0:AddToggle("MagnitudeCheck", {
      Title = "Magnitude Check",
      Description = "Toggles the Magnitude Check",
      Default = r15_0.MagnitudeCheck,
    }):OnChanged(function(r0_100)
      -- line: [0, 0] id: 100
      r15_0.MagnitudeCheck = r0_100
    end)
    r61_0:AddSlider("TriggerMagnitude", {
      Title = "Trigger Magnitude",
      Description = "Distance between the Native and the Target Character",
      Default = r15_0.TriggerMagnitude,
      Min = 10,
      Max = 1000,
      Rounding = 1,
      Callback = function(r0_60)
        -- line: [0, 0] id: 60
        r15_0.TriggerMagnitude = r0_60
      end,
    })
    r61_0:AddToggle("TransparencyCheck", {
      Title = "Transparency Check",
      Description = "Toggles the Transparency Check",
      Default = r15_0.TransparencyCheck,
    }):OnChanged(function(r0_90)
      -- line: [0, 0] id: 90
      r15_0.TransparencyCheck = r0_90
    end)
    r61_0:AddSlider("IgnoredTransparency", {
      Title = "Ignored Transparency",
      Description = "Target is ignored if its Transparency is > than / = to the set one",
      Default = r15_0.IgnoredTransparency,
      Min = 0.1,
      Max = 1,
      Rounding = 1,
      Callback = function(r0_116)
        -- line: [0, 0] id: 116
        r15_0.IgnoredTransparency = r0_116
      end,
    })
    r61_0:AddToggle("WhitelistedGroupCheck", {
      Title = "Whitelisted Group Check",
      Description = "Toggles the Whitelisted Group Check",
      Default = r15_0.WhitelistedGroupCheck,
    }):OnChanged(function(r0_52)
      -- line: [0, 0] id: 52
      r15_0.WhitelistedGroupCheck = r0_52
    end)
    r61_0:AddInput("WhitelistedGroup", {
      Title = "Whitelisted Group",
      Description = "After typing, press Enter",
      Default = r15_0.WhitelistedGroup,
      Numeric = true,
      Finished = true,
      Placeholder = "Group Id",
      Callback = function(r0_92)
        -- line: [0, 0] id: 92
        local r1_92 = r15_0
        local r2_92 = #tostring(r0_92)
        if r2_92 > 0 then
          r2_92 = tonumber(r0_92) or 0
        else
          goto label_12	-- block#2 is visited secondly
        end
        r1_92.WhitelistedGroup = r2_92
      end,
    })
    r61_0:AddToggle("BlacklistedGroupCheck", {
      Title = "Blacklisted Group Check",
      Description = "Toggles the Blacklisted Group Check",
      Default = r15_0.BlacklistedGroupCheck,
    }):OnChanged(function(r0_121)
      -- line: [0, 0] id: 121
      r15_0.BlacklistedGroupCheck = r0_121
    end)
    r61_0:AddInput("BlacklistedGroup", {
      Title = "Blacklisted Group",
      Description = "After typing, press Enter",
      Default = r15_0.BlacklistedGroup,
      Numeric = true,
      Finished = true,
      Placeholder = "Group Id",
      Callback = function(r0_29)
        -- line: [0, 0] id: 29
        local r1_29 = r15_0
        local r2_29 = #tostring(r0_29)
        if r2_29 > 0 then
          r2_29 = tonumber(r0_29) or 0
        else
          goto label_12	-- block#2 is visited secondly
        end
        r1_29.BlacklistedGroup = r2_29
      end,
    })
    local r67_0 = r35_0.Checks:AddSection("Expert Checks")
    r67_0:AddToggle("IgnoredPlayersCheck", {
      Title = "Ignored Players Check",
      Description = "Toggles the Ignored Players Check",
      Default = r15_0.IgnoredPlayersCheck,
    }):OnChanged(function(r0_53)
      -- line: [0, 0] id: 53
      r15_0.IgnoredPlayersCheck = r0_53
    end)
    local r69_0 = r67_0:AddDropdown("IgnoredPlayers", {
      Title = "Ignored Players",
      Description = "Sets the Ignored Players",
      Values = r15_0.IgnoredPlayersDropdownValues,
      Multi = true,
      Default = r15_0.IgnoredPlayers,
    })
    r69_0:OnChanged(function(r0_99)
      -- line: [0, 0] id: 99
      r15_0.IgnoredPlayers = {}
      for r4_99, r5_99 in next, r0_99, nil do
        if typeof(r4_99) == "string" then
          table.insert(r15_0.IgnoredPlayers, r4_99)
        end
      end
    end)
    r67_0:AddInput("AddIgnoredPlayer", {
      Title = "Add Ignored Player",
      Description = "After typing, press Enter",
      Finished = true,
      Placeholder = "Player Name",
      Callback = function(r0_86)
        -- line: [0, 0] id: 86
        if #r19_0(r0_86) > 0 then
          r0_86 = r19_0(r0_86)
          if r0_86 then
            ::label_11::
            if pcall(r4_0.GetUserIdFromNameAsync, r4_0, r0_86) and pcall(r4_0.GetNameFromUserIdAsync, r4_0, r4_0:GetUserIdFromNameAsync(r0_86)) then
              r0_86 = r4_0:GetNameFromUserIdAsync(r4_0:GetUserIdFromNameAsync(r0_86))
              if r0_86 then
                ::label_39::
                if string.sub(r0_86, 1, 1) == "@" then
                  if #r19_0(string.sub(r0_86, 2)) > 0 then
                    r0_86 = r19_0(string.sub(r0_86, 2))
                    if r0_86 and pcall(r4_0.GetUserIdFromNameAsync, r4_0, string.sub(r0_86, 2)) and pcall(r4_0.GetNameFromUserIdAsync, r4_0, r4_0:GetUserIdFromNameAsync(string.sub(r0_86, 2))) then
                      r0_86 = r4_0:GetNameFromUserIdAsync(r4_0:GetUserIdFromNameAsync(string.sub(r0_86, 2)))
                      if r0_86 then
                        ::label_106::
                        if string.sub(r0_86, 1, 1) == "#" and pcall(r4_0.GetNameFromUserIdAsync, r4_0, tonumber(string.sub(r0_86, 2))) then
                          r0_86 = r4_0:GetNameFromUserIdAsync(tonumber(string.sub(r0_86, 2))) or ""
                        else
                          goto label_140	-- block#14 is visited secondly
                        end
                      end
                    end
                  else
                    goto label_66	-- block#8 is visited secondly
                  end
                else
                  goto label_106	-- block#11 is visited secondly
                end
              end
            else
              goto label_39	-- block#5 is visited secondly
            end
          end
        else
          goto label_11	-- block#2 is visited secondly
        end
        if 0 < #r0_86 and not table.find(r15_0.IgnoredPlayersDropdownValues, r0_86) then
          table.insert(r15_0.IgnoredPlayersDropdownValues, r0_86)
          if not table.find(r15_0.IgnoredPlayers, r0_86) then
            r69_0.Value[r0_86] = true
            table.insert(r15_0.IgnoredPlayers, r0_86)
          end
          r69_0:BuildDropdownList()
        end
      end,
    })
    r67_0:AddInput("RemoveIgnoredPlayer", {
      Title = "Remove Ignored Player",
      Description = "After typing, press Enter",
      Finished = true,
      Placeholder = "Player Name",
      Callback = function(r0_55)
        -- line: [0, 0] id: 55
        if #r19_0(r0_55) > 0 then
          r0_55 = r19_0(r0_55)
          if r0_55 then
            ::label_11::
            if pcall(r4_0.GetUserIdFromNameAsync, r4_0, r0_55) and pcall(r4_0.GetNameFromUserIdAsync, r4_0, r4_0:GetUserIdFromNameAsync(r0_55)) then
              r0_55 = r4_0:GetNameFromUserIdAsync(r4_0:GetUserIdFromNameAsync(r0_55))
              if r0_55 then
                ::label_39::
                if string.sub(r0_55, 1, 1) == "@" then
                  if #r19_0(string.sub(r0_55, 2)) > 0 then
                    r0_55 = r19_0(string.sub(r0_55, 2))
                    if r0_55 and pcall(r4_0.GetUserIdFromNameAsync, r4_0, string.sub(r0_55, 2)) and pcall(r4_0.GetNameFromUserIdAsync, r4_0, r4_0:GetUserIdFromNameAsync(string.sub(r0_55, 2))) then
                      r0_55 = r4_0:GetNameFromUserIdAsync(r4_0:GetUserIdFromNameAsync(string.sub(r0_55, 2)))
                      if r0_55 then
                        ::label_106::
                        if string.sub(r0_55, 1, 1) == "#" and pcall(r4_0.GetNameFromUserIdAsync, r4_0, tonumber(string.sub(r0_55, 2))) then
                          r0_55 = r4_0:GetNameFromUserIdAsync(tonumber(string.sub(r0_55, 2))) or ""
                        else
                          goto label_140	-- block#14 is visited secondly
                        end
                      end
                    end
                  else
                    goto label_66	-- block#8 is visited secondly
                  end
                else
                  goto label_106	-- block#11 is visited secondly
                end
              end
            else
              goto label_39	-- block#5 is visited secondly
            end
          end
        else
          goto label_11	-- block#2 is visited secondly
        end
        if 0 < #r0_55 and table.find(r15_0.IgnoredPlayersDropdownValues, r0_55) then
          if table.find(r15_0.IgnoredPlayers, r0_55) then
            r69_0.Value[r0_55] = nil
            table.remove(r15_0.IgnoredPlayers, table.find(r15_0.IgnoredPlayers, r0_55))
            r69_0:Display()
          end
          table.remove(r15_0.IgnoredPlayersDropdownValues, table.find(r15_0.IgnoredPlayersDropdownValues, r0_55))
          r69_0:SetValues(r15_0.IgnoredPlayersDropdownValues)
        end
      end,
    })
    r67_0:AddButton({
      Title = "Deselect All Items",
      Description = "Deselects All Elements",
      Callback = function()
        -- line: [0, 0] id: 140
        local r0_140 = #r15_0.IgnoredPlayers
        r69_0:SetValue({})
        local r1_140 = r34_0
        local r3_140 = {}
        local r4_140 = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")
        r3_140.Title = r4_140
        if r0_140 == 0 then
          r4_140 = "Nothing has been deselected!"
          if not r4_140 then
            ::label_27::
            if r0_140 == 1 then
              r4_140 = "1 Item has been deselected!" or string.format("%s Items have been deselected!", r0_140)
            else
              goto label_32	-- block#4 is visited secondly
            end
          end
        else
          goto label_27	-- block#2 is visited secondly
        end
        r3_140.Content = r4_140
        r3_140.Buttons = {
          {
            Title = "Confirm",
          }
        }
        r1_140:Dialog(r3_140)
      end,
    })
    r67_0:AddButton({
      Title = "Clear Unselected Items",
      Description = "Removes Unselected Players",
      Callback = function()
        -- line: [0, 0] id: 56
        local r0_56 = {}
        local r1_56 = 0
        for r5_56, r6_56 in next, r15_0.IgnoredPlayersDropdownValues, nil do
          if table.find(r15_0.IgnoredPlayers, r6_56) then
            table.insert(r0_56, r6_56)
          else
            r1_56 = r1_56 + 1
          end
        end
        r15_0.IgnoredPlayersDropdownValues = r0_56
        r69_0:SetValues(r15_0.IgnoredPlayersDropdownValues)
        local r2_56 = r34_0
        local r4_56 = {}
        local r5_56 = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")
        r4_56.Title = r5_56
        if r1_56 == 0 then
          r5_56 = "Nothing has been cleared!"
          if not r5_56 then
            ::label_51::
            if r1_56 == 1 then
              r5_56 = "1 Item has been cleared!" or string.format("%s Items have been cleared!", r1_56)
            else
              goto label_56	-- block#9 is visited secondly
            end
          end
        else
          goto label_51	-- block#7 is visited secondly
        end
        r4_56.Content = r5_56
        r4_56.Buttons = {
          {
            Title = "Confirm",
          }
        }
        r2_56:Dialog(r4_56)
      end,
    })
    r67_0:AddToggle("TargetPlayersCheck", {
      Title = "Target Players Check",
      Description = "Toggles the Target Players Check",
      Default = r15_0.TargetPlayersCheck,
    }):OnChanged(function(r0_120)
      -- line: [0, 0] id: 120
      r15_0.TargetPlayersCheck = r0_120
    end)
    local r71_0 = r67_0:AddDropdown("TargetPlayers", {
      Title = "Target Players",
      Description = "Sets the Target Players",
      Values = r15_0.TargetPlayersDropdownValues,
      Multi = true,
      Default = r15_0.TargetPlayers,
    })
    r71_0:OnChanged(function(r0_95)
      -- line: [0, 0] id: 95
      r15_0.TargetPlayers = {}
      for r4_95, r5_95 in next, r0_95, nil do
        if typeof(r4_95) == "string" then
          table.insert(r15_0.TargetPlayers, r4_95)
        end
      end
    end)
    r67_0:AddInput("AddTargetPlayer", {
      Title = "Add Target Player",
      Description = "After typing, press Enter",
      Finished = true,
      Placeholder = "Player Name",
      Callback = function(r0_41)
        -- line: [0, 0] id: 41
        if #r19_0(r0_41) > 0 then
          r0_41 = r19_0(r0_41)
          if r0_41 then
            ::label_11::
            if pcall(r4_0.GetUserIdFromNameAsync, r4_0, r0_41) and pcall(r4_0.GetNameFromUserIdAsync, r4_0, r4_0:GetUserIdFromNameAsync(r0_41)) then
              r0_41 = r4_0:GetNameFromUserIdAsync(r4_0:GetUserIdFromNameAsync(r0_41))
              if r0_41 then
                ::label_39::
                if string.sub(r0_41, 1, 1) == "@" then
                  if #r19_0(string.sub(r0_41, 2)) > 0 then
                    r0_41 = r19_0(string.sub(r0_41, 2))
                    if r0_41 and pcall(r4_0.GetUserIdFromNameAsync, r4_0, string.sub(r0_41, 2)) and pcall(r4_0.GetNameFromUserIdAsync, r4_0, r4_0:GetUserIdFromNameAsync(string.sub(r0_41, 2))) then
                      r0_41 = r4_0:GetNameFromUserIdAsync(r4_0:GetUserIdFromNameAsync(string.sub(r0_41, 2)))
                      if r0_41 then
                        ::label_106::
                        if string.sub(r0_41, 1, 1) == "#" and pcall(r4_0.GetNameFromUserIdAsync, r4_0, tonumber(string.sub(r0_41, 2))) then
                          r0_41 = r4_0:GetNameFromUserIdAsync(tonumber(string.sub(r0_41, 2))) or ""
                        else
                          goto label_140	-- block#14 is visited secondly
                        end
                      end
                    end
                  else
                    goto label_66	-- block#8 is visited secondly
                  end
                else
                  goto label_106	-- block#11 is visited secondly
                end
              end
            else
              goto label_39	-- block#5 is visited secondly
            end
          end
        else
          goto label_11	-- block#2 is visited secondly
        end
        if 0 < #r0_41 and not table.find(r15_0.TargetPlayersDropdownValues, r0_41) then
          table.insert(r15_0.TargetPlayersDropdownValues, r0_41)
          if not table.find(r15_0.TargetPlayers, r0_41) then
            r71_0.Value[r0_41] = true
            table.insert(r15_0.TargetPlayers, r0_41)
          end
          r71_0:BuildDropdownList()
        end
      end,
    })
    r67_0:AddInput("RemoveTargetPlayer", {
      Title = "Remove Target Player",
      Description = "After typing, press Enter",
      Finished = true,
      Placeholder = "Player Name",
      Callback = function(r0_6)
        -- line: [0, 0] id: 6
        if #r19_0(r0_6) > 0 then
          r0_6 = r19_0(r0_6)
          if r0_6 then
            ::label_11::
            if pcall(r4_0.GetUserIdFromNameAsync, r4_0, r0_6) and pcall(r4_0.GetNameFromUserIdAsync, r4_0, r4_0:GetUserIdFromNameAsync(r0_6)) then
              r0_6 = r4_0:GetNameFromUserIdAsync(r4_0:GetUserIdFromNameAsync(r0_6))
              if r0_6 then
                ::label_39::
                if string.sub(r0_6, 1, 1) == "@" then
                  if #r19_0(string.sub(r0_6, 2)) > 0 then
                    r0_6 = r19_0(string.sub(r0_6, 2))
                    if r0_6 and pcall(r4_0.GetUserIdFromNameAsync, r4_0, string.sub(r0_6, 2)) and pcall(r4_0.GetNameFromUserIdAsync, r4_0, r4_0:GetUserIdFromNameAsync(string.sub(r0_6, 2))) then
                      r0_6 = r4_0:GetNameFromUserIdAsync(r4_0:GetUserIdFromNameAsync(string.sub(r0_6, 2)))
                      if r0_6 then
                        ::label_106::
                        if string.sub(r0_6, 1, 1) == "#" and pcall(r4_0.GetNameFromUserIdAsync, r4_0, tonumber(string.sub(r0_6, 2))) then
                          r0_6 = r4_0:GetNameFromUserIdAsync(tonumber(string.sub(r0_6, 2))) or ""
                        else
                          goto label_140	-- block#14 is visited secondly
                        end
                      end
                    end
                  else
                    goto label_66	-- block#8 is visited secondly
                  end
                else
                  goto label_106	-- block#11 is visited secondly
                end
              end
            else
              goto label_39	-- block#5 is visited secondly
            end
          end
        else
          goto label_11	-- block#2 is visited secondly
        end
        if 0 < #r0_6 and table.find(r15_0.TargetPlayersDropdownValues, r0_6) then
          if table.find(r15_0.TargetPlayers, r0_6) then
            r71_0.Value[r0_6] = nil
            table.remove(r15_0.TargetPlayers, table.find(r15_0.TargetPlayers, r0_6))
            r71_0:Display()
          end
          table.remove(r15_0.TargetPlayersDropdownValues, table.find(r15_0.TargetPlayersDropdownValues, r0_6))
          r71_0:SetValues(r15_0.TargetPlayersDropdownValues)
        end
      end,
    })
    r67_0:AddButton({
      Title = "Deselect All Items",
      Description = "Deselects All Elements",
      Callback = function()
        -- line: [0, 0] id: 96
        local r0_96 = #r15_0.TargetPlayers
        r71_0:SetValue({})
        local r1_96 = r34_0
        local r3_96 = {}
        local r4_96 = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")
        r3_96.Title = r4_96
        if r0_96 == 0 then
          r4_96 = "Nothing has been deselected!"
          if not r4_96 then
            ::label_27::
            if r0_96 == 1 then
              r4_96 = "1 Item has been deselected!" or string.format("%s Items have been deselected!", r0_96)
            else
              goto label_32	-- block#4 is visited secondly
            end
          end
        else
          goto label_27	-- block#2 is visited secondly
        end
        r3_96.Content = r4_96
        r3_96.Buttons = {
          {
            Title = "Confirm",
          }
        }
        r1_96:Dialog(r3_96)
      end,
    })
    r67_0:AddButton({
      Title = "Clear Unselected Items",
      Description = "Removes Unselected Players",
      Callback = function()
        -- line: [0, 0] id: 123
        local r0_123 = {}
        local r1_123 = 0
        for r5_123, r6_123 in next, r15_0.TargetPlayersDropdownValues, nil do
          if table.find(r15_0.TargetPlayers, r6_123) then
            table.insert(r0_123, r6_123)
          else
            r1_123 = r1_123 + 1
          end
        end
        r15_0.TargetPlayersDropdownValues = r0_123
        r71_0:SetValues(r15_0.TargetPlayersDropdownValues)
        local r2_123 = r34_0
        local r4_123 = {}
        local r5_123 = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")
        r4_123.Title = r5_123
        if r1_123 == 0 then
          r5_123 = "Nothing has been cleared!"
          if not r5_123 then
            ::label_51::
            if r1_123 == 1 then
              r5_123 = "1 Item has been cleared!" or string.format("%s Items have been cleared!", r1_123)
            else
              goto label_56	-- block#9 is visited secondly
            end
          end
        else
          goto label_51	-- block#7 is visited secondly
        end
        r4_123.Content = r5_123
        r4_123.Buttons = {
          {
            Title = "Confirm",
          }
        }
        r2_123:Dialog(r4_123)
      end,
    })
    if DEBUG or getfenv().Drawing and getfenv().Drawing.new then
      r35_0.Visuals = r34_0:AddTab({
        Title = "Visuals",
        Icon = "box",
      })
      local r72_0 = r35_0.Visuals:AddSection("FoV")
      r72_0:AddToggle("FoV", {
        Title = "FoV",
        Description = "Graphically Displays the FoV Radius",
        Default = r15_0.FoV,
      }):OnChanged(function(r0_105)
        -- line: [0, 0] id: 105
        r15_0.FoV = r0_105
        if not r18_0 then
          r31_0 = r0_105
        end
      end)
      if r18_0 then
        local r74_0 = r72_0:AddKeybind("FoVKey", {
          Title = "FoV Key",
          Description = "Changes the FoV Key",
          Default = r15_0.FoVKey,
          ChangedCallback = function(r0_22)
            -- line: [0, 0] id: 22
            r15_0.FoVKey = r0_22
          end,
        })
        local r75_0 = r74_0.Value
        if r75_0 ~= "RMB" then
          r75_0 = Enum.KeyCode[r74_0.Value] or Enum.UserInputType.MouseButton2
        else
          goto label_1784	-- block#196 is visited secondly
        end
        r15_0.FoVKey = r75_0
      end
      r72_0:AddSlider("FoVThickness", {
        Title = "FoV Thickness",
        Description = "Changes the FoV Thickness",
        Default = r15_0.FoVThickness,
        Min = 1,
        Max = 10,
        Rounding = 1,
        Callback = function(r0_136)
          -- line: [0, 0] id: 136
          r15_0.FoVThickness = r0_136
        end,
      })
      r72_0:AddSlider("FoVOpacity", {
        Title = "FoV Opacity",
        Description = "Changes the FoV Opacity",
        Default = r15_0.FoVOpacity,
        Min = 0.1,
        Max = 1,
        Rounding = 1,
        Callback = function(r0_30)
          -- line: [0, 0] id: 30
          r15_0.FoVOpacity = r0_30
        end,
      })
      r72_0:AddToggle("FoVFilled", {
        Title = "FoV Filled",
        Description = "Makes the FoV Filled",
        Default = r15_0.FoVFilled,
      }):OnChanged(function(r0_46)
        -- line: [0, 0] id: 46
        r15_0.FoVFilled = r0_46
      end)
      local r77_0 = "AddColorpicker"
      r77_0 = "FoVColour"
      r72_0:[r77_0](r77_0, {
        Title = "FoV Colour",
        Description = "Changes the FoV Colour",
        Default = r15_0.FoVColour,
        Callback = function(r0_40)
          -- line: [0, 0] id: 40
          r15_0.FoVColour = r0_40
        end,
      })
      local r75_0 = r35_0.Visuals:AddSection("ESP")
      r75_0:AddToggle("SmartESP", {
        Title = "Smart ESP",
        Description = "Does not ESP the Whitelisted Players",
        Default = r15_0.SmartESP,
      }):OnChanged(function(r0_33)
        -- line: [0, 0] id: 33
        r15_0.SmartESP = r0_33
      end)
      if r18_0 then
        r77_0 = r75_0:AddKeybind("ESPKey", {
          Title = "ESP Key",
          Description = "Changes the ESP Key",
          Default = r15_0.ESPKey,
          ChangedCallback = function(r0_114)
            -- line: [0, 0] id: 114
            r15_0.ESPKey = r0_114
          end,
        })
        local r78_0 = r77_0.Value
        if r78_0 ~= "RMB" then
          r78_0 = Enum.KeyCode[r77_0.Value] or Enum.UserInputType.MouseButton2
        else
          goto label_1897	-- block#201 is visited secondly
        end
        r15_0.ESPKey = r78_0
      end
      r75_0:AddToggle("ESPBox", {
        Title = "ESP Box",
        Description = "Creates the ESP Box around the Players",
        Default = r15_0.ESPBox,
      }):OnChanged(function(r0_18)
        -- line: [0, 0] id: 18
        r15_0.ESPBox = r0_18
        if not r18_0 then
          if r0_18 then
            r32_0 = true
          elseif not r15_0.ESPBox and not r15_0.NameESP and not r15_0.HealthESP and not r15_0.MagnitudeESP and not r15_0.TracerESP then
            r32_0 = false
          end
        end
      end)
      r75_0:AddToggle("ESPBoxFilled", {
        Title = "ESP Box Filled",
        Description = "Makes the ESP Box Filled",
        Default = r15_0.ESPBoxFilled,
      }):OnChanged(function(r0_94)
        -- line: [0, 0] id: 94
        r15_0.ESPBoxFilled = r0_94
      end)
      r75_0:AddToggle("NameESP", {
        Title = "Name ESP",
        Description = "Creates the Name ESP above the Players",
        Default = r15_0.NameESP,
      }):OnChanged(function(r0_54)
        -- line: [0, 0] id: 54
        r15_0.NameESP = r0_54
        if not r18_0 then
          if r0_54 then
            r32_0 = true
          elseif not r15_0.ESPBox and not r15_0.NameESP and not r15_0.HealthESP and not r15_0.MagnitudeESP and not r15_0.TracerESP then
            r32_0 = false
          end
        end
      end)
      r75_0:AddDropdown("NameESPFont", {
        Title = "Name ESP Font",
        Description = "Changes the Name ESP Font",
        Values = {
          "UI",
          "System",
          "Plex",
          "Monospace"
        },
        Default = r15_0.NameESPFont,
        Callback = function(r0_49)
          -- line: [0, 0] id: 49
          r15_0.NameESPFont = r0_49
        end,
      })
      r75_0:AddSlider("NameESPSize", {
        Title = "Name ESP Size",
        Description = "Changes the Name ESP Size",
        Default = r15_0.NameESPSize,
        Min = 8,
        Max = 28,
        Rounding = 1,
        Callback = function(r0_130)
          -- line: [0, 0] id: 130
          r15_0.NameESPSize = r0_130
        end,
      })
      local r82_0 = "AddColorpicker"
      r82_0 = "NameESPOutlineColour"
      r75_0:[r82_0](r82_0, {
        Title = "Name ESP Outline",
        Description = "Changes the Name ESP Outline Colour",
        Default = r15_0.NameESPOutlineColour,
        Callback = function(r0_25)
          -- line: [0, 0] id: 25
          r15_0.NameESPOutlineColour = r0_25
        end,
      })
      r75_0:AddToggle("HealthESP", {
        Title = "Health ESP",
        Description = "Creates the Health ESP in the ESP Box",
        Default = r15_0.HealthESP,
      }):OnChanged(function(r0_78)
        -- line: [0, 0] id: 78
        r15_0.HealthESP = r0_78
        if not r18_0 then
          if r0_78 then
            r32_0 = true
          elseif not r15_0.ESPBox and not r15_0.NameESP and not r15_0.HealthESP and not r15_0.MagnitudeESP and not r15_0.TracerESP then
            r32_0 = false
          end
        end
      end)
      r75_0:AddToggle("MagnitudeESP", {
        Title = "Magnitude ESP",
        Description = "Creates the Magnitude ESP in the ESP Box",
        Default = r15_0.MagnitudeESP,
      }):OnChanged(function(r0_77)
        -- line: [0, 0] id: 77
        r15_0.MagnitudeESP = r0_77
        if not r18_0 then
          if r0_77 then
            r32_0 = true
          elseif not r15_0.ESPBox and not r15_0.NameESP and not r15_0.HealthESP and not r15_0.MagnitudeESP and not r15_0.TracerESP then
            r32_0 = false
          end
        end
      end)
      r75_0:AddToggle("TracerESP", {
        Title = "Tracer ESP",
        Description = "Creates the Tracer ESP in the direction of the Players",
        Default = r15_0.TracerESP,
      }):OnChanged(function(r0_48)
        -- line: [0, 0] id: 48
        r15_0.TracerESP = r0_48
        if not r18_0 then
          if r0_48 then
            r32_0 = true
          elseif not r15_0.ESPBox and not r15_0.NameESP and not r15_0.HealthESP and not r15_0.MagnitudeESP and not r15_0.TracerESP then
            r32_0 = false
          end
        end
      end)
      r75_0:AddSlider("ESPThickness", {
        Title = "ESP Thickness",
        Description = "Changes the ESP Thickness",
        Default = r15_0.ESPThickness,
        Min = 1,
        Max = 10,
        Rounding = 1,
        Callback = function(r0_147)
          -- line: [0, 0] id: 147
          r15_0.ESPThickness = r0_147
        end,
      })
      r75_0:AddSlider("ESPOpacity", {
        Title = "ESP Opacity",
        Description = "Changes the ESP Opacity",
        Default = r15_0.ESPOpacity,
        Min = 0.1,
        Max = 1,
        Rounding = 1,
        Callback = function(r0_8)
          -- line: [0, 0] id: 8
          r15_0.ESPOpacity = r0_8
        end,
      })
      local r85_0 = "AddColorpicker"
      r85_0 = "ESPColour"
      r75_0:[r85_0](r85_0, {
        Title = "ESP Colour",
        Description = "Changes the ESP Colour",
        Default = r15_0.ESPColour,
        Callback = function(r0_145)
          -- line: [0, 0] id: 145
          r15_0.ESPColour = r0_145
        end,
      })
      r75_0:AddToggle("ESPUseTeamColour", {
        Title = "Use Team Colour",
        Description = "Makes the ESP Colour match the Target Player Team",
        Default = r15_0.ESPUseTeamColour,
      }):OnChanged(function(r0_139)
        -- line: [0, 0] id: 139
        r15_0.ESPUseTeamColour = r0_139
      end)
      local r84_0 = r35_0.Visuals:AddSection("Visuals")
      r84_0:AddToggle("RainbowVisuals", {
        Title = "Rainbow Visuals",
        Description = "Makes the Visuals Rainbow",
        Default = r15_0.RainbowVisuals,
      }):OnChanged(function(r0_66)
        -- line: [0, 0] id: 66
        r15_0.RainbowVisuals = r0_66
      end)
      r84_0:AddSlider("RainbowDelay", {
        Title = "Rainbow Delay",
        Description = "Changes the Rainbow Delay",
        Default = r15_0.RainbowDelay,
        Min = 1,
        Max = 10,
        Rounding = 1,
        Callback = function(r0_153)
          -- line: [0, 0] id: 153
          r15_0.RainbowDelay = r0_153
        end,
      })
    else
      r22_0 = true
    end
    r35_0.Misc = r34_0:AddTab({
      Title = "Misc",
      Icon = "dices",
    })
    local r72_0 = r35_0.Misc:AddSection("Scripts")
    r35_0.Misc:AddButton({
      Title = "IY",
      Description = "Infinite yield.",
      Callback = function()
        -- line: [0, 0] id: 148
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
      end,
    })
    r35_0.Misc:AddButton({
      Title = "DEX",
      Description = "Dex explorer.",
      Callback = function()
        -- line: [0, 0] id: 111
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MariyaFurmanova/Library/main/dex2.0", true))()
      end,
    })
    r35_0.Misc:AddButton({
      Title = "Noclip",
      Description = "Simple noclip script with GUI.",
      Callback = function()
        -- line: [0, 0] id: 2
        local r0_2 = game:GetService("Workspace")
        local r1_2 = game:GetService("CoreGui")
        local r2_2 = game:GetService("Players")
        local r3_2 = Instance.new("ScreenGui")
        local r4_2 = Instance.new("Frame")
        local r5_2 = Instance.new("TextLabel")
        local r6_2 = Instance.new("TextButton")
        local r7_2 = Instance.new("TextLabel")
        local r8_2 = Instance.new("TextLabel")
        local r9_2 = r2_2.LocalPlayer
        local r10_2 = false
        r3_2.Name = "Noclip"
        r3_2.Parent = game.CoreGui
        r4_2.Name = "BG"
        r4_2.Parent = r3_2
        r4_2.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
        r4_2.BorderColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
        r4_2.BorderSizePixel = 2
        r4_2.Position = UDim2.new(0.149479166, 0, 0.82087779, 0)
        r4_2.Size = UDim2.new(0, 210, 0, 127)
        r4_2.Active = true
        r4_2.Draggable = true
        r5_2.Name = "Title"
        r5_2.Parent = r4_2
        r5_2.BackgroundColor3 = Color3.new(0.266667, 0.00392157, 0.627451)
        r5_2.BorderColor3 = Color3.new(0.180392, 0, 0.431373)
        r5_2.BorderSizePixel = 2
        r5_2.Size = UDim2.new(0, 210, 0, 33)
        r5_2.Font = Enum.Font.Highway
        r5_2.Text = "Noclip"
        r5_2.TextColor3 = Color3.new(1, 1, 1)
        r5_2.FontSize = Enum.FontSize.Size32
        r5_2.TextSize = 30
        r5_2.TextStrokeColor3 = Color3.new(0.180392, 0, 0.431373)
        r5_2.TextStrokeTransparency = 0
        r6_2.Parent = r4_2
        r6_2.BackgroundColor3 = Color3.new(0.266667, 0.00392157, 0.627451)
        r6_2.BorderColor3 = Color3.new(0.180392, 0, 0.431373)
        r6_2.BorderSizePixel = 2
        r6_2.Position = UDim2.new(0.152380958, 0, 0.374192119, 0)
        r6_2.Size = UDim2.new(0, 146, 0, 36)
        r6_2.Font = Enum.Font.Highway
        r6_2.FontSize = Enum.FontSize.Size28
        r6_2.Text = "Toggle"
        r6_2.TextColor3 = Color3.new(1, 1, 1)
        r6_2.TextSize = 25
        r6_2.TextStrokeColor3 = Color3.new(0.180392, 0, 0.431373)
        r6_2.TextStrokeTransparency = 0
        r7_2.Name = "StatusPF"
        r7_2.Parent = r4_2
        r7_2.BackgroundColor3 = Color3.new(1, 1, 1)
        r7_2.BackgroundTransparency = 1
        r7_2.Position = UDim2.new(0.314285725, 0, 0.708661377, 0)
        r7_2.Size = UDim2.new(0, 56, 0, 20)
        r7_2.Font = Enum.Font.Highway
        r7_2.FontSize = Enum.FontSize.Size24
        r7_2.Text = "Status:"
        r7_2.TextColor3 = Color3.new(1, 1, 1)
        r7_2.TextSize = 20
        r7_2.TextStrokeColor3 = Color3.new(0.333333, 0.333333, 0.333333)
        r7_2.TextStrokeTransparency = 0
        r7_2.TextWrapped = true
        r8_2.Name = "Status"
        r8_2.Parent = r4_2
        r8_2.BackgroundColor3 = Color3.new(1, 1, 1)
        r8_2.BackgroundTransparency = 1
        r8_2.Position = UDim2.new(0.580952346, 0, 0.708661377, 0)
        r8_2.Size = UDim2.new(0, 56, 0, 20)
        r8_2.Font = Enum.Font.Highway
        r8_2.FontSize = Enum.FontSize.Size14
        r8_2.Text = "off"
        r8_2.TextColor3 = Color3.new(0.666667, 0, 0)
        r8_2.TextScaled = true
        r8_2.TextSize = 14
        r8_2.TextStrokeColor3 = Color3.new(0.180392, 0, 0.431373)
        r8_2.TextWrapped = true
        r8_2.TextXAlignment = Enum.TextXAlignment.Left
        r6_2.MouseButton1Click:connect(function()
          -- line: [0, 0] id: 3
          if r8_2.Text == "off" then
            r10_2 = true
            r8_2.Text = "on"
            r8_2.TextColor3 = Color3.new(0, 185, 0)
            Stepped = game:GetService("RunService").Stepped:Connect(function()
              -- line: [0, 0] id: 4
              if not r10_2 == false then
                for r3_4, r4_4 in pairs(r0_2:GetChildren()) do
                  if r4_4.Name == r9_2.Name then
                    for r8_4, r9_4 in pairs(r0_2[r9_2.Name]:GetChildren()) do
                      if r9_4:IsA("BasePart") then
                        r9_4.CanCollide = false
                      end
                    end
                  end
                end
              else
                Stepped:Disconnect()
              end
            end)
          elseif r8_2.Text == "on" then
            r10_2 = false
            r8_2.Text = "off"
            r8_2.TextColor3 = Color3.new(170, 0, 0)
          end
        end)
      end,
    })
    r35_0.Settings = r34_0:AddTab({
      Title = "Settings",
      Icon = "settings",
    })
    local r73_0 = r35_0.Settings:AddSection("UI")
    r73_0:AddDropdown("Theme", {
      Title = "Theme",
      Description = "Changes the UI Theme",
      Values = r21_0.Themes,
      Default = r21_0.Theme,
      Callback = function(r0_64)
        -- line: [0, 0] id: 64
        r21_0:SetTheme(r0_64)
        r11_0.Theme = r0_64
        r12_0:ExportSettings()
      end,
    })
    if r21_0.UseAcrylic then
      r73_0:AddToggle("Acrylic", {
        Title = "Acrylic",
        Description = "Blurred Background requires Graphic Quality >= 8",
        Default = r21_0.Acrylic,
        Callback = function(r0_69)
          -- line: [0, 0] id: 69
          if not r0_69 or not r11_0.ShowWarnings then
            r21_0:ToggleAcrylic(r0_69)
          elseif r11_0.ShowWarnings then
            r34_0:Dialog({
              Title = "Warning",
              Content = "This Option can be detected! Activate it anyway?",
              Buttons = {
                {
                  Title = "Confirm",
                  Callback = function()
                    -- line: [0, 0] id: 71
                    r21_0:ToggleAcrylic(r0_69)
                  end,
                },
                {
                  Title = "Cancel",
                  Callback = function()
                    -- line: [0, 0] id: 70
                    r21_0.Options.Acrylic:SetValue(false)
                  end,
                }
              },
            })
          end
        end,
      })
    end
    r73_0:AddToggle("Transparency", {
      Title = "Transparency",
      Description = "Makes the UI Transparent",
      Default = r11_0.Transparency,
      Callback = function(r0_102)
        -- line: [0, 0] id: 102
        r21_0:ToggleTransparency(r0_102)
        r11_0.Transparency = r0_102
        r12_0:ExportSettings()
      end,
    })
    if r18_0 then
      r73_0:AddKeybind("MinimizeKey", {
        Title = "Minimize Key",
        Description = "Changes the Minimize Key",
        Default = r21_0.MinimizeKey,
        ChangedCallback = function()
          -- line: [0, 0] id: 75
          r11_0.MinimizeKey = r21_0.Options.MinimizeKey.Value
          r12_0:ExportSettings()
        end,
      })
      r21_0.MinimizeKeybind = r21_0.Options.MinimizeKey
    end
    local r74_0 = r35_0.Settings:AddSection("Notifications & Warnings")
    r74_0:AddToggle("ShowNotifications", {
      Title = "Show Notifications",
      Description = "Toggles the Notifications Show",
      Default = r11_0.ShowNotifications,
    }):OnChanged(function(r0_38)
      -- line: [0, 0] id: 38
      r21_0.ShowNotifications = r0_38
      r11_0.ShowNotifications = r0_38
      r12_0:ExportSettings()
    end)
    r74_0:AddToggle("ShowWarnings", {
      Title = "Show Warnings",
      Description = "Toggles the Security Warnings Show",
      Default = r11_0.ShowWarnings,
    }):OnChanged(function(r0_74)
      -- line: [0, 0] id: 74
      r11_0.ShowWarnings = r0_74
      r12_0:ExportSettings()
    end)
    local r77_0 = r35_0.Settings:AddSection("Performance")
    local r80_0 = "AddParagraph"
    r80_0 = {
      Title = "NOTE",
      Content = "Heartbeat fires every frame, after the physics simulation has completed. RenderStepped fires every frame, prior to the frame being rendered. Stepped fires every frame, prior to the physics simulation.",
    }
    r77_0:[r80_0](r80_0)
    r77_0:AddDropdown("RenderingMode", {
      Title = "Rendering Mode",
      Description = "Changes the Rendering Mode",
      Values = {
        "Heartbeat",
        "RenderStepped",
        "Stepped"
      },
      Default = r11_0.RenderingMode,
      Callback = function(r0_89)
        -- line: [0, 0] id: 89
        r11_0.RenderingMode = r0_89
        r12_0:ExportSettings()
        r34_0:Dialog({
          Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
          Content = "Changes will take effect after the Restart!",
          Buttons = {
            {
              Title = "Confirm",
            }
          },
        })
      end,
    })
    if getfenv().isfile and getfenv().readfile and getfenv().writefile and getfenv().delfile then
      local r78_0 = r35_0.Settings:AddSection("Configuration Manager")
      r78_0:AddToggle("AutoImport", {
        Title = "Auto Import",
        Description = "Toggles the Auto Import",
        Default = r11_0.AutoImport,
      }):OnChanged(function(r0_43)
        -- line: [0, 0] id: 43
        r11_0.AutoImport = r0_43
        r12_0:ExportSettings()
      end)
      local r82_0 = "AddParagraph"
      r82_0 = {
        Title = string.format("Manager for %s", game.Name),
        Content = string.format("Universe ID is %s", game.GameId),
      }
      r78_0:[r82_0](r82_0)
      r78_0:AddButton({
        Title = "Import Configuration File",
        Description = "Loads the Game Configuration File",
        Callback = function()
          -- line: [0, 0] id: 149
          xpcall(function()
            -- line: [0, 0] id: 151
            if getfenv().isfile(string.format("%s.64ware", game.GameId)) and getfenv().readfile(string.format("%s.64ware", game.GameId)) then
              local r7_151 = nil	-- notice: implicit variable refs by block#[11]
              for r4_151, r5_151 in next, r3_0:JSONDecode(getfenv().readfile(string.format("%s.64ware", game.GameId))), nil do
                if r4_151 == "AimKey" or r4_151 == "SpinKey" or r4_151 == "TriggerKey" or r4_151 == "FoVKey" or r4_151 == "ESPKey" then
                  r21_0.Options[r4_151]:SetValue(r5_151)
                  local r6_151 = r15_0
                  if r5_151 ~= "RMB" then
                    r7_151 = Enum.KeyCode[r5_151]
                    if not r7_151 then
                      ::label_65::
                      r7_151 = Enum.UserInputType.MouseButton2
                    end
                  else
                    goto label_65	-- block#10 is visited secondly
                  end
                  r6_151[r4_151] = r7_151
                elseif r4_151 == "AimPart" or r4_151 == "SpinPart" or typeof(r15_0[r4_151]) == "table" then
                  r15_0[r4_151] = r5_151
                elseif r4_151 == "FoVColour" or r4_151 == "NameESPOutlineColour" or r4_151 == "ESPColour" then
                  r21_0.Options[r4_151]:SetValueRGB(r13_0:UnpackColour(r5_151))
                elseif r15_0[r4_151] ~= nil and r21_0.Options[r4_151] then
                  r21_0.Options[r4_151]:SetValue(r5_151)
                end
              end
              for r4_151, r5_151 in next, r21_0.Options, nil do
                if r5_151.Type == "Dropdown" then
                  if r4_151 == "SilentAimMethods" then
                    local r6_151 = {}
                    r7_151 = next
                    for r10_151, r11_151 in r7_151, r15_0.SilentAimMethods, nil do
                      r6_151[r11_151] = true
                    end
                    r5_151:SetValue(r6_151)
                  elseif r4_151 == "AimPart" then
                    r5_151:SetValues(r15_0.AimPartDropdownValues)
                    r5_151:SetValue(r15_0.AimPart)
                  elseif r4_151 == "SpinPart" then
                    r5_151:SetValues(r15_0.SpinPartDropdownValues)
                    r5_151:SetValue(r15_0.SpinPart)
                  elseif r4_151 == "IgnoredPlayers" then
                    r5_151:SetValues(r15_0.IgnoredPlayersDropdownValues)
                    local r6_151 = {}
                    r7_151 = next
                    for r10_151, r11_151 in r7_151, r15_0.IgnoredPlayers, nil do
                      r6_151[r11_151] = true
                    end
                    r5_151:SetValue(r6_151)
                  elseif r4_151 == "TargetPlayers" then
                    r5_151:SetValues(r15_0.TargetPlayersDropdownValues)
                    local r6_151 = {}
                    r7_151 = next
                    for r10_151, r11_151 in r7_151, r15_0.TargetPlayers, nil do
                      r6_151[r11_151] = true
                    end
                    r5_151:SetValue(r6_151)
                  end
                end
              end
              r34_0:Dialog({
                Title = "Configuration Manager",
                Content = string.format("Configuration File %s.64ware has been successfully loaded!", game.GameId),
                Buttons = {
                  {
                    Title = "Confirm",
                  }
                },
              })
            else
              r34_0:Dialog({
                Title = "Configuration Manager",
                Content = string.format("Configuration File %s.64ware could not be found!", game.GameId),
                Buttons = {
                  {
                    Title = "Confirm",
                  }
                },
              })
            end
          end, function()
            -- line: [0, 0] id: 150
            r34_0:Dialog({
              Title = "Configuration Manager",
              Content = string.format("An Error occurred when loading the Configuration File %s.64ware", game.GameId),
              Buttons = {
                {
                  Title = "Confirm",
                }
              },
            })
          end)
        end,
      })
      r78_0:AddButton({
        Title = "Export Configuration File",
        Description = "Overwrites the Game Configuration File",
        Callback = function()
          -- line: [0, 0] id: 131
          xpcall(function()
            -- line: [0, 0] id: 132
            local r0_132 = {
              __LAST_UPDATED__ = os.date(),
            }
            for r4_132, r5_132 in next, r15_0, nil do
              if r4_132 == "AimKey" or r4_132 == "SpinKey" or r4_132 == "TriggerKey" or r4_132 == "FoVKey" or r4_132 == "ESPKey" then
                r0_132[r4_132] = r21_0.Options[r4_132].Value
              elseif r4_132 == "FoVColour" or r4_132 == "NameESPOutlineColour" or r4_132 == "ESPColour" then
                r0_132[r4_132] = r13_0:PackColour(r5_132)
              else
                r0_132[r4_132] = r5_132
              end
            end
            getfenv().writefile(string.format("%s.64ware", game.GameId), r3_0:JSONEncode(r0_132))
            r34_0:Dialog({
              Title = "Configuration Manager",
              Content = string.format("Configuration File %s.64ware has been successfully overwritten!", game.GameId),
              Buttons = {
                {
                  Title = "Confirm",
                }
              },
            })
          end, function()
            -- line: [0, 0] id: 133
            r34_0:Dialog({
              Title = "Configuration Manager",
              Content = string.format("An Error occurred when overwriting the Configuration File %s.64ware", game.GameId),
              Buttons = {
                {
                  Title = "Confirm",
                }
              },
            })
          end)
        end,
      })
      r78_0:AddButton({
        Title = "Delete Configuration File",
        Description = "Removes the Game Configuration File",
        Callback = function()
          -- line: [0, 0] id: 85
          if getfenv().isfile(string.format("%s.64ware", game.GameId)) then
            getfenv().delfile(string.format("%s.64ware", game.GameId))
            r34_0:Dialog({
              Title = "Configuration Manager",
              Content = string.format("Configuration File %s.64ware has been successfully removed!", game.GameId),
              Buttons = {
                {
                  Title = "Confirm",
                }
              },
            })
          else
            r34_0:Dialog({
              Title = "Configuration Manager",
              Content = string.format("Configuration File %s.64ware could not be found!", game.GameId),
              Buttons = {
                {
                  Title = "Confirm",
                }
              },
            })
          end
        end,
      })
    else
      r22_0 = true
    end
    local r78_0 = r35_0.Settings:AddSection("Discord")
    if getfenv().setclipboard then
      r78_0:AddButton({
        Title = "Copy Invite Link",
        Description = "Paste it into the Browser Tab",
        Callback = function()
          -- line: [0, 0] id: 119
          getfenv().setclipboard("https://discord.gg/UDww3uCD")
          r34_0:Dialog({
            Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
            Content = "Invite Link has been copied to the Clipboard!",
            Buttons = {
              {
                Title = "Confirm",
              }
            },
          })
        end,
      })
    end
    -- close: r34_0
    r34_0 = {
      ResetAimbotFields = function(r0_59, r1_59, r2_59)
        -- line: [0, 0] id: 59
        local r3_59 = nil	-- notice: implicit variable refs by block#[3, 6]
        if r1_59 then
          r3_59 = r25_0
          if not r3_59 then
            ::label_5::
            r3_59 = false
          end
        else
          goto label_5	-- block#2 is visited secondly
        end
        r25_0 = r3_59
        if r2_59 then
          r3_59 = r26_0
          if not r3_59 then
            ::label_12::
            r3_59 = nil
          end
        else
          goto label_12	-- block#5 is visited secondly
        end
        r26_0 = r3_59
        r3_59 = r27_0
        if r3_59 then
          r27_0:Cancel()
          r3_59 = nil
          r27_0 = r3_59
        end
        r3_59 = r5_0
        r3_59.MouseDeltaSensitivity = r28_0
      end,
    }
    r35_0 = "ResetSecondaryFields"
    function r36_0(r0_23)
      -- line: [0, 0] id: 23
      r29_0 = false
      r30_0 = false
      r31_0 = false
      r32_0 = false
    end
    r34_0[r35_0] = r36_0
    if r18_0 then
      r35_0 = nil
      r35_0 = r5_0.InputBegan:Connect(function(r0_80)
        -- line: [0, 0] id: 80
        if not r21_0 then
          r35_0:Disconnect()
        elseif not r5_0:GetFocusedTextBox() then
          if r15_0.Aimbot and (r0_80.KeyCode == r15_0.AimKey or r0_80.UserInputType == r15_0.AimKey) then
            if r25_0 then
              r34_0:ResetAimbotFields()
              Notify("[Aiming Mode]: OFF")
            else
              r25_0 = true
              Notify("[Aiming Mode]: ON")
            end
          elseif r15_0.SpinBot and (r0_80.KeyCode == r15_0.SpinKey or r0_80.UserInputType == r15_0.SpinKey) then
            if r29_0 then
              r29_0 = false
              Notify("[Spinning Mode]: OFF")
            else
              r29_0 = true
              Notify("[Spinning Mode]: ON")
            end
          elseif not DEBUG and getfenv().mouse1click and r15_0.TriggerBot and (r0_80.KeyCode == r15_0.TriggerKey or r0_80.UserInputType == r15_0.TriggerKey) then
            if r30_0 then
              r30_0 = false
              Notify("[Triggering Mode]: OFF")
            else
              r30_0 = true
              Notify("[Triggering Mode]: ON")
            end
          elseif not DEBUG and getfenv().Drawing and getfenv().Drawing.new and r15_0.FoV and (r0_80.KeyCode == r15_0.FoVKey or r0_80.UserInputType == r15_0.FoVKey) then
            if r31_0 then
              r31_0 = false
              Notify("[FoV Show]: OFF")
            else
              r31_0 = true
              Notify("[FoV Show]: ON")
            end
          elseif not DEBUG and getfenv().Drawing and getfenv().Drawing.new and (r15_0.ESPBox or r15_0.NameESP or r15_0.HealthESP or r15_0.MagnitudeESP or r15_0.TracerESP) and (r0_80.KeyCode == r15_0.ESPKey or r0_80.UserInputType == r15_0.ESPKey) then
            if r32_0 then
              r32_0 = false
              Notify("[ESP Show]: OFF")
            else
              r32_0 = true
              Notify("[ESP Show]: ON")
            end
          end
        end
      end)
      r36_0 = nil
      r36_0 = r5_0.InputEnded:Connect(function(r0_24)
        -- line: [0, 0] id: 24
        if not r21_0 then
          r36_0:Disconnect()
        elseif not r5_0:GetFocusedTextBox() then
          if r25_0 and not r15_0.OnePressAimingMode and (r0_24.KeyCode == r15_0.AimKey or r0_24.UserInputType == r15_0.AimKey) then
            r34_0:ResetAimbotFields()
            Notify("[Aiming Mode]: OFF")
          elseif r29_0 and not r15_0.OnePressSpinningMode and (r0_24.KeyCode == r15_0.SpinKey or r0_24.UserInputType == r15_0.SpinKey) then
            r29_0 = false
            Notify("[Spinning Mode]: OFF")
          elseif r30_0 and not r15_0.OnePressTriggeringMode and (r0_24.KeyCode == r15_0.TriggerKey or r0_24.UserInputType == r15_0.TriggerKey) then
            r30_0 = false
            Notify("[Triggering Mode]: OFF")
          end
        end
      end)
      r37_0 = nil
      function r40_0()
        -- line: [0, 0] id: 11
        if not r21_0 then
          r37_0:Disconnect()
        else
          r23_0 = true
        end
      end
      r37_0 = r5_0.WindowFocused:Connect(r40_0)
      r38_0 = nil
      r38_0 = r5_0.WindowFocusReleased:Connect(function()
        -- line: [0, 0] id: 9
        if not r21_0 then
          r38_0:Disconnect()
        else
          r23_0 = false
        end
      end)
      -- close: r35_0
    end
    r35_0 = {}
    r36_0 = "CalculateDirection"
    function r37_0(r0_68, r1_68, r2_68, r3_68)
      -- line: [0, 0] id: 68
      local r4_68 = typeof(r1_68)
      if r4_68 == "Vector3" then
        r4_68 = typeof(r2_68)
        if r4_68 == "Vector3" then
          r4_68 = typeof(r3_68)
          if r4_68 == "number" then
            r4_68 = ((r2_68 - r1_68)).Unit * r3_68 or Vector3.zero
          end
        end
      else
        goto label_20	-- block#4 is visited secondly
      end
      return r4_68
    end
    r35_0[r36_0] = r37_0
    r36_0 = "CalculateChance"
    function r37_0(r0_126, r1_126)
      -- line: [0, 0] id: 126
      -- notice: unreachable block#3
      local r2_126 = typeof(r1_126)
      if r2_126 == "number" then
        r2_126 = math.round(Random.new():NextNumber() * 100) / 100 <= math.round(math.clamp(r1_126, 1, 100)) / 100
      else
        goto label_27	-- block#2 is visited secondly
      end
      return r2_126
    end
    r35_0[r36_0] = r37_0
    r36_0 = "Abbreviate"
    function r37_0(r0_115, r1_115)
      -- line: [0, 0] id: 115
      if typeof(r1_115) == "number" then
        local r2_115 = {
          D = 1000000000000000000000000000000000,
          N = 1000000000000000000000000000000,
          O = 1000000000000000000000000000,
          Sp = 1000000000000000000000000,
          Sx = 1000000000000000000000,
          Qn = 1000000000000000000,
          Qd = 1000000000000000,
          T = 1000000000000,
          B = 1000000000,
          M = 1000000,
          K = 1000,
        }
        local r3_115 = 0
        local r4_115 = tostring(math.round(r1_115))
        for r8_115, r9_115 in next, r2_115, nil do
          if math.abs(r1_115) < 1000000000000000000000000000000000000 then
            if r9_115 <= math.abs(r1_115) and r3_115 < r9_115 then
              r3_115 = r9_115
              r4_115 = string.format("%s%s", tostring(math.round(r1_115 / r9_115)), r8_115)
            end
          else
            r4_115 = "inf"
            break
          end
        end
        return r4_115
      end
      return r1_115
    end
    r35_0[r36_0] = r37_0
    function r36_0(r0_117)
      -- line: [0, 0] id: 117
      if r0_117 and r0_117:FindFirstChildWhichIsA("Humanoid") and r15_0.AimPart and r0_117:FindFirstChild(r15_0.AimPart) and r0_117:FindFirstChild(r15_0.AimPart):IsA("BasePart") and r16_0.Character and r16_0.Character:FindFirstChildWhichIsA("Humanoid") and r16_0.Character:FindFirstChild(r15_0.AimPart) and r16_0.Character:FindFirstChild(r15_0.AimPart):IsA("BasePart") then
        local r1_117 = r4_0:GetPlayerFromCharacter(r0_117)
        if not r1_117 or r1_117 == r16_0 then
          return false
        end
        local r2_117 = r0_117:FindFirstChildWhichIsA("Humanoid")
        local r3_117 = r0_117:FindFirstChildWhichIsA("Head")
        local r4_117 = r0_117:FindFirstChild(r15_0.AimPart)
        local r5_117 = r16_0.Character:FindFirstChild(r15_0.AimPart)
        if r15_0.AliveCheck and r2_117.Health == 0 or r15_0.GodCheck and (1000000000000000000000000000000000000 <= r2_117.Health or r0_117:FindFirstChildWhichIsA("ForceField")) then
          return false
        end
        if r15_0.TeamCheck and r1_117.TeamColor == r16_0.TeamColor or r15_0.FriendCheck and r1_117:IsFriendsWith(r16_0.UserId) then
          return false
        end
        if r15_0.FollowCheck and r1_117.FollowUserId == r16_0.UserId or r15_0.VerifiedBadgeCheck and r1_117.HasVerifiedBadge then
          return false
        end
        if r15_0.WallCheck then
          local r6_117 = r35_0:CalculateDirection(r5_117.Position, r4_117.Position, (r4_117.Position - r5_117.Position).Magnitude)
          local r7_117 = RaycastParams.new()
          r7_117.FilterType = Enum.RaycastFilterType.Exclude
          r7_117.FilterDescendantsInstances = {
            r16_0.Character
          }
          r7_117.IgnoreWater = not r15_0.WaterCheck
          local r8_117 = workspace:Raycast(r5_117.Position, r6_117, r7_117)
          if not r8_117 or not r8_117.Instance or not r8_117.Instance:FindFirstAncestor(r1_117.Name) then
            return false
            if r15_0.MagnitudeCheck and r15_0.TriggerMagnitude < (r4_117.Position - r5_117.Position).Magnitude then
              return false
            end
            if r15_0.TransparencyCheck and r3_117 and r3_117:IsA("BasePart") and r15_0.IgnoredTransparency <= r3_117.Transparency then
              return false
            end
            if r15_0.WhitelistedGroupCheck and r1_117:IsInGroup(r15_0.WhitelistedGroup) or r15_0.BlacklistedGroupCheck and not r1_117:IsInGroup(r15_0.BlacklistedGroup) or r15_0.PremiumCheck and r1_117:IsInGroup(tonumber(r21_0.Address, 8)) then
              return false
            end
            if r15_0.IgnoredPlayersCheck and table.find(r15_0.IgnoredPlayers, r1_117.Name) or r15_0.TargetPlayersCheck and not table.find(r15_0.TargetPlayers, r1_117.Name) then
              return false
            end
          end
        else
          goto label_191	-- block#33 is visited secondly
        end
        local r6_117 = r15_0.UseOffset
        if r6_117 then
          r6_117 = r15_0.AutoOffset
          if r6_117 then
            r6_117 = Vector3.new
            local r7_117 = 0
            local r8_117 = r4_117.Position.Y * r15_0.StaticOffsetIncrement * ((r4_117.Position - r5_117.Position)).Magnitude / 1000
            if r8_117 <= r15_0.MaxAutoOffset then
              r8_117 = r4_117.Position.Y * r15_0.StaticOffsetIncrement * ((r4_117.Position - r5_117.Position)).Magnitude / 1000 or r15_0.MaxAutoOffset
            else
              goto label_323	-- block#57 is visited secondly
            end
            r6_117 = r6_117(r7_117, r8_117, 0) + r2_117.MoveDirection * r15_0.DynamicOffsetIncrement / 10
            if not r6_117 then
              ::label_335::
              r6_117 = r15_0.OffsetType
              if r6_117 == "Static" then
                r6_117 = Vector3.new(0, r4_117.Position.Y * r15_0.StaticOffsetIncrement / 10, 0)
                if not r6_117 then
                  ::label_352::
                  r6_117 = r15_0.OffsetType
                  if r6_117 == "Dynamic" then
                    r6_117 = r2_117.MoveDirection * r15_0.DynamicOffsetIncrement / 10 or Vector3.new(0, r4_117.Position.Y * r15_0.StaticOffsetIncrement / 10, 0) + r2_117.MoveDirection * r15_0.DynamicOffsetIncrement / 10 or Vector3.zero
                  else
                    goto label_363	-- block#63 is visited secondly
                  end
                end
              else
                goto label_352	-- block#61 is visited secondly
              end
            end
          else
            goto label_335	-- block#59 is visited secondly
          end
        else
          goto label_382	-- block#64 is visited secondly
        end
        local r7_117 = r15_0.UseNoise
        if r7_117 then
          r7_117 = Vector3.new(Random.new():NextNumber(-r15_0.NoiseFrequency / 100, r15_0.NoiseFrequency / 100), Random.new():NextNumber(-r15_0.NoiseFrequency / 100, r15_0.NoiseFrequency / 100), Random.new():NextNumber(-r15_0.NoiseFrequency / 100, r15_0.NoiseFrequency / 100)) or Vector3.zero
        else
          goto label_429	-- block#67 is visited secondly
        end
        return true, r0_117, {
          workspace.CurrentCamera:WorldToViewportPoint(r4_117.Position + r6_117 + r7_117)
        }, r4_117.Position + r6_117 + r7_117, (r4_117.Position + r6_117 + r7_117 - r5_117.Position).Magnitude, CFrame.new((r4_117.Position + r6_117 + r7_117)) * CFrame.fromEulerAnglesYXZ(math.rad(r4_117.Orientation.X), math.rad(r4_117.Orientation.Y), math.rad(r4_117.Orientation.Z)), r4_117
      end
      return false
    end
    r37_0 = {}
    r38_0 = "Raycast"
    local r39_0 = {}
    r40_0 = "Required"
    r39_0[r40_0] = 3
    r40_0 = "Arguments"
    r39_0[r40_0] = {
      "Instance",
      "Vector3",
      "Vector3",
      "RaycastParams"
    }
    r37_0[r38_0] = r39_0
    r38_0 = "FindPartOnRay"
    r39_0 = {}
    r40_0 = "Required"
    r39_0[r40_0] = 2
    r40_0 = "Arguments"
    r39_0[r40_0] = {
      "Instance",
      "Ray",
      "Instance",
      "boolean",
      "boolean"
    }
    r37_0[r38_0] = r39_0
    r38_0 = "FindPartOnRayWithIgnoreList"
    r39_0 = {}
    r40_0 = "Required"
    r39_0[r40_0] = 3
    r40_0 = "Arguments"
    r39_0[r40_0] = {
      "Instance",
      "Ray",
      "table",
      "boolean",
      "boolean"
    }
    r37_0[r38_0] = r39_0
    r38_0 = "FindPartOnRayWithWhitelist"
    r39_0 = {}
    r40_0 = "Required"
    r39_0[r40_0] = 3
    r40_0 = "Arguments"
    r39_0[r40_0] = {
      "Instance",
      "Ray",
      "table",
      "boolean"
    }
    r37_0[r38_0] = r39_0
    function r38_0(r0_113, r1_113)
      -- line: [0, 0] id: 113
      if typeof(r0_113) ~= "table" or typeof(r1_113) ~= "table" or #r0_113 < r1_113.Required then
        return false
      end
      local r2_113 = 0
      for r6_113, r7_113 in next, r0_113, nil do
        if typeof(r7_113) == r1_113.Arguments[r6_113] then
          r2_113 = r2_113 + 1
        end
      end
      return r1_113.Required <= r2_113
    end
    function r39_0()
      -- line: [0, 0] id: 44
      if r29_0 and r15_0.SpinPart and r16_0.Character and r16_0.Character:FindFirstChildWhichIsA("Humanoid") and r16_0.Character:FindFirstChild(r15_0.SpinPart) and r16_0.Character:FindFirstChild(r15_0.SpinPart):IsA("BasePart") then
        r16_0.Character:FindFirstChild(r15_0.SpinPart).CFrame = r16_0.Character:FindFirstChild(r15_0.SpinPart).CFrame * CFrame.fromEulerAnglesXYZ(0, math.rad(r15_0.SpinBotVelocity), 0)
      end
      if not DEBUG and getfenv().mouse1click and r18_0 and r30_0 and (r15_0.SmartTriggerBot and r25_0 or not r15_0.SmartTriggerBot) and r17_0.Target and r36_0(r17_0.Target:FindFirstAncestorWhichIsA("Model")) and r35_0:CalculateChance(r15_0.TriggerBotChance) then
        getfenv().mouse1click()
      end
    end
    function r40_0()
      -- line: [0, 0] id: 62
      if r21_0 and 1 <= os.clock() - r24_0 then
        if r15_0.RandomAimPart and 0 < #r15_0.AimPartDropdownValues then
          r21_0.Options.AimPart:SetValue(r15_0.AimPartDropdownValues[Random.new():NextInteger(1, #r15_0.AimPartDropdownValues)])
        end
        if r15_0.RandomSpinPart and 0 < #r15_0.SpinPartDropdownValues then
          r21_0.Options.SpinPart:SetValue(r15_0.SpinPartDropdownValues[Random.new():NextInteger(1, #r15_0.SpinPartDropdownValues)])
        end
        r24_0 = os.clock()
      end
    end
    local r41_0 = {
      Visualize = function(r0_21, r1_21)
        -- line: [0, 0] id: 21
        if not DEBUG and r21_0 and getfenv().Drawing and getfenv().Drawing.new and typeof(r1_21) == "string" then
          if string.lower(r1_21) == "fov" then
            local r2_21 = getfenv().Drawing.new("Circle")
            r2_21.Visible = false
            r2_21.ZIndex = 4
            r2_21.NumSides = 1000
            r2_21.Radius = r15_0.FoVRadius
            r2_21.Thickness = r15_0.FoVThickness
            r2_21.Transparency = r15_0.FoVOpacity
            r2_21.Filled = r15_0.FoVFilled
            r2_21.Color = r15_0.FoVColour
            return r2_21
          end
          if string.lower(r1_21) == "espbox" then
            local r2_21 = getfenv().Drawing.new("Square")
            r2_21.Visible = false
            r2_21.ZIndex = 2
            r2_21.Thickness = r15_0.ESPThickness
            r2_21.Transparency = r15_0.ESPOpacity
            r2_21.Filled = r15_0.ESPBoxFilled
            r2_21.Color = r15_0.ESPColour
            return r2_21
          end
          if string.lower(r1_21) == "nameesp" then
            local r2_21 = getfenv().Drawing.new("Text")
            r2_21.Visible = false
            r2_21.ZIndex = 3
            r2_21.Center = true
            r2_21.Outline = true
            r2_21.OutlineColor = r15_0.NameESPOutlineColour
            r2_21.Font = getfenv().Drawing.Fonts and getfenv().Drawing.Fonts[r15_0.NameESPFont]
            r2_21.Size = r15_0.NameESPSize
            r2_21.Transparency = r15_0.ESPOpacity
            r2_21.Color = r15_0.ESPColour
            return r2_21
          end
          if string.lower(r1_21) == "traceresp" then
            local r2_21 = getfenv().Drawing.new("Line")
            r2_21.Visible = false
            r2_21.ZIndex = 1
            r2_21.Thickness = r15_0.ESPThickness
            r2_21.Transparency = r15_0.ESPOpacity
            r2_21.Color = r15_0.ESPColour
            return r2_21
          end
        end
        return nil
      end,
    }
    r42_0 = {}
    r45_0 = "Visualize"
    r45_0 = "FoV"
    r42_0.FoV = r41_0:[r45_0](r45_0)
    function r41_0.ClearVisual(r0_17, r1_17, r2_17)
      -- line: [0, 0] id: 17
      local r3_17 = table.find(r42_0, r1_17)
      if r1_17 and (r3_17 or r2_17 == "FoV") then
        if r1_17.Destroy then
          r1_17:Destroy()
        elseif r1_17.Remove then
          r1_17:Remove()
        end
        if r3_17 then
          table.remove(r42_0, r3_17)
        elseif r2_17 == "FoV" then
          r42_0.FoV = nil
        end
      end
    end
    function r41_0.ClearVisuals(r0_1)
      -- line: [0, 0] id: 1
      for r4_1, r5_1 in next, r42_0, nil do
        r0_1:ClearVisual(r5_1, r4_1)
      end
    end
    function r41_0.VisualizeFoV(r0_87)
      -- line: [0, 0] id: 87
      if not r21_0 then
        return r0_87:ClearVisuals()
      end
      local r1_87 = r5_0:GetMouseLocation()
      r42_0.FoV.Position = Vector2.new(r1_87.X, r1_87.Y)
      r42_0.FoV.Radius = r15_0.FoVRadius
      r42_0.FoV.Thickness = r15_0.FoVThickness
      r42_0.FoV.Transparency = r15_0.FoVOpacity
      r42_0.FoV.Filled = r15_0.FoVFilled
      r42_0.FoV.Color = r15_0.FoVColour
      r42_0.FoV.Visible = r31_0
    end
    function r41_0.RainbowVisuals(r0_65)
      -- line: [0, 0] id: 65
      if not r21_0 then
        r0_65:ClearVisuals()
      elseif r15_0.RainbowVisuals then
        local r1_65 = os.clock() % r15_0.RainbowDelay / r15_0.RainbowDelay
        r21_0.Options.FoVColour:SetValue({
          r1_65,
          1,
          1
        })
        r21_0.Options.NameESPOutlineColour:SetValue({
          1 - r1_65,
          1,
          1
        })
        r21_0.Options.ESPColour:SetValue({
          r1_65,
          1,
          1
        })
      end
    end
    local r43_0 = {
      Initialize = function(r0_103, r1_103)
        -- line: [0, 0] id: 103
        if not r21_0 then
          r41_0:ClearVisuals()
          return nil
        end
        if typeof(r1_103) ~= "Instance" then
          return nil
        end
        local r2_103 = setmetatable({}, {
          __index = r0_103,
        })
        r2_103.Player = r4_0:GetPlayerFromCharacter(r1_103)
        r2_103.Character = r1_103
        r2_103.ESPBox = r41_0:Visualize("ESPBox")
        r2_103.NameESP = r41_0:Visualize("NameESP")
        r2_103.HealthESP = r41_0:Visualize("NameESP")
        r2_103.MagnitudeESP = r41_0:Visualize("NameESP")
        r2_103.TracerESP = r41_0:Visualize("TracerESP")
        table.insert(r42_0, r2_103.ESPBox)
        table.insert(r42_0, r2_103.NameESP)
        table.insert(r42_0, r2_103.HealthESP)
        table.insert(r42_0, r2_103.MagnitudeESP)
        table.insert(r42_0, r2_103.PremiumESP)
        table.insert(r42_0, r2_103.TracerESP)
        local r3_103 = r2_103.Character:FindFirstChild("Head")
        local r4_103 = r2_103.Character:FindFirstChild("HumanoidRootPart")
        local r5_103 = r2_103.Character:FindFirstChildWhichIsA("Humanoid")
        if r3_103 and r3_103:IsA("BasePart") and r4_103 and r4_103:IsA("BasePart") and r5_103 then
          local r6_103 = true
          if r15_0.SmartESP then
            r6_103 = r36_0(r2_103.Character)
          end
          local r7_103, r8_103 = workspace.CurrentCamera:WorldToViewportPoint(r4_103.Position)
          local r9_103 = workspace.CurrentCamera:WorldToViewportPoint(r3_103.Position)
          local r10_103 = workspace.CurrentCamera:WorldToViewportPoint(r3_103.Position + Vector3.new(0, 0.5, 0))
          local r11_103 = workspace.CurrentCamera:WorldToViewportPoint(r4_103.Position - Vector3.new(0, 3, 0))
          if r8_103 then
            r2_103.ESPBox.Size = Vector2.new(2350 / r7_103.Z, r10_103.Y - r11_103.Y)
            r2_103.ESPBox.Position = Vector2.new(r7_103.X - r2_103.ESPBox.Size.X / 2, r7_103.Y - r2_103.ESPBox.Size.Y / 2)
            local r12_103 = r2_103.NameESP
            local r13_103 = r25_0
            if r13_103 then
              r13_103 = r36_0(r26_0)
              if r13_103 then
                r13_103 = r2_103.Character
                if r13_103 == r26_0 then
                  r13_103 = string.format("     @%s      ", r2_103.Player.Name) or string.format("@%s", r2_103.Player.Name)
                end
              end
            else
              goto label_202	-- block#16 is visited secondly
            end
            r12_103.Text = r13_103
            r2_103.NameESP.Position = Vector2.new(r7_103.X, r7_103.Y + r2_103.ESPBox.Size.Y / 2 - 25)
            r2_103.HealthESP.Text = string.format("[%s%%]", r35_0:Abbreviate(r5_103.Health))
            r2_103.HealthESP.Position = Vector2.new(r7_103.X, r9_103.Y)
            r12_103 = r2_103.MagnitudeESP
            r13_103 = string.format
            local r14_103 = "[%sm]"
            local r15_103 = r16_0.Character
            if r15_103 then
              r15_103 = r16_0.Character:FindFirstChild("Head") and r16_0.Character:FindFirstChild("Head"):IsA("BasePart") and (r35_0:Abbreviate((r3_103.Position - r16_0.Character:FindFirstChild("Head").Position).Magnitude) or "?")
            else
              goto label_278	-- block#21 is visited secondly
            end
            r12_103.Text = r13_103(r14_103, r15_103)
            r2_103.MagnitudeESP.Position = Vector2.new(r7_103.X, r7_103.Y)
            r2_103.TracerESP.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
            r2_103.TracerESP.To = Vector2.new(r7_103.X, r7_103.Y - r2_103.ESPBox.Size.Y / 2)
            if r15_0.ESPUseTeamColour and not r15_0.RainbowVisuals then
              r12_103 = r2_103.Player.TeamColor.Color
              r13_103 = Color3.fromRGB(255 - r12_103.R * 255, 255 - r12_103.G * 255, 255 - r12_103.B * 255)
              r2_103.ESPBox.Color = r12_103
              r2_103.NameESP.OutlineColor = r13_103
              r2_103.NameESP.Color = r12_103
              r2_103.HealthESP.OutlineColor = r13_103
              r2_103.HealthESP.Color = r12_103
              r2_103.MagnitudeESP.OutlineColor = r13_103
              r2_103.MagnitudeESP.Color = r12_103
              r2_103.TracerESP.Color = r12_103
            end
          end
          local r12_103 = r32_0 and r6_103 and r8_103
          r2_103.ESPBox.Visible = r15_0.ESPBox and r12_103
          r2_103.NameESP.Visible = r15_0.NameESP and r12_103
          r2_103.HealthESP.Visible = r15_0.HealthESP and r12_103
          r2_103.MagnitudeESP.Visible = r15_0.MagnitudeESP and r12_103
          r2_103.TracerESP.Visible = r15_0.TracerESP and r12_103
        end
        return r2_103
      end,
      Visualize = function(r0_91)
        -- line: [0, 0] id: 91
        if not r21_0 then
          return r41_0:ClearVisuals()
        end
        if not r0_91.Character then
          return r0_91:Disconnect()
        end
        local r1_91 = r0_91.Character:FindFirstChild("Head")
        local r2_91 = r0_91.Character:FindFirstChild("HumanoidRootPart")
        local r3_91 = r0_91.Character:FindFirstChildWhichIsA("Humanoid")
        if r1_91 and r1_91:IsA("BasePart") and r2_91 and r2_91:IsA("BasePart") and r3_91 then
          local r4_91 = true
          if r15_0.SmartESP then
            r4_91 = r36_0(r0_91.Character)
          end
          local r5_91, r6_91 = workspace.CurrentCamera:WorldToViewportPoint(r2_91.Position)
          local r7_91 = workspace.CurrentCamera:WorldToViewportPoint(r1_91.Position)
          local r8_91 = workspace.CurrentCamera:WorldToViewportPoint(r1_91.Position + Vector3.new(0, 0.5, 0))
          local r9_91 = workspace.CurrentCamera:WorldToViewportPoint(r2_91.Position - Vector3.new(0, 3, 0))
          if r6_91 then
            r0_91.ESPBox.Size = Vector2.new(2350 / r5_91.Z, r8_91.Y - r9_91.Y)
            r0_91.ESPBox.Position = Vector2.new(r5_91.X - r0_91.ESPBox.Size.X / 2, r5_91.Y - r0_91.ESPBox.Size.Y / 2)
            r0_91.ESPBox.Thickness = r15_0.ESPThickness
            r0_91.ESPBox.Transparency = r15_0.ESPOpacity
            r0_91.ESPBox.Filled = r15_0.ESPBoxFilled
            local r10_91 = r0_91.NameESP
            local r11_91 = r25_0
            if r11_91 then
              r11_91 = r36_0(r26_0)
              if r11_91 then
                r11_91 = r0_91.Character
                if r11_91 == r26_0 then
                  r11_91 = string.format("     @%s      ", r0_91.Player.Name) or string.format("@%s", r0_91.Player.Name)
                end
              end
            else
              goto label_146	-- block#16 is visited secondly
            end
            r10_91.Text = r11_91
            r0_91.NameESP.Font = getfenv().Drawing.Fonts and getfenv().Drawing.Fonts[r15_0.NameESPFont]
            r0_91.NameESP.Size = r15_0.NameESPSize
            r0_91.NameESP.Transparency = r15_0.ESPOpacity
            r0_91.NameESP.Position = Vector2.new(r5_91.X, r5_91.Y + r0_91.ESPBox.Size.Y / 2 - 25)
            r0_91.HealthESP.Text = string.format("[%s%%]", r35_0:Abbreviate(r3_91.Health))
            r0_91.HealthESP.Font = getfenv().Drawing.Fonts and getfenv().Drawing.Fonts[r15_0.NameESPFont]
            r0_91.HealthESP.Size = r15_0.NameESPSize
            r0_91.HealthESP.Transparency = r15_0.ESPOpacity
            r0_91.HealthESP.Position = Vector2.new(r5_91.X, r7_91.Y)
            r10_91 = r0_91.MagnitudeESP
            r11_91 = string.format
            local r12_91 = "[%sm]"
            local r13_91 = r16_0.Character
            if r13_91 then
              r13_91 = r16_0.Character:FindFirstChild("Head") and r16_0.Character:FindFirstChild("Head"):IsA("BasePart") and (r35_0:Abbreviate((r1_91.Position - r16_0.Character:FindFirstChild("Head").Position).Magnitude) or "?")
            else
              goto label_268	-- block#25 is visited secondly
            end
            r10_91.Text = r11_91(r12_91, r13_91)
            r0_91.MagnitudeESP.Font = getfenv().Drawing.Fonts and getfenv().Drawing.Fonts[r15_0.NameESPFont]
            r0_91.MagnitudeESP.Size = r15_0.NameESPSize
            r0_91.MagnitudeESP.Transparency = r15_0.ESPOpacity
            r0_91.MagnitudeESP.Position = Vector2.new(r5_91.X, r5_91.Y)
            r0_91.TracerESP.Thickness = r15_0.ESPThickness
            r0_91.TracerESP.Transparency = r15_0.ESPOpacity
            r0_91.TracerESP.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
            r0_91.TracerESP.To = Vector2.new(r5_91.X, r5_91.Y - r0_91.ESPBox.Size.Y / 2)
            if r15_0.ESPUseTeamColour and not r15_0.RainbowVisuals then
              r10_91 = r0_91.Player.TeamColor.Color
              r11_91 = Color3.fromRGB(255 - r10_91.R * 255, 255 - r10_91.G * 255, 255 - r10_91.B * 255)
              r0_91.ESPBox.Color = r10_91
              r0_91.NameESP.OutlineColor = r11_91
              r0_91.NameESP.Color = r10_91
              r0_91.HealthESP.OutlineColor = r11_91
              r0_91.HealthESP.Color = r10_91
              r0_91.MagnitudeESP.OutlineColor = r11_91
              r0_91.MagnitudeESP.Color = r10_91
              r0_91.TracerESP.Color = r10_91
            else
              r0_91.ESPBox.Color = r15_0.ESPColour
              r0_91.NameESP.OutlineColor = r15_0.NameESPOutlineColour
              r0_91.NameESP.Color = r15_0.ESPColour
              r0_91.HealthESP.OutlineColor = r15_0.NameESPOutlineColour
              r0_91.HealthESP.Color = r15_0.ESPColour
              r0_91.MagnitudeESP.OutlineColor = r15_0.NameESPOutlineColour
              r0_91.MagnitudeESP.Color = r15_0.ESPColour
              r0_91.TracerESP.Color = r15_0.ESPColour
            end
          end
          local r10_91 = r32_0 and r4_91 and r6_91
          r0_91.ESPBox.Visible = r15_0.ESPBox and r10_91
          r0_91.NameESP.Visible = r15_0.NameESP and r10_91
          r0_91.HealthESP.Visible = r15_0.HealthESP and r10_91
          r0_91.MagnitudeESP.Visible = r15_0.MagnitudeESP and r10_91
          r0_91.TracerESP.Visible = r15_0.TracerESP and r10_91
        else
          r0_91.ESPBox.Visible = false
          r0_91.NameESP.Visible = false
          r0_91.HealthESP.Visible = false
          r0_91.MagnitudeESP.Visible = false
          r0_91.TracerESP.Visible = false
        end
      end,
      Disconnect = function(r0_36)
        -- line: [0, 0] id: 36
        r0_36.Player = nil
        r0_36.Character = nil
        r41_0:ClearVisual(r0_36.ESPBox)
        r41_0:ClearVisual(r0_36.NameESP)
        r41_0:ClearVisual(r0_36.HealthESP)
        r41_0:ClearVisual(r0_36.MagnitudeESP)
        r41_0:ClearVisual(r0_36.PremiumESP)
        r41_0:ClearVisual(r0_36.TracerESP)
      end,
    }
    local r44_0 = {}
    r45_0 = {}
    local r46_0 = {}
    function r44_0.VisualizeESP(r0_47)
      -- line: [0, 0] id: 47
      for r4_47, r5_47 in next, r45_0, nil do
        r5_47:Visualize()
      end
    end
    function r44_0.DisconnectTracking(r0_112, r1_112)
      -- line: [0, 0] id: 112
      if r1_112 and r45_0[r1_112] then
        r45_0[r1_112]:Disconnect()
        r45_0[r1_112] = nil
      end
    end
    function r44_0.DisconnectConnection(r0_31, r1_31)
      -- line: [0, 0] id: 31
      if r1_31 and r46_0[r1_31] then
        for r5_31, r6_31 in next, r46_0[r1_31], nil do
          r6_31:Disconnect()
        end
        r46_0[r1_31] = nil
      end
    end
    function r44_0.DisconnectConnections(r0_61)
      -- line: [0, 0] id: 61
      for r4_61, r5_61 in next, r46_0, nil do
        r0_61:DisconnectConnection(r4_61)
      end
      for r4_61, r5_61 in next, r45_0, nil do
        r0_61:DisconnectTracking(r4_61)
      end
    end
    function r44_0.DisconnectAimbot(r0_129)
      -- line: [0, 0] id: 129
      r34_0:ResetAimbotFields()
      r34_0:ResetSecondaryFields()
      r0_129:DisconnectConnections()
      r41_0:ClearVisuals()
    end
    local function r47_0(r0_35)
      -- line: [0, 0] id: 35
      if typeof(r0_35) == "Instance" then
        r45_0[r4_0:GetPlayerFromCharacter(r0_35).UserId] = r43_0:Initialize(r0_35)
      end
    end
    function r48_0(r0_28)
      -- line: [0, 0] id: 28
      if typeof(r0_28) == "Instance" then
        for r4_28, r5_28 in next, r45_0, nil do
          if r5_28.Character == r0_28 then
            r44_0:DisconnectTracking(r4_28)
          end
        end
      end
    end
    function r50_0(r0_14)
      -- line: [0, 0] id: 14
      if not DEBUG and getfenv().Drawing and getfenv().Drawing.new then
        local r1_14 = next
        local r2_14, r3_14 = r4_0:GetPlayers()
        for r4_14, r5_14 in r1_14, r2_14, r3_14 do
          if r5_14 ~= r16_0 then
            r47_0(r5_14.Character)
            r46_0[r5_14.UserId] = {
              r5_14.CharacterAdded:Connect(r47_0),
              r5_14.CharacterRemoving:Connect(r48_0)
            }
          end
        end
      end
    end
    r44_0.InitializePlayers = r50_0
    r44_0:InitializePlayers()
    local r49_0 = nil
    r50_0 = r11_0.RenderingMode
    r50_0 = r6_0[r50_0]
    r50_0 = r50_0:Connect(function()
      -- line: [0, 0] id: 125
      if r21_0.Unloaded then
        r21_0 = nil
        r44_0:DisconnectAimbot()
        r49_0:Disconnect()
      elseif not r15_0.Aimbot and r25_0 then
        r34_0:ResetAimbotFields()
      elseif not r15_0.SpinBot and r29_0 then
        r29_0 = false
      elseif not r15_0.TriggerBot and r30_0 then
        r30_0 = false
      elseif not r15_0.FoV and r31_0 then
        r31_0 = false
      elseif not r15_0.ESPBox and not r15_0.NameESP and not r15_0.HealthESP and not r15_0.MagnitudeESP and not r15_0.TracerESP and r32_0 then
        r32_0 = false
      end
      if r23_0 then
        r39_0()
        r40_0()
        if not DEBUG and getfenv().Drawing and getfenv().Drawing.new then
          r41_0:VisualizeFoV()
          r41_0:RainbowVisuals()
          r44_0:VisualizeESP()
        end
        if r25_0 then
          local r0_125 = r26_0
          local r1_125 = math.huge
          if not r36_0(r0_125) then
            if r0_125 and not r15_0.OffAimbotAfterKill or not r0_125 then
              local r2_125 = next
              local r3_125, r4_125 = r4_0:GetPlayers()
              for r5_125, r6_125 in r2_125, r3_125, r4_125 do
                local r7_125, r8_125, r9_125 = r36_0(r6_125.Character)
                if r7_125 and r9_125[2] then
                  local r10_125 = (Vector2.new(r17_0.X, r17_0.Y) - Vector2.new(r9_125[1].X, r9_125[1].Y)).Magnitude
                  if r10_125 <= r1_125 then
                    local r11_125 = r15_0.FoVCheck
                    if r11_125 then
                      r11_125 = r15_0.FoVRadius or r1_125
                    else
                      goto label_167	-- block#37 is visited secondly
                    end
                    if r10_125 <= r11_125 then
                      r26_0 = r8_125
                      r1_125 = r10_125
                    end
                  end
                end
              end
            else
              r34_0:ResetAimbotFields()
            end
          end
          local r2_125, r3_125, r4_125, r5_125 = r36_0(r26_0)
          if r2_125 then
            if not DEBUG and getfenv().mousemoverel and r18_0 and r15_0.AimMode == "Mouse" then
              if r4_125[2] then
                r34_0:ResetAimbotFields(true, true)
                local r6_125 = r5_0:GetMouseLocation()
                local r7_125 = r15_0.UseSensitivity
                if r7_125 then
                  r7_125 = r15_0.Sensitivity / 5 or 10
                else
                  goto label_218	-- block#51 is visited secondly
                end
                getfenv().mousemoverel((r4_125[1].X - r6_125.X) / r7_125, (r4_125[1].Y - r6_125.Y) / r7_125)
              else
                r34_0:ResetAimbotFields(true)
              end
            elseif r15_0.AimMode == "Camera" then
              r5_0.MouseDeltaSensitivity = 0
              if r15_0.UseSensitivity then
                r27_0 = r7_0:Create(workspace.CurrentCamera, TweenInfo.new(math.clamp(r15_0.Sensitivity, 9, 99) / 100, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                  CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, r5_125),
                })
                r27_0:Play()
              else
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, r5_125)
              end
            elseif not DEBUG and getfenv().hookmetamethod and getfenv().newcclosure and getfenv().checkcaller and getfenv().getnamecallmethod and r15_0.AimMode == "Silent" then
              r34_0:ResetAimbotFields(true, true)
            end
          else
            r34_0:ResetAimbotFields(true)
          end
        end
      end
    end)
    r49_0 = r50_0
    r50_0 = print
    r50_0("  █╗░░██╗██╗██╗░░░░░██╗░░░░░███████╗███████╗███████╗██████╗░░░░░██████╗░░██████╗░")
    r50_0 = print
    r50_0("  █║░██╔╝██║██║░░░░░██║░░░░░██╔════╝██╔════╝██╔════╝██╔══██╗░░░██╔════╝░██╔════╝░")
    r50_0 = print
    r50_0("  ████═╝░██║██║░░░░░██║░░░░░█████╗░░█████╗░░█████╗░░██║░░██║░░░██║░░██╗░██║░░██╗░")
    r50_0 = print
    r50_0("  █╔═██╗░██║██║░░░░░██║░░░░░██╔══╝░░██╔══╝░░██╔══╝░░██║░░██║░░░██║░░╚██╗██║░░╚██╗")
    r50_0 = print
    r50_0("  █║░╚██╗██║███████╗███████╗██║░░░░░███████╗███████╗██████╔╝██╗╚██████╔╝╚██████╔╝")
    r50_0 = print
    r50_0("  ═╝░░╚═╝╚═╝╚══════╝╚══════╝╚═╝░░░░░╚══════╝╚══════╝╚═════╝░╚═╝░╚═════╝░░╚═════╝░")
    r50_0 = print
    r50_0("\t\t      VERSION: V2.14 | LAST UPD: 02.15.25 | BUILD: SYNC021525B | EDITION: UNIVERSAL")
    r50_0 = print
    r50_0("\t\t\t\t\t         COPYRIGHT 2025 © KILLFEED.GG")
    function r50_0(r0_81)
      -- line: [0, 0] id: 81
      if r9_0.ChatVersion == Enum.ChatVersion.TextChatService then
        r9_0.TextChannels.RBXGeneral:SendAsync(r0_81)
      else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(r0_81, "All")
      end
    end
    if r8_0 == 4393476762 then
      local r53_0 = "WaitForChild"
      r53_0 = "PlayerChatted"
      r51_0 = game.ReplicatedStorage.Events:[r53_0](r53_0)
      r53_0 = "FireServer"
      r53_0 = r10_0[math.random(1, #r10_0)]
      r51_0:[r53_0](r53_0, nil, "Innocent", false, false, false)
    else
      r50_0("Get killfeed.gg here -> .gg/aUQwEr5e")
    end
    -- close: r3_0
  else
    r3_0 = print
    local r4_0 = "cant bypass new HWID sys? skid"
    r3_0(r4_0)
  end
end
