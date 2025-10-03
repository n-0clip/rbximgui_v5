-- WeedHax GUI Library
-- A Roblox Luau library for creating exploit-style GUIs matching the provided screenshot.
-- Fixed bugs, improved UI, exact match to screenshot elements.
-- Created/Updated on October 03, 2025.

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

-- Header (Paste.lua | Fallen | etc.)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = ScreenGui
Header.BackgroundTransparency = 1
Header.Position = UDim2.new(0, 10, 0, 0)
Header.Size = UDim2.new(0, 600, 0, 25)

local HeaderText = Instance.new("TextLabel")
HeaderText.Name = "HeaderText"
HeaderText.Parent = Header
HeaderText.BackgroundTransparency = 1
HeaderText.Position = UDim2.new(0, 0, 0, 0)
HeaderText.Size = UDim2.new(1, -35, 1, 0)
HeaderText.Font = Enum.Font.Gotham
HeaderText.Text = "Paste.lua | Fallen | User:Finob | Aug. 17, 2025"
HeaderText.TextColor3 = Color3.fromRGB(200, 200, 200)
HeaderText.TextSize = 12
HeaderText.TextXAlignment = Enum.TextXAlignment.Left

local Avatar = Instance.new("ImageLabel")
Avatar.Name = "Avatar"
Avatar.Parent = Header
Avatar.BackgroundTransparency = 1
Avatar.Position = UDim2.new(1, -30, 0, 0)
Avatar.Size = UDim2.new(0, 25, 0, 25)
Avatar.Image = "rbxasset://textures/face.png"
Avatar.ImageColor3 = Color3.fromRGB(255, 255, 255)

local AvCorner = Instance.new("UICorner")
AvCorner.CornerRadius = UDim.new(1, 0)
AvCorner.Parent = Avatar

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0, 30)
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
TitleLabel.Size = UDim2.new(1, -130, 1, 0)
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

-- Keybinds Toggle Button
local KeybindsButton = Instance.new("TextButton")
KeybindsButton.Name = "KeybindsButton"
KeybindsButton.Parent = TopBar
KeybindsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeybindsButton.BorderSizePixel = 0
KeybindsButton.Position = UDim2.new(1, -25, 0, 5)
KeybindsButton.Size = UDim2.new(0, 20, 0, 20)
KeybindsButton.Font = Enum.Font.Gotham
KeybindsButton.Text = ""
KeybindsButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local KbCorner = Instance.new("UICorner")
KbCorner.CornerRadius = UDim.new(0, 4)
KbCorner.Parent = KeybindsButton

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

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabButtons
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 0)

-- Tab Content
local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Parent = ContentFrame
TabContent.BackgroundTransparency = 1
TabContent.Position = UDim2.new(0, 120, 0, 0)
TabContent.Size = UDim2.new(1, -120, 1, 0)

-- Keybinds Panel
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

local KeybindsListLayout = Instance.new("UIListLayout")
KeybindsListLayout.Parent = KeybindsPanel
KeybindsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
KeybindsListLayout.Padding = UDim.new(0, 2)
KeybindsListLayout.Position = UDim2.new(0, 0, 0, 25)

-- Chat Frame
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
ChatFrame.ScrollBarImageTransparency = 0.5

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.Parent = ChatFrame
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLayout.Padding = UDim.new(0, 2)

-- Local variables
local CurrentTab = nil
local Tabs = {}
local Elements = {}

local KeybindStates = {}  -- name -> keycode or nil
local KeybindButtons = {}  -- name -> button
local KbEntries = {}  -- name -> entry label
local Callbacks = {}  -- name -> callback
local currentListening = nil

-- Utility Functions
local function Tween(obj, props, duration, easing)
    duration = duration or 0.3
    easing = easing or Enum.EasingStyle.Quad
    local tween = TweenService:Create(obj, TweenInfo.new(duration, easing, Enum.EasingDirection.Out), props)
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
Library.CreateSection = CreateSection

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

    table.insert(Tabs, {Button = TabButton, Frame = Tab})

    if #Tabs == 1 then
        CurrentTab = Tab
        Tab.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    TabButton.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Visible = false
            local currentIndex = 0
            for i, t in ipairs(Tabs) do
                if t.Frame == CurrentTab then
                    currentIndex = i
                    break
                end
            end
            if currentIndex > 0 then
                Tabs[currentIndex].Button.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
        CurrentTab = Tab
        Tab.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    return TabList
end

-- Toggle
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

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ToggleButton

    local state = default
    callback(state)

    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        Tween(ToggleButton, {BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)})
        callback(state)
    end)

    return {
        Set = function(_, newState)
            state = newState
            Tween(ToggleButton, {BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)})
            callback(state)
        end
    }
end

-- Slider
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
    SliderLabel.Position = UDim2.new(0, 5, 0, 5)
    SliderLabel.Size = UDim2.new(0.5, 0, 0.3, 0)
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
    SliderBar.Position = UDim2.new(0.5, 0, 0.5, -2.5)
    SliderBar.Size = UDim2.new(0.45, 0, 0, 5)

    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.ZIndex = 2

    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "Button"
    SliderButton.Parent = SliderBar
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Position = UDim2.new((default - min) / (max - min), -5, -5, 0)
    SliderButton.Size = UDim2.new(0, 10, 0, 10)
    SliderButton.Font = Enum.Font.Gotham
    SliderButton.Text = ""
    SliderButton.ZIndex = 3

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = SliderButton

    local dragging = false
    local value = default
    callback(value)

    local function UpdateSlider()
        local mousePos = UserInputService:GetMouseLocation()
        local barPos = SliderBar.AbsolutePosition.X
        local barSize = SliderBar.AbsoluteSize.X
        local percent = math.clamp((mousePos.X - barPos) / barSize, 0, 1)
        value = math.floor(min + (max - min) * percent)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderButton.Position = UDim2.new(percent, -5, -5, 0)
        SliderLabel.Text = name .. ": " .. value
        callback(value)
    end

    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
        UpdateSlider()
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return {
        Set = function(_, newValue)
            value = math.clamp(newValue, min, max)
            local percent = (value - min) / (max - min)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -5, -5, 0)
            SliderLabel.Text = name .. ": " .. value
            callback(value)
        end
    }
end

-- Dropdown
function Library:CreateDropdown(parent, options)
    options = options or {}
    local name = options.Name or "Dropdown"
    local optsList = options.Options or {}
    local default = options.Default or optsList[1]
    local keyDefault = options.KeyDefault  -- nil or KeyCode
    local callback = options.Callback or function() end
    local keyCallback = options.KeyCallback or function() end

    local hasKey = keyDefault ~= nil
    local frameHeight = hasKey and 40 or 25
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name .. "Dropdown"
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Size = UDim2.new(1, -10, 0, frameHeight)

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Parent = DropdownFrame
    NameLabel.BackgroundTransparency = 1
    NameLabel.Position = UDim2.new(0, 5, 0, 0)
    NameLabel.Size = UDim2.new(1, 0, 0, 20)
    NameLabel.Font = Enum.Font.Gotham
    NameLabel.Text = name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextSize = 12
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local selectedLabel
    if hasKey then
        local SelectedFrame = Instance.new("Frame")
        SelectedFrame.Name = "SelectedFrame"
        SelectedFrame.Parent = DropdownFrame
        SelectedFrame.BackgroundTransparency = 1
        SelectedFrame.Position = UDim2.new(0, 0, 0, 20)
        SelectedFrame.Size = UDim2.new(1, 0, 0, 20)

        selectedLabel = Instance.new("TextLabel")
        selectedLabel.Name = "Selected"
        selectedLabel.Parent = SelectedFrame
        selectedLabel.BackgroundTransparency = 1
        selectedLabel.Position = UDim2.new(0, 5, 0, 0)
        selectedLabel.Size = UDim2.new(1, -45, 1, 0)
        selectedLabel.Font = Enum.Font.Gotham
        selectedLabel.Text = default
        selectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        selectedLabel.TextSize = 12
        selectedLabel.TextXAlignment = Enum.TextXAlignment.Left

        local dkeyName = name .. "_key"
        KeybindStates[dkeyName] = keyDefault
        local dtext = keyDefault and keyDefault.Name or "NONE"
        local dcolor = keyDefault and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(255, 0, 0)
        Callbacks[dkeyName] = keyCallback

        local KeybindButton = Instance.new("TextButton")
        KeybindButton.Name = "KeyButton"
        KeybindButton.Parent = SelectedFrame
        KeybindButton.BackgroundColor3 = dcolor
        KeybindButton.BorderSizePixel = 0
        KeybindButton.Position = UDim2.new(1, -40, 0, 0)
        KeybindButton.Size = UDim2.new(0, 35, 1, 0)
        KeybindButton.Font = Enum.Font.GothamBold
        KeybindButton.Text = dtext
        KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeybindButton.TextSize = 10
        KeybindButton.TextXAlignment = Enum.TextXAlignment.Center

        local dcorner = Instance.new("UICorner")
        dcorner.CornerRadius = UDim.new(0, 3)
        dcorner.Parent = KeybindButton

        KeybindButtons[dkeyName] = KeybindButton

        local dkbe = Instance.new("TextLabel")
        dkbe.Name = dkeyName .. "Entry"
        dkbe.Parent = KeybindsPanel
        dkbe.BackgroundTransparency = 1
        dkbe.Size = UDim2.new(1, -10, 0, 20)
        dkbe.Font = Enum.Font.Gotham
        dkbe.Text = name .. ": " .. dtext
        dkbe.TextColor3 = Color3.fromRGB(255, 255, 255)
        dkbe.TextSize = 11
        dkbe.TextXAlignment = Enum.TextXAlignment.Left
        KbEntries[dkeyName] = dkbe

        KeybindButton.MouseButton1Click:Connect(function()
            if currentListening == dkeyName then
                KeybindStates[dkeyName] = nil
                KeybindButton.Text = "NONE"
                KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                dkbe.Text = name .. ": NONE"
                keyCallback(nil)
                currentListening = nil
            else
                currentListening = dkeyName
                KeybindButton.Text = "..."
                KeybindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            end
        end)

        if keyDefault then
            keyCallback(keyDefault)
        end
    else
        selectedLabel = Instance.new("TextLabel")
        selectedLabel.Name = "Selected"
        selectedLabel.Parent = DropdownFrame
        selectedLabel.BackgroundTransparency = 1
        selectedLabel.Position = UDim2.new(0, 5, 0, 20)
        selectedLabel.Size = UDim2.new(1, 0, 0, 5)
        selectedLabel.Font = Enum.Font.Gotham
        selectedLabel.Text = default
        selectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        selectedLabel.TextSize = 12
        selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    end

    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "List"
    DropdownList.Parent = DropdownFrame
    DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownList.BorderSizePixel = 0
    DropdownList.Position = UDim2.new(0, 0, 1, 2)
    DropdownList.Size = UDim2.new(1, 0, 0, #optsList * 20)
    DropdownList.Visible = false
    DropdownList.ZIndex = 10

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropdownList
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 0)

    for i, opt in ipairs(optsList) do
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
        OptButton.Position = UDim2.new(0, 5, 0, 0)

        OptButton.MouseButton1Click:Connect(function()
            default = opt
            selectedLabel.Text = default
            callback(default)
            DropdownList.Visible = false
        end)

        OptButton.MouseEnter:Connect(function()
            OptButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            OptButton.BackgroundTransparency = 0
        end)

        OptButton.MouseLeave:Connect(function()
            OptButton.BackgroundTransparency = 1
        end)
    end

    NameLabel.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)

    callback(default)

    return {
        Set = function(_, newValue)
            for _, opt in ipairs(optsList) do
                if opt == newValue then
                    default = newValue
                    selectedLabel.Text = default
                    callback(default)
                    break
                end
            end
        end
    }
end

-- Keybind (standalone)
function Library:CreateKeybind(parent, options)
    options = options or {}
    local name = options.Name or "Keybind"
    local default = options.Default  -- KeyCode or nil
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

    KeybindStates[name] = default
    local text = default and default.Name or "NONE"
    local color = default and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(255, 0, 0)
    Callbacks[name] = callback

    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Name = "Button"
    KeybindButton.Parent = KeybindFrame
    KeybindButton.BackgroundColor3 = color
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Position = UDim2.new(1, -40, 0, 0)
    KeybindButton.Size = UDim2.new(0, 35, 1, 0)
    KeybindButton.Font = Enum.Font.GothamBold
    KeybindButton.Text = text
    KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeybindButton.TextSize = 10
    KeybindButton.TextXAlignment = Enum.TextXAlignment.Center

    local kcorner = Instance.new("UICorner")
    kcorner.CornerRadius = UDim.new(0, 3)
    kcorner.Parent = KeybindButton

    KeybindButtons[name] = KeybindButton

    local kbe = Instance.new("TextLabel")
    kbe.Name = name .. "Entry"
    kbe.Parent = KeybindsPanel
    kbe.BackgroundTransparency = 1
    kbe.Size = UDim2.new(1, -10, 0, 20)
    kbe.Font = Enum.Font.Gotham
    kbe.Text = name .. ": " .. text
    kbe.TextColor3 = Color3.fromRGB(255, 255, 255)
    kbe.TextSize = 11
    kbe.TextXAlignment = Enum.TextXAlignment.Left
    KbEntries[name] = kbe

    KeybindButton.MouseButton1Click:Connect(function()
        if currentListening == name then
            KeybindStates[name] = nil
            KeybindButton.Text = "NONE"
            KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            kbe.Text = name .. ": NONE"
            callback(nil)
            currentListening = nil
        else
            currentListening = name
            KeybindButton.Text = "..."
            KeybindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end)

    if default then
        callback(default)
    end

    return {
        Set = function(_, newKey)
            KeybindStates[name] = newKey
            local btn = KeybindButtons[name]
            local txt = newKey and newKey.Name or "NONE"
            local col = newKey and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(255, 0, 0)
            btn.Text = txt
            btn.BackgroundColor3 = col
            KbEntries[name].Text = name .. ": " .. txt
            callback(newKey)
        end
    }
end

-- Color Picker
function Library:CreateColorPicker(parent, options)
    options = options or {}
    local name = options.Name or "ColorPicker"
    local default = options.Default or Color3.fromRGB(255, 255, 255)
    local callback = options.Callback or function() end

    local ColorFrame = Instance.new("Frame")
    ColorFrame.Name = name .. "ColorPicker"
    ColorFrame.Parent = parent
    ColorFrame.BackgroundTransparency = 1
    ColorFrame.BorderSizePixel = 0
    ColorFrame.Size = UDim2.new(1, -10, 0, 20)

    local ColorPreview = Instance.new("Frame")
    ColorPreview.Name = "Preview"
    ColorPreview.Parent = ColorFrame
    ColorPreview.BackgroundColor3 = default
    ColorPreview.BorderSizePixel = 0
    ColorPreview.Position = UDim2.new(0, 0, 0, 0)
    ColorPreview.Size = UDim2.new(0, 20, 1, 0)

    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Name = "Label"
    ColorLabel.Parent = ColorFrame
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Position = UDim2.new(0, 25, 0, 0)
    ColorLabel.Size = UDim2.new(1, -25, 1, 0)
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.Text = name
    ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorLabel.TextSize = 12
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left

    local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,255,255)}
    local currentColorIndex = 1
    for i, c in ipairs(colors) do
        if c == default then currentColorIndex = i break end
    end

    ColorPreview.MouseButton1Click:Connect(function()
        currentColorIndex = currentColorIndex % #colors + 1
        default = colors[currentColorIndex]
        ColorPreview.BackgroundColor3 = default
        callback(default)
    end)

    callback(default)

    return {
        Set = function(_, newColor)
            default = newColor
            ColorPreview.BackgroundColor3 = default
            callback(default)
        end
    }
end

-- Add Message to Chat
function Library:AddMessage(text, isDamage)
    local MessageFrame = Instance.new("Frame")
    MessageFrame.Name = "Message"
    MessageFrame.Parent = ChatFrame
    MessageFrame.BackgroundTransparency = 1
    MessageFrame.Size = UDim2.new(1, -10, 0, 25)

    local IconFrame = Instance.new("Frame")
    IconFrame.Parent = MessageFrame
    IconFrame.BackgroundColor3 = isDamage and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 150, 255)
    IconFrame.BorderSizePixel = 0
    IconFrame.Position = UDim2.new(0, 0, 0.5, -10)
    IconFrame.Size = UDim2.new(0, 20, 0, 20)

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = IconFrame

    local IconText = Instance.new("TextLabel")
    IconText.Parent = IconFrame
    IconText.BackgroundTransparency = 1
    IconText.Size = UDim2.new(1, 0, 1, 0)
    IconText.Font = Enum.Font.GothamBold
    IconText.Text = isDamage and "🔫" or "!"
    IconText.TextColor3 = Color3.fromRGB(255, 255, 255)
    IconText.TextSize = 12
    IconText.TextXAlignment = Enum.TextXAlignment.Center

    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Text"
    MessageLabel.Parent = MessageFrame
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Position = UDim2.new(0, 25, 0, 0)
    MessageLabel.Size = UDim2.new(1, -25, 1, 0)
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = text
    MessageLabel.TextColor3 = isDamage and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
    MessageLabel.TextSize = 11
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextWrapped = true

    ChatFrame.CanvasSize = UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y)
    ChatFrame.CanvasPosition = Vector2.new(0, ChatFrame.CanvasSize.Y.Offset)

    if #ChatFrame:GetChildren() > 50 then
        ChatFrame:GetChildren()[1]:Destroy()
    end
end

-- Global Keybind Handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.Unknown then return end

    -- Trigger
    for n, k in pairs(KeybindStates) do
        if k == kc then
            print("Keybind triggered: " .. n)
            Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)
        end
    end

    -- Listening
    if currentListening then
        local newKey = kc
        local btn = KeybindButtons[currentListening]
        local kbe = KbEntries[currentListening]
        local cb = Callbacks[currentListening]
        KeybindStates[currentListening] = newKey
        btn.Text = newKey.Name
        btn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        kbe.Text = currentListening .. ": " .. newKey.Name
        if cb then cb(newKey) end
        currentListening = nil
    end
end)

-- Keybinds Panel Toggle
local kbVisible = false
KeybindsButton.MouseButton1Click:Connect(function()
    kbVisible = not kbVisible
    KeybindsPanel.Visible = kbVisible
    local targetPos = kbVisible and UDim2.new(1, -200, 0, 50) or UDim2.new(1, 0, 0, 50)
    Tween(KeybindsPanel, {Position = targetPos}, 0.3, Enum.EasingStyle.Back)
end)

-- Example Usage
local ExampleTab = Library:CreateTab("Example")

local Section1 = Library:CreateSection(ExampleTab, "Title")

Library:CreateToggle(Section1, {Name = "Toggle", Default = false})

local Slider1 = Library:CreateSlider(Section1, {Name = "Slider", Min = 0, Max = 100, Default = 50})

Library:CreateDropdown(Section1, {
    Name = "Example Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    KeyDefault = Enum.KeyCode.F
})

Library:CreateColorPicker(Section1, {Name = "Color Keybind", Default = Color3.fromRGB(255, 0, 0)})

local Section2 = Library:CreateSection(ExampleTab, "Title")

Library:CreateToggle(Section2, {Name = "Toggle", Default = false})

local Slider2 = Library:CreateSlider(Section2, {Name = "Slider", Min = 0, Max = 100, Default = 50})

Library:CreateDropdown(Section2, {
    Name = "Example Dropdown",
    Options = {"Option 1"},
    Default = "Option 1",
    KeyDefault = nil  -- For NONE, but since nil, red NONE
})

local SettingsTab = Library:CreateTab("Settings")

-- Example messages
Library:AddMessage("Hello there!! This is textThis is textThis is textThis is textThis is text")
Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)
Library:AddMessage("Hello there!! This is textThis is textThis is textThis is textThis is text")
Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)
Library:AddMessage("Hello there!! This is textThis is textThis is textThis is textThis is text")
Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)
Library:AddMessage("Hello there!! This is textThis is textThis is textThis is textThis is text")
Library:AddMessage("Hit noob in the head for 100 damage (UpperTorso)", true)

return Library
