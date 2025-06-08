{ pkgs, mcp-hub-package, mcp-nixos-package, fzf-git-sh-package, yamb-yazi, ... }:

let
  kittyEverforestDarkHard = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/kovidgoyal/kitty-themes/master/themes/everforest_dark_soft.conf";
    sha256 = "sha256-Zn0aNDlUnD09PP5gZ0xD7dmbycjX3lQBKA2BigZEcoE=";
  };

  kittyEverforestLightHard = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/kovidgoyal/kitty-themes/master/themes/everforest_light_soft.conf";
    sha256 = "sha256-6b3883Dsp0pjmDXTDmwVmscNc3HfNwIlYqpsRc5Ld1U=";
  };
in
{
  imports = [
    ./mcp-servers.nix
  ];

  home = {
    homeDirectory = "/Users/vaporif";
    username = "vaporif";
    stateVersion = "24.05";
  };
  home.packages = with pkgs; [
    nerd-fonts.hack
    yt-dlp
    mermaid-cli
    tectonic
    typescript-language-server
    ueberzugpp
    imagemagick
    pngpaste
    viu
    chafa
    basedpyright
    ghostscript
    wget
    delta
    tldr
    bottom
    hyperfine
    pango
    gnupg
    python312Full
    nodejs_22
    bun
    uv
    ruff
    spacetimedb
    glances
    claude-code
    mcp-hub-package
    mcp-nixos-package
    qdrant
    qdrant-web-ui
  ];

  programs = {
    home-manager.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    gh.enable = true;
    lazygit.enable = true;
    bat = {
      enable = true;
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    kitty = {
      enable = true;
      font = {
        name = "Hack Nerd Font Mono";
        size = 16;
      };
      settings = {
        scrollback_lines = 20000;
        enable_audio_bell = false;
        cursor_trail = 2;
        confirm_os_window_close = 0;
        cursor_trail_start_threshold = 4;
        cursor_trail_decay = "0.05 0.2";
      };
      extraConfig = ''
        macos_option_as_alt yes
      '';
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      stdlib = builtins.readFile ./direnvrc;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ghc = "gh pr create -a @me";
        ghm = "gh pr merge -d";
        ghl = "gh pr list";
        t = "yy";
        lg = "lazygit";
        ai = "claude code";
        ls = "eza -a";
        cat = "bat";
        e = "nvim";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "rust" ];
        theme = "robbyrussell";
      };
      initContent = ''
        ulimit -Sn 4096
        ulimit -Sl unlimited
        source ${fzf-git-sh-package}/bin/fzf-git.sh
        export OPENROUTER_API_KEY="$(cat /run/secrets/openrouter-key)"
        export TAVILY_API_KEY="$(cat /run/secrets/tavily-key)"
        export PATH="/opt/homebrew/bin:$PATH"

        # Generate zellij config if it doesn't exist or update theme based on system appearance
        ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"
        ZELLIJ_CONFIG="$ZELLIJ_CONFIG_DIR/config.kdl"

        # Create directory if it doesn't exist
        mkdir -p "$ZELLIJ_CONFIG_DIR"

        # Detect current theme
        APPEARANCE=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
        if [ "$APPEARANCE" = "Dark" ]; then
          ZELLIJ_THEME="everforest-dark"
        else
          ZELLIJ_THEME="everforest-light-soft"
        fi

        # Copy the config file
        cp ${./zellij/config.kdl} "$ZELLIJ_CONFIG"

        # Update theme in config
        sed -i "" "s/theme \".*\"/theme \"$ZELLIJ_THEME\"/" "$ZELLIJ_CONFIG"
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
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      # remove --exact to make it fuzzy
      historyWidgetOptions = [
        "--no-sort"
        "--tiebreak=index"
      ];
    };

    neovim = {
      viAlias = true;
      enable = true;
      extraPackages = with pkgs; [
        lua51Packages.luarocks
        lua51Packages.lua
        lua-language-server
        stylua
      ];
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zellij = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  home.file = {
    ".envrc".text = ''
        use flake github:vaporif/nix-devshells/23ff6af6c6e5bd542a2c52246dbade2fec96ff63
    '';
   ".ssh/config" = {
      source = ./.ssh/config;
    };
  };

  xdg.configFile."karabiner/karabiner.json".source = ./karabiner/karabiner.json;

  xdg.configFile."kitty/no-preference-theme.auto.conf".source = kittyEverforestLightHard;
  xdg.configFile."kitty/light-theme.auto.conf".source = kittyEverforestLightHard;
  xdg.configFile."kitty/dark-theme.auto.conf".source = kittyEverforestDarkHard;

  xdg.configFile."yazi/init.lua".source = ./yazi/init.lua;
  xdg.configFile."yazi/keymap.toml".source = ./yazi/keymap.toml;
  xdg.configFile."yazi/theme.toml".source = ./yazi/theme.toml;
  xdg.configFile."yazi/plugins/yamb.yazi/" = {
    source = yamb-yazi;
    recursive = true;
  };

  xdg.configFile."bat/config".text = "--style=plain\n--theme=everforest-light\n";
  xdg.configFile."bat/themes/everforest-light.tmTheme".source = ./bat_themes/everforest_light_soft_zellij.tmTheme;
  xdg.configFile.nvim.source = ./nvim;

launchd.agents.zellij-theme-watcher = {
  enable = true;
  config = {
    ProgramArguments = [ "${pkgs.bash}/bin/bash" "-c" ''
      update_theme() {
        # Detect macOS appearance mode using osascript
        APPEARANCE=$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode' 2>/dev/null)

        # Set theme based on system appearance
        if [ "$APPEARANCE" = "true" ]; then
          ZELLIJ_THEME="everforest-dark"
        else
          ZELLIJ_THEME="everforest-light-soft"
        fi

        # Update the config file in place
        sed -i "" "s/theme \".*\"/theme \"$ZELLIJ_THEME\"/" ~/.config/zellij/config.kdl
      }

      # Initial update
      update_theme

      # Use osascript to watch for appearance changes
      osascript -l JavaScript << 'EOF'
      ObjC.import("Cocoa");

      // Function to update zellij theme
      function updateTheme() {
        const task = $.NSTask.alloc.init;
        task.launchPath = "/bin/bash";
        task.arguments = ["-c", `
          APPEARANCE=$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode' 2>/dev/null)
          if [ "$APPEARANCE" = "true" ]; then
            ZELLIJ_THEME="everforest-dark"
          else
            ZELLIJ_THEME="everforest-light-soft"
          fi
          sed -i "" "s/theme \\".*\\"/theme \\"$ZELLIJ_THEME\\"/" ~/.config/zellij/config.kdl
        `];
        task.launch;
        task.waitUntilExit;
      }

      // Set up observer for appearance changes
      $.NSDistributedNotificationCenter.defaultCenter.addObserverForNameObjectQueueUsingBlock(
        "AppleInterfaceThemeChangedNotification",
        null,
        $.NSOperationQueue.mainQueue,
        function(notification) {
          updateTheme();
        }
      );

      // Keep the script running
      $.NSRunLoop.currentRunLoop.run;
      EOF
    '' ];
    RunAtLoad = true;
    KeepAlive = true;
    StandardOutPath = "/tmp/zellij-theme-watcher.log";
    StandardErrorPath = "/tmp/zellij-theme-watcher.err";
  };
};
}
