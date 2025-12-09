local M = {}

local function get_eslint_root_dir()
	local util = require("lspconfig.util")

	-- Define ESLint config files directly as flat list
	-- Bypasses buggy util.insert_package_json() call
	local root_files = {
		".eslintrc",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc.json",
		"package.json",
	}

	return util.root_pattern(unpack(root_files))
end

M.server_config = {
	eslint = {
		root_dir = get_eslint_root_dir(),
		settings = {
			packageManager = nil, -- Auto-detect from lock files
			experimental = {
				useFlatConfig = false, -- Using legacy .eslintrc format
			},
			format = false, -- Disable ESLint formatting - let Prettier handle it
			run = "onType", -- Real-time diagnostics
			codeAction = {
				disableRuleComment = {
					enable = true,
					location = "separateLine",
				},
				showDocumentation = {
					enable = true,
				},
			},
			quiet = false,
			onIgnoredFiles = "off",
		},
		on_attach = function(client, bufnr)
			-- Disable formatting to prevent conflicts with Prettier
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
	},
}

function M.setup()
	-- Auto-fix ESLint issues on save
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", "*.mjs", "*.cjs" },
		callback = function(event)
			local clients = vim.lsp.get_clients({ bufnr = event.buf, name = "eslint" })
			if #clients > 0 then
				vim.schedule(function()
					pcall(vim.cmd, "EslintFixAll")
				end)
			end
		end,
		desc = "ESLint: Auto-fix on save",
	})
end

return M
