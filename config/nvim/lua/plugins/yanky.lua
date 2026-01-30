local function show_yanky_hint()
  vim.defer_fn(function()
    vim.api.nvim_echo({ { ' <C-p> prev | <C-n> next ', 'Comment' } }, false, {})
  end, 0)
  vim.defer_fn(function()
    vim.cmd 'echo ""'
  end, 2000)
end

local function put_with_hint(plug)
  return function()
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes(plug, true, true, true), 'n')
    show_yanky_hint()
  end
end

return {
  {
    'gbprod/yanky.nvim',
    event = 'VeryLazy',
    keys = {
      { 'p', put_with_hint '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put after' },
      { 'P', put_with_hint '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put before' },
      { 'gp', put_with_hint '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'GPut after' },
      { 'gP', put_with_hint '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'GPut before' },
      { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Yanky previous' },
      { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Yanky next' },
    },
    opts = {
      preserve_cursor_position = { enabled = true },
    },
  },
  {
    'gbprod/substitute.nvim',
    keys = {
      {
        's',
        function()
          require('substitute').operator()
        end,
        desc = 'Substitute',
      },
      {
        'ss',
        function()
          require('substitute').line()
        end,
        desc = 'Substitute line',
      },
      {
        'S',
        function()
          require('substitute').eol()
        end,
        desc = 'Substitute to EOL',
      },
      {
        's',
        function()
          require('substitute').visual()
        end,
        mode = 'x',
        desc = 'Substitute',
      },
    },
    opts = {
      on_substitute = function(event)
        require('yanky.integration').substitute()(event)
        show_yanky_hint()
      end,
      highlight_substituted_text = { enabled = true, timer = 300 },
    },
  },
}
