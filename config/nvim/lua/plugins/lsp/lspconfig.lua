return {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        -- Capabilities for completion
        local capabilities = cmp_nvim_lsp.default_capabilities()

        vim.diagnostic.config({
            float = { border = "rounded" },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.INFO] = "",
                    [vim.diagnostic.severity.HINT] = "",
                },
            },
        })

        -- Inlay hints helpers
        local function enable_inlay_hints(bufnr)
            if vim.lsp.inlay_hint then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            elseif vim.lsp.buf and vim.lsp.buf.inlay_hint then
                vim.lsp.buf.inlay_hint(bufnr, true)
            end
        end

        local function toggle_inlay_hints(bufnr)
            if vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled then
                local on = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                vim.lsp.inlay_hint.enable(not on, { bufnr = bufnr })
            elseif vim.lsp.buf and vim.lsp.buf.inlay_hint then
                vim.b[bufnr].inlay_hints_enabled = not vim.b[bufnr].inlay_hints_enabled
                vim.lsp.buf.inlay_hint(bufnr, vim.b[bufnr].inlay_hints_enabled)
            end
        end

        -- ✅ The “native” attach hook
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then
                    return
                end

                local opts = { noremap = true, silent = true, buffer = bufnr }

                -- Enable inlay hints if supported
                if client.server_capabilities and client.server_capabilities.inlayHintProvider then
                    enable_inlay_hints(bufnr)
                end

                opts.desc = "Toggle inlay hints"
                vim.keymap.set("n", "<leader>uh", function()
                    toggle_inlay_hints(bufnr)
                end, opts)

                opts.desc = "Show LSP references"
                vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "Go to declaration"
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "Show LSP definitions"
                vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

                opts.desc = "Show LSP implementations"
                vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

                opts.desc = "Show LSP type definitions"
                vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                opts.desc = "Code actions"
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                opts.desc = "Smart rename"
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Show buffer diagnostics"
                vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

                opts.desc = "Show line diagnostics"
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                opts.desc = "Prev diagnostic"
                vim.keymap.set("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, opts)

                opts.desc = "Next diagnostic"
                vim.keymap.set("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, opts)

                -- -- You don’t need to remap K on 0.11+ unless you want to override defaults.
                -- opts.desc = "Hover"
                -- vim.keymap.set("n", "K", function()
                --     vim.lsp.buf.hover({ border = "rounded" })
                -- end, opts)

                opts.desc = "Restart LSP"
                vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
            end,
        })

        -- Optional: set shared defaults once
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- Basic servers
        for _, server in ipairs({ "html", "cssls", "eslint" }) do
            vim.lsp.config(server, {}) -- merges with lsp/<server>.lua from nvim-lspconfig
        end

        -- TS
        local function organize_imports()
            local clients = vim.lsp.get_clients({ name = "tsserver" })
            for _, client in ipairs(clients) do
                client:exec_cmd({
                    title = "",
                    command = "_typescript.organizeImports",
                    arguments = { vim.api.nvim_buf_get_name(0) },
                }, {
                    bufnr = 0,
                })
            end
        end

        vim.lsp.config("ts_ls", {
            commands = {
                OrganizeImports = { organize_imports, description = "Organize Imports" },
            },
            init_options = { preferences = { disableSuggestions = true } },
        })

        -- Rust
        vim.lsp.config("rust_analyzer", {
            capabilities = capabilities,
            root_markers = { "Cargo.toml", "rust-project.json" },
            filetypes = { "rust" },
            single_file_support = true,
            settings = {
                ["rust-analyzer"] = {
                    diagnostics = { enable = true },
                    inlayHints = {
                        enable = true,
                        parameterHints = { enable = true },
                        typeHints = { enable = true },
                        chainingHints = { enable = true },
                        bindingModeHints = { enable = true },
                        closingBraceHints = { minLines = 25 },
                        lifetimeElisionHints = { enable = "always" },
                        implicitDrops = { enable = true },
                    },
                },
            },
        })

        vim.lsp.enable("rust_analyzer")

        -- C#
        vim.lsp.enable("csharp_ls")

        -- Python
        vim.lsp.config("pylsp", {
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = { maxLineLength = 100 },
                        jedi_completion = {
                            fuzzy = true,
                            include_params = true,
                        },
                    },
                },
            },
        })

        -- Clangd
        vim.lsp.config("clangd", {
            cmd = { "clangd", "--offset-encoding=utf-16" },
        })

        -- Emmet
        vim.lsp.config("emmet_ls", {
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
        })

        -- LTeX
        vim.lsp.config("ltex", {
            settings = {
                ltex = { language = "es", checkFrequency = "save" },
            },
            filetypes = { "bib", "plaintex", "tex", "pandoc", "quarto", "rmd", "context", "mail" },
        })

        -- Lua
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })

        -- Enable everything (once)
        vim.lsp.enable({
            "html",
            "cssls",
            "eslint",
            "ts_ls",
            "rust_analyzer",
            "pylsp",
            "clangd",
            "emmet_ls",
            "ltex",
            "lua_ls",
        })
    end,
}
