--!strict

--[[
	This Service handles finding paths to Instances for AutoCompletions
]]

--// Requires
local TableExtras = require(script.Parent.Parent.Utils.TableUtils.TableExtras)

local PathService = {}

--// Private Helper Functions
local function EscapeString(stringToEscape: string, relative: boolean): string
	if stringToEscape:match("^[%a_][%w_]*$") then
		return stringToEscape
	else
		stringToEscape = stringToEscape:gsub("\\", "\\\\"):gsub('"', '\\"')
		return if not relative then `["{stringToEscape}"]` else `{stringToEscape}`
	end
end

local function BuildPathPartsFromAncestor(root: Instance, target: Instance)
	local parts = {}
	local node = target
	while node and node ~= root do
		table.insert(parts, EscapeString(node.Name, false))
		node = node.Parent :: Instance
	end
	TableExtras.Reverse(parts)
	return parts
end

--// Public Helper Functions \\--

--// Returns the raw full path to an instance
function PathService.GetFullPath(instance: Instance): string
	return instance:GetFullName()
end

--// Returns the return path including services needed to get there from the currentScript to a targetModule
function PathService.GetRequirePath(currentScript: Instance, targetModule: Instance): string
	local isDescendant = targetModule:IsDescendantOf(currentScript)
	local root = if isDescendant then currentScript else PathService.GetRootService(targetModule)
	local prefix = if isDescendant then "script" else root.Name

	local parts = BuildPathPartsFromAncestor(root, targetModule)

	local path = prefix
	for _, part in parts do
		if part:match("^%[") then
			path = path .. part
		else
			path = path .. "." .. part
		end
	end

	return path
end

--// Returns the path from the currentScript to a targetModule in the form of a relative string
function PathService.GetRelativePath(currentScript: Instance, targetModule: Instance): string
	if targetModule:IsDescendantOf(currentScript) then
		local parts = {}
		local node = targetModule
		while node and node ~= currentScript do
			table.insert(parts, EscapeString(node.Name, true))
			node = node.Parent :: Instance
		end
		TableExtras.Reverse(parts)
		return "@self/" .. table.concat(parts, "/")
	end

	local currentAncestors: { [Instance]: number } = {}
	local node: Instance? = currentScript.Parent
	local depth = 0
	while node do
		currentAncestors[node] = depth
		node = node.Parent
		depth += 1
	end

	local down = {}
	local lca: Instance? = nil
	node = targetModule
	while node do
		if currentAncestors[node] then
			lca = node
			break
		end
		table.insert(down, EscapeString(node.Name, true))
		node = node.Parent
	end
	TableExtras.Reverse(down)

	if not lca then
		return "./" .. table.concat(down, "/")
	end

	local parts = {}
	if #down > 0 then
		table.insert(parts, table.concat(down, "/"))
	end

	local path = table.concat(parts, "/")
	if not path:match("^%.") then
		path = "./" .. path
	end

	return path
end

--// Returns the service from a current destination (path)
function PathService.GetServiceFromPath(path: string): string?
	local service = path:match("^[^.]+")
	return service
end

--// Returns the root service of the currentScript
function PathService.GetRootService(currentScript: Instance): Instance
	local node = currentScript
	while node.Parent and node.Parent ~= game do
		node = node.Parent
	end
	return node
end

return PathService
