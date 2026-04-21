--!strict

local React = require(script.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local Types = require(script.Parent.Parent.Parent.Utils.TypeUtils.Types)

--// Components
local Background = require(script.Viewport.Background)
local TabViewFrame = require(script.Viewport.TabViewFrame)
local LeftPanel = require(script.LeftPanel)
local TitlePanel = require(script.TitlePanel)
local TerminalPanel = require(script.TerminalPanel)

--// Layout is what assembles the whole base layout of the UI. It's pretty simple.
local function Layout(props: Props)
	local theme = props.Theme
	local layoutSettings = props.Settings
	local tabs = props.Tabs

	local activeTab, setActiveTab = React.useState("Snippets")
	local leftPanelSize, setLeftPanelSize = React.useState(layoutSettings.CurrentLeftPanelSize)
	local terminalPanelSize, setTerminalPanelSize = React.useState(layoutSettings.CurrentTerminalPanelSize)
	local mainBodySize, setMainBodySize = React.useState(Vector2.zero)

	return e("Frame", {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = theme.ViewBackgroundColor,
		BorderSizePixel = 0,
	}, {
		TitlePanel = e(TitlePanel, {
			Theme = theme,
			LayoutSettings = layoutSettings,
		}),

		MainBody = e("Frame", {
			Size = UDim2.new(1, 0, 1, -layoutSettings.TitlePanelHeight),
			Position = UDim2.fromOffset(0, layoutSettings.TitlePanelHeight),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = function(rbx)
				setMainBodySize(rbx.AbsoluteSize)
			end,
		}, {
			LeftPanel = e(LeftPanel, {
				Theme = theme,
				LayoutSettings = layoutSettings,
				LeftPanelSize = leftPanelSize,
				MaxAvailableSize = mainBodySize,
				SetLeftPanelSize = setLeftPanelSize,
				Tabs = tabs,
				ActiveTab = activeTab,
				SetActiveTab = setActiveTab,
			}),

			TerminalPanel = e(TerminalPanel, {
				Theme = theme,
				MaxAvailableSize = mainBodySize,
				LayoutSettings = layoutSettings,
				TerminalPanelSize = terminalPanelSize,
				LeftPanelSize = leftPanelSize,
				SetTerminalPanelSize = setTerminalPanelSize,
			}),

			ViewportPanel = e("Frame", {
				Size = UDim2.new(1, -leftPanelSize, 1, 0),
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.fromOffset(leftPanelSize, 0),
				BackgroundTransparency = 1,
			}, {
				Lock = e("UISizeConstraint", {
					MinSize = Vector2.new(0, 0),
				}),

				TabViewFrame = e(TabViewFrame, {
					Theme = theme,
					Tabs = tabs,
					LayoutSettings = layoutSettings,
					LeftPanelWidth = leftPanelSize,
					ActiveTab = activeTab,
				}),
			}),
		}),

		Background = e(Background, {
			Theme = theme,
			LayoutSettings = layoutSettings,
		}),
	})
end

type Props = {
	Theme: Types.Theme,
	Settings: Types.LayoutSetting,
	Tabs: any,
}

return Layout
