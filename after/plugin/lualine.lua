-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
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
  return is_modified and "🟡" or "🟢"
end


require('lualine').setup {
  options = {
    theme = bubbles_theme,
  },
  sections = {
    lualine_a = {
      { 'mode', right_padding = 2 },
    },
    lualine_b = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
    },
      'branch' },
    lualine_c = { 'fileformat' },
    lualine_x = { 'diff' },
    lualine_y = { 'filetype', 'progress', save_status },
    lualine_z = {
      { 'location', left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { save_status, 'location' },
  },
  tabline = {},
  extensions = {},
}
