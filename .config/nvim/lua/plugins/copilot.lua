return {
  -- Ghost text autocompletion (inline suggestions while typing)
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },

  -- AI Chat / Agent / Sidebar (Cursor-like experience)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "copilot", -- Uses your existing GitHub Copilot subscription
      mode = "agentic",
      behaviour = {
        auto_suggestions = false, -- Use copilot.vim for this instead
      },
    },
  },
}
