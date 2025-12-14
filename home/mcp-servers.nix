{ pkgs, config, lib, mcp-servers-nix, mcpPrograms, ... }:
let
  mcpServersConfig = mcp-servers-nix.lib.mkConfig pkgs {
    programs = mcpPrograms;
  };
in
{
  home.file = {
    "${config.xdg.configHome}/mcphub/servers.json".source = mcpServersConfig;
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    "Library/Application\ Support/Claude/claude_desktop_config.json".source = mcpServersConfig;
  };
}
