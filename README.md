# Nix-darwin + home-manager

Personal macOS configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## Forking This Config

### Prerequisites

1. Install [Homebrew](https://brew.sh/)
2. Install [Nix](https://determinate.systems/nix-installer/)
3. Install [nix-darwin](https://github.com/nix-darwin/nix-darwin)

### Quick Setup

```shell
# Clone your fork
git clone https://github.com/YOUR-USERNAME/nix-darwin.git /etc/nix-darwin
cd /etc/nix-darwin

# Run setup script (configures user.nix, generates age key, etc.)
./scripts/setup.sh

# Create and encrypt your secrets
sops secrets/secrets.yaml

# Apply configuration
sudo darwin-rebuild switch --flake .#YOUR-HOSTNAME

# Allow direnv for default devshell
direnv allow ~
```

### Manual Setup

If you prefer manual configuration:

1. **Edit `user.nix`** with your values:
   - `user` - your macOS username
   - `hostname` - your machine name (System Settings → Sharing → Local hostname)
   - `system` - `"aarch64-darwin"` (Apple Silicon) or `"x86_64-darwin"` (Intel)
   - `git.name` / `git.email` - your git identity
   - `git.signingKey` - your GPG key ID (or empty to disable signing)
   - `cachix` - your Cachix cache (or empty strings to disable)
   - `configPath` - path to this repo (e.g., `/etc/nix-darwin`)
   - `timezone` - your timezone (run `sudo systemsetup -listtimezones`)
   - `sshAgent` - `"secretive"` for Secretive.app or `""` for default

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
user.nix                     # User-specific config (edit this when forking)
flake.nix                    # Entry point, inputs
├── mcp.nix                  # MCP server configuration
├── system/
│   ├── default.nix          # System defaults, skhd
│   ├── theme.nix            # Stylix theme
│   ├── security.nix         # SOPS, firewall, TouchID
│   └── homebrew.nix         # Homebrew casks
├── home/
│   ├── default.nix          # Home-manager config
│   ├── shell.nix            # Zsh, aliases, prompt
│   └── packages.nix         # User packages
├── overlays/                # Custom package overlays
├── pkgs/                    # Custom package definitions
├── config/                  # Dotfiles (nvim, wezterm, etc.)
├── secrets/
│   ├── secrets.yaml         # Encrypted secrets (not in git)
│   └── secrets.yaml.template
└── scripts/
    ├── setup.sh             # Bootstrap script for forks
    ├── install-librewolf.sh
    └── check-flake-age.sh   # Flake input freshness check
vulnix-whitelist.toml        # CVE whitelist for vulnix
```

## Learning

- https://nix.dev/recommended-reading
