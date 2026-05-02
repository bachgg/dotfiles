return {
  "samharju/yeet.nvim",
  dependencies = {
    "stevearc/dressing.nvim",
  },
  version = "*",
  cmd = "Yeet",
  keys = {
    { "<leader><BS>", function() require("yeet").list_cmd() end },
    { "<leader>yt",   function() require("yeet").select_target() end },
    { "\\\\",         function() require("yeet").execute() end },
    { "<leader>yo",   function() require("yeet").toggle_post_write() end },
    {
      "<leader>\\",
      function() require("yeet").execute(nil, { clear_before_yeet = false, interrupt_before_yeet = true }) end,
    },
    {
      "<leader>yv",
      function() require("yeet").execute_selection({ clear_before_yeet = false }) end,
      mode = { "n", "v" },
    },
  },
  opts = {
    yeet_and_run = true,
    interrupt_before_yeet = false,
    clear_before_yeet = true,
    notify_on_success = true,
    warn_tmux_not_running = false,
    cache = true,
    cache_window_opts = {
      relative = "editor",
      row = (vim.o.lines - 15) * 0.5,
      col = (vim.o.columns - math.ceil(0.6 * vim.o.columns)) * 0.5,
      width = math.ceil(0.6 * vim.o.columns),
      height = 15,
      border = "single",
      title = "Yeet",
    },
  },
}
