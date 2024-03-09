return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    name = "harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():append()
        end, { desc = "Add buffer to Harpoon" })
        vim.keymap.set("n", "<C-M-a>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Open Harpoon list" })

        vim.keymap.set("n", "<C-A-j>", function()
            harpoon:list():select(1)
        end, { desc = "Add buffer to list (1)" })
        vim.keymap.set("n", "<C-A-k>", function()
            harpoon:list():select(2)
        end, { desc = "Add buffer to list (2)" })
        vim.keymap.set("n", "<C-A-l>", function()
            harpoon:list():select(3)
        end, { desc = "Add buffer to list (3)" })
        vim.keymap.set("n", "<C-A-n>", function()
            harpoon:list():select(4)
        end, { desc = "Add buffer to list (4)" })
    end,
}
