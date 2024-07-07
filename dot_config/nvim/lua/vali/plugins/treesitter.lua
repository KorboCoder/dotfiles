--- @type LazyPlugin[] | LazyPlugin
return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        branch = 'master',
        -- version = 'v0.9.*',
        build = ':TSUpdate',
    },
    {
        enabled=false,
        "nvim-treesitter/playground",
    },
}
