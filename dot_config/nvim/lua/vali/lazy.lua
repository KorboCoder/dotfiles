-- lazy path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- install lazy
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- setup plugins
-- TODO: look into stuff i can disable for performance
require("lazy").setup("vali.plugins", {
    ui = {
        border = "single"
    }
})
