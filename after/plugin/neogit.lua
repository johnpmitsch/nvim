local neogit = require('neogit')

vim.keymap.set("n", "<leader>gs", function() neogit.open() end);
