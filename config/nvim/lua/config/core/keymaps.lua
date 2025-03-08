-- Leader key
vim.g.mapleader = " "

----- Normal mode remaps -----

-- Line navigation remaps
-- Remaps Ctrl+Shift+{ to Ctrl+^, which moves the cursor to the first non-blank character of the line
vim.keymap.set("n", "<C-[>", "^", { silent = true, desc = "Move to first non-blank character" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "Go to next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { silent = true, desc = "Go to previous buffer" })
vim.keymap.set("n", "U", "<C-r>", { silent = true, desc = "Redo" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { silent = true, desc = "Save file" })
vim.keymap.set("n", "<leader>sa", "<cmd>wall<CR>", { silent = true, desc = "Save all buffers" })

-- Line insertion
vim.keymap.set("n", "<CR>", "m`o<Esc>``")
vim.keymap.set("n", "<C-S-CR>", "k`O<Esc>``")

----- Insert mode remaps -----
vim.keymap.set("i", "<C-H>", "<C-w>", { silent = true, desc = "Delete word to the left" })
vim.keymap.set("i", "<C-Del>", "<C-o>dw", { silent = true, desc = "Delete word to the right" })


-- Command mode remaps
vim.keymap.set(
    "c",
    "<C-k>",
    [[ wildmenumode() ? "<C-p>" : "<Up>" ]],
    { noremap = true, expr = true, desc = "Previous command search" }
)
vim.keymap.set(
    "c",
    "<C-j>",
    [[ wildmenumode() ? "<C-n>" : "<Down>" ]],
    { noremap = true, expr = true, desc = "Next command search" }
)

-- Move selected line / block in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line/block down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line/block up", silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.api.nvim_set_keymap("t", "<C-v>", "<C-r><C-o>+", { noremap = true, silent = true })

-- Exits from insert mode when pressing Ctrl-c
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>rf", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights", silent = true })

-- increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
