return {
  'saghen/blink.pairs',
  version = '*', -- (recommended) only required with prebuilt binaries

  dependencies = 'saghen/blink.download',

  opts = {
    mappings = {
      enabled = true,
      pairs = {},
      disabled_filetypes = {},
    },
    highlights = {
      enabled = true,
      groups = {
        'BlinkPairsWarm1',
        'BlinkPairsWarm2',
      },
    },
    debug = false,
  },
}
