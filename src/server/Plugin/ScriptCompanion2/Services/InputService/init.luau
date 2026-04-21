--!strict

--[[
	InputService handles being able to capture input in the PluginUI
]]

--// Function Stuff
local listeners = {}

--// Mouse
local mousePos

local pluginUI = nil

--// Module
local InputService = {}

--// Private Functions
function UpdateMousePosition(input: InputObject)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		local relativePosition =
			Vector2.new(input.Position.X - pluginUI.AbsolutePosition.X, input.Position.Y - pluginUI.AbsolutePosition.Y)
		mousePos = relativePosition

		-- Loop backwards so removing items doesn't break the loop
		for i = #listeners, 1, -1 do
			local callback = listeners[i]
			task.spawn(callback, mousePos)
		end
	end
end

--// Public Functions
--// Setup
function InputService.Init(ui: Frame)
	pluginUI = ui
	pluginUI.InputChanged:Connect(UpdateMousePosition)
end

function InputService.GetMousePosition(): Vector2
	return mousePos
end

function InputService.OnMouseMove(callback: (Vector2) -> ())
	table.insert(listeners, callback)

	return {
		Disconnect = function()
			local index = table.find(listeners, callback)
			if index then
				table.remove(listeners, index)
			end
		end,
	}
end

return InputService
