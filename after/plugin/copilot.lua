require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<C-]>",
      accept_word = false,
      accept_line = false,
      next = "<Nop>",
      prev = "<Nop>",
      dismiss = "<Nop>",
    },
  },
  panel = { enabled = false },
})
