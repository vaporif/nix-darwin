return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    files = {
      cmd = 'fd --type f --hidden --follow --exclude .git || find . -type f',
    },
    winopts = {
      border = 'none',
      preview = {
        border = 'noborder',
      },
    },
    grep = {
      actions = {
        ['ctrl-g'] = false,
      },
    },
  },
  keys = {
    { '<leader>fh', '<cmd>FzfLua help_tags<cr>', desc = '[h]elp' },
    { '<leader>fk', '<cmd>FzfLua keymaps<cr>', desc = '[k]eymaps' },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = '[f]iles' },
    { '<leader>fs', '<cmd>FzfLua builtin<cr>', desc = '[s]elect fzf-lua' },
    { '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = '[g]rep' },
    { '<leader>fd', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'workspace [d]iagnostics' },
    { '<leader>fD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = '[D]ocument diagnostics' },
    { '<leader>fr', '<cmd>FzfLua resume<cr>', desc = '[r]esume' },
    { '<leader>fm', '<cmd>FzfLua marks<cr>', desc = '[m]arks' },
    { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = '[b]uffers' },
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
      '<leader>fn',
      function()
        require('fzf-lua').files {
          prompt = 'Neovim Config> ',
          cwd = vim.fn.stdpath 'config',
        }
      end,
      desc = '[n]eovim files',
    },
    -- LSP keymaps
    { 'gd', '<cmd>FzfLua lsp_definitions<cr>', desc = 'goto [d]efinition' },
    { 'gR', '<cmd>FzfLua lsp_references<cr>', desc = 'goto [R]eferences (fzf-lua)' },
    { 'gI', '<cmd>FzfLua lsp_implementations<cr>', desc = 'goto [I]mplementation' },
    { '<leader>fi', '<cmd>FzfLua lsp_typedefs<cr>', desc = 'type def[i]nition' },
    { '<leader>fs', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'document [s]ymbols' },
    { '<leader>fw', '<cmd>FzfLua lsp_dynamic_workspace_symbols<cr>', desc = '[w]orkspace symbols' },
  },
}
