return {
    "folke/noice.nvim",
    enabled = true,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    event = "VeryLazy",
    config = true,
    opts = {
        lsp = {
            hover = {
                enabled = false,
            },
        },
    },
    keys = {
        { "<leader>nd", "<cmd>Noice dismiss<cr>",   desc = "Dismiss notification pop-ups" },
        { "<leader>nl", "<cmd>Noice last<cr>",      desc = "Show the last notification" },
        { "<leader>ne", "<cmd>Noice errors<cr>",    desc = "Show the errors in a split" },
        { "<leader>nt", "<cmd>Noice telescope<cr>", desc = "Opens the message history in Telescope" },
    },
}
