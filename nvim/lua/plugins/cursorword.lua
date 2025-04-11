return {
  'xiyaowong/nvim-cursorword',
  event = 'VeryLazy',
  enabled = true,
  config = function()
    vim.cmd [[
    		hi default CursorWord cterm=underline gui=underline
    		let g:cursorword_disable_filetypes = []
    		let g:cursorword_min_width = 3
    		]]
  end,
}
