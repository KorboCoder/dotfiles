--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    {
        "olexsmir/gopher.nvim",
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
        dependencies = {  -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
		init = function()
			local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					vim.cmd("GoFmt")
				end,
				group = format_sync_grp,
			})
		end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    }
}
