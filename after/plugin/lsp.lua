local cmp = require('cmp')
local luasnip = require('luasnip')
local lspconfig = require('lspconfig')
local null_ls = require("null-ls")
local lsp_status = require('lsp-status')

local select_opts = { behavior = cmp.SelectBehavior.Select }
local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function filterReactDTS(value)
  return string.match(value.targetUri, '%.d.ts') == nil
end


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
  preselect = cmp.PreselectMode.None,
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
    ['<C-j>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-k>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.scroll_docs(-4),
    ['<C-m>'] = cmp.mapping.scroll_docs(4),
    ['<C-b>'] = cmp.mapping.abort(),
  }),
})

local on_attach = function(client, bufnr)
  vim.api.nvim_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua require("telescope.builtin").lsp_references()<CR>',
    { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-e>', '<cmd>lua vim.diagnostic.open_float()<cr>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { noremap = true, silent = true })
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
    'svelte',
    'tsserver',
    'solargraph',
    'sorbet',
    'solang',
    'rubocop',
    'eslint',
    'yamlls',
    'rust_analyzer',
  },
  handlers = {
    function(server)
      if server == "yamlls" then
        lspconfig[server].setup {
          settings = {
            yaml = {
              schemas = {
                ['https://json.schemastore.org/kustomization'] = { 'kustomization.yaml', 'deploy.yaml', 'base/*.yaml',
                  'overlays/*.yaml' },
              },
            },
          }
        }
      elseif server == "tsserver" then
        lspconfig[server].setup {
          handlers = {
            ['textDocument/definition'] = function(err, result, method, ...)
              if vim.tbl_islist(result) and #result > 1 then
                local filtered_result = filter(result, filterReactDTS)
                return vim.lsp.handlers['textDocument/definition'](err, filtered_result, method, ...)
              end

              vim.lsp.handlers['textDocument/definition'](err, result, method, ...)
            end

          }
        }
      elseif server == "solargraph" then
        local home = os.getenv("HOME")
        local ruby_path = ""

        -- For RVM
        if vim.fn.isdirectory(home .. "/.rbenv/bin") == 1 then
          ruby_path = home .. "/.rbenv/bin/:"
          -- For rbenv
        elseif vim.fn.isdirectory(home .. "/.rbenv/shims") == 1 then
          ruby_path = home .. "/.rbenv/shims/"
        end

        -- Add Ruby path to Neovim's PATH
        vim.env.PATH = ruby_path .. vim.env.PATH

        -- Set up Solargraph with the correct Ruby
        lspconfig[server].setup {
          cmd = { ruby_path .. "solargraph", "stdio" },
          settings = {
            solargraph = {
              diagnostics = true,
              completion = true,
              hover = true,
              formatting = true,
              useBundler = true, -- Use this if you're using Bundler
              autoformat = true,
              symbols = true,
              definitions = true,
              references = true,
              rename = true
            }
          },
          on_attach = on_attach -- Make sure to use your custom on_attach function
        }
      elseif server == "rust_analyzer" then
        -- do nothing so it uses rustaceanvim
        --lspconfig[server].setup {
        --  check = {
        --    command = "clippy",
        --  },
        --  extraArgs = {
        --    "--all-targets"
        --  },
        --  diagnostics = {
        --    enable = true,
        --  }
        --}
      else
        lspconfig[server].setup({})
      end
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
      "markdown",
      "graphql",
      "md",
      "txt",
    },
  }),
  null_ls.builtins.formatting.gofmt.with({
    filetypes = {
      "go",
    },
  }),
  null_ls.builtins.formatting.rustfmt,
  null_ls.builtins.diagnostics.rubocop.with({
    command = "rubocop",
    args = { "--format", "json", "--force-exclusion", "--stdin", "$FILENAME" },
    diagnostics_format = "#{m} [#{c}]"
  }),
}

local augroup = vim.api.nvim_create_augroup("LspFormattingJM", {})

vim.g.rustaceanvim = function()
  return {
    server = {
      on_attach = function()
        vim.keymap.set("n", "K", function() vim.cmd.RustLsp { "hover", "actions" } end, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>rr", function() vim.cmd.RustLsp('runnables') end, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>ca", function() vim.cmd.RustLsp('codeAction') end, { noremap = true, silent = true })

        vim.api.nvim_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua require("telescope.builtin").lsp_references()<CR>',
          { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-e>', '<cmd>lua vim.diagnostic.open_float()<cr>',
          { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { noremap = true, silent = true })
      end
    }
  }
end

vim.lsp.set_log_level("debug")

null_ls.setup({
  sources = lSsources,
  on_attach = function(client, bufnr)
    if vim.api.nvim_buf_get_option(bufnr, 'filetype') == 'yaml' then
      return -- Skip setting up formatting for YAML files
    end

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr
          })
        end,
      })
    end
  end,
})

--require("mason-nvim-dap").setup({
--  ensure_installed = {
--    "codelldb",
--    "cpptools"
--  }
--})
