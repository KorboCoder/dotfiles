return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        version = 'v0.9.*',
        build = ':TSUpdate',
    },
    {
        enabled=false,
        "nvim-treesitter/playground",
    },
}
