-- setup leaders before anything else
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- setup plugins
require("vali.lazy")


-- set vim configurations
require("vali.set")
-- setup autocommands
--
require("vali.autocommands")

-- setup commands
require("vali.commands")

-- setup key mappings
require("vali.remap");

