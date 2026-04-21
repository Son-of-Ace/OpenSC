--!strict

local React = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local TabSettings = require(script.Parent.Parent.TabTypes)

local function SnippetComponent(props: TabSettings.Props)
	local theme = props.Theme

	return e("Frame", {
		Size = UDim2.fromOffset(250, 170),
		BackgroundColor3 = theme.SnippetBackgroundColor,
	}, {
		Corner = e("UICorner", {
			CornerRadius = UDim.new(0, 5),
		}),
	})
end

return SnippetComponent
