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
  {
    'm00qek/baleia.nvim',
    version = '*',
    keys = {
      { '<leader>cA', desc = '[A]nsi colorize' },
    },
    config = function()
      local baleia = require('baleia').setup {}
      vim.api.nvim_create_user_command('BaleiaColorize', function()
        baleia.once(vim.api.nvim_get_current_buf())
      end, {})
      vim.keymap.set('n', '<leader>cA', '<cmd>BaleiaColorize<cr>', { desc = '[A]nsi colorize' })
    end,
  },
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
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      suppressed_dirs = { '~/', '~/Repos', '~/Downloads', '/' },
      no_restore_cmds = { 'Neotree float reveal' },
    },
  },
  { 'chentoast/marks.nvim', event = 'VeryLazy', opts = {} },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = { 'MunifTanjim/nui.nvim' },
  },
}
