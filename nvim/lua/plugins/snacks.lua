return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    input = {},
    picker = {
      ui_select = true,
    },
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
