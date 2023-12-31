local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
--if not vim.loop.fs_stat(lazypath) then
--  vim.fn.system({
--    "git",
--    "clone",
--    "--filter=blob:none",
--    "https://github.com/folke/lazy.nvim.git",
--    "--branch=stable", -- latest stable release
--    lazypath,
--  })
--end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct


-- Plugins configuration
local plugins = {
  'nvim-lua/plenary.nvim',
  "keyvchan/telescope-find-pickers.nvim",
  "MunifTanjim/nui.nvim",

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      "keyvchan/telescope-find-pickers.nvim"
    }
  },

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },

  -- Other plugins
  'mbbill/undotree',
  "junegunn/gv.vim",
  "tpope/vim-rhubarb",
  "zbirenbaum/copilot.lua",
  "folke/tokyonight.nvim",
  'folke/flash.nvim',

  -- Registers
  {
    "tversteeg/registers.nvim",
    config = function() require("registers").setup() end,
  },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  },

  'tpope/vim-fugitive',
  'stevearc/oil.nvim',

  -- Spectre
  {
    'nvim-pack/nvim-spectre',
    requires = 'nvim-lua/plenary.nvim'
  },

  "beauwilliams/focus.nvim",

  -- Mason
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'L3MON4D3/LuaSnip'
  },

  -- null-ls
  {
    'jose-elias-alvarez/null-ls.nvim',
    requires = 'nvim-lua/plenary.nvim'
  },

  "numToStr/FTerm.nvim",
  'jinh0/eyeliner.nvim',

  -- Uncomment if needed
  -- {
  --   "m4xshen/hardtime.nvim",
  --   requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" }
  -- }
}

require("lazy").setup(plugins)
