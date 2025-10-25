return {
  'folke/trouble.nvim',
  opts = {},
  cmd = 'Trouble',
  keys = {
    {
      '<leader>tt',
      '<cmd>Trouble todo toggle<cr>',
      desc = '[t]odo',
    },
    {
      '<leader>td',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = '[d]iagnostics',
    },
    {
      '<leader>tb',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = '[b]uffer',
    },
    {
      '<leader>ts',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = '[s]ymbols',
    },
    {
      '<leader>tl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = '[L]SP Definitions / references / ...',
    },
    {
      '<leader>to',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'l[o]ocation',
    },
    {
      '<leader>tq',
      '<cmd>Trouble qflist toggle<cr>',
      desc = '[q]uickfix',
    },
    {
      ']t',
      function()
        require('trouble').next { skip_groups = true, jump = true }
      end,
      desc = 'Next trouble item',
    },
    {
      '[t',
      function()
        require('trouble').prev { skip_groups = true, jump = true }
      end,
      desc = 'Previous trouble item',
    },
  },
}
