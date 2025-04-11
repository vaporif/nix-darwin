{ config, pkgs, ... }:

{
  # List packages installed in system profile
  environment.systemPackages = [
    pkgs.vim
    pkgs.nixd
  ];
  
  # Address the Determinate error
  nix.enable = false;
  
  # Necessary for using flakes on this system
  nix.settings.experimental-features = "nix-command flakes";
  
  # Set Git commit hash for darwin-version
  system.configurationRevision = null;
  system.stateVersion = 6;
  
  # Enable homebrew
  homebrew.enable = true;
  
  # Set platform
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  # You can add more system-level configurations here
  # such as networking, fonts, system services, etc.
}
