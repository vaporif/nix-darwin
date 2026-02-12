let
  common = import ./common.nix;
in
  common
  // {
    hostname = "vaporif-bubuntu";
    system = "aarch64-linux";
    configPath = "/etc/nix-darwin";
    sshAgent = "";
  }
