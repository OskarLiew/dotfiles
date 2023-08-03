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

M.telescope = {
    n = {
        ["<leader>gf"] = { "<cmd> Telescope git_files <CR>", "git files" },
        ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
        ["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "git status" },
    },
}

M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "insert breakpoint" },
    },
}

M.dap_python = {
    plugin = true,
    n = {
        ["<leader>dpr"] = {
            function()
                require("dap-python").test_method()
            end,
            "launch debugger",
        },
    },
}

M.undotree = {
    n = {
        ["<leader>u"] = { "<cmd> UndotreeToggle <CR>", "launch undotree" },
    },
}

M.fugitive = {
    n = {
        ["<leader>gg"] = { "<cmd> Git <CR>", "launch fugitive" },
    },
}

-- more keybinds!

return M
