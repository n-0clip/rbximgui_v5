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
        
        local combined = clientId .. userId
        
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
        local str = visitorId .. tostring(LocalPlayer.UserId)
        for i = 1, #str do
            hash = (hash * 31 + string.byte(str, i)) % 2147483647
        end
        
        hwid = "kfcc-" .. string.format("%08X", hash) .. "-" .. tostring(LocalPlayer.UserId)
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

function HWID_System.Verify()
    if not HWID_System.Enabled then
        return true
    end
    
    local hwid = HWID_System.Generate()
    local isWhitelisted = HWID_System.CheckWhitelist(hwid)
    
    if isWhitelisted then
        return true, hwid
    else
        print('not whitelisted')
        return false, hwid
    end
end

function HWID_System.GetHWID()
    return HWID_System.Generate()
end

return HWID_System
