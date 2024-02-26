return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local nvimtree = require("nvim-tree")

        -- Recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- Set colors
        -- Folder
        vim.cmd("highlight NvimTreeFolderIcon guifg=#EABD40")
        vim.cmd("highlight NvimTreeOpenedFolderIcon guifg=#EABD40")
        vim.cmd("highlight NvimTreeClosedFolderIcon guifg=#EABD40")

        nvimtree.setup({
            view = {
                width = 35,
                relativenumber = true,
            },
            renderer = {
                indent_markers = {
                    enable = true,
                },
                icons = {
                    show = {
                        modified = true,
                    },
                    glyphs = {
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                        },
                    },
                },
            },
            git = {
                ignore = false,
            },
            modified = {
                enable = true,
            },
            diagnostics = {
                enable = true,
            },
        })

        -- Set keymaps
        vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        vim.keymap.set(
            "n",
            "<leader>ef",
            "<cmd>NvimTreeFindFile<CR>",
            { desc = "Toggle file explorer on current file" }
        )
        vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
        vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
    end,
}
