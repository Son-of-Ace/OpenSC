--!strict

--[[
    This services provides functions to get info about the user using the plugin like their Roblox Name and other stuff
]]

--// Services
local StudioService = game:GetService("StudioService")
local Players = game:GetService("Players")

local UserService = {}

function UserService.GetDeveloperName(): string
	local userId = StudioService:GetUserId()

	if userId <= 0 then
		return "Guest"
	end

	local succes, result = pcall(function()
		return Players:GetNameFromUserIdAsync(userId)
	end)

	if succes then
		return result
	else
		warn(`Failed to fetch developer name: {result}`)
		return "Developer"
	end
end

return UserService
