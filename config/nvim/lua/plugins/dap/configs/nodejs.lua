return {
    adapter = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = {
                require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
                "${port}",
            },
        },
    },
    debugger = {
        { -- Debug single NodeJS file
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
            skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            sourceMaps = true,
        },
        { -- Debug NodeJS processes
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            sourceMaps = true,
        },
        { -- Debug web applications (client side)
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
                local co = coroutine.running()
                return coroutine.create(function()
                    vim.ui.input({
                        prompt = "Enter URL: ",
                        default = "http:--localhost:3000",
                    }, function(url)
                        if url == nil or url == "" then
                            return
                        else
                            coroutine.resume(co, url)
                        end
                    end)
                end)
            end,
            webRoot = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
        },
    },
}
