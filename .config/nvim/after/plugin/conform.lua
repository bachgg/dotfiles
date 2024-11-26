require("conform").setup({
  default_format_opts = {
    stop_after_first = true
  },
  formatters_by_ft = {
    json = { "prettierd", "prettier" },
    lua = { "stylua" },
    python = { "black_128" },
    javascript = { "prettierd", "prettier" },
    javascriptreact = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    typescriptreactl = { "prettierd", "prettier" },
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
      meta = { url = "https://github.com/psf/black", description = "The uncompromising Python code formatter." },
      command = "black",
      stdin = true,
      args = { "--line-length", "128", "--stdin-filename", "$FILENAME", "--quiet", "-" },
      range_args = function(self, ctx)
        return { "--line-ranges", ctx.range["start"][1] .. "-" .. ctx.range["end"][1] }
      end,
      cwd = require("conform.util").root_file({
        "pyproject.toml",
      })
    }
  }
})
