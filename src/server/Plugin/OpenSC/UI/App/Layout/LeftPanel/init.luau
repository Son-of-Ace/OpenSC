--!strict

local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local Types = require(script.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)
local Settings = require(script.LeftPanelSettings)

local RadioButton = require(script.Parent.Parent.Components.Buttons.PanelButton)
local DragableSplitter = require(script.Parent.Parent.Components.Utility.DragableSplitter)

local function LeftPanel(props: Props)
	local theme = props.Theme
	local layoutSettings = props.LayoutSettings

	--// Loads all the buttons needed from TabsRegistry into the LeftPanel
	local buttons = {}
	for _, tab in props.Tabs do
		table.insert(
			buttons,
			e(RadioButton, {
				Theme = theme,
				LayoutSettings = props.LayoutSettings,
				Text = tab.Name,
				Icon = tab.Icon,
				Active = tab.Name == props.ActiveTab,
				OnClick = function()
					props.SetActiveTab(tab.Name)
				end,
			})
		)
	end

	--// Building the LeftPanel UI
	return e("Frame", {
		Size = UDim2.new(0, props.LeftPanelSize, 1, 0),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.PanelColor,
		BorderSizePixel = 0,
		ClipsDescendants = false,
	}, {
		ClippedContent = e("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		}, {
			BackgroundFrame = e("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
			}, {
				Texture = e("ImageLabel", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					Image = theme.LeftPanelTexture,
					ImageColor3 = theme.PanelColor,
				}),
			}),

			Buttons = e("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
			}, {
				UIPadding = e("UIPadding", { PaddingTop = UDim.new(0, 20) }),
				UIListLayout = e("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Top,
				}),
			}, buttons),
		}),

		Splitter = e(DragableSplitter, {
			Direction = "Horizontal",
			Anchor = "Right",
			CurrentSize = props.LeftPanelSize,
			MinSize = layoutSettings.MinLeftPanelSize,
			MaxSize = props.MaxAvailableSize.X,
			OnSizeChanged = props.SetLeftPanelSize,
			HitboxWidth = Settings.DragHitboxSize,
			SplitterSize = Settings.SplitterSize,
			Theme = theme,
			SnapPoints = { props.MaxAvailableSize.X },
		}),
	})
end

type Props = {
	Theme: Types.Theme,
	LayoutSettings: Types.LayoutSetting,
	LeftPanelSize: number,
	MaxAvailableSize: Vector2,
	SetLeftPanelSize: (number) -> (),
	ActiveTab: string,
	SetActiveTab: (string) -> (),
	Tabs: { Types.TabsMap },
}

return LeftPanel
