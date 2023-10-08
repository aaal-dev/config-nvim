local utils = require 'plugins.lazy.utils'

return {
    ['romgrk/barbar.nvim'] = {
        'romgrk/barbar.nvim',
        dependencies = {
          'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
          'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        opts = {
            -- lazy.nvim will automatically call setup for you. put your
            -- options here, anything missing will use the default:
            -- animation = true,
            -- insert_at_start = true,
            -- …etc.
        },
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    ['utilyre/barbecue.nvim'] = {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        version = '*',
        dependencies = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons', -- optional dependency
        },
        opts = {
            attach_navic = false,
            create_autocmd = false,
            show_basename = false,
            show_dirname = false,
        },
        config = function (_, opts)
            require('barbecue').setup(opts)

            vim.api.nvim_create_autocmd({
                "WinResized",
                "BufWinEnter",
                'CursorMoved',

              -- include this if you have set `show_modified` to `true`
              -- "BufModifiedSet",
            }, {
              group = vim.api.nvim_create_augroup("barbecue.updater", {}),
              callback = function()
                require("barbecue.ui").update()
              end,
            })
        end,
    },
    ['https://git.sr.ht/~p00f/clangd_extensions.nvim'] = {
        'https://git.sr.ht/~p00f/clangd_extensions.nvim',
        ft = { 'c', 'cpp' },
        config = true,
    },
    ['numToStr/Comment.nvim'] = {
      'numToStr/Comment.nvim',
      event = 'User ActuallyEditing',
      config = true,
    },
    ['onsails/diaglist.nvim'] = {
      'onsails/diaglist.nvim',
    },
    ['sainnhe/edge'] = {
        'sainnhe/edge',
        lazy = false,
        priority = 1000,
        config = function(_, _)
            vim.g.edge_style = 'default'
            vim.g.edge_better_performance = 1
            vim.cmd('colorscheme edge')
            vim.cmd('TSEnable highlight')
        end,
    },
    ['j-hui/fidget.nvim'] = {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        event = 'LspAttach',
        opts = {
            text = {
                spinner = 'meter',
            },
        },
    },
    ['lewis6991/gitsigns.nvim'] = {
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
    },
    ['ray-x/go.nvim'] = {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function() require("go").setup() end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },

        -- if you need to install/update all binaries
        build = ':lua require("go.install").update_all_sync()',
        init = function ()
            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    require("go.format").goimport()
                end,
                group = format_sync_grp,
            })
        end,
    },
    ['https://sr.ht/~p00f/godbolt.nvim/'] = {
        'https://sr.ht/~p00f/godbolt.nvim/',
        config = true,
    },
    ['ntk148v/habamax.nvim'] = {
        'ntk148v/habamax.nvim',
        dependencies = {
            'rktjmp/lush.nvim',
        },
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('colorscheme habamax.nvim')
        end,
    },
    ['lewis6991/impatient.nvim'] = {
        'lewis6991/impatient.nvim',
    },
    ['b0o/incline.nvim'] = {
        'b0o/incline.nvim',
        opts = {
            debounce_threshold = {
                falling = 50,
                rising = 10,
            },
            highlight = {
                groups = {
                    InclineNormal = {
                        default = true,
                        group = "NormalFloat",
                    },
                    InclineNormalNC = {
                        default = true,
                        group = "NormalFloat",
                    },
                },
            },
            ignore = {
                buftypes = "special",
                filetypes = {},
                floating_wins = true,
                unlisted_buffers = true,
                wintypes = "special",
            },
            render = function(props)
                local filename = vim.fn.fnamemodify(
                    vim.api.nvim_buf_get_name(props.buf),
                    ':t'
                )

                local modified = vim.api.nvim_get_option_value(
                    'modified',
                    { buf = props.buf, }
                )

                if modified then
                    filename = ' ' .. filename
                end

                if props.focused == true then
                    return {
                        {
                            ' '..filename..' ',
                            guibg = '#282828',
                            guifg = '#a0a0a0',
                        }
                    }
                else
                    return {
                        {
                            ' '..filename..' ',
                            guibg = '#282828',
                            guifg = '#a0a0a0',
                        }
                    }
                end
            end,
            window = {
                margin = {
                    horizontal = 1,
                    vertical = 2,
                },
                options = {
                    signcolumn = "no",
                    wrap = false,
                },
                padding = 0,
                padding_char = " ",
                placement = {
                    horizontal = "right",
                    vertical = "top"
                },
                width = "fit",
                winhighlight = {
                    active = {
                        EndOfBuffer = "None",
                        Normal = "InclineNormal",
                        Search = "None",
                    },
                    inactive = {
                        EndOfBuffer = "None",
                        Normal = "InclineNormalNC",
                        Search = "None",
                    },
                },
                zindex = 50,
            },
        },
    },
    ['lukas-reineke/indent-blankline.nvim'] = {
        'lukas-reineke/indent-blankline.nvim',
        opts = {
            char = "",
            char_highlight_list = {
                "IndentBlanklineIndent1",
                "IndentBlanklineIndent2",
            },
            space_char_highlight_list = {
                "IndentBlanklineIndent1",
                "IndentBlanklineIndent2",
            },
            show_current_context = true,
            show_current_context_start = true,
            show_trailing_blankline_indent = false,
            space_char_blankline = " ",
        },
        init = function ()
            vim.cmd(
                'highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine'
            )
            vim.cmd(
                'highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine'
            )
        end,
    },
    ['rebelot/kanagawa.nvim'] = {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            background = {
                dark = 'dragon',
                light = 'lotus',
            },
            theme = 'dragon',
        },
        config = function(_, opts)
            require("kanagawa").setup(opts)
            vim.cmd("colorscheme kanagawa")
        end,
    },
    ['daschw/leaf.nvim'] = {
        'daschw/leaf.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme leaf]])
        end,
    },
    ['williamboman/mason.nvim'] = {
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
        init = function ()
            local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
            vim.env.PATH = vim.env.PATH
                .. (is_windows and ';' or ':')
                .. vim.fn.stdpath('data')
                .. '/mason/bin'
        end,
    },
    ['williamboman/mason-lspconfig.nvim'] = {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        opts = {
            automatic_instalation = true,
        },
    },
    ['marko-cerovac/material.nvim'] = {
        'marko-cerovac/material.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.material_style = 'darker'
            vim.cmd('colorscheme material')
        end,
    },
    ['folke/neodev.nvim'] = {
      'folke/neodev.nvim',
      opts = {},
    },
    ['karb94/neoscroll.nvim'] = {
        'karb94/neoscroll.nvim',
        opts = {
            -- All these keys will be mapped to their corresponding default
            -- scrolling animation
            mappings = {
                '<C-u>',
                '<C-d>',
                '<C-b>',
                '<C-f>',
                '<C-y>',
                '<C-e>',
                'zt',
                'zz',
                'zb'
            },

            -- Hide cursor while scrolling
            hide_cursor = true,

            -- Stop at <EOF> when scrolling downwards
            stop_eof = true,

            -- Stop scrolling when the cursor reaches the scrolloff margin
            -- of the file
            respect_scrolloff = false,

            -- The cursor will keep on scrolling even if the window cannot scroll
            -- further
            cursor_scrolls_alone = true,

            -- Default easing function
            easing_function = nil,

            -- Function to run before the scrolling animation starts
            pre_hook = nil,

            -- Function to run after the scrolling animation ends
            post_hook = nil,

            -- Disable "Performance Mode" on all buffers.
            performance_mode = false,
        },
    },
    ['nacro90/numb.nvim'] = {
        'nacro90/numb.nvim',
        opts = {
            -- Enable 'number' for the window while peeking
            show_numbers = true,

            -- Enable 'cursorline' for the window while peeking
            show_cursorline = true,

            -- Enable turning off 'relativenumber' for the window while peeking
            hide_relativenumbers = true,

            -- Peek only when the command is only a number instead of when it
            -- starts with a number
            number_only = false,

            -- Peeked line will be centered relative to window
            centered_peeking = true,
        }
    },
    ['windwp/nvim-autopairs'] = {
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
    ['code-biscuits/nvim-biscuits'] = {
        'code-biscuits/nvim-biscuits',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        init = function ()
            vim.cmd'highlight BiscuitColor ctermfg=DarkGray guifg=#474337'
        end,
        opts = {
            default_config = {
                min_distance = 5,
                -- max_length = 12,
                prefix_string ='<- ',
            },
        },
    },
    ['hrsh7th/nvim-cmp'] = {
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
            {
                'paopaol/cmp-doxygen',
                dependencies = {
                  "nvim-treesitter/nvim-treesitter",
                  "nvim-treesitter/nvim-treesitter-textobjects"
                },
            },
            { "ray-x/cmp-treesitter" },
            { "doxnit/cmp-luasnip-choice" },
            -- { "amarakon/nvim-cmp-buffer-lines" },
            -- { "amarakon/nvim-cmp-lua-latex-symbols" },
            { 'windwp/nvim-autopairs' },
        },
        opts = {
            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = function(_, item)
                    local icon = utils.lspkind_icons[item.kind]
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
                { name = 'doxygen' },
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
    },
    ['mfussenegger/nvim-dap'] = {
        'mfussenegger/nvim-dap',
        depedencies = {
            'jbyuki/one-small-step-for-vimkind',
        },
    },
    ['rcarriga/nvim-dap-ui'] = {
        'rcarriga/nvim-dap-ui',
        depedencies = {
            'mfussenegger/nvim-dap',
        },
    },
    ['theHamsta/nvim-dap-virtual-text'] = {
        'theHamsta/nvim-dap-virtual-text',
    },
    ['neovim/nvim-lspconfig'] = {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            {
                'SmiteshP/nvim-navbuddy',
                 dependencies = {
                    'SmiteshP/nvim-navic',
                    'MunifTanjim/nui.nvim',
                    'numToStr/Comment.nvim',        -- Optional
                    'nvim-telescope/telescope.nvim' -- Optional
                },
                opts = {
                    lsp = {
                        auto_attach = true,
                    },
                },
            },
        },
        opts = {
            capabilities = {
                textDocument = {
                    completion = {
                        compleitionItem = {
                            documentationFormat = {
                                'markdown',
                                'plaintext',
                            },
                            snippetSupport = true,
                            preselectSupport = true,
                            insertReplaceSupport = true,
                            labelDetailsSupport = true,
                            deprecatedSupport = true,
                            commitCharactersSupport = true,
                            tagSupport = { valeSet = { 1 } },
                            resolveSupport = {
                                properties = {
                                    'documentation',
                                    'detail',
                                    'additionalTextEdits',
                                },
                            }
                        }
                    },
                },
            },
            servers = {
                ['clangd'] = {
                    on_attach = function (client, bufnr)
                        local inlay_hints = require(
                            'clangd_extensions.inlay_hints'
                        )
                        inlay_hints.setup_autocmd()
                        inlay_hints.set_inlay_hints()

                        require('nvim-navic').attach(client, bufnr)
                        require('nvim-navbuddy').attach(client, bufnr)
                    end,
                },
                ['cmake'] = {},
                ['gdscript'] = {},
                ['gopls'] = {},
                ['lua_ls'] = {
                    opts = {
                        single_file_support = true,
                        flags = {
                            debounce_text_changes = 150,
                        },
                    },
                    on_init = function(client)
                        local path = client.workspace_folders[1].name
                        if not vim.loop.fs_stat(path..'/.luarc.json')
                        and not vim.loop.fs_stat(path..'/.luarc.jsonc')
                        then
                            client.config.settings = vim.tbl_deep_extend('force',
                                client.config.settings,
                                {
                                    Lua = {
                                        runtime = {
                                            -- Tell the language server which
                                            -- version of Lua you're using (most
                                            -- likely LuaJIT in the case of Neovim)
                                            version = 'LuaJIT'
                                        },
                                        -- Make the server aware of Neovim runtime
                                        -- files
                                        workspace = {
                                            checkThirdParty = false,
                                            library = {
                                                vim.env.VIMRUNTIME
                                                -- "${3rd}/luv/library"
                                                -- "${3rd}/busted/library",
                                            }
                                            -- or pull in all of 'runtimepath'.
                                            -- NOTE: this is a lot slower
                                            -- library = vim.api.nvim_get_runtime_file("", true)
                                        }
                                    }
                                }
                            )

                            client.notify(
                                "workspace/didChangeConfiguration",
                                { settings = client.config.settings }
                            )
                        end
                        return true
                    end,
                },
                ['rust_analyzer'] = {},
                ['zls'] = {},
            }
        },
        config = function (_, opts)
            local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
            local capabilities = vim.tbl_deep_extend('force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                opts.capabilities or {}
            )

            local lsp = require 'lspconfig'
            for server, server_options in pairs(opts.servers) do
                lsp[server].setup(vim.tbl_deep_extend('force',
                    { capabilities = vim.deepcopy(capabilities) },
                    server_options or {}
                ))
            end

        end,
    },
    ['SmiteshP/nvim-navic'] = {
        'SmiteshP/nvim-navic',
        opts = {
            icons = {
                File          = "󰈙 ",
                Module        = " ",
                Namespace     = "󰌗 ",
                Package       = " ",
                Class         = "󰌗 ",
                Method        = "󰆧 ",
                Property      = " ",
                Field         = " ",
                Constructor   = " ",
                Enum          = "󰕘",
                Interface     = "󰕘",
                Function      = "󰊕 ",
                Variable      = "󰆧 ",
                Constant      = "󰏿 ",
                String        = "󰀬 ",
                Number        = "󰎠 ",
                Boolean       = "◩ ",
                Array         = "󰅪 ",
                Object        = "󰅩 ",
                Key           = "󰌋 ",
                Null          = "󰟢 ",
                EnumMember    = " ",
                Struct        = "󰌗 ",
                Event         = " ",
                Operator      = "󰆕 ",
                TypeParameter = "󰊄 ",
            },
            lsp = {
                auto_attach = false,
                preference = nil,
            },
            highlight = false,
            separator = " > ",
            depth_limit = 0,
            depth_limit_indicator = "..",
            safe_output = true,
            lazy_update_context = false,
            click = false
        },
    },
    ['nvim-tree/nvim-tree.lua'] = {
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
    },
    ['nvim-treesitter/nvim-treesitter'] = {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-refactor',
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        cmd = {
            'TSInstall',
            'TSBufEnable',
            'TSBufDisable',
            'TSEnable',
            'TSDisable',
            'TSModuleInfa',
        },
        event = 'BufReadPost',
        version = false,
        opts = {
            auto_install = true,
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            refactor = { -- nvim-treesitter-refactor module
                highlight_current_scope = { enable = false },
                highlight_definitions = {
                    enable = true,
                    -- Set to false if you have an `updatetime` of ~100.
                    clear_on_cursor_move = true,
                },
                navigation = {
                    enable = true,
                    -- Assign keymaps to false to disable them,
                    -- e.g. `goto_definition = false`.
                    keymaps = {
                        goto_definition = "gnd",
                        list_definitions = "gnD",
                        list_definitions_toc = "gO",
                        goto_next_usage = "<a-*>",
                        goto_previous_usage = "<a-#>",
                    },
                },
                smart_rename = {
                    enable = true,
                    -- Assign keymaps to false to disable them,
                    -- e.g. `smart_rename = false`.
                    keymaps = {
                        smart_rename = "grr",
                    },
                },
            },
            textobjects = { -- nvim-treesitter-textobjects module
                lsp_interop = {
                    enable = true,
                    border = 'none',
                    floating_preview_opts = {},
                    peek_definition_code = {
                        ["<leader>df"] = "@function.outer",
                        ["<leader>dF"] = "@class.outer",
                  },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = {
                            query = "@class.outer",
                            desc = "Next class start"
                        },

                        -- You can use regex matching (i.e. lua pattern)
                        -- and/or pass a list in a "query" key to group
                        -- multiple queires.
                        ["]o"] = "@loop.*",
                        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }

                        -- You can pass a query group to use query from
                        -- `queries/<lang>/<query_group>.scm file in your
                        -- runtime path.
                        -- Below example nvim-treesitter's `locals.scm` and
                        -- `folds.scm`. They also provide highlights.scm and
                        -- indent.scm.
                        ["]s"] = {
                            query = "@scope",
                            query_group = "locals",
                            desc = "Next scope"
                        },
                        ["]z"] = {
                            query = "@fold",
                            query_group = "folds",
                            desc = "Next fold"
                        },
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                    -- Below will go to either the start or the end, whichever
                    -- is closer.
                    -- Use if you want more granular movements
                    -- Make it even more gradual by adding multiple queries
                    -- and regex.
                    goto_next = {
                        ["]d"] = "@conditional.outer",
                    },
                    goto_previous = {
                        ["[d"] = "@conditional.outer",
                    }
                },
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar
                    -- to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined
                        -- in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",

                        -- You can optionally set descriptions to the mappings
                        -- (used in the desc parameter of nvim_buf_set_keymap)
                        -- which plugins like which-key display
                        ["ic"] = {
                            query = "@class.inner",
                            desc = "Select inner part of a class region"
                        },

                        -- You can also use captures from other query groups
                        -- like `locals.scm`
                        ["as"] = {
                            query = "@scope",
                            query_group = "locals",
                            desc = "Select language scope"
                        },
                    },

                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with
                    -- the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>')
                    -- or a table mapping query_strings to modes.
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V', -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },

                    -- If you set this to `true` (default is `false`) then any
                    -- textobject is extended to include preceding or
                    -- succeeding whitespace. Succeeding whitespace has
                    -- priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with
                    -- the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true of false
                    include_surrounding_whitespace = true,
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner",
                    },
                },
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end
    },
    ['nvim-treesitter/nvim-treesitter-context'] = {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = true,
    },
    ['Th3Whit3Wolf/one-nvim'] = {
        'Th3Whit3Wolf/one-nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('colorscheme one-nvim')
        end,
    },
    ['nvim-lua/plenary.nvim'] = {
      'nvim-lua/plenary.nvim',
    },
    ['glepnir/porcelain.nvim'] = {
        'glepnir/porcelain.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme porcelain]])
        end,
    },
    ['simrat39/rust-tools.nvim'] = {
        "simrat39/rust-tools.nvim",
        dependencies = { -- optional packages
            "neovim/nvim-lspconfig",
        },
        ft = { "rs" },
        config = true,
    },
    ['leath-dub/stat.nvim'] = {
        'leath-dub/stat.nvim',
        opts = {
            modules = {
                filetype = function ()
                    local filetype = string.upper(vim.bo.filetype)
                    if filetype == "" then
                        return ""
                    end
                    return Stat.lib.set_highlight("Filetype", " " .. filetype .. " ", true)
                end,
                mode = function ()
                    local modes = {
                        ["n"] = "N",
                        ["no"] = "N",
                        ["nov"] = "N",
                        ["noV"] = "N",
                        ["no\22"] = "N",
                        ["niI"] = "N",
                        ["niR"] = "N",
                        ["niV"] = "N",
                        ["nt"] = "N",
                        ["ntT"] = "N",
                        ["v"] = "V",
                        ["vs"] = "V",
                        ["V"] = "V",
                        ["Vs"] = "V",
                        ["\22"] = "V",
                        ["\22s"] = "V",
                        ["s"] = "S",
                        ["S"] = "S",
                        ["CTRL-S"] = "S",
                        ["i"] = "I",
                        ["ic"] = "I",
                        ["ix"] = "I",
                        ["R"] = "R",
                        ["Rc"] = "R",
                        ["Rx"] = "R",
                        ["Rvc"] = "R",
                        ["Rvx"] = "R",
                        ["c"] = "C",
                        ["cv"] = "E",
                        ["r"] = "N",
                        ["rm"] = "N",
                        ["r?"] = "N",
                        ["!"] = "N",
                        ["t"] = "T"
                    }
                    local mode = modes[vim.api.nvim_get_mode().mode]
                    return Stat.lib.set_highlight(mode, " " .. mode .. " ", true)
                end,
            },
        },
        config = function(_, opts)
            require('stat').setup({
                statusline = {
                    opts.modules.filetype,
                    Stat.___,
                    opts.modules.mode,
                    Stat.___,
                },
                theme = {
                    ["N"] = { fg = "#2d353b", bg = "#83c092" },
                    ["I"] = { fg = "#2d353b", bg = "#7fbbb3" },
                    ["V"] = { fg = "#2d353b", bg = "#dbbc7f" },
                    ["C"] = { fg = "#2d353b", bg = "#d699b6" },
                    ["T"] = { fg = "#2d353b", bg = "#a7c080" },
                    ["S"] = { fg = "#2d353b", bg = "#e67e80" },
                    ["File"] = { fg = "#d3c6aa", bg = "#343f44" },
                    ["Filetype"] = { fg = "#d3c6aa", bg = "#272e33" },
                    ["GitDiffDeletion"] = { fg = "#e67e80", bg = "#232a2e" },
                    ["GitDiffInsertion"] = { fg = "#a7c080", bg = "#232a2e" }
                },
            })
        end,
    },
    ['nvim-telescope/telescope.nvim'] = {
        'nvim-telescope/telescope.nvim',
        version = false,
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "tsakirist/telescope-lazy.nvim",
        },
        opts = {
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "-L",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                file_ignore_patterns = { "node_modules" },
                path_display = { "truncate" },
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,

                mappings = {
                    n = {
                        ["q"] = function()
                            require("telescope.actions").close()
                        end,
                    },
                    i = {
                        ["<c-t>"] = function(...)
                            return require("trouble.providers.telescope").open_with_trouble(...)
                        end,
                        ["<a-i>"] = function()
                            Util.telescope("find_files", { no_ignore = true })()
                        end,
                        ["<a-h>"] = function()
                            Util.telescope("find_files", { hidden = true })()
                        end,
                        ["<C-Down>"] = function(...)
                            return require("telescope.actions").cycle_history_next(...)
                        end,
                        ["<C-Up>"] = function(...)
                            return require("telescope.actions").cycle_history_prev(...)
                        end,
                    },
                },
            },
        },
    },
    ['folke/todo-comments.nvim'] = {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "TodoTrouble", "TodoTelescope" },
        config = true,
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Next todo comment"
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Previous todo comment"
            },
            {
                "<leader>xt",
                "<cmd>TodoTrouble<cr>",
                desc = "Todo (Trouble)"
            },
            {
                "<leader>xT",
                "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
                desc = "Todo/Fix/Fixme (Trouble)"
            },
            {
                "<leader>st",
                "<cmd>TodoTelescope<cr>",
                desc = "Todo"
            },
            {
                "<leader>sT",
                "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
                desc = "Todo/Fix/Fixme"
            },
        },
    },
    ['akinsho/toggleterm.nvim'] = {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = true,
    },
    ['jbyuki/venn.nvim'] = {
        'jbyuki/venn.nvim',
        keys = {
            { '<leader>v', '<cmd>lua Toggle_venn()<cr>', desc = 'Venn' },
        },
        config = function ()
            function _G.Toggle_venn()
                local venn_enabled = vim.inspect(vim.b.venn_enabled)
                if venn_enabled == "nil" then
                    vim.b.venn_enabled = true
                    vim.cmd[[setlocal ve=all]]
                    -- draw a line on HJKL keystokes
                    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
                    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
                    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
                    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
                    -- draw a box by pressing "f" with visual selection
                    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
                else
                    vim.cmd[[setlocal ve=]]
                    vim.cmd[[mapclear <buffer>]]
                    vim.b.venn_enabled = nil
                end
            end
        end
    },
    ['lukas-reineke/virt-column.nvim'] = {
        'lukas-reineke/virt-column.nvim',
        opts = {},
    },
    ['folke/which-key.nvim'] = {
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
    },
    ['NTBBloodbath/zig-tools.nvim'] = {
        "NTBBloodbath/zig-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "akinsho/toggleterm.nvim",
        },
        ft = { "zig" },
        config = true,
    },
}
