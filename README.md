# Nix-darwin + home-manager

Cross-platform personal configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

- **macOS** — nix-darwin system config + Home Manager
- **Linux** — Home Manager standalone (with [nixGL](https://github.com/nix-community/nixGL) for GPU apps)

## Forking This Config

### Prerequisites

1. Install [Nix](https://determinate.systems/nix-installer/)
2. **macOS only**: Install [Homebrew](https://brew.sh/) and [nix-darwin](https://github.com/nix-darwin/nix-darwin)

### Quick Setup

```shell
# Clone your fork
git clone https://github.com/YOUR-USERNAME/nix.git ~/.config/nix-darwin
cd ~/.config/nix-darwin

# Run setup script (configures host files, generates age key, etc.)
./scripts/setup.sh

# Create and encrypt your secrets
sops secrets/secrets.yaml

# Apply configuration
# macOS:
sudo darwin-rebuild switch --flake .#YOUR-HOSTNAME
# Linux:
home-manager switch --flake .#YOUR-USER@YOUR-HOSTNAME

# Allow direnv for default devshell
direnv allow ~
```

### Manual Setup

If you prefer manual configuration:

1. **Edit host config** in `hosts/`:
   - Copy an existing host file (e.g., `hosts/macbook.nix`) and override:
   - `hostname` - your machine name
   - `system` - `"aarch64-darwin"`, `"x86_64-darwin"`, `"aarch64-linux"`, or `"x86_64-linux"`
   - `configPath` - path to this repo
   - `sshAgent` - `"secretive"` for macOS Secretive.app, `""` otherwise
   - Edit `hosts/common.nix` for shared values (`user`, `git.*`, `cachix.*`, `timezone`)

2. **Generate age key** for secrets:
   ```shell
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/key.txt
   ```

3. **Update `.sops.yaml`** with your public key

4. **Create secrets** from template:
   ```shell
   cp secrets/secrets.yaml.template secrets/secrets.yaml
   sops -e -i secrets/secrets.yaml
   ```

5. **Apply**:
   ```shell
   just switch
   ```

## Working with SOPS Secrets

Secrets are encrypted using [SOPS](https://github.com/getsops/sops) with age encryption.

### Editing Secrets

```shell
sops secrets/secrets.yaml
```

Opens your `$EDITOR` with decrypted content. Changes are re-encrypted on save.

### Adding New Secrets

1. Edit `secrets/secrets.yaml` and add your secret
2. Define in nix (e.g., `system/security.nix`):
   ```nix
   sops.secrets.my-new-secret = { };
   ```
3. Access at runtime: `/run/secrets/my-new-secret`

## Development

Run `just` to see available commands:

| Command | Description |
|---------|-------------|
| `just switch` | Apply configuration (darwin-rebuild switch) |
| `just check` | Run all checks (lint + policy) |
| `just check-policy` | Run policy checks (freshness, pinning) |
| `just fmt` | Format all files |
| `just cache` | Build and push to Cachix |
| `just setup-hooks` | Enable git hooks |

### Git Hooks

Enable git hooks (auto-format on commit, lint + cache on push):
```shell
just setup-hooks
```

Skip hooks when needed:
```shell
git commit --no-verify
git push --no-verify
```

### Policy Enforcement

Security and compliance checks run in CI and locally:
- **Vulnerability scanning** - `vulnix` with whitelist for false positives
- **Input freshness** - Warns if flake inputs are >30 days old
- **Pinned inputs** - Fails if any inputs are unpinned (indirect)
- **Secret scanning** - `gitleaks` prevents committing secrets
- **License compliance** - Unfree packages must be explicitly allowlisted

Run locally: `just check-vulns` or `just check-policy`

### Cachix

Binary cache for faster builds:
```shell
cachix authtoken <your-token>
just cache
```

## Structure

```
flake.nix                    # Entry point, inputs, outputs for both platforms
├── hosts/
│   ├── common.nix           # Shared user config (name, git, cachix, timezone)
│   ├── macbook.nix          # macOS host overrides
│   └── ubuntu-desktop.nix   # Linux host overrides
├── modules/
│   ├── nix.nix              # Shared Nix settings
│   └── theme.nix            # Shared Stylix theme (Linux standalone)
├── mcp.nix                  # MCP server configuration (shared)
├── system/
│   └── darwin/              # macOS-only: nix-darwin system config, skhd, SOPS, firewall
├── home/
│   ├── common/              # Shared home-manager config (shell, packages, editor, etc.)
│   ├── darwin/              # macOS-specific home config
│   └── linux/               # Linux-specific home config (nixGL, systemd services)
├── overlays/                # Custom package overlays
├── pkgs/                    # Custom package definitions
├── config/                  # Dotfiles (nvim, wezterm, yazi, karabiner, etc.)
├── secrets/
│   ├── secrets.yaml         # Encrypted secrets (not in git)
│   └── secrets.yaml.template
└── scripts/
    ├── setup.sh             # Bootstrap script for forks
    ├── git-bare-clone.sh    # Bare clone with main worktree
    ├── git-meta.sh          # Worktree config sync (.meta/)
    ├── install-librewolf.sh
    └── check-flake-age.sh   # Flake input freshness check
vulnix-whitelist.toml        # CVE whitelist for vulnix
```

## Learning

- https://nix.dev/recommended-reading
