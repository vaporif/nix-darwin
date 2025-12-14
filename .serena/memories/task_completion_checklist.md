# Task Completion Checklist

## After Modifying Nix Configuration Files

### Required Steps
1. **Apply Changes**: Run `sudo darwin-rebuild switch`
2. **Check for Errors**: Review the build output for any errors or warnings
3. **Verify Changes**: Test that the changes work as expected

### If Adding New Packages
- Add to `home/packages.nix` for user packages
- Add to `system.nix` for system packages
- Add to `homebrew.casks` in `system.nix` for GUI apps from Homebrew

### If Modifying Shell Configuration
- Changes take effect after `darwin-rebuild switch`
- May need to restart shell or run `source ~/.zshrc`

### If Modifying Neovim Configuration
- Restart Neovim to load new configurations
- For Lua files, run StyLua for formatting: `stylua nvim/`

### If Modifying Secrets
- Edit with: `sops secrets/secrets.yaml`
- Reference via `config.sops.secrets.<name>.path`

## Code Quality Checks

### Lua Files
- Format with StyLua: `stylua <file>`
- Ensure 2-space indentation
- Check column width doesn't exceed 160

### Nix Files
- Ensure proper indentation (2 spaces)
- Test builds successfully with `darwin-rebuild switch`

## No Formal Testing/Linting Pipeline
This configuration repository does not have:
- Unit tests
- CI/CD pipeline (there's a `.github/workflows/check.yaml` but it appears incomplete)
- Automated linting

Testing is done manually by applying the configuration and verifying functionality.
