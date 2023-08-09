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
vim.opt.ignorecase = true

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


-- suppose to be the default highlight for LspInlayHint but background is not being set
-- decided to set the default manually here
local hint_bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg
local hint_fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg
vim.api.nvim_set_hl(0, "LspInlayHint", { bg = hint_bg, fg = hint_fg })

-- Set groovy as language for Jenkinsfile*
vim.api.nvim_command('au BufNewFile,BufRead Jenkinsfile* setf groovy')

-- Reference: https://stackoverflow.com/questions/76028722/how-can-i-temporarily-disable-netrw-so-i-can-have-telescope-at-startup
-- Disable netrw
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- Open Telescope on startup if the first argument is a directory
-- Reference: https://www.reddit.com/r/neovim/comments/zco47a/open_neovim_into_folder_with_telescope_open_in/
local ts_group = vim.api.nvim_create_augroup("TelescopeOnEnter", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        local first_arg = vim.v.argv[3]
        if first_arg and vim.fn.isdirectory(first_arg) == 1 then
            -- Vim creates a buffer for folder. Close it.
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
