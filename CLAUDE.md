# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Nix-darwin + Home Manager configuration for macOS. Manages system and user configurations declaratively using Nix.

## Essential Commands

```bash
just switch                   # Apply configuration changes
nix flake update              # Update all flake inputs
sops secrets/secrets.yaml     # Edit encrypted secrets
just check                    # Run all linting checks
just fmt                      # Format all files
```

## Linting & Formatting

Run `just` to see all available commands. Key ones:

| Command | Description |
|---------|-------------|
| `just switch` | Apply configuration (darwin-rebuild switch) |
| `just check` | Run all checks (lint + policy) |
| `just check-policy` | Policy checks (freshness, pinning) |
| `just lint-lua` | Selene + stylua for Lua files |
| `just lint-nix` | Flake check + alejandra + statix + deadnix |
| `just fmt` | Format all (Lua + Nix + TOML) |
| `just cache` | Build and push to Cachix |
| `just setup-hooks` | Enable git hooks |

Tools: `selene`, `stylua`, `alejandra`, `statix`, `deadnix`, `typos`, `taplo`, `shellcheck`, `actionlint`, `jaq`, `gitleaks`

## Git Hooks

Enable with `just setup-hooks` or `git config core.hooksPath .githooks`:
- **pre-commit**: Auto-formats code with `just fmt`
- **pre-push**: Runs `just check` then `just cache`

Skip hooks when needed: `git commit --no-verify` or `git push --no-verify`

## Cachix

Binary cache at https://vaporif.cachix.org for faster builds:
- CI automatically pushes builds
- Local: `just cache` to build and push
- Auth: `cachix authtoken <token>` (one-time setup)

## Shell Aliases

- `a` - Claude Code CLI
- `ap` - Claude Code with `--print`
- `ai` - Claude Code with `--dangerously-skip-permissions`
- `ar` - Claude Code with `--resume`
- `g` - Lazygit
- `e` - Neovim
- `t` - Yazi file manager
- `ls` - eza (with hidden files)
- `cat` - bat (syntax highlighting)

## Application Shortcuts (skhd)

Uses `hyper` key (caps lock via Karabiner):

| Key | App |
|-----|-----|
| `hyper + r` | Librewolf |
| `hyper + t` | WezTerm |
| `hyper + c` | Claude |
| `hyper + s` | Slack |
| `hyper + b` | Brave |
| `hyper + d` | Discord |
| `hyper + w` | WhatsApp |
| `hyper + m` | Ableton Live |
| `hyper + l` | Signal |
| `hyper + p` | Spotify |

## Architecture

```
flake.nix                    # Entry point, inputs, specialArgs
├── mcp.nix                  # MCP server configuration
├── system/
│   ├── default.nix          # Nix settings, system defaults, skhd
│   ├── theme.nix            # Stylix theme (Everforest Light)
│   ├── security.nix         # SOPS, firewall, TouchID
│   └── homebrew.nix         # Homebrew casks
├── home/
│   ├── default.nix          # Home-manager config, Claude plugins
│   ├── shell.nix            # Zsh, aliases, prompt, shell tools
│   └── packages.nix         # User packages
├── overlays/                # Custom package overlays
└── pkgs/                    # Custom package definitions
```

### Config Files (dotfiles)

Application configs live in `/config/` and are symlinked via `xdg.configFile`:
- `nvim/` - Neovim (Lua)
- `wezterm/` - Terminal (Lua)
- `yazi/` - File manager
- `karabiner/` - Keyboard remapping

## User-Specific Values

Update `user.nix` when forking:
- `user` - macOS username
- `hostname` - machine name
- `system` - architecture
- `git.*` - git identity and signing key
- `cachix.*` - binary cache config
- `timezone` - system timezone
- `sshAgent` - SSH agent type

## MCP Servers

Configured in `mcp.nix`. Available servers:
- **serena** - Semantic code editing (recommended for this repo, has nixd + lua-language-server)
- **filesystem** - File access
- **github** - GitHub operations (uses `gh auth token`)
- **context7** - Library documentation
- **nixos** - NixOS/nix-darwin option search
- **tavily** - Web search
- **deepl** - Translation

## Secrets Management

SOPS with age encryption:
```bash
sops secrets/secrets.yaml              # Edit secrets
cat /run/secrets/<secret-name>         # Access at runtime
```

Key: `~/.config/sops/age/key.txt`

## Claude Code Plugins

Nix-managed plugins from `github:anthropics/claude-code`:
- **feature-dev** - Feature development workflow
- **ralph-wiggum** - Iterative development loops
- **code-review** - PR code review

## Security & Policy Enforcement

- **Secrets**: SOPS with age encryption (key at `~/.config/sops/age/key.txt`)
- **TouchID**: Enabled for sudo via `security.pam.services.sudo_local.touchIdAuth`
- **Firewall**: Application firewall with stealth mode enabled
- **Umask**: Stricter 077 - new files only readable by owner
- **Sudo timeout**: 1 minute

### CI Policy Checks
- **Vulnerability scanning**: `vulnix` with `vulnix-whitelist.toml`
- **Input freshness**: Warns if flake inputs >30 days old
- **Pinned inputs**: Fails if any inputs are unpinned
- **Secret scanning**: `gitleaks` prevents committing secrets
- **License compliance**: Unfree packages must be allowlisted in `flake.nix`

## Key Implementation Details

- **Unfree packages**: Allowlisted in flake.nix (`spacetimedb`, `claude-code`)
- **LibreWolf**: Auto-updated via `scripts/install-librewolf.sh` on activation
- **External devshell**: Rust tools via `~/.envrc` (run `direnv allow ~` after setup)
- **Theme**: Stylix manages colors/fonts across all apps

## Common Tasks

### Adding a Package
1. Edit `home/packages.nix` (user) or `system/default.nix` (system)
2. Run `sudo darwin-rebuild switch`

### Adding/Updating Secrets
1. Edit: `sops secrets/secrets.yaml`
2. Define in nix: `sops.secrets.my-secret = { };` (in `system/security.nix`)
3. Access at runtime: `/run/secrets/my-secret`

### Adding MCP Servers
1. Edit `mcp.nix`
2. Follow existing patterns (see `programs` or `settings.servers`)
3. Apply and restart Claude app

### Modifying Shell Aliases
1. Edit `home/shell.nix` → `shellAliases` section
2. Apply with `sudo darwin-rebuild switch`
