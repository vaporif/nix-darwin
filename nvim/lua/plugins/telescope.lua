return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        preview = {
          filesize_limit = 3,
        },
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
      },
      -- pickers = {}
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', ';', ':', { desc = 'CMD enter command mode' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[h]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[k]eymaps' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]iles' })
    vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[s]elect telescope' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[g]rep' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[d]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[r]esume' })
    vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = '[m]arks' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[b]uffers' })
    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>.', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = 'Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>f/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[/] in open files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[n]eovim files' })
  end,
}
