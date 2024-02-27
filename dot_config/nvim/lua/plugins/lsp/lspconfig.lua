return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local opts = { noremap = true, silent = true }

        -- Give floating windows borders
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

        local on_attach = function(_, bufnr)
            opts.buffer = bufnr

            -- Keybindings
            opts.desc = "Show LSP references"
            vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- Show definition, references

            opts.desc = "Go to declaration"
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- Go to declaration

            opts.desc = "Show LSP definitions"
            vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- Show lsp definitions

            opts.desc = "Show LSP implementations"
            vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- Show lsp implementations

            opts.desc = "Show LSP type definitions"
            vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- Show lsp type definitions

            opts.desc = "See available code actions"
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- See available code actions, in visual mode will apply to selection

            opts.desc = "Smart rename"
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Smart rename

            opts.desc = "Show buffer diagnostics"
            vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- Show diagnostics for file

            opts.desc = "Show line diagnostics"
            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- Show diagnostics for line

            opts.desc = "Go to previous diagnostic"
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- Jump to previous diagnostic in buffer

            opts.desc = "Go to next diagnostic"
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- Jump to next diagnostic in buffer

            opts.desc = "Show documentation for what is under cursor"
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Show documentation for what is under cursor

            opts.desc = "Restart LSP"
            vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts) -- Mapping to restart lsp if necessary
        end

        -- Used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- LSPs to be configured with default settings
        local servers = {
            "html",
            "cssls",
            "eslint",
            "rust_analyzer",
            "clangd",
        }

        -- Loop through servers and configure them
        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end

        local function organize_imports()
            local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
            }
            vim.lsp.buf.execute_command(params)
        end

        -- Configure JavaScript/TypeScript language server
        lspconfig["tsserver"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            commands = {
                OrganizeImports = {
                    organize_imports,
                    description = "Organize Imports",
                },
            },
            init_options = {
                preferences = {
                    disableSuggestions = true,
                },
            },
        })

        -- Configure Python language server
        lspconfig["pyright"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "python" },
            settings = {
                python = {
                    venvPath = ".venv",
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                    },
                },
            },
        })

        -- Configure Java language server
        lspconfig["jdtls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "jdtls" },
            filetypes = { "java" },
        })

        lspconfig["java_language_server"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = {
                vim.fn.expand("$HOME")
                .. "/.local/share/nvim/mason/packages/java-language-server/dist/lang_server_linux.sh",
            },
            filetypes = { "java" },
        })

        -- -- Configure GraphQL language server
        -- lspconfig["graphql"].setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        --     filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        -- })

        -- Configure emmet language server
        lspconfig["emmet_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
        })

        -- Omnisharp (C#) language server
        lspconfig["omnisharp"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "dotnet", "/home/gabo/Downloads/OmniSharp.dll" },
        })

        -- Latex language server
        lspconfig["ltex"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                ltex = {
                    language = "en-US",
                    checkFrequency = "save",
                },
            },
        })

        -- Configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = { -- Custom settings for lua
                Lua = {
                    -- Make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- Make the LSP aware of the runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })
    end,
}
