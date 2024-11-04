return {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
        "mfussenegger/nvim-dap-python",
    },
    ft = "python",
    event = "VeryLazy",
    config = function()
        require("venv-selector").setup()
    end,
    keys = {
        { ",vs", "<cmd>VenvSelect<cr>" },
        { ",vc", "<cmd>VenvSelectCached<cr>" },
    },
}
