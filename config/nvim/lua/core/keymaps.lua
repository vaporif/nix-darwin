-- Outline
vim.keymap.set('n', '<leader>co', '<cmd>Outline<CR>', { desc = '[o]utline' })

-- Snacks (git)
vim.keymap.set('n', '<leader>g', function()
  require('snacks').lazygit()
end, { desc = 'Lazy[g]it' })
vim.keymap.set('n', '<leader>l', function()
  require('snacks').lazygit.log()
end, { desc = 'git [l]ogs' })

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Prev error' })
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Next error' })

-- Code (generic)
vim.keymap.set('n', '<leader>cd', '<cmd>DiffviewOpen<CR>', { desc = '[d]iff tool' })
vim.keymap.set('n', '<leader>cA', '<cmd>AnsiEsc<CR>', { desc = '[A]nsi escape' })

vim.keymap.set('n', '<leader>/', 'gcc', { desc = 'toggle comment', remap = true })
vim.keymap.set('v', '<leader>/', 'gc', { desc = 'toggle comment', remap = true })
vim.keymap.set('n', '<leader>w', '<cmd>w!<CR>', { desc = '[w]rite' })
vim.keymap.set('n', '<leader>e', '<cmd>Neotree float toggle reveal_force_cwd<CR>', { desc = 'n[e]otree' })

vim.keymap.set('n', '<leader><Tab>', '<C-w>w', { desc = 'next pane' })

vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = '[v]ertically' })
vim.keymap.set('n', '<leader>sh', '<cmd>split<CR>', { desc = '[h]orizontally' })

-- Buffer navigation
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
-- yanky
vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')

-- Find & replace
vim.keymap.set({ 'n', 'v' }, '<leader>qg', function()
  local grug = require 'grug-far'
  local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
  grug.open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  }
end, { desc = '[g]lobal' })

vim.keymap.set({ 'n', 'v' }, '<leader>qw', function()
  local grug = require 'grug-far'
  local is_visual = vim.fn.mode():match '[vV]'

  if is_visual then
    -- Use visual selection
    grug.with_visual_selection()
  else
    -- Use whole buffer
    local buf_name = vim.api.nvim_buf_get_name(0)
    grug.open {
      transient = true,
      prefills = {
        paths = buf_name ~= '' and buf_name or nil,
      },
    }
  end
end, { desc = '[w]ithin buffer/selection' })

-- subversive
vim.keymap.set('n', 's', '<Plug>(SubversiveSubstitute)')
vim.keymap.set('n', 'ss', '<Plug>(SubversiveSubstituteLine)')
vim.keymap.set('n', 'S', '<Plug>(SubversiveSubstituteToEndOfLine)')
vim.keymap.set('x', 's', '<Plug>(SubversiveSubstitute)')
vim.keymap.set('i', 'ii', '<Esc>')

-- Unbind hjk since I use extend layer & colemak (l is used by Flash)
vim.keymap.set({ 'n', 'v', 'o' }, 'h', '<Nop>')
vim.keymap.set({ 'n', 'v', 'o' }, 'j', '<Nop>')
vim.keymap.set({ 'n', 'v', 'o' }, 'k', '<Nop>')

-- ; -> :
vim.keymap.set({ 'n', 'v', 'x' }, ';', ':')

-- delete default code operations
for _, key in ipairs { 'grn', 'grr', 'gri', 'gra' } do
  pcall(vim.keymap.del, 'n', key)
end
