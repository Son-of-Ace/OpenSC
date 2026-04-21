local AutoCompleteHandler = {}

local CommandService = require(script.Parent.CommandService)
local PathService = require(script.Parent.PathService)
local ServiceProvider = require(script.Parent.Parent.Utils.ServiceProvider)
local ModuleLogger = require(script.Parent.ModuleLogger)
local SnippetService = require(script.Parent.SnippetService)

-- Constants
local DEFAULT_PREFIXES: {[PrefixesKind]: string} = {
	path = ":", 
	relative = "::", 
	snippet = ":", 
	command = "/",
}
-- Types
export type LogicResult = {
	label: string,
	code: string, -- the autocomplete
	mode: "Module" | "Service" | "Snippet" | "Command",
	isCommand: boolean?,
	snippetData: { Name: string, Code: string }? 
}

type PrefixesKind = "path" | "relative" | "snippet" | "command"

type CompletionItem = {
	label: string,
	kind: Enum.CompletionItemKind,
	insertText: string,
	documentation: { value: string },
	textEdit: {
		newText: string,
		replace: {
			start: { line: number, character: number },
			["end"]: { line: number, character: number },
		},
	},
}

type Request = {
	position: { line: number, character: number },
	textDocument: { document: any, script: LuaSourceContainer },
}

type Response = { items: { CompletionItem } }

type SnippetInfo = {
	ID: string,
	Name: string,
	Code: string,
	Description: string,
}

-- This is determine a specific item that should show up in the intellisense (search bar)
local function MatchesSearch(name: string?, searchText: string?): boolean
	if not name or not searchText or searchText == "" then return true end
	-- 1 -> start at index one, true -> requires exact match instead of pattern
	return string.find(string.lower(name), string.lower(searchText), 1, true) ~= nil
end

-- This is used to detect if a line in the text has a prefix
-- prefixMap is something like (prefixType -> prefix itself)
local function DetectPrefix(lineText: string, prefixMap: {[PrefixesKind]: string}): (string?, PrefixesKind?)
	local bestSymbol, bestKind: PrefixesKind? = nil, nil
	local maxLen = -1

	--  The main logic here is to prioritize prefix with the highest length that is in the line
	for kind: PrefixesKind, symbol in prefixMap do
		if #symbol <= maxLen then continue end -- Early exit if it is shorter than our "best" prefix

		-- for ex if you write ";stuff" (first line is not the prefix (:) but s, so return false for that kind)
		if lineText:sub(1, #symbol) ~= symbol then continue end

		maxLen = #symbol
		bestSymbol = symbol
		bestKind = kind
	end
	return bestSymbol, bestKind
end

-- This is where the magic happen, there are 4 main modes
-- Module, Service, Snippet, and Command
local function CreateCompletionItem(
	label: string,
	newText: string, -- This is a path to the stuff
	cursorLine: number,
	prefix: string,
	searchText: string,
	mode: "Module" | "Service" | "Snippet" | "Command"
): CompletionItem

	local finalizedText = newText

	-- If it's a command, it's currently a comment, so the replacement must include --
	if mode == "Command" then
        finalizedText = "--" .. prefix .. newText
    end

	return {
		label = label,
		kind = if mode == "Service" then Enum.CompletionItemKind.Class
			elseif mode == "Module" then Enum.CompletionItemKind.Module
			else Enum.CompletionItemKind.Snippet,
		insertText = label,
		documentation = {value = `{mode}: {label} | Path: {newText}`},
		textEdit = {
			newText = finalizedText, 
			replace = {
				["start"] = { line = cursorLine, character = 1 },
				["end"] = { line = cursorLine, character = 1000 }, 
			}, -- replace that line with finalized text -> (1 - 1000)
		},
	}
end

local PrefixLogic = {
	-- searchText -> basically lineText wo prefix
	["snippet"] = function(request: Request, searchText: string, plugin: Plugin): {LogicResult}
		local items: {LogicResult} = {}
		local savedSnippets = SnippetService.GetAllSnippets() :: {[string]: SnippetInfo}

		for id, info in savedSnippets do
			if type(info) ~= "table" then continue end

			local name: string = if type(info.Name) == "string" then info.Name else tostring(id)
			if not MatchesSearch(name, searchText) then continue end

			local codeText: string = if type(info.Code) == "string" then info.Code else ""

			local result: LogicResult = {
				label = name, 
				code = codeText, 
				mode = "Snippet"
			}
			table.insert(items, result)
		end
		return items
	end,

	["command"] = function(request: Request, searchText: string, plugin: Plugin): {LogicResult}
		local items: {LogicResult} = {}
		local suggestions, isRoot = CommandService.GetSuggestions("/" .. searchText, "/")

		-- We check if the user just typed ".."
		local isFinisher = searchText:match("%.%.$") ~= nil
		if isFinisher then
			print("command finished")
		end

		for _, node in suggestions do
			table.insert(items, {
				label = node.name,
				code = if isRoot then node.name else `{searchText:gsub("%S+$", "")}{node.name}`,
				mode = "Command",
				isCommand = true,
			})
		end
		return items
	end,

	["path"] = function(request: Request, searchText: string): {LogicResult}
		local items: {LogicResult} = {}

		for _, serviceName in ServiceProvider.GetAllNames() do
			if not MatchesSearch(serviceName, searchText) then continue end
			table.insert(items, {
				label = serviceName, 
				code = `local {serviceName} = game:GetService("{serviceName}")`, 
				mode = "Service"
			} :: LogicResult)
		end

		local currentScript = request.textDocument.script :: ModuleScript
		for module, info in ModuleLogger.GetAllModules() do
			if module == currentScript then continue end
			if not MatchesSearch(info.Name, searchText) then continue end

			local code = `local {info.Name} = require({PathService.GetRequirePath(currentScript, module)})`
			table.insert(items, {label = info.Name, code = code, mode = "Module"} :: LogicResult)
		end

		return items
	end,

	["relative"] = function(request: Request, searchText: string): {LogicResult}
		local items: {LogicResult} = {}
		local currentScript = request.textDocument.script
		local root = PathService.GetRootService(currentScript)

		for module, info in ModuleLogger.GetAllModules() do
			if module == currentScript or not module:IsDescendantOf(root) then continue end
			if not MatchesSearch(info.Name, searchText) then continue end

			local code = `local {info.Name} = require("{PathService.GetRelativePath(currentScript, module)}")`
			table.insert(items, {label = info.Name, code = code, mode = "Module"} :: LogicResult)
		end

		return items
	end,
}

function AutoCompleteHandler.AutoCompleteCallback(request: Request, response: Response, plugin: Plugin): Response
	local doc = request.textDocument.document
	if not doc then return response end

	local cursorLine = request.position.line
	local lineText = doc:GetLine(cursorLine)
	if not lineText or lineText == "" then return response end

	local userPrefixes = plugin:GetSetting("PrefixSettings") or DEFAULT_PREFIXES
	local bestSymbol, bestKind = DetectPrefix(lineText, userPrefixes)

	-- if we see a prefix but NO comment dashes, add them!
	if bestSymbol and not lineText:match("^%s*%-%-") then
		task.defer(function()
			--insert "--" at the very start of the line (character 1)
			doc:EditTextAsync("--", cursorLine, 1, cursorLine, 1)
		end)
		-- return empty for this frame so we don't glitch the UI while dashes are being added
		return { items = {} }
	end

	local effectiveText = lineText
	if lineText:match("^%s*%-%-") then
		effectiveText = lineText:gsub("^%s*%-%-", "")
	end

	bestSymbol, bestKind = DetectPrefix(effectiveText, userPrefixes)
    if not bestSymbol or not bestKind then return response end

	local searchText = effectiveText:sub(#bestSymbol + 1) or ""

	for kind, symbol in userPrefixes do
		if symbol ~= bestSymbol then continue end

		local logicFunc = PrefixLogic[kind]
		if not logicFunc then continue end

		local results: {LogicResult} = logicFunc(request, searchText, plugin)

		for _, data in results do
			-- Use effectiveText (no dashes) to check for dots
			-- We use %s* to ignore any accidental spaces before the dots
			if effectiveText:match("%.%.%s*$") then
				local currentLineNumber = cursorLine

				local cleanCmd = effectiveText:gsub("%.%.%s*$", "")
				print("Attempting Execution on:", cleanCmd)
				
				CommandService.Execute(cleanCmd, bestSymbol)
				
				-- Only clear the line if Execute worked
				task.defer(function()
					-- Re-verify we are on the same line before clearing
					doc:EditTextAsync("", currentLineNumber, 1, currentLineNumber, 1000)
				end)

				return { items = {} } 
			end

			table.insert(response.items, CreateCompletionItem(
				data.label, 
				data.code, 
				cursorLine, 
				bestSymbol, 
				searchText, 
				data.mode
			))
		end
	end

	return response
end

return AutoCompleteHandler