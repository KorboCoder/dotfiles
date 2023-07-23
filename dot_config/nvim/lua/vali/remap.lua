local wk = require('which-key')

-- <NoP> for <space> to prevent going to next line in modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- go to explorer
-- vim.keymap.set("n", "-", "Ex")
vim.keymap.set("n", "-", require("oil").open)

-- move selected chunk
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

local leaderN = { prefix = "<leader>", mode = "n" }
local leaderV = { prefix = "<leader>", mode = "v" }
local leaderNV = { prefix = "<leader>", mode = { "n", "v" } }

-- clipboard operations
wk.register(
    {
        Y = {
            "\"+Y", 'yank line to system'
        },
        p = {
            "\"+p", 'paste from system'
        },
        d = {
            "\"_d", 'delete to void'
        },
        x = {
            "\"_x", 'delete char to void'
        }

    },
    leaderN
)

wk.register(
    {
        y = {
            "\"+y", 'yank to system'
        },
        d = {
            "\"_d", 'delete to void'
        }

    },
    leaderNV
)
-- search operations
local builtin = require('telescope.builtin')
wk.register({
        s = {
            name = "+Search",
            f = {
                builtin.find_files, "Files"
            },
            t = {
                builtin.current_buffer_fuzzy_find, 'Text'
            },
            T = {
                "<cmd>Telescope live_grep<cr>", 'Global Text'
            },
            h = {
                "<cmd>Telescope help_tags<cr>", 'Help'
            },
            m = {
                "<cmd>Telescope man_pages<cr>", 'Man'
            },
            r = {
                "<cmd>Telescope oldfiles<cr>", "Recent"
            },
            k = {
                "<cmd>Telescope keymaps<cr>", "Keymaps"
            },
            c = {
                "<cmd>Telescope commands<cr>", "Commands"
            },
            C = {
                "<cmd>Telescope command_history<cr>", "Command History"
            },
            n = {
                "<cmd>Noice telescope<cr>", "Notif History"
            },
            s = {
                "<cmd>Telescope lsp_document_symbols<cr>", "Document Sybols"
            },
            S = {
                "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols"
            }
        }
    },
    leaderN
)
wk.register({
    t = {
        name = "Test",
        -- l = { "<cmd>lua require('jester').run_last()<cr>", "Last" },
        -- L = { "<cmd>lua require('jester').debug_last()<cr>", "Debug Last" },
        -- n = { "<cmd>lua require('jester').run()<cr>", "Nearest" },
        -- N = { "<cmd>lua require('jester').debug()<cr>", "Debug Nearest" },
        -- f = { "<cmd>lua require('jester').file()<cr>", "File" },
        l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Last" },
        L = { "<cmd>lua require('neotest').run.run_last({strategy = \"dap\"})<cr>", "Debug Last" },
        n = { "<cmd>lua require('neotest').run.run()<cr>", "Nearest" },
        N = { "<cmd>lua require('neotest').run.run({strategy = \"dap\"})<cr>", "Debug Nearest" },
        f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "File" },
        w = { "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>", "Watch" },
        d = { "<cmd>lua require('neotest').run.run({strategy = \"dap\"})<cr>", "Debug" }
    }
})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>gg', "<cmd>lua require 'vali.terminal'.lazygit_toggle()<cr>", { desc = "Lazygit" })
vim.keymap.set('n', '<leader>gb', "<cmd>Telescope git_branches<cr>", { desc = 'Checkout Branch' })
vim.keymap.set('n', '<leader>gs', "<cmd>Telescope git_status<cr>", {desc = "Git Status"})
vim.keymap.set('n', '<leader>gc', "<cmd>Telescope git_commits<cr>", {desc = "Checkout Commit"})

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = 'Undo Tree' })

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")


vim.keymap.set("n", "<leader>ha", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>hh", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>hj", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>hk", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>hl", function() ui.nav_file(4) end)

-- Reference for following: https://github.com/nvim-lua/kickstart.nvim
-- treesitter
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}


-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
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
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
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
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    tsserver = {},

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

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

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
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
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
        { name = 'path'},
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'luasnip' },
        -- { name = 'ray-x/lsp_signature.nvim' }
        -- { name = 'nvim_lsp_signature_help' }
    },
}
