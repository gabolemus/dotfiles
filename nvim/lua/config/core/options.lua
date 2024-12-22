-- Line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Window splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Tabs and indentation
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Virtual editing
vim.opt.virtualedit = "block"

-- Line wrapping
vim.opt.wrap = false
vim.opt.whichwrap:append("<,>,h,l")

-- Search highlighting
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.inccommand = "split"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Scroll
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Keywords
vim.opt.iskeyword:append("-")

-- Update time
vim.opt.updatetime = 50

-- Column ruler
vim.opt.colorcolumn = "80"

-- Undo and swap files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Backspace
vim.opt.backspace = "indent,eol,start"

-- Copilot
vim.g.copilot_assume_mapped = true
