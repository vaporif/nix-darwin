{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    nixd
    kanata
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
        on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
        gaps = {
        };
        mode.main.binding = {
          alt-j = "focus left";
          alt-u = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-e = "macos-native-fullscreen";

          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";
          alt-0 = "workspace 10";


          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
          alt-shift-0 = "move-node-to-workspace 10";
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
