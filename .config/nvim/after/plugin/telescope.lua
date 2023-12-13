local builtin = require('telescope.builtin')

-- vim.ui.select = 'telescope'

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gr', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader><Space>', builtin.buffers, {})

local actions = require('telescope.actions')
local actions_layout = require('telescope.actions.layout')

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
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-p>"] = actions_layout.toggle_preview
            },
            n = {
                ["<C-p>"] = actions_layout.toggle_preview
            },
        },
        preview = {
            hide_on_startup = true
        },
        borderchars = { "╌", "╎", "╌", "╎", "┌", "┐", "┘", "└" },
        results_title = "",
        prompt_prefix = " ▶ ",
        selection_caret = " ",
        entry_prefix = " "
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                initial_mode = "normal"
            }
        }
    }
}

require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")
