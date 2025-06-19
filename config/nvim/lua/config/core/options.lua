-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true        -- Enable cursorline (required for CursorLineNr)
-- vim.opt.cursorlineopt = "number" -- Only highlight the line number, not the full line

-- Window splitting behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Line wrapping
vim.opt.wrap = false
vim.opt.whichwrap:append("<,>,h,l")

-- Tab and indentation settings
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Clipboard integration
vim.opt.clipboard = "unnamedplus" -- Sync the system clipboard with Neovim's clipboard

-- Scrolling behavior
vim.opt.scrolloff = 999 -- Keeps the cursor in the middle of the screen while scrolling
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Allow cursor to move freely in visual block mode
vim.opt.virtualedit = "block"

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

-- Undo and swap files
--vim.opt.swapfile = false
--vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"

-- Backspace
vim.opt.backspace = "indent,eol,start"

-- Function to update the highlight color of CursorLineNr based on mode
local function update_cursorline_color()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "n" then
        vim.cmd([[ highlight CursorLineNr guifg=#ffffff gui=bold ]]) -- Normal mode: White
    elseif mode == "i" then
        vim.cmd([[ highlight CursorLineNr guifg=#3A96DD gui=bold ]]) -- Insert mode: Blue
    elseif mode == "v" or mode == "V" or mode == "␖" then
        vim.cmd([[ highlight CursorLineNr guifg=#ff5555 gui=bold ]]) -- Visual mode: Red
    elseif mode == "R" then
        vim.cmd([[ highlight CursorLineNr guifg=#ff00ff gui=bold ]]) -- Replace mode: Magenta
    else
        vim.cmd([[ highlight CursorLineNr guifg=#ffffff gui=bold ]]) -- Default: White
    end
end

-- Autocommand to change CursorLineNr color when mode changes
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = update_cursorline_color,
})

-- Initialize color on startup
update_cursorline_color()
