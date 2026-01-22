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
    {
      '"',
      function()
        Snacks.picker.registers()
      end,
      mode = { 'n', 'v' },
      desc = 'Registers',
    },
  },
  ---@type snacks.Config
  opts = {
    image = { enabled = false },
    input = {},
    picker = {
      ui_select = true,
    },
  },
}
