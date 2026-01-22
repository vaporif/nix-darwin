return {
  { 'neovim/nvim-lspconfig', event = 'BufReadPre' },
  { 'tpope/vim-sleuth', event = 'BufReadPre' },
  {
    'svermeulen/vim-subversive',
    keys = {
      { 's', '<Plug>(SubversiveSubstitute)', desc = 'Substitute' },
      { 'ss', '<Plug>(SubversiveSubstituteLine)', desc = 'Substitute line' },
      { 'S', '<Plug>(SubversiveSubstituteToEndOfLine)', desc = 'Substitute to EOL' },
      { 's', '<Plug>(SubversiveSubstitute)', mode = 'x', desc = 'Substitute' },
    },
  },
  { 'powerman/vim-plugin-AnsiEsc', cmd = 'AnsiEsc' },
  { 'sindrets/diffview.nvim', cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' } },
  {
    'chrisgrieser/nvim-early-retirement',
    config = true,
    event = 'VeryLazy',
  },
  {
    'gbprod/yanky.nvim',
    keys = {
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put after' },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put before' },
      { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'GPut after' },
      { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'GPut before' },
      { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Yanky previous' },
      { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Yanky next' },
    },
    opts = {
      preserve_cursor_position = {},
    },
  },
  -- UI and navigation
  require 'plugins.gitsigns',
  require 'plugins.flash',
  require 'plugins.which-key',
  require 'plugins.fzf',
  require 'plugins.lualine',
  require 'plugins.mini',
  require 'plugins.neo-tree',
  require 'plugins.marksnvim',
  require 'plugins.harpoon',

  -- Code features
  require 'plugins.blink-cmp',
  require 'plugins.neotest',
  require 'plugins.rust',
  require 'plugins.go-nvim',
  require 'plugins.conform',
  require 'plugins.blink-pairs',
  require 'plugins.nvim-ufo',
  require 'plugins.treesitter',
  require 'plugins.dap',
  require 'plugins.trouble',
  require 'plugins.cursorword',
  require 'plugins.markdown',
  require 'plugins.grug-far',
  {
    'tidalcycles/vim-tidal',
    ft = 'tidal',
    config = function()
      vim.g.tidal_target = 'terminal'
      vim.g.tidal_ghci = 'ghci'
      vim.g.tidal_boot = vim.fn.expand '~/.config/tidal/Tidal.ghci'
      vim.g.tidal_sc_enable = false
    end,
  },

  require 'plugins.lazydev',

  -- Misc
  require 'plugins.noice',
  'LunarVim/bigfile.nvim',
  require 'plugins.snacks',
  require 'plugins.theme',
  require 'plugins.todo',

  require 'plugins.outline',
  {
    'rmagatti/auto-session',
    lazy = false,
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Repos', '~/Downloads', '/' },
      no_restore_cmds = { 'Neotree float reveal' },
    },
  },
}
