# Suggested Commands

## System Management
| Command | Description |
|---------|-------------|
| `sudo darwin-rebuild switch` | Apply configuration changes after modifying .nix files |
| `nix flake update` | Update all flake inputs to latest versions |
| `nix flake show` | Display available outputs from the flake |
| `direnv allow ~` | Allow direnv .envrc in home directory |

## Shell Aliases (available after config applied)
| Alias | Command | Description |
|-------|---------|-------------|
| `a` | `claude` | Claude Code CLI |
| `ap` | `claude --print` | Claude Code print mode |
| `ai` | `claude --dangerously-skip-permissions` | Claude Code skip permissions |
| `ar` | `claude --resume` | Claude Code resume session |
| `g` | `lazygit` | Git TUI |
| `e` | `nvim` | Neovim editor |
| `t` | `yy` | Yazi file manager |
| `ls` | `eza -a` | Enhanced ls |
| `cat` | `bat` | Syntax-highlighted cat |
| `x` | `exit` | Exit shell |

## Git Aliases (configured via git config)
| Alias | Command |
|-------|---------|
| `git co` | `git checkout` |
| `git cob` | `git checkout -b` |
| `git discard` | `git reset HEAD --hard` |
| `git fp` | `git fetch --all --prune` |

## Utility Commands (Darwin/macOS)
| Command | Description |
|---------|-------------|
| `ls` | List files (GNU coreutils via Nix) |
| `cd` | Change directory |
| `grep` / `rg` | Search (ripgrep preferred) |
| `fd` | Find files (better than find) |
| `bat` | View files with syntax highlighting |

## Development Tools
| Tool | Purpose |
|------|---------|
| `bacon` | Rust background compiler |
| `uv` | Python package manager |
| `bun` | JavaScript runtime/bundler |
| `just` | Command runner |
| `mprocs` | Process manager |

## Nix-Specific
| Command | Description |
|---------|-------------|
| `nix-tree` | Visualize Nix derivation dependencies |
| `nix-diff` | Compare Nix derivations |
| `nix-search` | Search for Nix packages |
| `nixd` | Nix language server |
