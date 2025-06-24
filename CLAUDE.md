# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix-darwin + Home Manager configuration for macOS that manages system-level and user-level configurations declaratively. The configuration uses the Nix expression language and includes dotfiles, development tools, and application settings.

## Essential Commands

### System Management
- `sudo darwin-rebuild switch` - Apply configuration changes after modifying any .nix files
- `direnv allow ~` - Allow direnv .envrc for the default devshell (required after initial setup)

### Development Shortcuts
- `ai` - Claude Code CLI
- `lg` - Lazygit for Git operations
- `e` - Neovim editor
- `ghc` - Create GitHub PR assigned to self
- `ghm` - Merge GitHub PR and delete branch

## Architecture

### Core Configuration Files
- `flake.nix` - Main entry point defining inputs (nixpkgs, home-manager, stylix, sops-nix, mcp-servers) and system configuration
- `system.nix` - System-level settings: Homebrew packages, fonts, system preferences, launchd agents
- `home.nix` - User-level settings: shell configuration, development tools, application settings
- `mcp-servers.nix` - MCP (Model Context Protocol) server configurations

### Key Directories
- `/nvim/` - Neovim configuration with 30+ plugins, LSP settings, and custom keybindings
- `/karabiner/` - Keyboard customization rules
- `/secrets/` - SOPS-encrypted secrets (SSH keys, tokens)
- `/zellij/` - Terminal multiplexer configuration with sessionizer plugin
- `/yazi/` - File manager configuration

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
- Language servers: nixd, typescript-language-server, basedpyright, ruff
- Python: Uses `uv` for package management with Python 3.12

### Security
- Secrets managed via SOPS with age encryption
- SSH keys and API tokens stored in `/secrets/`
- Never commit unencrypted secrets

## Testing Changes

After modifying any .nix files:
1. Ensure syntax is correct (Nix will validate during rebuild)
2. Run `sudo darwin-rebuild switch` to apply changes
3. Check for errors in the output
4. Restart affected applications if needed

For Neovim changes, restart Neovim to load new configurations.