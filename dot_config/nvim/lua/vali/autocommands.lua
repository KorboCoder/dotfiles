-- autocommands setup, reference: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function augroup(name)
    return vim.api.nvim_create_augroup("vali_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = '*',
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup('last_loc'),
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

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dap-float",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
-- Open Telescope on startup if the first argument is a directory
-- Reference: https://www.reddit.com/r/neovim/comments/zco47a/open_neovim_into_folder_with_telescope_open_in/
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        local first_arg = vim.v.argv[3]
        if first_arg and vim.fn.isdirectory(first_arg) == 1 then
            -- Vim creates a buffer for folder. Close it.
            require("telescope.builtin").find_files({ search_dirs = { first_arg } })
        end
    end,
    group = augroup('telelscope_on_enter'),
});

-- Go visibility hints setup and toggle
pcall(function()
  local hints = require("vali.go_visibility_hints")
  hints.setup({
    -- symbols = { exported = "↑", unexported = "•" },
    -- colors = {
    --   exported = { fg = "#7ee787" },
    --   unexported = { fg = "#9ea7b3" },
    -- },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function(args)
      -- Enable by default and map a toggle
      hints.enable(args.buf)
      vim.keymap.set("n", "<leader>v", function()
        hints.toggle(args.buf)
      end, { buffer = args.buf, desc = "Toggle Go visibility hints" })
    end,
  })

end)

-- macro recording mode indicator 
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    vim.notify("🔴 Recording macro @" .. vim.fn.reg_recording())
  end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    vim.notify("🟢 Stopped recording")
  end,
})


-- golang auto format imports
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("go_format_imports"),
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})

-- vim.api.nvim_create_autocmd('CursorHold', {
--     callback = function()
--         vim.diagnostic.open_float(0, { scope = "cursor", focusable = false })
--     end,
-- })


