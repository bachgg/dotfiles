vim.keymap.set({ 'n', 't' }, '<C-\\>', '<cmd>FloatermToggle --cwd=<buffer-root><cr>', {})
vim.keymap.set('n', '<leader>gi', '<cmd>FloatermNew --height=0.95 --width=0.95 --cwd=<buffer-root> lazygit<cr>', {})

vim.g.floaterm_width = 0.6
vim.g.floaterm_height = 0.6
vim.g.floaterm_title = ''
vim.g.floaterm_opener = 'edit'


vim.api.nvim_create_autocmd("VimEnter", {
  command = 'hi FloatermBorder guifg=#dcd7ba guibg=#00000000'
})
