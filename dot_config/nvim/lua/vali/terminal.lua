-- Reference: https://github.com/LunarVim/LunarVim/blob/d663929036e23bd54427cf3e78dedf5b34ab97fc/lua/lvim/core/terminal.lua#L101
local M = {}

-- work with lazy git inside the terminal
M.lazygit_toggle = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 100000,
      height = 100000,
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = 99,
  }
  lazygit:toggle()
end
return M

