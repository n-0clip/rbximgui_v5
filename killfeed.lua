-- v3

local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = library.subs.Wait

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local SupportedGames = {
    [301549746] = "Counter Blox",
    [292439477] = "Phantom Forces",
    [17625359962] = "Rivals",
    [286090429] = "Arsenal",
    [982263812] = "Murder Mystery 2",
    [3837841034] = "Bad Business"
}

local PlaceId = game.PlaceId
local GameName = SupportedGames[PlaceId] or "Universal"

-- next is obfucated bcs of skidders.
