return {
    -- git integration
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gs", "<cmd>Git<CR>",         desc = "Git Status" },
            { "<leader>go", ":GBrowse<CR>",         desc = "Open in browser", mode = { "n", "v" } },
            { "<leader>gd", "<cmd>Gvdiffsplit<CR>", desc = "Git Diff" },
            { "<leader>gp", "<cmd>G push<CR>",      desc = "Git Push" },
            { "<leader>gr", "<cmd>Gread<CR>",       desc = "Git Read" },
            { "<leader>gw", "<cmd>Gwrite<CR>",      desc = "Git Write" },
        },
    },
    -- show git changes in the sign column
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            signcolumn = true,
            numhl = true,
            linehl = true,
            current_line_blame_opts = {
                virt_text_pos = 'right_align',
                delay = 500,
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
                    { buffer = bufnr, desc = 'Prev Hunk' })
                vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
                    { buffer = bufnr, desc = 'Next Hunk' })
                vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = 'Preview Hunk' })
            end,
        },
        init = function()
            vim.keymap.set('n', "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", { desc = "Blame" })
        end
    },
    -- open github with GBrowse
    {
        "tpope/vim-rhubarb"
    },
    -- add bitbucket support to fugitive
    {
        "tommcdo/vim-fubitive"
    }
}
