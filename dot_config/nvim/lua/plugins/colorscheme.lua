return {
    "cpea2506/one_monokai.nvim",
    priority = 1000, -- Load before all the other start plugins
    name = "one_monokai",
    config = function()
        require("one_monokai").setup({
            transparent = true,
            italics = true,
            colors = {
                popup_bg = "#1a1a1a",
            },
            themes = function(colors)
                return {
                    -- Normal = { bg = colors.newbg },
                    --DiffChange = { fg = colors.white:darken(0.3) },
                    --ErrorMsg = { fg = colors.pink, standout = true },
                    ["@lsp.type.keyword"] = { link = "@keyword" },
                    ["Pmenu"] = { fg = colors.fg, bg = colors.popup_bg },
                    -- ["PmenuSel"] = { fg = colors.white, bg = colors.pink },
                }
            end,
        })

        vim.cmd.colorscheme("one_monokai")
    end,
}
