return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig', branch = "master" }, -- Required
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
            { 'hrsh7th/nvim-cmp', },                                                 -- Required
            { 'hrsh7th/cmp-nvim-lsp' },                                              -- Required
            { 'L3MON4D3/LuaSnip',                 build = "make install_jsregexp" }, -- Required
            { 'hrsh7th/cmp-buffer' },                                                -- Required
            { 'hrsh7th/cmp-path' },                                                  -- Required
            { 'hrsh7th/cmp-nvim-lua' },                                              -- Required
            { 'saadparwaiz1/cmp_luasnip' },                                          -- Optional
            { 'rafamadriz/friendly-snippets' },                                      -- Optional
            { 'folke/neodev.nvim', opts = {} },
            -- { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            -- { 'ray-x/lsp_signature.nvim' },
            -- LSp status updates
            {
                enabled = true,
                'j-hui/fidget.nvim',
                tag = 'legacy',
                event = "LspAttach",
                opts = {
                    window = {
                        blend = 0,
                        border = "single"
                    },
                    text = {
                        spinner = "meter"
                    }
                }
            },

            -- Additional nvim lua configuration
            'folke/neodev.nvim',

            --  vscode like symbols
            { 'onsails/lspkind.nvim' }

        },
        config = function()
            local lsp = require('lsp-zero')

            lsp.preset('recommended')
            lsp.setup()

            -- Set groovy as language for Jenkinsfile*
            vim.api.nvim_command('au BufNewFile,BufRead Jenkinsfile* setf groovy')

            -- [[ Configure LSP ]]
            --  This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(client, bufnr)
                require("lsp-inlayhints").on_attach(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    require('nvim-navic').attach(client, bufnr)
                end
                -- NOTE: Remember that lua is a real programming language, and as such it is possible
                -- to define small helper and utility functions so you don't have to repeat yourself
                -- many times.
                --
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end

                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                local vmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end

                    vim.keymap.set('v', keys, func, { buffer = bufnr, desc = desc })
                end

                vmap('<M-F>', vim.lsp.buf.format, '[C]ode [F]ormat')
                nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('<F12>', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('<S-F12>', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
                -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                --
                -- See `:help K` for why this keymap
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

                -- Lesser used LSP functionality
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                nmap('<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [L]ist Folders')

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, { desc = 'Format current buffer with LSP' })
            end
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
                        workspace = { checkThirdParty = true },
                        telemetry = { enable = false },
                        diagnostics = {

                            disable = {"undefined-field"},
                        }
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
                    -- ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    -- to exit completion tab if i want to close
                    -- ['<C-Space>'] = cmp.mapping.complete {},
                    -- Toggle copmletion menu. Ref: https://github.com/hrsh7th/nvim-cmp/issues/429#issuecomment-954121524
                    ['<C-Space>'] = cmp.mapping({
                        i = function()
                            if cmp.visible() then
                                cmp.abort()
                            else
                                cmp.complete()
                            end
                        end,
                        c = function()
                            if cmp.visible() then
                                cmp.close()
                            else
                                cmp.complete()
                            end
                        end }),
                    ['<CR>'] = cmp.mapping.confirm {
                        -- behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                    -- ['<C-k>'] = cmp.mapping(function(fallback)
                    --     if luasnip.expand_or_jump() then
                    --         luasnip.expand_or_jump()
                    --     else
                    --         fallback()
                    --     end
                    -- end, { 'i', 's' }),
                    ['<C-j>'] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-k>'] = cmp.mapping(function(fallback)
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
        keys = {
            { '<leader>L', "<cmd>lua require('lsp-inlayhints').toggle()<cr>", desc = "Toggle Inlayhints" }
        },
        config = function()

            require('lsp-inlayhints').setup()
            -- suppose to be the default highlight for LspInlayHint but background is not being set
            -- decided to set the default manually here
            local hint_bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg
            local hint_fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
            vim.api.nvim_set_hl(0, "LspInlayHint", { bg = hint_bg, fg = hint_fg })
        end
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
