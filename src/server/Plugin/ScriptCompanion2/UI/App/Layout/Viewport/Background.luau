--!strict

local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local Types = require(script.Parent.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

local function Background(props: Props)
	local theme = props.Theme
	local layoutSettings = props.LayoutSettings

	return e("Frame", {
		Size = UDim2.new(1, 0, 1, layoutSettings.TitlePanelHeight),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = -100,
	}, {
		Texture = e("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = theme.TabViewTexture,
			ImageTransparency = 0,
			ImageColor3 = Color3.fromRGB(255, 255, 255),
		}),
	})
end

type Props = {
	Theme: Types.Theme,
	LayoutSettings: Types.LayoutSetting,
}

return Background
