return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {
    files = {
      -- file size limit for preview (in MB)
      preview_opts = 'head -1000',
      -- you can set a custom file size limit here
      cmd = 'fd --type f --hidden --follow --exclude .git || find . -type f',
    },
    keymap = {
      { ';', ':', desc = 'CMD enter command mode' },
      { '<leader>fh', '<cmd>FzfLua help_tags<cr>', desc = '[h]elp' },
      { '<leader>fk', '<cmd>FzfLua keymaps<cr>', desc = '[k]eymaps' },
      { '<leader>ff', '<cmd>FzfLua files<cr>', desc = '[f]iles' },
      { '<leader>fs', '<cmd>FzfLua builtin<cr>', desc = '[s]elect fzf-lua' },
      { '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = '[g]rep' },
      { '<leader>fd', '<cmd>FzfLua diagnostics_workspace<cr>', desc = '[d]iagnostics' },
      { '<leader>fr', '<cmd>FzfLua resume<cr>', desc = '[r]esume' },
      { '<leader>fm', '<cmd>FzfLua marks<cr>', desc = '[m]arks' },
      { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = '[b]uffers' },
      {
        '<leader>.',
        function()
          require('fzf-lua').blines {
            previewer = false,
            winopts = {
              height = 0.40,
              width = 0.60,
              row = 0.40,
            },
          }
        end,
        desc = 'Fuzzily search in current buffer',
      },
      {
        '<leader>f/',
        function()
          require('fzf-lua').live_grep {
            prompt = 'Live Grep in Open Buffers> ',
            -- Search only in open buffers
            cmd = 'rg --column --line-number --no-heading --color=always --smart-case',
            search = '',
            fzf_opts = {
              ['--phony'] = '',
              ['--query'] = '',
              ['--bind'] = 'change:reload:rg --column --line-number --no-heading --color=always --smart-case {q} ' .. table.concat(
                vim.tbl_map(
                  function(b)
                    return vim.api.nvim_buf_get_name(b)
                  end,
                  vim.tbl_filter(function(b)
                    return vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) ~= ''
                  end, vim.api.nvim_list_bufs())
                ),
                ' '
              ),
            },
          }
        end,
        desc = '[/] in open files',
      },
      {
        '<leader>fn',
        function()
          require('fzf-lua').files {
            prompt = 'Neovim Config> ',
            cwd = vim.fn.stdpath 'config',
          }
        end,
        desc = '[n]eovim files',
      },
    },
  },
}
