-- Everforest Theme with Light/Dark Mode Support
-- Your customized light theme preserved + empty dark theme for customization

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
            -- Add your dark theme customizations here
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
            hl.TelescopeNormal = { bg = palette.bg_dim } -- lighter background
            hl.TelescopeBorder = { fg = palette.bg5, bg = palette.bg_dim }
            hl.TelescopePromptNormal = { bg = palette.bg_dim }
            hl.TelescopePromptBorder = { fg = palette.bg5, bg = palette.bg_dim }
            hl.TelescopeResultsNormal = { bg = palette.bg_dim }
            hl.TelescopeResultsBorder = { fg = palette.bg5, bg = palette.bg_dim }
            hl.TelescopePreviewNormal = { bg = palette.bg_dim }
            hl.TelescopePreviewBorder = { fg = palette.bg5, bg = palette.bg_dim }

            hl.TelescopeSelection = { bg = palette.bg0 }
            hl.TelescopeSelectionCaret = { fg = palette.red, bg = palette.bg0 }
          end
        end,

        colours_override = function(palette)
          if is_dark then
            -- ===========================
            -- DARK THEME PALETTE OVERRIDES
            -- ===========================
            -- Add your dark theme palette overrides here
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
            palette.bg_visual = '#e6dec7'
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
