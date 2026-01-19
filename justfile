# List available recipes
default:
    @just --list

# Run all checks
check: lint-lua lint-nix lint-json check-typos

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

# Format nix files
fmt-nix:
    alejandra .

# Validate JSON configs (use jq or jaq)
lint-json:
    @which jaq >/dev/null 2>&1 && jaq empty config/karabiner/karabiner.json || jq empty config/karabiner/karabiner.json

# Check for typos
check-typos:
    typos

# Format all
fmt: fmt-lua fmt-nix
