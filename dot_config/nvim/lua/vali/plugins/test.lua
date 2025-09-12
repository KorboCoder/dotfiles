--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    {

        "nvim-neotest/neotest",
        version = "5.11.*",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {"nvim-neotest/neotest-jest",commit = "c211844" },
            "antoinemadec/FixCursorHold.nvim",
            { "fredrikaverpil/neotest-golang", version = "1.14.*" }, -- Installation
            "andythigpen/nvim-coverage",
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
                    require("neotest-golang")( {  -- Specify configuration
                        runner = "gotestsum",
                        go_test_args = {
                            "-v",
                            "-race",
                            "-count=1",
                            "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                        },
                    }),
                },
                discovery = {
                    enabled = true,
                    concurrent = 1,
                },
                running ={
                    concurrent = false,
                },
                consumers = {
                    -- notify when tests start and end
                    notify = function(client)
                        local testStartTime = os.time()

                        client.listeners.run = function()
                                require("neotest.lib").notify("Tests Running...")
                                testStartTime = os.time()
                        end

                        client.listeners.results = function(_, results, partial)
                            if partial then
                                return
                            end

                            local totalDuration = testStartTime ~= 0 and os.difftime(os.time(), testStartTime) .. "s" or "unknown time"

                            local firstResult = nil
                            local resTable = {
                                passed = 0,
                                failed = 0,
                                skipped = 0

                            }
                            -- this is not accurate to actual test results, might need to configure for each test. adapter
                            for _, value in pairs(results) do
                                resTable[value.status] = resTable[value.status] + 1;
                                if(value.status == 'passed' or value.status == 'failed') then
                                    firstResult = value
                                end
                            end

                            if resTable.passed + resTable.failed > 1 then
                                require("neotest.lib").notify("Tests completed(" .. totalDuration .. "):\nPassed: " ..
                                resTable.passed .. "\nFailed: " .. resTable.failed .. "\nSkipped: " .. resTable.skipped)
                            elseif firstResult ~= nil then
                                local level = vim.log.levels.INFO
                                if firstResult.status == "failed" then
                                    level = vim.log.levels.ERROR
                                end

                                require("neotest.lib").notify("Test Result(" .. totalDuration .. "): " .. firstResult.status, level)
                            end
                        end
                        return {}
                    end,
                },
                output = {
                    open_on_run = true
                },
                -- status = {
                --     virtual_text = true
                -- }

            })
        end
    },
    {
        "andythigpen/nvim-coverage",
        version = "*",
        dependencies= {
            "catppuccin/nvim",

        },
        config = function()
            local macchiato = require("catppuccin.palettes").get_palette "macchiato"

            require("coverage").setup({
                auto_reload = true,
                commands = true,
                highlights = {
                    -- customize highlight groups created by the plugin
                    covered = { fg = macchiato.green },   -- supports style, fg, bg, sp (see :h highlight-gui)
                    uncovered = { fg = macchiato.red },
                    partial = { fg = macchiato.mauve },
                },
                signs = {
                    -- use your own highlight groups or text markers
                    covered = { text = "█" },
                    uncovered = { text = "█" },
                },
            })
        end,
        keys = {
            { "<leader>tcc", "<cmd>CoverageToggle<cr>", desc = "Toggle Coverage" },
            { "<leader>tcs", "<cmd>CoverageSummary<cr>", desc = "Coverage Summary" },
            { "<leader>tcl", "<cmd>CoverageLoad<cr>", desc = "Load Coverage" },
            { "<leader>tcC", "<cmd>CoverageClear<cr>", desc = "Clear Coverage" },
        },
    },
}
