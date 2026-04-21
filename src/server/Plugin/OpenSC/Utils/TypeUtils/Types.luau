--// Defines types used across multiple scripts

local Types = {}

export type Theme = {
	ViewBackgroundColor: Color3,
	PanelColor: Color3,
	TitlePanelColor: Color3,
	PanelSplitterColor: Color3,
	PanelSplitterHighlightColor: Color3,
	CTAColor: Color3,
	TextColor: Color3,
	HighlitTextColor: Color3,

	SnippetBackgroundColor: Color3,
	SnippetUnderBarColor: Color3,
	SnippetBaseButtonColor: Color3,
	SnippetTextColor: Color3,

	IconColor: Color3,
	HighlitIconColor: Color3,

	TerminalCommandColor: Color3,
	TerminalErrorColor: Color3,

	TabViewTexture: string,
	LeftPanelTexture: string,
}

export type LayoutSetting = {
	MinLeftPanelSize: number,
	MaxLeftPanelSize: number,
	CurrentLeftPanelSize: number,
	MinTerminalPanelSize: number,
	MaxTerminalPanelSize: number,
	CurrentTerminalPanelSize: number,
	TitlePanelHeight: number,
	TabHeaderHeight: number,
	ButtonTextSize: number,
	TitlePanelTextSize: number,
	HeaderTextSize: number,
	TopPadding: UDim,
	LeftPadding: UDim,
	RightPadding: UDim,
}

export type TabsMap = {
	Name: string,
	Icon: string,
	Component: any,
}

export type TabHeader = {
	Theme: Theme,
	LayoutSettings: LayoutSetting,
}

return Types
