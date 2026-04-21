--!strict

--// MountUI is what mounts the UI to the Plugin Widget
local React = require(script.Parent.Parent.Parent.Packages.React)
local ReactRoblox = require(script.Parent.Parent.Parent.Packages.ReactRoblox)

local InputService = require(script.Parent.Parent.Parent.Services.InputService)

local RootUI = require(script.Parent.RootUI)

return function(widget)
	local container: Frame = Instance.new("Frame") :: Frame
	container.Name = "React"
	container.Size = UDim2.fromScale(1, 1)
	container.BackgroundTransparency = 1
	container.Parent = widget

	InputService.Init(container)

	local root = ReactRoblox.createRoot(container)
	local app = React.createElement(RootUI)
	root:render(app)
end
