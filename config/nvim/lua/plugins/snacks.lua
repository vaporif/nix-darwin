return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    image = { enabled = false },
    input = {},
    picker = {
      ui_select = true,
    },
  },
}
