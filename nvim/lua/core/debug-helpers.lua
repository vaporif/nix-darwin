-- Debug helpers for WhichKey and keymapping issues

local M = {}

-- Check current leader key and space mapping
function M.check_leader()
  print("Leader key: " .. vim.inspect(vim.g.mapleader))
  print("Local leader: " .. vim.inspect(vim.g.maplocalleader))

  -- Check if space is mapped
  local space_mappings = vim.api.nvim_get_keymap('n')
  local space_found = false
  for _, mapping in ipairs(space_mappings) do
    if mapping.lhs == ' ' then
      print("Space is mapped to: " .. vim.inspect(mapping))
      space_found = true
    end
  end
  if not space_found then
    print("WARNING: Space key has no normal mode mapping!")
  end
end

-- Reset leader key
function M.reset_leader()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
  print("Leader key reset to space")
  -- Force WhichKey to reload
  M.reload_whichkey()
end

-- Reload WhichKey
function M.reload_whichkey()
  -- Clear WhichKey state
  package.loaded['which-key'] = nil
  package.loaded['which-key.util'] = nil
  package.loaded['which-key.config'] = nil

  -- Reload the plugin
  local ok, wk = pcall(require, 'which-key')
  if ok then
    -- Re-register the groups
    wk.add({
      { '<leader>b', group = '[b]uffer' },
      { '<leader>s', group = '[s]plit' },
      { '<leader>f', group = '[f]ind' },
      { '<leader>q', group = '[q]uickreplace' },
      { '<leader>c', group = '[c]ode' },
      { '<leader>d', group = '[d]ebug' },
      { '<leader>t', group = '[t]rouble' },
      { '<leader>h', group = 'git [h]unk', mode = { 'n', 'v' } },
    })
    print("WhichKey reloaded successfully")
  else
    print("Failed to reload WhichKey")
  end
end

-- Check for conflicting keymaps
function M.check_conflicts()
  local mappings = vim.api.nvim_get_keymap('n')
  local leader_mappings = {}

  for _, mapping in ipairs(mappings) do
    if mapping.lhs:match('^<leader>') or mapping.lhs:match('^<Leader>') then
      local key = mapping.lhs:lower()
      if leader_mappings[key] then
        print("CONFLICT: " .. key .. " mapped by both:")
        print("  1. " .. (leader_mappings[key].desc or leader_mappings[key].rhs or "unknown"))
        print("  2. " .. (mapping.desc or mapping.rhs or "unknown"))
      else
        leader_mappings[key] = mapping
      end
    end
  end
  print("Conflict check complete. Found " .. vim.tbl_count(leader_mappings) .. " leader mappings")
end

-- Check LSP status and hover capability
function M.check_lsp_hover()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print("No LSP clients attached")
    return
  end

  for _, client in ipairs(clients) do
    print("LSP: " .. client.name)
    if client.server_capabilities.hoverProvider then
      print("  ✓ Hover supported")
    else
      print("  ✗ Hover NOT supported")
    end
  end

  -- Check if K is mapped
  local k_mapping = vim.fn.maparg('K', 'n')
  if k_mapping ~= '' then
    print("K is mapped to: " .. k_mapping)
  else
    print("K has default mapping (vim.lsp.buf.hover)")
  end
end

-- Full diagnostics
function M.full_diagnostic()
  print("=== WhichKey & Mapping Diagnostics ===")
  print("")
  print("--- Leader Key Status ---")
  M.check_leader()
  print("")
  print("--- LSP Hover Status ---")
  M.check_lsp_hover()
  print("")
  print("--- Checking for Conflicts ---")
  M.check_conflicts()
  print("")
  print("=== End Diagnostics ===")
end

-- Create user commands
vim.api.nvim_create_user_command('CheckLeader', M.check_leader, {})
vim.api.nvim_create_user_command('ResetLeader', M.reset_leader, {})
vim.api.nvim_create_user_command('ReloadWhichKey', M.reload_whichkey, {})
vim.api.nvim_create_user_command('CheckConflicts', M.check_conflicts, {})
vim.api.nvim_create_user_command('CheckLspHover', M.check_lsp_hover, {})
vim.api.nvim_create_user_command('WhichKeyDiagnostic', M.full_diagnostic, {})

-- Autocmd to warn if leader key gets changed
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
  callback = function()
    if vim.g.mapleader ~= ' ' then
      vim.notify("WARNING: Leader key changed from space to: " .. vim.inspect(vim.g.mapleader), vim.log.levels.WARN)
    end
  end,
})

return M