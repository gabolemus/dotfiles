-- Configuration to reset the cursor when exiting Neovim
-- Cursor options
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
    .. ",a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
    .. ",sm:block-blinkwait175-blinkoff150-blinkon175"

-- -- Set guicursor and send escape sequence on VimLeave
-- vim.api.nvim_exec(
--     [[
--     augroup MyAutoCmds
--         autocmd!
--         autocmd VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q") | call chansend(v:stderr, "\x1b]12;white\x07")
--     augroup END
--     ]],
--     false
-- )

-- Set guicursor and send escape sequence on VimLeave
vim.api.nvim_exec(
    [[
    augroup MyAutoCmds
        autocmd!
        autocmd VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q") | call chansend(v:stderr, "\x1b[0m") | call chansend(v:stderr, "\x1b]12;white\x07")
    augroup END
    ]],
    false
)

-- Configuration to highlight only the number of the current line
-- Set cursorline
vim.cmd("set cursorline")

-- Set cursorlineopt to number
vim.cmd("set cursorlineopt=number")

-- Define an autocmd for ColorScheme event
vim.api.nvim_exec(
    [[
  autocmd ColorScheme * highlight CursorLineNr cterm=bold term=bold gui=bold
]],
    false
)
