local leap = require('leap')
leap.add_default_mappings()
leap.opts.case_sensitive = false
leap.opts.special_keys.prev_target = '<s-enter>'

vim.api.nvim_set_hl(0, 'LeapLabel', {
  -- For light themes, set to 'black' or similar.
  fg = 'red',
  bold = true,
  nocombine = true,
})
