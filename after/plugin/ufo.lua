vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zA", require("ufo").openAllFolds)
vim.keymap.set("n", "zZ", require("ufo").closeAllFolds)

require("ufo").setup()
