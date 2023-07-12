local telescope = require("telescope")
local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

telescope.load_extension('find_pickers')
telescope.setup {
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    }
  },
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = function(bufnr)
          actions.smart_send_to_qflist(bufnr)
          builtin.quickfix()
        end,
      }
    }
  },
}

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set("n", "<leader><leader>", telescope.extensions.find_pickers.find_pickers)
vim.keymap.set('n', '<leader>pf', builtin.git_files, {})
vim.keymap.set('n', '<leader>pq', builtin.quickfix, {})
vim.keymap.set('n', '<leader>cq', '<cmd>cex []<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>po', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>pl', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
