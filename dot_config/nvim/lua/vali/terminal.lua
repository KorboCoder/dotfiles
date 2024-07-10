-- Reference: https://github.com/LunarVim/LunarVim/blob/d663929036e23bd54427cf3e78dedf5b34ab97fc/lua/lvim/core/terminal.lua#L101
local M = {}

local Terminal = require("toggleterm.terminal").Terminal
local curr_term = nil
local NO_SESSION = "no-session"

-- create a terminal instance
local create_terminal = function(name, toggletermId)
  local tempterm = Terminal:new {
    cmd = name,
    hidden = true,
    direction = "float",
    env = {
        TOGGLETERM_ID = toggletermId
    },
    float_opts = {
      border = "double",
            width = function()
                return math.floor(vim.o.columns * 0.9)
            end,
            height = function()
                return math.floor(vim.o.lines * 0.9)
            end,
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_)
        -- on close remove whatever is ther current terminal, if there are bugs
        -- on unregistering other terminals can do additional id checks here
        curr_term = nil;
    end,
    count = 99,
  }
  return tempterm
end
local additional_args = {}

-- map terminal instances here for persistance
local terminal_map = {
    default = create_terminal(nil, vim.fn.getcwd()),
    lazygit = create_terminal('lazygit', NO_SESSION),
    lazydocker = create_terminal('lazydocker', NO_SESSION)
}

-- function for toggleling terminals
M.cmd_toggle = function(cmd)
    -- if no cmd param set a 'default'
    cmd = cmd or "default"

    -- if there's an existing terminal toggle it
    if(curr_term) then
        curr_term:toggle();
        return;
    end

    local selected_term = nil;

    if (terminal_map[cmd]) then
        selected_term = terminal_map[cmd];
    else
        vim.notify("Terminal for " .. cmd .. " doesn't exist in map", vim.log.levels.ERROR);
        return
    end

    curr_term = selected_term;
    selected_term:toggle();


end

return M

