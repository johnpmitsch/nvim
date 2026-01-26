local M = {}

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

M.server_config = {
	ruby_lsp = {
		on_attach = function(client, buffer)
			add_ruby_deps_command(client, buffer)
		end,
	},
}

function M.setup()
	-- Ruby formatting is handled by conform.nvim
	-- No additional autocommands needed
end

return M