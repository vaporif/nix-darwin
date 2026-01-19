return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  event = 'BufReadPost',
  opts = {
    provider_selector = function(_, _, _)
      return { 'treesitter', 'indent' }
    end,
  },
}
