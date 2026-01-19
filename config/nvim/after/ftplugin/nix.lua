vim.opt_local.makeprg = 'nix flake check'
vim.keymap.set('n', '<leader>cc', '<cmd>make<CR>', { buffer = 0, desc = '[c]heck flake' })
vim.keymap.set('n', '<leader>cb', '<cmd>!nix build<CR>', { buffer = 0, desc = '[b]uild' })
vim.keymap.set('n', '<leader>cu', '<cmd>!nix flake update<CR>', { buffer = 0, desc = '[u]pdate flake' })
