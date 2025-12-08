require("buf-jump").setup({
	-- Set to false to disable default keymaps
	-- Set to a table to customize them
	mappings = {
		list = "<leader>bj", -- Show buffer history
		back = "<C-y>", -- Go to previous buffer
		forward = "<C-n>", -- Go to next buffer
	},
})
