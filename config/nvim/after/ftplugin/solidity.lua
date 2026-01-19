vim.opt_local.makeprg = 'forge build'
vim.keymap.set('n', '<leader>cb', '<cmd>make<CR>', { buffer = 0, desc = '[b]uild' })
vim.keymap.set('n', '<leader>ct', '<cmd>!forge test<CR>', { buffer = 0, desc = '[t]est' })
vim.keymap.set('n', '<leader>cT', '<cmd>!forge test -vvvv<CR>', { buffer = 0, desc = '[T]est verbose' })
vim.keymap.set('n', '<leader>cs', '<cmd>!forge snapshot<CR>', { buffer = 0, desc = 'gas [s]napshot' })
vim.keymap.set('n', '<leader>cc', '<cmd>!forge coverage<CR>', { buffer = 0, desc = '[c]overage' })
