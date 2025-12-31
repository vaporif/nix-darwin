{
  lib,
  user,
  homeDir,
  ...
}: {
  sops.defaultSopsFile = ../secrets/secrets.yaml;
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

  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
    blockAllIncoming = false;
    allowSigned = true;
    allowSignedApp = false;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=1
  '';

  # Stricter umask - new files only readable by owner
  system.activationScripts.umask.text = ''
    launchctl config user umask 077
  '';
}
