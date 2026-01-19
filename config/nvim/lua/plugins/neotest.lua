return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'fredrikaverpil/neotest-golang',
    'nvim-neotest/neotest-python',
    'marilari88/neotest-vitest',
  },
  cmd = 'Neotest',
  config = function()
    require('neotest').setup {
      adapters = {
        require 'rustaceanvim.neotest',
        require 'neotest-golang',
        require 'neotest-python' {
          dap = { justMyCode = false },
          pytest_discover_instances = true,
        },
        require 'neotest-vitest',
      },
    }
  end,
}
