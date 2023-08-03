vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.editorconfig = true -- use .editorconfig file
vim.opt.smartindent = true
vim.opt.formatoptions = "jcroqlnt" -- tcqj

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "screen"

vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

vim.opt.showmode = false

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.g.indent_blankline_char ='┆'
-- vim.g.indent_blankline_char_list = {'┆', '┊' }

vim.opt.updatetime = 500

vim.opt.colorcolumn = "80,125"

vim.o.completeopt = 'menu,menuone,preview'

-- indent setup
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("vali_last_loc", {clear = true}),
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- suppose to be the default highlight for LspInlayHint but background is not being set
-- decided to set the default manually here
local hint_bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg
local hint_fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
vim.api.nvim_set_hl(0, "LspInlayHint", { bg = hint_bg, fg = hint_fg })

-- Set groovy as language for Jenkinsfile*
vim.api.nvim_command('au BufNewFile,BufRead Jenkinsfile* setf groovy')

-- telescope on neovim enter

-- Reference: https://www.reddit.com/r/neovim/comments/zco47a/open_neovim_into_folder_with_telescope_open_in/
-- local is_git_dir = function()
--     return os.execute('git rev-parse --is-inside-work-tree >> /dev/null 2>&1')
-- end
-- vim.api.nvim_create_autocmd('VimEnter', {
--     callback = function()
--         local bufferPath = vim.fn.expand('%:p')
--         if vim.fn.isdirectory(bufferPath) ~= 0 then
--             local ts_builtin = require('telescope.builtin')
--             vim.api.nvim_buf_delete(0, { force = true })
--             if is_git_dir() == 0 then
--                 ts_builtin.git_files({ show_untracked = true })
--             else
--                 ts_builtin.find_files()
--             end
--         end
--     end,
-- })

-- Reference: https://stackoverflow.com/questions/76028722/how-can-i-temporarily-disable-netrw-so-i-can-have-telescope-at-startup
-- Disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- Open Telescope on startup if the first argument is a directory
local ts_group = vim.api.nvim_create_augroup("TelescopeOnEnter", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        local first_arg = vim.v.argv[3]
        if first_arg and vim.fn.isdirectory(first_arg) == 1 then
            -- Vim creates a buffer for folder. Close it.
            vim.cmd(":bd 1")
            require("telescope.builtin").find_files({ search_dirs = { first_arg } })
        end
    end,
    group = ts_group,
});

-- local lspconfig = require('lspconfig')
-- lspconfig.tsserver.setup({
--     settings = {
--         typescript = {
--             inlayHints = {
--                 includeInlayParameterNameHints = 'all',
--                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--                 includeInlayFunctionParameterTypeHints = true,
--                 includeInlayVariableTypeHints = true,
--                 includeInlayVariableTypeHintsWhenTypeMatchesName = false,
--                 includeInlayPropertyDeclarationTypeHints = true,
--                 includeInlayFunctionLikeReturnTypeHints = true,
--                 includeInlayEnumMemberValueHints = true,
--             }
--         },
--         javascript = {
--             inlayHints = {
--                 includeInlayParameterNameHints = 'all',
--                 includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--                 includeInlayFunctionParameterTypeHints = true,
--                 includeInlayVariableTypeHints = true,
--                 includeInlayVariableTypeHintsWhenTypeMatchesName = false,
--                 includeInlayPropertyDeclarationTypeHints = true,
--                 includeInlayFunctionLikeReturnTypeHints = true,
--                 includeInlayEnumMemberValueHints = true,
--             }
--         }
--     }
-- })
