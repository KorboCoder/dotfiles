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
                opts = {
                    ui = {
                        border = "rounded",

                    }
                }
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp', },                                            -- Required
            { 'hrsh7th/cmp-nvim-lsp' },                                         -- Required
            { 'L3MON4D3/LuaSnip',                 build = "make install_jsregexp" }, -- Required
            { 'hrsh7th/cmp-buffer' },                                           -- Required
            { 'hrsh7th/cmp-path' },                                             -- Required
            { 'hrsh7th/cmp-nvim-lua' },                                         -- Required
            { 'saadparwaiz1/cmp_luasnip' },                                     -- Optional
            { 'rafamadriz/friendly-snippets' },                                 -- Optional
            -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            -- { 'ray-x/lsp_signature.nvim' },
            -- LSp status updates
            { 'j-hui/fidget.nvim',                tag = 'legacy',                 opts = {} },

            -- Additional nvim lua configuration
            'folke/neodev.nvim',

            --  vscode like symbols
            { 'onsails/lspkind.nvim' }

        },
        config = function()
            local lsp = require('lsp-zero')

            lsp.preset('recommended')
            lsp.setup()

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installedu
            --  Add any additional override configuration in the following tables. They will be passed to
            --  the `settings` field of the server config. You must look up that documentation yourself.
            local servers = {
                -- clangd = {},
                -- gopls = {},
                -- pyright = {},
                -- rust_analyzer = {},
                tsserver = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        }
                    }
                },

                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            }

            -- Setup neovim lua configuration
            require('neodev').setup()

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            -- Ensure the servers above are installed
            local mason_lspconfig = require 'mason-lspconfig'

            mason_lspconfig.setup {
                ensure_installed = vim.tbl_keys(servers),
            }

            mason_lspconfig.setup_handlers {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                    }
                end,
            }
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            local lspkind = require('lspkind')
            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup {}
            luasnip.config.set_config({
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true
            })
            cmp.setup {
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = { format = lspkind.cmp_format({ mode = 'symbol_text' }) },
                mapping = cmp.mapping.preset.insert {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    -- to exit completion tab if i want to close
                    ['<C-Space>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm {
                        -- behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                    ['<C-k>'] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_jump() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-l>'] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    -- remove this because exiting from insert mode is annoying
                    -- ['<Esc>'] = cmp.mapping.abort(),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'path' },
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'luasnip' },
                    -- { name = 'ray-x/lsp_signature.nvim' }
                    -- { name = 'nvim_lsp_signature_help' }
                },
            }
        end
    },
    {
        'lvimuser/lsp-inlayhints.nvim',
        config = true,
        keys = {
            { '<leader>L', "<cmd>lua require('lsp-inlayhints').toggle()<cr>", desc = "Toggle Inlayhints" }
        },
    },
    {
        enabled = false,
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            settings = {
                separate_diagnostic_server = true,
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeCompletionsForModuleExports = true,
                    quotePreference = "auto",
                },
            },
        },
    }
}
