-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    -- NOTE: Yes, you can install new plugins here!
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    dependencies = {

        -- library for asynchronous IO
        'nvim-neotest/nvim-nio',

        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui',

        -- Installs the debug adapters for you
        'williamboman/mason.nvim',
        {'jay-babu/mason-nvim-dap.nvim', opts = {automatic_installation = true}},

        -- Add your own debuggers here
        'leoluz/nvim-dap-go',
        {
            -- 'mxsdev/nvim-dap-vscode-js',
            'thenbe/nvim-dap-vscode-js',
            branch = 'configure-lazynvim',
            config = function()

                local lazypath = vim.fn.stdpath("data") .. "/lazy/"
                require('dap-vscode-js').setup({
                    debugger_path = lazypath .. 'vscode-js-debug'
                })
            end
        },
        {
            "microsoft/vscode-js-debug",
            build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
        },
        -- nice virtual text to see values
        {
            'theHamsta/nvim-dap-virtual-text',
            config = true

        }
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        require('mason-nvim-dap').setup {
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_setup = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                'delve',
            },
        }

        -- unity configuration
        dap.adapters.unity = {
            type = 'executable',
            command = '/Library/Frameworks/Mono.framework/Versions/Current/Commands/mono',
            args = {'/Users/vali/.vscode/extensions/unity.unity-debug-3.0.1/bin/UnityDebug.exe'}
        }
        dap.configurations.cs = {
            {
                type = 'unity',
                request = 'attach',
                name = 'Unity Editor',
                path = vim.fn.getcwd() .. "/Library/EditorInstance.json"
            }
        }

        -- Basic debugging keymaps, feel free to change to your liking!
        vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
        vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<F9>', dap.step_out, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<leader>dl', function()
            dap.set_breakpoint(nil, nil,vim.fn.input 'Log point message: ')
        end, { desc = 'Debug: Set Log point' })
        vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'Debug: REPL' })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>B', function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end, { desc = 'Debug: Set Breakpoint' })


        
        vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Open Repl' })
        vim.keymap.set('n', "<leader>dw", function() require("dap.ui.widgets").hover() end, { desc = "Widgets" })

        -- configure column signs
        local sign = vim.fn.sign_define
        sign("DapBreakpoint", { text = "█", texthl = "DapBreakpoint", linehl = "", numhl = "DapBreakpoint" })
        sign("DapBreakpointCondition", { text = "█", texthl = "DapBreakpointCondition", linehl = "", numhl = "DapBreakpointCondition" })
        sign("DapLogPoint", { text = "█", texthl = "DapLogPoint", linehl = "", numhl = "DapLogPoint" })
        sign("DapStopped", { text = "⇛", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

        local ok, _ = pcall(require, "catppuccin.palettes")
        if ok then
            local macchiato = require("catppuccin.palettes").get_palette("macchiato")
            vim.api.nvim_set_hl(0, "DapBreakpoint", {  fg = macchiato.red})
            vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = macchiato.peach})
            vim.api.nvim_set_hl(0, "DapLogPoint", { fg = macchiato.green })
            -- vim.api.nvim_set_hl(0, "DapStopped", { link = "Cursor" })
            vim.api.nvim_set_hl(0, "DapStopped", { bg=macchiato.surface1 })
        end

        -- Reference for additional dap setup: https://github.com/aaronmcadam/dotfiles/blob/c883d941764fa0153991c6ee91cd8dcb27c174c3/nvim/.config/nvim/lua/azvim/plugins/configs/dap.lua#L23
        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup {
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don't feel like these are good choices.
            icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                    disconnect = '⏏',
                },
            },
        }

        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- Install golang specific config
        require('dap-go').setup()
    end,
}
