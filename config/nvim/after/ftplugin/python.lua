vim.keymap.set('n', '<leader>cr', '<cmd>!python %<CR>', { buffer = 0, desc = '[r]un file' })

vim.opt_local.makeprg = 'pytest'
vim.keymap.set('n', '<leader>ct', '<cmd>make<CR>', { buffer = 0, desc = '[t]est' })
vim.keymap.set('n', '<leader>cT', '<cmd>!pytest -v %<CR>', { buffer = 0, desc = '[T]est file verbose' })
