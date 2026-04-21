export type CommandNode = {
	type: "literal" | "argument", -- value of argument is mutable
	name: string, -- name of that command
	argumentTypes: string?, -- only for argument nodes
	defaultValue: any?, -- if the user ignore or forget to fill in that value
	children: { CommandNode }?,
	handler: ((...any) -> ())?,
}

export type CommandTree = {
	[string]: CommandNode,
}

return {
	["snippet"] = {
		type = "literal",
		name = "snippet",

		children = {
			{
				type = "literal",
				name = "create",

				children = {
					{
						type = "argument",
						name = "snippetName",
						argumentType = "string",

						handler = function(snippetName: string, code: string)
							print("create", snippetName, code)
						end,
					},
				},
			},

			{
				type = "literal",
				name = "delete",

				children = {
					{
						type = "argument",
						name = "snippetName",
						argumentType = "string",

						handler = function(snippetName: string)
							print("delete", snippetName)
						end,
					},
				},
			},

			{
				type = "literal",
				name = "edit",

				children = {
					{
						type = "argument",
						name = "snippetName",
						argumentType = "string",

						children = {
							{
								type = "argument",
								name = "code",
								argumentType = "string",

								handler = function(snippetName: string, code: string)
									print("edit", snippetName, code)
								end,
							},
						},
					},
				},
			},

			{
				type = "literal",
				name = "favorite",

				children = {
					{
						type = "argument",
						name = "snippetName",
						argumentType = "string",

						handler = function(snippetName: string)
							print("favorite", snippetName)
						end,
					},
				},
			},
		},
	},
	["secret"] = {
		type = "literal",
		name = "secretCommand",
		children = {
			{
				type = "literal",
				name = "sosisenakya",
				handler = function()
					print("Easter egg triggered! sosisenakya is here :>")
				end,
			},
			{
				type = "literal",
				name = "sonoface",
				handler = function()
					print("I will make this script companion plugin paid!")
				end,
			},
		},
	},
} :: CommandTree
