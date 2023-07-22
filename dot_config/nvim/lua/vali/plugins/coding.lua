return {
    -- toggle comments
    {
        "numToStr/Comment.nvim",
        opts = {}
    },
    -- general code refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        opts = {}
    },
    -- automatically pair stuff
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
}
