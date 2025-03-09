-- Configuration to reset the cursor when exiting Neovim
-- Cursor options
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
    .. ",a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
    .. ",sm:block-blinkwait175-blinkoff150-blinkon175"

-- Set guicursor and send escape sequence on VimLeave
vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        vim.opt.guicursor = "a:ver25"
    end,
})

-- Configuration to highlight only the number of the current line
vim.cmd("set cursorline")
vim.cmd("set cursorlineopt=number")

-- Define an autocmd for ColorScheme event
vim.api.nvim_exec2(
    [[
  autocmd ColorScheme * highlight CursorLineNr cterm=bold term=bold gui=bold
  ]],
    { output = false }
)
