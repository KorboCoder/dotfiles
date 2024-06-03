return {
    -- toggle comments
    {
        "numToStr/Comment.nvim",
        opts = {}
    },
    -- TODO: another toggle coments plugin, try this might be good
    {
        enabled = false,
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true
    },
    {
        enabled = false,
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo
                        .commentstring
                end,
            },
        },
    },
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    -- general code refactoring
    {
        enabled = false,
        "ThePrimeagen/refactoring.nvim",
        opts = {}
    },
    -- automatically pair stuff
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require('nvim-autopairs').setup {}
            -- If you want to automatically add `(` after selecting a function or method
            local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
            local cmp = require 'cmp'
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    },
    -- nice diagnosis UI
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        branch = "main",
        config = function()
            local lsp_lines = require('lsp_lines')
            lsp_lines.setup()

            -- keybind setup so we can toggle between virtual_text and virtual_lines
            local initState = true
            vim.diagnostic.config({
                virtual_text = initState,
                virtual_lines = not initState
            })
            vim.keymap.set('n', "<leader>l", function()
                    initState = not initState
                    vim.diagnostic.config({
                        virtual_text = initState,
                        virtual_lines = not initState
                    })
                end,
                { desc = "Toggle lsp_lines" })
        end
    },
    -- edit pairs easier
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        opts = {}
    },
    -- TODO: better text objects
    {
        "echasnovski/mini.ai",
        enabled = false,
        -- keys = {
        --   { "a", mode = { "x", "o" } },
        --   { "i", mode = { "x", "o" } },
        -- },
        event = "VeryLazy",
        dependencies = { "nvim-treesitter-textobjects" },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
            -- register all text objects with which-key
            require("lazyvim.util").on_load("which-key.nvim", function()
                ---@type table<string, string|table>
                local i = {
                    [" "] = "Whitespace",
                    ['"'] = 'Balanced "',
                    ["'"] = "Balanced '",
                    ["`"] = "Balanced `",
                    ["("] = "Balanced (",
                    [")"] = "Balanced ) including white-space",
                    [">"] = "Balanced > including white-space",
                    ["<lt>"] = "Balanced <",
                    ["]"] = "Balanced ] including white-space",
                    ["["] = "Balanced [",
                    ["}"] = "Balanced } including white-space",
                    ["{"] = "Balanced {",
                    ["?"] = "User Prompt",
                    _ = "Underscore",
                    a = "Argument",
                    b = "Balanced ), ], }",
                    c = "Class",
                    f = "Function",
                    o = "Block, conditional, loop",
                    q = "Quote `, \", '",
                    t = "Tag",
                }
                local a = vim.deepcopy(i)
                for k, v in pairs(a) do
                    a[k] = v:gsub(" including.*", "")
                end

                local ic = vim.deepcopy(i)
                local ac = vim.deepcopy(a)
                for key, name in pairs({ n = "Next", l = "Last" }) do
                    i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
                    a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
                end
                require("which-key").register({
                    mode = { "o", "x" },
                    i = i,
                    a = a,
                })
            end)
        end,
    },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        version = "*",
        config = function(_, opts)
            local neogen = require("neogen")
            neogen.setup(opts)
            vim.keymap.set("n", "<leader>cc", neogen.generate, { desc = "Add Annotation" })
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.keymap.set("n", "<leader>zz", function() require("trouble").toggle() end, { desc="Toggle" })
            vim.keymap.set("n", "<leader>zw", function() require("trouble").open("workspace_diagnostics") end, { desc="Workspace" })
            vim.keymap.set("n", "<leader>zd", function() require("trouble").open("document_diagnostics") end, { desc="Document" })
            vim.keymap.set("n", "<leader>zq", function() require("trouble").open("quickfix") end, { desc="Quickfix" })
            vim.keymap.set("n", "<leader>zl", function() require("trouble").open("loclist") end, { desc="loclist" })
            vim.keymap.set("n", "<leader>zr", function() require("trouble").open("lsp_references") end, { desc="lsp_references" })
        end
    },
    -- for handlebars support
    { "mustache/vim-mustache-handlebars" },
    -- ai code completion
    {
        'Exafunction/codeium.vim',
        enabled = false,
        event = 'BufEnter',
        config = function()
            -- Change '<C-g>' here to any keycode you like.
            vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
            vim.keymap.set('i', '<C-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
            vim.keymap.set('i', '<C-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
            vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
        end
    }

}
