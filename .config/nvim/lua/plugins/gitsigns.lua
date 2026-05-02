return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  keys = {
    { "gb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Git blame line" },
    {
      "gB",
      function()
        local commit = require("gitsigns").get_hunks and vim.fn.system("git blame -l -L" .. vim.fn.line(".") .. "," .. vim.fn.line(".") .. " -- " .. vim.fn.expand("%")):match("^(%x+)")
        if not commit or commit:match("^0+$") then
          vim.notify("Not committed yet", vim.log.levels.WARN)
          return
        end
        local remote = vim.fn.system("git remote get-url origin"):gsub("%s+$", "")
        local url = remote:gsub("git@(.+):(.+)%.git", "https://%1/%2"):gsub("%.git$", "")
        url = url .. "/commit/" .. commit
        vim.fn.system({ "open", url })
      end,
      desc = "Open blame commit on GitHub",
    },
  },
  opts = {
    signs                        = {
      add          = { text = '│' },
      change       = { text = '│' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir                 = {
      follow_files = true
    },
    attach_to_untracked          = true,
    current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
      virt_text = true,
      virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
      delay = 300,
      ignore_whitespace = false,
      virt_text_priority = 100,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil, -- Use default
    max_file_length              = 40000, -- Disable if file is longer than this (in lines)
    preview_config               = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
  }
}
