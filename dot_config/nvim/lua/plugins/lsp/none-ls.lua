return {
    -- Todo: check if this plugin is still needed
    "nvimtools/none-ls.nvim", -- Configure formatters & linters
    lazy = true,
    -- event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "jay-babu/mason-null-ls.nvim",
    },
    config = function()
        local mason_null_ls = require("mason-null-ls")
        local null_ls = require("null-ls")
        local null_ls_utils = require("null-ls.utils")

        mason_null_ls.setup({
            ensure_installed = {
                "prettier", -- Prettier formatter
                "stylua",   -- Lua formatter
                "autopep8", -- Python formatter
                "pylint",   -- Python linter
                "eslint_d", -- JavaScript linter
            },
        })

        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics

        -- To setup format on save
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        -- Configure null_ls
        null_ls.setup({
            -- Add package.json as identifier for root (for typescript monorepos)
            root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
            -- Setup formatters & linters
            sources = {
                --  To disable file types use
                --  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
                -- formatting.prettier.with({
                --     extra_filetypes = { "svelte" },
                -- }),                -- JS/TS formatter
                formatting.stylua, -- Lua formatter
                formatting.isort,
                formatting.autopep8,
                formatting["bibtex-tidy"],
                diagnostics.pylint,
                diagnostics.eslint_d.with({                                             -- JS/TS linter
                    condition = function(utils)
                        return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- Only enable if root has .eslintrc.js or .eslintrc.cjs
                    end,
                }),
            },
            -- Configure format on save
            on_attach = function(current_client, bufnr)
                if current_client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                filter = function(client)
                                    --  Only use null-ls for formatting instead of lsp server
                                    return client.name == "null-ls"
                                end,
                                bufnr = bufnr,
                            })
                        end,
                    })
                end
            end,
        })
    end,
}
