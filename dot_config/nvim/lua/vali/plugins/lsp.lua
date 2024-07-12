--- @type LazyPlugin[] | LazyPlugin
return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
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
            { 'hrsh7th/cmp-nvim-lsp' },                                              -- Required
            { 'L3MON4D3/LuaSnip',                 build = "make install_jsregexp" }, -- Required
            { 'hrsh7th/cmp-buffer' },                                                -- Required
            { 'hrsh7th/cmp-path' },                                                  -- Required
            { 'hrsh7th/cmp-nvim-lua' },                                              -- Required
            { 'saadparwaiz1/cmp_luasnip' },                                          -- Optional
            { 'rafamadriz/friendly-snippets' },                                      -- Optional
            { "Hoffs/omnisharp-extended-lsp.nvim" },
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
                    },
                    align = {
                        bottom = false
                    }
                }
            },

            --  vscode like symbols
            { 'onsails/lspkind.nvim' },
            
            -- rust tools
            { 'simrat39/rust-tools.nvim' },

        },
        config = function()
            local lsp = require('lsp-zero')

            lsp.preset('recommended')
            lsp.setup()

            -- Set groovy as language for Jenkinsfile*
            vim.api.nvim_command('au BufNewFile,BufRead Jenkinsfile* setf groovy')

            -- [[ Configure LSP ]]
            local on_attach = function(client, bufnr)
                local ok, _ = pcall(require, "inlay-hints")
                if ok then
                    require("inlay-hints").on_attach(client, bufnr)
                end


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

                nmap('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
                vmap('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
                nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, { desc = 'Format current buffer with LSP' })
			-- The following autocommand is used to enable inlay hints in your
			  -- code, if the language server you are using supports them
			  --
			  -- This may be unwanted, since they displace some of your code
			  if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
				vim.lsp.inlay_hint.enable(true) -- enable at start

				nmap('<leader>L', function()
				  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
				end, '[T]oggle Inlay [H]ints')
			  end

            end

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installedu
            --  Add any additional override configuration in the following tables. They will be passed to
            --  the `settings` field of the server config. You must look up that documentation yourself.
            --  Reference: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
            local servers = {
                -- clangd = {},
                gopls = {
                    gofumpt = true,
                    codelenses = {
                        gc_details = false,
                        generate = true,
                        regenerate_cgo = true,
                        run_govulncheck = true,
                        test = true,
                        tidy = true,
                        upgrade_dependency = true,
                        vendor = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                    analyses = {
                        fieldalignment = true,
                        nilness = true,
                        unusedparams = true,
                        unusedwrite = true,
                        useany = true,
                    },
                    usePlaceholders = true,
                    completeUnimported = true,
                    staticcheck = true,
                    directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                    semanticTokens = true,
                },
                -- pyright = {},
                -- rust_analyzer = {},
                -- cql = {},
				glimmer = {},
				['htmx-lsp'] = {
					filetypes = {"html", "html.handlebars"}
				},
                bashls = {
                    -- include zsh
                    filetypes = { 'sh', 'zsh', },
                },
                astro = {},
                tailwindcss = {

                },
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
                -- Reference: https://github.com/LuaLS/lua-language-server/wiki/Settings
                lua_ls = {
                    Lua = {
                        hint = {
                            enable = true
                        },
                        workspace = { checkThirdParty = true, library = { vim.env.VIMRUNTIME } },
                        telemetry = { enable = false },
                        diagnostics = {
                            -- reference: https://github.com/LuaLS/lua-language-server/wiki/Diagnostics
                            disable = { "missing-fields" },
                        }
                    },
                },
                -- Reference: https://github.com/walcht/neovim-unity/blob/main/after/plugin/lsp_related/lspconfig.lua 
                -- omnisharp_mono = {
                --     handlers = {
                --         ["textDocument/definition"] = require('omnisharp_extended').handler,
                --     },
                --     cmd = { vim.fn.stdpath("data") .. "/mason/bin/omnisharp-mono", '--languageserver', '--hostPID', tostring(vim.fn.getpid()) },
                --     enable_roslyn_analyzers = true,
                --     use_mono = true
                --     -- rest of your settings
                --
                -- }
            }

            -- Configure LSP through rust-tools.nvim plugin.
            -- rust-tools will configure and enable certain LSP features for us.
            -- See https://github.com/simrat39/rust-tools.nvim#configuration
            local opts = {
                tools = {
                    runnables = {
                        use_telescope = true,
                    },
                    inlay_hints = {
                        auto = true,
                        show_parameter_hints = false,
                        parameter_hints_prefix = "",
                        other_hints_prefix = "",
                    },
                },

                -- all the opts to send to nvim-lspconfig
                -- these override the defaults set by rust-tools.nvim
                -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
                server = {
                    -- on_attach is a callback called when the language server attachs to the buffer
                    on_attach = on_attach,
                    settings = {
                        -- to enable rust-analyzer settings visit:
                        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                        ["rust-analyzer"] = {
                            -- enable clippy on save
                            checkOnSave = {
                                command = "clippy",
                            },
                            cargo = {
                                allfeatures=true
                            }
                        },
                    },
                },
            }

            require("rust-tools").setup(opts)

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            -- Ensure the servers above are installed
            local mason_lspconfig = require 'mason-lspconfig'

            mason_lspconfig.setup {
                ensure_installed = vim.tbl_keys(servers),
            }
            local lspconfig = require('lspconfig')

            mason_lspconfig.setup_handlers {
                function(server_name)
                    local lspconfig_name = server_name

                    -- use omnisharp if ominisharp_mono is detected
                    if server_name == 'omnisharp_mono' then 
                        lspconfig_name = 'omnisharp'
                    end
                    if(lspconfig[lspconfig_name].setup ~= nil) then
                        lspconfig[lspconfig_name].setup {
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = servers[server_name],
                        }
                    else
                        -- check if we ran into an unsupported server or a random typo
                        vim.notify("Server not found for " .. server_name, vim.log.levels.WARN);

                    end
                end,
            }
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            local lspkind = require('lspkind')
            require('luasnip.loaders.from_vscode').lazy_load()

            -- lua snipppet setup
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
                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    ['<C-y>'] = cmp.mapping.confirm { select = true },
                    ['<C-CR>'] = cmp.mapping.confirm { select = true },


                    -- to exit completion tab if i want to close
                    ['<C-Space>'] = cmp.mapping.complete {},
                    -- Toggle copmletion menu. Ref: https://github.com/hrsh7th/nvim-cmp/issues/429#issuecomment-954121524
                    -- ['<C-Space>'] = cmp.mapping({
                    --     i = function()
                    --         if cmp.visible() then
                    --             cmp.abort()
                    --         else
                    --             cmp.complete()
                    --         end
                    --     end,
                    --     c = function()
                    --         if cmp.visible() then
                    --             cmp.close()
                    --         else
                    --             cmp.complete()
                    --         end
                    --     end }),
                    -- ['<CR>'] = cmp.mapping.confirm {
                    --     -- behavior = cmp.ConfirmBehavior.Replace,
                    --     select = false,
                    -- },
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
                    { name = 'buffer', keyword_length = 2 },
                    { name = 'luasnip', key_length = 3 },
                    -- { name = 'ray-x/lsp_signature.nvim' }
                    -- { name = 'nvim_lsp_signature_help' }
                },
            }
        end
    },
    {
        -- enabled = false,
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            settings = {
                separate_diagnostic_server = false,
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
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
        },
    },
    {

        "someone-stole-my-name/yaml-companion.nvim",
        ft = { "yaml" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        },
        config = function(_, opts)
            local cfg = require("yaml-companion").setup(opts)
            require("lspconfig")["yamlls"].setup(cfg)
            require("telescope").load_extension("yaml_schema")
        end
    },
    { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint-cli2' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
    },
    {
        'ckipp01/nvim-jenkinsfile-linter',
        dependencies = {"nvim-lua/plenary.nvim" },

        keys = {
            {
                "<leader>jj",
                function()
                    require("jenkinsfile_linter").validate()
                end,
                desc = "Validate Jenkinsfile",
            },
        }
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    { -- optional completion source for require statements and module annotations
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
    {
        'cameron-wags/rainbow_csv.nvim',
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon'
        },
        cmd = {
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim'
        }
    }

}
