-- ──────────────────────────────
--  Cursor shape & reset on exit
-- ──────────────────────────────
vim.opt.guicursor = table.concat({
    "n-v-c:block",                   -- block in Normal/Visual/Command
    "i-ci-ve:ver25",                 -- 25 % bar in Insert/C-Insert/Virtual
    "r-cr:hor20",                    -- 20 % underline in Replace/Command-replace
    "o:hor50",                       -- 50 % underline in Operator-pending
    "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",  -- blink params
    "sm:block-blinkwait175-blinkoff150-blinkon175"           -- show-match block
}, ",")

-- Return to a thin vertical bar (the classic “pipe”) when Neovim quits.
vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        vim.opt.guicursor = "a:ver25"
    end,
})

-- ──────────────────────────────
--  Cursor-line: number only
-- ──────────────────────────────
-- Make the highlighted line number bold, no matter what colourscheme loads.
local hl_group = vim.api.nvim_create_augroup("UserCursorLineNr", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    group = hl_group,
    callback = function()
        -- You can add foreground / background colours here if you like
        vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true })
    end,
})

