-- Setup all plugins here

return {

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            defaults = {
                layout_strategy = "flex",
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = { width = 0.95, height = 0.95, preview_width = 100, prompt_position = 'top' }
                },
            },
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {
            flavour = "macchiato",
            transparent_background = true,
            term_colors = true,
            dim_inactive = {
                enabled = true,
                shade = "dark",
                percentage = 0.15
            }
        },

        config = function()
            -- require("catppuccin").setup({
            --     flavour = "macchiato",
            --     transparent_background = true,
            --     term_colors = false,
            --     dim_inactive = {
            --         enabled = true,
            --         shade = "dark",
            --         percentage = 0.15
            --     }
            -- })
            vim.cmd([[colorscheme catppuccin]])
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
    -- {
    --     "Mofiqul/vscode.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         require('vscode').setup();
    --     end
    -- },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
    {
        "nvim-treesitter/playground",
    },
    {
        "theprimeagen/harpoon",
    },
    {
        "mbbill/undotree"
    },
    {
        "tpope/vim-fugitive"
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },             -- Required
            { 'hrsh7th/cmp-nvim-lsp' },         -- Required
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'saadparwaiz1/cmp_luasnip' },     -- Optional
            { 'rafamadriz/friendly-snippets' }, -- Optional
            -- LSp status updates
            { 'j-hui/fidget.nvim',                tag = 'legacy', opts = {} },

            -- Additional nvim lua configuration
            'folke/neodev.nvim',
        },
        config = function()
            local lsp = require('lsp-zero')

            lsp.preset('recommended')
            lsp.setup()
        end
    },
    { "folke/which-key.nvim",       opts = {} },
    {
        "numToStr/Comment.nvim",
        opts = {}
    },
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
    { "nvim-tree/nvim-web-devicons" },
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            show_trailing_blankline_indent = false,
        },
        config = function()
            require("indent_blankline").setup { space_char_blankline = " ",
                show_current_context = true,
                show_current_context_start = true, }
        end
    },
    {
        'lewis6991/gitsigns.nvim',
        opt = {}
    },

    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        --     config = function()
        --         require("oil").setup()
        --     end
    },
    {
        'mawkler/modicator.nvim',
        init = function()
            -- These are required for Modicator to work
            vim.o.cursorline = true
            vim.o.number = true
            vim.o.termguicolors = true
        end,
        opt = {}
    },
    {
        'RRethy/vim-illuminate'
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    {
        'chrisbra/csv.vim'
    },
    -- {
    --
    --     'yamatsum/nvim-cursorline',
    --     config = function()
    --         require('nvim-cursorline').setup({
    --             cursorline = {
    --                 enable = true,
    --                 timeout = 0,
    --                 number = false,
    --             },
    --             cursorword = {
    --                 enable = true,
    --                 min_length = 3,
    --                 hl = { underline = true },
    --             }
    --         })
    --     end
    -- },
    -- plugins from other files
    require('vali.autoformat')


}
