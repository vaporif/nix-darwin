if vim.g.have_nerd_font then
  local signs = { Error = '', Warn = '', Hint = '', Info = '' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    },
  },
})

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.config.lua_ls = {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
    },
  },
}
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'ts_ls'
vim.lsp.config.cairo_ls = {
  cmd = { 'scarb', 'cairo-language-server', '/C', '--node-ipc' },
  cmd_env = {
    SCARB_CONFIG = vim.fn.expand '$HOME/.scarb/config',
    SCARB_CACHE = vim.fn.expand '$HOME/.scarb/cache',
    CARGO_HOME = vim.fn.expand '$HOME/.cargo',
    TMPDIR = vim.fn.expand '$HOME/.tmp',
    PATH = vim.fn.expand '$HOME/.local/bin' .. ':' .. vim.env.PATH,
  },
  on_init = function()
    vim.fn.mkdir(vim.fn.expand '$HOME/.tmp', 'p')
    vim.fn.mkdir(vim.fn.expand '$HOME/.scarb/config', 'p')
    vim.fn.mkdir(vim.fn.expand '$HOME/.scarb/cache', 'p')
    vim.fn.mkdir(vim.fn.expand '$HOME/.cargo', 'p')
  end,
}
vim.lsp.enable 'cairo_ls'

local nixpkgs_expr = string.format('import (builtins.getFlake "%s").inputs.nixpkgs { }', vim.fn.getcwd())
vim.lsp.config.nixd = {
  settings = {
    nixd = {
      nixpkgs = {
        expr = nixpkgs_expr,
      },
      formatting = {
        command = { 'nixfmt' },
      },
    },
  },
}

vim.diagnostic.config {
  virtual_text = {
    prefix = '●',
    source = true,
  },
  float = {
    source = true,
  },
}
