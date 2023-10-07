local M = {}

M.check_bootstrap = function()
    local bootstrap = false
    local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        bootstrap = true
        vim.fn.system {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        }
    end
    vim.opt.rtp:prepend(lazypath)
    return bootstrap
end

M.create_border = function (type, highlight)
    local styles = {
        plused  = { '+', '-', '+', '|', '+', '-', '+', '|' },
        rounded = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        starsed = { '*', '*', '*', '*', '*', '*', '*', '*' },
    }
    return {
        { styles[type][1], highlight },
        { styles[type][2], highlight },
        { styles[type][3], highlight },
        { styles[type][4], highlight },
        { styles[type][5], highlight },
        { styles[type][6], highlight },
        { styles[type][7], highlight },
        { styles[type][8], highlight },
    }
end

M.has = function(plugin)
    return require("lazy.core.config").plugins[plugin] ~= nil
end

M.map_keys = function(keymaps)
    for mode, mode_values in pairs(keymaps) do
        for keybind, bind_values in pairs(mode_values) do
            vim.api.nvim_set_keymap(mode, keybind, bind_values.exec, {
                desc = bind_values.desc,
            })
        end
    end
end

M.lspkind_icons = {
    Array = "[]",
    Boolean = "",
    Calendar = "",
    Class = "פּ",
    Color = "",
    Constant = "",
    Constructor = "ﴯ",
    Copilot = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "ƒ",
    Interface = "",
    Keyword = "",
    Method = "ƒ",
    Module = "",
    Namespace = "",
    Null = "ﳠ",
    Number = "",
    Object = "",
    Operator = "",
    Package = "",
    Property = "",
    Reference = "",
    Snippet = "",
    String = "",
    Struct = "פּ",
    Table = "",
    Tag = "",
    Text = "",
    TypeParameter = "",
    Unit = "塞",
    Value = "",
    Variable = "",
    Watch = "",
}

M.setup = function(plugin_name, plugins, options)
    local success, plugin = pcall(require, plugin_name)

    if not success then
        vim.api.nvim_err_writeln(
            'Faild to load plugin <' .. plugin_name .. '>'
        )
        vim.api.nvim_err_writeln(plugin)
        return
    end

    plugin.setup(plugins, options)
end

return M
