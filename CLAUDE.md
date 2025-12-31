# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix-darwin + Home Manager configuration for macOS that manages system-level and user-level configurations declaratively. The configuration uses the Nix expression language and includes dotfiles, development tools, and application settings.

## Essential Commands

### System Management
- `sudo darwin-rebuild switch` - Apply configuration changes after modifying any .nix files
- `direnv allow ~` - Allow direnv .envrc in home directory for the external Rust devshell (required after initial setup)
- `nix flake update` - Update all flake inputs to latest versions
- `nix flake show` - Display available outputs from the flake

### Shell Aliases
- `a` - Claude Code CLI
- `g` - Lazygit for Git operations
- `e` - Neovim editor
- `t` - Yazi file manager (alias for `yy`)
- `x` - Exit shell
- `ls` - Enhanced ls with eza (shows hidden files)
- `cat` - Syntax-highlighted cat with bat
- `mcp-scan` - Run MCP security scanner

### System-wide Application Shortcuts (skhd)
- `cmd + 1` - Librewolf browser
- `cmd + 2` - WezTerm terminal
- `cmd + 3` - Claude app
- `cmd + 4` - WhatsApp
- `cmd + 5` - Slack
- `cmd + 6` - Brave Browser
- `cmd + 7` - Ableton Live 12 Suite
- `cmd + 8` - Signal
- `cmd + 9` - Spotify

## Architecture

### Configuration Flow
The configuration follows a hierarchical module system:
1. `flake.nix` → Entry point defining inputs, MCP server config, and instantiating configurations
2. `system/` → System-level Darwin settings (imported by flake)
3. `home/default.nix` → User-level home-manager configuration (imported by flake)
4. `home/*.nix` → Modular home configuration files (imported by home/default.nix)

### Core Configuration Files
- `flake.nix` - Main entry point defining inputs (nixpkgs, home-manager, stylix, sops-nix, mcp-servers-nix), MCP server configuration, and system modules
- `system/default.nix` - System-level settings: nix config, system preferences, skhd shortcuts
- `system/theme.nix` - Stylix theme configuration (Everforest Light)
- `system/security.nix` - SOPS secrets, firewall, TouchID
- `system/homebrew.nix` - Homebrew casks and taps
- `home/default.nix` - Main home configuration that imports modules and configures Claude Code plugins
- `home/shell.nix` - Shell environment (zsh, aliases, prompt, completions)
- `home/packages.nix` - User-installed packages and development tools

### Key Directories
- `/config/` - Application configuration files (dotfiles)
  - `nvim/` - Neovim configuration with 30+ plugins, LSP settings, custom keybindings
  - `wezterm/` - Terminal emulator with tmux-like keybindings
  - `yazi/` - File manager configuration with yamb bookmarks plugin
  - `karabiner/` - Keyboard customization rules
  - `librewolf/` - LibreWolf browser configuration overrides
  - `tidal/` - TidalCycles live coding configuration
  - `claude/` - Claude Code settings and permissions
  - `procs/` - Process viewer configuration
  - `.ssh/` - SSH configuration
- `/home/` - Nix home-manager modules
- `/system/` - Nix darwin system modules
- `/pkgs/` - Custom Nix package definitions
- `/secrets/` - SOPS-encrypted secrets (API tokens)
- `/scripts/` - Custom scripts including LibreWolf auto-updater

### External Dependencies
- Rust devshell from `github:vaporif/nix-devshells` (pinned commit, provides additional development tools via ~/.envrc)
- MCP servers for AI capabilities configured inline in flake.nix

## Important Configuration Details

### User-Specific Settings
When working with this configuration, these values in `flake.nix` are user-specific:
- Machine name: `darwinConfigurations."MacBook-Pro"`
- Username: `users.users.vaporif`
- Home directory: `/Users/vaporif`

### Theme System
Uses Stylix for consistent theming across all applications with custom Everforest Light theme. Color scheme and fonts are centrally managed in `system.nix`.

### Development Environment
- Primary shell: Zsh with extensive configuration
- Package managers: Nix (primary), Homebrew (for casks and specific tools)
- Language servers (neovim): lua-language-server, typescript-language-server, basedpyright, haskell-language-server, just-lsp, golangci-lint, nomicfoundation-solidity-language-server
- Nix tools: nixd, nix-tree, nix-diff, nix-search
- Rust tools: bacon, cargo-info, rusty-man
- Python tools: uv, ruff, Python 3.12
- JavaScript tools: bun, Node.js 22
- System tools: dust, dua, mprocs, presenterm, tokei, hyperfine, btop, just, httpie, k9s
- AI/Vector DB: qdrant, qdrant-web-ui
- Media tools: yt-dlp, wiki-tui, mermaid-cli, tectonic

### MCP Server Integrations
The configuration includes extensive AI capabilities through MCP servers (configured in flake.nix).

**Recommended for this repo:** Use Serena for semantic code navigation and editing. It provides symbol-level operations (find definitions, references, rename) that are more precise than text-based search. Configured LSPs relevant to this repo:
- `nixd` for `.nix` files (flake, system, home-manager configs)
- `lua-language-server` for Lua files (Neovim config in `/config/nvim/`, WezTerm config in `/config/wezterm/`)
- **filesystem**: Access to ~/Documents
- **git**: Git repository operations
- **sequential-thinking**: AI reasoning capabilities
- **time**: Time operations (Europe/Lisbon timezone)
- **context7**: Library documentation lookup
- **memory**: Persistent AI memory
- **serena**: Semantic code editing with LSP support and web dashboard (rust-analyzer, gopls, nixd, typescript-language-server, basedpyright, lua-language-server)
- **github**: GitHub repository operations (uses `gh auth token`)
- **deepl**: Translation API integration
- **tavily**: Search API integration
- **nixos**: NixOS/nix-darwin option search

### Claude Code Configuration
- **Global preferences**: `~/.claude/CLAUDE.md` (managed via `config/claude/CLAUDE.md`) - applies to all projects
- **Project-specific**: `/private/etc/nix-darwin/CLAUDE.md` (this file) - applies only to this repo

### Claude Code Plugins
Nix-managed Claude Code plugins (configured in home/default.nix):
- **feature-dev**: Comprehensive feature development workflow
- **ralph-wiggum**: Iterative development loops
- **code-review**: Multi-agent PR code review

Plugins are sourced from `github:anthropics/claude-code` and enabled via settings.json.

### Security
- Secrets managed via SOPS with age encryption (configured in `.sops.yaml`)
- Age key location: `/Users/vaporif/.config/sops/age/key.txt`
- Encrypted secrets: `/secrets/secrets.yaml` (includes API keys for OpenRouter, Tavily, YouTube, DeepL)
- TouchID enabled for sudo authentication
- Application firewall with stealth mode enabled
- Stricter umask (077) - new files only readable by owner
- Secure keyboard entry for Terminal (anti-keylogger)
- Sudo timeout set to 1 minute

### System Automation
- LibreWolf browser auto-updates via custom script (`scripts/install-librewolf.sh`) and activation script
- Homebrew auto-update, upgrade, and cleanup on system activation
- Claude Code managed MCP config deployed to `/Library/Application Support/ClaudeCode/`
- Direnv integration for project-specific environments

### Homebrew Applications (Casks)
Key applications managed via Homebrew:
- **Browsers**: Brave Browser, Tor Browser
- **Communication**: Element, Signal, Simplex
- **Development**: OrbStack (Docker), Karabiner Elements
- **Media**: VLC, SuperCollider, Cardinal (audio plugins), BlackHole (audio routing)
- **Productivity**: Claude, Zoom, MonitorControl, KeyCastr
- **Privacy**: Proton Mail, Proton Drive, ProtonVPN, Secretive (SSH keys)
- **Other**: GIMP, qBittorrent

### Special Configurations

#### Tidal Live Coding
- Complete TidalCycles setup for algorithmic music
- Custom shell scripts (`tidal`, `tidalvim`) for workflow
- GHC with Tidal packages pre-configured
- SuperCollider integration for audio synthesis

#### WezTerm Terminal
- Tmux-like keybindings with leader key (Ctrl-b)
- Smart pane management with toggle functionality
- Integration with Yazi file manager

#### Package Version Management
- Unfree package allowlist (spacetimedb, claude-code)

## Testing Changes

After modifying any .nix files:
1. Run `sudo darwin-rebuild switch` to apply changes
2. Check for errors in the output
3. Restart affected applications if needed

For Neovim changes, restart Neovim to load new configurations.

## Common Development Tasks

### Adding a New Package
1. Edit `home/packages.nix` for user packages or `system.nix` for system packages
2. Run `sudo darwin-rebuild switch`

### Updating Secrets
1. Edit secrets with: `sops secrets/secrets.yaml`
2. Reference in configuration via `config.sops.secrets.<name>.path`

### Modifying Shell Aliases
1. Edit `home/shell.nix` in the `shellAliases` section
2. Apply with `sudo darwin-rebuild switch`
3. Restart shell or source new configuration

### Adding MCP Servers
1. Edit `mcpConfig` in `flake.nix`
2. Add server configuration following existing patterns
3. Apply changes and restart Claude app
