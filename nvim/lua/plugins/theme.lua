-- Customization to have colors you can see irl + muted so it's easy on eyes
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
      italics = false,
      disable_italic_comments = false,
      on_highlights = function(hl, _)
        -- Natural earth tones for Rust keywords
        hl['@keyword'] = { fg = '#9d6b47', bg = 'NONE' } -- Warm terracotta
        hl['@keyword.function.rust'] = { fg = '#8b7355', bg = 'NONE' } -- Natural wood
        hl['@keyword.import.rust'] = { fg = '#a17c59', bg = 'NONE' } -- Sandy brown
        hl['@keyword.conditional.rust'] = { fg = '#9d6b47', bg = 'NONE' } -- Warm terracotta

        -- Natural purple like lavender
        hl['@macro'] = { fg = '#9b7d8a', bg = 'NONE' } -- Muted mauve

        -- Softer, natural error colors
        hl.DiagnosticError = { fg = '#c85552', bg = 'NONE' } -- Muted coral
        hl['Purple'] = { fg = '#9b7d8a' } -- Dusty purple
        hl['PurpleItalic'] = { fg = '#9b7d8a', italic = true }
        hl['Red'] = { fg = '#c85552' } -- Muted coral
        hl['DiagnosticUnderlineError'] = { undercurl = true, sp = '#c85552' }
        hl.ErrorFloat = { fg = '#9d6b47', bg = 'NONE' }

        -- Additional natural highlights for better readability
        hl['@type'] = { fg = '#708c7e', bg = 'NONE' } -- Sage green
        hl['@function'] = { fg = '#6b8b8f', bg = 'NONE' } -- Blue-grey stone
        hl['@string'] = { fg = '#89a05d', bg = 'NONE' } -- Olive leaf
        hl['@comment'] = { fg = '#8d9d8d', italic = true } -- Moss grey
        hl['@variable'] = { fg = '#5d6b66', bg = 'NONE' } -- Deep forest
        hl['@constant'] = { fg = '#8f7e6b', bg = 'NONE' } -- Earth brown
        hl['@number'] = { fg = '#b8915f', bg = 'NONE' } -- Warm amber
        hl['@boolean'] = { fg = '#9b7d8a', bg = 'NONE' } -- Dusty purple
        hl['@parameter'] = { fg = '#6b8b8f', bg = 'NONE' } -- Blue-grey

        -- UI elements with natural colors
        hl['@punctuation'] = { fg = '#7d8d85', bg = 'NONE' } -- Stone grey
        hl['@punctuation.bracket'] = { fg = '#7d8d85', bg = 'NONE' }
        hl['@punctuation.delimiter'] = { fg = '#8d9d8d', bg = 'NONE' }

        -- Rust-specific
        hl['@type.rust'] = { fg = '#708c7e', bg = 'NONE' } -- Sage green
        hl['@variable.rust'] = { fg = '#5d6b66', bg = 'NONE' }
        hl['@function.rust'] = { fg = '#6b8b8f', bg = 'NONE' }
        hl['@attribute.rust'] = { fg = '#9b7d8a', bg = 'NONE' }

        -- Warnings and hints
        hl.DiagnosticWarn = { fg = '#c9a05a', bg = 'NONE' } -- Muted gold
        hl.DiagnosticHint = { fg = '#6b8b8f', bg = 'NONE' } -- Blue-grey
        hl.DiagnosticInfo = { fg = '#708c7e', bg = 'NONE' } -- Sage
      end,
      colours_override = function(palette)
        if not palette then
          return palette
        end
        return {
          -- Main colors - all natural and muted
          red = '#c85552', -- Muted coral (instead of bright red)
          orange = '#c08563', -- Soft clay orange
          yellow = '#c9a05a', -- Warm honey/wheat
          green = '#89a05d', -- Olive leaf green
          aqua = '#6b9b91', -- Sea glass teal
          blue = '#6b8b8f', -- Storm cloud blue
          purple = '#9b7d8a', -- Dusty lavender

          -- Background colors - very soft and natural
          bg0 = '#fdf6e3', -- Cream (keeping original)
          bg1 = '#f4eedb', -- Light parchment
          bg2 = '#eee8d5', -- Soft sand
          bg3 = '#e6e0cd', -- Pale wheat
          bg4 = '#dfd9c6', -- Light stone
          bg5 = '#d5cdb7', -- Warm grey

          bg_visual = '#e8e2cf', -- Selection background
          bg_red = '#fce8e8', -- Very light coral
          bg_green = '#f0f4e6', -- Very light sage
          bg_blue = '#e8f0f3', -- Very light sky
          bg_yellow = '#faf3e0', -- Very light cream
          bg_purple = '#f3e8f0', -- Very light lavender

          -- Foreground colors
          fg = '#5c6a72', -- Charcoal (keeping original)

          -- Greys - like natural stone colors
          grey0 = '#859289', -- River stone
          grey1 = '#9da9a0', -- Light pebble
          grey2 = '#b5c1b8', -- Pale stone

          -- Additional colors
          statusline1 = '#93a99f',
          statusline2 = '#859289',
          statusline3 = '#708c7e',
        }
      end,
    }
    everforest.load()
  end,
}
