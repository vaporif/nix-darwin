vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.g.no_cecutil_maps = 1
vim.opt.swapfile = false
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15
vim.lsp.inlay_hint.enable()

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- delete trailing spaces
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  callback = function(ev)
    -- Skip for files larger than 1MB
    local max_size = 1 * 1024 * 1024
    local file_size = vim.fn.getfsize(vim.fn.expand '%')
    if file_size > max_size then
      return
    end
    local cursor_position = vim.fn.getpos '.'
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos('.', cursor_position)
  end,
})

vim.api.nvim_create_user_command('SearchAndSub', function()
  -- Use * to search for the word under cursor
  vim.cmd 'normal! *'

  -- Get the current search pattern
  local search_pattern = vim.fn.getreg '/'

  -- Start a substitution command with the current search pattern
  vim.api.nvim_feedkeys(':%s/' .. search_pattern .. '/', 'n', false)
end, {})
-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

require 'mappings'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth',
  require 'plugins.gitsigns',
  require 'plugins.flash',
  require 'plugins.undotree',
  require 'plugins.which-key',
  require 'plugins.telescope',
  require 'plugins.lazydev',
  require 'plugins.lazygit',
  require 'plugins.autopairs',
  require 'plugins.dashboard',
  require 'plugins.snacks',
  require 'plugins.lsp',
  require 'plugins.blink-cmp',
  require 'plugins.neotest',
  require 'plugins.rustacean',
  require 'plugins.crates',
  require 'plugins.conform',
  require 'plugins.lualine',
  -- make toggle
  require 'plugins.rainbow',
  'mg979/vim-visual-multi',
  require 'plugins.mini',
  { 'svermeulen/vim-subversive' },
  { 'powerman/vim-plugin-AnsiEsc' },
  { 'sindrets/diffview.nvim' },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  require 'plugins.treesitter',
  require 'plugins.treesitter-context',
  require 'plugins.indent_line',
  require 'plugins.neo-tree',
  require 'plugins.dap',
  require 'plugins.trouble',
  require 'plugins.cursorword',
  require 'plugins.theme',
  require 'plugins.marksnvim',
  require 'plugins.snipe',
  require 'plugins.harpoon',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
  lockfile = '/etc/nix-darwin/nvim/lazy-lock.json',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
