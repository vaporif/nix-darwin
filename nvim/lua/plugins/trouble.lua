return {
  'folke/trouble.nvim',
  opts = {},
  cmd = 'Trouble',
  keys = {
    {
      '<leader>td',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = '[d]iagnostics',
    },
    {
      '<leader>tB',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = '[b]uffer',
    },
    {
      '<leader>ts',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = '[s]ymbols',
    },
    {
      '<leader>tL',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = '[L]SP Definitions / references / ...',
    },
    {
      '<leader>tl',
      '<cmd>Trouble loclist toggle<cr>',
      desc = '[l]ocation',
    },
    {
      '<leader>tQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = '[Q]uickfix',
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
