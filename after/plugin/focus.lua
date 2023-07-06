vim.api.nvim_set_keymap('n', '<c-w>', ':FocusSplitNicely<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<C-u>', ':wincmd k<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-d>', ':wincmd j<CR>', { noremap = true, silent = true })

