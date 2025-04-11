{ config, pkgs, ... }: {
  environment.systemPackages = [
    pkgs.vim
    pkgs.nixd
  ];

  # Address the Determinate error
  nix.enable = false;

  nix.settings.experimental-features = "nix-command flakes";

  system.configurationRevision = null;
  system.stateVersion = 6;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];

    brews = [
    ];

    casks = [
      "kitty"
      "karabiner-elements"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
