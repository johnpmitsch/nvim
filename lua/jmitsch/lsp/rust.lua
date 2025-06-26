local M = {}

function M.setup()
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
				end,
			},
		}
	end
end

return M