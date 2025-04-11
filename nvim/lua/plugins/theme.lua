return {
  'neanias/everforest-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local everforest = require 'everforest'
    everforest.setup {
      background = 'soft',
      transparent_background_level = 0,
      italics = true,
      disable_italic_comments = false,
      on_highlights = function(hl, _)
        hl['@string.special.symbol.ruby'] = { link = '@field' }
      end,
    }
    everforest.load()
  end,
}
