# Linux-specific home-manager config
{
  pkgs,
  homeDir,
  ...
}: {
  stylix.targets = {
    gnome.enable = false;
    gtk.enable = false;
    kde.enable = false;
  };
  systemd.user.services.qdrant = {
    Unit = {
      Description = "Qdrant vector database";
      After = ["network.target"];
    };
    Service = {
      ExecStart = "${pkgs.qdrant}/bin/qdrant --config-path ${homeDir}/.qdrant/config.yaml";
      Restart = "always";
      StandardOutput = "append:${homeDir}/.qdrant/qdrant.log";
      StandardError = "append:${homeDir}/.qdrant/qdrant.err";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  home.packages = with pkgs; [
    librewolf
  ];

  # TODO: app shortcuts (equivalent of skhd on macOS)
  # swhkd is not in nixpkgs yet; using GNOME dconf keybindings instead
  # Customize bindings when machine is set up
  # TODO: re-enable once GNOME session stability is confirmed
  # dconf.settings = {
  #   "org/gnome/settings-daemon/plugins/media-keys" = {
  #     custom-keybindings = [
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
  #     ];
  #   };
  #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
  #     name = "Terminal";
  #     command = "wezterm";
  #     binding = "<Super>t";
  #   };
  #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
  #     name = "Browser";
  #     command = "librewolf";
  #     binding = "<Super>r";
  #   };
  # };
}
