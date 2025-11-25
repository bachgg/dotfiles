-- move a block around
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- move a block around on mac
vim.keymap.set("v", "∆", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "˚", ":m '<-2<CR>gv=gv")

-- move a line around
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")

-- move a line around on mac
vim.keymap.set("n", "∆", ":m .+1<CR>==")
vim.keymap.set("n", "˚", ":m .-2<CR>==")

-- duplicate a line
vim.keymap.set("n", "<A-J>", "yyp")

-- cursor stays in the middle when page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- cursor stays in the middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- keep pasting the same thing over again
vim.keymap.set("x", "p", "\"_dP")

-- copy to system clipboard
vim.keymap.set("n", "<C-y>", "\"+y")
vim.keymap.set("v", "<C-y>", "\"+y")
vim.keymap.set("n", "<C-Y>", "\"+Y")

-- delete to void register
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- first line first character & last line last character
vim.keymap.set({ "n", "v" }, "gg", "gg0")
vim.keymap.set({ "n", "v" }, "G", "G$")

-- moving between panes
-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>")

-- resizing panes
vim.keymap.set("n", "<M-->", ":resize -3<CR>")
vim.keymap.set("n", "<M-=>", ":resize +3<CR>")
vim.keymap.set("n", "<M-_>", ":vertical resize -3<CR>")
vim.keymap.set("n", "<M-+>", ":vertical resize +3<CR>")

-- move cursor in command mode
vim.keymap.set("c", "<C-h>", "<Left>")
vim.keymap.set("c", "<C-j>", "<Down>")
vim.keymap.set("c", "<C-k>", "<Up>")
vim.keymap.set("c", "<C-l>", "<Right>")

-- search & replace
vim.keymap.set("v", "<leader>ss", "y/<C-r>\"")
-- below is replaced by nvim-rip-substitute
-- vim.keymap.set("v", "<leader>sr", "y:%s/<C-r>\"/<C-r>\"/g<Left><Left>")

-- move faster
vim.keymap.set({ "n", "v" }, "J", "4j")
vim.keymap.set({ "n", "v" }, "K", "4k")

-- insert & remove tabs from lines
vim.keymap.set('v', '<Tab>', ":<C-u>silent '<,'>normal! I    <CR>gv", { noremap = true, silent = true })
vim.keymap.set('v', '<S-Tab>', ":<C-u>silent '<,'>s/^\\%(\t\\|    \\)//e<CR>gv", { noremap = true, silent = true })
