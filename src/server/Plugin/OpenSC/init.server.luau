--!strict
--[[
	This is the ServerScript EntryPoint for the plugin. It handles setting up the plugin widget and distributing it to any Services that might need it.
	It also calls any .Init functions that need to be ran upon startup.
]]

-- Cache all services
local ServiceProvider = require(script.Utils.ServiceProvider)

--// Services
local ScriptEditorService = ServiceProvider.Request("ScriptEditorService")
local RunService = ServiceProvider.Request("RunService")

--// If game is running, do not Init anything.
if RunService:IsRunning() then
	return
end

--// Requires
local AutoCompleteService = require(script.Services.AutoCompleteService)
local ModuleLogger = require(script.Services.ModuleLogger)
local SnippetService = require(script.Services.SnippetService)

local MountUI = require(script.UI.Startup.MountUI)

--// Constants
local PLUGIN_NAME: string = "OpenSC"
local AUTOCOMPLETE_PRIORITY: number = 1

--// Plugin Setup
local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 1200, 800)
local widget = plugin:CreateDockWidgetPluginGuiAsync(PLUGIN_NAME, widgetInfo)
--// This ensures ZIndex acts correctly (IDFK why it works, but I found it on some random ass forum and it fixed all the issues!!)
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
widget.Title = PLUGIN_NAME

local toolbar = plugin:CreateToolbar(PLUGIN_NAME)
local toggleButton = toolbar:CreateButton(PLUGIN_NAME, "Toggle OpenSC", "")

--// Widget UI
toggleButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

--// Init all modules
ModuleLogger.Init()
SnippetService.Init(plugin)
MountUI(widget)

--// Allow input capture while Widget is in focus
plugin:Activate(true)

--// Safely Register AutoCompleteCallback
pcall(function()
	ScriptEditorService:DeregisterAutocompleteCallback(PLUGIN_NAME)
end)

ScriptEditorService:RegisterAutocompleteCallback(PLUGIN_NAME, AUTOCOMPLETE_PRIORITY, function(request, response)
	return AutoCompleteService.AutoCompleteCallback(request, response, plugin)
end)
