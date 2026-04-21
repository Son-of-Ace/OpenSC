--!strict

local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local Types = require(script.Parent.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

local function SettingsHeader(props: Types.TabHeader)
	return e("Frame", {
		Size = UDim2.fromScale(0.95, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, {
		TabTitleText = e("TextLabel", {
			Text = "Settings",
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,

			TextSize = props.LayoutSettings.HeaderTextSize,
			Font = Enum.Font.SourceSansBold,
			TextColor3 = props.Theme.HighlitTextColor,

			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
		}),
	})
end

return SettingsHeader
