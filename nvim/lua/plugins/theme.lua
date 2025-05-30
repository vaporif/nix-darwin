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
      on_highlights = function(hl, p)
        hl.TSKeyword = { fg = '#c9706f', bg = 'NONE' }
        hl['@keyword'] = { fg = '#c9706f', bg = 'NONE' }
        hl.TSFunction = { fg = '#7fb4ca', bg = 'NONE' }
        hl['@function'] = { fg = '#7fb4ca', bg = 'NONE' }
        hl.TSMacro = { fg = '#a991d1', bg = 'NONE' }
        hl['@macro'] = { fg = '#a991d1', bg = 'NONE' }
        hl.DiagnosticError = { fg = '#c9706f', bg = 'NONE' }
      end,
      colours_override = function(palette)
        if not palette then
          return {}
        end

        return {
          red = '#c9706f',
          purple = '#a991d1',
          bg_red = '#2d1f25',
          bg_purple = '#252033',
        }
      end,
    }
    everforest.load()
  end,
}
