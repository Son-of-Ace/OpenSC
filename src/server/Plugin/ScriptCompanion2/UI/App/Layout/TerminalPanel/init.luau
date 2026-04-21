--!strict

local TextService = game:GetService("TextService")

local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local e = React.createElement

local UserInfoService = require(script.Parent.Parent.Parent.Parent.Services.UserInfoService)
local Types = require(script.Parent.Parent.Parent.Parent.Utils.TypeUtils.Types)

local CustomScrollFrame = require(script.Parent.Parent.Components.Utility.CustomScrollFrame)
local DragableSplitter = require(script.Parent.Parent.Components.Utility.DragableSplitter)

local Settings = require(script.TerminalSettings)
local TerminalCommands = require(script.TerminalCommands)

local function TerminalPanel(props: Props)
	local theme = props.Theme
	local layoutSettings = props.LayoutSettings

	local cmdColor = theme.TerminalCommandColor
	local errorColor = theme.TerminalErrorColor

	local history, setHistory = React.useState({} :: { string })
	local inputText, setInputText = React.useState("")

	local inputRef = React.useRef(nil :: TextBox?)

	local textFont = Settings.TextFont
	local textSize = Settings.TextSize

	local devName = UserInfoService.GetDeveloperName()
	local fullPrefix = `{devName}\\> `

	local function ToHex(color: Color3)
		return string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
	end

	local function StripTags(text: string)
		return text:gsub("<[^>]*>", "")
	end

	local function ProcessCommand(rawInput: string)
		local parts = {}
		for char in string.gmatch(rawInput, "%S+") do
			table.insert(parts, char)
		end

		if #parts == 0 then
			setHistory(function(old)
				local newHistory = { table.unpack(old) }
				table.insert(newHistory, fullPrefix)
				return newHistory
			end)
			return
		end

		local command = table.remove(parts, 1)
		if not command then
			return
		end
		command = command:lower()
		local args = parts

		local foundCommand: TerminalCommands.CmdDef? = nil
		for _, cmd in TerminalCommands do
			if table.find(cmd.Aliases, command) then
				foundCommand = cmd
				break
			end
		end

		local response: string? = nil

		if foundCommand then
			response = foundCommand.Execute({
				Args = args,
				SetHistory = setHistory,
			})
		else
			response = `<font color="{ToHex(errorColor)}">Unknown command: {command}</font>`
		end

		if response ~= nil or not table.find({ "clear", "cls" }, command) then
			setHistory(function(old)
				local newHistory = { table.unpack(old) }
				table.insert(newHistory, `{fullPrefix}{rawInput}`)
				if response then
					table.insert(newHistory, response)
				end
				return newHistory
			end)
		end
	end

	local function HighlightCommand(rawText: string)
		if rawText == "" then
			return ""
		end

		local processed = rawText:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

		processed = processed:gsub("^(%s*)(%S+)", function(...: string): string
			local args = { ... }
			local spaces = args[1]
			local cmd = args[2]
			return `{spaces}<font color="{ToHex(cmdColor)}">{cmd}</font>`
		end)

		return processed
	end

	local plainBuffer = ""
	local richBuffer = ""

	local function CleanHistory()
		for _, line in history do
			plainBuffer ..= StripTags(line) .. "\n"
			if line:sub(1, #fullPrefix) == fullPrefix then
				richBuffer ..= `<font color="{ToHex(theme.HighlitTextColor)}">{fullPrefix}</font>` .. HighlightCommand(
					line:sub(#fullPrefix + 1)
				) .. "\n"
			else
				richBuffer ..= line .. "\n"
			end
		end
	end

	CleanHistory()

	local readOnlyLength = #plainBuffer + #fullPrefix
	local finalPlain = plainBuffer .. fullPrefix .. inputText
	local finalRich = richBuffer
		.. `<font color="{ToHex(theme.HighlitTextColor)}">{fullPrefix}</font>`
		.. HighlightCommand(inputText)

	--// Building the TerminalPanel UI
	return e("Frame", {
		Size = UDim2.new(1, -props.LeftPanelSize - 2, 0, props.TerminalPanelSize),
		Position = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = theme.PanelColor,
		BorderSizePixel = 0,
	}, {
		TerminalFrame = e("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		}, {
			TopBar = e("Frame", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundTransparency = 1,
			}, {
				Layout = e("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),

				Padding = e("UIPadding", {
					PaddingLeft = UDim.new(0, 10),
				}),

				TerminalButton = e("TextButton", {
					Size = UDim2.fromOffset(60, 30),
					Text = "TERMINAL",
					TextColor3 = theme.HighlitTextColor,
					BackgroundTransparency = 1,
					TextScaled = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
				}, {
					UnderLine = e("Frame", {
						Size = UDim2.new(1, 0, 0, 1),
						AnchorPoint = Vector2.new(0, 1),
						Position = UDim2.fromScale(0, 1),
						BackgroundColor3 = theme.CTAColor,
						BorderSizePixel = 0,
					}),
				}),
			}),

			TextView = e(CustomScrollFrame, {
				Theme = theme,
				ScrollSpeed = 9,
				ScrollType = "Smooth",
				Size = UDim2.new(1, -10, 1, -50),
				Position = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(1, 1),
				Children = (function()
					local children = {}

					children[#children + 1] = e("Frame", {
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
					}, {
						DisplayLabel = e("TextLabel", {
							Size = UDim2.fromScale(1, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							Text = finalRich,
							RichText = true,
							BackgroundTransparency = 1,
							TextColor3 = theme.HighlitTextColor,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							TextSize = textSize,
							Font = textFont,
							TextWrapped = true,
							ZIndex = 3,
						}),

						Textbox = e("TextBox", {
							ref = inputRef,
							Size = UDim2.fromScale(1, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							Text = finalPlain,
							BackgroundTransparency = 1,
							TextTransparency = 0,
							TextColor3 = theme.HighlitTextColor,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Top,
							TextSize = textSize,
							Font = textFont,
							ClearTextOnFocus = false,
							MultiLine = true,
							TextWrapped = true,
							ZIndex = 1,

							[React.Change.Text] = function(rbx: TextBox)
								local currentText = rbx.Text

								if currentText:find("\n$") then
									ProcessCommand(inputText)
									setInputText("")

									task.spawn(function()
										task.wait(0.01)
										rbx.CursorPosition = #rbx.Text + 1
									end)
									return
								end

								if
									#currentText < readOnlyLength
									or currentText:sub(1, #plainBuffer + #fullPrefix) ~= (plainBuffer .. fullPrefix)
								then
									rbx.Text = finalPlain
									rbx.CursorPosition = #finalPlain + 1
								else
									setInputText(currentText:sub(readOnlyLength + 1))
								end
							end,
						}),
					})
					return children
				end)(),
			}),
		}),

		Splitter = e(DragableSplitter, {
			Direction = "Vertical",
			Anchor = "Top",
			CurrentSize = props.TerminalPanelSize,
			MinSize = layoutSettings.MinTerminalPanelSize,
			MaxSize = props.MaxAvailableSize.Y,
			OnSizeChanged = props.SetTerminalPanelSize,
			HitboxWidth = Settings.DragHitboxSize,
			SplitterSize = Settings.SplitterSize,
			Theme = theme,
			SnapPoints = { props.MaxAvailableSize.Y },
		}),
	})
end

type Props = {
	Theme: Types.Theme,
	MaxAvailableSize: Vector2,
	LayoutSettings: Types.LayoutSetting,
	TerminalPanelSize: number,
	LeftPanelSize: number,
	SetTerminalPanelSize: (number) -> (),
}

return TerminalPanel
