return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    cmd = "Telescope",
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                path_display = { "truncate " },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                        ["<C-j>"] = actions.move_selection_next,     -- move to next result
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
        })

        telescope.load_extension("fzf")
    end,
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Fuzzy find files in cwd" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>",    desc = "Fuzzy find recent files" },
        { "<leader>fs", "<cmd>Telescope live_grep<cr>",   desc = "Fuzzy find string in cwd" },
        { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Fuzzy find buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Fuzzy find help tags" },
        { "<leader>fg", "<cmd>Telescope git_files<cr>",   desc = "Fuzzy find git files" },
        {
            "<leader>fo",
            function()
                require("telescope.builtin").find_files({ search_dirs = { "~" } })
            end,
            desc = "Fuzzy find in home directory",
        },
    },
}
