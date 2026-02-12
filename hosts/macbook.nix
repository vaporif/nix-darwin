let
  common = import ./common.nix;
in
  common
  // {
    hostname = "MacBook-Pro";
    system = "aarch64-darwin";
    configPath = "/private/etc/nix-darwin";
    sshAgent = "secretive";
  }
