return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",     desc = "Jump to the left buffer" },
        { "<C-j>", "<cmd>TmuxNavigateDown<cr>",     desc = "Jump to the bottom buffer" },
        { "<C-k>", "<cmd>TmuxNavigateUp<cr>",       desc = "Jump to the upper buffer" },
        { "<C-l>", "<cmd>TmuxNavigateRight<cr>",    desc = "Jump to the right buffer" },
        { "<C-p>p", "<cmd>TmuxNavigatePrevious<cr>", mode = { "n" }, desc = "Jump to the previous buffer" },
    },
    config = function()
        vim.g.tmux_navigator_save_on_switch = 2 -- Write all buffers when navigating from Neovim to a tmux pane
        vim.g.tmux_navigator_disable_netrw_workaround = 1
    end,
}
