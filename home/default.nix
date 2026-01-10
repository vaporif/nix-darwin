{
  pkgs,
  config,
  user,
  homeDir,
  sharedLspPackages,
  yamb-yazi,
  mcp-servers-nix,
  mcpConfig,
  claude-code-plugins,
  ...
}: let
  mcpServersConfig = mcp-servers-nix.lib.mkConfig pkgs mcpConfig;

  claudePluginsBase = ".claude/plugins/marketplaces";
  nixPluginsPath = "${claudePluginsBase}/nix-plugins";

  # Marketplace manifest for Nix-managed plugins
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
      installLocation = "${config.home.homeDirectory}/${claudePluginsBase}/claude-plugins-official";
      lastUpdated = "2025-01-01T00:00:00.000Z";
    };
    "nix-plugins" = {
      source = {
        source = "directory";
        path = "${config.home.homeDirectory}/${nixPluginsPath}";
      };
      installLocation = "${config.home.homeDirectory}/${nixPluginsPath}";
      lastUpdated = "2025-01-01T00:00:00.000Z";
    };
  };
in {
  imports = [
    ./packages.nix
    ./shell.nix
  ];

  home = {
    homeDirectory = homeDir;
    username = user;
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
      extraConfig = builtins.readFile ../config/wezterm/init.lua;
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
      extraPackages =
        sharedLspPackages
        ++ (with pkgs; [
          lua51Packages.luarocks
          lua51Packages.lua
          stylua
          haskell-language-server
          just-lsp
          golangci-lint
        ]);
    };

    fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "Apple";
          padding.top = 1;
        };
        display.separator = " → ";
        modules = [
          {
            type = "os";
            key = "OS";
          }
          {
            type = "kernel";
            key = "Kernel";
          }
          {
            type = "uptime";
            key = "Uptime";
          }
          {
            type = "packages";
            key = "Packages";
          }
          {
            type = "shell";
            key = "Shell";
          }
          {
            type = "editor";
            key = "Editor";
          }
          {
            type = "terminal";
            key = "Terminal";
          }
          {
            type = "terminalfont";
            key = "Font";
          }
          {
            type = "command";
            key = "Nix";
            text = "nix --version";
          }
          "break"
          {
            type = "cpu";
            key = "CPU";
          }
          {
            type = "gpu";
            key = "GPU";
          }
          {
            type = "display";
            key = "Display";
          }
          {
            type = "command";
            key = "Sound";
            text = "system_profiler SPAudioDataType 2>/dev/null | awk '/^        [^ ]/{device=$0} /Default System Output Device: Yes/{print device}' | sed 's/://g' | xargs";
          }
          {
            type = "memory";
            key = "Memory";
          }
          {
            type = "disk";
            key = "Disk";
          }
          {
            type = "colors";
            paddingLeft = 2;
            symbol = "circle";
          }
        ];
      };
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
        source = ../config/.ssh/config;
      };
      ".librewolf/librewolf.overrides.cfg" = {
        source = ../config/librewolf/librewolf.overrides.cfg;
      };
      "${config.xdg.configHome}/mcphub/servers.json".source = mcpServersConfig;

      # Claude Code plugins - create a local marketplace structure
      "${nixPluginsPath}/.claude-plugin/marketplace.json".text = nixPluginsMarketplace;
      "${nixPluginsPath}/feature-dev".source = "${claude-code-plugins}/plugins/feature-dev";
      "${nixPluginsPath}/ralph-wiggum".source = "${claude-code-plugins}/plugins/ralph-wiggum";
      "${nixPluginsPath}/code-review".source = "${claude-code-plugins}/plugins/code-review";

      ".claude/CLAUDE.md".source = ../config/claude/CLAUDE.md;
      ".claude/settings.json".source = ../config/claude/settings.json;
      ".claude/plugins/known_marketplaces.json".text = knownMarketplaces;
    }
    // {
      ${
        if pkgs.stdenv.isDarwin
        then "Library/Application Support/Claude/claude_desktop_config.json"
        else ".config/Claude/claude_desktop_config.json"
      }.source =
        mcpServersConfig;
    };

  xdg.configFile = {
    "nvim".source = ../config/nvim;
    "karabiner/karabiner.json".source = ../config/karabiner/karabiner.json;
    "yazi/init.lua".source = ../config/yazi/init.lua;
    "yazi/keymap.toml".source = ../config/yazi/keymap.toml;
    "yazi/plugins/yamb.yazi" = {
      source = yamb-yazi;
      recursive = true;
    };
    "tidal/Tidal.ghci".source = ../config/tidal/Tidal.ghci;
    "procs/config.toml".source = ../config/procs/config.toml;
  };
}
