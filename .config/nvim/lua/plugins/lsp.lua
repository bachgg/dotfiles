return {
  { 'williamboman/mason.nvim' },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'bash-language-server',
        'cssls',
        'helm_ls',
        -- 'harper-ls',
        'jsonls',
        'lemminx',
        'lua_ls',
        'marksman',
        -- 'rust_analyzer',
        'shellcheck',
        'shfmt',
        'sqlls',
        'tailwindcss',
        'tflint',
        'tombi',
        'vimls',
        'yamlls',
      },
    }
  },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'L3MON4D3/LuaSnip' },
  { 'towolf/vim-helm',                  ft = 'helm' },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  }
}
