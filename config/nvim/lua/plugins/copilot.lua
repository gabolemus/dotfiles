return {
    "github/copilot.vim",
    config = function()
        -- Enable Copilot on Markdown files
        vim.g.copilot_filetypes = {
            markdown = true,
        }

        -- Disable Copilot initially.
        vim.g.copilot_enabled = false

        -- Remaps
        vim.keymap.set("n", "<leader>ce", "<cmd>Copilot enable<CR>", { desc = "Enable GitHub Copilot" })
        vim.keymap.set("n", "<leader>cd", "<cmd>Copilot disable<CR>", { desc = "Disable GitHub Copilot" })
        vim.keymap.set("n", "<leader>cr", "<cmd>Copilot restart<CR>", { desc = "Restart GitHub Copilot" })
        vim.keymap.set("n", "<leader>cs", "<cmd>Copilot status<CR>", { desc = "Display GitHub Copilot status" })
        vim.keymap.set("n", "<leader>cp", "<cmd>Copilot panel<CR>", { desc = "Show GitHub Copilot panel" })
    end,
}
