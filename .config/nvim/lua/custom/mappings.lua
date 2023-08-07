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
        ["<C-p>"] = { "<cmd> Telescope git_files <CR>", "git files" },
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

M.refactor = {
    n = {
        ["<leader>rr"] = { "<leader>ra", "rename" },
    },
    v = {
        ["<leader>re"] = { "<cmd> Refactor extract <CR>", "extract methond" },
        ["<leader>rf"] = { "<cmd> Refactor extract_to_file <CR>", "extract method to file" },
        ["<leader>rv"] = { "<cmd> Refactor extract_var <CR>", "extract variable" },
        ["<leader>ri"] = { "<cmd> Refactor inline_var <CR>", "inline variable" },
        ["<leader>rb"] = { "<cmd> Refactor extract_block <CR>", "extract block" },
        ["<leader>rbf"] = { "<cmd> Refactor extract_block_to_file <CR>", "extract block to file" },
    },
}

M.harpoon = {
    n = {
        ["<leader>a"] = {
            function()
                require("harpoon.mark").add_file()
            end,
            "add file",
        },
        ["<C-e>"] = {
            function()
                require("harpoon.ui").toggle_quick_menu()
            end,
            "quick menu",
        },
        ["<leader>1"] = {
            function()
                require("harpoon.ui").nav_file(1)
            end,
            "go to file 1",
        },
        ["<leader>2"] = {
            function()
                require("harpoon.ui").nav_file(2)
            end,
            "go to file 2",
        },
        ["<leader>3"] = {
            function()
                require("harpoon.ui").nav_file(3)
            end,
            "go to file 3",
        },
        ["<leader>4"] = {
            function()
                require("harpoon.ui").nav_file(4)
            end,
            "go to file 4",
        },
    },
}

-- more keybinds!

return M
