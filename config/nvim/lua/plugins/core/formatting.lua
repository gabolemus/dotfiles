return {
    "stevearc/conform.nvim",
    enabled = true,
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                jsonc = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "autopep8" },
                cpp = { "clang-format" },
                tex = { "bibtex-tidy" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            -- Also call LSP formatting if filetype is lua
            if vim.bo.filetype == "lua" then
                vim.lsp.buf.format()
            else
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                })
            end
            -- Todo: find a way to configure StyLua to format with the
            -- `vim.lsp.buf.format()` defaults
        end, { desc = "Format file or range (in visual mode)" })

        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                if vim.bo.filetype == "lua" then
                    vim.lsp.buf.format()
                else
                    require("conform").format({ bufnr = args.buf })
                end
            end,
        })
    end,
}
