local CommandService = {}

local CommandList = require("@self/CommandList")
local COMMAND_TREE: CommandList.CommandTree = CommandList

-- Reference command
--/snippet create (snippetName) (code).. -< .. as an ender
local function navigateTree(lineText: string, prefix: string): (CommandList.CommandNode?, { string }?, { string }?)
	local cleanText = lineText:gsub("%.%.$", "")

	local tokens: { string } = {}
	for commandPart in cleanText:gmatch("%S+") do
		table.insert(tokens, commandPart)
	end

	-- this is used to "search" for the next upcoming arg, if the last char is
	-- space then it means user are typing to type new token

	if not tokens[1] then
		return nil, {}, {}
	end
	local commandName = tokens[1]:sub(1 + #prefix)

	local currentNode: CommandList.CommandNode? = COMMAND_TREE[commandName]
	print("Initial Node Found for:", commandName, currentNode ~= nil)

	if not currentNode then
		return nil, {}, {}
	end

	local args: { string } = {}

	-- Only walk up to the SECOND to last token if we are currently typing a word
	-- If we just hit space, we walk all tokens.
	--local limit = if isTypingNewToken then #tokens else #tokens - 1

	local i = 2
	while i <= #tokens do
		local token = tokens[i]
		local matched = false
		if not currentNode.children then
			break
		end

		for _, child in currentNode.children do
			if child.type == "literal" and child.name == token then
				currentNode = child
				matched = true
				break
			elseif child.type == "argument" then
				-- if it's an argument and it's the LAST expected child,
				-- we consume ALL remaining tokens as the argument (for code blocks)
				if not child.children or #child.children == 0 then
					local remaining = {}
					for j = i, #tokens do
						table.insert(remaining, tokens[j])
					end
					table.insert(args, table.concat(remaining, " "))
					currentNode = child
					i = #tokens -- End loop
				else
					table.insert(args, token)
					currentNode = child
				end
				matched = true
				break
			end
		end

		if not matched then
			break
		end
		i += 1
	end

	return currentNode, args, tokens
end

function CommandService.GetSuggestions(lineText: string, prefix: string) --: (CommandList.CommandTree, boolean)
	local node, _, tokens = navigateTree(lineText, prefix)
	local hasEnder = lineText:match("%.%.$") ~= nil

	--if there is no token at all then show the root level command (snippet, etc)
	if #tokens == 0 then
		return COMMAND_TREE, true
	end

	-- if navigateTree didn't find the command or we are at a leaf node
	if hasEnder then
		print("has ender")
		return { { name = "Executing...", type = "literal" } }, false
	end

	if not node or not node.children then
		return {}, false
	end
	-- second return arg is basically if it returns the whole command tree or not

	local lastChar = lineText:sub(-1)
	local activeToken = if lastChar == " " then "" else tokens[#tokens]
	print("Filtering suggestions for activeToken:", "'" .. activeToken .. "'")

	-- if we are mid-word, only return children that start with that word
	local filtered = {}
	for _, child in node.children do
		-- If user typed 'c', show 'create'. If user hit space, show everything.
		if child.name:lower():sub(1, #activeToken) == activeToken:lower() and child.type == "literal" then
			table.insert(filtered, child)
		end
	end

	print("Suggestions returning count:", #filtered)
	return filtered, false
end

function CommandService.Parse(lineText: string, prefix: string): (CommandList.CommandNode?, { string }?, boolean?)
	local node, args, _ = navigateTree(lineText, prefix)

	if not node then
		return nil, nil, nil
	end

	local isComplete = node.handler ~= nil
	return node, args, isComplete
end

function CommandService.Execute(lineText: string, prefix: string)
	local node, args, isComplete = CommandService.Parse(lineText, prefix)
	-- if it's complete then it'll handle it, node will be the last children
	if not node or not isComplete then
		return false
	end

	if node.handler then
		node.handler(table.unpack(args)) -- unpack previous arg to use as a parameter
		return true
	end

	return false
end

return CommandService
