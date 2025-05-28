vim.api.nvim_create_user_command('SearchAndSub', function()
  -- Use * to search for the word under cursor
  vim.cmd 'normal! *'

  -- Get the current search pattern
  local search_pattern = vim.fn.getreg '/'

  -- Start a substitution command with the current search pattern
  vim.api.nvim_feedkeys(':%s/' .. search_pattern .. '/', 'n', false)
end, {})
