vim.keymap.set('n', '<leader>cr', '<cmd>source %<CR>', { buffer = 0, desc = '[r]un/source file' })

vim.opt_local.makeprg = 'selene --display-style=quiet'
vim.keymap.set('n', '<leader>cl', '<cmd>make %<CR>', { buffer = 0, desc = '[l]int' })
