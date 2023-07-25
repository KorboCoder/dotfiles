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
    },
}
