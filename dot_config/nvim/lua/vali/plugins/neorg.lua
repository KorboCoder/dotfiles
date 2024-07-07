--- @type LazyPlugin[] | LazyPlugin
return {
    -- NOTE: install treesitter wthn  `CC=gcc-14 nvim -c "TSInstall norg"`
    {
        "nvim-neorg/neorg",
        -- lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*", -- Pin Neorg to the latest stable release
        opts = {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {
                    config = {
                        folds = false
                    }
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/notes",
                        },
                        default_workspace = "notes",
                    },
                },
            },
        },
    }
}
