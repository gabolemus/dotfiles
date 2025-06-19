return {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    config = function()
        local debugpy_path = require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/bin/python"
        require("dap-python").setup(debugpy_path)
    end,
}
