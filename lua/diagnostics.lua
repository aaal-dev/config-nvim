local icons = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
}

for name, icon in pairs(icons) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

vim.diagnostic.config {
    underline = true,
    update_in_insert = false,
    -- virtual_text = { spacing = 4, prefix = "●", source = "always" },
    virtual_text = false,
    float = { source = "always" },
    severity_sort = true,
}

local diagnostic_goto = function (next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function() go { severity = severity } end
end

require('utils').set_keymap {
    ["<leader>cd"] = {
        cmd = vim.diagnostic.open_float,
        opts = {
            desc = "Line Diagnostics",
        },
    },
    ["]d"] = {
        cmd = diagnostic_goto(true),
        opts = {
            desc = "Next Diagnostic",
        },
    },
    ["[d"] = {
        cmd = diagnostic_goto(false),
        opts = {
            desc = "Prev Diagnostic",
        },
    },
    ["]e"] = {
        cmd = diagnostic_goto(true, "ERROR"),
        opts = {
            desc = "Next Error",
        },
    },
    ["[e"] = {
        cmd = diagnostic_goto(false, "ERROR"),
        opts = {
            desc = "Prev Error",
        },
    },
    ["]w"] = {
        cmd = diagnostic_goto(true, "WARN"),
        opts = {
            desc = "Next Warning",
        },
    },
    ["[w"] = {
        cmd = diagnostic_goto(false, "WARN"),
        opts = {
            desc = "Prev Warning"
        },
    },
}
