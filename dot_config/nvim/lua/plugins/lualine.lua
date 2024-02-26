return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status") -- To configure lazy pending updates count

        lualine.setup({
            options = {
                disabled_filetypes = {
                    "NvimTree",
                    "undotree",
                    "diff",
                    "help",
                    "qf",
                    "dapui_scopes",
                    "dapui_breakpoints",
                    "dapui_stacks",
                    "dapui_watches",
                    "dapui_repl",
                    "dapui_console",
                },
            },
            sections = {
                -- lualine_c = {
                --     "buffers",
                --     "filename",
                -- },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#ff9e64" },
                    },
                    { "encoding" },
                    { "fileformat" },
                    { "filetype" },
                },
            },
        })
    end,
}
