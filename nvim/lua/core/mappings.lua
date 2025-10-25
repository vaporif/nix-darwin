-- LSP
vim.keymap.set('n', '<leader>ce', '<cmd>RustLsp expandMacro<Cr>', { desc = '[e]xpand macro' })
vim.keymap.set('n', '<leader>cc', '<cmd>RustLsp flyCheck<Cr>', { desc = '[c]heck' })
vim.keymap.set('n', '<leader>ch', '<cmd>RustLsp hover actions<Cr>', { desc = '[h]over' })
vim.keymap.set('n', '<leader>cx', '<cmd>RustLsp explainError<Cr>', { desc = 'e[x]plain error' })
vim.keymap.set('n', '<leader>cr', '<cmd>RustLsp runnables<Cr>', { desc = '[r]unnables' })
vim.keymap.set('n', '<leader>ct', '<cmd>Neotree summary<Cr>', { desc = '[t]ests' })
vim.keymap.set('n', '<leader>ca', '<cmd>RustLsp codeAction<Cr>', { desc = '[a]ction' })
vim.keymap.set('n', '<leader>cD', '<cmd>RustLsp renderDiagnostic<Cr>', { desc = '[D]iagnostic' })
vim.keymap.set('n', '<leader>cd', '<cmd>RustLsp debuggables<Cr>', { desc = '[d]ebug' })
vim.keymap.set('n', '<leader>cR', '<cmd>RustAnalyzer restart<Cr>', { desc = 'rust-lsp [R]estart' })
vim.keymap.set('n', '<leader>cf', '<cmd>DiffviewOpen<Cr>', { desc = 'di[f]f tool' })
vim.keymap.set('n', '<leader>ci', '<cmd>AnsiEsc<Cr>', { desc = 'ans[i] escape' })
vim.keymap.set('n', '<leader>ck', vim.diagnostic.setloclist, { desc = 'quic[k]fix list' })

vim.keymap.set('n', '<leader>/', 'gcc', { desc = 'toggle comment', remap = true })
vim.keymap.set('v', '<leader>/', 'gc', { desc = 'toggle comment', remap = true })
vim.keymap.set('n', '<leader>w', '<cmd>w!<CR>', { desc = '[w]rite' })
vim.keymap.set('n', '<Leader>e', '<Cmd>Neotree float toggle reveal_force_cwd<CR>', { desc = 'n[e]otree' })
vim.keymap.set('n', '<Leader>E', '<Cmd>Neotree float git_status toggle reveal<CR>', { desc = 'n[E]otree git' })

vim.keymap.set('n', '<leader><Tab>', '<C-w>w', { noremap = true, desc = '[tab] pane' })

vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { noremap = true, desc = '[v]ertically' })
vim.keymap.set('n', '<leader>sh', ':split<CR>', { noremap = true, desc = '[h]orizontally' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
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
vim.keymap.set('n', 's', '<Plug>(SubversiveSubstitute)', {})
vim.keymap.set('n', 'ss', '<Plug>(SubversiveSubstituteLine)', {})
vim.keymap.set('n', 'S', '<Plug>(SubversiveSubstituteToEndOfLine)', {})
vim.keymap.set('x', 's', '<Plug>(SubversiveSubstitute)', {})
vim.api.nvim_set_keymap('i', 'ii', '<Esc>', { noremap = true })

-- Unbind hjkl since I use extend layer & colemak
--
-- Normal mode
vim.keymap.set('n', 'h', '<Nop>', { noremap = true })
vim.keymap.set('n', 'j', '<Nop>', { noremap = true })
vim.keymap.set('n', 'k', '<Nop>', { noremap = true })
vim.keymap.set('n', 'l', '<Nop>', { noremap = true })

-- Visual mode
vim.keymap.set('v', 'h', '<Nop>', { noremap = true })
vim.keymap.set('v', 'j', '<Nop>', { noremap = true })
vim.keymap.set('v', 'k', '<Nop>', { noremap = true })
vim.keymap.set('v', 'l', '<Nop>', { noremap = true })

-- Operator-pending mode
vim.keymap.set('o', 'h', '<Nop>', { noremap = true })
vim.keymap.set('o', 'j', '<Nop>', { noremap = true })
vim.keymap.set('o', 'k', '<Nop>', { noremap = true })
vim.keymap.set('o', 'l', '<Nop>', { noremap = true })

-- ; -> :
vim.keymap.set({ 'n', 'v', 'x' }, ';', ':')

-- delete default code operations
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'gra')
