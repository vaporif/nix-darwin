return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  opts = {
    window = {
      mappings = {
        ['g'] = function()
          vim.cmd 'Neotree float git_status'
        end,
        ['f'] = function()
          vim.cmd 'Neotree float filesystem'
        end,
        ['b'] = function()
          vim.cmd 'Neotree float buffers'
        end,
      },
    },
    filesystem = {
      filtered_items = {
        visible = true,
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      hijack_netrw_behavior = 'open_current',
      window = {
        popup = {
          border = 'none',
          title = '',
        },
        border = 'none',
        mappings = {
          ['e'] = 'none',
        },
      },
    },
  },
}
