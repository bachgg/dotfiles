require("conform").setup({
  formatters_by_ft = {
    json = { { "prettierd", "prettier" } },
    lua = { "stylua" },
    python = { "black_128" },
    javascript = { { "prettierd", "prettier" } },
    javascriptreact = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    typescriptreact = { { "prettierd", "prettier" } },
    terraform = { "terraform_fmt" },
    vue = { "prettierd" }

  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters = {
    black_128 = {
      command = "black",
      args = { "--line-length", "128", "$FILENAME" },
      stdin = false
    }
  }
})
