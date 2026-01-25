{
  lib,
  pkgs,
  config,
  user,
  homeDir,
  sharedLspPackages,
  yamb-yazi,
  mcpServersConfig,
  claude-code-plugins,
  nix-devshells,
  userConfig,
  ...
}: let
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
  # Homebrew path differs by architecture
  homebrewPath =
    if pkgs.stdenv.hostPlatform.isAarch64
    then "/opt/homebrew/bin"
    else "/usr/local/bin";
in {
  imports = [
    ./packages.nix
    ./shell.nix
  ];

  # Disable manual generation to avoid builtins.toFile warning (home-manager#7935)
  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };

  home = {
    homeDirectory = homeDir;
    username = user;
    stateVersion = "24.05";
    sessionPath = [
      homebrewPath
      "$HOME/.cargo/bin"
    ];
    sessionVariables =
      {
        SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/key.txt";
        EDITOR = "nvim";
        VISUAL = "nvim";
      }
      // lib.optionalAttrs (userConfig.sshAgent == "secretive") {
        SSH_AUTH_SOCK = "${homeDir}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      };
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
        git.pull.mode = "ff-only";
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
          inherit (userConfig.git) name email;
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
        delta = {
          navigate = true;
          syntax-theme = "gruvbox-light";
          line-numbers = true;
        };
      };
      signing = {
        key = "${homeDir}/.ssh/signing_key.pub";
        signByDefault = userConfig.git.signingKey != "";
        format = "ssh";
      };
      # Note: "gpg.ssh" is git's config namespace for SSH signing, not GPG
      settings.gpg.ssh.allowedSignersFile = "${homeDir}/.ssh/allowed_signers";
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

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      extraOptionOverrides =
        {
          StrictHostKeyChecking = "accept-new";
        }
        // lib.optionalAttrs (userConfig.sshAgent == "secretive") {
          IdentityAgent = "${homeDir}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        };
      matchBlocks."*" = {
        addKeysToAgent = "yes";
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
      };
    };
  };

  home.file =
    {
      ".envrc".text = ''
        use flake github:vaporif/nix-devshells/${nix-devshells.rev}
      '';
      # Qdrant config - localhost only
      ".qdrant/config.yaml".text = ''
        service:
          host: 127.0.0.1
          http_port: 6333
          grpc_port: 6334
        storage:
          storage_path: ${homeDir}/.qdrant/storage
          snapshots_path: ${homeDir}/.qdrant/snapshots
        telemetry_disabled: true
      '';
      # Stable symlink to Neovim runtime for .luarc.json
      ".local/share/nvim-runtime".source = "${pkgs.neovim-unwrapped}/share/nvim/runtime";
      ".librewolf/librewolf.overrides.cfg" = {
        source = ../config/librewolf/librewolf.overrides.cfg;
      };
      "${config.xdg.configHome}/mcphub/servers.json".source = mcpServersConfig;

      # Claude Code plugins - create a local marketplace structure
      "${nixPluginsPath}/.claude-plugin/marketplace.json".text = nixPluginsMarketplace;
      "${nixPluginsPath}/feature-dev".source = "${claude-code-plugins}/plugins/feature-dev";
      "${nixPluginsPath}/ralph-wiggum".source = "${claude-code-plugins}/plugins/ralph-wiggum";
      "${nixPluginsPath}/code-review".source = "${claude-code-plugins}/plugins/code-review";

      # Claude Code custom commands
      ".claude/commands/remember.md".source = ../config/claude-commands/remember.md;
      ".claude/commands/recall.md".source = ../config/claude-commands/recall.md;
      ".claude/commands/cleanup.md".source = ../config/claude-commands/cleanup.md;
      ".claude/commands/commit.md".source = ../config/claude-commands/commit.md;
      ".claude/commands/pr.md".source = ../config/claude-commands/pr.md;

      ".claude/CLAUDE.md".source = ../config/claude/CLAUDE.md;
      ".claude/settings.json".source = ../config/claude/settings.json;
      ".claude/plugins/known_marketplaces.json".text = knownMarketplaces;

      # SSH signing key (public key from Secretive)
      ".ssh/signing_key.pub".text = userConfig.git.signingKey + "\n";
      # SSH allowed signers for git signature verification
      ".ssh/allowed_signers".text = "${userConfig.git.email} ${userConfig.git.signingKey}\n";
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
    "yazi/yazi.toml".source = ../config/yazi/yazi.toml;
    "yazi/init.lua".source = ../config/yazi/init.lua;
    "yazi/keymap.toml".source = ../config/yazi/keymap.toml;
    "yazi/plugins/yamb.yazi" = {
      source = yamb-yazi;
      recursive = true;
    };
    "tidal/Tidal.ghci".source = ../config/tidal/Tidal.ghci;
    "procs/config.toml".source = ../config/procs/config.toml;
  };

  launchd.agents.qdrant = {
    enable = true;
    config = {
      Label = "org.qdrant.server";
      ProgramArguments = [
        "${pkgs.qdrant}/bin/qdrant"
        "--config-path"
        "${homeDir}/.qdrant/config.yaml"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${homeDir}/.qdrant/qdrant.log";
      StandardErrorPath = "${homeDir}/.qdrant/qdrant.err";
    };
  };

  # launchd.agents.rectangle = {
  #   enable = true;
  #   config = {
  #     Label = "com.knollsoft.Rectangle";
  #     ProgramArguments = ["/usr/bin/open" "-a" "Rectangle"];
  #     RunAtLoad = true;
  #   };
  # };
}
