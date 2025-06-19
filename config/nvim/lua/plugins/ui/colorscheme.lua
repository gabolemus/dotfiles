return {
    "sainnhe/sonokai",
    priority = 1000,
    name = "sonokai",
    dependencies = {
        "nvim-lualine/lualine.nvim",
    },
    config = function()
        vim.g.sonokai_style = "atlantis"
        vim.g.sonokai_enable_italic = 1
        vim.g.sonokai_disable_italic_comment = 1
        vim.g.sonokai_better_performance = 1
        vim.g.sonokai_transparent_background = 0
        vim.g.sonokai_show_eob = 0
        vim.g.sonokai_dim_inactive_windows = 1
        vim.g.sonokai_inlay_hints_background = "dimmed"
        vim.g.sonokai_diagnostic_virtual_text = "highlighted"

        -- Apply the colorscheme
        vim.cmd.colorscheme("sonokai")

        -- Create toggle function globally so it can be mapped elsewhere
        function ToggleSonokaiTransparency()
            local current = vim.g.sonokai_transparent_background
            vim.g.sonokai_transparent_background = (current == 1 and 0 or 1)
            vim.cmd.colorscheme("sonokai") -- reapply to trigger the change

            -- -- Optional: notify the transparency change
            -- vim.notify("Sonokai transparency: " ..
            -- (vim.g.sonokai_transparent_background == 1 and "enabled" or "disabled"))
        end

        vim.keymap.set("n", "<leader>c", function()
            ToggleSonokaiTransparency()
        end, { desc = "Toggle colorscheme transparency" })
    end,
}
