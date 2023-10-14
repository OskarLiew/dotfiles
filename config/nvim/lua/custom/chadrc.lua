---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	theme = "everforest",

	hl_override = highlights.override,
	hl_add = highlights.add,
	transparency = true,

	tabufline = {
		enabled = false,
	},
	statusline = {
		theme = "default",
		overriden_modules = function(modules)
			table.insert(
				modules,
				2,
				(function()
					local relative = vim.fn.fnamemodify(vim.fn.expand("%:h"), ":~:.")
					return relative .. " "
				end)()
			)
		end,
	},
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
