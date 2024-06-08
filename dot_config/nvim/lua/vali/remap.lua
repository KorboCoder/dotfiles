local wk = require('which-key')

-- <NoP> for <space> to prevent going to next line in modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- move selected chunk
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- indent to the right
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })
-- alternative to see if i like this
vim.keymap.set("v", "<s-tab>", "<gv", { noremap = true })
vim.keymap.set("v", "<tab>", ">gv", { noremap = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<c-h>", "<C-w>h", { desc = "Go to left window", noremap = true})
vim.keymap.set("n", "<c-j>", "<C-w>j", { desc = "Go to lower window", noremap = true})
vim.keymap.set("n", "<c-k>", "<C-w>k", { desc = "Go to upper window", noremap = true})
vim.keymap.set("n", "<c-l>", "<C-w>l", { desc = "Go to right window", noremap = true})

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-M-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-M-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-M-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-M-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })


local leaderN = { prefix = "<leader>", mode = "n" }
local leaderV = { prefix = "<leader>", mode = "v" }
local leaderNV = { prefix = "<leader>", mode = { "n", "v" } }

-- clipboard operations
wk.register(
    {
        x = {
            "\"_x", 'delete char to void'
        }

    },
    leaderN
)

wk.register(
    {
        d = {
            "\"_d", 'delete to void'
        },
        _ = {
            "\"_", 'to void register'
        },
        ['+'] = {
            "\"+", 'to system register'
        }

    },
    leaderNV
)

wk.register(
    {
        p = {
            "\"_dP", 'paste without changing register'
        },
    },
    leaderV
)

-- search operations
local builtin = require('telescope.builtin')
wk.register({
        f = {
            name = "+Search",
            f = {
                builtin.find_files, "Files"
            },
            b = {
                "<cmd>Telescope buffers<cr>", "Buffers"
            },
            d = {
                "<cmd>Telescope diagnostics<cr>", "Diagnostics"
            },
            t = {
                builtin.current_buffer_fuzzy_find, 'Text'
            },
            T = {
                "<cmd>Telescope live_grep<cr>", 'Global Text'
            },
            h = {
                "<cmd>Telescope help_tags<cr>", 'Help'
            },
            m = {
                "<cmd>Telescope man_pages<cr>", 'Man'
            },
            r = {
                "<cmd>Telescope registers<cr>", "Registers"
            },
            k = {
                "<cmd>Telescope keymaps<cr>", "Keymaps"
            },
            c = {
                "<cmd>Telescope commands<cr>", "Commands"
            },
            C = {
                "<cmd>Telescope command_history<cr>", "Command History"
            },
            n = {
                "<cmd>Noice telescope<cr>", "Notif History"
            },
            s = {
                "<cmd>Telescope lsp_document_symbols<cr>", "Document Sybols"
            },
            S = {
                "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols"
            }
        }
    },
    leaderN
)
wk.register({
    t = {
        name = "Test",
        -- l = { "<cmd>lua require('jester').run_last()<cr>", "Last" },
        -- L = { "<cmd>lua require('jester').debug_last()<cr>", "Debug Last" },
        -- n = { "<cmd>lua require('jester').run()<cr>", "Nearest" },
        -- N = { "<cmd>lua require('jester').debug()<cr>", "Debug Nearest" },
        -- f = { "<cmd>lua require('jester').file()<cr>", "File" },
        t = { "<cmd>lua require('neotest').run.run({suite = true})<cr>", "All" },
        l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Last" },
        L = { "<cmd>lua require('neotest').run.run_last({strategy = \"dap\"})<cr>", "Debug Last" },
        n = { "<cmd>lua require('neotest').run.run()<cr>", "Nearest" },
        N = { "<cmd>lua require('neotest').run.run({strategy = \"dap\"})<cr>", "Debug Nearest" },
        f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "File" },
        w = { "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>", "Watch" },
        d = { "<cmd>lua require('neotest').run.run({strategy = \"dap\"})<cr>", "Debug" },
        s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
        o = { "<cmd>lua require('neotest').output_panel.toggle()<cr>", "Output Panel" },
        O = { "<cmd>lua require('neotest').output.open({ enter = true, auto_close = true})<cr>", "Output Window" },

    }
}, leaderN)


local terminal = require('vali.terminal')

-- lazygit
vim.keymap.set('n', '<leader>gg', function() terminal.cmd_toggle("lazygit") end,
    { desc = "Lazygit" })

-- lazydocker
vim.keymap.set('n', '<leader>od', function() terminal.cmd_toggle("lazydocker") end,
    { desc = "Lazydocker" })

-- normal terminal
vim.keymap.set({ 't', 'i', 'n', 'x' }, '<C-Bslash>', terminal.cmd_toggle,
    { desc = "Floating Terminal" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
vim.keymap.set('i', '<M-BS>', '<C-w>', { noremap = true })

-- Reference for following: https://github.com/nvim-lua/kickstart.nvim
-- treesitter
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'comment',
        'jsdoc', 'c_sharp' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            }, -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

