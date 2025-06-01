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

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  group = augroup 'trim_whitespace',
  callback = function()
    -- Skip for files larger than 1MB
    local max_size = 1 * 1024 * 1024
    local file_size = vim.fn.getfsize(vim.fn.expand '%')
    if file_size > max_size then
      return
    end
    local cursor_position = vim.fn.getpos '.'
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos('.', cursor_position)
  end,
})
