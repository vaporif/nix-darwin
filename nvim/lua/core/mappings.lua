-- ========================================================================
-- LSP & Code Actions
-- ========================================================================
local code_mappings = {
  e = { '<cmd>RustLsp expandMacro<CR>', '[e]xpand macro' },
  c = { '<cmd>RustLsp flyCheck<CR>', '[c]heck' },
  h = { '<cmd>RustLsp hover actions<CR>', '[h]over' },
  x = { '<cmd>RustLsp explainError<CR>', 'e[x]plain error' },
  r = { '<cmd>RustLsp runnables<CR>', '[r]unnables' },
  t = { '<cmd>Neotree summary<CR>', '[t]ests' },
  a = { '<cmd>RustLsp codeAction<CR>', '[a]ction' },
  D = { '<cmd>RustLsp renderDiagnostic<CR>', '[D]iagnostic' },
  d = { '<cmd>RustLsp debuggables<CR>', '[d]ebug' },
  R = { '<cmd>RustAnalyzer restart<CR>', 'rust-lsp [R]estart' },
  l = { '<cmd>DiffviewOpen<CR>', 'diff too[l]' },
  i = { '<cmd>AnsiEsc<CR>', 'ans[i] escape' },
  k = { vim.diagnostic.setloclist, 'quic[k]fix list' },
}

for key, mapping in pairs(code_mappings) do
  vim.keymap.set('n', '<leader>c' .. key, mapping[1], { noremap = true, silent = true, desc = mapping[2] })
end

-- ========================================================================
-- File & Navigation
-- ========================================================================
vim.keymap.set('n', '<leader>/', 'gcc', { noremap = true, silent = true, desc = 'toggle comment', remap = true })
vim.keymap.set('v', '<leader>/', 'gc', { noremap = true, silent = true, desc = 'toggle comment', remap = true })
vim.keymap.set('n', '<leader>w', '<cmd>w!<CR>', { noremap = true, silent = true, desc = 'write' })
vim.keymap.set('n', '<leader>e', '<cmd>Neotree float toggle reveal_force_cwd<CR>', { noremap = true, silent = true, desc = 'n[e]otree' })
vim.keymap.set('n', '<leader>E', '<cmd>Neotree float git_status toggle reveal<CR>', { noremap = true, silent = true, desc = 'n[E]otree git' })
vim.keymap.set('n', '<leader>m', ':SearchAndSub<CR>', { noremap = true, silent = true, desc = '[m]ulti replace' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { noremap = true, silent = true, desc = 'clear search highlights' })

-- ========================================================================
-- Buffer Management
-- ========================================================================
local buffer_mappings = {
  n = { ':bnext<CR>', '[n]ext buffer' },
  p = { ':bprevious<CR>', '[p]revious buffer' },
  b = { '<C-^>', 'toggle [b]uffer' },
  d = { ':bdelete<CR>', '[d]elete current' },
  o = { ':%bd|e#|bd#<CR>', 'cl[o]se except current' },
}

for key, mapping in pairs(buffer_mappings) do
  vim.keymap.set('n', '<leader>b' .. key, mapping[1], { noremap = true, silent = true, desc = mapping[2] })
end

-- Window management
vim.keymap.set('n', '<leader><Tab>', '<C-w>w', { noremap = true, silent = true, desc = 'cycle through windows' })
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { noremap = true, silent = true, desc = 'split [v]ertically' })
vim.keymap.set('n', '<leader>sh', ':split<CR>', { noremap = true, silent = true, desc = 'split [h]orizontally' })

-- ========================================================================
-- Quickfix Navigation
-- ========================================================================
vim.keymap.set('n', '<M-e>', '<cmd>cnext<CR>', { noremap = true, silent = true, desc = 'next quickfix item' })
vim.keymap.set('n', '<M-u>', '<cmd>cprev<CR>', { noremap = true, silent = true, desc = 'previous quickfix item' })

-- ========================================================================
-- Subversive Plugin Mappings
-- ========================================================================
vim.keymap.set('n', 's', '<Plug>(SubversiveSubstitute)', { desc = 'substitute' })
vim.keymap.set('n', 'ss', '<Plug>(SubversiveSubstituteLine)', { desc = 'substitute line' })
vim.keymap.set('n', 'S', '<Plug>(SubversiveSubstituteToEndOfLine)', { desc = 'substitute to end' })
vim.keymap.set('x', 's', '<Plug>(SubversiveSubstitute)', { desc = 'substitute selection' })

-- ========================================================================
-- Insert Mode Escape
-- ========================================================================
vim.keymap.set('i', 'ii', '<Esc>', { noremap = true, silent = true, desc = 'escape from insert mode' })

-- ========================================================================
-- Remove Unwanted Mappings
-- ========================================================================
local keys_to_delete = { 'grn', 'grr', 'gri', 'gra' }
for _, key in ipairs(keys_to_delete) do
  vim.keymap.del('n', key)
end

-- ========================================================================
-- Disable HJKL Navigation (Colemak user)
-- ========================================================================
local modes = { 'n', 'v', 'o' }
local keys = { 'h', 'j', 'k', 'l' }

for _, mode in ipairs(modes) do
  for _, key in ipairs(keys) do
    vim.keymap.set(mode, key, '<Nop>', { noremap = true, silent = true, desc = 'disabled key (colemak)' })
  end
end

return {}
