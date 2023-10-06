local M = {}

M.load = function(plugins_list)
    local utils = require "plugins.lazy.utils"
    local _ = utils.check_bootstrap()

    local plugins = {}
    for _, plugin_name in ipairs(plugins_list) do
        local plugin_options = require("plugins.lazy." .. plugin_name)
        table.insert(plugins, plugin_options)
    end

    local options = {
        checker = { enable = true },
        performance = {
            rtp = {
                disabled_plugins = {
                    "2html_plugin",
                    "bugreport",
                    "compiler",
                    "ftplugin",
                    "getscript",
                    "getscriptPlugin",
                    "gzip",
                    "logipat",
                    "matchit",
                    "netrw",
                    "netrwPlugin",
                    "netrwSettings",
                    "netrwFileHandlers",
                    "optwin",
                    "rplugin",
                    "rrhelper",
                    "spellfile_plugin",
                    "synmenu",
                    "syntax",
                    "tar",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "vimball",
                    "vimballPlugin",
                    "zip",
                    "zipPlugin",
                },
            },
        },
        ui = {
            border = utils.create_border('rounded', 'FloatBorder'),
            title = ' Lazy ',
            icons = {
              ft = "",
              lazy = "󰂠 ",
              loaded = "",
              not_loaded = "",
            },
        },
    }

    utils.setup('lazy', plugins, options)

    vim.keymap.set(
        "n",
        "<leader>z",
        "<cmd>:Lazy<cr>",
        { desc = "Plugin Manager" }
    )
end

return M
