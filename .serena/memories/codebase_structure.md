# Codebase Structure

## Configuration Flow
```
flake.nix (Entry point)
    ├── system/ (System-level Darwin settings)
    │       ├── default.nix (nix config, system defaults, skhd)
    │       ├── theme.nix (Stylix theme)
    │       ├── security.nix (SOPS, firewall, TouchID)
    │       └── homebrew.nix (Homebrew casks)
    └── home/default.nix (User-level home-manager config)
            ├── home/packages.nix (User packages)
            └── home/shell.nix (Shell configuration)
```

## Directory Structure

### Root Level
| File/Dir | Purpose |
|----------|---------|
| `flake.nix` | Main entry point, defines inputs and outputs |
| `flake.lock` | Locked versions of all flake inputs |
| `mcp.nix` | MCP server configuration |
| `CLAUDE.md` | Instructions for Claude Code |

### `system/` - Darwin System Configuration
| File | Purpose |
|------|---------|
| `default.nix` | Nix settings, system defaults, skhd shortcuts |
| `theme.nix` | Stylix theme (Everforest Light) |
| `security.nix` | SOPS secrets, firewall, TouchID |
| `homebrew.nix` | Homebrew casks and taps |

### `home/` - Home Manager Configuration
| File | Purpose |
|------|---------|
| `default.nix` | Main home config, imports modules, defines programs |
| `packages.nix` | User-installed packages and custom derivations |
| `shell.nix` | Zsh config, aliases, shell tools (fzf, starship, etc.) |

### `config/` - Application Configurations (Dotfiles)
| Path | Purpose |
|------|---------|
| `nvim/` | Neovim config (init.lua, lua/core/, lua/plugins/, lazy-lock.json) |
| `wezterm/` | Terminal config with tmux-like keybindings |
| `yazi/` | File manager config (init.lua, keymap.toml) |
| `karabiner/` | Keyboard customization rules |
| `librewolf/` | Browser configuration overrides |
| `tidal/` | TidalCycles live coding setup |
| `claude/` | Claude Code settings and CLAUDE.md |
| `procs/` | Process viewer configuration |
| `direnvrc` | Direnv library functions |

### `pkgs/` - Custom Nix Packages
| File | Purpose |
|------|---------|
| `unclog.nix` | Custom package |
| `nomicfoundation-solidity-language-server.nix` | Solidity LSP |

### `secrets/` - Encrypted Secrets
| File | Purpose |
|------|---------|
| `secrets.yaml` | SOPS-encrypted secrets (API keys, tokens) |

### Other Directories
| Directory | Purpose |
|-----------|---------|
| `scripts/` | Custom shell scripts (LibreWolf installer) |
| `.ssh/` | SSH configuration |

### Special Files
| File | Purpose |
|------|---------|
| `.sops.yaml` | SOPS encryption configuration |
