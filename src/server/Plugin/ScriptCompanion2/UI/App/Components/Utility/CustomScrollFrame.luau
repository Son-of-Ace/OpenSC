--!strict

--[[
	CustomScrollFrame:
		- This is a fully custom ScrollFrame implementation fully avoiding roblox's default ScrollingFrame class
		- The purpose of doing this is because roblox's default ScrollFrame sinks ALL input when hovering over it no matter what
]]

local RunService = game:GetService("RunService")

local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local Types = require(script.Parent.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

local function CustomScrollFrame(props: Props)
	local theme = props.Theme

	local viewportRef = React.useRef(nil :: Frame?)
	local contentRef = React.useRef(nil :: Frame?)
	local scrollBarRef = React.useRef(nil :: Frame?)

	local scrollType = props.ScrollType

	React.useEffect(function()
		local viewport: Frame? = viewportRef.current
		local content: Frame? = contentRef.current
		local scrollBar: Frame? = scrollBarRef.current

		local scrollVelocity = 0
		local scrollPosition = 0

		if not viewport or not content or not scrollBar then
			return
		end

		local function UpdateScrollBar()
			local contentHeight = content.AbsoluteSize.Y
			local viewportHeight = viewport.AbsoluteSize.Y

			if contentHeight <= viewportHeight or viewportHeight <= 0 then
				scrollBar.Visible = false
				content.Position = UDim2.new(0, 0, 0, 0)
				return
			else
				scrollBar.Visible = true
			end

			local ratio = math.clamp(viewportHeight / contentHeight, 0.05, 1)
			scrollBar.Size = UDim2.new(0, scrollBar.Size.X.Offset, ratio, 0)

			local scrollPercent = -content.Position.Y.Offset / (contentHeight - viewportHeight)
			scrollBar.Position = UDim2.fromScale(1, scrollPercent * (1 - ratio))
		end

		local function ScrollToBottom()
			local contentHeight = content.AbsoluteSize.Y
			local viewportHeight = viewport.AbsoluteSize.Y

			if contentHeight > viewportHeight then
				local bottomY = viewportHeight - contentHeight
				content.Position = UDim2.fromOffset(0, bottomY)
				scrollPosition = bottomY
				scrollVelocity = 0
			end
			UpdateScrollBar()
		end

		local function OnInputChanged(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseWheel then
				local delta = input.Position.Z * props.ScrollSpeed
				local contentHeight = content.AbsoluteSize.Y
				local viewportHeight = viewport.AbsoluteSize.Y

				if scrollType == "Default" then
					local newY = math.clamp(content.Position.Y.Offset + delta, viewportHeight - contentHeight, 0)
					content.Position = UDim2.fromOffset(0, newY)
				elseif scrollType == "Smooth" then
					scrollVelocity += delta * 0.6
				end

				UpdateScrollBar()
			end
		end

		local function SmoothScroll(dt: number)
			if scrollType ~= "Smooth" then
				return
			end

			local contentHeight = content.AbsoluteSize.Y
			local viewportHeight = viewport.AbsoluteSize.Y

			if contentHeight <= viewportHeight then
				return
			end

			scrollVelocity *= math.pow(0.85, dt * 60)

			if math.abs(scrollVelocity) < 0.01 then
				scrollVelocity = 0
			end

			local minY = viewportHeight - contentHeight
			local maxY = 0

			scrollPosition = math.clamp(scrollPosition + scrollVelocity * dt * 60, minY, maxY)
			content.Position = UDim2.fromOffset(0, scrollPosition)

			UpdateScrollBar()
		end

		local c1 = viewport.InputChanged:Connect(OnInputChanged)
		local c2 = content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			task.defer(ScrollToBottom)
		end)
		local c3 = viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateScrollBar)
		local c4 = RunService.RenderStepped:Connect(SmoothScroll)

		task.defer(ScrollToBottom)

		return function()
			c1:Disconnect()
			c2:Disconnect()
			c3:Disconnect()
			c4:Disconnect()
		end
	end, { props.Children })

	return e("Frame", {
		Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position or UDim2.fromScale(0, 0),
		AnchorPoint = props.AnchorPoint or Vector2.new(0, 0),
		BackgroundTransparency = 1,
	}, {
		Viewport = e("Frame", {
			ref = viewportRef,
			Size = UDim2.new(1, -14, 1, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		}, {
			Content = e("Frame", {
				ref = contentRef,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
			}, {
				unpack(props.Children or {}),
			}),
		}),

		ScrollBarTrack = e("Frame", {
			Size = UDim2.new(0, 14, 1, 0),
			Position = UDim2.fromScale(0.999, 0),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, {
			Border = e("UIStroke", {
				Color = theme.PanelSplitterColor,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				LineJoinMode = Enum.LineJoinMode.Miter,
			}),

			ScrollBar = e("Frame", {
				ref = scrollBarRef,
				Size = UDim2.fromOffset(14, 100),
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(1, 0),
				BackgroundColor3 = theme.CTAColor,
				BorderSizePixel = 0,
			}),
		}),
	})
end

type Props = {
	Theme: Types.Theme,
	ScrollSpeed: number,
	ScrollType: "Default" | "Smooth",
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	Children: { React.ReactElement }?,
}

return CustomScrollFrame
