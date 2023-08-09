-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { "keyvchan/telescope-find-pickers.nvim" }
    }
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    { run = ':TSUpdate' }
  }
  use 'ThePrimeagen/harpoon'
  use 'mbbill/undotree'
  use "junegunn/gv.vim"
  use "tpope/vim-rhubarb"
  use "zbirenbaum/copilot.lua"
  use "navarasu/onedark.nvim"
  use 'folke/flash.nvim'
  use {'neoclide/coc.nvim', branch = 'release'}
  use {
    "tversteeg/registers.nvim",
    config = function()
      require("registers").setup()
    end,
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use 'tpope/vim-fugitive'
  use { 'stevearc/oil.nvim' }
  use {
    'nvim-pack/nvim-spectre',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use { "beauwilliams/focus.nvim", config = function()
    require("focus").setup()
  end }
end)
