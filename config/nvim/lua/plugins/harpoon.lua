return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = function()
    local keys = {
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
    }
    for i = 1, 9 do
      keys[#keys + 1] = {
        '<leader>' .. i,
        function()
          require('harpoon'):list():select(i)
        end,
        desc = 'which_key_ignore',
      }
    end
    keys[#keys + 1] = {
      '<leader>0',
      function()
        require('harpoon'):list():select(10)
      end,
      desc = 'which_key_ignore',
    }
    return keys
  end,
  config = function()
    require('harpoon'):setup()
  end,
}
