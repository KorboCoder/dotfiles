--- @type LazyPluginSpec[] | LazyPluginSpec
return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        branch = 'master',
        version = 'v0.9.*',
        build = ':TSUpdate',
		configs =function ()
			local configs = require("nvim-treesitter.configs")
			configs.setup({});
			require 'nvim-treesitter.install'.compilers = { 'clang++'}
		end


    },
    {
        enabled=false,
        "nvim-treesitter/playground",
    },
}
