local augroup = function(name)
  return vim.api.nvim_create_augroup('nvim_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
  pattern = '*',
})
