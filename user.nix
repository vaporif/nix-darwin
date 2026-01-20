# User-specific configuration
# Fork this repo and update these values for your setup
{
  # Your username (macOS user account name)
  username = "vaporif";

  # Your machine's hostname (System Settings → General → Sharing → Local hostname)
  hostname = "MacBook-Pro";

  # System architecture
  # Options: "aarch64-darwin" (Apple Silicon) or "x86_64-darwin" (Intel)
  system = "aarch64-darwin";

  # Git configuration
  git = {
    name = "Dmytro Onypko";
    email = "vaporif@proton.me";
    # GPG signing key (leave empty to disable signing)
    signingKey = "AE206889199EC9E9";
  };

  # Cachix binary cache (optional, remove if not using)
  # Create your own at https://app.cachix.org
  cachix = {
    name = "vaporif";
    publicKey = "vaporif.cachix.org-1:y/fKd8ILM10UJCdXFFYn/n8+AqXnRLzwHjX+BikcUf8=";
  };

  # Path to this config repo (for MCP filesystem access)
  configPath = "/private/etc/nix-darwin";

  # Timezone (used by system and MCP time server)
  # Run `sudo systemsetup -listtimezones` for valid values
  timezone = "Europe/Lisbon";

  # SSH agent: "secretive" for Secretive.app, or "" for default ssh-agent
  sshAgent = "secretive";
}
