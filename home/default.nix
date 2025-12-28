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

  # Auto-formatter script for Claude Code hooks
  # Uses shell PATH so project devshells can override formatters
  claudeFormatter = pkgs.writeShellScript "claude-formatter" ''
    file_path=$(${pkgs.jq}/bin/jq -r '.tool_input.file_path // empty')
    [ -z "$file_path" ] || [ ! -f "$file_path" ] && exit 0

    case "$file_path" in
      *.nix) alejandra -q "$file_path" 2>/dev/null || true ;;
      *.go)  gofmt -w "$file_path" 2>/dev/null || true ;;
      *.rs)  rustfmt "$file_path" 2>/dev/null || true ;;
    esac
  '';

  # Claude Code settings with plugins enabled (preserving existing settings)
  claudeSettings = {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";
    alwaysThinkingEnabled = true;
    enabledPlugins = {
      "feature-dev@nix-plugins" = true;
      "ralph-wiggum@nix-plugins" = true;
      "code-review@nix-plugins" = true;
    };
    permissions = {
      allow = [
        # Filesystem - read only
        "mcp__filesystem__read_file"
        "mcp__filesystem__read_text_file"
        "mcp__filesystem__read_media_file"
        "mcp__filesystem__read_multiple_files"
        "mcp__filesystem__list_directory"
        "mcp__filesystem__list_directory_with_sizes"
        "mcp__filesystem__directory_tree"
        "mcp__filesystem__search_files"
        "mcp__filesystem__get_file_info"
        "mcp__filesystem__list_allowed_directories"
        # Git - read only
        "mcp__git__git_status"
        "mcp__git__git_diff_unstaged"
        "mcp__git__git_diff_staged"
        "mcp__git__git_diff"
        "mcp__git__git_log"
        "mcp__git__git_show"
        "mcp__git__git_branch"
        # GitHub - read only
        "mcp__github__get_file_contents"
        "mcp__github__get_commit"
        "mcp__github__get_me"
        "mcp__github__get_tag"
        "mcp__github__get_label"
        "mcp__github__get_latest_release"
        "mcp__github__get_release_by_tag"
        "mcp__github__get_team_members"
        "mcp__github__get_teams"
        "mcp__github__list_branches"
        "mcp__github__list_commits"
        "mcp__github__list_issues"
        "mcp__github__list_pull_requests"
        "mcp__github__list_releases"
        "mcp__github__list_tags"
        "mcp__github__list_issue_types"
        "mcp__github__issue_read"
        "mcp__github__pull_request_read"
        "mcp__github__search_code"
        "mcp__github__search_issues"
        "mcp__github__search_pull_requests"
        "mcp__github__search_repositories"
        "mcp__github__search_users"
        # Serena - read only + activate
        "mcp__serena__activate_project"
        "mcp__serena__check_onboarding_performed"
        "mcp__serena__get_current_config"
        "mcp__serena__list_dir"
        "mcp__serena__read_file"
        "mcp__serena__read_memory"
        "mcp__serena__list_memories"
        "mcp__serena__find_file"
        "mcp__serena__get_symbols_overview"
        "mcp__serena__find_symbol"
        "mcp__serena__find_referencing_symbols"
        "mcp__serena__search_for_pattern"
        "mcp__serena__initial_instructions"
        "mcp__serena__onboarding"
        "mcp__serena__think_about_collected_information"
        "mcp__serena__think_about_task_adherence"
        "mcp__serena__think_about_whether_you_are_done"
        # Nix - read only
        "Bash(nix flake show:*)"
        "Bash(nix flake metadata:*)"
        "Bash(nix flake info:*)"
        "Bash(nix flake check:*)"
        "Bash(nix search:*)"
        "Bash(nix eval:*)"
        "Bash(nix derivation show:*)"
        "Bash(nix why-depends:*)"
        "Bash(nix path-info:*)"
        "Bash(nix store ls:*)"
        "Bash(nix store diff-closures:*)"
        "Bash(nix profile list:*)"
        "Bash(nix registry list:*)"
        "Bash(nix log:*)"
        "Bash(nix hash:*)"
        "Bash(nix-store --query:*)"
        "Bash(nix-store -q:*)"
        "Bash(nix-instantiate --eval:*)"
        # Tavily - web search
        "mcp__tavily__tavily-search"
        "mcp__tavily__tavily-extract"
        "mcp__tavily__tavily-crawl"
        "mcp__tavily__tavily-map"
        # WebFetch - all domains
        "WebFetch"
        # Shell - info only
        "Bash(which:*)"
        "Bash(type:*)"
        "Bash(pwd)"
        "Bash(whoami)"
        "Bash(uname:*)"
        "Bash(date:*)"
        # Rust - read only
        "Bash(cargo check:*)"
        "Bash(cargo test:*)"
        "Bash(cargo clippy:*)"
        "Bash(cargo fmt --check:*)"
        "Bash(cargo doc:*)"
        "Bash(cargo tree:*)"
        "Bash(cargo metadata:*)"
        # Go - read only
        "Bash(go list:*)"
        "Bash(go mod graph:*)"
        "Bash(go doc:*)"
        "Bash(go vet:*)"
        # Blockchain - read only
        "Bash(forge build:*)"
        "Bash(forge test:*)"
        "Bash(forge doc:*)"
        "Bash(cast:*)"
        # Context7 - library docs
        "mcp__context7__resolve-library-id"
        "mcp__context7__get-library-docs"
        # Memory - read only
        "mcp__memory__read_graph"
        "mcp__memory__search_nodes"
        "mcp__memory__open_nodes"
        # NixOS - all search/info tools
        "mcp__nixos__nixos_search"
        "mcp__nixos__nixos_info"
        "mcp__nixos__nixos_channels"
        "mcp__nixos__nixos_stats"
        "mcp__nixos__home_manager_search"
        "mcp__nixos__home_manager_info"
        "mcp__nixos__home_manager_stats"
        "mcp__nixos__home_manager_list_options"
        "mcp__nixos__home_manager_options_by_prefix"
        "mcp__nixos__darwin_search"
        "mcp__nixos__darwin_info"
        "mcp__nixos__darwin_stats"
        "mcp__nixos__darwin_list_options"
        "mcp__nixos__darwin_options_by_prefix"
        "mcp__nixos__nixos_flakes_stats"
        "mcp__nixos__nixos_flakes_search"
        "mcp__nixos__nixhub_package_versions"
        "mcp__nixos__nixhub_find_version"
        # DeepL - translation
        "mcp__deepl__get-source-languages"
        "mcp__deepl__get-target-languages"
        "mcp__deepl__translate-text"
        "mcp__deepl__get-writing-styles"
        "mcp__deepl__get-writing-tones"
        "mcp__deepl__rephrase-text"
        "mcp__deepl__list-glossaries"
        "mcp__deepl__get-glossary"
        "mcp__deepl__get-glossary-dictionary-entries"
        # Time
        "mcp__time__get_current_time"
        "mcp__time__convert_time"
        # Sequential Thinking
        "mcp__sequential-thinking__sequentialthinking"
        # WebSearch
        "WebSearch"
      ];
    };
    hooks = {
      PostToolUse = [
        {
          matcher = "Edit|Write";
          hooks = [
            {
              type = "command";
              command = "${claudeFormatter}";
            }
          ];
        }
      ];
    };
  };

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

    gh.enable = true;
    lazygit.enable = true;

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

  home.file =
    {
      ".envrc".text = ''
        use flake github:vaporif/nix-devshells/683da1d6207cb130c611db98933e82b4a43f7900
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

      # Claude Code settings with plugins enabled
      ".claude/settings.json".text = builtins.toJSON claudeSettings;
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
}
