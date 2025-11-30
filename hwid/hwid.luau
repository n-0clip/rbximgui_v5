local HWID_System = {}

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer

HWID_System.WhitelistURL = ""
HWID_System.Enabled = true

function HWID_System.Generate()
    local hwid = ""
    
    local success, result = pcall(function()
        local clientId = RbxAnalyticsService:GetClientId()
        local userId = tostring(LocalPlayer.UserId)
        local accountAge = tostring(LocalPlayer.AccountAge)
        local gameId = tostring(game.GameId)
        
        local combined = clientId .. userId .. accountAge .. gameId
        
        local hash1 = 0
        local hash2 = 0
        
        for i = 1, #combined do
            hash1 = (hash1 * 31 + string.byte(combined, i)) % 2147483647
            hash2 = (hash2 * 37 + string.byte(combined, #combined - i + 1)) % 2147483647
        end
        
        local part1 = string.format("%08X", hash1)
        local part2 = string.format("%08X", hash2)
        local part3 = string.sub(clientId:gsub("-", ""), 1, 8):upper()
        
        return "KF-" .. part1 .. "-" .. part2 .. "-" .. part3
    end)
    
    if success and result then
        hwid = result
    else
        local visitorId = ""
        pcall(function()
            visitorId = tostring(RbxAnalyticsService:GetClientId())
        end)
        
        if visitorId == "" then
            visitorId = tostring(LocalPlayer.UserId)
        end
        
        local hash = 0
        local str = visitorId .. tostring(LocalPlayer.UserId) .. tostring(LocalPlayer.AccountAge)
        for i = 1, #str do
            hash = (hash * 31 + string.byte(str, i)) % 2147483647
        end
        
        hwid = "KF-" .. string.format("%08X", hash) .. "-" .. tostring(LocalPlayer.UserId)
    end
    
    return hwid
end

function HWID_System.CheckWhitelist(hwid)
    local success, result = pcall(function()
        local response = game:HttpGet(HWID_System.WhitelistURL)
        
        for line in response:gmatch("[^\r\n]+") do
            local cleanLine = line:gsub("%s+", "")
            if cleanLine == hwid then
                return true
            end
        end
        
        return false
    end)
    
    if success then
        return result
    end
    
    return false
end

function HWID_System.ShowUI(hwid)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    local existingGui = PlayerGui:FindFirstChild("HWID_System_GUI")
    if existingGui then
        existingGui:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HWID_System_GUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.5
    Background.BorderSizePixel = 0
    Background.Parent = ScreenGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 420, 0, 220)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(212, 133, 240)
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 15)
    TitleFix.Position = UDim2.new(0, 0, 1, -15)
    TitleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "killfeed.cc - HWID Verification"
    Title.TextColor3 = Color3.fromRGB(212, 133, 240)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TitleBar
    
    local LockIcon = Instance.new("TextLabel")
    LockIcon.Size = UDim2.new(0, 30, 0, 30)
    LockIcon.Position = UDim2.new(0, 10, 0.5, -15)
    LockIcon.BackgroundTransparency = 1
    LockIcon.Text = "🔒"
    LockIcon.TextSize = 20
    LockIcon.Parent = TitleBar
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -20, 1, -55)
    ContentFrame.Position = UDim2.new(0, 10, 0, 50)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    local HWIDLabel = Instance.new("TextLabel")
    HWIDLabel.Name = "HWIDLabel"
    HWIDLabel.Size = UDim2.new(1, 0, 0, 25)
    HWIDLabel.Position = UDim2.new(0, 0, 0, 5)
    HWIDLabel.BackgroundTransparency = 1
    HWIDLabel.Text = "Your Hardware ID:"
    HWIDLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    HWIDLabel.TextSize = 14
    HWIDLabel.Font = Enum.Font.Gotham
    HWIDLabel.TextXAlignment = Enum.TextXAlignment.Left
    HWIDLabel.Parent = ContentFrame
    
    local HWIDBox = Instance.new("TextBox")
    HWIDBox.Name = "HWIDBox"
    HWIDBox.Size = UDim2.new(1, 0, 0, 38)
    HWIDBox.Position = UDim2.new(0, 0, 0, 32)
    HWIDBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    HWIDBox.BorderSizePixel = 0
    HWIDBox.Text = hwid
    HWIDBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    HWIDBox.TextSize = 13
    HWIDBox.Font = Enum.Font.Code
    HWIDBox.ClearTextOnFocus = false
    HWIDBox.TextEditable = false
    HWIDBox.Parent = ContentFrame
    
    local HWIDBoxCorner = Instance.new("UICorner")
    HWIDBoxCorner.CornerRadius = UDim.new(0, 8)
    HWIDBoxCorner.Parent = HWIDBox
    
    local HWIDBoxStroke = Instance.new("UIStroke")
    HWIDBoxStroke.Color = Color3.fromRGB(60, 60, 70)
    HWIDBoxStroke.Thickness = 1
    HWIDBoxStroke.Parent = HWIDBox
    
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "Buttons"
    ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
    ButtonFrame.Position = UDim2.new(0, 0, 0, 80)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Parent = ContentFrame
    
    local CopyButton = Instance.new("TextButton")
    CopyButton.Name = "CopyButton"
    CopyButton.Size = UDim2.new(0.48, 0, 1, 0)
    CopyButton.Position = UDim2.new(0, 0, 0, 0)
    CopyButton.BackgroundColor3 = Color3.fromRGB(212, 133, 240)
    CopyButton.BorderSizePixel = 0
    CopyButton.Text = "Copy HWID"
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.TextSize = 14
    CopyButton.Font = Enum.Font.GothamBold
    CopyButton.AutoButtonColor = true
    CopyButton.Parent = ButtonFrame
    
    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 8)
    CopyCorner.Parent = CopyButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0.48, 0, 1, 0)
    CloseButton.Position = UDim2.new(0.52, 0, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "Close Game"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.AutoButtonColor = true
    CloseButton.Parent = ButtonFrame
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0, 0, 0, 128)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "You are not whitelisted. Send your HWID to get access."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 100)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    StatusLabel.Parent = ContentFrame
    
    CopyButton.MouseButton1Click:Connect(function()
        local copySuccess = pcall(function()
            if setclipboard then
                setclipboard(hwid)
            elseif toclipboard then
                toclipboard(hwid)
            elseif Clipboard and Clipboard.set then
                Clipboard.set(hwid)
            end
        end)
        
        if copySuccess then
            StatusLabel.Text = "HWID copied to clipboard!"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            CopyButton.Text = "Copied!"
            CopyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            
            task.delay(2, function()
                if CopyButton and CopyButton.Parent then
                    CopyButton.Text = "Copy HWID"
                    CopyButton.BackgroundColor3 = Color3.fromRGB(212, 133, 240)
                end
            end)
        else
            StatusLabel.Text = "Failed to copy. Please copy manually."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        LocalPlayer:Kick("\n\nkillfeed.cc\n\nYou are not whitelisted!\n\nYour HWID:\n" .. hwid .. "\n\nSend this HWID to get access.")
    end)
    
    return ScreenGui
end

function HWID_System.Verify()
    if not HWID_System.Enabled then
        return true
    end
    
    local hwid = HWID_System.Generate()
    local isWhitelisted = HWID_System.CheckWhitelist(hwid)
    
    if isWhitelisted then
        return true, hwid
    else
        HWID_System.ShowUI(hwid)
        return false, hwid
    end
end

function HWID_System.GetHWID()
    return HWID_System.Generate()
end

return HWID_System
