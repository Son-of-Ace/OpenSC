--!strict

--[[
    This file is for defining new commands for the terminal
]]

export type CmdContext = {
	Args: { string },
	SetHistory: (({ string }) -> { string }) -> (),
}

export type CmdDef = {
	Aliases: { string },
	Execute: (ctx: CmdContext) -> string?,
}

local commands: { CmdDef } = {
	{
		Aliases = { "clear", "cls" },
		Execute = function(ctx)
			ctx.SetHistory(function()
				return {}
			end)
			return nil
		end,
	},
	{
		Aliases = { "help", "hlp", "?" },
		Execute = function(ctx)
			return "Available commands: clear, help"
		end,
	},
}

return commands
