{ pkgs, mcp-hub-package, fzf-git-sh-package, yamb-yazi, ... }:

let
  everforestDarkHard = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/kovidgoyal/kitty-themes/master/themes/everforest_dark_soft.conf";
    sha256 = "sha256-Zn0aNDlUnD09PP5gZ0xD7dmbycjX3lQBKA2BigZEcoE=";
  };

  everforestLightHard = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/kovidgoyal/kitty-themes/master/themes/everforest_light_soft.conf";
    sha256 = "sha256-6b3883Dsp0pjmDXTDmwVmscNc3HfNwIlYqpsRc5Ld1U=";
  };
in
{
  home = {
    homeDirectory = "/Users/vaporif";
    username = "vaporif";
    stateVersion = "24.05";
  };

  home.packages = with pkgs; [
    nerd-fonts.hack
    wget
    delta
    tldr
    bottom
    hyperfine
    pango
    gnupg
    mcp-hub-package
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
        # export PATH="/Users/vaporif/.bun/bin:$PATH"
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

  home.file.".envrc".text = ''
    use flake github:vaporif/nix-devshells
  '';

  home.file = {
    ".ssh/config" = {
      source = ./.ssh/config;
      onChange = ''
        chmod 600 ~/.ssh/config
      '';
    };
  };

  xdg.configFile."karabiner/karabiner.json".source = ./karabiner/karabiner.json;

  xdg.configFile."kitty/no-preference-theme.auto.conf".source = everforestLightHard;
  xdg.configFile."kitty/light-theme.auto.conf".source = everforestLightHard;
  xdg.configFile."kitty/dark-theme.auto.conf".source = everforestDarkHard;

  xdg.configFile."yazi/init.lua".source = ./yazi/init.lua;
  xdg.configFile."yazi/keymap.toml".source = ./yazi/keymap.toml;
  xdg.configFile."yazi/theme.toml".source = ./yazi/theme.toml;
  xdg.configFile."yazi/plugins/yamb.yazi/" = {
    source = yamb-yazi;
    recursive = true;
  };

  xdg.configFile."zellij/config.kdl".source = ./zellij/config.kdl;
  xdg.configFile."bat/config".text = ''
    --style="plain"
  '';
  xdg.configFile.nvim.source = ./nvim;
}
