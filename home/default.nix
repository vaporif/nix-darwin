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

    kitty = {
      enable = true;
      font = {
        name = "Hack Nerd Font Mono";
      };
      settings = {
        scrollback_lines = 20000;
        enable_audio_bell = false;
        cursor_trail = 2;
        confirm_os_window_close = 0;
        cursor_trail_start_threshold = 4;
        cursor_trail_decay = "0.05 0.2";
      };
      keybindings = {
        "cmd+t" = "no_op";
      };
      extraConfig = ''
        map shift+space send_key ~
        macos_option_as_alt yes
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

    zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        simplified_ui = true;
        show_startup_tips = false;
        pane_frames = false;
      };
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

  xdg.configFile."zellij/config.kdl".text = lib.mkAfter ''
    ${builtins.readFile ../zellij/config.kdl }
  '';
  xdg.configFile."zellij/plugins/zellij-sessionizer.wasm".source = pkgs.fetchurl {
    url = "https://github.com/laperlej/zellij-sessionizer/releases/download/v0.4.3/zellij-sessionizer.wasm";
    sha256 = "sha256-AGuWbuRX7Yi9tPdZTzDKULXh3XLUs4navuieCimUgzQ=";
  };
  xdg.configFile.nvim.source = ../nvim;
}
