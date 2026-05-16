vim.api.nvim_create_user_command("DiffYankWithSelection", function(opts)
    local reg = opts.args ~= "" and opts.args or '"'
    local yanked = vim.fn.getreg(reg, 1, true)

    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

    vim.cmd("tabnew")
    local left = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(left, 0, -1, false, yanked)
    vim.bo[left].buftype = "nofile"
    vim.bo[left].bufhidden = "wipe"
    vim.bo[left].swapfile = false
    vim.cmd("diffthis")

    vim.cmd("vnew")
    local right = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(right, 0, -1, false, lines)
    vim.bo[right].buftype = "nofile"
    vim.bo[right].bufhidden = "wipe"
    vim.bo[right].swapfile = false
    vim.cmd("diffthis")
end, {
    range = true,
    nargs = "?",
})
