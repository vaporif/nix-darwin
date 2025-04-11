return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>Gs', gitsigns.stage_hunk, { desc = '[s]tage hunk' })
        map('n', '<leader>Gr', gitsigns.reset_hunk, { desc = '[r]eset hunk' })
        map('n', '<leader>GS', gitsigns.stage_buffer, { desc = '[S]tage buffer' })
        map('n', '<leader>GR', gitsigns.reset_buffer, { desc = '[R]eset buffer' })
        map('n', '<leader>Gp', gitsigns.preview_hunk, { desc = '[p]review hunk' })
        map('n', '<leader>Gb', gitsigns.blame_line, { desc = '[b]lame line' })
        map('n', '<leader>Gd', gitsigns.diffthis, { desc = '[d]iff against index' })
        map('n', '<leader>GD', function()
          gitsigns.diffthis '@'
        end, { desc = '[D]iff against last commit' })
        -- Toggles
        map('n', '<leader>Gb', gitsigns.toggle_current_line_blame, { desc = '[b]lame line' })
        map('n', '<leader>GD', gitsigns.toggle_deleted, { desc = '[D]eleted' })
      end,
    },
  },
}
