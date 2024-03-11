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
})

function ColorNvimTree()
    vim.cmd("highlight NvimTreeFolderName guifg=#61AFEF")
    vim.cmd("highlight NvimTreeEmptyFolderName guifg=#61AFEF")
    vim.cmd("highlight NvimTreeOpenedFolderName guifg=#61AFEF")
    vim.cmd("highlight NvimTreeSymlinkFolderName guifg=#61AFEF")

    -- Highlight groups
    vim.cmd("highlight NeoTreeDirectoryIcon guifg=#EABD40")
    -- vim.cmd("highlight NvimTreeOpenedFolderIcon guifg=#EABD40")
    -- vim.cmd("highlight NvimTreeClosedFolderIcon guifg=#EABD40")

    vim.cmd("highlight NeoTreeDirectoryName guifg=#61AFEF")
    -- vim.cmd("highlight NvimTreeEmptyFolderName guifg=#61AFEF")
    -- vim.cmd("highlight NvimTreeOpenedFolderName guifg=#61AFEF")
    -- vim.cmd("highlight NvimTreeSymlinkFolderName guifg=#61AFEF")
end

local coloring_timeout = 100

-- Hack to change NvimTree folder name color after loading
-- This is a workaround given that the highlight groups for NvimTree appear to
-- need to be set after the plugin is loaded.
-- Todo: Find a better way to do this
-- vim.defer_fn(ColorNvimTree, coloring_timeout)

-- Call vim.lsp.buf.format()
function LspFormat()
    vim.lsp.buf.format()
end
