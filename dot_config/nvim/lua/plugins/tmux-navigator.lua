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
        { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>",     desc = "Jump to the left buffer" },
        { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>",     desc = "Jump to the bottom buffer" },
        { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>",       desc = "Jump to the upper buffer" },
        { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>",    desc = "Jump to the right buffer" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Jump to the previous buffer" },
    },
}
