return {
  { 'tpope/vim-sleuth' },
  { 'mg979/vim-visual-multi' },
  { 'f-person/auto-dark-mode.nvim', opts = {} },
  { 'svermeulen/vim-subversive' },
  { 'powerman/vim-plugin-AnsiEsc' },
  { 'sindrets/diffview.nvim' },
  { 'j-hui/fidget.nvim', opts = {} },

  -- UI and navigation
  require 'plugins.gitsigns',
  require 'plugins.flash',
  require 'plugins.undotree',
  require 'plugins.which-key',
  require 'plugins.telescope',
  require 'plugins.dashboard',
  require 'plugins.lualine',
  require 'plugins.neoscroll',
  require 'plugins.mini',
  require 'plugins.neo-tree',
  require 'plugins.marksnvim',
  require 'plugins.snipe',
  require 'plugins.harpoon',
  require 'plugins.multicursor',

  -- Code features
  'neovim/nvim-lspconfig',
  require 'plugins.blink-cmp',
  require 'plugins.neotest',
  require 'plugins.rustacean',
  require 'plugins.crates',
  require 'plugins.conform',
  require 'plugins.autopairs',
  -- TODO: maybe update after bugfixes
  -- require 'plugins.blink-pairs',
  require 'plugins.treesitter',
  require 'plugins.treesitter-context',
  require 'plugins.indent_line',
  require 'plugins.dap',
  require 'plugins.trouble',
  require 'plugins.cursorword',
  require 'plugins.markdown',
  require 'plugins.avante',
  require 'plugins.mcphub',

  -- Development
  require 'plugins.lazydev',
  require 'plugins.lazygit',

  -- Misc
  require 'plugins.snacks',
  require 'plugins.theme',

  -- Additional plugins with minimal config
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
