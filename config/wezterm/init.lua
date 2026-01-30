local wezterm = require 'wezterm'
local act = wezterm.action

-- Event handlers (side effects, not config values)
local mux = wezterm.mux
wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local config = {
  front_end = 'WebGpu',
  max_fps = 120,
  animation_fps = 120,

  -- Window configuration
  window_padding = {
    left = 15,
    right = 15,
    top = 10,
    bottom = 5,
  },
  window_decorations = 'RESIZE',
  native_macos_fullscreen_mode = true,

  -- Tab bar configuration
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = true,
  tab_max_width = 32,
  cursor_blink_rate = 0,

  -- Scrollback
  scrollback_lines = 50000,

  -- Disable dead keys
  use_dead_keys = false,

  leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 },

  keys = {
    -- Pane management
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },

    -- Split panes
    { key = 'v', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'h', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    -- Navigate panes
    { key = 'n', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'i', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
    { key = 'u', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'e', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },

    -- Toggle fullscreen for pane
    { key = 'f', mods = 'LEADER', action = act.TogglePaneZoomState },

    -- Rename tab
    {
      key = ',',
      mods = 'LEADER',
      action = act.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },

    -- Search mode
    { key = '/', mods = 'LEADER', action = act.Search { CaseInSensitiveString = '' } },

    -- Scroll mode
    { key = 'c', mods = 'LEADER', action = act.ActivateCopyMode },

    -- Resize panes
    {
      key = 'r',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'resize_pane',
        one_shot = false,
      },
    },

    -- Move panes
    {
      key = 'm',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'move_tab',
        one_shot = false,
      },
    },

    -- Session management
    { key = 'o', mods = 'LEADER', action = act.ShowLauncher },

    -- Quick session switcher
    { key = 'z', mods = 'LEADER', action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    } },

    -- Pane cycling with Tab
    { key = 'Tab', mods = 'LEADER', action = act.ActivatePaneDirection 'Next' },

    -- Additional useful bindings
    { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
    { key = '+', mods = 'CMD', action = act.IncreaseFontSize },
    { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
    { key = '0', mods = 'CMD', action = act.ResetFontSize },

    -- Copy/Paste
    { key = 'y', mods = 'CMD', action = act.CopyTo 'Clipboard' },
    { key = 'p', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
    {
      key = 't',
      mods = 'CTRL',
      action = wezterm.action_callback(function(window, pane)
        local tab = window:active_tab()
        local panes = tab:panes_with_info()

        if #panes == 1 then
          -- Create bottom pane
          pane:split {
            direction = 'Bottom',
            size = 0.7,
          }
        elseif #panes == 2 then
          -- Check if we're zoomed
          for _, p in ipairs(panes) do
            if p.is_zoomed then
              -- Unzoom to show the terminal
              window:perform_action(act.TogglePaneZoomState, pane)
              -- Switch to the bottom pane
              window:perform_action(act.ActivatePaneDirection 'Down', pane)
              return
            end
          end
          -- Not zoomed - hide the terminal by zooming the main pane
          window:perform_action(act.ActivatePaneDirection 'Up', pane)
          window:perform_action(act.TogglePaneZoomState, pane)
        end
      end),
    },
    {
      key = '/',
      mods = 'CTRL',
      action = wezterm.action_callback(function(window, pane)
        local tab = window:active_tab()
        local panes = tab:panes_with_info()

        if #panes == 1 then
          -- Create right pane
          pane:split {
            direction = 'Right',
            size = 0.5,
          }
        elseif #panes == 2 then
          -- Check if we're zoomed
          for _, p in ipairs(panes) do
            if p.is_zoomed then
              -- Unzoom to show the split
              window:perform_action(act.TogglePaneZoomState, pane)
              -- Switch to the right pane
              window:perform_action(act.ActivatePaneDirection 'Right', pane)
              return
            end
          end
          -- Not zoomed - hide the split by zooming the main pane
          window:perform_action(act.ActivatePaneDirection 'Left', pane)
          window:perform_action(act.TogglePaneZoomState, pane)
        end
      end),
    },
  },

  -- Key tables for resize and move modes
  key_tables = {
    resize_pane = {
      { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'n', action = act.AdjustPaneSize { 'Left', 1 } },

      { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'i', action = act.AdjustPaneSize { 'Right', 1 } },

      { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'u', action = act.AdjustPaneSize { 'Up', 1 } },

      { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 1 } },
      { key = 'e', action = act.AdjustPaneSize { 'Down', 1 } },

      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'Enter', action = 'PopKeyTable' },
    },

    move_tab = {
      { key = 'n', action = act.MoveTabRelative(-1) },
      { key = 'i', action = act.MoveTabRelative(1) },

      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'Enter', action = 'PopKeyTable' },
    },
  },

  -- Mouse bindings
  mouse_bindings = {
    -- Right click to paste
    {
      event = { Up = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = act.PasteFrom 'Clipboard',
    },

    -- Select text to copy to clipboard
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    },
  },

  unix_domains = {
    {
      name = 'unix',
    },
  },

  launch_menu = {
    {
      label = 'Repos',
      cwd = wezterm.home_dir .. '/Repos',
    },
    {
      label = 'Nix Config',
      cwd = '/etc/nix-darwin',
    },
    {
      label = 'Home',
      cwd = wezterm.home_dir,
    },
  },
}

-- Use Secretive's SSH agent if available
local secretive_sock = wezterm.home_dir .. '/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh'
if #wezterm.glob(secretive_sock) == 1 then
  config.default_ssh_auth_sock = secretive_sock
end

return config
