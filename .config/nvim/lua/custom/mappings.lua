---@type MappingsTable
local M = {}

M.general = {
    n = {
        [";"] = { ":", "enter command mode", opts = { nowait = true } },
        ["<C-d>"] = { "<C-d>zz", "move half page down and center" },
        ["<C-u>"] = { "<C-u>zz", "move half page up and center" },
        -- Search terms centered
        ["<n>"] = { "nzzzv" },
        ["<N>"] = { "Nzzzv" },
        ["<leader>y"] = { '"+y', "yank to clipboard" },
        ["<leader>Y"] = { '"+Y', "yank row to clipboard" },
    },
    x = {
        ["<leader>p"] = { '"_dP', "paste and keep buffer" },
    },
    v = {
        ["<A-j>"] = { ":m '>+1<CR>gv=gv", "move selection down" },
        ["<A-k>"] = { ":m '<-2<CR>gv=gv", "move selection up" },
        ["<leader>y"] = { '"+y', "yank selection to clipboard" },
    },
}

M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
    },
}

M.dap_python = {
    plugin = true,
    n = {
        ["<leader>dpr"] = {
            function()
                require("dap-python").test_method()
            end,
        },
    },
}

-- more keybinds!

return M
