{
  pkgs,
  user,
  mcp-servers-nix,
  mcpConfig,
  ...
}: let
  mcpServersConfig = mcp-servers-nix.lib.mkConfig pkgs mcpConfig;
in {
  imports = [
    ./theme.nix
    ./security.nix
    ./homebrew.nix
  ];

  environment.systemPackages = with pkgs; [
    age
    libressl
  ];

  # Address the Determinate error
  nix.enable = false;

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

  system.activationScripts.postActivation.text = let
    librewolfInstaller = ../scripts/install-librewolf.sh;
    claudeCodeConfigDir = "/Library/Application Support/ClaudeCode";
  in ''
    echo "Installing/updating LibreWolf..."
    ${pkgs.bash}/bin/bash ${librewolfInstaller}

    echo "Setting up Claude Code managed MCP config..."
    mkdir -p "${claudeCodeConfigDir}"
    cp ${mcpServersConfig} "${claudeCodeConfigDir}/managed-mcp.json"
  '';

  nixpkgs.hostPlatform = "aarch64-darwin";
}
