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

  vim.keymap.set('n', 'ga', function()
    vim.lsp.buf.code_action()
  end, opts)

  vim.keymap.set('n', 'gn', function()
    vim.diagnostic.goto_next()
  end, opts)

  vim.keymap.set('n', 'gp', function()
    vim.diagnostic.goto_prev()
  end, opts)

  vim.keymap.set('n', '<C-y>', function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end)

  vim.keymap.set('n', 'gr', function()
    require('telescope.builtin').lsp_references({
      preview = {
        hide_on_startup = false
      },
      initial_mode = "normal",
      sorting_strategy = "ascending",
      results_title = "",
      dynamic_preview_title = true
    })
  end, opts)
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

require('lspconfig').eslint.setup({
  on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>es', function()
      vim.api.nvim_command('EslintFixAll')
    end)
  end,
})

require('rust-tools').setup({
  tools = {
    parameter_hints_prefix = "◀︎ ",
    inlay_hints = {
      other_hints_prefix = "▶︎ "
    }
  }
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'tsserver',
    'rust_analyzer',
    'lua_ls',
    'bashls',
    'cssls',
    'jsonls',
    'marksman',
    'sqlls',
    'tflint',
    'yamlls',
    'tailwindcss',
    'vimls',
    'pyright',
    'volar',
  },
  handlers = {
    lsp_zero.default_setup,
    tsserver = function()
      require('lspconfig').tsserver.setup({
        settings = {
          completions = {
            completeFunctionCalls = true
          }
        }
      })
    end,
  },
})

local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
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
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['html'].setup {
  capabilities = capabilities
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.gitlab-ci*.{yml,yaml}",
  callback = function()
    vim.bo.filetype = "yaml.gitlab"
  end,
})
