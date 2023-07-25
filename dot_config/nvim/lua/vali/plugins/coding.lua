return {
    -- toggle comments
    {
        "numToStr/Comment.nvim",
        opts = {}
    },
    -- general code refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        opts = {}
    },
    -- automatically pair stuff
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    -- nice diagnosis UI
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = true,
        -- keys = {
        --     {"<leader>l", "<cmd>lua require('lsp_lines').toggle()<cr>", "Toggle lsp_lines"}
        -- },
        init = function()
            vim.diagnostic.config({
                virtual_text = false,
                virtual_lines = true
            })
            vim.keymap.set('n', "<leader>l", "<cmd>lua require('lsp_lines').toggle()<cr>", { desc = "Toggle lsp_lines" })
        end
    },
    -- edit pairs easier
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        opts = {}
    }

}
