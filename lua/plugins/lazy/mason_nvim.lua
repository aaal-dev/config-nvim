local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
vim.env.PATH = vim.env.PATH
    .. (is_windows and ';' or ':')
    .. vim.fn.stdpath('data')
    .. '/mason/bin'

local utils = require 'plugins.lazy.utils'

return {
    {
        'williamboman/mason.nvim',
        cmd = {
            'Mason',
            'MasonInstall',
            'MasonInstallAll',
            'MasonUninstall',
            'MasonUninstallAll',
            'MasonLog',
        },
        keys = {
            { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' },
        },
        opts = {
            ui = {
                border = utils.create_border('rounded', 'FloatBorder'),
                icons = {
                    package_installed = ' ',
                    package_pending = ' ',
                    package_uninstalled = 'ﮊ ',
                },
                keymaps = {
                    toggle_server_expand = '<CR>',
                    install_package = 'i',
                    update_package = 'u',
                    check_package_version = 'c',
                    update_all_packages = 'U',
                    check_outdated_packages = 'C',
                    uninstall_package = 'U',
                    cancel_installation = '<C-c>',
                    apply_language_filter = '<C-f>',
                    toogle_package_install_log = '<CR>',
                    toggle_help = 'g?',
                },
            },
            max_concurent_installers = 4,
            PATH = 'skip',
        },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        opts = {
            automatic_instalation = true,
        },
    },
}
