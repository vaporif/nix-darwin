return {
  { 'neovim/nvim-lspconfig', event = 'BufReadPre' },
  { 'NMAC427/guess-indent.nvim', event = 'BufReadPre', opts = {} },
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      suppressed_dirs = { '~/', '~/Repos', '~/Downloads', '/' },
      no_restore_cmds = { 'Neotree float reveal' },
    },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
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
    'gbprod/yanky.nvim',
    event = 'VeryLazy',
    keys = {
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put after' },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put before' },
      { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'GPut after' },
      { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'GPut before' },
      { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Yanky previous' },
      { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Yanky next' },
    },
    opts = {
      preserve_cursor_position = { enabled = true },
    },
  },
  {
    'gbprod/substitute.nvim',
    keys = {
      {
        's',
        function()
          require('substitute').operator()
        end,
        desc = 'Substitute',
      },
      {
        'ss',
        function()
          require('substitute').line()
        end,
        desc = 'Substitute line',
      },
      {
        'S',
        function()
          require('substitute').eol()
        end,
        desc = 'Substitute to EOL',
      },
      {
        's',
        function()
          require('substitute').visual()
        end,
        mode = 'x',
        desc = 'Substitute',
      },
    },
    opts = {
      on_substitute = function(event)
        require('yanky.integration').substitute()(event)
      end,
      highlight_substituted_text = { enabled = true, timer = 300 },
    },
  },

  { 'chrisgrieser/nvim-early-retirement', event = 'VeryLazy', config = true },
  { 'sindrets/diffview.nvim', cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' } },

  { 'mrcjkb/rustaceanvim', version = '^7', lazy = false },
  { 'saecki/crates.nvim', event = 'BufRead Cargo.toml', opts = {} },
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
    'm00qek/baleia.nvim',
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
}
