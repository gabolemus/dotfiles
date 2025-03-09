return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        -- Recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("neo-tree").setup({
            sources = {
                "filesystem",
                "buffers",
                "git_status",
                "document_symbols",
            },
            popup_border_style = "rounded",
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        -- Change highlight groups
                        vim.cmd("highlight NeoTreeDirectoryIcon guifg=#EABD40")
                        vim.cmd("highlight NeoTreeDirectoryName guifg=Normal")
                        -- vim.cmd("highlight NeoTreeDirectoryName guifg=#61AFEF")
                        vim.cmd("highlight NeoTreeIndentMarker guifg=#999999")
                        vim.cmd("highlight NeoTreeExpander guifg=#BDBDBD")
                        -- vim.cmd("highlight NeoTreeGitUntracked guifg=#41AC91")
                        vim.cmd("highlight NeoTreeGitUntracked guifg=#61AFEF")
                    end,
                },
            },
            default_component_configs = {
                diagnostics = {
                    symbols = {
                        hint = "󰠠",
                        info = "",
                        warn = "",
                        error = "",
                    },
                    highlights = {
                        hint = "DiagnosticSignHint",
                        info = "DiagnosticSignInfo",
                        warn = "DiagnosticSignWarn",
                        error = "DiagnosticSignError",
                    },
                },
                indent = {
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                },
                git_status = {
                    symbols = {
                        -- Change type
                        added = "✚",
                        deleted = "🗙",
                        modified = "",
                        renamed = "󰁕",
                        -- Status type
                        untracked = "",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "",
                    },
                    align = "right",
                },
            },
            filesystem = {
                scan_mode = "deep",
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                follow_current_file = {
                    leave_dirs_open = true,
                },
                hijack_netrw_behavior = "open_current",
                use_libuv_file_watcher = true,
            },
        })
        -- Custom functions
        local function revealFiles()
            local state = require("neo-tree.sources.manager").get_state("filesystem")
            require("neo-tree.sources.filesystem.commands").refresh(state)
        end

        local function closeNodes()
            local state = require("neo-tree.sources.manager").get_state("filesystem")
            require("neo-tree.sources.filesystem.commands").close_all_nodes(state)
        end

        -- Keymaps
        vim.keymap.set("n", "<leader>ee", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
        vim.keymap.set(
            "n",
            "<leader>ef",
            "<cmd>Neotree reveal focus<CR>",
            { desc = "Show the current file in the explorer" }
        )
        vim.keymap.set("n", "<leader>ec", closeNodes, { desc = "Collapse file explorer" })
        vim.keymap.set("n", "<leader>er", revealFiles, { desc = "Refresh file explorer" })
    end,
}
