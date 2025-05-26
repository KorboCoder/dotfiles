--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    {

        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {"nvim-neotest/neotest-jest",commit = "c211844" },
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
                consumers = {
                    -- notify when tests start and end
                    notify = function(client)
                        client.listeners.started = function()
                                require("neotest.lib").notify("Starting Tests...")
                        end
                        client.listeners.results = function(_, results, partial)

                            if partial then
                                return
                            end
                            local firstResult = nil
                            local resTable = {
                                passed = 0,
                                failed = 0,
                                skipped = 0

                            }
                            -- this is not accurate to actual test results, might need to configure for each test adapter
                            for _, value in pairs(results) do
                                resTable[value.status] = resTable[value.status] + 1;
                                if(value.status == 'passed' or value.status == 'failed') then
                                    firstResult = value
                                end
                            end

                            if resTable.passed + resTable.failed > 1 then
                                require("neotest.lib").notify("Tests completed:\nPassed: " ..
                                resTable.passed .. "\nFailed: " .. resTable.failed .. "\nSkipped: " .. resTable.skipped)
                            elseif firstResult ~= nil then
                                local level = vim.log.levels.INFO
                                if firstResult.status == "failed" then
                                    level = vim.log.levels.ERROR
                                end

                                require("neotest.lib").notify("Test Result: " .. firstResult.status, level)
                            end
                        end
                        return {}
                    end,
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
