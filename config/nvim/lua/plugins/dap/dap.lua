return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            -- Rust
            local dap_rust = require("plugins.dap.configs.rust")
            dap.adapters.codelldb = dap_rust.adapter
            dap.configurations.rust = dap_rust.debugger

            -- NodeJS
            local dap_nodejs = require("plugins.dap.configs.nodejs")
            dap.adapters["pwa-node"] = dap_nodejs.adapter
            for _, language in ipairs({ "typescript", "javascript" }) do
                dap.configurations[language] = dap_nodejs.debugger
            end

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
        end,
    },

    -- Python
    require("plugins.dap.configs.python"),
}
