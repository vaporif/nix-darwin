# Project Overview

## Purpose
This is a **Nix-darwin + Home Manager configuration** for macOS that manages system-level and user-level configurations declaratively. It provides a complete development environment setup including:
- System preferences and settings
- Development tools and language servers
- Application configurations (Neovim, WezTerm, Yazi, etc.)
- MCP (Model Context Protocol) server integrations for AI capabilities
- Secrets management via SOPS
- Consistent theming via Stylix

## Tech Stack
- **Configuration Language**: Nix expression language
- **System Management**: nix-darwin (macOS-specific Nix configuration)
- **User Environment**: Home Manager
- **Secrets**: SOPS with age encryption
- **Theming**: Stylix (Everforest Light theme)
- **Platform**: macOS (aarch64-darwin / Apple Silicon)

## Key Dependencies (Flake Inputs)
- `nixpkgs` (unstable channel)
- `nix-darwin`
- `home-manager`
- `sops-nix`
- `stylix`
- `mcp-servers-nix` - MCP server configurations
- `nix-devshells` - External Rust devshell (referenced in ~/.envrc)

## User-Specific Values
- Machine name: `MacBook-Pro`
- Username: `vaporif`
- Home directory: `/Users/vaporif`
