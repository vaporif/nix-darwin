{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    nixd
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
    screencapture.location = "~/screenshots";
    screensaver.askForPasswordDelay = 10;
  };
  system.defaults.dock.autohide-delay = 0.2;
  system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = 0.0;
  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        cmd - 1 : open -a "Brave Browser"
        cmd - 2 : open -a "kitty"
        cmd - 3 : open -a "Slack"
        cmd - 4 : open -a "Telegram"
      '';
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.finder = {
    NewWindowTarget = "Home";
    ShowPathbar = true;
  };

  system.defaults.loginwindow = {
    GuestEnabled = false;
    LoginwindowText = "derp durp";
    autoLoginUser = "vaporif";
  };
  system.defaults.menuExtraClock = {
    Show24Hour = true;
    ShowDayOfMonth = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];

    brews = [
      "podman"
    ];

    casks = [
      "kitty"
      "karabiner-elements"
      "telegram"
      "tor-browser"
      "podman-desktop"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
