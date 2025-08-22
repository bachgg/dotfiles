local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  local opts = {
    buffer = bufnr,
  }
  lsp_zero.default_keymaps(
    {
      buffer = bufnr,
      exclude = { 'K' }
    }
  )

  vim.keymap.set('n', 'L', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)

  -- vim.keymap.set('n', 'ga', function()
  --   vim.lsp.buf.code_action()
  -- end, opts)

  vim.keymap.set('n', 'gn', function()
    vim.diagnostic.goto_next()
  end, opts)

  vim.keymap.set('n', 'gp', function()
    vim.diagnostic.goto_prev()
  end, opts)

  vim.keymap.set('n', '<C-y>', function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end)
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

require('lspconfig').protols.setup {}

require('lspconfig').lua_ls.setup {
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
}

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
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
    -- ts_ls = function()
    --   local root_dir = util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')()
    --   print('heyyyyy', root_dir)
    --   require('lspconfig').ts_ls.setup({
    --     settings = {
    --       completions = {
    --         completeFunctionCalls = true
    --       }
    --     },
    --     root_dir = util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')
    --   })
    -- end,
    rust_analyzer = function() end
  },
})

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
require('lspconfig')['html'].setup {
  capabilities = capabilities
}

require('lspconfig').helm_ls.setup {
  settings = {
    ['helm-ls'] = {
      yamlls = {
        path = "yaml-language-server",
      }
    }
  }
}
require('lspconfig').yamlls.setup {}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.gitlab-ci*.{yml,yaml}",
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
})

require('typescript-tools').setup({})
