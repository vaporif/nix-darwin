# Codebase Structure

## Configuration Flow
```
user.nix (User-specific config - edit when forking)
flake.nix (Entry point)
    ├── overlays/ (Custom package overlays)
    ├── pkgs/ (Custom package definitions)
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
| `user.nix` | User-specific config (user, hostname, git, timezone) |
| `flake.nix` | Main entry point, defines inputs and outputs |
| `flake.lock` | Locked versions of all flake inputs |
| `justfile` | Task runner for linting/formatting/update commands |
| `typos.toml` | Typos checker configuration |
| `mcp.nix` | MCP server configuration |
| `CLAUDE.md` | Instructions for Claude Code |

### `overlays/` - Custom Package Overlays
| File | Purpose |
|------|---------|
| `default.nix` | Overlay with custom packages (unclog, solidity-lsp, claude_formatter, tidal_script) |

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
| `nvim/` | Neovim config (init.lua, lua/core/, lua/plugins/, selene.toml, vim.yml) |
| `wezterm/` | Terminal config with tmux-like keybindings |
| `yazi/` | File manager config (init.lua, keymap.toml) |
| `karabiner/` | Keyboard customization rules |
| `librewolf/` | Browser configuration overrides |
| `tidal/` | TidalCycles live coding setup |
| `claude/` | Claude Code settings and CLAUDE.md |
| `procs/` | Process viewer configuration |
| `.ssh/` | SSH configuration |
| `direnvrc` | Direnv library functions |

### `pkgs/` - Custom Nix Package Definitions (with passthru.tests)
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

### Special Files
| File | Purpose |
|------|---------|
| `.sops.yaml` | SOPS encryption configuration |
