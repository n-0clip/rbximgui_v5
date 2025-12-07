local Loader = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local banner = [[
 __   .__.__  .__   _____                 .___
|  | _|__|  | |  |_/ ____\____   ____   __| _/
|  |/ /  |  | |  |\   __\/ __ \_/ __ \ / __ | 
|    <|  |  |_|  |_|  | \  ___/\  ___// /_/ | 
|__|_ \__|____/____/__|  \___  >\___  >____ | 
     \/                      \/     \/     \/ 
]]

Loader.Gui = nil
Loader.ProgressBar = nil
Loader.StatusLabel = nil

function Loader.Create()
    print(banner)
    
    pcall(function()
        if CoreGui:FindFirstChild("KillfeedLoader") then
            CoreGui.KillfeedLoader:Destroy()
        end
    end)
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "KillfeedLoader"
    gui.Parent = CoreGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "killfeed.cc"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0.9, 0, 0, 8)
    barBg.Position = UDim2.new(0.05, 0, 0.5, 0)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.BorderSizePixel = 0
    barBg.Parent = frame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = barBg
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    bar.BorderSizePixel = 0
    bar.Parent = barBg
    
    local barCorner2 = Instance.new("UICorner")
    barCorner2.CornerRadius = UDim.new(0, 4)
    barCorner2.Parent = bar
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.7, 0)
    status.BackgroundTransparency = 1
    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(150, 150, 150)
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    Loader.Gui = gui
    Loader.ProgressBar = bar
    Loader.StatusLabel = status
end

function Loader.UpdateProgress(percent, text)
    if Loader.ProgressBar then
        TweenService:Create(Loader.ProgressBar, TweenInfo.new(0.3), {Size = UDim2.new(percent / 100, 0, 1, 0)}):Play()
    end
    if Loader.StatusLabel and text then
        Loader.StatusLabel.Text = text
    end
end

function Loader.Success(text)
    if Loader.StatusLabel then
        Loader.StatusLabel.Text = text or "Loaded!"
        Loader.StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    task.delay(1, function()
        if Loader.Gui then
            Loader.Gui:Destroy()
        end
    end)
end

function Loader.Error(text)
    if Loader.StatusLabel then
        Loader.StatusLabel.Text = text or "Error!"
        Loader.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    if Loader.ProgressBar then
        Loader.ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end

return Loader
