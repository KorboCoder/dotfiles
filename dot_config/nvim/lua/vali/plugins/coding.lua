--- @type LazyPluginSpec[] | LazyPluginSpec
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
        enabled = false,
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
			sign_priority=5,
            keywords = {
                FIX = {
                    icon = " ", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                IMPORTANT = { icon = " ", color = "error", alt = { "ATTENTION" }},
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning", alt = { "QQQ" }},
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO", "TEMP"} },
                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			}
        }
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
            require('nvim-autopairs').remove_rule('"') -- remove rule (
            require('nvim-autopairs').remove_rule('\'') -- remove rule (
            -- If you want to automatically add `(` after selecting a function or method
            local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
            local cmp = require 'cmp'
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

        end,
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        enabled = false,
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup({
                preset = "powerline",
                options = {
                    multilines = {
                        -- Enable multiline diagnostic messages
                        enabled = true,

                        -- Always show messages on all lines for multiline diagnostics
                        always_show = false,
                    },
                }
            })
            vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
        end,
        keys = {
            {
                "<leader>ld",
                function() require("tiny-inline-diagnostic").toggle() end,
                desc = "Toggle Inline Diagnostics",
            },
            {
                "<leader>le",
                function() 
                    require("tiny-inline-diagnostic").change_severities({vim.diagnostic.severity.ERROR})
                end,
                desc = "Toggle Only Error Diagnostics",
            },
            {

                "<leader>lw",
                function() 
                    require("tiny-inline-diagnostic").change_severities({vim.diagnostic.severity.WARN})
                end,
                desc = "Toggle Only Warning Diagnostics",
            },
            {
                "<leader>la",
                function() require("tiny-inline-diagnostic").change_severities({
                    vim.diagnostic.severity.WARN,
                    vim.diagnostic.severity.ERROR,
                    vim.diagnostic.severity.INFO,
                    vim.diagnostic.severity.HINT
                }) 
                end,

                desc = "Toggle All Diagnostics",
            }
        }
    },
    -- nice diagnosis UI
  --   {
  --       enabled = false,
  --       "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --       branch = "main",
  --       config = function()
  --           local lsp_lines = require('lsp_lines')
  --           lsp_lines.setup()
		--
		-- 	-- diagnostics setup
		-- 	local signs = {
		-- 		Error = '󰅚',
		-- 		Warn = '󰀪',
		-- 		Info = '󰋽',
		-- 		Hint = '󰌶',
		-- 	}
		-- 	local origVirtualText = {
		-- 		prefix = function(diagnostic)
		-- 			if diagnostic.severity == vim.diagnostic.severity.ERROR then
		-- 				return signs['Error']
		-- 			elseif diagnostic.severity == vim.diagnostic.severity.WARN then
		-- 				return signs['Warning']
		-- 			elseif diagnostic.severity == vim.diagnostic.severity.INFO then
		-- 				return signs['Info']
		-- 			else
		-- 				return signs['Hint']
		-- 			end
		-- 		end,
		-- 	}
		--
  --           -- keybind setup so we can toggle between virtual_text and virtual_lines
  --           local initState = true
  --           vim.diagnostic.config({
  --               virtual_text = origVirtualText,
  --               virtual_lines = not initState,
  --           })
		--
		-- 	vim.keymap.set('n', "<leader>l",
		-- 		function()
		-- 			initState = not initState
		-- 			if(initState) then
		-- 				vim.diagnostic.config({
		-- 					virtual_text = origVirtualText,
		-- 					virtual_lines = not initState
		-- 				})
		-- 			else
		-- 				vim.diagnostic.config({
		-- 					virtual_text = false,
		-- 					virtual_lines = not initState
		-- 				})
		-- 			end
		--
		-- 		end,
		-- 		{ desc = "Toggle lsp_lines" })
		-- end
  --   },
    -- edit pairs easier
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        opts = {}
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
        opts = {},
        cmd = "Trouble",
        keys = {
            {
                "<leader>zz",
                function() require("trouble").toggle("diagnostics") end,
                desc = "Diagnostics (Trouble)",
            },

            {
                "<leader>zo",
                function() require("trouble").next() end,
                desc = "Previous",
            },
            {
                "<leader>zi",
                function() require("trouble").prev() end,
                desc = "Next",
            },
            {
                "<leader>zZ",
                function() require("trouble").toggle("diagnostics", { filter = { buf = 0 } }) end,
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>zs",
                function() require("trouble").toggle("symbols", { focus = false }) end,
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>zl",
                function() require("trouble").toggle("lsp", { focus = false, win = { position = "right" } }) end,
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>zL",
                function() require("trouble").toggle("loclist") end,
                desc = "Location List (Trouble)",
            },
            {
                "<leader>zq",
                function() require("trouble").toggle("qflist") end,
                desc = "Quickfix List (Trouble)",
            },
        },
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
            -- vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
            vim.keymap.set('i', '<C-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
            vim.keymap.set('i', '<C-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
            vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
        end
    },
    -- better yanking and pasta-ing
    {
        "gbprod/yanky.nvim",
        -- dependencies = {
        --     { "kkharji/sqlite.lua" }
        -- },
        opts = {
            -- ring = { storage = "sqlite" },
            highlight = {
                on_put = false,
                on_yank = false,
            },
        },
        keys = {
            { "<leader>fp", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Open Yank History" },
            { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
            { "<leader>p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
            { "<leader>P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
            { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
            { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
            { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
            { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
            { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
            { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
            { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
            { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
            { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
            { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
            { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
            { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
            { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
            { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
        },
    },
    -- run selected snippets
    {
        "michaelb/sniprun",
        build = "sh ./install.sh",
        -- do 'sh install.sh 1' if you want to force compile locally
        -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

        config = function()
            require("sniprun").setup({
                display = {
                    "Terminal",
                    "VirtualText",


                },
            })
        end,
        keys = {
            {  '<leader>cR', '<Plug>SnipRunOperator', mode = {'n'}, silent = true , desc= "SnipRunOperator"},
            { '<leader>cr', '<Plug>SnipRun', mode = {'n', 'v'}, silent = true , desc= "SnipRun"},
            { '<leader>cs', '<Plug>SnipClose', mode = {'n', 'v'}, silent = true , desc= "Clear Snips"}
        }


	},
    -- work with regsiters easier
    {
        "tversteeg/registers.nvim",
        cmd = "Registers",
        opts = {
            window = {
                border = 'double',
                transparency = 0
            }
        },
        config = true,
        keys = {
            { "\"",    mode = { "n", "v" } },
            { "<C-R>", mode = "i" }
        },
        name = "registers",
    },
    {
        'Wansmer/treesj',
        keys = { 
            {
                '<space>cm',

                "<cmd>TSJToggle<cr>",
                desc = 'Toggle Func Spread'
            }
        },
        dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
        opts = {
            use_default_keymaps = false,
            max_join_length = 1000,
        },
    },
    {
        'Wansmer/symbol-usage.nvim',
        event = 'BufReadPre', -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
        config = function()
            local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end

            -- hl-groups can have any name
            vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = false })
            vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

            local function text_format(symbol)
                local res = {}
                local round_start = { "█", 'SymbolUsageRounding' }
                local round_end = { "█", 'SymbolUsageRounding' }

                -- Indicator that shows if there are any other symbols in the same line
                local stacked_functions_content = symbol.stacked_count > 0
                and ("+%s"):format(symbol.stacked_count)
                or ''

                if symbol.references then
                    local usage = symbol.references <= 1 and 'usage' or 'usages'
                    local num = symbol.references == 0 and 'no' or symbol.references
                    table.insert(res, round_start)
                    table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
                    table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
                    table.insert(res, round_end)
                end

                if symbol.definition then
                    if #res > 0 then
                        table.insert(res, { ' ', 'NonText' })
                    end
                    table.insert(res, round_start)
                    table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
                    table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
                    table.insert(res, round_end)
                end

                if symbol.implementation then
                    if #res > 0 then
                        table.insert(res, { ' ', 'NonText' })
                    end
                    table.insert(res, round_start)
                    table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
                    table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
                    table.insert(res, round_end)
                end

                if stacked_functions_content ~= '' then
                    if #res > 0 then
                        table.insert(res, { ' ', 'NonText' })
                    end
                    table.insert(res, round_start)
                    table.insert(res, { ' ', 'SymbolUsageImpl' })
                    table.insert(res, { stacked_functions_content, 'SymbolUsageContent' })
                    table.insert(res, round_end)
                end

                return res
            end

            require('symbol-usage').setup({
                text_format = text_format,
                vt_position = 'end_of_line',
                implementation = { enabled = true },
            })
        end
    },
    {
        'dnlhc/glance.nvim',
        enabled = false,
        cmd = 'Glance',
        keys = {
            -- { 'gd', '<cmd>Glance definitions<cr>', desc = 'Glance Definitions' },
            -- { 'gr', '<cmd>Glance references<cr>', desc = 'Glance References' },
            -- { 'gm', '<cmd>Glance implementations<cr>', desc = 'Glance Implementations' },
            -- { 'gy', '<cmd>Glance type_definitions<cr>', desc = 'Glance Type Definitions' },
        },
        opts ={
            height = 30,
            border = {
                enable = true, -- Show window borders. Only horizontal borders allowed
                top_char = '═',
                bottom_char = '═',
            },
            hooks = {
                before_open = function(results, open, jump, method)
                    if #results == 1 then
                        local uri = vim.uri_from_bufnr(0)
                        local target_uri = results[1].uri or results[1].targetUri

                        if target_uri == uri then
                            jump(results[1])
                        else
                            open(results)
                        end
                    else
                        open(results)
                    end
                end,

            }

        },
    },
    {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope.nvim"},
        },
        event = "LspAttach",
        opts = {
            backend = "vim",
            picker = {
                "buffer",
                opts = {
                    hotkeys = true,
                    hotkeys_mode = function(titles, used_hotkeys)
                        local t = {}
                        for i = 1, #titles do t[i] = tostring(i) end
                        return t
                    end,
                    auto_preview = true,
                    winborder ="double"
                }
            }
        },
        init = function()
            vim.keymap.set({ "n", "x" }, "<leader>ca", function()
                require("tiny-code-action").code_action()
            end, { noremap = true, silent = true, desc = "Code Actions" })
        end


    },

    { -- This plugin
        "Zeioth/compiler.nvim",
        cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"},
        dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
        opts = {},
        init = function()
            -- Open compiler
            vim.api.nvim_set_keymap('n', '<F6>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })

            -- Redo last selected option
            vim.api.nvim_set_keymap('n', '<leader><F6>',
                "<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
                .. "<cmd>CompilerRedo<cr>",
                { noremap = true, silent = true })

            -- Toggle compiler results
            vim.api.nvim_set_keymap('n', '<leader><F7>', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
        end,
    },
    { -- The task runner we use
        "stevearc/overseer.nvim",
        commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1
            },
        },
    },
    {
        'piersolenski/import.nvim',
        dependencies = {
            -- One of the following pickers is required:
            -- 'nvim-telescope/telescope.nvim',
            'folke/snacks.nvim',
            -- 'ibhagwan/fzf-lua',
        },
        opts = {
            picker = "telescope",
        },
        keys = {
            {
                "<leader>ci",
                function()
                    require("import").pick()
                end,
                desc = "Import",
            },
        },
    },
    
}
