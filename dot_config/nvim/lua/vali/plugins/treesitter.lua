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
        "nvim-treesitter/playground",
    },
}
