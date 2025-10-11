return {


  'dynamotn/Navigator.nvim',

  config = function()
    vim.g.tmux_navigator_no_wrap = 1
    require('Navigator').setup()

    vim.keymap.set({ 'n', 't' }, "<D-h>", '<CMD>NavigatorLeft<CR>')
    vim.keymap.set({ 'n', 't' }, "<D-y>", '<CMD>NavigatorRight<CR>')
    vim.keymap.set({ 'n', 't' }, "<D-l>", '<CMD>NavigatorUp<CR>')
    vim.keymap.set({ 'n', 't' }, "<D-j>", '<CMD>NavigatorDown<CR>')

    vim.keymap.set("n", "<C-h>", require('Navigator').left)
    vim.keymap.set("n", "<C-l>", require('Navigator').right)
    vim.keymap.set("n", "<C-k>", require('Navigator').up)
    vim.keymap.set("n", "<C-j>", require('Navigator').down)
  end
}
