local cmp = require('cmp')
local luasnip = require('luasnip')
local lspconfig = require('lspconfig')
local null_ls = require("null-ls")

local select_opts = { behavior = cmp.SelectBehavior.Select }

-- See :help cmp-config
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-j>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-k>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.scroll_docs(-4),
    ['<C-m>'] = cmp.mapping.scroll_docs(4),
    ['<C-b>'] = cmp.mapping.abort(),
  }),
})

local on_attach = function(_, bufnr)
  vim.api.nvim_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua require("telescope.builtin").lsp_references()<CR>',
    { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-e>', '<cmd>lua vim.diagnostic.open_float()<cr>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
end

vim.api.nvim_exec([[
  command! NoAutoFormat lua vim.lsp.buf_set_option('format_on_save', false)
]], false)

local lsp_defaults = {
  on_attach = on_attach,
}


lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    'clangd',
    'cssls',
    'gopls',
    'html',
    'jsonls',
    'lua_ls',
    'pyre',
    'solang',
    'svelte',
    'tsserver',
    'solargraph',
    'sorbet',
    'rubocop',
    'eslint'
  },
  handlers = {
    function(server)
      lspconfig[server].setup({})
    end,
  }
})

local lSsources = {
  null_ls.builtins.code_actions.eslint_d.with({
    filetypes = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
  }),
  null_ls.builtins.formatting.prettierd.with({
    filetypes = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "css",
      "scss",
      "html",
      "yaml",
      "markdown",
      "graphql",
      "md",
      "txt",
    },
  })
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = lSsources,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(cl)
              return cl.name == "null-ls"
            end,
          })
        end,
      })
    end
  end,
})
