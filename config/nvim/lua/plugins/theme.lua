return {
  'vaporif/earthtone.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('earthtone').setup { background = 'light' }
    vim.cmd.colorscheme 'earthtone'
  end,
}
