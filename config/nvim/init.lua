-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Window splitting behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Line wrapping
vim.opt.wrap = false

-- Tab and indentation settings
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Clipboard integration
vim.opt.clipboard = "unnamedplus" -- Sync the system clipboard with Neovim's clipboard

-- Scrolling behavior
vim.opt.scrolloff = 999 -- Keeps the cursor in the middle of the screen while scrolling

-- Allow cursor to move freely in visual block mode
vim.opt.virtualedit = "block"

-- Live preview of substitution commands
vim.opt.inccommand = "split"

-- Case-insensitive searching
vim.opt.ignorecase = true

-- Enable true color support
vim.opt.termguicolors = true

