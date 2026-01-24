# List available recipes
default:
    @just --list

# Run all checks
check: lint-lua lint-nix lint-json lint-toml lint-shell lint-actions check-typos check-policy

# Run policy checks (freshness, pinning)
check-policy: check-freshness check-pinned

# Lint nvim lua with selene
lint-lua:
    cd config/nvim && selene lua after init.lua
    stylua --check config/

# Format lua files
fmt-lua:
    stylua config/

# Lint nix files
lint-nix:
    nix flake check
    alejandra --check .
    statix check
    deadnix --fail

# Format nix files
fmt-nix:
    alejandra .

# Validate JSON configs
lint-json:
    jq empty config/karabiner/karabiner.json

# Lint TOML files
lint-toml:
    taplo check

# Format TOML files
fmt-toml:
    taplo fmt

# Lint shell scripts
lint-shell:
    shellcheck -S style -o all scripts/*.sh

# Lint GitHub Actions
lint-actions:
    actionlint

# Check for typos
check-typos:
    typos

# Check flake input freshness (warn if >30 days old)
check-freshness:
    ./scripts/check-flake-age.sh 30 true

# Scan for vulnerabilities (with whitelist)
check-vulns:
    vulnix --system --whitelist vulnix-whitelist.toml

# Verify inputs are pinned
check-pinned:
    @echo "Checking all inputs are pinned..."
    @! grep -q '"type": "indirect"' flake.lock && echo "All inputs properly pinned."

# Format all
fmt: fmt-lua fmt-nix fmt-toml

# Apply configuration
switch:
    sudo darwin-rebuild switch

# Update neovim plugins
lazy-update:
    nvim --headless "+Lazy! update" +qa

# Set up git hooks
setup-hooks:
    git config core.hooksPath .githooks

# Build and push to cachix
cache:
    #!/usr/bin/env bash
    hostname=$(nix eval --raw -f user.nix hostname)
    cachix_name=$(nix eval --raw -f user.nix cachix.name)
    nix build ".#darwinConfigurations.${hostname}.system"
    [[ -n "$cachix_name" ]] && cachix push "$cachix_name" ./result
