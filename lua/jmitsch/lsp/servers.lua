local servers = {
	clangd = {},
	gopls = {},
	pyright = {},
	ruff = {
		settings = {
			lineLength = 88,
		},
	},
	helm_ls = {
		settings = {
			["helm-ls"] = {
				yamlls = {
					path = "yaml-language-server",
				},
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
}

return servers
