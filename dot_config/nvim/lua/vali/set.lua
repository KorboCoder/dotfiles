vim.g.editorconfig = true -- use .editorconfig file

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.ruler = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.clipboard = "unnamedplus" -- synvc with system clipboard by defaut (no need to use + register)

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

vim.opt.updatetime = 500

vim.opt.colorcolumn = "80,110"
vim.opt.cursorcolumn = true

-- diagnostics setup
vim.diagnostic.config({
	signs = false,    
})

vim.opt.completeopt = 'menu,menuone,preview'

vim.opt.binary = true
-- indent setup
vim.opt.list = true
vim.opt.listchars:append "space:·"
-- vim.opt.listchars:append "multispace:···"
-- vim.opt.listchars:append "trail:•"
vim.opt.listchars:append "precedes:«"
vim.opt.listchars:append "extends:»"
vim.opt.listchars:append "tab:··"
-- vim.opt.listchars:append "tab:··»"
vim.opt.listchars:append "nbsp:␣"
-- vim.opt.listchars:append "eol:↴"

-- Reference: https://stackoverflow.com/questions/76028722/how-can-i-temporarily-disable-netrw-so-i-can-have-telescope-at-startup
-- Disable netrw
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrw = 1

-- https://www.reddit.com/r/neovim/comments/15ue6vh/guys_i_need_a_nvim_plugin_to_highlight_the_words/
vim.opt.diffopt = {
  'internal', 'filler', 'vertical', 'linematch:60', 'closeoff'
  -- the default uses 'closeoff' which will automatically
  -- stop showing diffs when you only have one diff window remaining.
}
