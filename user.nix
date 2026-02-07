# User-specific configuration
# Fork this repo and update these values for your setup
{
  # Your macOS user account name
  user = "vaporif";

  # Your machine's hostname (System Settings → General → Sharing → Local hostname)
  hostname = "MacBook-Pro";

  # System architecture
  # Options: "aarch64-darwin" (Apple Silicon) or "x86_64-darwin" (Intel)
  system = "aarch64-darwin";

  # Git configuration
  git = {
    name = "Dmytro Onypko";
    email = "vaporif@proton.me";
    # SSH signing key from Secretive (leave empty to disable signing)
    signingKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBP7sf4L6CNhRgdRKmXH2H7xxWTEWMTCS/oOkOwZIIIrpoVeXj01gVp6G4Al0+MdekYO9QbVGX4WMX8+hMpUXs/M= github@secretive.MacBook-Pro.local";
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
  timezone = "Asia/Tokyo";

  # SSH agent: "secretive" for Secretive.app, or "" for default ssh-agent
  sshAgent = "secretive";
}
