-- Function to check if process is running
function IsProcessRunning(processName)
    local cmd = "pgrep " .. processName
    local handle = io.popen(cmd)
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result ~= ""
    else
        return nil
    end
end

-- Runs Love2D on Windows on the parent directory of the currently opened buffer
-- or on the root directory if no buffer is opened.
function RunLove2D()
    local cmd = "/mnt/c/Program\\ Files/LOVE/love.exe"
    local directory

    -- Check if there's a buffer opened
    if vim.fn.bufexists(0) == 1 then
        -- Get the path of the parent directory of the current buffer
        local buffer_path = vim.fn.expand("%:p:h")
        directory = vim.fn.substitute(buffer_path, "\\", "/", "g")
    else
        -- If no buffer is opened, use the root directory
        directory = vim.loop.cwd()
    end

    -- Execute the command
    local full_cmd = string.format('%s "$(wslpath -w "%s")"', cmd, directory)
    -- vim.fn.system(full_cmd)

    -- local job_id = vim.fn.jobstart(full_cmd, {
    vim.fn.jobstart(full_cmd, {
        detach = 1, -- Run the job in the background
        on_exit = function(_, code, _)
            if code ~= 0 then
                vim.notify("Error: Love2D exited with code " .. code, vim.log.levels.ERROR)
            end
        end,
    })
    vim.notify("Love2D started in the background.", vim.log.levels.INFO)
end

-- Stops the Love2D process running in Windows
function StopLove2D()
    local cmd = "/mnt/c/Program\\ Files/PowerShell/7/pwsh.exe"
    local args = { "-Command", '"(Get-Process -Name love).CloseMainWindow()"' }

    -- Execute the command asynchronously
    local full_cmd = string.format("%s %s", cmd, table.concat(args, " "))
    -- local job_id = vim.fn.jobstart(full_cmd, {
    vim.fn.jobstart(full_cmd, {
        on_exit = function(_, code, _)
            if code ~= 0 then
                vim.notify("Failed to stop Love2D process. Exit code: " .. code, vim.log.levels.ERROR)
            else
                vim.notify("Love2D process stopped successfully", vim.log.levels.INFO)
            end
        end,
    })
    vim.notify("Stopping the Love2D process.", vim.log.levels.INFO)
end
