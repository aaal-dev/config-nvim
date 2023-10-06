return {
    "lewis6991/gitsigns.nvim",
    --event = "BufReadPre",
    ft = { 'gitcommit', 'diff' },
    opts = {
        signs = {
            add = {
                hl = "DiffAdd",
                text = "│",
                numhl = "GitSignsAddNr"
            },
            change = {
                hl = "DiffChange",
                text = "│",
                numhl = "GitSignsChangeNr",
            },
            delete = {
                hl = "DiffDelete",
                text = "",
                numhl = "GitSignsDeleteNr",
            },
            topdelete = {
                hl = "DiffDelete",
                text = "‾",
                numhl = "GitSignsDeleteNr",
            },
            changedelete = {
                hl = "DiffChangeDelete",
                text = "~",
                numhl = "GitSignsChangeNr",
            },
            untracked = { text = "▎" },
        },
        on_attach = function(buffer)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            -- stylua: ignore start
            map("n", "]h", gs.next_hunk, "Next Hunk")
            map("n", "[h", gs.prev_hunk, "Prev Hunk")
            map({"n", "v"}, "<leader>ghs", ":Gitsigns stage_hunk<CR>",
                "Stage Hunk")
            map({"n", "v"}, "<leader>ghr", ":Gitsigns reset_hunk<CR>",
                "Reset Hunk")
            map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
            map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
            map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
            map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
            map("n", "<leader>ghb", function()
                gs.blame_line({full = true})
            end, "Blame Line")
            map("n", "<leader>ghd", gs.diffthis, "Diff This")
            map("n", "<leader>ghD", function() gs.diffthis("~") end,
                "Diff This ~")
            map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>",
                "GitSigns Select Hunk")
        end,
    },
    init = function()
        local plugin_name = 'GitSignsLazyLoad'
        vim.api.nvim_create_autocmd({ 'BufRead' }, {
            group = vim.api.nvim_create_augroup(plugin_name, { clear = true }),
            callback = function()
                vim.fn.system('git -C "'
                    .. vim.fn.expand('%:p:h')
                    .. '" rev-parse'
                )
                if vim.v.shell_error == 0 then
                    vim.api.nvim_del_augroup_by_name(plugin_name)
                    vim.schedule(function ()
                        require('lazy').load {
                            plugins = { 'gitsigns.nvim' }
                        }
                    end)
                end
            end,
        })
    end,
}
