return {
    "L3MON4D3/LuaSnip",
    config = function()
        local luasnip = require("luasnip")
        -- local snippet = luasnip.snippet
        -- local txt_node = luasnip.text_node
        -- local ins_node = luasnip.insert_node
        -- local fmt = require("luasnip.extras.fmt").fmt

        -- Keymaps
        -- Alt-j/k to jump forward/backward between snippet jump points.
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
    end,
}
