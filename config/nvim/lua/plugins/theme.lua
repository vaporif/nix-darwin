-- Everforest Theme with Light Mode
-- colors are changed to natural looking ones
-- should be way easier on eyes
return {
  'neanias/everforest-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local everforest = require 'everforest'
    vim.opt.background = 'light'
    local function apply_theme()
      everforest.setup {
        background = 'soft',
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

        on_highlights = function(hl, _palette)
          hl['@keyword'] = { fg = '#7a4f3a', bg = 'NONE' } -- Warm terracotta
          hl['@function.builtin'] = { fg = '#7a6d5b', bg = 'NONE' }
          hl['@lsp.typemod.keyword.controlFlow.rust'] = { fg = '#846347', bg = 'NONE' }
          hl['@operator'] = { fg = '#5a4746', bg = 'NONE' }
          hl['@punctuation.special'] = { fg = '#7a6756', bg = 'NONE' } -- For :: -> =>
          hl.CursorLine = { bg = '#faf3e8' }

          hl['@macro'] = { fg = '#9b7d8a', bg = 'NONE' } -- Muted mauve
          -- Softer, natural error colors
          hl.DiagnosticError = { fg = '#c85552', bg = 'NONE' } -- Muted coral
          hl['Purple'] = { fg = '#8b6d7a' } -- Dusty purple
          hl['PurpleItalic'] = { fg = '#9b7d8a', italic = false }
          hl['Red'] = { fg = '#a84440' } -- Muted coral
          hl['Orange'] = { fg = '#c2591e', bg = 'NONE' }
          hl['DiagnosticUnderlineError'] = { undercurl = true, sp = '#c85552' }
          hl.ErrorFloat = { fg = '#9d6b47', bg = 'NONE' }
          hl.YankHighlight = { bg = '#e8e2cf' }
          -- Additional natural highlights for better readability
          hl['@type'] = { fg = '#3a5b4d', bg = 'NONE' } -- Sage green
          hl['@function'] = { fg = '#3b5b5f', bg = 'NONE' } -- Blue-grey stone
          hl['@string'] = { fg = '#5a6a4e', bg = 'NONE' }
          hl['@variable'] = { fg = '#4d5b56', bg = 'NONE' } -- Deep forest
          hl['@variable.builtin'] = { fg = '#8a8275', bg = 'NONE' }
          hl['@constant'] = { fg = '#907760', bg = 'NONE' } -- Earth brown
          hl['@number'] = { fg = '#a8814f', bg = 'NONE' } -- Warm amber
          hl['@boolean'] = { fg = '#907760', bg = 'NONE' } -- Warmer tan
          hl['@parameter'] = { fg = '#7a5a4a' }

          -- UI elements with natural colors
          hl['@punctuation'] = { fg = '#7d8d85', bg = 'NONE' } -- Stone grey
          hl['@punctuation.bracket'] = { fg = '#7d8d85', bg = 'NONE' }
          hl['@punctuation.delimiter'] = { fg = '#8d9d8d', bg = 'NONE' }

          -- Rust-specific
          hl['@type.rust'] = { fg = '#4a6b5d', bg = 'NONE' } -- Sage green
          hl['@function.rust'] = { fg = '#4b6b6f', bg = 'NONE' }
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
          hl['@keyword.rust'] = { fg = '#8b5a3c', bg = 'NONE' } -- Sandy brown
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

          -- Todo comments highlighting (folke/todo-comments.nvim)
          -- The plugin creates these highlight groups dynamically
          hl['@text.todo'] = { fg = '#708c7e', bold = true }
          hl['@text.note'] = { fg = '#6b8b8f', bold = true }
          hl['@text.warning'] = { fg = '#c9a05a', bold = true }
          hl['@text.danger'] = { fg = '#c85552', bold = true }
          hl['@text.todo.unchecked'] = { fg = '#708c7e', bold = true }
          hl['@text.todo.checked'] = { fg = '#89a05d', bold = true }

          -- Default todo-comments highlight groups
          hl.TodoBgTODO = { bg = '#708c7e', fg = '#f8f1de', bold = true }
          hl.TodoFgTODO = { fg = '#708c7e', bold = true }
          hl.TodoSignTODO = { fg = '#708c7e', bold = true }

          hl.TodoBgFIX = { bg = '#c85552', fg = '#f8f1de', bold = true }
          hl.TodoFgFIX = { fg = '#c85552', bold = true }
          hl.TodoSignFIX = { fg = '#c85552', bold = true }

          hl.TodoBgHACK = { bg = '#c9a05a', fg = '#f8f1de', bold = true }
          hl.TodoFgHACK = { fg = '#c9a05a', bold = true }
          hl.TodoSignHACK = { fg = '#c9a05a', bold = true }

          hl.TodoBgWARN = { bg = '#c9a05a', fg = '#f8f1de', bold = true }
          hl.TodoFgWARN = { fg = '#c9a05a', bold = true }
          hl.TodoSignWARN = { fg = '#c9a05a', bold = true }

          hl.TodoBgPERF = { bg = '#9b7d8a', fg = '#f8f1de', bold = true }
          hl.TodoFgPERF = { fg = '#9b7d8a', bold = true }
          hl.TodoSignPERF = { fg = '#9b7d8a', bold = true }

          hl.TodoBgNOTE = { bg = '#6b8b8f', fg = '#f8f1de', bold = true }
          hl.TodoFgNOTE = { fg = '#6b8b8f', bold = true }
          hl.TodoSignNOTE = { fg = '#6b8b8f', bold = true }

          hl.TodoBgTEST = { bg = '#9b7d8a', fg = '#f8f1de', bold = true }
          hl.TodoFgTEST = { fg = '#9b7d8a', bold = true }
          hl.TodoSignTEST = { fg = '#9b7d8a', bold = true }

          -- Blink-pairs custom highlight groups
          hl.BlinkPairsWarm1 = { fg = '#c08563' } -- base09: warm orange
          hl.BlinkPairsWarm2 = { fg = '#859289' } -- base0F: neutral brown
        end,

        colours_override = function(palette)
          palette.red = '#b85450' -- clay red
          palette.orange = '#c08563' -- Soft clay orange
          palette.yellow = '#c9a05a' -- Warm honey/wheat
          palette.green = '#89a05d' -- Olive leaf green
          palette.aqua = '#6b9b91' -- Sea glass teal
          palette.blue = '#6b8b8f' -- Storm cloud blue
          palette.purple = '#9b7d8a' -- Dusty lavender

          -- Background colors - very soft and natural
          palette.bg0 = '#e8dcc6' -- Main background color
          palette.bg_visual = '#d5c9b8' -- Slightly warmer selection
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
          palette.statusline1 = '#5c6a72' -- Dark grey
          palette.statusline2 = '#708c7e' -- Darker sage
          palette.statusline3 = '#7a8478' -- Even darker
        end,
      }

      everforest.load()
    end

    -- Apply theme on startup
    apply_theme()
  end,
}
