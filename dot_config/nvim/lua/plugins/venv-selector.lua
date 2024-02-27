return {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
        "mfussenegger/nvim-dap-python",
    },
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    opts = {
        name = { "venv", ".venv" },
        dap_enabled = true,
    },
    keys = {
        { "<leader>vs", "<cmd>VenvSelect<cr>",       desc = "Venv: Pick a virtual environment" },
        { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Venv: retrieve virtual environment from cache" },
    },
}
