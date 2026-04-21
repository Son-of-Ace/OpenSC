--!strict

--// This tab defines the behaviour for DataStoreTab

local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local function DatastoreTab()
	return e("Frame", {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 1,
	}, {})
end

return DatastoreTab
