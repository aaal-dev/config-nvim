local M = {}

M.alpha = function()
    return string.format("%x", math.floor((255 * vim.g.transparency) or 0.8))
end

M.get_root = function()
    ---@type string?
    local path = vim.api.nvim_buf_get_name(0)
    path = path ~= "" and vim.loop.fs_realpath(path) or nil

    ---@type string[]
    local roots = {}
    if path then
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            local workspace = client.config.workspace_folders
            local paths = workspace and vim.tbl_map(function(ws)
                    return vim.uri_to_fname(ws.uri)
                end, workspace)
            or client.config.root_dir and { client.config.root_dir }
            or {}

            for _, p in ipairs(paths) do
                local r = vim.loop.fs_realpath(p)
                if path:find(r, 1, true) then
                    roots[#roots + 1] = r
                end
            end
        end
    end

    table.sort(roots, function(a, b)
        return #a > #b
    end)

    ---@type string?
    local root = roots[1]
    if not root then
        path = path and vim.fs.dirname(path) or vim.loop.cwd()
        ---@type string?
        root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
        root = root and vim.fs.dirname(root) or vim.loop.cwd()
    end
    ---@cast root string
    return root
end


M.load = function(config_list)
    for _, config in ipairs(config_list) do
        local success, error = pcall(require, config)
        if not success then
            vim.api.nvim_err_writeln(
                'Failed to load config "' .. config ..  '"'
            )
            vim.api.nvim_err_writeln(error)
        end
    end
end

M.root_patterns = {
    '.git',
    'lua'
}

M.set_keymap = function(keymap)
    for key, options in pairs(keymap) do
        vim.keymap.set(options.mode or "n", key, options.cmd, options.opts)
    end
end

M.set_variables = function(into, options)
    for key, value in pairs(options) do
        into[key] = value
    end
end

M.set_vim_g = function(options) M.set_variables(vim.g, options) end

M.set_vim_o = function(options) M.set_variables(vim.o, options) end

M.set_vim_opt = function(options) M.set_variables(vim.opt, options) end

return M
