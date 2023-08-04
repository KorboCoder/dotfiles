return {
    -- git integration
    {
        "tpope/vim-fugitive",
        keys = {
            -- { "<leader>gs", "<cmd>Git<CR>",         desc = "Git Status" },
            { "<leader>go", ":GBrowse<CR>",         desc = "Open in browser", mode = { "n", "v" } },
            { "<leader>gd", "<cmd>Gvdiffsplit<CR>", desc = "Git Diff" },
            -- { "<leader>gp", "<cmd>G push<CR>",      desc = "Git Push" },
            -- { "<leader>gr", "<cmd>Gread<CR>",       desc = "Git Read" },
            -- { "<leader>gw", "<cmd>Gwrite<CR>",      desc = "Git Write" },
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
            -- linehl = true,
            current_line_blame_opts = {
                virt_text_pos = 'right_align',
                delay = 500,
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- stylua: ignore start
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                map("n", "<leader>gtd", gs.toggle_deleted, "Toggle Deleted")
                map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle Line Blame")
                map("n", "<leader>gth", gs.toggle_linehl, "Toggle Highlights")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end
        },
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
