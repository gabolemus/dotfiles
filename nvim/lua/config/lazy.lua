-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- Latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("lazy").setup({
    { import = "plugins" },
    { import = "plugins.lsp" },
    { import = "plugins.dap" },
    { import = "plugins.dap.servers" },
    { import = "plugins.languages" },
}, {
    install = {
        colorscheme = { "one_monokai" },
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        notify = false,
    },
    ui = {
        border = "rounded",
    },
})

-- Call vim.lsp.buf.format()
function LspFormat()
    vim.lsp.buf.format()
end
