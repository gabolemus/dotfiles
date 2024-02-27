return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    dependencies = {
        "HiPhish/rainbow-delimiters.nvim",
    },
    config = function()
        local ibl = require("ibl")
        local hooks = require("ibl.hooks")
        local rdl = require("rainbow-delimiters.setup")
        local rainbow = require("rainbow-delimiters")

        -- Indent blankline config
        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        -- Create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)

        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        vim.g.rainbow_delimiters = { highlight = highlight }

        local web_dev_setup = {
            "statement_block",
            "function",
            "arrow_function",
            "function_declaration",
            "method_definition",
            "if_statement",
            "for_statement",
            "for_in_statement",
            "catch_clause",
            "object_pattern",
            "arguments",
            "switch_case",
            "switch_statement",
            "switch_default",
            "array",
            "object",
            "object_type",
            "ternary_expression",
            "return_statement",
            "parenthesized_expression",
        }

        ibl.setup({
            scope = {
                highlight = highlight,
                show_start = false,
                show_end = false,
                include = {
                    node_type = {
                        lua = {
                            "do_statement",
                            "while_statement",
                            "repeat_statement",
                            "if_statement",
                            "for_statement",
                            "function_declaration",
                            "function_definition",
                            "table_constructor",
                        },
                        javascript = web_dev_setup,
                        typescript = web_dev_setup,
                        javascriptreact = web_dev_setup,
                        typescriptreact = web_dev_setup,
                        python = {
                            "function_definition",
                            "class_definition",
                            "if_statement",
                            "for_statement",
                            "while_statement",
                            "with_statement",
                            "try_statement",
                            "except_clause",
                            "finally_clause",
                            "except_clause",
                        },
                        java = {
                            "class_declaration",
                            "interface_declaration",
                            "enum_declaration",
                            "method_declaration",
                            "constructor_declaration",
                            "field_declaration",
                            "block",
                            "if_statement",
                            "for_statement",
                            "while_statement",
                            "do_statement",
                            "switch_statement",
                            "try_statement",
                            "catch_clause",
                            "finally_clause",
                            "synchronized_statement",
                            "assert_statement",
                            "return_statement",
                            "throw_statement",
                            "break_statement",
                            "continue_statement",
                            "expression_statement",
                            "lambda_expression",
                            "method_reference",
                            "constructor_reference",
                            "array_initializer",
                            "array_access",
                            "array_creation",
                            "array_type",
                            "assert_expression",
                            "assignment",
                            "binary_expression",
                            "cast_expression",
                            "class_instance_creation",
                            "conditional_expression",
                            "field_access",
                            "instanceof_expression",
                            "lambda_expression",
                            "method_invocation",
                            "switch_label",
                            "switch_expression",
                            "switch_block",
                            "switch_block_statement_group",
                        },
                        scheme = {
                            "list",
                        },
                        tex = {
                            "class_include",
                            "package_include",
                        },
                    },
                },
                exclude = {
                    -- Exclude HTML tags on web dev filetypes
                    node_type = {
                        javascript = {
                            "jsx_element",
                            "jsx_self_closing_element",
                            "jsx_closing_element",
                            "jsx_expression",
                        },
                        typescript = {
                            "jsx_element",
                            "jsx_self_closing_element",
                            "jsx_closing_element",
                            "jsx_expression",
                        },
                        javascriptreact = {
                            "jsx_element",
                            "jsx_self_closing_element",
                            "jsx_closing_element",
                            "jsx_expression",
                        },
                        typescriptreact = {
                            "jsx_element",
                            "jsx_self_closing_element",
                            "jsx_closing_element",
                            "jsx_expression",
                        },
                    },
                },
            },
        })

        -- Rainbow delimiters config
        rdl.setup({
            strategy = {
                [""] = rainbow.strategy["global"],
                vim = rainbow.strategy["local"],
                html = rainbow.strategy["local"],
                -- -- Pick the strategy for LaTeX dynamically based on the buffer size
                -- tex = function()
                --     -- Disabled for very large files, global strategy for large files,
                --     -- local strategy otherwise
                --     if vim.fn.line("$") > 10000 then
                --         return nil
                --     elseif vim.fn.line("$") > 1000 then
                --         return rainbow.strategy["global"]
                --     end
                --     return rainbow.strategy["local"]
                -- end,
            },
            query = {
                [""] = "rainbow-delimiters",
                lua = "rainbow-blocks",
            },
            priority = {
                [""] = 110,
                lua = 210,
            },
            highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            },
        })
    end,
}
