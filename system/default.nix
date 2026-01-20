{
  pkgs,
  user,
  mcpServersConfig,
  userConfig,
  ...
}: {
  imports = [
    ./theme.nix
    ./security.nix
    ./homebrew.nix
  ];

  time.timeZone = userConfig.timezone;

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
    substituters =
      [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ]
      ++ (
        if userConfig.cachix.name != ""
        then ["https://${userConfig.cachix.name}.cachix.org"]
        else []
      );
    trusted-public-keys =
      [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ]
      ++ (
        if userConfig.cachix.publicKey != ""
        then [userConfig.cachix.publicKey]
        else []
      );
  };

  system = {
    configurationRevision = null;
    stateVersion = 6;
    primaryUser = user;

    defaults = {
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
  };

  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        # App shortcuts (hyper = caps lock via karabiner)
        # Left hand
        hyper - r : open -a "Librewolf"             # lib[r]ewolf
        hyper - t : open -a "wezterm"               # [t]erminal
        hyper - c : open -a "Claude"                # [c]laude
        hyper - s : open -a "Slack"                 # [s]lack
        hyper - b : open -a "Brave Browser"         # [b]rave
        hyper - d : open -a "Discord"               # [d]iscord
        # Right hand
        hyper - w : open -a "WhatsApp"              # [w]hatsapp
        hyper - m : open -a "Ableton Live 12 Suite" # [m]usic
        hyper - l : open -a "Signal"                # signa[l]
        hyper - p : open -a "Spotify"               # s[p]otify
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

  nixpkgs.hostPlatform = userConfig.system;
}
