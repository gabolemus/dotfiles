local ExecTypes = {
    bin = "cargo build -q --message-format=json",
    tests = "cargo build --tests -q --message-format=json",
}

local function runBuild(type)
    -- Execute the Cargo build command based on the provided type ("BIN" or "TEST")
    local lines = vim.fn.systemlist(type)

    -- Concatenate the lines of the build output into a single string
    local output = table.concat(lines, "\n")

    -- Use regex to extract the executable from the build output
    local filename = output:match('^.*"executable":"(.*)",.*\n.*,"success":true}$')

    -- if filename is not found (nil), print error message and return
    if filename == nil then
        return error("Filename was not found.")
    end

    return filename
end

return {
    adapter = {
        name = "codelldb",
        type = "executable",
        command = require("mason-registry").get_package("codelldb"):get_install_path() .. "/codelldb",
    },
    debugger = {
        {
            name = "Debug Binary",
            type = "codelldb",
            request = "launch",
            program = function()
                return runBuild(ExecTypes.bin)
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            showDisassembly = "never",
        },
        {
            name = "Debug Tests",
            type = "codelldb",
            request = "launch",
            program = function()
                return runBuild(ExecTypes.tests)
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            showDisassembly = "never",
            env = { RUSTFLAGS = "-Clinker=ld.mold" },
            sourceLanguages = { "rust" },
        },
    },
}
