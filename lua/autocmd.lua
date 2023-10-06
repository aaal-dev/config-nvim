local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

--autocmd('BufEnter', {
--    callback = function ()
--        vim.api.nvim_set_current_dir(require('utils').get_root())
--    end,
--    group = augroup'ChangeCwd',
--    pattern = '*'
--})

-- Check if we need to reload the file when it changed
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    command = 'checktime',
    group = augroup'checktime',
})

-- [[ Auto resize panes when resizing nvim window ]]
autocmd('VimResized', {
    callback = function ()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. vim.fn.tabpagenr())
    end,
    group = augroup'resize_splits',
    pattern = '*',
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = augroup'YankHighlight',
    pattern = '*',
})

-- [[ dont list quickfix buffers ]]
autocmd('FileType', {
    callback = function()
        vim.opt_local.buflisted = false
    end,
    pattern = 'qf',
})

-- [[ Close floating panels with 'q' key ]]
autocmd("FileType", {
    pattern = {
        "OverseerForm",
        "OverseerList",
        "PlenaryTestPopup",
        "checkhealth",
        "floggraph",
        "fugitive",
        "git",
        "help",
        "lspinfo",
        "man",
        "neotest-output",
        "neotest-output-panel",
        "neotest-summary",
        "qf",
        "query",
        "spectre_panel",
        "startuptime",
        "toggleterm",
        "tsplayground",
        "vim",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true
        })
    end,
})

-- [[ Show something when user doesn't press a key for a while ]]
autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        local opts = {
            focusable = false,
            close_events = {
                "BufLeave",
                "CursorMoved",
                "InsertEnter",
                "FocusLost",
            },
            border = "rounded",
            prefix = " ",
            scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
    end,
})
