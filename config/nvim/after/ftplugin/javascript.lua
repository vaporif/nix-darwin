vim.keymap.set('n', '<leader>ci', function()
  vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' }, diagnostics = {} }, apply = true }
end, { buffer = 0, desc = 'organize [i]mports' })

vim.keymap.set('n', '<leader>cr', '<cmd>!node %<CR>', { buffer = 0, desc = '[r]un file' })
vim.keymap.set('n', '<leader>cb', '<cmd>!npm run build<CR>', { buffer = 0, desc = '[b]uild' })
vim.keymap.set('n', '<leader>ct', '<cmd>!npm test<CR>', { buffer = 0, desc = '[t]est' })
