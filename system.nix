{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    age
    libressl
  ];

  # Address the Determinate error
  nix.enable = false;

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.keyFile = "/Users/vaporif/.config/sops/age/key.txt";
  sops.age.sshKeyPaths = [];
  sops.secrets.openrouter-key = {
    owner = "vaporif";
    group = "staff";
    mode = "0400";
  };

  sops.secrets.tavily-key = {
    owner = "vaporif";
    group = "staff";
    mode = "0400";
  };

  sops.secrets.youtube-key = {
    owner = "vaporif";
    group = "staff";
    mode = "0400";
  };

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = null;
  system.stateVersion = 6;
  system.primaryUser = "vaporif";
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
        cmd - 3 : open -a "Claude"
        cmd - 4 : open -a "WhatsApp"
        cmd - 5 : open -a "Slack"
        cmd - 6 : open -a "Activity Monitor"
        cmd - 7 : open -a "Brave Browser"
        cmd - 8 : open -a "Telegram"
        cmd - 9 : open -a "Spotify"
        cmd - 0 : open -a "Librewolf" "https://anitube.in.ua/3734-uma-musume-pretty-derby-tv-season-2.html"
      '';
    };
    openssh.enable = false;
  };
  launchd.user.agents = {
    librewolf-hourly-update = {
      serviceConfig = {
        Label = "com.user.librewolf-hourly-install";
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "/opt/homebrew/bin/brew install --cask librewolf || /opt/homebrew/bin/brew upgrade --cask librewolf"
        ];
        StartInterval = 3600;
        RunAtLoad = true;
        StandardOutPath = "/Users/${builtins.getEnv "USER"}/Library/Logs/librewolf-install.log";
        StandardErrorPath = "/Users/${builtins.getEnv "USER"}/Library/Logs/librewolf-install.error.log";
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
      "oven-sh/bun"
    ];

    brews = [
      "ollama"
    ];

    casks = [
      "element"
      "librewolf"
      "freetube"
      "claude"
      "brave-browser"
      "kitty"
      "karabiner-elements"
      "tor-browser"
      "vlc"
      "orbstack"
      "qbittorrent"
      "secretive"
      "simplex"
      "signal"
      "cardinal"
    ];
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
}
