require("config.core.clipboard")
require("config.core.cursor")
require("config.core.keymaps")
require("config.core.languages")
require("config.core.options")

if vim.g.vscode then
    vim.cmd([[source $HOME/.config/nvim/lua/config/vscode/settings.vim]])
end
