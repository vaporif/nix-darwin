vim.keymap.set('n', '<leader>ci', function()
  vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
end, { buffer = 0, desc = 'organize [i]mports' })

vim.opt_local.makeprg = 'go build ./...'
vim.keymap.set('n', '<leader>cb', '<cmd>make<CR>', { buffer = 0, desc = '[b]uild' })
