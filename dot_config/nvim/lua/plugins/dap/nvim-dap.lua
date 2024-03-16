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

        -- -- CodeLLDB debug adapter
        -- dap.adapters["codelldb"] = {
        --     type = "server",
        --     port = "${port}",
        --     executable = {
        --         command = require("mason-registry").get_package("codelldb"):get_install_path()
        --             .. "/extension/adapter/codelldb",
        --         args = { "--port", "${port}" },
        --         -- detached = false,
        --     },
        -- }
        --
        -- -- Rust
        -- dap.configurations["rust"] = {
        --     {
        --         name = "Debug with codelldb",
        --         type = "codelldb",
        --         request = "launch",
        --         program = function()
        --             vim.fn.jobstart("cargo build")
        --             return vim.fn.input({
        --                 prompt = "Path to executable: ",
        --                 default = vim.fn.getcwd() .. "/",
        --                 completion = "file",
        --             })
        --         end,
        --         cwd = "${workspaceFolder}",
        --         stopOnEntry = false,
        --         sourceLanguages = { "rust" },
        --         showDisassembly = "never",
        --     },
        --     {
        --         name = "Debug tests",
        --         type = "codelldb",
        --         request = "launch",
        --         program = function()
        --             vim.fn.jobstart("cargo test --no-run")
        --
        --             -- -- The debuggable file will be in the target/debug directory
        --             -- -- But there'll be other files, so we need to filter the one
        --             -- -- without an extension.
        --             -- local files = vim.fn.glob(vim.fn.getcwd() .. "/target/debug/*")
        --             -- local file = ""
        --             -- for _, f in ipairs(files) do
        --             --     if not string.match(f, "%..+") then
        --             --         file = f
        --             --         break
        --             --     end
        --             -- end
        --             return vim.fn.input({
        --                 prompt = "Path to test executable: ",
        --                 -- Present the whole path, but only use the directory
        --                 -- as the default value.
        --                 -- default = file,
        --                 default = vim.fn.getcwd() .. "/target/debug/",
        --                 completion = "file",
        --             })
        --         end,
        --         problemMatcher = { "$rustc" },
        --         cwd = "${workspaceFolder}",
        --         stopOnEntry = false,
        --         sourceLanguages = { "rust" },
        --         showDisassembly = "never",
        --     },
        -- }

        -- Node debug adapter
        dap.adapters["pwa-node"] = {
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
        }

        -- JavaScript and TypeScript debug configurations with pwa-node
        -- Todo: add javascriptreact and typescriptreact to the configs
        for _, language in ipairs({ "javascript", "typescript" }) do
            dap.configurations[language] = {
                -- Debug single NodeJS files
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    sourceMaps = true,
                },
                -- Debug NodeJS processes
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach",
                    processId = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                    sourceMaps = true,
                },
                -- Debug web applications (client side)
                {
                    type = "pwa-chrome",
                    request = "launch",
                    name = "Launch & Debug Chrome",
                    url = function()
                        local co = coroutine.running()
                        return coroutine.create(function()
                            vim.ui.input({
                                prompt = "Enter URL: ",
                                default = "http://localhost:3000",
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
                    skipFiles = { "<node_internals>/**/*.js" },
                    protocol = "inspector",
                    sourceMaps = true,
                    userDataDir = false,
                },
            }
        end

        -- C# debug adapter
        dap.adapters.coreclr = {
            type = "executable",
            command = "/home/gabo/.local/share/nvim/mason/packages/netcoredbg/libexec/netcoredbg/netcoredbg",
            args = { "--interpreter=vscode" },
        }

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
                end,
            },
        }
    end,
}
