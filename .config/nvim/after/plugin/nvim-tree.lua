vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "<S-CR>", api.node.open.vertical, opts("Up"))
end

require("nvim-tree").setup({
  on_attach = my_on_attach,
  sort = {
    sorter = "name",
  },
  view = {
    width = function()
      return math.floor(vim.opt.columns:get() * 0.2)
    end,
    number = true,
    relativenumber = true,
    signcolumn = "auto",
    centralize_selection = true,
    cursorline = true,

    float = {
      enable = false,
      quit_on_focus_loss = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * 0.6
        local window_h = screen_h * 0.6
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2)
            - vim.opt.cmdheight:get()
        return {
          border = "single",
          relative = "editor",
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
      end,
    }
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
    git_ignored = true
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
      quit_on_open = false
    }
  },
  hijack_cursor = true
})

local api = require 'nvim-tree.api'

vim.keymap.set('n', '<c-f>', function()
  api.tree.toggle({ path = "<args>", update_root = false, find_file = true, focus = true, })
end, {})
