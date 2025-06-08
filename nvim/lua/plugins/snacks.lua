return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    notifier = {},
  },
  keys = {
    {
      '<leader>g',
      function()
        require('snacks').lazygit()
      end,
      desc = 'Lazy[g]it',
    },
    {
      '<leader>l',
      function()
        require('snacks').lazygit.log()
      end,
      desc = 'git [l]ogs',
    },
  },
}
