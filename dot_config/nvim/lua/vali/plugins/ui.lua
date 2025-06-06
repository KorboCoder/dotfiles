--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    -- for nice vim.ui.select and vim.ui.input
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    -- fade background of unselected window
    {
        enabled = true,
        "levouh/tint.nvim",
        opts = {
            tint = -20,
            saturation = 0.5
        }
    },
    -- tmux like border for active window
    {
        "nvim-zh/colorful-winsep.nvim",
        config = true,
        event = { "WinNew" },
    },
    -- pretter context line at the bottom
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                globalstatus = true,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { 
                    {
                        "branch", 
                        fmt = function(branch_name, ctx)
                            local max_length = 18 -- Set the max length for branch names
                            if #branch_name > max_length then
                                return string.sub(branch_name, 1, max_length) .. '…'
                            end
                            return branch_name
                        end,
                    },
                    "diff" 
                },
                lualine_c = {
                    {
                        "diagnostics",
                        -- symbols = {
                        --     error = icons.diagnostics.Error,
                        --     warn = icons.diagnostics.Warn,
                        --     info = icons.diagnostics.Info,
                        --     hint = icons.diagnostics.Hint,
                        -- },
                    },
                    {
                        "filetype",
                        icon_only = false,
                        icon = { align = 'right' },
                        padding = {
                            left = 1, right = 0 }
                    },
                    { "filename", newfile_status = true, symbols = { modified = "📝", readonly = " 🔒", unnamed = "🤷", newFile = "📄"} },
                    { "grapple" }
                    -- stylua: ignore
                    -- {
                    --     function() return require("nvim-navic").get_location() end,
                    --     cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
                    -- },
                },
                lualine_x = {
                    -- stylua: ignore
                    {
                        function() return require("noice").api.status.command.get() end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                        -- color = Util.fg("Statement"),
                    },
                    -- stylua: ignore
                    {
                        function() return require("noice").api.status.mode.get() end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                        -- color = Util.fg("Constant"),
                    },
                    -- stylua: ignore
                    {
                        function() return "  " .. require("dap").status() end,
                        cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
                        -- color = Util.fg("Debug"),
                    },
                    {
                        require("lazy.status").updates,
                        cond = require("lazy.status").has_updates,
                        -- color = Util.fg("Special")
                    },
                    -- {
                    --     "diff",
                    --     -- symbols = {
                    --     --     added = icons.git.added,
                    --     --     modified = icons.git.modified,
                    --     --     removed = icons.git.removed,
                    --     -- },
                    -- },
                },
                lualine_y = {
                    {
                    -- Yoinked from:  https://github.com/LunarVim/LunarVim/blob/420817e617dcc05fa110b59f3e7af64096d3f2ea/lua/lvim/core/lualine/components.lua
                    -- for knowing which language server is attached
						function()
							local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
							if #buf_clients == 0 then
								return "LSP Inactive"
							end

							local buf_ft = vim.bo.filetype
							local buf_client_names = {}
							local copilot_active = false

							-- add client
							for _, client in pairs(buf_clients) do
								if client.name ~= "null-ls" and client.name ~= "copilot" then
									table.insert(buf_client_names, client.name)
								end

								if client.name == "copilot" then
									copilot_active = true
								end
							end

							-- -- add formatter
							-- local formatters = require "lvim.lsp.null-ls.formatters"
							-- local supported_formatters = formatters.list_registered(buf_ft)
							-- vim.list_extend(buf_client_names, supported_formatters)
							--
							-- -- add linter
							-- local linters = require "lvim.lsp.null-ls.linters"
							-- local supported_linters = linters.list_registered(buf_ft)
							-- vim.list_extend(buf_client_names, supported_linters)

							local unique_client_names = table.concat(buf_client_names, ", ")
							local language_servers = string.format("[%s]", unique_client_names)

							-- if copilot_active then
							--     language_servers = language_servers .. "%#SLCopilot#" .. " " .. lvim.icons.git.Octoface .. "%*"
							-- end

							return language_servers
						end,
						color = { gui = "bold" },
					},
					{
						'fileformat',
						icons_enabled = true,
						symbols = {
							unix = 'LF',
							dos = 'CRLF',
							mac = 'CR',
						},
					},
                },
                lualine_z = {
                    {"encoding"},
						-- {
                    --     'vim.fn["codeium#GetStatusString"]()',
                    --     fmt = function(str)
                    --         return "suggestions " .. str:lower():match("^%s*(.-)%s*$")
                    --     end
                    --
                    -- },
                    -- { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
					{
						-- yoinked this from the original progress function, but 
						-- returned the total instead of percent
						function()
							local cur = vim.fn.line('.')
							local total = vim.fn.line('$')
							if cur == 1 then
								return 'Top'
							elseif cur == total then
								return 'Bot'
							else
								return total
								-- return string.format('%2d%%%%', math.floor(cur / total * 100))
							end
						end,
						separator = '',
					},
					{ "location", padding = { left = 0, right = 1 } },
                }
            },
            extensions = { "lazy", "toggleterm", "nvim-dap-ui", "fugitive" },
        }
    },
    {
        'Bekaboo/dropbar.nvim',
        event = { "BufReadPost", "BufNewFile" },
        -- enabled =  false,
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim'
        },
        opts = {
            general = {
                ---@type boolean|fun(buf: integer, win: integer, info: table?): boolean
                enable = function(buf, win, _)
                    return vim.fn.win_gettype(win) == ''
                        and vim.wo[win].winbar == ''
                        and vim.bo[buf].bt == ''
                        and (
                        vim.bo[buf].ft == 'markdown'
                        or (
                        buf
                        and vim.api.nvim_buf_is_valid(buf)
                        -- removed this to allow dropbar even if there's no treesitter active, this is so
                        -- we can at least see filepath for ordinary files, or if for some reason treesitter fails
                        -- and (pcall(vim.treesitter.get_parser, buf, vim.bo[buf].ft))
                        and true
                        or false
                    )
                    )
                end,
            },
			sources = {
				path = {
					modified = function(sym)
						return sym:merge({
							name = sym.name .. '📝',
							-- icon = ' ',
							name_hl = '@comment.warning.gitcommit',
							icon_hl = '@comment.warning.gitcommit',
							-- ...
						})
					end
				}
			}

        }
    },
    {
        "SmiteshP/nvim-navic",
        enabled = false,
        lazy = true,
        init = function()
            vim.g.navic_silence = true
        end,
        opts = function()
            return {
                lsp = {
                    auto_attach = true
                },
                separator = " ",
                highlight = true,
                depth_limit = 5,
            }
        end
    },
    {
        "utilyre/barbecue.nvim",
        enabled = false,
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            show_dirname = false,
        },
    },
    -- nice icons
    {
        "nvim-tree/nvim-web-devicons"
    },
    -- pretty indentations
    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        version = '2.*',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help indent_blankline.txt`
        opts = {
            show_trailing_blankline_indent = false,
        },
        config = function()
            require("indent_blankline").setup {
                space_char_blankline = " ",
                show_current_context = false,
                show_current_context_start = false,
                char_highlight_list = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                    "IndentBlanklineIndent3",
                    "IndentBlanklineIndent4",
                    "IndentBlanklineIndent5",
                    "IndentBlanklineIndent6",
                },
            }
            vim.g.indent_blankline_char ='┆'
            -- vim.g.indent_blankline_char_list = {'┆', '┊' }

            -- Used functions from tint.nvim to adjust indent lint colors
            local tint_func= require("tint.transforms").tint(-100)
            local sat_func = require("tint.transforms").saturate(0.4)
            local hex_to_rgb = require("tint.colors").hex_to_rgb
            local rgb_to_hex = require("tint.colors").rgb_to_hex
            local custom_transform = function(hex)
                local r,g,b = hex_to_rgb(hex)
                local r1,g1,b1 = sat_func(tint_func(r, g, b))
                local res = rgb_to_hex(r1,g1,b1)
                return res
            end

            local ok, _ = pcall(require, "catppuccin.palettes")
            if ok then
                local macchiato = require("catppuccin.palettes").get_palette "macchiato"

                vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { blend = 0, fg=custom_transform(macchiato.yellow)})
                vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { blend = 0, fg=custom_transform(macchiato.red)})
                vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { blend = 0, fg=custom_transform(macchiato.teal)})
                vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { blend = 0, fg=custom_transform(macchiato.peach)})
                vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { blend = 0, fg=custom_transform(macchiato.blue)})
                vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { blend = 0, fg=custom_transform(macchiato.pink)})
            end

            -- dunno where to put this, migrate this where it makes sense
            -- vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#303347"})
        end
    },
    -- change cursorlinenumber depending on mode
    {
        'mawkler/modicator.nvim',
        init = function()
            -- These are required for Modicator to work
            vim.o.cursorline = true
            vim.o.number = true
            vim.o.termguicolors = true
        end,
        opts = {}
    },
    -- highlight/underline other instance of selected word
    {
        'RRethy/vim-illuminate'
    },
    -- popup what keymaps do
    {
        "folke/which-key.nvim",
        opts = {
			preset = "helix",
			win  = { border = "double" }
        },
    },
    -- better  ui for messages, cmdline and popupmenu
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                progress = {
                    enabled = false
                },
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = false,        -- use a classic bottom cmdline for search
                command_palette = false,      -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,        -- disable lsp doc border since we have another plugi handling it
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            {
                "rcarriga/nvim-notify",
                opts = {
                    fps = 60,
                    background_colour = "#000000",
                    stages = "fade_in_slide_out",
                    top_down = false
                },
                keys = {
                    { "<leader>cn", function() require("notify").dismiss({ silent = true }) end, desc = "Clear Notifs" }
                }
            },
        }
    },
    -- focus on one bufffer
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 0.9
            },
            plugins = {
                tmux = { enabled = true }
            },
            -- TODO: Update  this to auto commands
            -- callback where you can add custom code when the Zen window opens
            on_open = function(win)
                -- show symbol-usage
                local ok, buf = pcall(require, "symbol-usage.buf")
                if not ok then return end;
                local bufnr = vim.api.nvim_get_current_buf()
                buf.clear_buffer(bufnr)
            end,
            -- callback where you can add custom code when the Zen window closes
            on_close = function()
                -- hide symbol-usage
                local ok, buf = pcall(require, "symbol-usage.buf")
                if not ok then return end;
                local bufnr = vim.api.nvim_get_current_buf()
                buf.attach_buffer(bufnr)
            end,
        },
        keys = {
            { 'gz', ':ZenMode<CR>', desc = "Zen Mode" }
        }
    },
    -- animated ui
    {
        enabled = false,
        'echasnovski/mini.animate',
        version = '*',
        config = true
    },
    {
        "tris203/precognition.nvim",
        enabled=false,
        keys = {
            { "<leader>P", function() require("precognition").peek() end, desc = "Precognition Peek" }
        }
    },
    -- make virt column thin
    { "lukas-reineke/virt-column.nvim", 
        config = function()
            require('virt-column').setup({
                enabled = true,
                highlight = 'VirtColumn'
            })
            local cursor_hl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
            vim.api.nvim_set_hl(0, "VirtColumn", { fg = cursor_hl.bg })
            vim.api.nvim_set_hl(0, "CursorColumn", cursor_hl)
        end

    },
    --colorizer
    {
        "norcalli/nvim-colorizer.lua",
    },
    {
        "sphamba/smear-cursor.nvim",
        opts = {                                -- Default  Range
            stiffness = 0.8,                      -- 0.6      [0, 1]
            trailing_stiffness = 0.5,             -- 0.4      [0, 1]
            stiffness_insert_mode = 0.6,          -- 0.4      [0, 1]
            trailing_stiffness_insert_mode = 0.6, -- 0.4      [0, 1]
            distance_stop_animating = 0.5,        -- 0.1      > 0
            legacy_computing_symbols_support = true,

            transparent_bg_fallback_color = "#303030",
        },
    }
}
