--!strict

--[[
	This Service handles caching all modules and tracking them on startup
]]

--// Requires
local PathService = require(script.Parent.PathService)

--// Constants
local NAME_PROPERTY_SIGNAL = "Name"
local PARENT_PROPERTY_SIGNAL = "Parent"
local MODULE_SCRIPT = "ModuleScript"

local ModuleLogger = {}

--// Keeps all the cached modules within the game
local TrackedModules: { [ModuleScript]: ModuleInfo } = {}

local function TrackModule(module: ModuleScript)
	local info: ModuleInfo = {
		Name = module.Name,
		Path = PathService.GetFullPath(module),
		Service = PathService.GetServiceFromPath(PathService.GetFullPath(module)),
	}

	--print(`Tracking module: {info.Name} | Path: {info.Path} | Service: {info.Service}`)
	TrackedModules[module] = info

	module.AncestryChanged:Connect(function()
		info.Path = PathService.GetFullPath(module)
		info.Service = PathService.GetServiceFromPath(PathService.GetFullPath(module))
	end)

	module:GetPropertyChangedSignal(NAME_PROPERTY_SIGNAL):Connect(function()
		local originalName = info.Name
		info.Name = module.Name
		info.Path = PathService.GetFullPath(module)
		print(`Upating module name from: {originalName} to: {info.Name}`)
	end)

	local oldParent = module.Parent
	module:GetPropertyChangedSignal(PARENT_PROPERTY_SIGNAL):Connect(function()
		local newParent = module.Parent

		print(`Module: {module.Name} has moved from: {oldParent} to: {newParent}`)

		if not module.Parent then
			TrackedModules[module] = nil
		end

		oldParent = newParent
	end)
end

local function BuildCache()
	for _, module in game:GetDescendants() do
		if module:IsA(MODULE_SCRIPT) then
			TrackModule(module :: ModuleScript)
		end
	end

	game.DescendantAdded:Connect(function(obj: Instance)
		if obj:IsA(MODULE_SCRIPT) then
			TrackModule(obj :: ModuleScript)
		end
	end)
end

function ModuleLogger.GetAllModules()
	return TrackedModules
end

function ModuleLogger.Init()
	BuildCache()
end

--// Types
type ModuleInfo = {
	Name: string,
	Path: string,
	Service: string?,
}

return ModuleLogger
