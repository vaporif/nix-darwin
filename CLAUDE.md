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
- `ai` - Claude Code CLI
- `lg` - Lazygit for Git operations
- `e` - Neovim editor
- `t` - Yazi file manager (alias for `yy`)
- `ls` - Enhanced ls with eza (shows hidden files)
- `cat` - Syntax-highlighted cat with bat
- `ghc` / `ghm` - GitHub PR shortcuts (provided by external devshell)

### System-wide Application Shortcuts (skhd)
- `cmd + 1` - Librewolf browser
- `cmd + 2` - Kitty terminal
- `cmd + 3` - Claude app
- `cmd + 4-9` - WhatsApp, Slack, Activity Monitor, Ableton, Telegram, Spotify

## Architecture

### Configuration Flow
The configuration follows a hierarchical module system:
1. `flake.nix` → Entry point defining inputs and instantiating configurations
2. `system.nix` → System-level Darwin settings (imported by flake)
3. `home/default.nix` → User-level home-manager configuration (imported by flake)
4. `home/*.nix` → Modular home configuration files (imported by home/default.nix)

### Core Configuration Files
- `flake.nix` - Main entry point defining inputs (nixpkgs, home-manager, stylix, sops-nix, mcp-servers) and system configuration
- `system.nix` - System-level settings: Homebrew packages, fonts, system preferences, launchd agents, skhd shortcuts
- `home/default.nix` - Main home configuration that imports all modular components
- `home/shell.nix` - Shell environment (zsh, aliases, prompt, completions)
- `home/packages.nix` - User-installed packages and development tools
- `home/mcp-servers.nix` - MCP (Model Context Protocol) server configurations for AI integrations

### Key Directories
- `/nvim/` - Neovim configuration with 30+ plugins, LSP settings, custom keybindings, and lazy-lock.json for reproducibility
- `/karabiner/` - Keyboard customization rules
- `/secrets/` - SOPS-encrypted secrets (SSH keys, API tokens)
- `/wezterm/` - Terminal emulator with tmux-like keybindings
- `/yazi/` - File manager configuration with yamb bookmarks plugin
- `/scripts/` - Custom scripts including LibreWolf auto-updater

### External Dependencies
- Rust devshell from `github:vaporif/nix-devshells` (provides additional development tools via ~/.envrc)
- MCP servers for AI capabilities (filesystem, git, youtube, search, memory, etc.)
- Nixpkgs overlay for package fixes (e.g., Tectonic version pinning)

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
- Language servers: nixd, typescript-language-server, basedpyright, ruff, lua-language-server, haskell-language-server, just-lsp
- Development tools: bacon, cargo-info, rusty-man (Rust), uv (Python 3.12), bun (JavaScript)
- System tools: dust, dua, mprocs, presenterm, tokei, hyperfine

### MCP Server Integrations
The configuration includes extensive AI capabilities through MCP servers:
- **filesystem**: Access to ~/Documents
- **youtube**: API integration for video operations
- **git**: Git repository operations
- **tavily**: Search API integration
- **qdrant**: Vector database for embeddings
- **memory**: Persistent AI memory
- **github**: Repository operations
- **sequential-thinking**: AI reasoning capabilities

### Security
- Secrets managed via SOPS with age encryption (configured in `.sops.yaml`)
- Age key location: `/Users/vaporif/.config/sops/age/key.txt`
- Encrypted secrets: `/secrets/secrets.yaml` (includes API keys for OpenRouter, Tavily, YouTube)
- TouchID enabled for sudo authentication

### System Automation
- LibreWolf browser auto-updates via custom script (`scripts/install-librewolf.sh`) and launchd agent
- Homebrew auto-update, upgrade, and cleanup on system activation
- Direnv integration for project-specific environments

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
- Nixpkgs overlay fixing Tectonic compilation issues
- Pinned nixpkgs-24.05 for specific packages
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
1. Edit `home/mcp-servers.nix`
2. Add server configuration following existing patterns
3. Apply changes and restart Claude app
