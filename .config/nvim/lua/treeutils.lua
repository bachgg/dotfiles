local api = require("nvim-tree.api")
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local M = {}

-- TODO
-- 1. highlight file when switching buffer
-- 2. find file globally instead of in current dir
-- 3. integrate with <leader>gf, <leader>ff and <leader>pv to highlight file if nvim-tree is open

local view_selection = function(prompt_bufnr, map)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if (filename == nil) then
            filename = selection[1]
        end
        api.tree.open()
        api.tree.find_file(filename)
        api.node.open.edit()
    end)
    return true
end

function M.launch_live_grep(opts)
    return M.launch_telescope("live_grep", opts)
end

function M.launch_find_files(opts)
    return M.launch_telescope("find_files", opts)
end

function M.launch_telescope(func_name, opts)
    local telescope_status_ok, _ = pcall(require, "telescope")
    if not telescope_status_ok then
        return
    end
    local node = api.tree.get_node_under_cursor()
    local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false
    local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
    if (node.name == '..' and TreeExplorer ~= nil) then
        basedir = TreeExplorer.cwd
    end
    opts = opts or {}
    opts.cwd = basedir
    opts.search_dirs = { basedir }
    opts.attach_mappings = view_selection
    return require("telescope.builtin")[func_name](opts)
end

return M
