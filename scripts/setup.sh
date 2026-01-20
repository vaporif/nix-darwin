#!/usr/bin/env bash
set -e
shopt -s inherit_errexit

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Nix-Darwin Setup ===${NC}"
echo ""

# Check if nix is installed
if ! command -v nix &> /dev/null; then
    echo -e "${RED}Error: Nix is not installed.${NC}"
    echo "Install with: curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    exit 1
fi

# Get user info
CURRENT_USER="${USER}"
CURRENT_HOSTNAME=$(scutil --get LocalHostName 2>/dev/null || hostname -s)
CURRENT_SYSTEM=$(uname -m)

if [[ "${CURRENT_SYSTEM}" == "arm64" ]]; then
    NIX_SYSTEM="aarch64-darwin"
else
    NIX_SYSTEM="x86_64-darwin"
fi

echo "Detected configuration:"
echo "  Username: ${CURRENT_USER}"
echo "  Hostname: ${CURRENT_HOSTNAME}"
echo "  System:   ${NIX_SYSTEM}"
echo ""

# Prompt for confirmation or custom values
read -rp "Username [${CURRENT_USER}]: " INPUT_USER
USERNAME="${INPUT_USER:-${CURRENT_USER}}"

read -rp "Hostname [${CURRENT_HOSTNAME}]: " INPUT_HOST
HOSTNAME="${INPUT_HOST:-${CURRENT_HOSTNAME}}"

read -rp "Git name: " GIT_NAME
read -rp "Git email: " GIT_EMAIL
read -rp "Timezone [UTC]: " INPUT_TZ
TIMEZONE="${INPUT_TZ:-UTC}"
read -rp "SSH agent (secretive/default) [default]: " INPUT_SSH
SSH_AGENT="${INPUT_SSH:-}"

echo ""
echo -e "${YELLOW}Updating user.nix...${NC}"

# Get current directory for configPath
CONFIG_PATH=$(pwd)

# Update user.nix
cat > user.nix << EOF
# User-specific configuration
# Fork this repo and update these values for your setup
{
  # Your username (macOS user account name)
  username = "${USERNAME}";

  # Your machine's hostname (System Settings → General → Sharing → Local hostname)
  hostname = "${HOSTNAME}";

  # System architecture
  # Options: "aarch64-darwin" (Apple Silicon) or "x86_64-darwin" (Intel)
  system = "${NIX_SYSTEM}";

  # Git configuration
  git = {
    name = "${GIT_NAME}";
    email = "${GIT_EMAIL}";
    # GPG signing key (leave empty to disable signing)
    signingKey = "";
  };

  # Cachix binary cache (optional, set to empty strings if not using)
  # Create your own at https://app.cachix.org
  cachix = {
    name = "";
    publicKey = "";
  };

  # Path to this config repo (for MCP filesystem access)
  configPath = "${CONFIG_PATH}";

  # Timezone for MCP time server
  timezone = "${TIMEZONE}";

  # SSH agent: "secretive" for Secretive.app, or "" for default ssh-agent
  sshAgent = "${SSH_AGENT}";
}
EOF

echo -e "${GREEN}user.nix updated${NC}"

# Setup age key for SOPS
AGE_KEY_DIR="${HOME}/.config/sops/age"
AGE_KEY_FILE="${AGE_KEY_DIR}/key.txt"

if [[ ! -f "${AGE_KEY_FILE}" ]]; then
    echo ""
    echo -e "${YELLOW}Generating age key for secrets...${NC}"
    mkdir -p "${AGE_KEY_DIR}"
    keygen_output=$(age-keygen -o "${AGE_KEY_FILE}" 2>&1)
    echo "${keygen_output}"
    chmod 600 "${AGE_KEY_FILE}"

    # Extract public key
    grep_output=$(echo "${keygen_output}" | grep "public key:" || true)
    AGE_PUBLIC_KEY=$(echo "${grep_output}" | awk '{print $3}')

    echo -e "${GREEN}Age key generated at ${AGE_KEY_FILE}${NC}"
    echo ""
    echo -e "${YELLOW}Your public key: ${AGE_PUBLIC_KEY}${NC}"
else
    echo ""
    echo -e "${GREEN}Age key already exists at ${AGE_KEY_FILE}${NC}"
    AGE_PUBLIC_KEY=$(age-keygen -y "${AGE_KEY_FILE}")
    echo "Public key: ${AGE_PUBLIC_KEY}"
fi

# Update .sops.yaml
echo ""
echo -e "${YELLOW}Updating .sops.yaml...${NC}"
cat > .sops.yaml << EOF
keys:
  - &${USERNAME} ${AGE_PUBLIC_KEY}
creation_rules:
  - path_regex: secrets/[^/]+\.(yaml|json|env|ini)$
    key_groups:
    - age:
      - *${USERNAME}
EOF
echo -e "${GREEN}.sops.yaml updated${NC}"

# Create secrets template if secrets don't exist
if [[ ! -f "secrets/secrets.yaml" ]]; then
    echo ""
    echo -e "${YELLOW}Creating secrets template...${NC}"
    mkdir -p secrets

    # Create unencrypted template
    cat > secrets/secrets.yaml.template << 'EOF'
# Template for secrets.yaml
# Copy this to secrets.yaml and encrypt with: sops -e -i secrets/secrets.yaml
#
# Example secrets (replace with your actual secrets):
github_token: "ghp_xxxxxxxxxxxxxxxxxxxx"
api_key: "your-api-key-here"
EOF

    echo -e "${GREEN}Template created at secrets/secrets.yaml.template${NC}"
    echo "Edit and encrypt with: sops secrets/secrets.yaml"
fi

# Update justfile and CI for new hostname
echo ""
echo -e "${YELLOW}Updating justfile...${NC}"
sed -i '' "s/MacBook-Pro/${HOSTNAME}/g" justfile 2>/dev/null || true

echo -e "${YELLOW}Updating CI workflow...${NC}"
sed -i '' "s/MacBook-Pro/${HOSTNAME}/g" .github/workflows/check.yml 2>/dev/null || true

echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Next steps:"
echo "  1. Review user.nix and make any additional changes"
echo "  2. Create and encrypt secrets: sops secrets/secrets.yaml"
echo "  3. Run: sudo darwin-rebuild switch --flake .#${HOSTNAME}"
echo ""
echo "Optional:"
echo "  - Set up Cachix: https://app.cachix.org"
echo "  - Set up GPG signing key and update user.nix"
