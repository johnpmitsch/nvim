local cmp = require("cmp")
local luasnip = require("luasnip")
local lspconfig = require("lspconfig")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself.
		--
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

		-- Find references for the word under your cursor.
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

		-- Jump to the implementation of the word under your cursor.
		--  Useful when your language has ways of declaring types without an actual implementation.
		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

		-- Jump to the type of the word under your cursor.
		--  Useful when you're not sure what type a variable is and you want to see
		--  the definition of its *type*, not where it was *defined*.
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		-- Rename the variable under your cursor.
		--  Most Language Servers support renaming across files, etc.
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("<C-e>", vim.diagnostic.open_float, "Open Float")

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
-- Add ufo folding capabilities
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local ruby_path = ""

local home = os.getenv("HOME")
-- For RVM
if vim.fn.isdirectory(home .. "/.rbenv/bin") == 1 then
	ruby_path = home .. "/.rbenv/bin"
-- For rbenv
elseif vim.fn.isdirectory(home .. "/.rbenv/shims") == 1 then
	ruby_path = home .. "/.rbenv/shims"
end

local function add_ruby_deps_command(client, bufnr)
	vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
		local params = vim.lsp.util.make_text_document_params()
		local showAll = opts.args == "all"

		client.request("rubyLsp/workspace/dependencies", params, function(error, result)
			if error then
				print("Error showing deps: " .. error)
				return
			end

			local qf_list = {}
			for _, item in ipairs(result) do
				if showAll or item.dependency then
					table.insert(qf_list, {
						text = string.format("%s (%s) - %s", item.name, item.version, item.dependency),
						filename = item.path,
					})
				end
			end

			vim.fn.setqflist(qf_list)
			vim.cmd("copen")
		end, bufnr)
	end, {
		nargs = "?",
		complete = function()
			return { "all" }
		end,
	})
end

local servers = {
	clangd = {},
	gopls = {},
	pyright = {},
	ruby_lsp = {
		on_attach = function(client, buffer)
			add_ruby_deps_command(client, buffer)
		end,
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
	--rust_analyzer = {},
	-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
	--
	-- Some languages (like typescript) have entire language plugins that can be useful:
	--    https://github.com/pmizio/typescript-tools.nvim
	--
	-- But for many setups, the LSP (`ts_ls`) will work just fine
	-- ts_ls = {},

	-- Set up Solargraph with the correct Ruby
	--solargraph = {
	--  cmd = { ruby_path .. "/solargraph", "stdio" },
	--  root_dir = function(fname)
	--    return require("lspconfig").util.root_pattern("Gemfile", ".git")(fname) or vim.fn.getcwd()
	--  end,
	--  settings = {
	--    solargraph = {
	--      diagnostics = true,
	--      completion = true,
	--      hover = true,
	--      formatting = false,
	--      useBundler = true,
	--      autoformat = false,
	--      symbols = true,
	--      definitions = true,
	--      references = true,
	--      rename = true
	--    }
	--  }
	--},
	--yamlls = {
	--	settings = {
	--		yaml = {
	--			filetypes_exclude = { "helm" },
	--			schemas = {
	--				["https://json.schemastore.org/kustomization"] = {
	--					"kustomization.yaml",
	--					"deploy.yaml",
	--					"base/*.yaml",
	--					"overlays/*.yaml",
	--				},
	--			},
	--		},
	--	},
	--},
	lua_ls = {
		-- cmd = {...},
		-- filetypes = { ...},
		-- capabilities = {},
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				-- diagnostics = { disable = { 'missing-fields' } },
			},
		},
	},
}

-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu.
require("mason").setup()

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
--
-- Also exclude rust_analyzer from ensure_installed if it's there
local ensure_installed = vim.tbl_keys(servers or {})
-- Remove rust_analyzer if it exists in the list
ensure_installed = vim.tbl_filter(function(server)
	return server ~= "rust_analyzer"
end, ensure_installed)

vim.list_extend(ensure_installed, {
	"stylua", -- Used to format Lua code
})
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}

			-- let rustaceanvim handle rust
			if server_name == "rust_analyzer" then
				return
			end
			-- This handles overriding only values explicitly passed
			-- by the server configuration above. Useful when disabling
			-- certain features of an LSP (for example, turning off formatting for ts_ls)
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		end,
	},
})

local select_opts = { behavior = cmp.SelectBehavior.Select }
local function filter(arr, fn)
	if type(arr) ~= "table" then
		return arr
	end

	local filtered = {}
	for k, v in pairs(arr) do
		if fn(v, k, arr) then
			table.insert(filtered, v)
		end
	end

	return filtered
end

local function filterReactDTS(value)
	return string.match(value.targetUri, "%.d.ts") == nil
end

-- See :help cmp-config
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "buffer" },
	}),
	preselect = cmp.PreselectMode.None,
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
		["<C-j>"] = cmp.mapping.select_next_item(select_opts),
		["<C-k>"] = cmp.mapping.select_prev_item(select_opts),
		["<C-n>"] = cmp.mapping.scroll_docs(-4),
		["<C-m>"] = cmp.mapping.scroll_docs(4),
		["<C-b>"] = cmp.mapping.abort(),
	}),
})

local on_attach = function(client, bufnr)
	vim.api.nvim_set_keymap("n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap(
		"n",
		"<leader>ca",
		"<Cmd>lua vim.lsp.buf.code_action()<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap(
		"n",
		"gr",
		'<Cmd>lua require("telescope.builtin").lsp_references()<CR>',
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-e>", "<cmd>lua vim.diagnostic.open_float()<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { noremap = true, silent = true })
end

vim.api.nvim_exec(
	[[
  command! NoAutoFormat lua vim.lsp.buf_set_option('format_on_save', false)
]],
	false
)

local lsp_defaults = {
	on_attach = on_attach,
}

lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

vim.g.rustaceanvim = function()
	return {
		server = {
			on_attach = function()
				-- Use RustLsp hover with actions (this is the correct way for Rust)
				vim.keymap.set("n", "K", function()
					vim.cmd.RustLsp({ "hover", "actions" })
				end, { noremap = true, silent = true })

				-- Rust-specific runnables
				vim.keymap.set("n", "<leader>rr", function()
					vim.cmd.RustLsp("runnables")
				end, { noremap = true, silent = true })

				-- Use RustLsp code actions (better than generic LSP for Rust)
				vim.keymap.set("n", "<leader>ca", function()
					vim.cmd.RustLsp("codeAction")
				end, { noremap = true, silent = true })

				-- Standard LSP mappings
				vim.api.nvim_set_keymap(
					"n",
					"<leader>rn",
					"<Cmd>lua vim.lsp.buf.rename()<CR>",
					{ noremap = true, silent = true }
				)
				vim.api.nvim_set_keymap(
					"n",
					"gd",
					"<Cmd>lua vim.lsp.buf.definition()<CR>",
					{ noremap = true, silent = true }
				)
				vim.api.nvim_set_keymap(
					"n",
					"gi",
					"<Cmd>lua vim.lsp.buf.implementation()<CR>",
					{ noremap = true, silent = true }
				)
				vim.api.nvim_set_keymap(
					"n",
					"gr",
					'<Cmd>lua require("telescope.builtin").lsp_references()<CR>',
					{ noremap = true, silent = true }
				)
				-- Diagnostic navigation
				vim.api.nvim_set_keymap(
					"n",
					"<C-e>",
					"<cmd>lua vim.diagnostic.open_float()<cr>",
					{ noremap = true, silent = true }
				)
				vim.api.nvim_set_keymap(
					"n",
					"[d",
					"<cmd>lua vim.diagnostic.goto_prev()<cr>",
					{ noremap = true, silent = true }
				)
				vim.api.nvim_set_keymap(
					"n",
					"]d",
					"<cmd>lua vim.diagnostic.goto_next()<cr>",
					{ noremap = true, silent = true }
				)
			end,
		},
	}
end

require("typescript-tools").setup({
	settings = {
		-- spawn additional tsserver instance to calculate diagnostics on it
		separate_diagnostic_server = true,
		-- "change"|"insert_leave" determine when the client asks the server about diagnostic
		publish_diagnostic_on = "insert_leave",
		-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
		-- "remove_unused_imports"|"organize_imports") -- or string "all"
		-- to include all supported code actions
		-- specify commands exposed as code_actions
		expose_as_code_action = {},
		-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
		-- not exists then standard path resolution strategy is applied
		tsserver_path = nil,
		-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
		-- (see 💅 `styled-components` support section)
		tsserver_plugins = {},
		-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
		-- memory limit in megabytes or "auto"(basically no limit)
		tsserver_max_memory = "auto",
		-- described below
		tsserver_format_options = {},
		tsserver_file_preferences = {},
		-- locale of all tsserver messages, supported locales you can find here:
		-- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
		tsserver_locale = "en",
		-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
		complete_function_calls = false,
		include_completions_with_insert_text = true,
		-- CodeLens
		-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
		-- possible values: ("off"|"all"|"implementations_only"|"references_only")
		code_lens = "off",
		-- by default code lenses are displayed on all referencable values and for some of you it can
		-- be too much this option reduce count of them by removing member references from lenses
		disable_member_code_lens = true,
		-- JSXCloseTag
		-- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
		-- that maybe have a conflict if enable this feature. )
		jsx_close_tag = {
			enable = false,
			filetypes = { "javascriptreact", "typescriptreact" },
		},
	},
})
--vim.lsp.set_log_level("debug")

-- I don't know why I need this specifically for ruby auto-formatting but it works
vim.cmd([[autocmd BufWritePre *.rb lua vim.lsp.buf.format()]])
