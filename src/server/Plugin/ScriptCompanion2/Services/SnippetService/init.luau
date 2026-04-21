--[[
    This services handles creating, removing and other general snippet stuff
]]

--// Services
local HttpService = game:GetService("HttpService")

local SnippetService = {}

--// Private Functions \\--

--// This function handles prompting the user if the current snippet name is already used
local function ValidateSnippetName(snippetInfo: SnippetInfo): boolean
	return true
end

--// This function handles adding a SnippetTemplate to the UI
local function CreateSnippetInUI(snippetInfo: SnippetInfo) end

local pluginObject: Plugin = nil -- this will hold plugin

function SnippetService.Init(plugin: Plugin)
	pluginObject = plugin
end

--// Public Functions \\--
function SnippetService.CreateSnippet(snippetInfo: SnippetInfo)
	if not pluginObject then
		return
	end

	-- Use the Name as the key to prevent duplicates
	local name = snippetInfo.Name or "Unnamed"
	local generatedId = string.sub(HttpService:GenerateGUID(false), 1, 6)

	local info: SnippetInfo = {
		ID = generatedId,
		Name = name,
		Code = snippetInfo.Code or `-- This is a placeholder for a snippet {name}`,
		Description = snippetInfo.Description or "",
	}

	local snippets = pluginObject:GetSetting("CustomUserSnippets") or {}
	snippets[name] = info

	pluginObject:SetSetting("CustomUserSnippets", snippets)
	-- print("Saved snippet:", name)

	CreateSnippetInUI(info)
end

function SnippetService.GetAllSnippets(): { [string]: SnippetInfo }
	--print(pluginObject:GetSetting("CustomUserSnippets"))
	return pluginObject:GetSetting("CustomUserSnippets") or {}
end

--// Types
type SnippetInfo = {
	ID: string,
	Name: string,
	Code: string,
	Description: string,
}

return SnippetService
