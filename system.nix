{ config, pkgs, ... }: {
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

  services = {
    aerospace = {
      enable = true;
      settings = {
        gaps = {
        };
        mode.main.binding = {
          alt-n = "focus left";
          alt-i = "focus down";
          alt-u = "focus up";
          alt-e = "focus right";
          alt-f = "fullscreen";
        };
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.finder = {
    NewWindowTarget = "Home";
    ShowPathbar = true;
  };

  system.defaults.loginwindow = {
    GuestEnabled = false;
    LoginwindowText = "derp durp durrrrrrrrrrrrrrrrrrrrrr";
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
      "telegram"
      "tor-browser"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
