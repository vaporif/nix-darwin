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

  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 10;
  };

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
