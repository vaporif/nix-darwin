{ pkgs, ... }: {
  stylix = {
    enable = true;
    base16Scheme = {
      scheme = "Everforest Light Custom";
      author = "Based on Sainnhe Park";
      base00 = "e8dcc6";  # background
      base01 = "f8f1de";  # lighter bg
      base02 = "d5c9b8";  # selection bg
      base03 = "b5c1b8";  # comments
      base04 = "9da9a0";  # dark fg
      base05 = "5c6a72";  # default fg
      base06 = "4d5b56";  # light fg
      base07 = "3a5b4d";  # light bg
      base08 = "b85450";  # red
      base09 = "c08563";  # orange
      base0A = "c9a05a";  # yellow
      base0B = "89a05d";  # green
      base0C = "6b9b91";  # cyan
      base0D = "6b8b8f";  # blue
      base0E = "9b7d8a";  # purple
      base0F = "859289";  # brown
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 16;
      };
    };
    polarity = "light";
  };
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
      "keycastr"
      "zoom"
    ];
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
}
