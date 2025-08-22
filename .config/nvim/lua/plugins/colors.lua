return {
  {
    'deparr/tairiki.nvim',
    enabled = false,
    lazy = false,
    priority = 1000, -- recommended if you use tairiki as your default theme
    config = function()
      require("tairiki").setup({
        palette = "dark",
        transparent = true
      })
      vim.cmd.colorscheme("tairiki")
    end
  },
  {
    "cpea2506/one_monokai.nvim",
    enabled = true,
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {},
    config = function()
      require("one_monokai").setup({ transparent = true }) -- https://github.com/neovim/neovim/issues/22614
      vim.cmd.colorscheme("one_monokai")
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        theme = 'one_monokai',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { '' },
        lualine_y = { 'filesize' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}

    }
  },
}
