{ pkgs, lib, mcp-nixos-package, fzf-git-sh-package, yamb-yazi, ... }:
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
    nixd
    nix-tree
    nix-diff
    nix-search
    du-dust
    dua
    bacon
    cargo-info
    rusty-man
    ncspot
    wiki-tui
    mprocs
    presenterm
    tokei
    httpie
    yt-dlp
    mermaid-cli
    tectonic
    just
    ghc
    tmux
    typescript-language-server
    haskellPackages.tidal
    haskellPackages.cabal-install
    haskell-language-server
    just-lsp
    ueberzugpp
    imagemagick
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
    glances
    claude-code
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

    carapace = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      stdlib = builtins.readFile ./direnvrc;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = ''
          $directory$git_branch$git_state$git_status$cmd_duration$line_break$character
        '';

        directory = {
          format = "[$path]($style)[$read_only]($read_only_style) ";
          style = "bold blue";
          truncation_length = 3;
          truncate_to_repo = true;
          read_only = " 🔒";
          read_only_style = "red";
        };

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold cyan)";
        };

        git_branch = {
          format = "[ $branch]($style)";
          style = "bold cyan";
        };

        git_status = {
          format = "[$all_status$ahead_behind]($style)";
          conflicted = "⚔️ ";
          ahead = "⇡$count";
          behind = "⇣$count";
          diverged = "⇕⇡$ahead_count⇣$behind_count";
          untracked = "🆕$count";
          stashed = "📦$count";
          modified = "📝$count";
          staged = "✅$count";
          renamed = "🔄$count";
          deleted = "🗑️$count";
          style = "bold yellow";
        };

        git_state = {
          format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
          style = "bold yellow";
        };

        cmd_duration = {
          format = "[⏱️ $duration]($style) ";
          style = "bold yellow";
          min_time = 2000;
        };

      };
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        highlight = "fg=#939f91,bold";
      };
      syntaxHighlighting.enable = true;
      shellAliases = {
        t = "yy";
        lg = "lazygit";
        ai = "claude code";
        ls = "eza -a";
        cat = "bat";
        e = "nvim";
      };
      initContent = ''
        ulimit -Sn 4096
        ulimit -Sl unlimited
        source ${fzf-git-sh-package}/bin/fzf-git.sh
        export OPENROUTER_API_KEY="$(cat /run/secrets/openrouter-key)"
        export TAVILY_API_KEY="$(cat /run/secrets/tavily-key)"
        export PATH="/opt/homebrew/bin:$PATH"
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
      source = ./.ssh/config;
    };
  };

  xdg.configFile."karabiner/karabiner.json".source = ./karabiner/karabiner.json;

  xdg.configFile."ncspot/config.toml".source = ./ncspot/config.toml;

  xdg.configFile."yazi/init.lua".source = ./yazi/init.lua;
  xdg.configFile."yazi/keymap.toml".source = ./yazi/keymap.toml;
  xdg.configFile."yazi/plugins/yamb.yazi/" = {
    source = yamb-yazi;
    recursive = true;
  };

  xdg.configFile."zellij/config.kdl".text = lib.mkAfter ''
    ${builtins.readFile ./zellij/config.kdl }
  '';
  xdg.configFile."zellij/plugins/zellij-sessionizer.wasm".source = pkgs.fetchurl {
    url = "https://github.com/laperlej/zellij-sessionizer/releases/download/v0.4.3/zellij-sessionizer.wasm";
    sha256 = "sha256-AGuWbuRX7Yi9tPdZTzDKULXh3XLUs4navuieCimUgzQ=";
  };
  xdg.configFile.nvim.source = ./nvim;
}
