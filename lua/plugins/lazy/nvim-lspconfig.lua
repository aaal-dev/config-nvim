return {
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
}
