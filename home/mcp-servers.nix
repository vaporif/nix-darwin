{ pkgs, config, lib, mcp-servers-nix, ... }:
let
  mcpServersConfig = mcp-servers-nix.lib.mkConfig pkgs
    {
      programs = {
        filesystem = {
          enable = true;
          args = [
            "${config.home.homeDirectory}/Documents"
          ];
        };
        git.enable = true;
        sequential-thinking.enable = true;
        time = {
          enable = true;
          args = [
            "--local-timezone"
            "Europe/Lisbon"
          ];
        };
        everything.enable = true;
        context7.enable = true;
        memory.enable = true;
        github = {
          enable = true;
          passwordCommand = {
            GITHUB_PERSONAL_ACCESS_TOKEN = [
              (pkgs.lib.getExe config.programs.gh.package)
              "auth"
              "token"
            ];
          };
        };

        # tavily = {
        #   enable = true;
        #   passwordCommand = {
        #     TAVILY_API_KEY = [
        #       "cat"
        #       "/run/secrets/tavily-key"
        #     ];
        #   };
        # };
        # youtube = {
        #   enable = true;
        #   passwordCommand = {
        #     YOUTUBE_API_KEY = [
        #       "cat"
        #       "/run/secrets/youtube-key"
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
