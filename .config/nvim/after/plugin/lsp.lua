local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local opts = {
    buffer = bufnr,
    silent = true
  }

  lsp_zero.default_keymaps(
    {
      buffer = bufnr,
      exclude = { 'K' }
    }
  )
  local map = function(mode, l, r)
    vim.keymap.set(mode, l, r, opts)
  end

  map('n', 'L', function()
    vim.lsp.buf.hover({
      border = "single",
      max_height = 20,
      max_width = 130,
    })
  end)
  map('n', 'gn', function() vim.diagnostic.jump({ count = 1, float = true }) end)
  map('n', 'gN', function() vim.diagnostic.jump({ count = -1, float = true }) end)
  map('n', '<C-y>', function() vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" }) end)
end)

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

-- Has to setup neodev before lspconfig
require("neodev").setup({})

local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'

if not configs.protols then
  configs.protols = {
    default_config = {
      cmd = { 'protols' },
      root_dir = lspconfig.util.root_pattern('.git'),
      filetypes = { 'proto' },
    },
  }
end

vim.lsp.config('protols', {})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT'
      },
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        }
      },
    }
  }
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.launch",
  callback = function()
    vim.bo.filetype = "xml"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.mdx",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

-- require('lspconfig').eslint.setup({
--   on_attach = function(client, bufnr)
--     vim.keymap.set('n', '<leader>es', function()
--       vim.api.nvim_command('EslintFixAll')
--     end)
--   end,
-- })

local util = require 'lspconfig.util'

require('mason').setup({})
require('mason-lspconfig').setup({})

local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' }
  },
  mapping = cmp.mapping.preset.insert({
    -- ['<Esc>'] = cmp.mapping.abort(),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = 'select' })
      end
    end),

    ['<C-j>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({ behavior = 'select' })
      end
    end),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    }),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('html', {
  capabilities = capabilities
})

vim.lsp.config('helm_ls', {
  settings = {
    ['helm-ls'] = {
      yamlls = {
        path = "yaml-language-server",
        redhat = {
          telemetry = {
            enabled = false
          }
        },
        yaml = {
          format = {
            enable = false,
            bracketSpacing = false
          }
        }
      }
    }
  }
})

vim.lsp.config('yamlls', {
  settings = {
    path = "yaml-language-server",
    redhat = {
      telemetry = {
        enabled = false
      }
    },
    yaml = {
      format = {
        enable = true,
        bracketSpacing = false
      }
    }
  }
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.gitlab-ci*.{yml,yaml}",
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
})

require('typescript-tools').setup({})
