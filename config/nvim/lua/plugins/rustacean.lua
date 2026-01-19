return {
  'mrcjkb/rustaceanvim',
  version = '^7',
  lazy = false,
  config = function()
    require('neotest').setup {
      adapters = {
        require 'rustaceanvim.neotest',
      },
    }
  end,
}
