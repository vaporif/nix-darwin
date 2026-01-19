-- Neotest
vim.keymap.set('n', '<leader>tt', function()
  require('neotest').run.run()
end, { desc = 'run [t]est' })
vim.keymap.set('n', '<leader>tf', function()
  require('neotest').run.run(vim.fn.expand '%')
end, { desc = 'run [f]ile' })
vim.keymap.set('n', '<leader>ts', function()
  require('neotest').summary.toggle()
end, { desc = '[s]ummary' })
vim.keymap.set('n', '<leader>tp', function()
  require('neotest').output_panel.toggle()
end, { desc = 'output [p]anel' })
vim.keymap.set('n', '<leader>tr', function()
  require('neotest').run.run_last()
end, { desc = '[r]e-run last' })
vim.keymap.set('n', '<leader>tx', function()
  require('neotest').run.stop()
end, { desc = 'stop' })

-- Debug (dap)
vim.keymap.set('n', '<leader>dc', function()
  require('dap').continue()
end, { desc = 'start/[c]ontinue' })
vim.keymap.set('n', '<leader>di', function()
  require('dap').step_into()
end, { desc = 'step [i]nto' })
vim.keymap.set('n', '<leader>dr', function()
  require('dap').step_over()
end, { desc = 'step ove[r]' })
vim.keymap.set('n', '<leader>do', function()
  require('dap').step_out()
end, { desc = 'step [o]ut' })
vim.keymap.set('n', '<leader>db', function()
  require('dap').toggle_breakpoint()
end, { desc = '[b]reakpoint' })
vim.keymap.set('n', '<leader>dl', function()
  require('dapui').toggle()
end, { desc = '[l]ast session result' })

-- Flash (motion)
vim.keymap.set({ 'n', 'x', 'o' }, 'l', function()
  require('flash').jump()
end, { desc = 'Flash' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })
vim.keymap.set('c', '<c-s>', function()
  require('flash').toggle()
end, { desc = 'Toggle Flash Search' })

-- Harpoon
vim.keymap.set('n', '<leader>a', function()
  require('harpoon'):list():add()
end, { desc = 'harpoon [a]dd' })
vim.keymap.set('n', '<leader>p', function()
  local harpoon = require 'harpoon'
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'har[p]oon' })
for i = 0, 9 do
  vim.keymap.set('n', '<leader>' .. i, function()
    require('harpoon'):list():select(i)
  end, { desc = 'which_key_ignore' })
end

-- Outline
vim.keymap.set('n', '<leader>co', '<cmd>Outline<CR>', { desc = '[o]utline' })

-- Snacks (git)
vim.keymap.set('n', '<leader>g', function()
  require('snacks').lazygit()
end, { desc = 'Lazy[g]it' })
vim.keymap.set('n', '<leader>l', function()
  require('snacks').lazygit.log()
end, { desc = 'git [l]ogs' })

-- Trouble
vim.keymap.set('n', '<leader>bt', '<cmd>Trouble todo toggle<cr>', { desc = '[t]odo' })
vim.keymap.set('n', '<leader>bd', '<cmd>Trouble diagnostics toggle<cr>', { desc = '[d]iagnostics' })
vim.keymap.set('n', '<leader>bb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = '[b]uffer' })
vim.keymap.set('n', '<leader>bs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = '[s]ymbols' })
vim.keymap.set('n', '<leader>bl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = '[L]SP Definitions / references / ...' })
vim.keymap.set('n', '<leader>bo', '<cmd>Trouble loclist toggle<cr>', { desc = 'l[o]ocation' })
vim.keymap.set('n', '<leader>bq', '<cmd>Trouble qflist toggle<cr>', { desc = '[q]uickfix' })
vim.keymap.set('n', ']b', function()
  require('trouble').next { skip_groups = true, jump = true }
end, { desc = 'Next trouble item' })
vim.keymap.set('n', '[b', function()
  require('trouble').prev { skip_groups = true, jump = true }
end, { desc = 'Previous trouble item' })

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
vim.keymap.set('n', '<leader>cf', '<cmd>DiffviewOpen<CR>', { desc = 'di[f]f tool' })
vim.keymap.set('n', '<leader>ci', '<cmd>AnsiEsc<CR>', { desc = 'ans[i] escape' })
vim.keymap.set('n', '<leader>ck', vim.diagnostic.setloclist, { desc = 'quic[k]fix list' })

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
