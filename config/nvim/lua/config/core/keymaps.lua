--------------------------------------------------------------------
--  Leader key
--------------------------------------------------------------------
vim.g.mapleader = " "

--------------------------------------------------------------------
--  Helpers
--------------------------------------------------------------------
local map  = vim.keymap.set          -- convenience alias
local opts = { silent = true }       -- default opts

-- Shorthand for normal-mode maps with description
local function n(lhs, rhs, desc)
    map("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
end

--------------------------------------------------------------------
--  Normal-mode navigation / editing
--------------------------------------------------------------------
n("<C-[>", "^",         "First non-blank char")          -- overrides default Esc in Normal only
n("J",       "mzJ`z",   "Join lines keep cursor")        -- keep cursor in place
n("<C-d>",   "<C-d>zz", "½-page down & recenter")
n("<C-u>",   "<C-u>zz", "½-page up & recenter")
n("n",       "nzzzv",   "Next search & unfold")
n("N",       "Nzzzv",   "Prev search & unfold")

-- Insert blank lines without entering Insert mode
n("<CR>",       "m`o<Esc>``",  "New line below (stay Normal)")
n("<S-CR>",     "m`O<Esc>``",  "New line above (stay Normal)")  -- Shift-Enter works in most terms

--------------------------------------------------------------------
--  Buffer & file handles
--------------------------------------------------------------------
--vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "Go to next buffer" })
n("<leader>bn", ":bnext<CR>",     "Next buffer")
n("<leader>bp", ":bprevious<CR>", "Previous buffer")
n("<C-s>",      "<cmd>w<CR>",     "Save file")
n("<leader>sa", "<cmd>wall<CR>",  "Save all buffers")
n("U",          "<C-r>",          "Redo")

--------------------------------------------------------------------
--  Quickfix / loclist navigation
--------------------------------------------------------------------
n("<C-k>",      "<cmd>cnext<CR>zz",   "Quickfix next")
n("<C-j>",      "<cmd>cprev<CR>zz",   "Quickfix prev")
n("<leader>k>", "<cmd>lnext<CR>zz",   "Loclist next")
n("<leader>j>", "<cmd>lprev<CR>zz",   "Loclist prev")

--------------------------------------------------------------------
--  Search helpers
--------------------------------------------------------------------
n("<leader>nh", ":nohl<CR>",                                            "Clear search highlight")
n("<leader>rf", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace word under cursor")

--------------------------------------------------------------------
--  Number increment / decrement
--------------------------------------------------------------------
n("<leader>+", "<C-a>", "Increment number")
n("<leader>-", "<C-x>", "Decrement number")

--------------------------------------------------------------------
--  Window management
--------------------------------------------------------------------
n("<leader>sv", "<C-w>v", "Split vertically")
n("<leader>sh", "<C-w>s", "Split horizontally")
n("<leader>se", "<C-w>=", "Equalize splits")
n("<leader>sx", "<cmd>close<CR>", "Close split")

--------------------------------------------------------------------
--  Tab management
--------------------------------------------------------------------
n("<leader>to", "<cmd>tabnew<CR>",     "New tab")
n("<leader>tx", "<cmd>tabclose<CR>",   "Close tab")
n("<leader>tn", "<cmd>tabn<CR>",       "Next tab")
n("<leader>tp", "<cmd>tabp<CR>",       "Prev tab")
n("<leader>tf", "<cmd>tabnew %<CR>",   "Current buffer in new tab")

--------------------------------------------------------------------
--  Visual-mode text movement
--------------------------------------------------------------------
map("v", "J", ":m '>+1<CR>gv=gv", vim.tbl_extend("keep", opts, { desc = "Move block down" }))
map("v", "K", ":m '<-2<CR>gv=gv", vim.tbl_extend("keep", opts, { desc = "Move block up" }))

--------------------------------------------------------------------
--  Registers / clipboard helpers
--------------------------------------------------------------------
map("x", "<leader>p", [["_dP]],      { silent = true, desc = "Paste over (keep clipboard)" })
map({ "n", "v" }, "<leader>y", [["+y]],  { silent = true, desc = "Yank to system clipboard" })
n("<leader>Y",     [["+Y]],              "Yank line to system clipboard")
map({ "n", "v" }, "<leader>d", [["_d]],  { silent = true, desc = "Delete to black-hole" })

--------------------------------------------------------------------
--  Terminal-mode paste
--------------------------------------------------------------------
map("t", "<C-v>", "<C-r><C-o>+", { silent = true, desc = "Paste clipboard in terminal" })

--------------------------------------------------------------------
--  Insert-mode extras
--------------------------------------------------------------------
map("i", "<C-h>",  "<C-w>",   { silent = true, desc = "Delete word left" })
map("i", "<C-Del>","<C-o>dw",{ silent = true, desc = "Delete word right" })
map("i", "<C-c>",  "<Esc>",   { silent = true, desc = "Leave insert (Ctrl-c)" })

--------------------------------------------------------------------
--  Command-line (:) navigation
--------------------------------------------------------------------
map("c", "<C-k>", [[wildmenumode() ? "<C-p>" : "<Up>"]],   { expr = true, desc = "Cmd-line previous" })
map("c", "<C-j>", [[wildmenumode() ? "<C-n>" : "<Down>"]], { expr = true, desc = "Cmd-line next" })

--------------------------------------------------------------------
--  Misc quality-of-life
--------------------------------------------------------------------
n("Q", "<nop>", "Disable Ex mode")
