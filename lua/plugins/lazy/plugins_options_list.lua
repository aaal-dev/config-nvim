local utils = require 'plugins.lazy.utils'

return {
    ['utilyre/barbecue.nvim'] = {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        version = '*',
        dependencies = {
            'SmiteshP/nvim-navic',
            'kyazdani42/nvim-web-devicons', -- optional dependency
        },
        config = true,
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
    ['ntk148v/habamax.nvim'] = {
      'ntk148v/habamax.nvim',
      dependencies = {
        'rktjmp/lush.nvim',
      },
    },
    ['lewis6991/impatient.nvim'] = {
        'lewis6991/impatient.nvim',
    },
    ['b0o/incline.nvim'] = {
        'b0o/incline.nvim',
        opts = {},
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
        },
        config = function (_, opts)
            local servers = {
                ['clangd'] = {
                    on_attach = function (_)
                        local inlay_hints = require'clangd_extensions.inlay_hints'
                        inlay_hints.setup_autocmd()
                        inlay_hints.set_inlay_hints()
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

            local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
            local capabilities = vim.tbl_deep_extend('force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                opts.capabilities or {}
            )

            local lsp = require 'lspconfig'
            for server, server_options in pairs(servers) do
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
    ['nvim-lua/plenary.nvim'] = {
      'nvim-lua/plenary.nvim',
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
