return {
    'nvim-tree/nvim-tree.lua',
    cmd = {
      "NvimTreeToggle",
      "NvimTreeFocus"
    },
    keys = {
        { '<C-n>', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle nvim-tree' },
        { '<leader>e', '<cmd>NvimTreeFocus<CR>', desc = 'Focus nvim-tree' },
    },
    opts = {
        filters = {
            dotfiles = false,
        },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
            enable = true,
            update_root = false,
        },
        view = {
            adaptive_size = false,
            side = 'left',
            width = 30,
            preserve_window_proportions = true,
        },
        git = { enable = true },
        filesystem_watchers = { enable = true },
        actions = {
            open_file = {
                resize_window = true,
            },
        },
        renderer = {
            root_folder_label = false,
            highlight_git = true,
            highlight_opened_files = 'icon',
            indent_markers = { enable = false },
            icons = {
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                },
                glyphs = {
                    default = '',
                    symlink = '',
                    folder = {
                        default = '',
                        empty = '',
                        empty_open = '',
                        open = '',
                        symlink = '',
                        symlink_open = '',
                        arrow_open = '',
                        arrow_closed = '',
                    },
                    git = {
                        unstaged = "✗",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌",
                    },
                },
            },
        },
    },
    config = function (_, opts)
        require('nvim-tree').setup(opts)

        local api = require'nvim-tree.api'
        api.events.subscribe(api.events.Event.Ready, function (_)
            local utils = require'utils'
            api.tree.change_root(utils.get_root())
        end)
    end
}
