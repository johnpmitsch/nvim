local flash = require("flash")

flash.setup({
  modes = {
    char = {
      enabled = false,
    }
  }
})

local forwardSearch = function()
  flash.jump({
    search = { forward = true, wrap = false, multi_window = true },
  })
end

local backwardSearch = function()
  flash.jump({
    search = {
      forward = false,
      wrap = false,
      multi_window = true,
    },
  })
end

local lineJump = function()
  flash.jump({
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = "^"
  })
end

local treesitter = function()
  flash.treesitter()
end

vim.keymap.set("n", "s", forwardSearch)
vim.keymap.set("x", "s", forwardSearch)
vim.keymap.set("o", "s", forwardSearch)

vim.keymap.set("n", "S", backwardSearch)
vim.keymap.set("x", "S", backwardSearch)
vim.keymap.set("o", "S", backwardSearch)

vim.keymap.set("n", "z", lineJump)
vim.keymap.set("x", "z", lineJump)
vim.keymap.set("o", "z", lineJump)

vim.keymap.set("n", "T", treesitter)
vim.keymap.set("x", "T", treesitter)
vim.keymap.set("o", "T", treesitter)
