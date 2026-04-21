--!strict

local React = require(script.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local Layout = require(script.Parent.Parent.App.Layout)

local TabsRegistry = require(script.Parent.Parent.App.RootSettings.TabsRegistry)
local LayoutSettings = require(script.Parent.Parent.App.Layout.LayoutSettings)
local CustomizationSettings = require(script.Parent.Parent.App.RootSettings.CustomizationSettings)
local UIThemes = require(script.Parent.Parent.App.RootSettings.UIThemes)

--// RootUI Is the entry point for the whole PluginUI. This calls main components and sends important parameters to them
local function RootUI()
	local themeName = CustomizationSettings.CurrentTheme
	local theme = UIThemes[themeName] or UIThemes.Blue

	return e(Layout, {
		Theme = theme,
		Settings = LayoutSettings,
		Tabs = TabsRegistry,
	})
end

return RootUI
