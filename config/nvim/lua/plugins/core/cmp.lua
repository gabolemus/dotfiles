return {
    "hrsh7th/nvim-cmp",
    -- event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",           -- Source for text in buffer
        "hrsh7th/cmp-path",             -- Source for file system paths
        "L3MON4D3/LuaSnip",             -- Snippet engine
        "saadparwaiz1/cmp_luasnip",     -- For autocompletion
        "rafamadriz/friendly-snippets", -- Useful snippets
        "onsails/lspkind.nvim",         -- VS Code like pictograms
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        -- Loads VS Code style snippets from installed plugins
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Completion highligh colors groups
        vim.api.nvim_set_hl(0, "CmpHighlight", { bg = "#85d3f2", fg = "#2d3137" })
        vim.api.nvim_set_hl(0, "CmpDocumentation", { bg = "#363944", fg = "#FFFFFF" })

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,preview,noselect",
            },
            snippet = { -- Configure how nvim-cmp interacts with snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = {
                    border = "rounded",
                    winhighlight = "CursorLine:CmpHighlight",
                },
                documentation = {
                    border = "rounded",
                    winhighlight = "Normal:CmpDocumentation,FloatBorder:Floatborder,CursorLine:Visual,Search:None",
                },
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous suggestion
                ["<C-j>"] = cmp.mapping.select_next_item(), -- Next suggestion
                ["<C-b>"] = cmp.mapping.scroll_docs(-5),
                ["<C-f>"] = cmp.mapping.scroll_docs(5),
                ["<C-Space>"] = cmp.mapping.complete(), -- Show completion suggestions
                ["<C-e>"] = cmp.mapping.abort(),        -- Close completion window
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                -- -- Jump to next placeholder in snippet
                -- ["<Tab>"] = function(fallback)
                --     if luasnip.jumpable(1) then
                --         luasnip.jump(1)
                --     else
                --         fallback()
                --     end
                -- end,
                -- -- Jump to previous placeholder in snippet
                -- ["<S-Tab>"] = function(fallback)
                --     if luasnip.jumpable(-1) then
                --         luasnip.jump(-1)
                --     else
                --         fallback()
                --     end
                -- end,
            }),
            -- Sources for autocompletion
            sources = cmp.config.sources({
                { name = "nvim_lsp" }, -- LSP
                { name = "luasnip" },  -- Snippets
                { name = "buffer" },   -- Text within current buffer
                { name = "path" },     -- File system paths
                { name = "crates" },   -- Rust crates
            }),
            -- Configure lspkind for VS Code like pictograms in completion menu
            formatting = {
                format = lspkind.cmp_format({
                    maxwidth = 50,
                    ellipsis_char = "...",
                }),
            },
        })
    end,
}
