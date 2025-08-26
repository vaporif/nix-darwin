{ pkgs, lib, yamb-yazi, ... }:
{
  imports = [
    ./mcp-servers.nix
    ./packages.nix
    ./shell.nix
  ];

  home = {
    homeDirectory = "/Users/vaporif";
    username = "vaporif";
    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;

    gh.enable = true;
    lazygit.enable = true;

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        local wezterm = require 'wezterm'
        local act = wezterm.action
        local config = wezterm.config_builder()
        config.front_end = "WebGpu"
        config.max_fps = 120
        config.animation_fps = 120

        -- Window configuration
        config.window_padding = {
          left = 5,
          right = 5,
          top = 5,
          bottom = 5,
        }
        config.window_decorations = 'RESIZE'
        config.native_macos_fullscreen_mode = true

        -- Tab bar configuration
        config.use_fancy_tab_bar = false
        config.tab_bar_at_bottom = true
        config.hide_tab_bar_if_only_one_tab = true
        config.tab_max_width = 32
        config.cursor_blink_rate = 0

        -- Scrollback
        config.scrollback_lines = 50000

        -- Disable dead keys
        config.use_dead_keys = false

        config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

        config.keys = {
          -- Pane management
          { key = 'b', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' }, -- New tab
          { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } }, -- Close pane

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

          -- Tab navigation
          { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
          { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
          { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
          { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
          { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
          { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
          { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
          { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
          { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },

          -- Rename tab
          {
            key = ',',
            mods = 'LEADER',
            action = act.PromptInputLine {
              description = 'Enter new name for tab',
              action = wezterm.action_callback(function(window, pane, line)
                if line then
                  window:active_tab():set_title(line)
                end
              end),
            },
          },

          -- Search mode
          { key = '/', mods = 'LEADER', action = act.Search { CaseSensitiveString = "" } },

          -- Scroll mode
          { key = 'c', mods = 'LEADER', action = act.ActivateCopyMode },

          -- Resize panes
          { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable {
            name = 'resize_pane',
            one_shot = false,
          } },

          -- Move panes
          { key = 'm', mods = 'LEADER', action = act.ActivateKeyTable {
            name = 'move_tab',
            one_shot = false,
          } },

          -- Session management
          { key = 'o', mods = 'LEADER', action = act.ShowLauncher },

          -- Quick session switcher
          { key = 'z', mods = 'LEADER', action = act.ShowLauncherArgs {
            flags = 'FUZZY|WORKSPACES',
          } },

          -- Additional useful bindings
          { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
          { key = '+', mods = 'CMD', action = act.IncreaseFontSize },
          { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
          { key = '0', mods = 'CMD', action = act.ResetFontSize },

          -- Copy/Paste
          { key = 'c', mods = 'CMD', action = act.CopyTo 'Clipboard' },
          { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
        }

        -- Key tables for resize and move modes
        config.key_tables = {
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
        }

        -- Mouse bindings
        config.mouse_bindings = {
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
        }

        config.unix_domains = {
          {
            name = 'unix',
          },
        }

        config.launch_menu = {
          {
            label = 'Repos',
            cwd = '/Users/vaporif/Repos',
          },
          {
            label = 'Nix Config',
            cwd = '/etc/nix-darwin',
          },
          {
            label = 'Home',
            cwd = '/Users/vaporif',
          },
        }

        return config
      '';
    };

    git = {
      enable = true;
      userName = "Dmytro Onypko";
      userEmail = "vaporif@proton.me";
      aliases = {
        co = "checkout";
        cob = "checkout -b";
        discard = "reset HEAD --hard";
        fp = "fetch --all --prune";
      };
      # yeah signing is not cool since my ssh
      # keys are living inside macbook secure enclave hsm
      signing = {
        key = "AC03496CA69745FE";
        signByDefault = true;
        format = "openpgp";
      };

      extraConfig = {
        core = {
          editor = "nvim";
          pager = "delta";
        };
        pull.ff = "only";
        push.autoSetupRemote = true;
        gui.encoding = "utf-8";
        merge.conflictstyle = "diff3";
        init.defaultBranch = "main";
        rebase.autosquash = true;
        rebase.autostash = true;
        commit.verbose = true;
        diff.colorMoved = true;
        diff.algorithm = "histogram";
        feature.experimental = true;
        help.autocorrect = "prompt";
        branch.sort = "committerdate";
        interactive.diffFilter = "delta --color-only";
        delta.navigate = true;
      };
    };

    neovim = {
      viAlias = true;
      enable = true;
      extraPackages = with pkgs; [
        lua51Packages.luarocks
        lua51Packages.lua
        lua-language-server
        stylua
        typescript-language-server
        haskell-language-server
        basedpyright
        just-lsp
      ];
    };
  };

  home.file = {
    ".envrc".text = ''
        use flake github:vaporif/nix-devshells/b7d8485fa2ad3ffac873a6d83d12fb30172ef0a9
    '';
   ".ssh/config" = {
      source = ../.ssh/config;
    };
  };

  # XDG configuration files
  xdg.configFile."karabiner/karabiner.json".source = ../karabiner/karabiner.json;
  xdg.configFile."ncspot/config.toml".source = ../ncspot/config.toml;
  xdg.configFile."yazi/init.lua".source = ../yazi/init.lua;
  xdg.configFile."yazi/keymap.toml".source = ../yazi/keymap.toml;
  xdg.configFile."yazi/plugins/yamb.yazi/" = {
    source = yamb-yazi;
    recursive = true;
  };
  xdg.configFile.nvim.source = ../nvim;
}
