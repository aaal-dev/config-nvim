return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        cmd = {
            'TSInstall',
            'TSBufEnable',
            'TSBufDisable',
            'TSEnable',
            'TSDisable',
            'TSModuleInfa',
        },
        event = 'BufReadPost',
        version = false,
        opts = {
            auto_install = true,
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = true,
    },
}
