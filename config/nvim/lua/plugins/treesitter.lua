return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "windwp/nvim-ts-autotag",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "rust",
                "json",
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "scss",
                "markdown",
                "markdown_inline",
                "gitignore",
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            autotag = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
