-- Setup all plugins here

return {

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
            -- require("tokyonight").setup({
            --     style = "night",
            --   transparent = true
            -- })
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
    { "folke/which-key.nvim",               opts = {} },
    {
        "numToStr/Comment.nvim",
        config = function() require('Comment').setup() end
    },
    { "lukas-reineke/indent-blankline.nvim" },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto'
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
    -- plugins from other files
    require('vali.autoformat')


}
