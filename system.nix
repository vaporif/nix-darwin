{
  pkgs,
  lib,
  user,
  homeDir,
  mcp-servers-nix,
  mcpConfig,
  ...
}: let
  mcpServersConfig = mcp-servers-nix.lib.mkConfig pkgs mcpConfig;
in {
  stylix = {
    enable = true;
    base16Scheme = {
      scheme = "Everforest Light Custom";
      author = "Based on Sainnhe Park";
      base00 = "e8dcc6"; # background
      base01 = "f8f1de"; # lighter bg
      base02 = "d5c9b8"; # selection bg
      base03 = "b5c1b8"; # comments
      base04 = "9da9a0"; # dark fg
      base05 = "5c6a72"; # default fg
      base06 = "4d5b56"; # light fg
      base07 = "3a5b4d"; # light bg
      base08 = "b85450"; # red
      base09 = "c08563"; # orange
      base0A = "c9a05a"; # yellow
      base0B = "89a05d"; # green
      base0C = "6b9b91"; # cyan
      base0D = "6b8b8f"; # blue
      base0E = "9b7d8a"; # purple
      base0F = "859289"; # brown
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
  sops.age.keyFile = "${homeDir}/.config/sops/age/key.txt";
  sops.age.sshKeyPaths = [];
  sops.secrets =
    lib.genAttrs
    ["openrouter-key" "tavily-key" "youtube-key" "deepl-key"]
    (_: {
      owner = user;
      group = "staff";
      mode = "0400";
    });

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    max-jobs = "auto";
    cores = 0; # use all cores
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  system.configurationRevision = null;
  system.stateVersion = 6;
  system.primaryUser = user;
  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.2;
      mru-spaces = false;
      wvous-br-corner = 1;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      AppleShowAllFiles = true;
      NewWindowTarget = "Home";
      ShowPathbar = true;
    };
    NSGlobalDomain = {
      "com.apple.sound.beep.volume" = 0.0;
      AppleShowAllFiles = true;
      AppleShowScrollBars = "WhenScrolling";
    };
    screencapture.location = "~/screenshots";
    screensaver.askForPasswordDelay = 0;
    loginwindow = {
      GuestEnabled = false;
      LoginwindowText = "derp durp";
      autoLoginUser = user;
    };
    menuExtraClock = {
      Show24Hour = true;
      ShowDayOfMonth = true;
    };
    CustomUserPreferences = {
      "com.apple.remoteappleevents".enabled = false;
      "com.apple.assistant.support"."Siri Data Sharing Opt-In Status" = 0;
      "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      "com.apple.CrashReporter".DialogType = "none";
      NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
      # Secure keyboard entry - prevents keyloggers from capturing terminal input
      "com.apple.Terminal".SecureKeyboardEntry = true;
    };
  };
  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
    blockAllIncoming = false;
    allowSigned = true;
    allowSignedApp = false;
  };

  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        cmd - 1 : open -a "Librewolf"
        cmd - 2 : open -a "wezterm"
        cmd - 3 : open -a "Claude"
        cmd - 4 : open -a "WhatsApp"
        cmd - 5 : open -a "Slack"
        cmd - 6 : open -a "Brave Browser"
        cmd - 7 : open -a "Ableton Live 12 Suite"
        cmd - 8 : open -a "Signal"
        cmd - 9 : open -a "Spotify"
      '';
    };
    openssh.enable = false;
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=1
  '';

  # Stricter umask - new files only readable by owner
  system.activationScripts.umask.text = ''
    launchctl config user umask 077
  '';

  system.activationScripts.postActivation.text = let
    librewolfInstaller = ./scripts/install-librewolf.sh;
    claudeCodeConfigDir = "/Library/Application Support/ClaudeCode";
  in ''
    echo "Installing/updating LibreWolf..."
    ${pkgs.bash}/bin/bash ${librewolfInstaller}

    echo "Setting up Claude Code managed MCP config..."
    mkdir -p "${claudeCodeConfigDir}"
    cp ${mcpServersConfig} "${claudeCodeConfigDir}/managed-mcp.json"
  '';

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

    casks = [
      "supercollider"
      "blackhole-2ch"
      "blackhole-16ch"
      "element"
      "claude"
      "brave-browser"
      "wezterm@nightly"
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
      "monitorcontrol"
      "proton-mail"
      "proton-drive"
      "protonvpn"
      "gimp"
    ];
  };
  nixpkgs.hostPlatform = "aarch64-darwin";
}
