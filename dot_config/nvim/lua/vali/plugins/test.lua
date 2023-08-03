return {
    {

        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {"haydenmeade/neotest-jest", lazy = false},
            "antoinemadec/FixCursorHold.nvim"
        },
        config = function()
            require('neotest').setup({
                adapters = {
                    require('neotest-jest')({
                        jestCommand = "npm test --",
                        jestConfigFile = "custom.jest.config.ts",
                        env = { CI = true },
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                    }),
                },
                output = {
                    open_on_run = true
                },
                status = {
                    virtual_text = true
                }

            })
        end
    },
}
