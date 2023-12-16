vim.keymap.set('n', '<leader>ft', '<cmd>FloatermNew --cwd=<buffer-root><cr>', {})
vim.keymap.set('n', '<leader>git', '<cmd>FloatermNew --cwd=<buffer-root> lazygit<cr>', {})

vim.g.floaterm_width = 0.6
vim.g.floaterm_height = 0.6
vim.g.floaterm_title = ''
vim.g.floaterm_opener = 'edit'
