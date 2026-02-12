# macOS activation scripts (LibreWolf installer, system MCP config)
{
  pkgs,
  mcpServersConfig,
  ...
}: {
  system.activationScripts.postActivation.text = let
    librewolfInstaller = ../../scripts/install-librewolf.sh;
    claudeCodeConfigDir = "/Library/Application Support/ClaudeCode";
  in ''
    echo "Installing/updating LibreWolf..."
    ${pkgs.bash}/bin/bash ${librewolfInstaller}

    echo "Setting up Claude Code managed MCP config..."
    mkdir -p "${claudeCodeConfigDir}"
    cp ${mcpServersConfig} "${claudeCodeConfigDir}/managed-mcp.json"
  '';
}
