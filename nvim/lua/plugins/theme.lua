return {
  'neanias/everforest-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local everforest = require 'everforest'
    vim.g.everforest_background = 'soft'
    vim.opt.background = 'light'
    everforest.setup {
      background = 'soft',
      transparent_background_level = 0,
      italics = true,
      disable_italic_comments = false,
      on_highlights = function(hl, _)
        hl['@string.special.symbol.ruby'] = { link = '@field' }
      end,
      colours_override = function(palette)
        palette.red = '#b86466'
        palette.bg_red = '#3d1f1f'
        palette.orange = '#d4937a'
        palette.yellow = '#c9b26f'
        palette.purple = '#a991d1' -- Soft lavender instead of bright purple
        palette.bg_purple = '#252033' -- Dark lavender background
      end,
    }
    everforest.load()
  end,
}
