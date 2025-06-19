return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.cmd("filetype plugin indent on")
        vim.cmd("syntax enable")

        -- VimTeX options
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_method = "latexrun"
        vim.g.maplocalleader = ","
    end,
}
