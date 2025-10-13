return {
  'saghen/blink.pairs',
  version = '*', -- (recommended) only required with prebuilt binaries

  dependencies = 'saghen/blink.download',

  --- @module 'blink.pairs'
  --- @type blink.pairs.Config
  opts = {
    mappings = {
      enabled = true,
      pairs = {},
      disabled_filetypes = {},
    },
    highlights = {
      enabled = true,
      groups = {
        'String',
        'Type',
      },
    },
    debug = false,
  },
}
