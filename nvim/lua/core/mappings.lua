-- LSP
vim.keymap.set('n', '<leader>ce', '<cmd>RustLsp expandMacro<Cr>', { desc = '[e]xpand macro' })
vim.keymap.set('n', '<leader>cc', '<cmd>RustLsp flyCheck<Cr>', { desc = '[c]heck' })
vim.keymap.set('n', '<leader>ch', '<cmd>RustLsp hover actions<Cr>', { desc = '[h]over' })
vim.keymap.set('n', '<leader>cx', '<cmd>RustLsp explainError<Cr>', { desc = 'e[x]plain error' })
vim.keymap.set('n', '<leader>cr', '<cmd>RustLsp runnables<Cr>', { desc = '[r]unnables' })
vim.keymap.set('n', '<leader>ct', '<cmd>Neotree summary<Cr>', { desc = '[t]ests' })
vim.keymap.set('n', '<leader>ca', '<cmd>RustLsp codeAction<Cr>', { desc = '[a]ction' })
vim.keymap.set('n', '<leader>cD', '<cmd>RustLsp renderDiagnostic<Cr>', { desc = '[D]iagnostic' })
vim.keymap.set('n', '<leader>cd', '<cmd>RustLsp debuggables<Cr>', { desc = '[d]ebug' })
vim.keymap.set('n', '<leader>cR', '<cmd>RustAnalyzer restart<Cr>', { desc = 'rust-lsp [R]estart' })
vim.keymap.set('n', '<leader>cl', '<cmd>DiffviewOpen<Cr>', { desc = 'diff too[l]' })
vim.keymap.set('n', '<leader>ci', '<cmd>AnsiEsc<Cr>', { desc = 'ans[i] escape' })
vim.keymap.set('n', '<leader>ck', vim.diagnostic.setloclist, { desc = 'quic[k]fix list' })

vim.keymap.set('n', '<leader>/', 'gcc', { desc = 'toggle comment', remap = true })
vim.keymap.set('v', '<leader>/', 'gc', { desc = 'toggle comment', remap = true })
vim.keymap.set('n', '<leader>w', '<cmd>w!<CR>', { desc = 'write' })
vim.keymap.set('n', '<Leader>e', '<Cmd>Neotree float toggle reveal_force_cwd<CR>', { desc = 'n[e]otree' })
vim.keymap.set('n', '<Leader>E', '<Cmd>Neotree float git_status toggle reveal<CR>', { desc = 'n[E]otree git' })
-- Buffers
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { noremap = true, desc = '[n]ext buffer' })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { noremap = true, desc = '[p]revious buffer' })
vim.keymap.set('n', '<leader>bb', '<C-^>', { noremap = true, desc = 'toggle [b]uffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { noremap = true, desc = '[d]elete current' })
vim.keymap.set('n', '<leader>bo', ':%bd|e#|bd#<CR>', { noremap = true, desc = 'cl[o]se except current' })
vim.keymap.set('n', '<leader><Tab>', '<C-w>w', { noremap = true, desc = 'tab buffers' })

vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { noremap = true, desc = '[v]ertically' })
vim.keymap.set('n', '<leader>sh', ':split<CR>', { noremap = true, desc = '[h]orizontally' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>h', ':MCPHub<CR>', { noremap = true, desc = 'MCP[h]ub' })

-- Avante
vim.keymap.set('n', '<leader>q', ':AvanteToggle<CR>', { noremap = true, desc = 'ai [q]uestion toggle' })

-- Quickfix
vim.keymap.set('n', '<M-e>', '<cmd>cnext<Cr>')
vim.keymap.set('n', '<M-u>', '<cmd>cprev<Cr>')

-- subversive
vim.keymap.set('n', 's', '<Plug>(SubversiveSubstitute)', {})
vim.keymap.set('n', 'ss', '<Plug>(SubversiveSubstituteLine)', {})
vim.keymap.set('n', 'S', '<Plug>(SubversiveSubstituteToEndOfLine)', {})
vim.keymap.set('x', 's', '<Plug>(SubversiveSubstitute)', {})
vim.api.nvim_set_keymap('i', 'ii', '<Esc>', { noremap = true })

-- Unbind hjkl since I use extend layer & colemak
--
-- Normal mode
vim.keymap.set('n', 'h', '<Nop>', { noremap = true })
vim.keymap.set('n', 'j', '<Nop>', { noremap = true })
vim.keymap.set('n', 'k', '<Nop>', { noremap = true })
vim.keymap.set('n', 'l', '<Nop>', { noremap = true })

-- Visual mode
vim.keymap.set('v', 'h', '<Nop>', { noremap = true })
vim.keymap.set('v', 'j', '<Nop>', { noremap = true })
vim.keymap.set('v', 'k', '<Nop>', { noremap = true })
vim.keymap.set('v', 'l', '<Nop>', { noremap = true })

-- Operator-pending mode
vim.keymap.set('o', 'h', '<Nop>', { noremap = true })
vim.keymap.set('o', 'j', '<Nop>', { noremap = true })
vim.keymap.set('o', 'k', '<Nop>', { noremap = true })
vim.keymap.set('o', 'l', '<Nop>', { noremap = true })

-- delete default code operations
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'gra')

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-keybinds', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('gd', require('telescope.builtin').lsp_definitions, 'goto [d]efinition')
    map('gr', '<cmd>lua vim.lsp.buf.references()<CR>', 'goto [r]eferences (quickfix)')
    map('gR', require('telescope.builtin').lsp_references, 'goto [R]eferences (telescope)')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('gI', require('telescope.builtin').lsp_implementations, 'goto [I]mplementation')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'type [D]efinition')
    map('<leader>fD', require('telescope.builtin').lsp_document_symbols, '[D]ocument symbols')
    map('<leader>fw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace symbols')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('<leader>r', vim.lsp.buf.rename, '[r]ename')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, '[a]ction')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
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

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>lh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, 'inlay [h]ints')
    end
  end,
})
