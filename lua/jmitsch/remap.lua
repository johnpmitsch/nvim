vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Dirbuf)

-- Move things around while highlighted
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in place with j
vim.keymap.set("n", "J", "mzJ`z")

-- half-page jumping
vim.keymap.set("n", "<C-n>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep cursor in the middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux new: tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- find and replace word in cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<space>x', vim.diagnostic.open_float)

vim.api.nvim_set_keymap('n', '<C-f>', ':q<CR>', {silent = true})
vim.keymap.set("n", '<C-q>', '<C-f>')

-- move window left and right
vim.api.nvim_set_keymap('n', '<leader>h', ':wincmd h<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>l', ':wincmd l<CR>', {silent = true})

