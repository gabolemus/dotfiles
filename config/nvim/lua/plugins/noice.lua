return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = true,
    keys = {
        { "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "Dismiss notification pop-ups" },
        { "<leader>nl", "<cmd>Noice last<cr>", desc = "Show the last notification pop-up" },
        { "<leader>ne", "<cmd>Noice errors<cr>", desc = "Show errors in a split" },
        { "<leader>nt", "<cmd>Noice telescope<cr>", desc = "Opens noice notifications in a Telescope window" },
    },
}
