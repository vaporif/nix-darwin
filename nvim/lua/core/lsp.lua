if vim.g.have_nerd_font then
  local signs = { Error = '', Warn = '', Hint = '', Info = '' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '●',
    source = true,
  },
  float = {
    source = true,
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange.dynamicRegistration = false
capabilities.textDocument.foldingRange.lineFoldingOnly = true

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

local corelib_path = os.getenv 'CAIRO_CORELIB_PATH'
vim.lsp.config.cairo_ls = {
  -- cmd = { vim.fn.expand '$HOME/.local/bin/scarb', 'cairo-language-server', '/C', '--node-ipc' },
  cmd = { 'scarb-cairo-language-server', '/C', '--node-ipc' },
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
  settings = {
    cairo1 = {
      corelibPath = corelib_path,
    },
  },
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
vim.lsp.enable 'nixd'

vim.lsp.config.basepyright = {
  settings = {
    pyright = {
      -- disable import sorting and use Ruff for this
      disableOrganizeImports = true,
      disableTaggedHints = false,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'workspace',
        typeCheckingMode = 'standard',
        useLibraryCodeForTypes = true,
        -- we can this setting below to redefine some diagnostics
        diagnosticSeverityOverrides = {
          deprecateTypingAliases = false,
        },
        -- inlay hint settings are provided by pylance?
        inlayHints = {
          callArgumentNames = 'partial',
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
        },
      },
    },
  },
  capabilities = {
    textDocument = {
      publishDiagnostics = {
        tagSupport = {
          valueSet = { 2 },
        },
      },
      hover = {
        contentFormat = { 'plaintext' },
        dynamicRegistration = true,
      },
    },
  },
}

vim.lsp.enable 'basedpyright'

vim.lsp.config.ruff = {
  settings = {
    organizeImports = false,
  },
}
vim.lsp.enable 'ruff'

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
    end

    map('gr', '<cmd>lua vim.lsp.buf.references()<CR>', 'goto [r]eferences (quickfix)')
    map('<leader>r', vim.lsp.buf.rename, '[r]ename')
    map('<leader>ca', vim.lsp.buf.code_action, '[a]ction')
    map('gD', vim.lsp.buf.declaration, 'goto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd('CursorHold', {
        buffer = event.buf,
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end
    vim.diagnostic.config {
      virtual_text = false,
      virtual_lines = false,
      signs = true,
      underline = true,
      float = {
        source = true,
      },
    }
    -- Disable ruff hover feature in favor of Pyright
    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end
  end,
})
