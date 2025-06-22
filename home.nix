{ pkgs, lib, config, mcp-nixos-package, fzf-git-sh-package, yamb-yazi, ... }:

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
    nixd
    nix-tree
    nix-diff
    nix-search
    tokei
    httpie
    nerd-fonts.hack
    yt-dlp
    mermaid-cli
    tectonic
    typescript-language-server
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

  stylix.targets = {
    kitty.enable = true;
    bat.enable = true;
    yazi.enable = true;
    lazygit.enable = true;
    starship.enable = true;
    fzf.enable = true;
    zellij.enable = true;
  };

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

        directory.style = "blue";

        character = {
          success_symbol = "[❯](purple)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };

        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };

        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
        };

        git_state = {
          format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
          style = "bright-black";
        };

        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
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
        show_startup_tips = false;
        pane_frames = false;
      };
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

  xdg.configFile."yazi/init.lua".source = ./yazi/init.lua;
  xdg.configFile."yazi/keymap.toml".source = ./yazi/keymap.toml;
  xdg.configFile."yazi/plugins/yamb.yazi/" = {
    source = yamb-yazi;
    recursive = true;
  };
  xdg.configFile."zellij/config.kdl".text = lib.mkAfter ''
   ${builtins.readFile ./zellij/keybinds.kdl}
  '';
  xdg.configFile.nvim.source = ./nvim;
}
