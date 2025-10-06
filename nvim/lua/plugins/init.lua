return {
  { 'tpope/vim-sleuth' },
  { 'svermeulen/vim-subversive' },
  { 'powerman/vim-plugin-AnsiEsc' },
  { 'sindrets/diffview.nvim' },
  {
    'chrisgrieser/nvim-early-retirement',
    config = true,
    event = 'VeryLazy',
  },
  {
    'gbprod/yanky.nvim',
    opts = {
      preserve_cursor_position = {
        enabled = true,
      },
    },
  },
  'gennaro-tedesco/nvim-peekup',

  -- UI and navigation
  require 'plugins.gitsigns',
  require 'plugins.flash',
  require 'plugins.undotree',
  require 'plugins.which-key',
  require 'plugins.fzf',
  require 'plugins.dashboard',
  require 'plugins.lualine',
  require 'plugins.mini',
  require 'plugins.neo-tree',
  require 'plugins.marksnvim',
  require 'plugins.harpoon',

  -- Code features
  'neovim/nvim-lspconfig',
  require 'plugins.blink-cmp',
  require 'plugins.neotest',
  require 'plugins.rustacean',
  require 'plugins.crates',
  require 'plugins.conform',
  require 'plugins.blink-pairs',

  -- require 'plugins.autopairs',
  require 'plugins.treesitter',
  require 'plugins.treesitter-context',
  require 'plugins.dap',
  require 'plugins.trouble',
  require 'plugins.cursorword',
  require 'plugins.markdown',
  require 'plugins.grug-far',
  {
    'tidalcycles/vim-tidal',
    config = function()
      -- Use Neovim's built-in terminal for Tidal REPL
      vim.g.tidal_target = 'terminal'

      -- Set the path to ghci
      vim.g.tidal_ghci = 'ghci'

      -- Set the boot file path to our Nix-managed Tidal.ghci
      vim.g.tidal_boot = vim.fn.expand '~/.config/tidal/Tidal.ghci'

      -- Disable SuperCollider terminal (we'll start it separately)
      vim.g.tidal_sc_enable = false
    end,
  },

  -- Development
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
      -- log_level = 'debug',
    },
  },
}
