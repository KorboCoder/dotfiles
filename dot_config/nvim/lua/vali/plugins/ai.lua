--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    {
        "yetone/avante.nvim",
        enabled = false,

        build = vim.fn.has("win32") ~= 0
            and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        event = "VeryLazy",
        version = false,
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            -- add any opts here
            -- for example
            provider = "copilot",
            behaviour = {
                auto_suggestions = false,
            },
            web_search_engine = {
                provider = "google",
            },
            disabled_tools = {
                "web_search",
            },
            mappings = {
                submit = {
                    normal = "<CR>",
                    insert = "<CR>",
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            "stevearc/dressing.nvim", -- for input provider dressing
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons

            -- {
            --     -- NOTE: remove this after this issue is resolved: https://github.com/LazyVim/LazyVim/issues/5899
            --     "zbirenbaum/copilot.lua",
            --     optional = true,
            --     opts = function()
            --         require("copilot.api").status = require("copilot.status")
            --     end,
            -- },
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { --[[ "markdown",  ]]"Avante" },
                },
                ft = { --[[ "markdown", ]] "Avante" },
            },
        },
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { 
                    auto_trigger = true,
                    keymap = {
                        accept = "<C-l>",
                    }
                },
                panel = { enabled = false },
            })
        end,
    },
    {
        "piersolenski/wtf.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-telescope/telescope.nvim", -- Optional: For WtfGrepHistory
        },
        opts = {
            provider = "copilot"
        },
        keys = {
            {
                "<leader>wd",
                mode = { "n", "x" },
                function()
                    require("wtf").diagnose()
                end,
                desc = "Debug diagnostic with AI",
            },
            {
                "<leader>wf",
                mode = { "n", "x" },
                function()
                    require("wtf").fix()
                end,
                desc = "Fix diagnostic with AI",
            },
            {
                mode = { "n" },
                "<leader>ws",
                function()
                    require("wtf").search()
                end,
                desc = "Search diagnostic with Google",
            },
            {
                mode = { "n" },
                "<leader>wp",
                function()
                    require("wtf").pick_provider()
                end,
                desc = "Pick provider",
            },
            {
                mode = { "n" },
                "<leader>wh",
                function()
                    require("wtf").history()
                end,
                desc = "Populate the quickfix list with previous chat history",
            },
            {
                mode = { "n" },
                "<leader>wg",
                function()
                    require("wtf").grep_history()
                end,
                desc = "Grep previous chat history with Telescope",
            },
        },
    },
    {
        "sudo-tee/opencode.nvim",
        config = function()
            require("opencode").setup({})
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    anti_conceal = { enabled = false },
                    file_types = { 'markdown', 'opencode_output' },
                },
                ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
            },
            -- Optional, for file mentions and commands completion, pick only one
            'saghen/blink.cmp',
            -- 'hrsh7th/nvim-cmp',

            -- Optional, for file mentions picker, pick only one
            'folke/snacks.nvim',
            -- 'nvim-telescope/telescope.nvim',
            -- 'ibhagwan/fzf-lua',
            -- 'nvim_mini/mini.nvim',
        },
    }
}
