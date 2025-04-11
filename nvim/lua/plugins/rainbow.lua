return {
  'HiPhish/rainbow-delimiters.nvim',
  config = function()
    require('rainbow-delimiters.setup').setup {
      strategy = { [''] = 'rainbow-delimiters.strategy.local' },
    }
  end,
}
