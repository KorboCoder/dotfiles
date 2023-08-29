return {

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {},

        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
                transparent_background = true,
                term_colors = true,
                dim_inactive = {
                    enabled = false,
                    shade = "dark",
                    percentage = 0.75
                },
                integrations = {
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = true
                    },
                    harpoon = true,
                    neotest = true,
                    illuminate = true,
                    which_key = true,
                    noice = true,
                    notify = true,
                    dap = {
                        enabled = true,
                        enable_ui = true
                    },
                    fidget = true,
                    mason = true,
                    lsp_trouble = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                        inlay_hints = {
                            background = true,
                        },
                    },

                }
            })
            vim.cmd([[colorscheme catppuccin-macchiato]])
        end
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = true
            })
            -- vim.cmd([[colorscheme tokyonight-night]])
        end,
    },
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            require('vscode').setup();
        end
    },{
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = {
            transparent = true
        }
    }
}
