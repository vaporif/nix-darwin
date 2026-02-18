return {
  'mrcjkb/rustaceanvim',
  version = '^7',
  lazy = false,
  init = function()
    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            files = {
              -- Exclude .direnv to prevent rust-analyzer from hanging on "roots scanned"
              -- when direnv creates a local cache folder. The global rust-analyzer.toml
              -- excludeDirs setting is unreliable (https://github.com/rust-lang/rust-analyzer/issues/14734)
              excludeDirs = { '.direnv' },
            },
          },
        },
      },
    }
  end,
}
