return {
    -- explore files and edit like a normal buffer
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        --     config = function()
        --         require("oil").setup()
        --     end
        init = function()
            -- go to explorer
            vim.keymap.set("n", "-", require("oil").open)
            -- Enable preview at start for oil
            -- vim.api.nvim_create_autocmd("User", {
            --     pattern = "OilEnter",
            --     callback = vim.schedule_wrap(function(args)
            --         local oil = require("oil")
            --         if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
            --             oil.select({ preview = true })
            --         end
            --     end),
            -- })
        end
    },
    -- jump between files
    {
        "theprimeagen/harpoon",
        keys = {

        },
        init = function()
            -- harpoon
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            vim.keymap.set("n", "<leader>ha", mark.add_file)
            vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

            vim.keymap.set("n", "<leader>hh", function() ui.nav_file(1) end)
            vim.keymap.set("n", "<leader>hj", function() ui.nav_file(2) end)
            vim.keymap.set("n", "<leader>hk", function() ui.nav_file(3) end)
            vim.keymap.set("n", "<leader>hl", function() ui.nav_file(4) end)
        end
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc =
            "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc =
            "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end,
                                                                                                          desc =
                "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc =
            "Toggle Flash Search" },
        },
    }
}
