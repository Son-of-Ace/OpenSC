--!strict

local TweenService = game:GetService("TweenService")

local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local Types = require(script.Parent.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

local function Button(props: Props)
	local theme = props.Theme

	local hover, setHover = React.useState(false)
	local indicatorRef = React.useRef(nil)

	--// This effect handles the Indicator tweening when hovering over a button
	React.useEffect(function()
		local indicator = indicatorRef.current
		if not indicator then
			return
		end

		local targetHeight = props.Active and 1 or (hover and 0.5 or 0)
		local tween = TweenService:Create(
			indicator,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Size = UDim2.new(0, 5, targetHeight, 0) }
		)
		tween:Play()
	end, { hover, props.Active })

	--// Building the Button UI
	return e("Frame", {
		Size = UDim2.new(1, 0, 0, props.LayoutSettings.TabHeaderHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, {
		--// OverlayFrame is used for the Gradient and any overlay effect the button might have
		OverlayFrame = if props.Active
			then e("Frame", {
				Size = UDim2.new(1, -2, 1, 0),
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				ZIndex = -1,
			}, {
				Stroke = e("UIStroke", {
					Color = theme.CTAColor,
				}),

				Gradient = e("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 37, 37)),
						ColorSequenceKeypoint.new(0.3, Color3.fromRGB(39, 37, 37)),
						ColorSequenceKeypoint.new(1, theme.CTAColor),
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.95),
						NumberSequenceKeypoint.new(1, 0.3),
					}),
					Rotation = 0,
				}),
			})
			else nil,

		--// ContentFrame contains the Button and the Selection Indicator
		ContentFrame = e("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 2,
		}, {
			Indicator = e("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				BackgroundColor3 = theme.CTAColor,
				BorderSizePixel = 0,
				ref = indicatorRef,
			}),

			--// Button holds an Icon and a Text Label as it's main components structured with a ListLayout
			Button = e("TextButton", {
				Size = UDim2.new(0.9, 0, 0, props.LayoutSettings.TabHeaderHeight),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				Text = "",

				[React.Event.MouseEnter] = function()
					setHover(true)
				end,
				[React.Event.MouseLeave] = function()
					setHover(false)
				end,
				[React.Event.Activated] = function()
					props.OnClick()
				end,
			}, {
				Layout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5),
				}),

				Icon = e("ImageLabel", {
					Size = UDim2.fromOffset(32, 32),
					ImageTransparency = 0,
					BackgroundTransparency = 1,
					ImageColor3 = props.Active and theme.HighlitIconColor or theme.IconColor,
					Image = props.Icon,
					LayoutOrder = 1,
				}),

				Text = e("TextLabel", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Font = props.Active and Enum.Font.SourceSansBold or Enum.Font.SourceSans,
					TextSize = props.LayoutSettings.ButtonTextSize,
					TextColor3 = props.Active and theme.HighlitTextColor or theme.TextColor,
					Text = props.Text,
					LayoutOrder = 2,
				}),
			}),

			--// This splitter appears underneath each button component
			Splitter = e("Frame", {
				Size = UDim2.new(0.9, 0, 0, 1),
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.fromScale(1, 1),
				BackgroundColor3 = theme.PanelSplitterColor,
				BorderSizePixel = 0,
				ZIndex = 1,
			}),
		}),
	})
end

type Props = {
	Theme: Types.Theme,
	LayoutSettings: any,
	Text: string,
	Icon: string,
	OnClick: () -> (),
	Active: boolean,
}

return Button
