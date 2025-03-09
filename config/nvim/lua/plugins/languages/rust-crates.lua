return {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = true,
    keys = {
        {
            "<leader>rcu",
            function()
                require("crates").upgrade_all_crates()
            end,
            desc = "Update Cargo crates",
        },
    },
}
