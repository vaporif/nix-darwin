{ pkgs, yamb-yazi, ... }:
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
      ignores = [ ".serena" ".claude" "CLAUDE.md" ];
      settings = {
        user = {
          name = "Dmytro Onypko";
          email = "vaporif@proton.me";
        };
        aliases = {
          co = "checkout";
          cob = "checkout -b";
          discard = "reset HEAD --hard";
          fp = "fetch --all --prune";
        };
        core = {
          editor = "nvim";
          pager = "delta";
        };
        pull.ff = "only";
        push.autoSetupRemote = true;
        gui.encoding = "utf-8";
        merge.conflictstyle = "diff3";
        init.defaultBranch = "main";
        init.defaultRefFormat = "files";
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
      signing = {
        key = "AE206889199EC9E9";
        signByDefault = true;
        format = "openpgp";
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
        pkgs.basedpyright # Using pinned version to avoid Node.js 22 compilation issue
        just-lsp
        golangci-lint
      ];
    };
  };

  home.file = {
    ".envrc".text = ''
        use flake github:vaporif/nix-devshells/ebd3bbdde917db4cba86c322235d68ce6f0c9d5d
    '';
    ".ssh/config" = {
      source = ../.ssh/config;
    };
    ".librewolf/librewolf.overrides.cfg" = {
      source = ../librewolf/librewolf.overrides.cfg;
    };
  };

  # XDG configuration files
  xdg.configFile.nvim.source = ../nvim;
  xdg.configFile."karabiner/karabiner.json".source = ../karabiner/karabiner.json;
  xdg.configFile."ncspot/config.toml".source = ../ncspot/config.toml;
  xdg.configFile."yazi/init.lua".source = ../yazi/init.lua;
  xdg.configFile."yazi/keymap.toml".source = ../yazi/keymap.toml;
  xdg.configFile."yazi/plugins/yamb.yazi/" = {
    source = yamb-yazi;
    recursive = true;
  };

  xdg.configFile."tidal/Tidal.ghci".source = ../tidal/Tidal.ghci;
}
