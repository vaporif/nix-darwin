vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
  pattern = '*',
})

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  callback = function()
    local lines = vim.fn.line '$'

    if lines > 1500 then
      vim.opt_local.foldlevel = 0 -- Fold everything
    elseif lines > 1000 then
      vim.opt_local.foldlevel = 1 -- Show 1 level
    elseif lines > 500 then
      vim.opt_local.foldlevel = 2 -- Show 2 levels
    else
      vim.opt_local.foldlevel = 99 -- Show everything
    end
  end,
})
