{
  pkgs,
  config,
  lib,
  yamb-yazi,
  mcp-servers-nix,
  mcpConfig,
  claude-code-plugins,
  ...
}: let
  mcpServersConfig = mcp-servers-nix.lib.mkConfig pkgs mcpConfig;

  # Marketplace manifest for our Nix-managed plugins
  nixPluginsMarketplace = builtins.toJSON {
    "$schema" = "https://anthropic.com/claude-code/marketplace.schema.json";
    name = "nix-plugins";
    description = "Nix-managed Claude Code plugins";
    owner = {
      name = "nix";
      email = "nix@localhost";
    };
    plugins = [
      {
        name = "feature-dev";
        description = "Comprehensive feature development workflow";
        source = "./feature-dev";
      }
      {
        name = "ralph-wiggum";
        description = "Iterative development loops";
        source = "./ralph-wiggum";
      }
      {
        name = "code-review";
        description = "Multi-agent PR code review";
        source = "./code-review";
      }
    ];
  };

  # Register marketplaces (preserving claude-plugins-official + adding nix-plugins)
  knownMarketplaces = builtins.toJSON {
    "claude-plugins-official" = {
      source = {
        source = "github";
        repo = "anthropics/claude-plugins-official";
      };
      installLocation = "${config.home.homeDirectory}/.claude/plugins/marketplaces/claude-plugins-official";
      lastUpdated = "2025-01-01T00:00:00.000Z";
    };
    "nix-plugins" = {
      source = {
        source = "directory";
        path = "${config.home.homeDirectory}/.claude/plugins/marketplaces/nix-plugins";
      };
      installLocation = "${config.home.homeDirectory}/.claude/plugins/marketplaces/nix-plugins";
      lastUpdated = "2025-01-01T00:00:00.000Z";
    };
  };
in {
  imports = [
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

    gh = {
      enable = true;
      extensions = [pkgs.gh-dash];
      settings.aliases = {
        co = "pr checkout";
        pv = "pr view --web";
        pl = "pr list";
        ps = "pr status";
        pm = "pr merge";
        d = "dash";
      };
    };
    lazygit = {
      enable = true;
      settings = {
        gui.nerdFontsVersion = "3";
        git.pagers = [
          {
            applyToPager = "diff";
            pager = "delta --paging=never";
            colorArg = "always";
          }
        ];
      };
    };

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ../wezterm/init.lua;
    };

    git = {
      enable = true;
      ignores = [".serena" ".claude" "CLAUDE.md"];
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
        diff.external = "difft";
        diff.algorithm = "histogram";
        feature.experimental = true;
        help.autocorrect = "prompt";
        branch.sort = "committerdate";
        interactive.diffFilter = "delta --color-only";
        delta.navigate = true;
        delta.syntax-theme = "gruvbox-light";
        delta.line-numbers = true;
      };
      signing = {
        key = "AE206889199EC9E9";
        signByDefault = true;
        format = "openpgp";
      };
      maintenance.enable = true;
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

  home.file =
    {
      ".envrc".text = ''
        use flake github:vaporif/nix-devshells/11b7a8af7649f404ad100374166a7a139dbff571
      '';
      # Stable symlink to Neovim runtime for .luarc.json
      ".local/share/nvim-runtime".source = "${pkgs.neovim-unwrapped}/share/nvim/runtime";
      ".ssh/config" = {
        source = ../.ssh/config;
      };
      ".librewolf/librewolf.overrides.cfg" = {
        source = ../librewolf/librewolf.overrides.cfg;
      };
      "${config.xdg.configHome}/mcphub/servers.json".source = mcpServersConfig;

      # Claude Code plugins - create a local marketplace structure
      ".claude/plugins/marketplaces/nix-plugins/.claude-plugin/marketplace.json".text = nixPluginsMarketplace;
      ".claude/plugins/marketplaces/nix-plugins/feature-dev".source = "${claude-code-plugins}/plugins/feature-dev";
      ".claude/plugins/marketplaces/nix-plugins/ralph-wiggum".source = "${claude-code-plugins}/plugins/ralph-wiggum";
      ".claude/plugins/marketplaces/nix-plugins/code-review".source = "${claude-code-plugins}/plugins/code-review";

      # Claude Code settings
      ".claude/settings.json".source = ../claude/settings.json;
      ".claude/plugins/known_marketplaces.json".text = knownMarketplaces;
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      "Library/Application Support/Claude/claude_desktop_config.json".source = mcpServersConfig;
    };

  # XDG configuration files
  xdg.configFile.nvim.source = ../nvim;
  xdg.configFile."karabiner/karabiner.json".source = ../karabiner/karabiner.json;
  xdg.configFile."yazi/init.lua".source = ../yazi/init.lua;
  xdg.configFile."yazi/keymap.toml".source = ../yazi/keymap.toml;
  xdg.configFile."yazi/plugins/yamb.yazi/" = {
    source = yamb-yazi;
    recursive = true;
  };

  xdg.configFile."tidal/Tidal.ghci".source = ../tidal/Tidal.ghci;

  xdg.configFile."procs/config.toml".source = ../procs/config.toml;
}
