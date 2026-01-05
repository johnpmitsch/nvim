require("gitlinker").setup()

vim.api.nvim_set_keymap(
	"n",
	"<leader>gl",
	'<cmd>lua require"gitlinker".get_buf_range_url("n", {})<cr>',
	{ silent = true }
)
vim.api.nvim_set_keymap("v", "<leader>gl", '<cmd>lua require"gitlinker".get_buf_range_url("v", {})<cr>', {})
