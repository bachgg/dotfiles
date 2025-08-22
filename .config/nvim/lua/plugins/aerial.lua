return {
  'stevearc/aerial.nvim',
  enabled = false,
  opts = {
    on_attach = function(bufnr)
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,

    layout = {
      max_width = { 60, 0.3 },
      min_width = { 0.3, 30 },
      resize_to_content = false
    },

    highlight_on_hover = true,
    autojump = true,
    show_guides = true

  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
  keys = {
    { "<C-g>", "<cmd>AerialToggle<CR>", "n" }
  }
}
