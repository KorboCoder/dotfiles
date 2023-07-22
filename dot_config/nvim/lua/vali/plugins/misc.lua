-- Plugisn to check out:
-- https://alpha2phi.medium.com/neovim-for-beginners-lsp-part-2-37f9f72779b6#aae3
-- inlay hints
-- telescope-file-browser.nvim
-- telescope-ui-select.nvim or dressing.nvim
-- config template: dope, https://www.youtube.com/watch?app=desktop&v=Vghglz2oR0c, https://github.com/ChristianChiarulli/nvim/tree/1631262e8df1de2ad0ecfd5f7dffd9c4476d7933

return {

    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = "markdown",
        lazy = true,
        keys = { { "gm", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" } },
        config = function()
            vim.g.mkdp_auto_close = true
            vim.g.mkdp_open_to_the_world = false
            vim.g.mkdp_open_ip = "127.0.0.1"
            vim.g.mkdp_port = "8888"
            vim.g.mkdp_browser = ""
            vim.g.mkdp_echo_preview_url = true
            vim.g.mkdp_page_title = "${name}"
        end,
    },
    {
        "mbbill/undotree"
    },
}
