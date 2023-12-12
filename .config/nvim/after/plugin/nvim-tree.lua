vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 45,
        number = true,
        relativenumber = true
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
    update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
    },
})

local api = require 'nvim-tree.api'

vim.keymap.set('n', '<leader>tr', function()
    api.tree.toggle({ path = "<args>", update_root = false, find_file = true, focus = true, })
end, {})
