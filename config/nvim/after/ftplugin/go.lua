vim.keymap.set('n', '<leader>ci', function()
  vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
end, { buffer = 0, desc = 'organize [i]mports' })

vim.keymap.set('n', '<leader>ce', function()
  vim.lsp.buf.code_action { context = { only = { 'refactor.rewrite.fillStruct' } }, apply = true }
end, { buffer = 0, desc = 'fill struct' })

vim.keymap.set('n', '<leader>ct', function()
  vim.lsp.buf.code_action { context = { only = { 'gopls.tidy' } }, apply = true }
end, { buffer = 0, desc = 'go mod [t]idy' })

vim.opt_local.makeprg = 'go build ./...'
vim.keymap.set('n', '<leader>cb', '<cmd>make<CR>', { buffer = 0, desc = '[b]uild' })
vim.keymap.set('n', '<leader>cr', '<cmd>!go run .<CR>', { buffer = 0, desc = '[r]un' })
