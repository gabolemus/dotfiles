return {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    config = function()
        local crates = require("crates")
        crates.setup({})

        -- Bindings
        vim.keymap.set("n", "<leader>rcu", function()
            crates.upgrade_all_crates()
        end, { desc = "Upgrade all cargo crates" })
    end,
}
