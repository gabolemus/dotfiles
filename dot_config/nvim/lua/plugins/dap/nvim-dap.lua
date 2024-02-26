return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require("dap")

        -- Lua debug configuration
        dap.adapters["local-lua"] = {
            type = "executable",
            command = "node",
            args = {
                "/opt/local-lua-debugger-vscode/extension/debugAdapter.js",
            },
            enrich_config = function(config, on_config)
                if not config["extensionPath"] then
                    local c = vim.deepcopy(config)
                    c.extensionPath = "/opt/local-lua-debugger-vscode/"
                    on_config(c)
                else
                    on_config(config)
                end
            end,
        }
        dap.configurations.lua = {
            {
                name = "Debug current file (local-lua-dbg, lua)",
                type = "local-lua",
                request = "launch",
                cwd = "${workspaceFolder}",
                program = {
                    lua = "lua",
                    file = "${file}",
                },
                args = {},
            },
        }

        -- Node debug adapter
        dap.adapters["pwa-node"] = {
            type = "server",
            host = "127.0.0.1",
            port = 8123,
            executable = {
                command = "js-debug-adapter",
            },
        }

        -- JavaScript and TypeScript debug configurations with pwa-node
        for _, language in ipairs({ "javascript", "typescript" }) do
            dap.configurations[language] = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    runtimeExecutable = "node",
                },
            }
        end
    end,
}
