vim.keymap.set('n', '<leader>ci', function()
  vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' }, diagnostics = {} }, apply = true }
end, { buffer = 0, desc = 'organize [i]mports' })

vim.opt_local.makeprg = 'go build ./...'
vim.keymap.set('n', '<leader>cb', '<cmd>make<CR>', { buffer = 0, desc = '[b]uild' })
vim.keymap.set('n', '<leader>ct', '<cmd>!go test ./...<CR>', { buffer = 0, desc = '[t]est' })
vim.keymap.set('n', '<leader>cr', '<cmd>!go run .<CR>', { buffer = 0, desc = '[r]un' })
vim.keymap.set('n', '<leader>cm', '<cmd>!go mod tidy<CR>', { buffer = 0, desc = '[m]od tidy' })
