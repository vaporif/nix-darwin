vim.opt_local.makeprg = 'forge build'
vim.keymap.set('n', '<leader>cb', '<cmd>make<CR>', { buffer = 0, desc = '[b]uild' })
vim.keymap.set('n', '<leader>ct', '<cmd>!forge test<CR>', { buffer = 0, desc = '[t]est' })
vim.keymap.set('n', '<leader>cf', '<cmd>!forge fmt<CR>', { buffer = 0, desc = '[f]ormat' })
