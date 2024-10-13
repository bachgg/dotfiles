require('Navigator').setup()

vim.keymap.set({ 'n', 't' }, "<D-h>", '<CMD>NavigatorLeft<CR>')
vim.keymap.set({ 'n', 't' }, "<D-y>", '<CMD>NavigatorRight<CR>')
vim.keymap.set({ 'n', 't' }, "<D-l>", '<CMD>NavigatorUp<CR>')
vim.keymap.set({ 'n', 't' }, "<D-j>", '<CMD>NavigatorDown<CR>')
