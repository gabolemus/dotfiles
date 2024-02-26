return {
    "simrat39/rust-tools.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    ft = "rust",
    config = function()
        -- local lspconfig = require("lspconfig")
        -- local lsp_util = require("lspconfig/util")
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

        require("rust-tools").setup({
            server = {
                on_attach = on_attach,
                capabilities = capabilities,
            },
        })

        -- Bindings
        vim.keymap.set("n", "<leader>dbr", "<cmd>RustDebuggables<CR>", { desc = "Start Rust debug session" })
    end,
}
