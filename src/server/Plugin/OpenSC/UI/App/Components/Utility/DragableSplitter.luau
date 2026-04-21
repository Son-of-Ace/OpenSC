--!strict

local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local InputService = require(script.Parent.Parent.Parent.Parent.Parent.Services.InputService)
local Types = require(script.Parent.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

local SNAP_THRESHOLD = 100
local DETACH_DISTANCE = 60
local DEFAULT_SNAP_MARGIN = 30

local function DraggableSplitter(props: Props)
	local theme = props.Theme
	local snapMargin = props.SnapMargin or DEFAULT_SNAP_MARGIN
	local isHorizontal = props.Direction == "Horizontal"

	--// React Variables
	local hovering, setHover = React.useState(false)
	local dragStartCoord = React.useRef(0)
	local initialSize = React.useRef(props.CurrentSize)
	local draggingRef = React.useRef(false)
	local prevMaxSize = React.useRef(0)

	--// Connects the dragging event and handles resizing Panels
	React.useEffect(
		function()
			local moveConnection = InputService.OnMouseMove(function(pos)
				if not draggingRef.current then
					return
				end

				local currentPos = if isHorizontal then pos.X else pos.Y
				local delta = currentPos - dragStartCoord.current

				if props.Anchor == "Left" or props.Anchor == "Top" then
					delta = -delta
				end

				local rawSize = initialSize.current + delta
				local finalSize = math.clamp(rawSize, props.MinSize, props.MaxSize)

				--// Handle Custom Snap Points
				local snapped = false
				if props.SnapPoints then
					for _, snapTarget in props.SnapPoints do
						if math.abs(rawSize - snapTarget) < snapMargin then
							finalSize = snapTarget
							snapped = true
							break
						end
					end
				end

				--// Handle Default Snapping (Close/Open logic) if not already snapped
				if not snapped then
					if initialSize.current == 0 then
						-- Pull to open
						if delta > (SNAP_THRESHOLD + DETACH_DISTANCE) then
							finalSize = math.clamp(rawSize, props.MinSize, props.MaxSize)
						else
							finalSize = 0
						end
					else
						-- Standard threshold snap to 0
						if rawSize < SNAP_THRESHOLD then
							if rawSize > (SNAP_THRESHOLD - DETACH_DISTANCE) then
								finalSize = SNAP_THRESHOLD
							else
								finalSize = 0
							end
						end
					end
				end

				if finalSize ~= props.CurrentSize then
					props.OnSizeChanged(finalSize)
				end
			end)

			return function()
				moveConnection.Disconnect()
			end
		end,
		{
			props.CurrentSize,
			props.OnSizeChanged,
			props.MinSize,
			props.MaxSize,
			props.Anchor,
			props.SnapPoints,
			snapMargin,
		} :: { any }
	)

	React.useEffect(function()
		if prevMaxSize.current <= 0 then
			prevMaxSize.current = props.MaxSize
			return
		end

		if props.MaxSize <= 0 then
			return
		end

		local wasSnappedToMax = props.CurrentSize >= prevMaxSize.current - 2

		if wasSnappedToMax or props.CurrentSize > props.MaxSize then
			if props.CurrentSize ~= props.MaxSize then
				props.OnSizeChanged(props.MaxSize)
			end
		end

		if props.CurrentSize < props.MinSize then
			props.OnSizeChanged(props.MinSize)
		end

		prevMaxSize.current = props.MaxSize
	end, { props.MaxSize, props.MinSize })

	--// This function will be ran when the Splitter hitbox is entered
	local function OnEnter(frame: Frame, input: InputObject)
		setHover(true)
	end

	--// This function will be ran when the Splitter hitbox is left
	local function OnLeave(frame: Frame, input: InputObject)
		if not draggingRef.current then
			setHover(false)
		end
	end

	--// This function will be ran when the Splitter hitbox is pressed
	local function OnInputBegan(frame: Frame, input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingRef.current = true
			local pos = InputService.GetMousePosition()
			dragStartCoord.current = if props.Direction == "Horizontal" then pos.X else pos.Y
			initialSize.current = props.CurrentSize
		end
	end

	--// This function will be ran when the Splitter hitbox is released
	local function OnInputEnded(frame: Frame, input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingRef.current = false
			setHover(false)
		end
	end

	local hitboxSize = if isHorizontal
		then UDim2.new(0, props.HitboxWidth, 1, 0)
		else UDim2.new(1, 0, 0, props.HitboxWidth)

	local visualSize = if isHorizontal
		then UDim2.new(0, props.SplitterSize, 1, 0)
		else UDim2.new(1, 0, 0, props.SplitterSize)

	local position = UDim2.fromScale(0, 0)
	local anchor = Vector2.new(0.5, 0.5)

	if props.Anchor == "Right" then
		position = UDim2.fromScale(1, 0.5)
		anchor = Vector2.new(0.5, 0.5)
	elseif props.Anchor == "Left" then
		position = UDim2.fromScale(0, 0.5)
		anchor = Vector2.new(0.5, 0.5)
	elseif props.Anchor == "Top" then
		position = UDim2.fromScale(0.5, 0)
		anchor = Vector2.new(0.5, 0.5)
	elseif props.Anchor == "Bottom" then
		position = UDim2.fromScale(0.5, 1)
		anchor = Vector2.new(0.5, 0.5)
	end

	return e("Frame", {
		Size = hitboxSize,
		Position = position,
		AnchorPoint = anchor,
		ZIndex = 401,
		BackgroundTransparency = 1,

		[React.Event.MouseEnter] = OnEnter,
		[React.Event.MouseLeave] = OnLeave,
		[React.Event.InputBegan] = OnInputBegan,
		[React.Event.InputEnded] = OnInputEnded,
	}, {
		Splitter = e("Frame", {
			Size = visualSize,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = (hovering or draggingRef.current) and theme.PanelSplitterHighlightColor
				or theme.PanelSplitterColor,
			BorderSizePixel = (hovering or draggingRef.current) and 1 or 0,
			BorderColor3 = theme.PanelSplitterHighlightColor,
			ZIndex = 600,
		}),
	})
end

type Props = {
	Direction: "Horizontal" | "Vertical",
	Anchor: "Left" | "Right" | "Top" | "Bottom",
	CurrentSize: number,
	MinSize: number,
	MaxSize: number,
	OnSizeChanged: (number) -> (),
	HitboxWidth: number,
	SplitterSize: number,
	Theme: Types.Theme,
	SnapPoints: { number }?,
	SnapMargin: number?,
}

return DraggableSplitter
