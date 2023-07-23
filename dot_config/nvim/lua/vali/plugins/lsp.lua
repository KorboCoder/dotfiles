return {
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
            -- { 'ray-x/lsp_signature.nvim' },
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
            -- require('lsp_signature').setup({
            --     bind = true,
            --     doc_lines = 50,
            --     handler_opts = {
            --         border = "rounded"
            --     }
            -- })
        end
    },
}
