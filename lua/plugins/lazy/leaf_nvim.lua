return {
    'daschw/leaf.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme leaf]])
    end,
}
