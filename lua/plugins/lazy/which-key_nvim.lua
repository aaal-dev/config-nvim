local utils = require 'plugins.lazy.utils'

return {
    "folke/which-key.nvim",
    lazy = true,
    module = "which-key",
    keys = { '<leader>' },
    opts = {
        icons = {
            -- symbol used in the command line area that shows your active
            -- key combo
            breadcrumb = "»",

            -- symbol used between a key and it's label
            separator = "  ",

            -- symbol prepended to a group
            group = "+",
        },

        popup_mappings = {
            scroll_down = "<c-d>", -- binding to scroll down inside the popup
            scroll_up = "<c-u>", -- binding to scroll up inside the popup
        },

        window = {
            border = 'none',
        },

        layout = {
            spacing = 6, -- spacing between columns
        },

        hidden = {
            "<silent>",
            "<cmd>",
            "<Cmd>",
            "<CR>",
            "call",
            "lua",
            "^:",
            "^ ",
        },

        triggers_blacklist = {
            -- list of mode / prefixes that should never be hooked by WhichKey
            i = { "j", "k" },
            v = { "j", "k" },
        },
    },
}
