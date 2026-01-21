return {
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {},
  config = function(_, opts)
    require('go').setup(opts)
  end,
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()',
}
