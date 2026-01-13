return {
  'stevearc/conform.nvim',
  opts = {
    default_format_opts = {
      stop_after_first = true
    },
    formatters_by_ft = {
      json = { "biome", "prettierd", "prettier" },
      lua = { "stylua" },
      javascript = { "biome", "prettierd", "prettier" },
      javascriptreact = { "biome", "prettierd", "prettier" },
      typescript = { "biome", "prettierd", "prettier" },
      typescriptreact = { "biome", "prettierd", "prettier" },
      html = { "biome", "prettierd", "prettier" },
      terraform = { "terraform_fmt" },
      vue = { "prettierd", "prettier" },
      kdl = { "kdlfmt" }
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },
  }

}
