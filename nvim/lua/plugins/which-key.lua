return {
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup {
      icons = {
        -- somehow breaks which-key
        mappings = false,
        --   -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        --   -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
    }

    require('which-key').add {
      { '<leader>b', group = '[b]uffer' },
      { '<leader>s', group = '[s]plit' },
      { '<leader>g', group = '[G]it signs' },
      { '<leader>f', group = '[f]ind' },
      { '<leader>c', group = '[c]ode' },
      { '<leader>l', group = 'tog[l]le' },
      { '<leader>r', group = '[r]ename' },
      { '<leader>w', group = '[w]rite' },
      { '<leader>t', group = '[t]rouble' },
      { '<leader>h', group = 'git [h]unk', mode = { 'n', 'v' } },
    }
  end,
}
