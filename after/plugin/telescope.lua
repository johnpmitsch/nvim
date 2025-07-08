local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local project_actions = require("telescope._extensions.project.actions")

telescope.load_extension("find_pickers")
telescope.load_extension("project")

telescope.setup({
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
		oldfiles = {
			cwd_only = true,
		},
	},
	defaults = {
		path_display = { "truncate" },
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = function(bufnr)
					actions.smart_send_to_qflist(bufnr)
					builtin.quickfix()
				end,
			},
		},
	},
	extensions = {
		project = {
			base_dirs = {
				{ "~/qn/", max_depth = 1 },
			},
			hidden_files = false,
			theme = "dropdown",
			order_by = "asc",
			search_by = "title",
			sync_with_nvim_tree = true,
			on_project_selected = function(prompt_bufnr)
				local project_path = require("telescope.actions.state").get_selected_entry(prompt_bufnr).value
				require("telescope.actions").close(prompt_bufnr)
				require("telescope._extensions.project.utils").change_project_dir(project_path, "lcd")
				vim.schedule(function()
					require("telescope.builtin").oldfiles({ cwd_only = true })
				end)
			end,
		},
	},
})

vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<C-f>", builtin.live_grep, {})
vim.keymap.set("n", "<leader><leader>", telescope.extensions.find_pickers.find_pickers)
vim.keymap.set("n", "<leader>pf", builtin.git_files, {})
vim.keymap.set("n", "<leader>pq", builtin.quickfix, {})
vim.keymap.set("n", "<leader>d", builtin.diagnostics, {})
vim.keymap.set("n", "<leader>cq", "<cmd>cex []<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>po", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
vim.keymap.set("n", "<leader>r", builtin.registers, {})
vim.keymap.set("n", "<leader>pp", ":lua require'telescope'.extensions.project.project{}<CR>", {})
-- vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
