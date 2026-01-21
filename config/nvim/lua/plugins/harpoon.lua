return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>a',
      function()
        require('harpoon'):list():add()
      end,
      desc = 'harpoon [a]dd',
    },
    {
      '<leader>p',
      function()
        local h = require 'harpoon'
        h.ui:toggle_quick_menu(h:list())
      end,
      desc = 'har[p]oon',
    },
    {
      '<leader>1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>5',
      function()
        require('harpoon'):list():select(5)
      end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>6',
      function()
        require('harpoon'):list():select(6)
      end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>7',
      function()
        require('harpoon'):list():select(7)
      end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>8',
      function()
        require('harpoon'):list():select(8)
      end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>9',
      function()
        require('harpoon'):list():select(9)
      end,
      desc = 'which_key_ignore',
    },
    {
      '<leader>0',
      function()
        require('harpoon'):list():select(0)
      end,
      desc = 'which_key_ignore',
    },
  },
  config = function()
    require('harpoon'):setup()
  end,
}
