return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        -- Enable mason and configure icons
        mason.setup({
            registries = {
                "github:nvim-java/mason-registry",
                "github:mason-org/mason-registry",
            },
            ui = {
                border = "rounded",
            },
        })

        mason_lspconfig.setup({
            -- List of servers for mason to install
            ensure_installed = {
                "tsserver",
                "html",
                "cssls",
                "eslint",
                "lua_ls",
                "emmet_ls",
                "pyright",
                "rust_analyzer",
                "clangd",
            },
            -- Auto-install configured servers (with lspconfig)
            automatic_installation = true, -- Not the same as ensure_installed
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "prettier",     -- Prettier formatter
                "stylua",       -- Lua formatter
                "isort",        -- Python formatter
                "autopep8",     -- Python formatter
                "pylint",       -- Python linter
                "eslint_d",     -- JavaScript linter
                "clang-format", -- C/C++ formatter
                "codelldb",     -- LLDB debugger
            },
        })
    end,
}
