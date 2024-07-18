local wk = require('which-key')

-- <NoP> for <space> to prevent going to next line in modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- move selected chunk
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- indent to the right
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })
-- alternative to see if i like this
vim.keymap.set("v", "<s-tab>", "<gv", { noremap = true })
vim.keymap.set("v", "<tab>", ">gv", { noremap = true })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<c-h>", "<C-w>h", { desc = "Go to left window", noremap = true})
vim.keymap.set("n", "<c-j>", "<C-w>j", { desc = "Go to lower window", noremap = true})
vim.keymap.set("n", "<c-k>", "<C-w>k", { desc = "Go to upper window", noremap = true})
vim.keymap.set("n", "<c-l>", "<C-w>l", { desc = "Go to right window", noremap = true})

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-M-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-M-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-M-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-M-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })


vim.keymap.set({"n","x", "i"}, "<C-q>", "<C-6>", { desc = "Toggle between files" })

local leaderN = { prefix = "<leader>", mode = "n" }
local leaderV = { prefix = "<leader>", mode = "v" }
local leaderNV = { prefix = "<leader>", mode = { "n", "v" } }

-- clipboard operations
-- wk.add({ "<leader>x", "\"_x", desc='delete char to void' })

-- wk.add({
-- 	"<leader>",
-- 	{"d","\"_d", desc='delete to void'},
-- 	{"_","\"_", desc='to void register'},
-- 	{'+', "\"+", desc='to system register'},
-- 	mode={"n","v"}
-- })
--
-- wk.add({
-- 	"<leader>",
-- 	{"p","\"_dP", desc='paste without changing register'},
-- 	mode={"v"}
-- })

-- search operations
local builtin = require('telescope.builtin')

wk.add({
	{"<leader>f", group = "Search"},
	{"<leader>ff", builtin.find_files, desc="Files"},
	{"<leader>fb", "<cmd>Telescope buffers<cr>", desc="Buffers"},
	{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc="Diagnostics" },
	{"<leader>ft", builtin.current_buffer_fuzzy_find, desc='Text'},
	{ "<leader>fT", "<cmd>Telescope live_grep<cr>", desc='Global Text' },
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc='Help' },
	{ "<leader>fm", "<cmd>Telescope man_pages<cr>", desc='Man' },
	{ "<leader>fr", "<cmd>Telescope registers<cr>", desc="Registers" },
	{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc="Keymaps" },
	{ "<leader>fc", "<cmd>Telescope commands<cr>", desc="Commands" },
	{ "<leader>fC", "<cmd>Telescope command_history<cr>", desc="Command History" },
	{ "<leader>fn", "<cmd>Noice telescope<cr>", desc="Notif History" },
	{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc="Document Sybols" },
	{ "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc="Workspace Symbols" },

}
)

wk.add({
	{"<leader>t", group="Test"},
	{"<leader>tt", "<cmd>lua require('neotest').run.run({suite = true})<cr>", desc="All" },
	{"<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc="Last" },
	{"<leader>tL", "<cmd>lua require('neotest').run.run_last({strategy = \"dap\"})<cr>", desc="Debug Last" },
	{"<leader>tn", "<cmd>lua require('neotest').run.run()<cr>", desc="Nearest" },
	{"<leader>tN", "<cmd>lua require('neotest').run.run({strategy = \"dap\"})<cr>", desc="Debug Nearest" },
	{"<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc="File" },
	{"<leader>tw", "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>", desc="Watch" },
	{"<leader>td", "<cmd>lua require('neotest').run.run({strategy = \"dap\"})<cr>", desc="Debug" },
	{"<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc="Summary" },
	{"<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc="Output Panel" },
	{"<leader>tO", "<cmd>lua require('neotest').output.open({ enter = true, auto_close = true})<cr>", desc="Output Window" },
})


local terminal = require('vali.terminal')

-- lazygit
vim.keymap.set({ 't', 'i', 'n', 'x' }, '<C-g>', function() terminal.cmd_toggle("lazygit") end,
    { desc = "Lazygit" })

-- lazydocker
vim.keymap.set({ 't', 'i', 'n', 'x' }, '<C-;>', function() terminal.cmd_toggle("lazydocker") end,
    { desc = "Lazydocker" })

-- normal terminal
vim.keymap.set({ 't', 'i', 'n', 'x' }, '<C-Bslash>', terminal.cmd_toggle,
    { desc = "Floating Terminal" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
vim.keymap.set('i', '<M-BS>', '<C-w>', { noremap = true })

-- Reference for following: https://github.com/nvim-lua/kickstart.nvim
-- treesitter
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'comment',
        'jsdoc', 'c_sharp' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>', -- TODO: Check on what this does
            node_decremental = '<M-space>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            }, -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
    },
}

