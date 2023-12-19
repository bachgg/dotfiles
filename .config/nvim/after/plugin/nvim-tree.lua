vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort = {
    sorter = "name",
  },
  view = {
    width = 60,
    number = true,
    relativenumber = true,
    signcolumn = "auto",
    centralize_selection = true,
    cursorline = true
  },
  renderer = {
    group_empty = true,
    highlight_opened_files = "all",
    icons = {
      show = {
        folder_arrow = false
      }
    }
  },
  filters = {
    dotfiles = false,
  },
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = {},
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true
  },
  actions = {
    open_file = {
      quit_on_open = true
    }
  },
  hijack_cursor = true
})

local api = require 'nvim-tree.api'

vim.keymap.set('n', '<leader>tr', function()
  api.tree.toggle({ path = "<args>", update_root = false, find_file = true, focus = true, })
end, {})
