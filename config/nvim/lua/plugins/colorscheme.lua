return {
    "sainnhe/sonokai",
    priority = 1000, -- Load before all the other plugins
    name = "sonokai",
    config = function()
        vim.g.sonokai_style = "default"
        vim.g.sonokai_cursor = "blue"
        vim.g.sonokai_enable_italic = 1
        vim.g.sonokai_disable_italic_comment = 1
        vim.g.sonokai_better_performance = 1
        vim.g.sonokai_transparent_background = 0
        vim.g.sonokai_show_eob = 0
        vim.g.sonokai_dim_inactive_windows = 1
        vim.g.sonokai_diagnostic_text_highlight = 1
        vim.g.sonokai_diagnostic_line_highlight = 1
        vim.g.sonokai_diagnostic_virtual_text = "highlighted"
        vim.cmd.colorscheme("sonokai")
    end,
}
