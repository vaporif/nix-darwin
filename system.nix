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
  system.defaults.dock.autohide-delay = 0.2;
  system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = 0.0;
system.activationScripts.postActivation.text = ''
   ${pkgs.skhd} -r
'';
  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        cmd - 1 : open -a "kitty"
        cmd - 2 : open -a "Brave Browser"
        cmd - 3 : open -a "Telegram"
        cmd - 4 : open -a "Slack"
      '';
    };
    aerospace = {
      # enable = true;
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

          cmd-1 = "workspace 1";
          cmd-2 = "workspace 2";
          cmd-3 = "workspace 3";
          cmd-4 = "workspace 4";
          cmd-5 = "workspace 5";
          cmd-6 = "workspace 6";
          cmd-7 = "workspace 7";
          cmd-8 = "workspace 8";
          cmd-9 = "workspace 9";
          cmd-0 = "workspace 10";


          alt-1 = "move-node-to-workspace 1";
          alt-2 = "move-node-to-workspace 2";
          alt-3 = "move-node-to-workspace 3";
          alt-4 = "move-node-to-workspace 4";
          alt-5 = "move-node-to-workspace 5";
          alt-6 = "move-node-to-workspace 6";
          alt-7 = "move-node-to-workspace 7";
          alt-8 = "move-node-to-workspace 8";
          alt-9 = "move-node-to-workspace 9";
          alt-0 = "move-node-to-workspace 10";
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
