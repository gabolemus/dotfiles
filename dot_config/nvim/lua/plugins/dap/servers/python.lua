return {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
    },
    config = function()
        local path = vim.fn.exepath("python3")
        local dap_python = require("dap-python")
        dap_python.setup(path)

        -- Bindings
        vim.keymap.set(
            "n",
            "<leader>dpr",
            "<cmd>lua require('dap-python').test_method()<CR>",
            { desc = "Debug: Run python test method" }
        )
    end,
}
