local ServiceProvider = {}

--// Cache all services when the plugin start, for it to show up in autocomplete

-- Service cached + type is obtained with this script
-- Reminder: SES has to be added manually, it's like the odd one out fr
-- PatchBunlderFileWatch also have to be removed (u have be roblox employee to use it)
--[[
local services = {}

for _, class in game:GetService("ReflectionService"):GetClasses() do
	if not (class.Permits and class.Permits.GetService) then
		continue
	end

	local success = pcall(function()
		return game:GetService(class.Name)
	end)

	if success then
		table.insert(services, class.Name)
	end
end

table.sort(services)

local tbl = "local serviceCached: {[string]: any} = {\n"
local tpe = "type GetServiceFn = \n"

for _, n in services do
	tbl ..= `\t{n} = game:GetService("{n}"),\n`
	tpe ..= `\t& ((serviceName: "{n}") -> {n})\n`
end

tbl ..= "}"

print(tbl .. "\n\n" .. tpe)
--]]

local ServicesList = require("@self/ServicesList")
local ServicesTypes = require("@self/ServicesTypes")

local serviceCached: {[string]: any} = ServicesList
type GetServiceFn = ServicesTypes.GetServiceFn

local serviceNames: {string} = {}
for name in serviceCached do
	table.insert(serviceNames, name)
end

table.sort(serviceNames)

--// Internal helper
local function requestService(serviceName: string): any
	if serviceCached[serviceName] then return serviceCached[serviceName] end
	
	local success, result = pcall(function()
		return game:GetService(serviceName)
	end)

	if success and result then
		(serviceCached :: any)[serviceName] = result
		return result :: any
	end

	error(`Failed to get service: {serviceName}`, 2)
end

--// Public API
ServiceProvider.Request = (requestService :: any) :: GetServiceFn

function ServiceProvider.GetAllNames(): {string}
	return serviceNames
end

return ServiceProvider