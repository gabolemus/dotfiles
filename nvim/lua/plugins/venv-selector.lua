return {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = {
        "neovim/nvim-lspconfig",
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python",
        { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    ft = "python",
    lazy = false,
    event = "VeryLazy",
    config = function()
        require("venv-selector").setup()
    end,
    keys = {
        { ",vs", "<cmd>VenvSelect<cr>" },
        { ",vc", "<cmd>VenvSelectCached<cr>" },
    },
}
