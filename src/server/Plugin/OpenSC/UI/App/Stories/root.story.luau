--!strict

--// This story defines the UI for UILabs

local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local ReactRoblox = require(script.Parent.Parent.Parent.Parent.Packages.ReactRoblox)

local e = React.createElement

local InputService = require(script.Parent.Parent.Parent.Parent.Services.InputService)

local RootUI = require(script.Parent.Parent.Parent.Startup.RootUI)

return function(parent)
	local root = ReactRoblox.createRoot(parent)
	local app = e(RootUI)
	root:render(app)

	InputService.Init(parent :: Frame)

	return function()
		root:unmount()
	end
end
