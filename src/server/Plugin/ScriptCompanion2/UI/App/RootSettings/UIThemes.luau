--!strict

--[[
    This file defines different color themes for the plugin UI
]]

local Types = require(script.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

local UIThemes: { [string]: Types.Theme } = {
	--// CTAColor stands for Call To Action (Anything that needs to catch the eye like important buttons or other small important things)

	Dark = {
		ViewBackgroundColor = Color3.fromRGB(30, 30, 30),
		PanelColor = Color3.fromRGB(40, 40, 40),
		TitlePanelColor = Color3.fromRGB(45, 45, 45),
		PanelSplitterColor = Color3.fromRGB(80, 80, 80),
		PanelSplitterHighlightColor = Color3.fromRGB(255, 255, 255),
		CTAColor = Color3.fromRGB(180, 180, 180),
		TextColor = Color3.fromRGB(178, 178, 178),
		HighlitTextColor = Color3.fromRGB(255, 255, 255),

		SnippetBackgroundColor = Color3.fromRGB(60, 60, 60),
		SnippetUnderBarColor = Color3.fromRGB(40, 40, 40),
		SnippetBaseButtonColor = Color3.fromRGB(80, 80, 80),
		SnippetTextColor = Color3.fromRGB(255, 255, 255),

		IconColor = Color3.fromRGB(150, 150, 150),
		HighlitIconColor = Color3.fromRGB(255, 255, 255),

		TerminalCommandColor = Color3.fromRGB(255, 255, 0),
		TerminalErrorColor = Color3.fromRGB(255, 0, 0),

		TabViewTexture = "rbxassetid://78061177885586",
		LeftPanelTexture = "",
	},

	Light = {
		ViewBackgroundColor = Color3.fromRGB(200, 200, 200),
		PanelColor = Color3.fromRGB(220, 220, 220),
		TitlePanelColor = Color3.fromRGB(230, 230, 230),
		PanelSplitterColor = Color3.fromRGB(80, 80, 80),
		PanelSplitterHighlightColor = Color3.fromRGB(255, 0, 0),
		CTAColor = Color3.fromRGB(70, 70, 70),
		TextColor = Color3.fromRGB(50, 50, 50),
		HighlitTextColor = Color3.fromRGB(0, 0, 0),

		SnippetBackgroundColor = Color3.fromRGB(60, 60, 60),
		SnippetUnderBarColor = Color3.fromRGB(40, 40, 40),
		SnippetBaseButtonColor = Color3.fromRGB(80, 80, 80),
		SnippetTextColor = Color3.fromRGB(255, 255, 255),

		IconColor = Color3.fromRGB(130, 130, 130),
		HighlitIconColor = Color3.fromRGB(90, 90, 90),

		TerminalCommandColor = Color3.fromRGB(0, 119, 255),
		TerminalErrorColor = Color3.fromRGB(255, 0, 0),

		TabViewTexture = "rbxassetid://78061177885586",
		LeftPanelTexture = "",
	},

	Blue = {
		ViewBackgroundColor = Color3.fromRGB(24, 31, 45),
		PanelColor = Color3.fromRGB(29, 36, 50),
		TitlePanelColor = Color3.fromRGB(40, 49, 65),
		PanelSplitterColor = Color3.fromRGB(59, 85, 109),
		PanelSplitterHighlightColor = Color3.fromRGB(0, 255, 234),
		--// Changed from: 88, 179, 231 (Blue) to: 210, 140, 15
		CTAColor = Color3.fromRGB(88, 179, 231),
		TextColor = Color3.fromRGB(178, 178, 178),
		HighlitTextColor = Color3.fromRGB(255, 255, 255),

		SnippetBackgroundColor = Color3.fromRGB(40, 49, 65),
		SnippetUnderBarColor = Color3.fromRGB(40, 49, 65),
		SnippetBaseButtonColor = Color3.fromRGB(80, 80, 80),
		SnippetTextColor = Color3.fromRGB(255, 255, 255),

		IconColor = Color3.fromRGB(150, 150, 150),
		HighlitIconColor = Color3.fromRGB(255, 255, 255),

		TerminalCommandColor = Color3.fromRGB(255, 255, 0),
		TerminalErrorColor = Color3.fromRGB(255, 0, 0),

		TabViewTexture = "rbxassetid://78061177885586",
		LeftPanelTexture = "",
	},

	Purple = {
		ViewBackgroundColor = Color3.fromRGB(30, 20, 30),
		PanelColor = Color3.fromRGB(40, 30, 40),
		TitlePanelColor = Color3.fromRGB(45, 35, 45),
		PanelSplitterColor = Color3.fromRGB(166, 75, 179),
		PanelSplitterHighlightColor = Color3.fromRGB(255, 255, 255),
		CTAColor = Color3.fromRGB(202, 32, 188),
		TextColor = Color3.fromRGB(178, 178, 178),
		HighlitTextColor = Color3.fromRGB(255, 255, 255),

		SnippetBackgroundColor = Color3.fromRGB(50, 35, 50),
		SnippetUnderBarColor = Color3.fromRGB(40, 30, 40),
		SnippetBaseButtonColor = Color3.fromRGB(80, 80, 80),
		SnippetTextColor = Color3.fromRGB(255, 255, 255),

		IconColor = Color3.fromRGB(150, 150, 150),
		HighlitIconColor = Color3.fromRGB(255, 255, 255),

		TerminalCommandColor = Color3.fromRGB(255, 255, 0),
		TerminalErrorColor = Color3.fromRGB(255, 0, 0),

		TabViewTexture = "rbxassetid://78061177885586",
		LeftPanelTexture = "",
	},

	Orange = {
		ViewBackgroundColor = Color3.fromRGB(114, 85, 44),
		PanelColor = Color3.fromRGB(126, 102, 55),
		TitlePanelColor = Color3.fromRGB(148, 119, 62),
		PanelSplitterColor = Color3.fromRGB(199, 153, 60),
		PanelSplitterHighlightColor = Color3.fromRGB(255, 230, 0),
		CTAColor = Color3.fromRGB(255, 114, 49),
		TextColor = Color3.fromRGB(178, 178, 178),
		HighlitTextColor = Color3.fromRGB(255, 255, 255),

		SnippetBackgroundColor = Color3.fromRGB(153, 117, 66),
		SnippetUnderBarColor = Color3.fromRGB(117, 86, 43),
		SnippetBaseButtonColor = Color3.fromRGB(80, 80, 80),
		SnippetTextColor = Color3.fromRGB(255, 255, 255),

		IconColor = Color3.fromRGB(150, 150, 150),
		HighlitIconColor = Color3.fromRGB(255, 255, 255),

		TerminalCommandColor = Color3.fromRGB(255, 255, 0),
		TerminalErrorColor = Color3.fromRGB(255, 0, 0),

		TabViewTexture = "rbxassetid://78061177885586",
		LeftPanelTexture = "",
	},
}

return UIThemes
