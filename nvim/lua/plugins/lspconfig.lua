return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    { 'saghen/blink.cmp' },
  },
  config = function()
    -- TODO: fix dap and remove mason
    require('mason').setup()
  end,
}
