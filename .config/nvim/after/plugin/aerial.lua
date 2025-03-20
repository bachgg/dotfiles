require("aerial").setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
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
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>ga", "<cmd>AerialToggle<CR>")
