vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.ruler = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.showmode = false

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.g.indent_blankline_char ='┆'
-- vim.g.indent_blankline_char_list = {'┆', '┊' }

vim.opt.updatetime = 500

vim.opt.colorcolumn = "80,125,125"

vim.o.completeopt = 'menu,menuone,preview'

-- indent setup
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

-- Enable preview at start for oil
-- vim.api.nvim_create_autocmd("User", {
--     pattern = "OilEnter",
--     callback = vim.schedule_wrap(function(args)
--         local oil = require("oil")
--         if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
--             oil.select({ preview = true })
--         end
--     end),
-- })


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


local lspconfig = require('lspconfig')
lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        require("lsp-inlayhints").on_attach(client, bufnr)
    end,
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            }
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            }
        }
    }
})
