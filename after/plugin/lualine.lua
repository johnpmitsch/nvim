-- Simplified lualine config using built-in components
-- Author: lokesh-krishna (simplified)

local colors = {
	blue = "#62C6F2",
	cyan = "#79dac8",
	black = "#080808",
	white = "#c6c6c6",
	red = "#ff5189",
	violet = "#d183e8",
	grey = "#303030",
	green = "#258a40",
	darkBlue = "#192a3d",
	orange = "#8a531c",
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
	return is_modified and "●" or "○"
end

require("lualine").setup({
	options = {
		theme = bubbles_theme,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = false, -- Single statusline for all windows
	},
	sections = {
		lualine_a = {
			{ "mode", right_padding = 2 },
		},
		lualine_b = {
			save_status,
			{
				"filename",
				file_status = true,
				path = 1,
				shorting_target = 40, -- Built-in intelligent shortening
				symbols = {
					modified = "[+]",
					readonly = "[RO]",
					unnamed = "[No Name]",
				},
			},
			{
				"branch",
				icon = "",
				fmt = function(str)
					if #str > 15 then
						return str:sub(1, 12) .. "..."
					end
					return str
				end,
				cond = function()
					return vim.fn.winwidth(0) > 100 -- Hide if window < 80 cols
				end,
			},
		},
		lualine_c = {},
		lualine_x = {
			"diff",
			cond = function()
				return vim.fn.winwidth(0) > 80 -- Hide if window < 100 cols
			end,
		},
		lualine_y = {
			{
				"diagnostics",
				-- Built-in diagnostics component with proper colors
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn", "info", "hint" },
				symbols = { error = "E", warn = "W", info = "I", hint = "H" },
				colored = true, -- Use built-in diagnostic colors
				update_in_insert = false, -- Only update when leaving insert mode
				always_visible = false, -- Hide when no diagnostics
			},
			"filetype",
			{
				function()
					-- Simple LSP client display
					local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
					local clients = vim.lsp.get_active_clients and vim.lsp.get_active_clients({ bufnr = 0 })
						or vim.lsp.buf_get_clients(0)

					if next(clients) == nil then
						return "No LSP"
					end

					local client_names = {}
					for _, client in pairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							table.insert(client_names, client.name)
						end
					end

					return #client_names > 0 and table.concat(client_names, ",") or "No LSP"
				end,
				icon = "⚡",
				color = function()
					local clients = vim.lsp.get_active_clients and vim.lsp.get_active_clients({ bufnr = 0 })
						or vim.lsp.buf_get_clients(0)
					return { fg = next(clients) and colors.green or colors.red }
				end,
				cond = function()
					return vim.fn.winwidth(0) > 100 -- Hide if window < 100 cols
				end,
			},
			"progress",
		},
		lualine_z = {
			{ "location", left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {
			save_status,
			{
				"filename",
				path = 1,
				shorting_target = 40,
			},
		},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = {},
})
