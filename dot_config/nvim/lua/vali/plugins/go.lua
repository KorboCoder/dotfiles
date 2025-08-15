--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    {
        "olexsmir/gopher.nvim",
        enabled = false,
        ft = "go",
        -- branch = "develop", -- if you want develop branch
        -- keep in mind, it might break everything
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
        },
        -- (optional) will update plugin's deps on every update
        build = function()
            vim.cmd.GoInstallDeps()
        end,
        ---@type gopher.Config
        opts = {},
    },{
        "ray-x/go.nvim",
        branch = "master",
        dependencies = {  -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function(lp, opts)
            require("go").setup(opts)
            -- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --     pattern = "*.go",
            --     callback = function()
            --         require('go.format').goimports()
            --     end,
            --     group = format_sync_grp,
            -- })
            vim.keymap.set({ "n", "v" }, "<leader>de", function()
                require("dapui").eval()  -- opens a small float only when pressed
            end)
        end,
        opts = {
            -- run_in_floaterm = true,
            -- floaterm = {   -- position
            --     posititon = 'right', -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
            -- },
            dap_debug = false,
            -- dap_debug_ui = { enabled = false },
            dap_debug_gui = false,
            dap_debug_keymap = false,

        },
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    }
}
