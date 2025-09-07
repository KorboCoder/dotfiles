--- @type LazyPluginSpec[] | LazyPluginSpec
return {

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {},

        config = function()
            require("catppuccin").setup({
				default_integrations = true,
                flavour = "macchiato",
                transparent_background = true,
                term_colors = true,
                dim_inactive = {
                    enabled = false,
                    shade = "dark",
                    percentage = 0.75
                },
                integrations = {
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = true
                    },
					gitsigns = true,
                    harpoon = true,
                    neotest = true,
                    illuminate = true,
                    which_key = true,
                    noice = true,
                    notify = true,
                    dropbar = {enabled = true},
                    dap = true,
                    fidget = true,
                    mason = true,
                    lsp_trouble = true,
                    native_lsp = {
                        enabled = true,
                        -- virtual_text = {
                        --     errors = { "italic" },
                        --     hints = { "italic" },
                        --     warnings = { "italic" },
                        --     information = { "italic" },
                        --     ok = { "italic" },
                        -- },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                            ok = { "underline" },
                        },
                        inlay_hints = {
                            background = true,
                        },
                    },

				},
				custom_highlights = function(colors)
					-- NOTE: this is used somewhere, refactor this eventually to a generic utils folder
					-- Used functions from tint.nvim to adjust indent lint colors
					local tint_func= require("tint.transforms").tint(-60)
					local sat_func = require("tint.transforms").saturate(0.6)
					local hex_to_rgb = require("tint.colors").hex_to_rgb
					local rgb_to_hex = require("tint.colors").rgb_to_hex
					local custom_transform = function(hex)
						local r,g,b = hex_to_rgb(hex)
						local r1,g1,b1 = sat_func(tint_func(r, g, b))
						local res = rgb_to_hex(r1,g1,b1)
						return res
					end
					return {
						DiagnosticVirtualTextError = {  blend=0, fg=custom_transform(colors.red)},
						DiagnosticVirtualTextWarn = {  blend=0, fg=custom_transform(colors.yellow)},
						DiagnosticVirtualTextOk = {  blend=0, fg=custom_transform(colors.green)},
						DiagnosticVirtualTextInfo = {  blend=0, fg=custom_transform(colors.green)},
						DiagnosticVirtualTextHint = {  blend=0, fg=custom_transform(colors.green)},
					}
				end
			})
			vim.cmd([[colorscheme catppuccin-macchiato]])

            -- vim.cmd('hi LspInlayHint gui=italic')
			local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end
			vim.api.nvim_set_hl(0, 'LspInlayHint', { fg=h('Comment').fg, bg=h('CursorLine').bg, italic = true})
        end
    }
}
