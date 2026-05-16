dofile(vim.fn.stdpath("config") .. "/after/ftplugin/default.lua")

vim.opt_local.ruler = true
vim.opt.colorcolumn = "80"

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python" },
    callback = function()
        vim.treesitter.start()
    end,
})

-- Enable folds
-- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.wo[0][0].foldmethod = "expr"
