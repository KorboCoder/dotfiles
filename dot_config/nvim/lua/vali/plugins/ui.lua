return {
    -- for nice vim.ui.select and vim.ui.input
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    -- fade background of unselected window
    {
        enabled = true,
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
                globalstatus = true,
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    {
                        "diagnostics",
                        -- symbols = {
                        --     error = icons.diagnostics.Error,
                        --     warn = icons.diagnostics.Warn,
                        --     info = icons.diagnostics.Info,
                        --     hint = icons.diagnostics.Hint,
                        -- },
                    },
                    {
                        "filetype",
                        icon_only = false,
                        icon = { align = 'right' },
                        padding = {
                            left = 1, right = 0 }
                    },
                    { "filename", path = 1, symbols = { modified = "✏️", readonly = " 🔒", unnamed = "" } },
                    -- stylua: ignore
                    -- {
                    --     function() return require("nvim-navic").get_location() end,
                    --     cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
                    -- },
                },
                lualine_x = {
                    -- stylua: ignore
                    {
                        function() return require("noice").api.status.command.get() end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                        -- color = Util.fg("Statement"),
                    },
                    -- stylua: ignore
                    {
                        function() return require("noice").api.status.mode.get() end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                        -- color = Util.fg("Constant"),
                    },
                    -- stylua: ignore
                    {
                        function() return "  " .. require("dap").status() end,
                        cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
                        -- color = Util.fg("Debug"),
                    },
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        -- color = Util.fg("Special")
                    },
                    -- {
                    --     "diff",
                    --     -- symbols = {
                    --     --     added = icons.git.added,
                    --     --     modified = icons.git.modified,
                    --     --     removed = icons.git.removed,
                    --     -- },
                    -- },
                },
                lualine_y = {
                    "encoding",
                },
                lualine_z = {
                    { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                    { "location", padding = { left = 0, right = 1 } },
                }
            },
            extensions = { "lazy", "toggleterm", "nvim-dap-ui", "fugitive" },
        }
    },
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        init = function()
            vim.g.navic_silence = true
        end,
        opts = function()
            return {
                lsp = {
                    auto_attach = true
                },
                separator = " ",
                highlight = true,
                depth_limit = 5,
            }
        end
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            show_dirname = false,
        },
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
                show_current_context = false,
                show_current_context_start = false,
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
    -- popup what keymaps do
    {
        "folke/which-key.nvim",
        opts = {
            -- layout similar to helix editor
            window = {
                margin = { 1, 0, 1, 0.7 },
                border = "double",
                position = "bottom",
            },
            layout = {
                height = { max = 200 },
                width = { min = 10, max = 100 },
                -- no idea what this does
                align = "right"
            },
        },
        init = function()
            -- control how fast window appears
            vim.o.timeoutlen = 200
        end
    },
    -- better  ui for messages, cmdline and popupmenu
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {

            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = false,        -- use a classic bottom cmdline for search
                command_palette = false,      -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- disable lsp doc border since we have another plugi handling it
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            {
                "rcarriga/nvim-notify",
                opts = {
                    background_colour = "#000000",
                    stages = "static"
                },
                keys = {
                    { "<leader>cn", function() require("notify").dismiss({ silent = true }) end, desc = "Clear Notifs" }
                }
            },
        }
    },
    -- focus on one bufffer
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 130
            }
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            { 'gz', ':ZenMode<CR>', desc = "Zen Mode" }
        }
    },
    -- animated ui
    {
        enabled = false,
        'echasnovski/mini.animate',
        version = '*',
        config = true
    },
}
