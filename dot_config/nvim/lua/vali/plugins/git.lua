--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    -- git integration
    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
        keys = {
            { "<leader>gs", "<cmd>Git<CR>",         desc = "Git Status" },
            { "<leader>go", ":GBrowse<CR>",         desc = "Open in browser", mode = { "n", "v" } },
            { "<leader>gd", "<cmd>Gvdiffsplit<CR>", desc = "Git Diff" },
            -- { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git Blame" },
            -- { "<leader>gp", "<cmd>G push<CR>",      desc = "Git Push" },
            -- { "<leader>gr", "<cmd>Gread<CR>",       desc = "Git Read" },
            -- { "<leader>gw", "<cmd>Gwrite<CR>",      desc = "Git Write" },
        },
    },
    {
        "sindrets/diffview.nvim",
        cmd = {"DiffviewOpen"}
    },
    -- show git changes in the sign column
    {
        'lewis6991/gitsigns.nvim',
		branch = 'main',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
			signs_staged = {
				add          = { text = '┃' },
				change       = { text = '┃' },
				delete       = { text = '┃' },
				topdelete    = { text = '‾' },
				changedelete = { text = '~' },
				untracked    = { text = '┆' },
			},
			signs_staged_enable = true,
			signcolumn = true,
            numhl = true,
            -- linehl = true,
			current_line_blame = false, 
            current_line_blame_opts = {
                virt_text_pos = 'right_align',
                delay = 100,
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- stylua: ignore start
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Prev Hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                map("n", "<leader>gtd", gs.toggle_deleted, "Toggle Deleted")
                map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle Line Blame")
                map("n", "<leader>gth", gs.toggle_linehl, "Toggle Highlights")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end
        },
    },
    -- open github with GBrowse
    {
        "tpope/vim-rhubarb"
    },
    -- add bitbucket support to fugitive
    {
        "tommcdo/vim-fubitive"
    },
    -- view blame
    {
        "FabijanZulj/blame.nvim",
        keys  = {
            { "<leader>gb", "<cmd>BlameToggle virtual<CR>", desc = "Git Blame" },
        },
        config = function()
            local blame = require("blame")
            blame.setup({
                date_format = "%d/%m/%y",
                -- max_summary_width = 60,
                -- commit-date-author-message
                format_fn = function(line_porcelain, config, idx)
                    local hash = string.sub(line_porcelain.hash, 0, 7)
                    local line_with_hl = {}
                    local is_commited = hash ~= "0000000"
                    if is_commited then
                        local summary
                        local committer_mail
                        if #line_porcelain.summary > config.max_summary_width then
                            summary = string.sub(
                                line_porcelain.summary,
                                0,
                                config.max_summary_width - 1
                            )

                            summary = string.match(summary, "^%s*(.-)%s*$") -- trim
                            summary = summary .. "…"
                        else
                            summary = line_porcelain.summary
                        end
                        if #line_porcelain.committer_mail > 10 then
                            committer_mail = string.sub(
                                line_porcelain.committer_mail,
                                0,
                                10 - 1
                            )
                            committer_mail = string.match(committer_mail, "^%s*(.-)%s*$") -- trim
                            committer_mail = committer_mail .. "…"
                        else
                            committer_mail = line_porcelain.committer_mail
                        end
                        line_with_hl = {
                            idx = idx,
                            values = {
                                {
                                    textValue = hash,
                                    hl = hash,
                                },
                                {
                                    textValue = os.date(
                                        config.date_format,
                                        line_porcelain.committer_time
                                    ),
                                    hl = "Comment",
                                },
                                {
                                    textValue = committer_mail,
                                    hl = "Comment",
                                },
                                {
                                    textValue = summary,
                                    hl = hash,
                                },
                            },
                            format = "%s  %s",
                        }
                    else
                        line_with_hl = {
                            idx = idx,
                            values = {
                                {
                                    textValue = "Not commited",
                                    hl = "Comment",
                                },
                            },
                            format = "%s",
                        }
                    end
                    return line_with_hl
                end 
            })

        end
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			-- { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
			{ "<space>gC", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit CurrentFileCommits" }
		}
	}
}
