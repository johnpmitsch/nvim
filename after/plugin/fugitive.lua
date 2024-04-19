vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>gr", vim.cmd.Gread);
vim.keymap.set("n", "<leader>gb", vim.cmd.GBrowse);
vim.api.nvim_command(
  "command! -nargs=1 Browse lua vim.cmd('silent !open ' .. vim.fn.shellescape(vim.fn.expand('<args>'), 1))")
