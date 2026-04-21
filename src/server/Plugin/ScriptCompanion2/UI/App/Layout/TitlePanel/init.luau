--!strict

local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local Types = require(script.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

--// TitlePanel is simple. It's the panel in the top of the UI
local function TitlePanel(props: Props)
	local theme = props.Theme

	return e("Frame", {
		Size = UDim2.new(1, 0, 0, props.LayoutSettings.TitlePanelHeight),
		Position = UDim2.fromScale(0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = theme.TitlePanelColor,
		BorderSizePixel = 0,
	}, {
		Splitter = e("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 1),
			BackgroundColor3 = props.Theme.PanelSplitterColor,
			BorderSizePixel = 0,
			ZIndex = 200,
		}),

		TitleText = e("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			TextSize = props.LayoutSettings.TitlePanelTextSize,
			TextColor3 = props.Theme.HighlitTextColor,
			Font = Enum.Font.SourceSansBold,
			Text = "Script Companion",
		}),
	})
end

type Props = {
	Theme: Types.Theme,
	LayoutSettings: any,
}

return TitlePanel
