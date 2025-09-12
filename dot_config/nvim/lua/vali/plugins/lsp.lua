--- @type LazyPluginSpec[] | LazyPluginSpec
return {

    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = { 
            'rafamadriz/friendly-snippets',
            'onsails/lspkind.nvim',
            'simrat39/rust-tools.nvim',
            "Hoffs/omnisharp-extended-lsp.nvim",
            {
                'L3MON4D3/LuaSnip',
                version = 'v2.*',
                run = "make install_jsregexp",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                },
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end
            },

        },

        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = { preset = 'luasnip' },
            cmdline = {
                enabled = true,
                ---@diagnostic disable-next-line: assign-type-mismatch
                sources = function()
                    local type = vim.fn.getcmdtype()
                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    if type == ":" or type == "@" then
                        return { "cmdline", "buffer" }
                    end
                    return {}
                end,
                completion = {
                    menu = { auto_show = true },
                    ghost_text = { enabled = false },
                },
            },
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { 
                preset = 'enter',  -- Override Tab and Shift+Tab for source cycling when menu is visible
                ['<Tab>'] = { 'snippet_forward', 'select_next','fallback' },
                ['<S-Tab>'] = { 'snippet_backward', 'select_prev','fallback' },
                ['<C-space>'] = { 'show', 'hide' },

            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                list = {
                    selection ={
                        preselect = false
                    }
                },

                menu = {
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local icon = require("lspkind").symbolic(ctx.kind, {mode = "symbol"})
                                    return icon .. ctx.icon_gap
                                end
                            }
                        }
                    }
                },
                documentation = { auto_show = true } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            -- Workaround for truncating long TypeScript inlay hints from your old config
            local methods = vim.lsp.protocol.Methods
            local inlay_hint_handler = vim.lsp.handlers[methods.textDocument_inlayHint]
            vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, config)
                local client = vim.lsp.get_client_by_id(ctx.client_id)
                if client and client.name == 'typescript-tools' then
                    result = vim.iter(result):map(function(hint)
                        local label = hint.label ---@type string
                        if label:len() >= 30 then
                            label = label:sub(1, 29) .. '…'
                        end
                        hint.label = label
                        return hint
                    end)
                end
                inlay_hint_handler(err, result, ctx, config)
            end

            -- Set groovy as language for Jenkinsfile* from your old config
            vim.api.nvim_command('au BufNewFile,BufRead Jenkinsfile* setf groovy')

            -- LSP on_attach function from your old config
            local on_attach = function(client, bufnr)
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

                -- Your keybindings from old config
                nmap('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
                vmap('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
                nmap('<leader>rn', ':IncRename ', '[R]e[n]ame')
                nmap('<leader>cq', vim.diagnostic.setqflist, 'Set Quickfix List')
                -- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                -- nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                -- nmap('gm', vim.lsp.buf.implementation, '[G]oto I[m]plementation')
                -- nmap('gD', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
                -- nmap('gy', vim.lsp.buf.declaration, '[G]oto T[y]pe Declaration')

                -- Create Format command
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, { desc = 'Format current buffer with LSP' })

                -- Inlay hints setup
                if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint.enable(true)
                    nmap('<leader>L', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, '[T]oggle Inlay [H]ints')
                end
            end

            -- Get capabilities from blink.cmp
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Language servers configuration from your old config
            local servers = {
                gopls = {
                    gopls = {
                        gofumpt = true,
                        codelenses = {
                            gc_details = true,
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
                },
                glimmer = {},
                ['htmx-lsp'] = {
                    filetypes = {"html", "html.handlebars"}
                },
                bashls = {
                    filetypes = { 'sh', 'zsh', },
                },
                -- groovy = {
                --     cmd = { vim.fn.stdpath('data') .. "/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar" },
                --     groovy = {
                --         classpath = {"~/jenkins.util/vars"},
                --     }
                -- },
                astro = {},
                tailwindcss = {},
                vtsls = {
                    javascript = {
                        inlayHints = {
                            functionLikeReturnTypes = { enabled = true },
                            parameterNames = { enabled = 'all' },
                            variableTypes = { enabled = true },
                        },
                    },
                    typescript = {
                        inlayHints = {
                            functionLikeReturnTypes = { enabled = true },
                            parameterNames = { enabled = 'all' },
                            variableTypes = { enabled = true },
                        },
                    },
                },
                lua_ls = {
                    Lua = {
                        hint = {
                            enable = true
                        },
                        workspace = { checkThirdParty = true, library = { vim.env.VIMRUNTIME } },
                        telemetry = { enable = false },
                        diagnostics = {
                            disable = { "missing-fields" },
                        }
                    },
                },
            }

            -- Rust tools setup from your old config
            local rust_opts = {
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
                server = {
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                            cargo = {
                                allfeatures = true
                            }
                        },
                    },
                },
            }
            require("rust-tools").setup(rust_opts)

            -- Mason LSP setup
            local mason_lspconfig = require('mason-lspconfig')
            mason_lspconfig.setup {
                ensure_installed = vim.tbl_keys(servers),
                automatic_installation = true,
            }

            local lspconfig = require('lspconfig')
            mason_lspconfig.setup_handlers {
                function(server_name)
                    local lspconfig_name = server_name

                    -- use omnisharp if omnisharp_mono is detected
                    if server_name == 'omnisharp_mono' then 
                        lspconfig_name = 'omnisharp'
                    end

                    if lspconfig[lspconfig_name] and lspconfig[lspconfig_name].setup then
                        local server_config = {
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = servers[server_name],
                        }

                        -- Add special handlers for omnisharp
                        if server_name == 'omnisharp_mono' then
                            server_config.handlers = {
                                ["textDocument/definition"] = require('omnisharp_extended').handler,
                            }
                        end

                        lspconfig[lspconfig_name].setup(server_config)
                    else
                        vim.notify("Server not found for " .. server_name, vim.log.levels.WARN)
                    end
                end,
            }
        end,
        dependencies = {
            { "mason-org/mason.nvim", 
                opts = {
                    registries = {
                        "github:mason-org/mason-registry",
                        "github:Crashdummyy/mason-registry",
                    },
                    ui = {
                        border = "rounded",
                    }
                }
            },
            "neovim/nvim-lspconfig",
            "saghen/blink.cmp"
        },
    },
    {
        "seblyng/roslyn.nvim",
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
        opts = {
            -- your configuration comes here; leave empty for default settings
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
    -- LSP status updates from your old config
    {
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
    -- { -- optional completion source for require statements and module annotations
    --     "hrsh7th/nvim-cmp",
    --     opts = function(_, opts)
    --         opts.sources = opts.sources or {}
    --         table.insert(opts.sources, {
    --             name = "lazydev",
    --             group_index = 0, -- set group index to 0 to skip loading LuaLS completions
    --         })
    --     end,
    -- },
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
