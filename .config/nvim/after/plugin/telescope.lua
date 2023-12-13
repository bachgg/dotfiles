local builtin = require('telescope.builtin')

-- vim.ui.select = 'telescope'

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gr', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader><Space>', builtin.buffers, {})

local actions = require('telescope.actions')

require('telescope').setup {
    pickers = {
        buffers = {
            initial_mode = "normal",
            mappings = {
                n = {
                    ["d"] = actions.delete_buffer
                }
            },
            sort_lastused = true
        }
    },
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous
            }
        }
    },
}
