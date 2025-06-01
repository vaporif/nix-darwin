{ pkgs, config, lib, mcp-servers-nix, ... }:
let
  mcpServersConfig = mcp-servers-nix.lib.mkConfig pkgs
    {
      programs = {
        filesystem = {
          enable = true;
          args = [
            "${config.home.homeDirectory}/mcp-data"
          ];
        };
        fetch.enable = true;
        git.enable = true;
        # github = {
        #   enable = true;
        #   passwordCommand = {
        #     GITHUB_PERSONAL_ACCESS_TOKEN = [
        #       (pkgs.lib.getExe config.programs.gh.package)
        #       "auth"
        #       "token"
        #     ];
        #   };
        # };
      };
    };
in
{
  home.file = {
    "${config.xdg.configHome}/mcphub/servers.json".source = mcpServersConfig;
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    "Library/Application\ Support/Claude/claude_desktop_config.json".source = mcpServersConfig;
  };
}
