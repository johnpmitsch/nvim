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
	ts_ls = {},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
				cargo = {
					allFeatures = true,
				},
				procMacro = {
					enable = true,
				},
				inlayHints = {
					enable = true,
					chainingHints = true,
					parameterHints = true,
					typeHints = true,
				},
			},
		},
	},
}

return servers
