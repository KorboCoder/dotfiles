return {
    -- for nice vim.ui.select and vim.ui.input
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    -- fade background of unselected window
    {
        "levouh/tint.nvim",
        opts = {
            tint = -20,
            saturation = 0.5
        }
    },
    -- tmux like border for active window
    {
        "nvim-zh/colorful-winsep.nvim",
        config = true,
        event = { "WinNew" },
    },
    -- pretter context line at the bottom
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                globalstatus = true
            }
        }
    },
    -- nice icons
    {
        "nvim-tree/nvim-web-devicons"
    },
    -- pretty indentations
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            show_trailing_blankline_indent = false,
        },
        config = function()
            require("indent_blankline").setup {
                space_char_blankline = " ",
                show_current_context = true,
                show_current_context_start = true,
                char_highlight_list = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                    "IndentBlanklineIndent3",
                    "IndentBlanklineIndent4",
                    "IndentBlanklineIndent5",
                    "IndentBlanklineIndent6",
                },
            }
        end
    },
    -- show git changes in the sign column
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
                    { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
                vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
                    { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = '[P]review [H]unk' })
            end,
        },

    },
    -- change cursorlinenumber depending on mode
    {
        'mawkler/modicator.nvim',
        init = function()
            -- These are required for Modicator to work
            vim.o.cursorline = true
            vim.o.number = true
            vim.o.termguicolors = true
        end,
        opts = {}
    },
    -- highlight/underline other instance of selected word
    {
        'RRethy/vim-illuminate'
    },
    {
        "folke/which-key.nvim",
        opts = {
            -- layout similar to helix editor
            window = {
                margin = {1, 0, 1, 0.7},
                border = "double",
                position = "bottom",
            },
            layout = {
                height = { max = 200 },
                width = { min  = 10, max = 100},
                -- no idea what this does
                align = "right"
            },
        },
        init = function()
            -- control how fast window appears
            vim.o.timeoutlen = 200
        end
    }
}
