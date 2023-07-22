return {
    {
        -- the best search
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            defaults = {
                layout_strategy = "flex",
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = { width = 0.95, height = 0.95, prompt_position = 'top' }
                },
            },
            extensions = {
                file_browser = {
                    hijack_netrw = true
                }
            }
        },
    }
}
