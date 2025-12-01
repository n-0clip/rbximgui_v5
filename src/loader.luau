-- no loader for you!
-- dont skid its open source






































































































local Loader = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local LoaderUI
local MainFrame
local currentProgress = 0
local targetProgress = 0
local particles = {}

local COLORS = {
    Primary = Color3.fromRGB(138, 43, 226),
    Secondary = Color3.fromRGB(186, 85, 211),
    Accent = Color3.fromRGB(147, 51, 234),
    Background = Color3.fromRGB(15, 15, 20),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(156, 163, 175)
}

local function Tween(instance, duration, properties, style, direction)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(
            duration, 
            style or Enum.EasingStyle.Quad, 
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

local function CreateGradient(parent, rotation, colorTable)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = rotation or 0
    
    local keypoints = {}
    local numColors = #colorTable
    
    if numColors == 1 then
        table.insert(keypoints, ColorSequenceKeypoint.new(0, colorTable[1]))
        table.insert(keypoints, ColorSequenceKeypoint.new(1, colorTable[1]))
    else
        for i, color in ipairs(colorTable) do
            local position = (i - 1) / (numColors - 1)
            table.insert(keypoints, ColorSequenceKeypoint.new(position, color))
        end
    end
    
    gradient.Color = ColorSequence.new(keypoints)
    gradient.Parent = parent
    return gradient
end

local function CreateShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, size, 1, size)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5028857084"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.8
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local function CreateParticle(container)
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = COLORS.Primary
    particle.BackgroundTransparency = math.random(60, 85) / 100
    particle.BorderSizePixel = 0
    particle.ZIndex = 10
    particle.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = particle
    
    return particle
end

local function AnimateParticles(container)
    for i = 1, 30 do
        task.spawn(function()
            local particle = CreateParticle(container)
            table.insert(particles, particle)
            
            while particle and particle.Parent do
                local randomX = math.random()
                local randomY = math.random()
                local duration = math.random(50, 90) / 10
                
                Tween(particle, duration, {
                    Position = UDim2.new(randomX, 0, randomY, 0),
                    BackgroundTransparency = math.random(60, 95) / 100
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                
                task.wait(duration)
            end
        end)
    end
end

local function AnimateText(textLabel, fullText, speed)
    task.spawn(function()
        local displayText = ""
        for i = 1, #fullText do
            displayText = fullText:sub(1, i)
            if textLabel then
                textLabel.Text = displayText
            end
            task.wait(speed or 0.05)
        end
    end)
end

local function MakeDraggable(frame)
    local dragToggle = nil
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        Tween(frame, 0.2, {Position = position}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end

function Loader.Create()
    if LoaderUI then
        LoaderUI:Destroy()
    end
    
    LoaderUI = Instance.new("ScreenGui")
    LoaderUI.Name = "KillfeedLoader_" .. HttpService:GenerateGUID(false)
    LoaderUI.ResetOnSpawn = false
    LoaderUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LoaderUI.IgnoreGuiInset = true
    LoaderUI.DisplayOrder = 999999
    
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, IsMobile and 350 or 450, 0, IsMobile and 250 or 300)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = COLORS.Background
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 3
    MainFrame.Parent = LoaderUI
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = MainFrame
    
    local particleContainer = Instance.new("Frame")
    particleContainer.Name = "ParticleContainer"
    particleContainer.Size = UDim2.new(1, 0, 1, 0)
    particleContainer.Position = UDim2.new(0, 0, 0, 0)
    particleContainer.BackgroundTransparency = 1
    particleContainer.ClipsDescendants = true
    particleContainer.ZIndex = 10
    particleContainer.Parent = MainFrame
    
    AnimateParticles(particleContainer)
    
    local blurEffect = Instance.new("ImageLabel")
    blurEffect.Size = UDim2.new(1, 0, 1, 0)
    blurEffect.BackgroundTransparency = 1
    blurEffect.Image = "rbxassetid://8992230677"
    blurEffect.ImageColor3 = COLORS.Background
    blurEffect.ImageTransparency = 0.3
    blurEffect.ScaleType = Enum.ScaleType.Slice
    blurEffect.SliceCenter = Rect.new(99, 99, 99, 99)
    blurEffect.ZIndex = 3
    blurEffect.Parent = MainFrame
    
    local blurCorner = Instance.new("UICorner")
    blurCorner.CornerRadius = UDim.new(0, 20)
    blurCorner.Parent = blurEffect
    
    CreateShadow(MainFrame, 80, 0.7)
    
    local borderGlow = Instance.new("UIStroke")
    borderGlow.Color = COLORS.Primary
    borderGlow.Thickness = 2
    borderGlow.Transparency = 0.2
    borderGlow.Parent = MainFrame
    
    local borderGradient = CreateGradient(borderGlow, 0, {
        COLORS.Primary,
        COLORS.Secondary,
        COLORS.Accent,
        COLORS.Primary
    })
    
    local outerGlow = Instance.new("ImageLabel")
    outerGlow.Name = "OuterGlow"
    outerGlow.Size = UDim2.new(1.4, 0, 1.4, 0)
    outerGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    outerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    outerGlow.BackgroundTransparency = 1
    outerGlow.Image = "rbxassetid://5028857084"
    outerGlow.ImageColor3 = COLORS.Primary
    outerGlow.ImageTransparency = 0.6
    outerGlow.ZIndex = 2
    outerGlow.Parent = MainFrame
    
    local logoContainer = Instance.new("Frame")
    logoContainer.Name = "LogoContainer"
    logoContainer.Size = UDim2.new(0, 90, 0, 90)
    logoContainer.Position = UDim2.new(0.5, 0, 0, 30)
    logoContainer.AnchorPoint = Vector2.new(0.5, 0)
    logoContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    logoContainer.BackgroundTransparency = 0.2
    logoContainer.BorderSizePixel = 0
    logoContainer.ZIndex = 5
    logoContainer.Parent = MainFrame
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 12)
    logoCorner.Parent = logoContainer
    
    local logoStroke = Instance.new("UIStroke")
    logoStroke.Color = COLORS.Primary
    logoStroke.Thickness = 3
    logoStroke.Transparency = 0
    logoStroke.Parent = logoContainer
    
    local logoGradient = CreateGradient(logoStroke, 0, {
        COLORS.Primary,
        COLORS.Secondary,
        COLORS.Primary
    })
    
    CreateShadow(logoContainer, 40, 0.5)
    
    local logoInnerGlow = Instance.new("ImageLabel")
    logoInnerGlow.Size = UDim2.new(1.3, 0, 1.3, 0)
    logoInnerGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoInnerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    logoInnerGlow.BackgroundTransparency = 1
    logoInnerGlow.Image = "rbxassetid://5028857084"
    logoInnerGlow.ImageColor3 = COLORS.Primary
    logoInnerGlow.ImageTransparency = 0.7
    logoInnerGlow.ZIndex = 5
    logoInnerGlow.Parent = logoContainer
    
    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "K"
    logoText.TextColor3 = COLORS.Text
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize = 52
    logoText.TextTransparency = 0
    logoText.ZIndex = 6
    logoText.Parent = logoContainer
    
    local logoTextGradient = CreateGradient(logoText, 45, {
        COLORS.Primary,
        COLORS.Text,
        COLORS.Secondary
    })
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -40, 0, 40)
    titleLabel.Position = UDim2.new(0, 20, 0, 135)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = ""
    titleLabel.TextColor3 = COLORS.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = IsMobile and 26 or 32
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.TextTransparency = 0
    titleLabel.ZIndex = 4
    titleLabel.Parent = MainFrame
    
    local titleGradient = CreateGradient(titleLabel, 0, {
        COLORS.Primary,
        COLORS.Text,
        COLORS.Secondary,
        COLORS.Text,
        COLORS.Primary
    })
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -40, 0, 25)
    statusLabel.Position = UDim2.new(0, 20, 0, 180)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = COLORS.TextDim
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = IsMobile and 13 or 15
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.TextTransparency = 0.2
    statusLabel.ZIndex = 4
    statusLabel.Parent = MainFrame
    
    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBackground"
    progressBg.Size = UDim2.new(1, -40, 0, 8)
    progressBg.Position = UDim2.new(0, 20, 0, 215)
    progressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    progressBg.BackgroundTransparency = 0.3
    progressBg.BorderSizePixel = 0
    progressBg.ZIndex = 4
    progressBg.Parent = MainFrame
    
    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(1, 0)
    progressBgCorner.Parent = progressBg
    
    local progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = COLORS.Primary
    progressFill.BackgroundTransparency = 0
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 5
    progressFill.Parent = progressBg
    
    local progressFillCorner = Instance.new("UICorner")
    progressFillCorner.CornerRadius = UDim.new(1, 0)
    progressFillCorner.Parent = progressFill
    
    local progressGradient = CreateGradient(progressFill, 90, {
        COLORS.Primary,
        COLORS.Secondary,
        COLORS.Accent
    })
    
    local progressGlow = Instance.new("ImageLabel")
    progressGlow.Size = UDim2.new(1, 20, 1, 20)
    progressGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    progressGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    progressGlow.BackgroundTransparency = 1
    progressGlow.Image = "rbxassetid://5028857084"
    progressGlow.ImageColor3 = COLORS.Primary
    progressGlow.ImageTransparency = 0.5
    progressGlow.ZIndex = 4
    progressGlow.Parent = progressFill
    
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Name = "PercentLabel"
    percentLabel.Size = UDim2.new(1, -40, 0, 25)
    percentLabel.Position = UDim2.new(0, 20, 0, 230)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = COLORS.Primary
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextSize = IsMobile and 15 or 17
    percentLabel.TextXAlignment = Enum.TextXAlignment.Center
    percentLabel.TextTransparency = 0
    percentLabel.ZIndex = 4
    percentLabel.Parent = MainFrame
    
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Name = "VersionLabel"
    versionLabel.Size = UDim2.new(1, -40, 0, 20)
    versionLabel.Position = UDim2.new(0, 20, 1, -25)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v1.0.0 BETA"
    versionLabel.TextColor3 = COLORS.TextDim
    versionLabel.Font = Enum.Font.GothamBold
    versionLabel.TextSize = 10
    versionLabel.TextXAlignment = Enum.TextXAlignment.Center
    versionLabel.TextTransparency = 0.5
    versionLabel.ZIndex = 4
    versionLabel.Parent = MainFrame
    
    LoaderUI.Parent = PlayerGui
    
    MakeDraggable(MainFrame)
    
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    logoContainer.Size = UDim2.new(0, 0, 0, 0)
    
    Tween(MainFrame, 0.7, {
        Size = UDim2.new(0, IsMobile and 350 or 450, 0, IsMobile and 250 or 300)
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    task.wait(0.3)
    
    Tween(logoContainer, 0.6, {
        Size = UDim2.new(0, 90, 0, 90)
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    task.wait(0.4)
    
    AnimateText(titleLabel, "killfeed.cc", 0.08)
    
    task.wait(0.6)
    
    AnimateText(statusLabel, "Initializing", 0.06)
    
    task.spawn(function()
        while outerGlow and outerGlow.Parent do
            Tween(outerGlow, 2.5, {
                ImageTransparency = 0.3,
                Size = UDim2.new(1.5, 0, 1.5, 0)
            }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2.5)
            if not outerGlow or not outerGlow.Parent then break end
            Tween(outerGlow, 2.5, {
                ImageTransparency = 0.7,
                Size = UDim2.new(1.4, 0, 1.4, 0)
            }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2.5)
        end
    end)
    
    task.spawn(function()
        while logoInnerGlow and logoInnerGlow.Parent do
            Tween(logoInnerGlow, 1.5, {ImageTransparency = 0.4}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
            if not logoInnerGlow or not logoInnerGlow.Parent then break end
            Tween(logoInnerGlow, 1.5, {ImageTransparency = 0.8}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
        end
    end)
    
    task.spawn(function()
        while borderGradient and borderGradient.Parent do
            Tween(borderGradient, 4, {Rotation = 360}, Enum.EasingStyle.Linear)
            task.wait(4)
            if borderGradient and borderGradient.Parent then
                borderGradient.Rotation = 0
            end
        end
    end)
    
    task.spawn(function()
        while logoGradient and logoGradient.Parent do
            Tween(logoGradient, 3, {Rotation = 360}, Enum.EasingStyle.Linear)
            task.wait(3)
            if logoGradient and logoGradient.Parent then
                logoGradient.Rotation = 0
            end
        end
    end)
    
    task.spawn(function()
        while titleGradient and titleGradient.Parent do
            Tween(titleGradient, 3, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(3)
            if titleGradient and titleGradient.Parent then
                titleGradient.Offset = Vector2.new(-1, 0)
            end
        end
    end)
    
    local dots = 0
    task.spawn(function()
        task.wait(0.7)
        while statusLabel and statusLabel.Parent do
            local baseText = statusLabel.Text:gsub("%.+$", "")
            dots = (dots % 3) + 1
            if statusLabel then
                statusLabel.Text = baseText .. string.rep(".", dots)
            end
            task.wait(0.4)
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if not LoaderUI or not LoaderUI.Parent then return end
        
        currentProgress = currentProgress + (targetProgress - currentProgress) * 0.1
        
        if progressFill then
            progressFill.Size = UDim2.new(currentProgress / 100, 0, 1, 0)
        end
        
        if percentLabel then
            percentLabel.Text = math.floor(currentProgress) .. "%"
        end
    end)
    
    return LoaderUI
end

function Loader.UpdateProgress(percent, status)
    if not LoaderUI or not LoaderUI.Parent then return end
    
    targetProgress = math.clamp(percent, 0, 100)
    
    local statusLabel = MainFrame and MainFrame:FindFirstChild("StatusLabel")
    if statusLabel and status then
        statusLabel.Text = status:gsub("%.+$", "")
        
        Tween(statusLabel, 0.2, {TextTransparency = 0.5})
        task.wait(0.2)
        Tween(statusLabel, 0.2, {TextTransparency = 0.2})
    end
end

function Loader.SetStatus(status)
    if not LoaderUI or not LoaderUI.Parent then return end
    
    local statusLabel = MainFrame and MainFrame:FindFirstChild("StatusLabel")
    if statusLabel then
        statusLabel.Text = status:gsub("%.+$", "")
    end
end

function Loader.SetProgressBar(percent)
    if not LoaderUI or not LoaderUI.Parent then return end
    
    targetProgress = math.clamp(percent, 0, 100)
end

function Loader.Close(callback)
    if not LoaderUI or not LoaderUI.Parent then 
        if callback then callback() end
        return 
    end
    
    for _, particle in pairs(particles) do
        if particle and particle.Parent then
            particle:Destroy()
        end
    end
    particles = {}
    
    if MainFrame then
        Tween(MainFrame, 0.6, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        
        for _, child in pairs(MainFrame:GetDescendants()) do
            if child:IsA("GuiObject") then
                if child:IsA("TextLabel") then
                    Tween(child, 0.6, {TextTransparency = 1})
                elseif child:IsA("ImageLabel") then
                    Tween(child, 0.6, {ImageTransparency = 1})
                elseif child:IsA("Frame") then
                    Tween(child, 0.6, {BackgroundTransparency = 1})
                elseif child:IsA("UIStroke") then
                    Tween(child, 0.6, {Transparency = 1})
                end
            end
        end
    end
    
    task.wait(0.7)
    
    if LoaderUI then
        LoaderUI:Destroy()
        LoaderUI = nil
    end
    
    if callback then
        callback()
    end
end

function Loader.Success(message, duration)
    if not LoaderUI or not LoaderUI.Parent then return end
    
    local statusLabel = MainFrame and MainFrame:FindFirstChild("StatusLabel")
    local logoStroke = MainFrame and MainFrame:FindFirstChild("LogoContainer") and MainFrame.LogoContainer:FindFirstChild("UIStroke")
    local borderGlow = MainFrame and MainFrame:FindFirstChild("UIStroke")
    
    if statusLabel then
        statusLabel.Text = "✓ " .. (message or "Successfully loaded!")
        Tween(statusLabel, 0.3, {TextColor3 = COLORS.Success})
    end
    
    if logoStroke then
        Tween(logoStroke, 0.3, {Color = COLORS.Success})
    end
    
    if borderGlow then
        Tween(borderGlow, 0.3, {Color = COLORS.Success})
    end
    
    targetProgress = 100
    
    task.wait(duration or 1.5)
    Loader.Close()
end

return Loader
