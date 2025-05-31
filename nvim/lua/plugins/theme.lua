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
      sign_column_background = 'none',
      ui_contrast = 'low',
      dim_inactive_windows = true,
      diagnostic_virtual_text = 'grey',
      diagnostic_text_highlight = false,
      diagnostic_line_highlight = false,
      spell_foreground = false,
      show_eob = false,
      float_style = 'bright',
      inlay_hints_background = 'dimmed',
      on_highlights = function(hl, palette)
        -- Natural earth tones for Rust keywords
        hl['@keyword'] = { fg = '#9d6b47', bg = 'NONE' } -- Warm terracotta
        hl['@function.builtin'] = { fg = '#8b7d6b', bg = 'NONE' }
        hl['@lsp.typemod.keyword.controlFlow.rust'] = { fg = '#946b47', bg = 'NONE' }
        hl['@operator'] = { fg = '#8a7766', bg = 'NONE' }
        hl['@punctuation.special'] = { fg = '#8a7766', bg = 'NONE' } -- For :: -> =>
        hl.CursorLine = { bg = '#faf3e8' }

        -- Natural purple like lavender
        hl['@macro'] = { fg = '#9b7d8a', bg = 'NONE' } -- Muted mauve
        -- Softer, natural error colors
        hl.DiagnosticError = { fg = '#c85552', bg = 'NONE' } -- Muted coral
        hl['Purple'] = { fg = '#9b7d8a' } -- Dusty purple
        hl['PurpleItalic'] = { fg = '#9b7d8a', italic = true }
        hl['Red'] = { fg = '#b85450' } -- Muted coral
        hl['Orange'] = { fg = '#d2691e', bg = 'NONE' }
        hl['DiagnosticUnderlineError'] = { undercurl = true, sp = '#c85552' }
        hl.ErrorFloat = { fg = '#9d6b47', bg = 'NONE' }
        hl.YankHighlight = { bg = '#e8e2cf' }
        -- Additional natural highlights for better readability
        hl['@type'] = { fg = '#708c7e', bg = 'NONE' } -- Sage green
        hl['@function'] = { fg = '#6b8b8f', bg = 'NONE' } -- Blue-grey stone
        hl['@string'] = { fg = '#89a05d', bg = 'NONE' } -- Olive leaf
        hl['@comment'] = { fg = '#a8a095', italic = true } -- Moss grey
        hl['@variable'] = { fg = '#5d6b66', bg = 'NONE' } -- Deep forest
        hl['@constant'] = { fg = '#a08770', bg = 'NONE' } -- Earth brown
        hl['@number'] = { fg = '#b8915f', bg = 'NONE' } -- Warm amber
        hl['@boolean'] = { fg = '#a08770', bg = 'NONE' } -- Warmer tan
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
        hl['@operator.rust'] = { fg = '#8a7766', bg = 'NONE' }
        hl['@lsp.type.method.rust'] = { fg = '#7a8a7f', bg = 'NONE' }
        hl['@keyword.modifier.rust'] = { fg = '#b87333', bg = 'NONE' }
        hl['@keyword.function.rust'] = { fg = '#8b7355', bg = 'NONE' } -- Natural wood
        hl['@constant.builtin.rust'] = { fg = '#a08770', bg = 'NONE' }
        hl['@lsp.mod.constant.rust'] = { fg = '#a67c52', bg = 'NONE' }
        hl['@keyword.storage.rust'] = { fg = '#a67c52', bg = 'NONE' }
        hl['@keyword.import.rust'] = { fg = '#a17c59', bg = 'NONE' } -- Sandy brown
        hl['@label.rust'] = { fg = '#9b7d8a', bg = 'NONE' }
        hl['@keyword.rust'] = { fg = '#a67c52', bg = 'NONE' } -- Sandy brown
        hl['@keyword.conditional.rust'] = { fg = '#9d6b47', bg = 'NONE' } -- Warm terracotta
        hl['@method.call.rust'] = { fg = '#7a8a7f', bg = 'NONE' } -- stone blue
        hl['@function.method.call.rust'] = { fg = '#8b7d6b', bg = 'NONE' }
        hl.GitSignsAdd = { fg = '#89a05d', bg = 'NONE' } -- Olive green
        hl.GitSignsChange = { fg = '#c9a05a', bg = 'NONE' } -- Honey yellow
        hl.GitSignsDelete = { fg = '#b85450', bg = 'NONE' } -- Clay red

        -- Warnings and hints
        hl.DiagnosticWarn = { fg = '#c9a05a', bg = 'NONE' } -- Muted gold
        hl.DiagnosticHint = { fg = '#6b8b8f', bg = 'NONE' } -- Blue-grey
        hl.DiagnosticInfo = { fg = '#708c7e', bg = 'NONE' } -- Sage

        hl.TelescopeNormal = { fg = palette.fg, bg = palette.bg0 } -- Same as editor
        hl.TelescopeBorder = { fg = palette.bg4, bg = palette.bg0 } -- Subtle border
        hl.TelescopePromptNormal = { fg = palette.fg, bg = palette.bg0 }
        hl.TelescopeResultsNormal = { fg = palette.fg, bg = palette.bg0 }
        hl.TelescopePreviewNormal = { fg = palette.fg, bg = palette.bg0 }
      end,
      colours_override = function(palette)
        -- Main colors - all natural and muted
        palette.red = '#b85450' -- clay red
        palette.orange = '#c08563' -- Soft clay orange
        palette.yellow = '#c9a05a' -- Warm honey/wheat
        palette.green = '#89a05d' -- Olive leaf green
        palette.aqua = '#6b9b91' -- Sea glass teal
        palette.blue = '#6b8b8f' -- Storm cloud blue
        palette.purple = '#9b7d8a' -- Dusty lavender

        -- Background colors - very soft and natural
        palette.bg_visual = '#ede7d4' -- Slightly warmer selection (currently you have it twice)
        palette.bg_red = '#fce8e8' -- Very light coral
        palette.bg_green = '#f0f4e6' -- Very light sage
        palette.bg_blue = '#e8f0f3' -- Very light sky
        palette.bg_yellow = '#faf3e0' -- Very light cream
        palette.bg_dim = '#f8f1de' -- For dimmed/inactive windows
        -- Foreground colors
        palette.fg = '#5c6a72' -- Charcoal (keeping original)

        -- Greys - like natural stone colors
        palette.grey0 = '#859289' -- River stone
        palette.grey1 = '#9da9a0' -- Light pebble
        palette.grey2 = '#b5c1b8' -- Pale stone

        -- Additional colors
        palette.statusline1 = '#93a99f'
        palette.statusline2 = '#859289'
        palette.statusline3 = '#708c7e'
      end,
    }
    everforest.load()
  end,
}
