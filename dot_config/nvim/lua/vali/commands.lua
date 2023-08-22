--https://www.reddit.com/r/neovim/comments/15ue6vh/guys_i_need_a_nvim_plugin_to_highlight_the_words/
vim.api.nvim_create_user_command('DiffOrig', function()
    local scratch_buffer = vim.api.nvim_create_buf(false, true)                             -- create a scratch buffer
    vim.api.nvim_buf_set_name(scratch_buffer, "diff-orig_" .. vim.api.nvim_buf_get_name(0)) -- set name of scracth buffer
    vim.api.nvim_buf_set_keymap(
        scratch_buffer, "n", "q", ':bw<CR>', { desc = "Close Buffer", silent = true }
    )                                             -- map q to close
    local current_ft = vim.bo
        .filetype                                 -- get the filetype of our current buffer
    vim.cmd('vertical sbuffer' .. scratch_buffer) -- open our scratch buffer in a split
    vim.bo[scratch_buffer].filetype =
        current_ft                                -- then set our scratch buffer to the same file type
    vim.cmd('read ++edit #')                      -- load contents of previous buffer into scratch_buffer
    vim.cmd.normal('1G"_d_')                      -- delete extra newline at top of scratch_buffer without overriding register
    vim.cmd.diffthis()                            -- scratch_buffer
    vim.cmd.wincmd('p')                           -- execute window
    vim.cmd.diffthis()                            -- current buffer
    vim.cmd.wincmd('w')                           -- execute window
end, {})

vim.keymap.set("n", "<leader>D", function()
    vim.cmd('DiffOrig')
end, { desc = "Diff Orig File" })

-- vim.keymap.set("n", "<leader>D", function()
--     local bufName = "diff-orig_" .. vim.api.nvim_buf_get_name(0)
--     local buffer = find_buffer_by_name(bufName)
--     vim.notify("buffer name " .. bufName)
--     vim.notify("num"..  buffer)
--     if  buffer == -1 then
--         vim.cmd('DiffOrig')
--     else
--         vim.notify("closing " .. vim.fn.bufwinid(buffer))
--         vim.api.nvim_win_close(vim.fn.bufwinid(buffer), true)
--
--     end
-- end, { desc = "Diff Orig File" })
