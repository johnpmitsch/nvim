-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use({ 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' } })
  use 'ThePrimeagen/harpoon'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      { -- Optional
        'williamboman/mason.nvim',
        run = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' }, -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' }, -- Required
      use {
        "tversteeg/registers.nvim",
        config = function()
          require("registers").setup()
        end,
      }
    }
  }
  use "junegunn/gv.vim"
  use "tpope/vim-rhubarb"
  use "zbirenbaum/copilot.lua"
  use "navarasu/onedark.nvim"
  use {
    "ggandor/leap.nvim",
    requires = {
      use {
        'ggandor/flit.nvim',
        conig = function()
          require("flit").setup()
        end,
      }
    }
  }
  use 'jose-elias-alvarez/null-ls.nvim'
  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use {
    'stevearc/oil.nvim',
    config = function() require('oil').setup() end
  }
end)
