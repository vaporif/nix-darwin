_: {
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
      "mpv"
      "vlc"
      "orbstack"
      "qbittorrent"
      "secretive"
      "signal"
      "cardinal"
      "keycastr"
      "zoom"
      "monitorcontrol"
      "proton-mail"
      "proton-drive"
      "protonvpn"
      "gimp"
      "syncthing-app"
      # "rectangle"
    ];
  };
}
