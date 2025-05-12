{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    nixd
    libressl
  ];

  # Address the Determinate error
  nix.enable = false;

  nix.settings.experimental-features = "nix-command flakes";

  system.configurationRevision = null;
  system.stateVersion = 6;

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      wvous-br-corner = 1;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      AppleShowAllFiles = true;
    };
    screencapture.location = "~/screenshots";
    screensaver.askForPasswordDelay = 10;
  };
  system.defaults.dock.autohide-delay = 0.2;
  system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = 0.0;
  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        cmd - 1 : open -a "Librewolf"
        cmd - 2 : open -a "kitty"
        cmd - 3 : open -a "Slack"
        cmd - 4 : open -a "Telegram"
        cmd - 5 : open -a "Spotify"
        cmd - 9 : open -a "FreeTube"
        cmd - 0 : open -a "Brave Browser" "https://anitube.in.ua/3734-uma-musume-pretty-derby-tv-season-2.html"
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
      "librewolf"
      "freetube"
      "simplex"
      "brave-browser"
      "kitty"
      "karabiner-elements"
      "telegram"
      "tor-browser"
      "podman-desktop"
      "vlc"
      "qbittorrent"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
