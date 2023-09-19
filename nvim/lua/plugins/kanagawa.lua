return {
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        config = function ()
            vim.cmd([[colorscheme kanagawa]])
        end,
    },
    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "kanagawa",
        },
    }
}
