{ pkgs, pkgs-stable, yamb-yazi, ... }:
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
      extraConfig = builtins.readFile ../wezterm/init.lua;
    };

    git = {
      enable = true;
      package = pkgs-stable.git;
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
        use flake github:vaporif/nix-devshells/77a2a97e4518c611bb69114e3f595f958dd5f9ba
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

  # Tidal configuration (from vim-tidal)
  xdg.configFile."tidal/Tidal.ghci".source = ../tidal/Tidal.ghci;
}
