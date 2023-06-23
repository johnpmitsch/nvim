vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>gd", vim.cmd.Gvdiffsplit);
vim.api.nvim_set_keymap('n', '<leader>gds', ':Gvdiffsplit --staged<CR>', {silent = true})
vim.keymap.set("n", "<leader>gr", vim.cmd.Gread);
vim.keymap.set("n", "<leader>gb", vim.cmd.GBrowse);
vim.api.nvim_set_keymap('n', '<leader>gl', ':GV<CR>', { silent = true })

