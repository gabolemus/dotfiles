return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- lsp = {
        --     -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        --     override = {
        --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        --         ["vim.lsp.util.stylize_markdown"] = true,
        --         ["cmp.entry.get_documentation"] = true,
        --     },
        -- },
        -- -- you can enable a preset for easier configuration
        -- presets = {
        --     bottom_search = true, -- use a classic bottom cmdline for search
        --     command_palette = true, -- position the cmdline and popupmenu together
        --     long_message_to_split = true, -- long messages will be sent to a split
        --     inc_rename = false, -- enables an input dialog for inc-rename.nvim
        --     lsp_doc_border = false, -- add a border to hover docs and signature help
        -- },

        -- Keymaps
        vim.keymap.set("n", "<leader>nd", "<cmd>Noice dismiss<CR>", { desc = "Dismiss notification popups" }),
        vim.keymap.set("n", "<leader>nl", "<cmd>Noice last<CR>", { desc = "Show last notification popup" }),
        vim.keymap.set("n", "<leader>ne", "<cmd>Noice errors<CR>", { desc = "Show errors in a split" }),
        vim.keymap.set("n", "<leader>nt", "<cmd>Noice telescope<CR>", { desc = "Opens message history in telescope" }),
    },
    config = true,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}
