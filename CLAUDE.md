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

### Core Configuration Files
- `flake.nix` - Main entry point defining inputs (nixpkgs, home-manager, stylix, sops-nix, mcp-servers) and system configuration
- `system.nix` - System-level settings: Homebrew packages, fonts, system preferences, launchd agents, skhd shortcuts
- `home.nix` - User-level settings: shell configuration, development tools, application settings, shell aliases
- `mcp-servers.nix` - MCP (Model Context Protocol) server configurations for AI integrations

### Key Directories
- `/nvim/` - Neovim configuration with 30+ plugins, LSP settings, and custom keybindings
- `/karabiner/` - Keyboard customization rules
- `/secrets/` - SOPS-encrypted secrets (SSH keys, API tokens)
- `/zellij/` - Terminal multiplexer configuration with sessionizer plugin
- `/yazi/` - File manager configuration with yamb bookmarks plugin

### External Dependencies
- Rust devshell from `github:vaporif/nix-devshells` (provides additional development tools via ~/.envrc)
- MCP servers for AI capabilities (filesystem, git, youtube, search, memory, etc.)

## Important Configuration Details

### User-Specific Settings
When working with this configuration, these values in `flake.nix` are user-specific:
- Machine name: `darwinConfigurations."MacBook-Pro"`
- Username: `users.users.vaporif`
- Home directory: `/Users/vaporif`

### Theme System
Uses Stylix for consistent theming across all applications with Everforest Light theme. Color scheme and fonts are centrally managed in `system.nix`.

### Development Environment
- Primary shell: Zsh with extensive configuration
- Package managers: Nix (primary), Homebrew (for casks and specific tools)
- Language servers: nixd, typescript-language-server, basedpyright, ruff, lua-language-server, haskell-language-server, just-lsp
- Development tools: bacon, cargo-info, rusty-man (Rust), uv (Python 3.12), bun (JavaScript)
- System tools: du-dust, dua, mprocs, presenterm, tokei, hyperfine

### MCP Server Integrations
The configuration includes extensive AI capabilities through MCP servers:
- **filesystem**: Access to ~/Documents
- **youtube**: API integration for video operations  
- **git**: Git repository operations
- **tavily**: Search API integration
- **qdrant**: Vector database for embeddings
- **memory**: Persistent AI memory
- **github**: Repository operations

### Security
- Secrets managed via SOPS with age encryption (configured in `.sops.yaml`)
- Age key location: `/Users/vaporif/.config/sops/age/key.txt`
- Encrypted secrets: `/secrets/secrets.yaml` (includes API keys for OpenRouter, Tavily, YouTube)
- TouchID enabled for sudo authentication

### System Automation
- LibreWolf browser auto-updates hourly via launchd agent
- Homebrew auto-update, upgrade, and cleanup on system activation

## Testing Changes

After modifying any .nix files:
1. Run `sudo darwin-rebuild switch` to apply changes
2. Check for errors in the output
3. Restart affected applications if needed

For Neovim changes, restart Neovim to load new configurations.