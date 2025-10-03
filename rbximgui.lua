-- WeedHax GUI Library
-- A Roblox Luau library for creating exploit-style GUIs with tabs, sections, toggles, sliders, dropdowns, keybinds, and color pickers.
-- Created on October 03, 2025.

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WeedHax"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "WeedHax"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local BuildLabel = Instance.new("TextLabel")
BuildLabel.Name = "Build"
BuildLabel.Parent = TopBar
BuildLabel.BackgroundTransparency = 1
BuildLabel.Position = UDim2.new(1, -100, 0, 0)
BuildLabel.Size = UDim2.new(0, 90, 1, 0)
BuildLabel.Font = Enum.Font.Gotham
BuildLabel.Text = "Build: Aug. 17, 2025"
BuildLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
BuildLabel.TextSize = 12
BuildLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Minimize Button (simple toggle for now)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "Minimize"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
MinimizeButton.Size = UDim2.new(0, 20, 1, 0)
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.TextXAlignment = Enum.TextXAlignment.Center

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.ClipsDescendants = true

-- Tab Buttons Frame
local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = ContentFrame
TabButtons.BackgroundTransparency = 1
TabButtons.Position = UDim2.new(0, 0, 0, 0)
TabButtons.Size = UDim2.new(0, 120, 1, 0)

-- Tab Content
local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Parent = ContentFrame
TabContent.BackgroundTransparency = 1
TabContent.Position = UDim2.new(0, 120, 0, 0)
TabContent.Size = UDim2.new(1, -120, 1, 0)

-- Keybinds Panel (overlay)
local KeybindsPanel = Instance.new("Frame")
KeybindsPanel.Name = "Keybinds"
KeybindsPanel.Parent = ScreenGui
KeybindsPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeybindsPanel.BorderSizePixel = 0
KeybindsPanel.Position = UDim2.new(1, -200, 0, 50)
KeybindsPanel.Size = UDim2.new(0, 180, 0, 200)
KeybindsPanel.Visible = false

local KeybindsTitle = Instance.new("TextLabel")
KeybindsTitle.Name = "Title"
KeybindsTitle.Parent = KeybindsPanel
KeybindsTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeybindsTitle.BorderSizePixel = 0
KeybindsTitle.Size = UDim2.new(1, 0, 0, 25)
KeybindsTitle.Font = Enum.Font.GothamBold
KeybindsTitle.Text = "Keybinds"
KeybindsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindsTitle.TextSize = 14

-- Chat/Console Frame (bottom)
local ChatFrame = Instance.new("ScrollingFrame")
ChatFrame.Name = "Chat"
ChatFrame.Parent = ScreenGui
ChatFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ChatFrame.BorderSizePixel = 0
ChatFrame.Position = UDim2.new(0, 10, 1, -200)
ChatFrame.Size = UDim2.new(0, 400, 0, 180)
ChatFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatFrame.ScrollBarThickness = 6
ChatFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.Parent = ChatFrame
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLayout.Padding = UDim.new(0, 2)

-- Local variables
local CurrentTab = nil
local Tabs = {}
local Sections = {}
local Elements = {}

-- Utility Functions
local function Tween(obj, props, duration, easing)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.3, easing or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function CreateSection(parent, name)
    local Section = Instance.new("Frame")
    Section.Name = name .. "Section"
    Section.Parent = parent
    Section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Section.BorderSizePixel = 0
    Section.Size = UDim2.new(1, -10, 0, 0)
    Section.Position = UDim2.new(0, 5, 0, #parent:GetChildren() * 30)

    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "Title"
    SectionTitle.Parent = Section
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Size = UDim2.new(1, 0, 0, 25)
    SectionTitle.Font = Enum.Font.GothamSemibold
    SectionTitle.Text = name
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextSize = 12
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Position = UDim2.new(0, 5, 0, 0)

    local SectionContent = Instance.new("Frame")
    SectionContent.Name = "Content"
    SectionContent.Parent = Section
    SectionContent.BackgroundTransparency = 1
    SectionContent.Position = UDim2.new(0, 0, 0, 25)
    SectionContent.Size = UDim2.new(1, 0, 1, -25)

    local SectionList = Instance.new("UIListLayout")
    SectionList.Parent = SectionContent
    SectionList.SortOrder = Enum.SortOrder.LayoutOrder
    SectionList.Padding = UDim.new(0, 5)

    SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.Size = UDim2.new(1, -10, 0, SectionList.AbsoluteContentSize.Y + 30)
    end)

    return SectionContent
end

-- Tab Creation
function Library:CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabButtons
    TabButton.BackgroundTransparency = 1
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabButton.TextSize = 12
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Position = UDim2.new(0, 0, 0, (#Tabs * 30))

    local Tab = Instance.new("Frame")
    Tab.Name = name .. "Tab"
    Tab.Parent = TabContent
    Tab.BackgroundTransparency = 1
    Tab.Size = UDim2.new(1, 0, 1, 0)
    Tab.Visible = false

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = Tab
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Position = UDim2.new(0, 5, 0, 5)

    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        -- Auto-size if needed
    end)

    table.insert(Tabs, {Button = TabButton, Frame = Tab, Content = TabList})

    if #Tabs == 1 then
        CurrentTab = Tab
        Tab.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Visible = false
            Tabs[#Tabs].Button.TextColor3 = Color3.fromRGB(150, 150, 150)  -- Wait, fix to current
            local currentIndex = 0
            for i, t in ipairs(Tabs) do
                if t.Frame == CurrentTab then currentIndex = i break end
            end
            Tabs[currentIndex].Button.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        CurrentTab = Tab
        Tab.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    return TabList
end

-- Toggle Creation
function Library:CreateToggle(parent, options)
    options = options or {}
    local name = options.Name or "Toggle"
    local default = options.Default or false
    local callback = options.Callback or function() end

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, -10, 0, 20)

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 5, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 12
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Button"
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -25, 0, 2.5)
    ToggleButton.Size = UDim2.new(0, 15, 0, 15)
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.Text = ""
    ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)

    local state = default
    callback(state)

    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        Tween(ToggleButton, {BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)}, 0.2)
        callback(state)
    end)

    return {
        Set = function(self, newState)
            state = newState
            Tween(ToggleButton, {BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)}, 0.2)
            callback(state)
        end
    }
end

-- Slider Creation
function Library:CreateSlider(parent, options)
    options = options or {}
    local name = options.Name or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local callback = options.Callback or function() end

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, -10, 0, 30)

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 5, 0, 0)
    SliderLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = name .. ": " .. default
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 12
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "Bar"
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0.5, 5, 0.25, 0)
    SliderBar.Size = UDim2.new(0.45, 0, 0, 5)

    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.ZIndex = 2

    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "Button"
    SliderButton.Parent = SliderFill
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Position = UDim2.new(1, -5, -2.5, 0)
    SliderButton.Size = UDim2.new(0, 10, 0, 10)
    SliderButton.Font = Enum.Font.Gotham
    SliderButton.Text = ""
    SliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    SliderButton.ZIndex = 3

    local dragging = false
    local value = default
    callback(value)

    local function UpdateSlider(input)
        local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * percent)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderButton.Position = UDim2.new(percent, -5, -2.5, 0)
        SliderLabel.Text = name .. ": " .. value
        callback(value)
    end

    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
        UpdateSlider(UserInputService:GetMouseLocation())
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(UserInputService:GetMouseLocation())
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return {
        Set = function(self, newValue)
            value = math.clamp(newValue, min, max)
            local percent = (value - min) / (max - min)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -5, -2.5, 0)
            SliderLabel.Text = name .. ": " .. value
            callback(value)
        end
    }
end

-- Dropdown Creation
function Library:CreateDropdown(parent, options)
    options = options or {}
    local name = options.Name or "Dropdown"
    local optionsList = options.Options or {}
    local default = options.Default or optionsList[1]
    local callback = options.Callback or function() end

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name .. "Dropdown"
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Size = UDim2.new(1, -10, 0, 25)

    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Name = "Label"
    DropdownLabel.Parent = DropdownFrame
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Position = UDim2.new(0, 5, 0, 0)
    DropdownLabel.Size = UDim2.new(1, -30, 1, 0)
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.Text = name .. ": " .. default
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 12
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "Button"
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Position = UDim2.new(1, -25, 0, 0)
    DropdownButton.Size = UDim2.new(0, 20, 1, 0)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Text = "▼"
    DropdownButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    DropdownButton.TextSize = 12

    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "List"
    DropdownList.Parent = DropdownFrame
    DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownList.BorderSizePixel = 0
    DropdownList.Position = UDim2.new(0, 0, 1, 0)
    DropdownList.Size = UDim2.new(1, 0, 0, #optionsList * 20)
    DropdownList.Visible = false
    DropdownList.ZIndex = 10

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropdownList
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 0)

    for i, opt in ipairs(optionsList) do
        local OptButton = Instance.new("TextButton")
        OptButton.Name = opt
        OptButton.Parent = DropdownList
        OptButton.BackgroundTransparency = 1
        OptButton.Size = UDim2.new(1, 0, 0, 20)
        OptButton.Font = Enum.Font.Gotham
        OptButton.Text = opt
        OptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptButton.TextSize = 11
        OptButton.TextXAlignment = Enum.TextXAlignment.Left

        OptButton.MouseButton1Click:Connect(function()
            default = opt
            DropdownLabel.Text = name .. ": " .. default
            callback(default)
            DropdownList.Visible = false
        end)

        OptButton.MouseEnter:Connect(function()
            OptButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)

        OptButton.MouseLeave:Connect(function()
            OptButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)

    return {
        Set = function(self, newValue)
            for _, opt in ipairs(optionsList) do
                if opt == newValue then
                    default = newValue
                    DropdownLabel.Text = name .. ": " .. default
                    callback(default)
                    break
                end
            end
        end
    }
end

-- Keybind Creation
local KeybindStates = {}

function Library:CreateKeybind(parent, options)
    options = options or {}
    local name = options.Name or "Keybind"
    local default = options.Default or Enum.KeyCode.F
    local callback = options.Callback or function() end

    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = name .. "Keybind"
    KeybindFrame.Parent = parent
    KeybindFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeybindFrame.BorderSizePixel = 0
    KeybindFrame.Size = UDim2.new(1, -10, 0, 20)

    local KeybindLabel = Instance.new("TextLabel")
    KeybindLabel.Name = "Label"
    KeybindLabel.Parent = KeybindFrame
    KeybindLabel.BackgroundTransparency = 1
    KeybindLabel.Position = UDim2.new(0, 5, 0, 0)
    KeybindLabel.Size = UDim2.new(1, -50, 1, 0)
    KeybindLabel.Font = Enum.Font.Gotham
    KeybindLabel.Text = name .. ": "
    KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeybindLabel.TextSize = 12
    KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Name = "Button"
    KeybindButton.Parent = KeybindFrame
    KeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Position = UDim2.new(1, -40, 0, 0)
    KeybindButton.Size = UDim2.new(0, 30, 1, 0)
    KeybindButton.Font = Enum.Font.GothamBold
    KeybindButton.Text = default.Name
    KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeybindButton.TextSize = 10
    KeybindButton.TextXAlignment = Enum.TextXAlignment.Center

    local listening = false
    KeybindStates[name] = default

    KeybindButton.MouseButton1Click:Connect(function()
        listening = true
        KeybindButton.Text = "..."
        KeybindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
            local newKey = input.KeyCode
            KeybindStates[name] = newKey
            KeybindButton.Text = newKey.Name
            KeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            listening = false
            callback(newKey)
        end
    end)

    -- Add to keybinds panel
    local KbEntry = Instance.new("TextLabel")
    KbEntry.Name = name
    KbEntry.Parent = KeybindsPanel
    KbEntry.BackgroundTransparency = 1
    KbEntry.Position = UDim2.new(0, 5, 0, 25 + (#KeybindsPanel:GetChildren() - 1) * 20)
    KbEntry.Size = UDim2.new(1, -10, 0, 20)
    KbEntry.Font = Enum.Font.Gotham
    KbEntry.Text = name .. ": " .. default.Name
    KbEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
    KbEntry.TextSize = 11
    KbEntry.TextXAlignment = Enum.TextXAlignment.Left

    -- Update panel when changed
    KeybindButton:GetPropertyChangedSignal("Text"):Connect(function()
        KbEntry.Text = name .. ": " .. KeybindButton.Text
    end)

    return {
        Set = function(self, newKey)
            KeybindStates[name] = newKey
            KeybindButton.Text = newKey.Name
            callback(newKey)
            KbEntry.Text = name .. ": " .. newKey.Name
        end
    }
end

-- Color Picker (Simple, using a basic frame for now; full picker would be more complex)
function Library:CreateColorPicker(parent, options)
    options = options or {}
    local name = options.Name or "ColorPicker"
    local default = options.Default or Color3.fromRGB(255, 255, 255)
    local callback = options.Callback or function() end

    local ColorFrame = Instance.new("Frame")
    ColorFrame.Name = name .. "ColorPicker"
    ColorFrame.Parent = parent
    ColorFrame.BackgroundColor3 = default
    ColorFrame.BorderSizePixel = 0
    ColorFrame.Size = UDim2.new(1, -10, 0, 20)

    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Name = "Label"
    ColorLabel.Parent = ColorFrame
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Position = UDim2.new(0, 25, 0, 0)
    ColorLabel.Size = UDim2.new(1, -30, 1, 0)
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.Text = name
    ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorLabel.TextSize = 12
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Simple button to open picker (placeholder; full implementation would need HSV picker)
    local ColorButton = Instance.new("TextButton")
    ColorButton.Name = "Button"
    ColorButton.Parent = ColorFrame
    ColorButton.BackgroundTransparency = 1
    ColorButton.Position = UDim2.new(0, 0, 0, 0)
    ColorButton.Size = UDim2.new(0, 20, 1, 0)
    ColorButton.Font = Enum.Font.Gotham
    ColorButton.Text = "🎨"
    ColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorButton.TextSize = 12

    ColorButton.MouseButton1Click:Connect(function()
        -- For simplicity, cycle through colors; in full lib, open a picker GUI
        local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0)}
        default = colors[math.random(1, #colors)]
        ColorFrame.BackgroundColor3 = default
        callback(default)
    end)

    return {
        Set = function(self, newColor)
            default = newColor
            ColorFrame.BackgroundColor3 = default
            callback(default)
        end
    }
end

-- Chat/Console Functions
function Library:AddMessage(text, isDamage)
    local MessageFrame = Instance.new("Frame")
    MessageFrame.Name = "Message"
    MessageFrame.Parent = ChatFrame
    MessageFrame.BackgroundTransparency = 1
    MessageFrame.Size = UDim2.new(1, -10, 0, 20)

    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Text"
    MessageLabel.Parent = MessageFrame
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Size = UDim2.new(1, 0, 1, 0)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = text
    MessageLabel.TextColor3 = isDamage and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
    MessageLabel.TextSize = 11
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextWrapped = true

    ChatFrame.CanvasSize = UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y)
    ChatFrame.CanvasPosition = Vector2.new(0, ChatFrame.CanvasSize.Y.Offset)

    -- Auto-remove old messages if too many
    if #ChatFrame:GetChildren() > 50 then
        ChatFrame:GetChildren()[1]:Destroy()
    end
end

-- Keybind Global Handler
UserInputService.InputBegan:Connect(function(input)
    for name, key in pairs(KeybindStates) do
        if input.KeyCode == key then
            -- Fire callback if needed; here just print for demo
            print("Keybind triggered: " .. name)
            -- Add damage message example
            Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)
        end
    end
end)

-- Minimize Functionality
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    Tween(MainFrame, {Size = minimized and UDim2.new(0, 600, 0, 30) or UDim2.new(0, 600, 0, 400)}, 0.3)
    ContentFrame.Visible = not minimized
    MinimizeButton.Text = minimized and "+" or "-"
end)

-- Toggle Keybinds Panel
local kbVisible = false
-- Add a button to toggle keybinds, e.g., on TopBar
local KbToggle = Instance.new("TextButton")
KbToggle.Name = "KbToggle"
KbToggle.Parent = TopBar
KbToggle.BackgroundTransparency = 1
KbToggle.Position = UDim2.new(1, -60, 0, 0)
KbToggle.Size = UDim2.new(0, 20, 1, 0)
KbToggle.Font = Enum.Font.Gotham
KbToggle.Text = "KB"
KbToggle.TextColor3 = Color3.fromRGB(150, 150, 150)
KbToggle.TextSize = 12

KbToggle.MouseButton1Click:Connect(function()
    kbVisible = not kbVisible
    KeybindsPanel.Visible = kbVisible
    Tween(KeybindsPanel, {Position = kbVisible and UDim2.new(1, -200, 0, 50) or UDim2.new(1, 0, 0, 50)}, 0.3, Enum.EasingStyle.Back)
end)

-- Example Usage (to match screenshot)
local ExampleTab = Library:CreateTab("Example")

local Section1 = CreateSection(ExampleTab, "Title")

Library:CreateToggle(Section1, {Name = "Toggle", Default = false})
Library:CreateSlider(Section1, {Name = "Slider", Min = 0, Max = 100, Default = 50})
Library:CreateDropdown(Section1, {Name = "Example Dropdown", Options = {"Option 1", "Option 2", "Option 3"}, Default = "Option 1"})
Library:CreateKeybind(Section1, {Name = "Example Keybind", Default = Enum.KeyCode.F})
Library:CreateColorPicker(Section1, {Name = "Color Keybind", Default = Color3.fromRGB(255, 0, 0)})

local SettingsTab = Library:CreateTab("Settings")

local Section2 = CreateSection(SettingsTab, "Title")

Library:CreateToggle(Section2, {Name = "Toggle", Default = true})
Library:CreateSlider(Section2, {Name = "Slider", Min = 0, Max = 100, Default = 50})
Library:CreateDropdown(Section2, {Name = "Example Dropdown", Options = {"Option 1"}, Default = "Option 1"})
Library:CreateKeybind(Section2, {Name = "Example Keybind", Default = Enum.KeyCode.NONE})

-- Example messages
Library:AddMessage("Hello there!! This is textThis is textThis is textThis is textThis is text")
Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)
Library:AddMessage("Hello there!! This is textThis is textThis is textThis is textThis is text")
Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)
Library:AddMessage("Hello there!! This is textThis is textThis is textThis is textThis is text")
Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)
Library:AddMessage("Hello there!! This is textThis is textThis is textThis is textThis is text")
Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)

-- Return the library
return Library
