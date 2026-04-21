--!strict

local Types = require(script.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

--// Tab Header Components
local DatastoreHeader = require(script.Parent.Parent.Components.Headers.DatastoreHeader)
local PatternVisualizerHeader = require(script.Parent.Parent.Components.Headers.PatternVisualizerHeader)
local SettingsHeader = require(script.Parent.Parent.Components.Headers.SettingsHeader)
local SnippetsHeader = require(script.Parent.Parent.Components.Headers.SnippetsHeader)
local TypesHeader = require(script.Parent.Parent.Components.Headers.TypesHeader)
local UIImporterHeader = require(script.Parent.Parent.Components.Headers.UIImporterHeader)

--// Tab Components
local DatastoreTab = require(script.Parent.Parent.Components.Tabs.DatastoreTab)
local PatternVisualizerTab = require(script.Parent.Parent.Components.Tabs.PatternVisualizerTab)
local SettingsTab = require(script.Parent.Parent.Components.Tabs.SettingsTab)
local SnippetsTab = require(script.Parent.Parent.Components.Tabs.SnippetsTab)
local TypesTab = require(script.Parent.Parent.Components.Tabs.TypesTab)
local UIImporterTab = require(script.Parent.Parent.Components.Tabs.UIImporterTab)

--// Defines all tabs used for creating buttons in LeftPanel
local tabs: { Types.TabsMap } = {
	{ Name = "Snippets", Icon = "rbxassetid://135583613172881", Header = SnippetsHeader, Component = SnippetsTab },
	{ Name = "Types", Icon = "rbxassetid://94762309414742", Header = TypesHeader, Component = TypesTab },
	{ Name = "DS Viewer", Icon = "rbxassetid://103038958831820", Header = DatastoreHeader, Component = DatastoreTab },
	{
		Name = "Pattern Matcher",
		Icon = "rbxassetid://70754597001642",
		Header = PatternVisualizerHeader,
		Component = PatternVisualizerTab,
	},
	{ Name = "UI Importer", Icon = "", Header = UIImporterHeader, Component = UIImporterTab },
	{ Name = "Settings", Icon = "rbxassetid://116420219450585", Header = SettingsHeader, Component = SettingsTab },
}

return tabs
