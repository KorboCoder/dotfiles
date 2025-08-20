--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    -- explore files and edit like a normal buffer
    {
        'stevearc/oil.nvim',
        version = "2.15.0",
        opts = {
            delete_to_trash=true,
        },
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        --     config = function()
        --         require("oil").setup()
        --     end
        init = function()
            -- go to explorer
            vim.keymap.set("n", "-", require("oil").open, {desc="Open parent directory"})
            vim.keymap.set("n", "<space>-", require("oil").toggle_float, {desc="Open parent directory in floating window"})
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
		enabled = false,
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
        "cbochs/portal.nvim",
        -- Optional dependencies
        dependencies = {
            "cbochs/grapple.nvim",
            -- "ThePrimeagen/harpoon"
        },
        init = function()
            -- vim.keymap.set("n", "<leader>M", function() require("portal.builtin").grapple.tunnel() end )
            vim.keymap.set("n", "<C-M-o>", "<cmd>Portal jumplist backward<cr>")
            vim.keymap.set("n", "<C-M-i>", "<cmd>Portal jumplist forward<cr>")
        end,
        config = function()
            require('portal').setup({
                -- labels = { '1', '2', '3', '4' },
                window_options = {
                    relative = "cursor",
                    col = 10,
                    height = 10
                }
            })
            vim.api.nvim_set_hl(0, "PortalLabel", { link = "CurSearch", default = true })
        end
    },
    {
        "folke/flash.nvim",
        enabled =false,
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
			modes = {
				search = {
					enabled = false
				}
			},
            label = {
                uppercase = false,
                style = "overlay",
                -- after = false,
                -- before = true
            }

        },
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            -- {
            --     "S",
            --     mode = { "n", "o", "x" },
            --     function() require("flash").treesitter() end,
            --     desc =
            --     "Flash Treesitter"
            -- },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc =
                "Remote Flash"
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc =
                "Treesitter Search"
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        },
    },
    {
        "cbochs/grapple.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons", lazy = true },
        },
        opts = {
            scope = "git", -- also try out "git_branch"
        },
        event = { "BufReadPost", "BufNewFile" },
        cmd = "Grapple",
        keys = {
            { "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
            { "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },

            -- Select tags
            { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
            { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
            { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
            { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },

            -- Cycle
            -- { "<C-S-n>", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
            -- { "<C-S-p>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
        }
    }

    
}
