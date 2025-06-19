return {
    "RRethy/vim-illuminate",
    config = function()
        vim.cmd("hi IlluminatedWordRead guibg=#3a425c")

        require("illuminate").configure({
            providers = {
                "lsp",
                "treesitter",
                "regex",
            },
            delay = 100, -- Delay in milliseconds
            -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
            filetypes_denylist = {
                "dirbuf",
                "dirvish",
                "fugitive",
            },
            min_count_to_highlight = 1, -- Minimum number of matches required to perform highlighting
        })
    end,
}
