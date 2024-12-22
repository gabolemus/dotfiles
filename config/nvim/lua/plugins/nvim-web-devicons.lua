return {
    "nvim-tree/nvim-web-devicons",
    config = function()
        require("nvim-web-devicons").setup({
            override = {
                [".gitignore"] = {
                    icon = "",
                    color = "#f1502f",
                    cterm_color = "166",
                    name = "Gitignore",
                },
                log = {
                    icon = "",
                    color = "#81e043",
                    cterm_color = "71",
                    name = "Log",
                },
                ts = {
                    icon = "󰛦",
                    color = "#3178c6",
                    cterm_color = "24",
                    name = "Typescript",
                },
            },
        })
    end,
}
