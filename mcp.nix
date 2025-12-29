{
  pkgs,
  homeDir,
  serenaPatched,
  mcp-servers-nix,
  mcp-nixos-package,
}: {
  programs = {
    filesystem = {
      enable = true;
      args = [
        "${homeDir}/Documents"
        "/private/etc/nix-darwin"
        "${homeDir}/.cargo"
        "${homeDir}/go"
        "/nix/store"
        "${homeDir}/.config"
        "${homeDir}/.local/share"
      ];
    };
    git.enable = true;
    sequential-thinking.enable = true;
    time = {
      enable = true;
      args = ["--local-timezone" "Europe/Lisbon"];
    };
    context7.enable = true;
    memory.enable = true;
    serena = {
      enable = true;
      package = serenaPatched;
      enableWebDashboard = true;
      extraPackages = with pkgs; [
        rust-analyzer
        gopls
        nixd
        typescript-language-server
        basedpyright
        lua-language-server
      ];
    };
    github = {
      enable = true;
      passwordCommand = {
        GITHUB_PERSONAL_ACCESS_TOKEN = [
          (pkgs.lib.getExe pkgs.gh)
          "auth"
          "token"
        ];
      };
    };
    deepl = {
      enable = true;
      passwordCommand = {
        DEEPL_API_KEY = ["cat" "/run/secrets/deepl-key"];
      };
    };
  };
  settings.servers = {
    tavily = {
      command = "${pkgs.writeShellScript "tavily-mcp-wrapper" ''
        export TAVILY_API_KEY="$(cat /run/secrets/tavily-key)"
        exec ${mcp-servers-nix.packages.${pkgs.stdenv.hostPlatform.system}.tavily-mcp}/bin/tavily-mcp
      ''}";
    };
    nixos = {
      command = "${mcp-nixos-package}/bin/mcp-nixos";
    };
  };
}
