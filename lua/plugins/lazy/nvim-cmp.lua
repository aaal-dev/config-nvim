local utils = require 'plugins.lazy.utils'

local lspkind_icons = {
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

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
                "molleweide/LuaSnip-snippets.nvim",
            },
            version = '<CurrentMajor>.*',
            build = 'make install_jsregexp',
            opts = {
                history = true,
                updateevents = 'TextChanged,TextChangedI',
            },
            config = function (_, opts)
                local success, luasnip = pcall(require, 'luasnip')
                if not success then
                    local error = luasnip
                    vim.api.nvim_err_writeln('Failed to load a luasnip \n')
                    vim.api.nvim_err_writeln(error)
                    error()
                end

                luasnip.setup(opts)

                local from_vscode = require 'luasnip.loaders.from_vscode'
                from_vscode.lazy_load {
                    paths = vim.g.luasnippets_path or "",
                }
                from_vscode.lazy_load()

                vim.api.nvim_create_autocmd("InsertLeave", {
                    callback = function()
                        local buffer = vim.api.nvim_get_current_buf()
                        if luasnip.session.current_nodes[buffer]
                            and not luasnip.session.jump_active
                        then
                            luasnip.unlink_current()
                        end
                    end,
                })
            end,
        },
        { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
        -- { "hrsh7th/cmp-buffer" },
        -- { "hrsh7th/cmp-calc" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
        { "ray-x/cmp-treesitter" },
        { "doxnit/cmp-luasnip-choice" },
        -- { "amarakon/nvim-cmp-buffer-lines" },
        -- { "amarakon/nvim-cmp-lua-latex-symbols" },
        {
            'windwp/nvim-autopairs',
            opts = {
                fast_wrap = {},
                disable_filetype = { 'TelescopePrompt', 'vim' },
            },
            config = function (_, opts)
                require('nvim-autopairs').setup(opts)

                local ca = require 'nvim-autopairs.completion.cmp'
                require('cmp').event:on('confirm_done', ca.on_confirm_done())
            end
        },
    },
    opts = {
        formatting = {
            fields = { 'abbr', 'menu', 'kind' },
            format = function(_, item)
                local icon = lspkind_icons[item.kind]
                if icon == nil then
                    icon = '  '
                end
                item.kind = icon .. item.kind
                return item
            end,
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        sources = {
            -- { name = "buffer" },
            -- { name = "buffer-lines" },
            -- { name = "calc" },
            -- { name = "lua-latex-symbols" },
            { name = "luasnip" },
            { name = "luasnip_choise" },
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "path" },
            { name = "treesitter" },
        },
        window = {
            completion = {
                --border = utils.create_border('rounded', 'CmpBorder'),
                winhighlight = 'Normal:CmpPmenu,'
                    .. 'CursorLine:PmenuSel,'
                    .. 'Search:None',
            },
            documentation = {
                --border = utils.create_border('rounded', 'CmpDocBorder'),
                --border = 'shadow',
                winhighlight = 'Normal:CmpDoc',
            },
        },
    },
    config = function(_, opts)
        local cmp = require "cmp"

        opts.sorting = {
            comparators = {
                cmp.config.compare.exact,
                require("clangd_extensions.cmp_scores"),
                cmp.config.compare.kind,
            },
        }

        opts.mapping = {
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ['<Esc>'] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = false,
            },
            ['<S-CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            },
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif require("luasnip").expand_or_jumpable() then
                    vim.fn.feedkeys(
                        vim.api.nvim_replace_termcodes(
                            "<Plug>luasnip-expand-or-jump",
                            true,
                            true,
                            true
                        ),
                        ""
                    )
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif require("luasnip").jumpable(-1) then
                    vim.fn.feedkeys(
                        vim.api.nvim_replace_termcodes(
                            "<Plug>luasnip-jump-prev",
                            true,
                            true,
                            true
                        ),
                        ""
                    )
                else
                    fallback()
                end
            end, { "i", "s" }),
        }

        cmp.setup(opts)

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = opts.mapping,
            sources = cmp.config.sources(
                { { name = "nvim_lsp_document_symbol" } },
                { { name = "buffer" } }
                -- { { name = "buffer-lines" } },
            ),
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`,
        -- this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = opts.mapping,
            sources = cmp.config.sources(
                { { name = "path" } },
                { { name = "cmdline" } }
            ),
        })
    end,
}
