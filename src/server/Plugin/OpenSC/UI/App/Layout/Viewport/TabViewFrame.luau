--!strict

local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local Types = require(script.Parent.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

local function TabViewFrame(props: Props)
	local theme = props.Theme
	local tabs = props.Tabs
	local layoutSettings = props.LayoutSettings

	local activeTab = props.ActiveTab

	local activeTabObj
	for _, tab in tabs do
		if tab.Name == activeTab then
			activeTabObj = tab
		end
	end

	local activeTabComponent = activeTabObj and e(activeTabObj.Component, { Theme = theme }) or nil

	return e("Frame", {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
	}, {

		UIPadding = e("UIPadding", {
			PaddingTop = UDim.new(0, 20),
			PaddingBottom = UDim.new(0, 20),
		}),

		TabHeader = e("Frame", {
			Size = UDim2.new(1, 0, 0, layoutSettings.TabHeaderHeight),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, {
			ActiveHeader = activeTabObj and e(activeTabObj.Header, { Theme = theme, LayoutSettings = layoutSettings })
				or nil,

			Padding = e("UIPadding", {
				PaddingLeft = layoutSettings.LeftPadding,
				PaddingRight = layoutSettings.RightPadding,
			}),

			Splitter = e("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				BackgroundColor3 = theme.PanelSplitterColor,
				BorderSizePixel = 0,
			}),
		}),

		TabContent = e("Frame", {
			Size = UDim2.new(1, 0, 1, -layoutSettings.TabHeaderHeight),
			Position = UDim2.fromOffset(0, layoutSettings.TabHeaderHeight),
			BorderSizePixel = 1,
			BackgroundTransparency = 1,
		}, {
			Padding = e("UIPadding", {
				PaddingTop = layoutSettings.TopPadding,
				PaddingLeft = layoutSettings.LeftPadding,
				PaddingRight = layoutSettings.RightPadding,
			}),

			ActiveTab = activeTabComponent,
		}),
	})
end

type Props = {
	Theme: Types.Theme,
	Tabs: any,
	LayoutSettings: Types.LayoutSetting,
	LeftPanelWidth: number,
	ActiveTab: string,
}

return TabViewFrame
