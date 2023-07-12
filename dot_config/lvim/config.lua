-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.opt.relativenumber = true


lvim.plugins = {
  "vim-test/vim-test",
  "nvim-neotest/neotest",
  "nvim-neotest/neotest-jest",
}



local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "eslint", filetypes = { "typescript", "typescriptreact" } }
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "prettier",
    filetypes = { "typescript", "typescriptreact" },
  },
}

local test = require "neotest"

test.setup(
  {
    adapters = {
      require('neotest-jest')({
        jestCommand = "npm test --",
        jestConfigFile = "jest.config.ts",
        env = { CI = true },
        cwd = function(path)
          return vim.fn.getcwd()
        end,
      })
    }
  }
)
lvim.builtin.which_key.mappings["t"] = {
  name = "Test",
  n = { "<cmd>lua require('neotest').run.run()<cr>", "Nearest" },
  f = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "File" },
  w = { "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>", "Watch" },
  d = { "<cmd>lua require('neotest').run.run({strategy = \"dap\"})<cr>", "Debug" }
}
