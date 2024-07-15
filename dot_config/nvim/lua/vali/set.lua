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

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 500

-- column indicator to see if text is pass limit
vim.opt.colorcolumn = "80,110"
vim.opt.cursorcolumn = true

vim.diagnostic.config({
	signs = false,
})

vim.opt.completeopt = 'menu,menuone,preview'

-- this is so we can see CRLF in files
vim.opt.binary = true

-- indent setup
vim.opt.list = true

-- set whitespace and overflow chars
vim.opt.listchars:append {
	space = "·",
	-- multispace = "···",
	-- trail = "•",
	precedes = "«",
	extends = "»",
	tab = "··",
	-- tab = "··»",
	nbsp = "␣",
	-- eol = "↴",
}

-- https://www.reddit.com/r/neovim/comments/15ue6vh/guys_i_need_a_nvim_plugin_to_highlight_the_words/
vim.opt.diffopt = {
  'internal', 'filler', 'vertical', 'linematch:60', 'closeoff'
  -- the default uses 'closeoff' which will automatically
  -- stop showing diffs when you only have one diff window remaining.
}
