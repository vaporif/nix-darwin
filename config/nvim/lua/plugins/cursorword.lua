return {
  'xiyaowong/nvim-cursorword',
  event = 'VeryLazy',
  config = function()
    vim.api.nvim_set_hl(0, 'CursorWord', { underline = true, default = true })
    vim.g.cursorword_disable_filetypes = {}
    vim.g.cursorword_min_width = 3
  end,
}
