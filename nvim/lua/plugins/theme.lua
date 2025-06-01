-- Everforest Theme with Light/Dark Mode Support
-- colors are changed to natural looking ones
-- should be way easier on eyes
return {
  'neanias/everforest-nvim',
  lazy = false,
  priority = 1000,

  config = function()
    local everforest = require 'everforest'

    -- Function to apply theme based on background
    local function apply_theme()
      local is_dark = vim.o.background == 'dark'

      everforest.setup {
        -- Base configuration (same for both)
        background = is_dark and 'medium' or 'soft',
        transparent_background_level = 0,
        italics = false,
        disable_italic_comments = false,
        sign_column_background = 'none',
        ui_contrast = 'low',
        dim_inactive_windows = false,
        diagnostic_virtual_text = 'grey',
        diagnostic_text_highlight = false,
        diagnostic_line_highlight = false,
        spell_foreground = false,
        show_eob = false,
        float_style = 'bright',
        inlay_hints_background = 'none',

        on_highlights = function(hl, palette)
          if is_dark then
            -- ===========================
            -- DARK THEME CUSTOMIZATIONS
            -- ===========================
            -- Natural, muted colors for dark theme - easy on eyes
            hl['@keyword'] = { fg = '#d89b7e', bg = 'NONE' } -- Warm terracotta (softer)
            hl['@function.builtin'] = { fg = '#a7c080', bg = 'NONE' }
            hl['@lsp.typemod.keyword.controlFlow.rust'] = { fg = '#d89b7e', bg = 'NONE' }
            hl['@lsp.type.macro.rust'] = { fg = '#b8a599', bg = 'NONE' }
            hl['@operator'] = { fg = '#e69875', bg = 'NONE' } -- Soft orange
            hl['@punctuation.special'] = { fg = '#e69875', bg = 'NONE' } -- For :: -> =>
            hl.CursorLine = { bg = '#374145' } -- Subtle highlight

            hl['@macro'] = { fg = '#b8a0a8', bg = 'NONE' }
            -- Natural error colors for dark
            hl.DiagnosticError = { fg = '#e67e80', bg = 'NONE' } -- Soft red
            hl['Purple'] = { fg = '#d699b6' }
            hl['PurpleItalic'] = { fg = '#b8a0a8', italic = false }
            hl['Red'] = { fg = '#e67e80' } -- Muted red
            hl['Orange'] = { fg = '#e69875', bg = 'NONE' } -- Soft orange
            hl['DiagnosticUnderlineError'] = { undercurl = true, sp = '#e67e80' }
            hl.ErrorFloat = { fg = '#d89b7e', bg = 'NONE' }
            hl.YankHighlight = { bg = '#4d5960' } -- Subtle highlight

            -- Natural highlights for readability in dark
            hl['@type'] = { fg = '#8a9a7e', bg = 'NONE' } -- Greyish sage
            hl['@function'] = { fg = '#7a9a95', bg = 'NONE' } -- Grey-teal
            hl['@string'] = { fg = '#8a9485', bg = 'NONE' }
            hl['@comment'] = { fg = '#859289', italic = false } -- Grey (readable)
            hl['@variable'] = { fg = '#d3c6aa', bg = 'NONE' } -- Light foreground
            hl['@constant'] = { fg = '#e69875', bg = 'NONE' } -- Warm orange
            hl['@number'] = { fg = '#b8a0a8', bg = 'NONE' }
            hl['@boolean'] = { fg = '#b8a0a8', bg = 'NONE' }
            hl['@parameter'] = { fg = '#83c092', bg = 'NONE' } -- Aqua

            -- UI elements with natural colors
            hl['@punctuation'] = { fg = '#859289', bg = 'NONE' } -- Grey
            hl['@punctuation.bracket'] = { fg = '#859289', bg = 'NONE' }
            hl['@punctuation.delimiter'] = { fg = '#859289', bg = 'NONE' }

            -- Rust-specific for dark
            hl['@type.rust'] = { fg = '#8a9a7e', bg = 'NONE' }
            hl['@variable.rust'] = { fg = '#d3c6aa', bg = 'NONE' }
            hl['@function.rust'] = { fg = '#7a9a95', bg = 'NONE' }
            hl['@attribute.rust'] = { fg = '#c7a0b4', bg = 'NONE' }
            hl['@operator.rust'] = { fg = '#d4a373', bg = 'NONE' }
            hl['@lsp.type.method.rust'] = { fg = '#7fa887', bg = 'NONE' }
            hl['@keyword.modifier.rust'] = { fg = '#d4a373', bg = 'NONE' }
            hl['@string.rust'] = { fg = '#8a9485', bg = 'NONE' }
            hl['@keyword.function.rust'] = { fg = '#c4a389', bg = 'NONE' }
            hl['@constant.builtin.rust'] = { fg = '#d4a373', bg = 'NONE' }
            hl['@lsp.mod.constant.rust'] = { fg = '#d4a373', bg = 'NONE' }
            hl['@keyword.storage.rust'] = { fg = '#d4a373', bg = 'NONE' }
            hl['@keyword.import.rust'] = { fg = '#c4a389', bg = 'NONE' }
            hl['@label.rust'] = { fg = '#c7a0b4', bg = 'NONE' }
            hl['@keyword.rust'] = { fg = '#c4a389', bg = 'NONE' }
            hl['@keyword.conditional.rust'] = { fg = '#c4a389', bg = 'NONE' }
            hl['@method.call.rust'] = { fg = '#7fa887', bg = 'NONE' }
            hl['@function.method.call.rust'] = { fg = '#95b37e', bg = 'NONE' }

            -- Git signs
            hl.GitSignsAdd = { fg = '#95b37e', bg = 'NONE' } -- Green
            hl.GitSignsChange = { fg = '#c9a86a', bg = 'NONE' } -- Yellow (muted)
            hl.GitSignsDelete = { fg = '#d78787', bg = 'NONE' } -- Red

            -- Warnings and hints
            hl.DiagnosticWarn = { fg = '#c9a86a', bg = 'NONE' } -- Yellow
            hl.DiagnosticHint = { fg = '#7aa89a', bg = 'NONE' } -- Teal
            hl.DiagnosticInfo = { fg = '#95b37e', bg = 'NONE' } -- Green

            -- Telescope dark theme (slightly lighter than bg)
            -- hl.TelescopeNormal = { bg = palette.bg1 }
            -- hl.TelescopeBorder = { fg = palette.bg5, bg = palette.bg1 }
            -- hl.TelescopePromptNormal = { bg = palette.bg1 }
            -- hl.TelescopePromptBorder = { fg = palette.bg5, bg = palette.bg1 }
            -- hl.TelescopeResultsNormal = { bg = palette.bg1 }
            -- hl.TelescopeResultsBorder = { fg = palette.bg5, bg = palette.bg1 }
            -- hl.TelescopePreviewNormal = { bg = palette.bg1 }
            -- hl.TelescopePreviewBorder = { fg = palette.bg5, bg = palette.bg1 }
            --
            -- hl.TelescopeSelection = { bg = palette.bg3 }
            -- hl.TelescopeSelectionCaret = { fg = palette.red, bg = palette.bg3 }

            -- Mini.indentscope
            hl.MiniIndentscopeSymbol = { fg = '#4f585e' } -- Subtle indent guides
          else
            -- ===========================
            -- LIGHT THEME CUSTOMIZATIONS (Your existing theme)
            -- ===========================
            hl['@keyword'] = { fg = '#9d6b47', bg = 'NONE' } -- Warm terracotta
            hl['@function.builtin'] = { fg = '#8b7d6b', bg = 'NONE' }
            hl['@lsp.typemod.keyword.controlFlow.rust'] = { fg = '#946b47', bg = 'NONE' }
            hl['@operator'] = { fg = '#8a7766', bg = 'NONE' }
            hl['@punctuation.special'] = { fg = '#8a7766', bg = 'NONE' } -- For :: -> =>
            hl.CursorLine = { bg = '#faf3e8' }

            hl['@macro'] = { fg = '#9b7d8a', bg = 'NONE' } -- Muted mauve
            -- Softer, natural error colors
            hl.DiagnosticError = { fg = '#c85552', bg = 'NONE' } -- Muted coral
            hl['Purple'] = { fg = '#9b7d8a' } -- Dusty purple
            hl['PurpleItalic'] = { fg = '#9b7d8a', italic = false }
            hl['Red'] = { fg = '#b85450' } -- Muted coral
            hl['Orange'] = { fg = '#d2691e', bg = 'NONE' }
            hl['DiagnosticUnderlineError'] = { undercurl = true, sp = '#c85552' }
            hl.ErrorFloat = { fg = '#9d6b47', bg = 'NONE' }
            hl.YankHighlight = { bg = '#e8e2cf' }
            -- Additional natural highlights for better readability
            hl['@type'] = { fg = '#708c7e', bg = 'NONE' } -- Sage green
            hl['@function'] = { fg = '#6b8b8f', bg = 'NONE' } -- Blue-grey stone
            hl['@string'] = { fg = '#8a9a7e', bg = 'NONE' }
            hl['@comment'] = { fg = '#a8a095' } -- Moss grey
            hl['@variable'] = { fg = '#5d6b66', bg = 'NONE' } -- Deep forest
            hl['@variable.builtin'] = { fg = '#a8a095', bg = 'NONE' }
            hl['@constant'] = { fg = '#a08770', bg = 'NONE' } -- Earth brown
            hl['@number'] = { fg = '#b8915f', bg = 'NONE' } -- Warm amber
            hl['@boolean'] = { fg = '#a08770', bg = 'NONE' } -- Warmer tan
            hl['@parameter'] = { fg = '#9a9a8a', bg = 'NONE' }

            -- UI elements with natural colors
            hl['@punctuation'] = { fg = '#7d8d85', bg = 'NONE' } -- Stone grey
            hl['@punctuation.bracket'] = { fg = '#7d8d85', bg = 'NONE' }
            hl['@punctuation.delimiter'] = { fg = '#8d9d8d', bg = 'NONE' }

            -- Rust-specific
            hl['@type.rust'] = { fg = '#708c7e', bg = 'NONE' } -- Sage green
            hl['@function.rust'] = { fg = '#6b8b8f', bg = 'NONE' }
            hl['@number.float'] = { fg = '#b8a0a8', bg = 'NONE' }
            hl['@attribute.rust'] = { fg = '#9b7d8a', bg = 'NONE' }
            hl['@operator.rust'] = { fg = '#8a7766', bg = 'NONE' }
            hl['@lsp.type.method.rust'] = { fg = '#7a8a7f', bg = 'NONE' }
            hl['@keyword.modifier.rust'] = { fg = '#b87333', bg = 'NONE' }
            hl['@keyword.function.rust'] = { fg = '#8b7355', bg = 'NONE' } -- Natural wood
            hl['@constant.builtin.rust'] = { fg = '#a08770', bg = 'NONE' }
            hl['@number.float.rust'] = { fg = '#9a8f85', bg = 'NONE' }
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
            -- hl.TelescopeNormal = { bg = palette.bg_dim } -- lighter background
            -- hl.TelescopeBorder = { fg = palette.bg5, bg = palette.bg_dim }
            -- hl.TelescopePromptNormal = { bg = palette.bg_dim }
            -- hl.TelescopePromptBorder = { fg = palette.bg5, bg = palette.bg_dim }
            -- hl.TelescopeResultsNormal = { bg = palette.bg_dim }
            -- hl.TelescopeResultsBorder = { fg = palette.bg5, bg = palette.bg_dim }
            -- hl.TelescopePreviewNormal = { bg = palette.bg_dim }
            -- hl.TelescopePreviewBorder = { fg = palette.bg5, bg = palette.bg_dim }
            --
            -- hl.TelescopeSelection = { bg = palette.bg0 }
            -- hl.TelescopeSelectionCaret = { fg = palette.red, bg = palette.bg0 }
          end
        end,

        colours_override = function(palette)
          if is_dark then
            -- ===========================
            -- DARK THEME PALETTE OVERRIDES
            -- ===========================
            -- Natural, muted colors for dark theme
            palette.orange = '#d4a373' -- Muted orange
            palette.yellow = '#c9a86a' -- Warm yellow (less bright)
            palette.green = '#8a9a7e'
            palette.blue = '#7a9a95'
            palette.purple = '#b8a0a8'
            palette.aqua = '#7a9a8a'
            palette.red = '#c88a8a'

            -- Background colors for dark
            palette.bg_visual = '#543a48' -- Subtle selection
            palette.bg_red = '#514045' -- Red tint
            palette.bg_green = '#425047' -- Green tint
            palette.bg_blue = '#3a515d' -- Blue tint
            palette.bg_yellow = '#4d4c43' -- Yellow tint
            palette.bg_dim = '#232a2e' -- For floats/inactive

            -- Greys for dark theme
            palette.grey0 = '#7a8478' -- Neutral grey
            palette.grey1 = '#859289' -- Light grey
            palette.grey2 = '#9da9a0' -- Lighter grey

            -- Statusline colors
            palette.statusline1 = '#a7c080'
            palette.statusline2 = '#d3c6aa'
            palette.statusline3 = '#e67e80'
          else
            -- ===========================
            -- LIGHT THEME PALETTE OVERRIDES (Your existing palette)
            -- ===========================
            -- Main colors - all natural and muted
            palette.red = '#b85450' -- clay red
            palette.orange = '#c08563' -- Soft clay orange
            palette.yellow = '#c9a05a' -- Warm honey/wheat
            palette.green = '#89a05d' -- Olive leaf green
            palette.aqua = '#6b9b91' -- Sea glass teal
            palette.blue = '#6b8b8f' -- Storm cloud blue
            palette.purple = '#9b7d8a' -- Dusty lavender

            -- Background colors - very soft and natural
            palette.bg_visual = '#ede7d4' -- Slightly warmer selection
            palette.bg_red = '#fce8e8' -- Very light coral
            palette.bg_green = '#f0f4e6' -- Very light sage
            palette.bg_blue = '#e8f0f3' -- Very light sky
            palette.bg_yellow = '#faf3e0' -- Very light cream
            palette.bg_dim = '#f8f1de' -- For dimmed/inactive windows

            -- Greys - like natural stone colors
            palette.grey0 = '#859289' -- River stone
            palette.grey1 = '#9da9a0' -- Light pebble
            palette.grey2 = '#b5c1b8' -- Pale stone

            -- Additional colors
            palette.statusline1 = '#93a99f'
            palette.statusline2 = '#859289'
            palette.statusline3 = '#708c7e'
          end
        end,
      }

      everforest.load()
    end

    -- Apply theme on startup
    apply_theme()

    -- Auto-apply theme when background changes
    vim.api.nvim_create_autocmd('OptionSet', {
      pattern = 'background',
      callback = function()
        apply_theme()
      end,
    })
  end,
}
