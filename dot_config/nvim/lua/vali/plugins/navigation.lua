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
    },
    -- jump between files
    {
        "theprimeagen/harpoon",
    },
}
