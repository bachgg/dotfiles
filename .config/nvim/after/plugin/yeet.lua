require('yeet').setup({
  opts = {
    -- Send <CR> to channel after command for immediate execution.
    yeet_and_run = true,
    -- Send C-c before execution
    interrupt_before_yeet = false,
    -- Send 'clear<CR>' to channel before command for clean output.
    clear_before_yeet = true,
    -- Enable notify for yeets. Success notifications may be a little
    -- too much if you are using noice.nvim or fidget.nvim
    notify_on_success = true,
    -- Print warning if pane list could not be fetched, e.g. tmux not running.
    warn_tmux_not_running = false,
    -- Use cache.
    cache = true,
    -- Window options for cache float
    cache_window_opts = {
      relative = "editor",
      row = (vim.o.lines - 15) * 0.5,
      col = (vim.o.columns - math.ceil(0.6 * vim.o.columns)) * 0.5,
      width = math.ceil(0.6 * vim.o.columns),
      height = 15,
      border = "single",
      title = "Yeet",
    },
  }
})

local yeet = require('yeet')
local keys = {
  {
    -- Pop command cache open
    "<leader><BS>",
    function() require("yeet").list_cmd() end,
  },
  {
    -- Open target selection
    "<leader>yt", function() require("yeet").select_target() end,
  },
  {
    -- Douple tap \ to yeet at something
    "\\\\", function() require("yeet").execute() end,
  },
  {
    -- Toggle autocommand for yeeting after write
    "<leader>yo", function() require("yeet").toggle_post_write() end,
  },
  {
    -- Run command without clearing terminal, send C-c
    "<leader>\\", function()
    require("yeet").execute(nil, { clear_before_yeet = false, interrupt_before_yeet = true })
  end,
  },
  {
    -- Yeet visual selection. Useful sending core to a repl or running multiple commands.
    "<leader>yv",
    function() require("yeet").execute_selection({ clear_before_yeet = false }) end,
    mode = { "n", "v" },
  },
}

local function setkeys()
  for k, v in pairs(keys) do
    vim.keymap.set('n', v[1], v[2])
  end
end

setkeys()
