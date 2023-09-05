-- Plugisn to check out:
-- https://alpha2phi.medium.com/neovim-for-beginners-lsp-part-2-37f9f72779b6#aae3
-- inlay hints
-- telescope-file-browser.nvim
-- telescope-ui-select.nvim or dressing.nvim
-- config template: dope, https://www.youtube.com/watch?app=desktop&v=Vghglz2oR0c, https://github.com/ChristianChiarulli/nvim/tree/1631262e8df1de2ad0ecfd5f7dffd9c4476d7933
-- https://github.com/ecosse3/nvim
return {
    -- preview markdown in browser
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = "markdown",
        lazy = true,
        keys = { { "gm", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" } },
        config = function()
            vim.g.mkdp_auto_close = true
            vim.g.mkdp_open_to_the_world = false
            vim.g.mkdp_open_ip = "127.0.0.1"
            vim.g.mkdp_port = "8888"
            vim.g.mkdp_browser = ""
            vim.g.mkdp_echo_preview_url = true
            vim.g.mkdp_page_title = "${name}"
        end,
    },
    -- terminal integration
    {
        'akinsho/toggleterm.nvim',
        version = "*",
    },
    -- undo history management
    {
        enabled = true,
        "mbbill/undotree",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = 'Undo Tree' }
        },
        init = function()
            -- focus on undotree after we opened
            vim.g.undotree_SetFocusWhenToggle = 1;
        end
    },
    -- auto session restore
    {
        'rmagatti/auto-session',
        config = function()
            require('auto-session').setup({
                auto_session_use_git_branch = true,
                auto_save_enabled = true,
                auto_restore_enabled = true,
                auto_session_suppress_dirs = { "~/" }
            })
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

            vim.keymap.set("n", "<leader>qr", "<cmd>SessionRestore<cr>", { desc = "Restore Session" })
            vim.keymap.set("n", "<leader>qs", function() require("auto-session.session-lens").search_session() end,
                { desc = "Search Sessions" })
            vim.keymap.set("n", "<leader>qd", "<cmd>Autosession delete<cr>", { desc = "Delete Sessions" })
        end
    },
    -- session management by folke
    {
        "folke/persistence.nvim",
        enabled = false,
        event   = "BufReadPre",
        opts    = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
        -- stylua: ignore
        keys    = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            {
                "<leader>qd",
                function() require("persistence").stop() end,
                desc =
                "Don't Save Current Session"
            },
        },
    },
    --  neovim latex support
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_compiler_method = 'latexmk'
            vim.g.vimtex_view_method = 'skim'
        end
    },
    {
        'ThePrimeagen/vim-be-good'
    },
    -- project management
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                patterns = { "*.sln", ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json",
                    "lazy-lock.json" },
            })
        end
    },
    {
        "ellisonleao/glow.nvim",
        config = {
            border = "single",
            width_ratio = 0.8,
            height_ratio = 0.8
        },
        cmd = "Glow"
    }

}
