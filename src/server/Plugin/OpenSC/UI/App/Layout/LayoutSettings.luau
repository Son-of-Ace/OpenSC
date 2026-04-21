--!strict

return {
	--// MinLeftPanelSize defines how small the LeftPanel can get from dragging it.
	MinLeftPanelSize = 0,

	--// CurrentLeftPanelSize holds the reference to the current width used for other Panels to scale relative to it
	CurrentLeftPanelSize = 250,

	--// MinTerminalPanelSize defines how small the TerminalPanel can get from dragging it.
	MinTerminalPanelSize = 0,

	--// MaxTerminalPanelSize defines how small the TerminalPanel can get from dragging it.
	CurrentTerminalPanelSize = 150,

	--// TitlePanelHeight is used for the Title component
	TitlePanelHeight = 60,

	--// TabHeaderHeight is used for the Header each tab has
	TabHeaderHeight = 60,

	--// ButtonTextSize defines the TextSize for most buttons
	ButtonTextSize = 28,

	--// TitlePanelTextSize defines the TextSize for TitlePanel
	TitlePanelTextSize = 35,

	--// HeaderTextSize defines the TextSize for TabHeaders
	HeaderTextSize = 30,

	--// TopPadding defines the amount of padding between the TabHeader and TabContent frames
	TopPadding = UDim.new(0, 20),

	--// LeftPadding defines the amount of padding between the Left and the TabContent
	LeftPadding = UDim.new(0, 40),

	RightPadding = UDim.new(0, 40),
}
