--!strict

--// This tab defines the behaviour for SnippetsTab

local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local TabTypes = require(script.Parent.TabTypes)

local CustomScrollFrame = require(script.Parent.Parent.Utility.CustomScrollFrame)
local SnippetComponent = require(script.SnippetComponent)

local function SnippetsTab(props: TabTypes.Props)
	local theme = props.Theme

	return e("Frame", {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 1,
	}, {
		Frame = e("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}),
	})
end

return SnippetsTab
