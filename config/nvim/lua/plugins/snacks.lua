return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
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
  opts = {
    image = { enabled = false },
    input = {},
  },
}
