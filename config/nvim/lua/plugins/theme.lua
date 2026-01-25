-- Everforest Theme with Light Mode
-- colors are changed to natural looking ones
-- should be way easier on eyes

-- Color palette for maintainability
local c = {
  -- Primary accent colors
  terracotta = '#7a4f3a',
  dusty_purple = '#9b7d8a',
  muted_coral = '#c85552',
  honey = '#c9a05a',
  sage = '#708c7e',
  storm_blue = '#6b8b8f',
  olive = '#89a05d',
  clay_red = '#b85450',
  warm_orange = '#c08563',

  -- Syntax colors
  deep_forest = '#4d5b56',
  blue_stone = '#3b5b5f',
  sage_green = '#3a5b4d',
  earth_brown = '#907760',
  warm_amber = '#a8814f',
  stone_grey = '#7d8d85',
  river_stone = '#859289',

  -- Rust-specific
  rust_keyword = '#8b5a3c',
  rust_conditional = '#9d6b47',
  rust_modifier = '#b87333',
  rust_wood = '#8b7355',
  rust_storage = '#a67c52',
  rust_import = '#a17c59',
  rust_method = '#7a8a7f',
  rust_type = '#4a6b5d',
  rust_function = '#4b6b6f',

  -- Background colors
  bg_main = '#e8dcc6',
  bg_cursor = '#faf3e8',
  bg_yank = '#e8e2cf',
  bg_dim = '#f8f1de',
  bg_selection = '#d5c9b8',

  -- UI colors
  dark_grey = '#5c6a72',
  light_pebble = '#9da9a0',
  pale_stone = '#b5c1b8',
}

return {
  'neanias/everforest-nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local everforest = require 'everforest'
    vim.opt.background = 'light'

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
        -- General syntax
        hl['@keyword'] = { fg = c.terracotta, bg = 'NONE' }
        hl['@function.builtin'] = { fg = '#7a6d5b', bg = 'NONE' }
        hl['@operator'] = { fg = '#5a4746', bg = 'NONE' }
        hl['@punctuation.special'] = { fg = '#7a6756', bg = 'NONE' }
        hl['@macro'] = { fg = c.dusty_purple, bg = 'NONE' }
        hl['@type'] = { fg = c.sage_green, bg = 'NONE' }
        hl['@function'] = { fg = c.blue_stone, bg = 'NONE' }
        hl['@string'] = { fg = '#5a6a4e', bg = 'NONE' }
        hl['@variable'] = { fg = c.deep_forest, bg = 'NONE' }
        hl['@variable.builtin'] = { fg = '#8a8275', bg = 'NONE' }
        hl['@constant'] = { fg = c.earth_brown, bg = 'NONE' }
        hl['@number'] = { fg = c.warm_amber, bg = 'NONE' }
        hl['@boolean'] = { fg = c.earth_brown, bg = 'NONE' }
        hl['@parameter'] = { fg = '#7a5a4a' }

        -- Punctuation
        hl['@punctuation'] = { fg = c.stone_grey, bg = 'NONE' }
        hl['@punctuation.bracket'] = { fg = c.stone_grey, bg = 'NONE' }
        hl['@punctuation.delimiter'] = { fg = '#8d9d8d', bg = 'NONE' }

        -- UI elements
        hl.CursorLine = { bg = c.bg_cursor }
        hl.YankyPut = { bg = c.terracotta, fg = c.bg_dim }
        hl.YankyYanked = { bg = c.terracotta, fg = c.bg_dim }
        hl['Purple'] = { fg = '#8b6d7a' }
        hl['PurpleItalic'] = { fg = c.dusty_purple, italic = false }
        hl['Red'] = { fg = '#a84440' }
        hl['Orange'] = { fg = '#c2591e', bg = 'NONE' }
        hl.ErrorFloat = { fg = c.rust_conditional, bg = 'NONE' }

        -- Diagnostics
        hl.DiagnosticError = { fg = c.muted_coral, bg = 'NONE' }
        hl.DiagnosticWarn = { fg = c.honey, bg = 'NONE' }
        hl.DiagnosticHint = { fg = c.storm_blue, bg = 'NONE' }
        hl.DiagnosticInfo = { fg = c.sage, bg = 'NONE' }
        hl['DiagnosticUnderlineError'] = { undercurl = true, sp = c.muted_coral }

        -- Git signs
        hl.GitSignsAdd = { fg = c.olive, bg = 'NONE' }
        hl.GitSignsChange = { fg = c.honey, bg = 'NONE' }
        hl.GitSignsDelete = { fg = c.clay_red, bg = 'NONE' }

        -- Rust-specific
        hl['@lsp.typemod.keyword.controlFlow.rust'] = { fg = '#846347', bg = 'NONE' }
        hl['@type.rust'] = { fg = c.rust_type, bg = 'NONE' }
        hl['@function.rust'] = { fg = c.rust_function, bg = 'NONE' }
        hl['@number.float'] = { fg = '#b8a0a8', bg = 'NONE' }
        hl['@attribute.rust'] = { fg = c.dusty_purple, bg = 'NONE' }
        hl['@operator.rust'] = { fg = '#8a7766', bg = 'NONE' }
        hl['@lsp.type.method.rust'] = { fg = c.rust_method, bg = 'NONE' }
        hl['@keyword.modifier.rust'] = { fg = c.rust_modifier, bg = 'NONE' }
        hl['@keyword.function.rust'] = { fg = c.rust_wood, bg = 'NONE' }
        hl['@constant.builtin.rust'] = { fg = '#a08770', bg = 'NONE' }
        hl['@number.float.rust'] = { fg = '#9a8f85', bg = 'NONE' }
        hl['@lsp.mod.constant.rust'] = { fg = c.rust_storage, bg = 'NONE' }
        hl['@keyword.storage.rust'] = { fg = c.rust_storage, bg = 'NONE' }
        hl['@keyword.import.rust'] = { fg = c.rust_import, bg = 'NONE' }
        hl['@label.rust'] = { fg = c.dusty_purple, bg = 'NONE' }
        hl['@keyword.rust'] = { fg = c.rust_keyword, bg = 'NONE' }
        hl['@keyword.conditional.rust'] = { fg = c.rust_conditional, bg = 'NONE' }
        hl['@method.call.rust'] = { fg = c.rust_method, bg = 'NONE' }
        hl['@function.method.call.rust'] = { fg = '#8b7d6b', bg = 'NONE' }

        -- Todo comments (folke/todo-comments.nvim)
        hl['@text.todo'] = { fg = c.sage, bold = true }
        hl['@text.note'] = { fg = c.storm_blue, bold = true }
        hl['@text.warning'] = { fg = c.honey, bold = true }
        hl['@text.danger'] = { fg = c.muted_coral, bold = true }
        hl['@text.todo.unchecked'] = { fg = c.sage, bold = true }
        hl['@text.todo.checked'] = { fg = c.olive, bold = true }

        hl.TodoBgTODO = { bg = c.sage, fg = c.bg_dim, bold = true }
        hl.TodoFgTODO = { fg = c.sage, bold = true }
        hl.TodoSignTODO = { fg = c.sage, bold = true }

        hl.TodoBgFIX = { bg = c.muted_coral, fg = c.bg_dim, bold = true }
        hl.TodoFgFIX = { fg = c.muted_coral, bold = true }
        hl.TodoSignFIX = { fg = c.muted_coral, bold = true }

        hl.TodoBgHACK = { bg = c.honey, fg = c.bg_dim, bold = true }
        hl.TodoFgHACK = { fg = c.honey, bold = true }
        hl.TodoSignHACK = { fg = c.honey, bold = true }

        hl.TodoBgWARN = { bg = c.honey, fg = c.bg_dim, bold = true }
        hl.TodoFgWARN = { fg = c.honey, bold = true }
        hl.TodoSignWARN = { fg = c.honey, bold = true }

        hl.TodoBgPERF = { bg = c.dusty_purple, fg = c.bg_dim, bold = true }
        hl.TodoFgPERF = { fg = c.dusty_purple, bold = true }
        hl.TodoSignPERF = { fg = c.dusty_purple, bold = true }

        hl.TodoBgNOTE = { bg = c.storm_blue, fg = c.bg_dim, bold = true }
        hl.TodoFgNOTE = { fg = c.storm_blue, bold = true }
        hl.TodoSignNOTE = { fg = c.storm_blue, bold = true }

        hl.TodoBgTEST = { bg = c.dusty_purple, fg = c.bg_dim, bold = true }
        hl.TodoFgTEST = { fg = c.dusty_purple, bold = true }
        hl.TodoSignTEST = { fg = c.dusty_purple, bold = true }

        -- Blink-pairs
        hl.BlinkPairsWarm1 = { fg = c.warm_orange }
        hl.BlinkPairsWarm2 = { fg = c.river_stone }
      end,

      colours_override = function(palette)
        palette.red = c.clay_red
        palette.orange = c.warm_orange
        palette.yellow = c.honey
        palette.green = c.olive
        palette.aqua = '#6b9b91'
        palette.blue = c.storm_blue
        palette.purple = c.dusty_purple

        palette.bg0 = c.bg_main
        palette.bg_visual = c.bg_selection
        palette.bg_red = '#fce8e8'
        palette.bg_green = '#f0f4e6'
        palette.bg_blue = '#e8f0f3'
        palette.bg_yellow = '#faf3e0'
        palette.bg_dim = c.bg_dim

        palette.grey0 = c.river_stone
        palette.grey1 = c.light_pebble
        palette.grey2 = c.pale_stone

        palette.statusline1 = c.dark_grey
        palette.statusline2 = c.sage
        palette.statusline3 = '#7a8478'
      end,
    }

    everforest.load()
  end,
}
