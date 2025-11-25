--vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.foldmethod = "expr"

-- :h vim.treesitter.foldexpr()
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- ref: https://github.com/neovim/neovim/pull/20750
vim.opt.foldtext = ""
vim.opt.fillchars:append("fold: ")

-- Open all folds by default, zm is not available
vim.opt.foldlevelstart = 99

vim.keymap.set("n", "zO", require("ufo").openAllFolds)
vim.keymap.set("n", "zC", require("ufo").closeAllFolds)
vim.keymap.set("n", "zo", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zC", require("ufo").closeFoldsWith)

require("ufo").setup()
