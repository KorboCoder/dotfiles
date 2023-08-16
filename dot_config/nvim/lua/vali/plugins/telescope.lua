return {
    {
        -- the best search
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {

                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
            "debugloop/telescope-undo.nvim",
            "nvim-telescope/telescope-file-browser.nvim"
        },
        keys = {
            { "<leader>f<tab>", "<cmd>Telescope<cr>",         desc = "Telescope" },
            -- { "<leader>u",  "<cmd>Telescope undo<cr>",         desc = "Undo Tree" },
            { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = 'Checkout Branch' },
            { '<leader>gs', "<cmd>Telescope git_status<cr>",   desc = "Git Status" },
            { '<leader>gc', "<cmd>Telescope git_commits<cr>",  desc = "Checkout Commit" },
            { '<leader>fq',      "<cmd>Telescope resume<cr>",        desc = "Resume" },
            { '<C-p>',      "<cmd>Telescope git_files<cr>",        desc = "Git Files" },
        },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    layout_strategy = "flex",
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = { width = 0.95, height = 0.95, prompt_position = 'top' }
                    },
                },
                file_ignore_patterns = {
                    "node_modules", "dist", ".git", "yarn.lock"
                },
                extensions = {
                    file_browser = {
                        hijack_netrw = true
                    },
                    undo = {
                        use_delta = true,
                        side_by_side = true
                    }
                }
            })
            require("telescope").load_extension "file_browser"
            require("telescope").load_extension "undo"
        end
    },
}
