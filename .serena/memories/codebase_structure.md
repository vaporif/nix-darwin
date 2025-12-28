# Codebase Structure

## Configuration Flow
```
flake.nix (Entry point)
    ├── system.nix (System-level Darwin settings)
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
| `system.nix` | System-level settings (Homebrew, skhd, secrets, Stylix) |
| `CLAUDE.md` | Instructions for Claude Code |

### `home/` - Home Manager Configuration
| File | Purpose |
|------|---------|
| `default.nix` | Main home config, imports modules, defines programs |
| `packages.nix` | User-installed packages and custom derivations |
| `shell.nix` | Zsh config, aliases, shell tools (fzf, starship, etc.) |

### `nvim/` - Neovim Configuration
| Path | Purpose |
|------|---------|
| `init.lua` | Entry point for Neovim |
| `lua/core/` | Core settings (options, mappings, LSP, autocmds) |
| `lua/plugins/` | Plugin configurations (30+ plugins) |
| `lazy-lock.json` | Plugin version lockfile |
| `.stylua.toml` | Lua formatter configuration |

### `wezterm/` - Terminal Configuration
| File | Purpose |
|------|---------|
| `init.lua` | WezTerm configuration with tmux-like keybindings |

### `yazi/` - File Manager Configuration
| File | Purpose |
|------|---------|
| `init.lua` | Yazi initialization |
| `keymap.toml` | Custom keybindings |
| `bookmark` | Bookmark data |

### `secrets/` - Encrypted Secrets
| File | Purpose |
|------|---------|
| `secrets.yaml` | SOPS-encrypted secrets (API keys, tokens) |

### Other Configuration Directories
| Directory | Purpose |
|-----------|---------|
| `karabiner/` | Keyboard customization rules |
| `tidal/` | TidalCycles live coding setup |
| `librewolf/` | Browser overrides |
| `scripts/` | Custom shell scripts |
| `.ssh/` | SSH configuration |

### Special Files
| File | Purpose |
|------|---------|
| `.sops.yaml` | SOPS encryption configuration |
| `direnvrc` | Direnv library functions |
