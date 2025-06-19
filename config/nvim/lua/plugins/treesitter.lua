return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
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
                "gitignore",
                "markdown",
                "markdown_inline",
                "json",
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "scss",
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
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                    },
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V",  -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                    include_surrounding_whitespace = true,
                },
            },
        })
    end,
    keys = {
        {
            "<leader>ss",
            function()
                require("nvim-treesitter.incremental_selection").init_selection()
            end,
            mode = "n",
            desc = "Init TreeSitter Selection",
        },
        {
            "<leader>si",
            function()
                require("nvim-treesitter.incremental_selection").node_incremental()
            end,
            mode = "v",
            desc = "Increment Node Selection",
        },
        {
            "<leader>sc",
            function()
                require("nvim-treesitter.incremental_selection").scope_incremental()
            end,
            mode = "v",
            desc = "Increment Scope Selection",
        },
        {
            "<leader>sd",
            function()
                require("nvim-treesitter.incremental_selection").node_decremental()
            end,
            mode = "v",
            desc = "Decrement Node Selection",
        },
    },
}
