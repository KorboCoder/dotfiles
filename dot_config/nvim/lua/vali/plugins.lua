-- Plugisn to check out:
-- https://alpha2phi.medium.com/neovim-for-beginners-lsp-part-2-37f9f72779b6#aae3
-- inlay hints
-- telescope-file-browser.nvim
-- telescope-ui-select.nvim or dressing.nvim
-- config template: dope, https://www.youtube.com/watch?app=desktop&v=Vghglz2oR0c
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
                    horizontal = { width = 0.95, height = 0.95, prompt_position = 'top' }
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
                percentage = 0.50
            },
            dap = {
                enabled = true,
                enable_ui = true
            }
        },

        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
                transparent_background = true,
                term_colors = true,
                dim_inactive = {
                    enabled = true,
                    shade = "dark",
                    percentage = 0.75
                },
                integrations = {
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = true
                    }
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
        "ThePrimeagen/refactoring.nvim",
        opts = {}
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
        "tpope/vim-fugitive",
        keys = {
      { "<leader>gg", "<cmd>Git<CR>", desc = "Git" },
      { "<leader>gb", "<cmd>GBrowse<CR>", desc = "Git Browse" },
      { "<leader>gd", "<cmd>Gvdiffsplit<CR>", desc = "Git Diff" },
      { "<leader>gp", "<cmd>G push<CR>", desc = "Git Push" },
      { "<leader>gr", "<cmd>Gread<CR>", desc = "Git Read" },
      { "<leader>gw", "<cmd>Gwrite<CR>", desc = "Git Write" },
    },
    },
    {
        "tpope/vim-rhubarb"
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
            -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'ray-x/lsp_signature.nvim' },
            {
                'lvimuser/lsp-inlayhints.nvim',
                opts = {},
            },
            -- LSp status updates
            { 'j-hui/fidget.nvim',                tag = 'legacy', opts = {} },

            -- Additional nvim lua configuration
            'folke/neodev.nvim',
        },
        config = function()
            local lsp = require('lsp-zero')

            lsp.preset('recommended')
            lsp.setup()
            require('lsp_signature').setup({
                bind = true,
                doc_lines = 50,
                handler_opts = {
                    border = "rounded"
                }
            })
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
        opts = {}
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

        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {"haydenmeade/neotest-jest", lazy = false},
            "antoinemadec/FixCursorHold.nvim"
        },
        config = function()
            require('neotest').setup({
            adapters = {
                require('neotest-jest')({
                    jestCommand = "npm test --",
                    jestConfigFile = "custom.jest.config.ts",
                    env = { CI = true },
                    cwd = function(path)
                        return vim.fn.getcwd()
                    end,
                }),
            }
            })
        end
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
    require('vali.autoformat'),
    require('vali.debug')


}
