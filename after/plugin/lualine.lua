-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local colors = {
  blue     = '#62C6F2',
  cyan     = '#79dac8',
  black    = '#080808',
  white    = '#c6c6c6',
  red      = '#ff5189',
  violet   = '#d183e8',
  grey     = '#303030',
  green    = '#258a40',
  darkBlue = '#192a3d',
  orange   = '#8a531c'
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.darkBlue, bg = colors.white },
    b = { fg = colors.blue, bg = colors.black },
    c = { fg = colors.black, bg = colors.grey },
  },

  insert = { a = { fg = colors.orange, bg = colors.white } },
  visual = { a = { fg = colors.green, bg = colors.white } },
  replace = { a = { fg = colors.red, bg = colors.white } },

  inactive = {
    a = { fg = colors.white, bg = colors.grey },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white, bg = colors.grey },
  },
}
local save_status = function()
  local is_modified = vim.bo.modified
  return is_modified and "🔴" or "🟢"
end

local lsp_name = function()
  local clients = vim.lsp.buf_get_clients(0)
  if next(clients) == nil then return 'No LSP' end
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local active_clients = {}

  for _, client in pairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      table.insert(active_clients, client.name)
    end
  end

  if #active_clients == 0 then
    return 'no lsp'
  else
    return table.concat(active_clients, ', ')
  end
end

local lsp_status = function()
  --if vim.lsp.buf_get_clients() < 1 then return "" end
  return lsp_status.status()
end

require('lualine').setup {
  options = {
    theme = bubbles_theme,
  },
  sections = {
    lualine_a = {
      { 'mode', right_padding = 2 },
    },
    lualine_b = {
      save_status, {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
    },
      'branch' },
    lualine_c = {},
    lualine_x = { 'diff' },
    lualine_y = { 'filetype', lsp_name, 'progress', },
    lualine_z = {
      { 'location', left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { save_status, {
      'filename',
      path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}
