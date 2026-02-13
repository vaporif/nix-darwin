# Project Overview

## Purpose
This is a **cross-platform Nix configuration** for macOS (nix-darwin) and Linux (Home Manager standalone) that manages system-level and user-level configurations declaratively. It provides a complete development environment setup including:
- System preferences and settings
- Development tools and language servers
- Application configurations (Neovim, WezTerm, Yazi, etc.)
- MCP (Model Context Protocol) server integrations for AI capabilities
- Secrets management via SOPS (macOS)
- Consistent theming via Stylix
- nixGL wrapping for GPU apps on Linux

## Tech Stack
- **Configuration Language**: Nix expression language
- **System Management**: nix-darwin (macOS), Home Manager standalone (Linux)
- **User Environment**: Home Manager
- **Secrets**: SOPS with age encryption
- **Theming**: Stylix (Everforest Light theme)
- **Platforms**: macOS (aarch64-darwin), Linux (aarch64-linux)
- **GPU Support**: nixGL (mesa) for Linux GUI apps

## Key Dependencies (Flake Inputs)
- `nixpkgs` (unstable channel)
- `nix-darwin`
- `home-manager`
- `sops-nix`
- `stylix`
- `mcp-servers-nix` - MCP server configurations
- `nix-devshells` - External Rust devshell (referenced in ~/.envrc)
- `nixgl` - OpenGL/GPU wrapper for non-NixOS Linux

## Hosts
- **macbook** — macOS (aarch64-darwin), `darwinConfigurations`, user `vaporif`
- **ubuntu-desktop** — Linux (aarch64-linux), `homeConfigurations`, user `vaporif`
