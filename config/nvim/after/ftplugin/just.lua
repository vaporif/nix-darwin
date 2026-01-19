vim.opt_local.makeprg = 'just'
vim.keymap.set('n', '<leader>cr', '<cmd>make<CR>', { buffer = 0, desc = '[r]un default' })
vim.keymap.set('n', '<leader>cl', '<cmd>!just --list<CR>', { buffer = 0, desc = '[l]ist recipes' })
