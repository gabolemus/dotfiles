return {
    "L3MON4D3/LuaSnip",
    config = function()
        local luasnip = require("luasnip")
        local snippet = luasnip.snippet
        -- local txt_node = luasnip.text_node
        local ins_node = luasnip.insert_node
        local fmt = require("luasnip.extras.fmt").fmt

        -- Keymaps
        -- A-j/k to jump forward/backward between snippet jump points.
        vim.keymap.set({ "i", "s" }, "<A-k>", function()
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end)
        vim.keymap.set({ "i", "s" }, "<A-j>", function()
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end)

        vim.keymap.set({ "i", "s" }, "<A-n>", function()
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            end
        end)

        -- Lua snippets
        luasnip.add_snippets("lua", {
            -- Initial setup for a Love2D project.
            snippet(
                "Love2D Init",
                fmt(
                    [[
                function love.load()
                    {}
                end

                function love.update({})
                    {}
                end

                function love.draw()
                    {}
                end
                ]],
                    { ins_node(1), ins_node(2, "dt"), ins_node(3), ins_node(4) }
                )
            ),
        })
    end,
}
