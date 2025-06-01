return {
  { 'tpope/vim-sleuth' },
  { 'mg979/vim-visual-multi' },
  { 'f-person/auto-dark-mode.nvim', opts = {} },
  { 'svermeulen/vim-subversive' },
  { 'powerman/vim-plugin-AnsiEsc' },
  { 'sindrets/diffview.nvim' },
  { 'j-hui/fidget.nvim', opts = {} },
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

  -- UI and navigation
  require 'plugins.gitsigns',
  require 'plugins.flash',
  require 'plugins.undotree',
  require 'plugins.which-key',
  require 'plugins.fzf',
  -- require 'plugins.telescope',
  require 'plugins.dashboard',
  require 'plugins.lualine',
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
  require 'plugins.dap',
  require 'plugins.trouble',
  require 'plugins.cursorword',
  require 'plugins.markdown',
  -- NOTE: Confused about using it
  -- claude code is better as background worker
  -- and I don't like idea of not having AI llm
  -- at my fingertips so less brain rot
  -- require 'plugins.avante',
  -- require 'plugins.mcphub',

  -- Development
  require 'plugins.lazydev',
  require 'plugins.lazygit',

  -- Misc
  'LunarVim/bigfile.nvim',
  require 'plugins.snacks',
  require 'plugins.theme',

  -- Additional plugins with minimal config
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
