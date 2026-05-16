local ExecTypes = {
    bin = "cargo build -q --message-format=json",
    tests = "cargo build --tests -q --message-format=json",
}

local function runBuild(cmd)
    local lines = vim.fn.systemlist(cmd)
    local output = table.concat(lines, "\n")
    -- Grab the final built artifact
    local filename = output:match('^.*"executable":"(.-)".-\n.*,"success":true}$')
    if not filename then
        error("Filename was not found. Did the build fail?")
    end
    return filename
end

local open_debug_ad7 = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"

return {
    adapter = {
        id = "cppdbg",
        type = "executable",
        command = open_debug_ad7,
    },
    debugger = {
        {
            name = "Debug Binary (rust-gdb)",
            type = "cppdbg",
            request = "launch",
            program = function()
                return runBuild(ExecTypes.bin)
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            MIMode = "gdb",
            miDebuggerPath = "rust-gdb",
            setupCommands = {
                { text = "-enable-pretty-printing", ignoreFailures = true },
            },
            environment = {
                { name = "RUST_BACKTRACE", value = "1" },
            },
            externalConsole = false,
        },
        {
            name = "Debug Tests (rust-gdb)",
            type = "cppdbg",
            request = "launch",
            program = function()
                return runBuild(ExecTypes.tests)
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            MIMode = "gdb",
            miDebuggerPath = "rust-gdb",
            setupCommands = {
                { text = "-enable-pretty-printing", ignoreFailures = true },
            },
            args = { "--nocapture" },
            environment = {
                { name = "RUST_BACKTRACE", value = "1" },
            },
            externalConsole = false,
        },
    },
}
