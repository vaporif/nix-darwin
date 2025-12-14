# Code Style and Conventions

## Nix Files (.nix)
- **Indentation**: 2 spaces
- **Naming**: kebab-case for file names, camelCase for attribute names
- **Structure**: Module pattern with `{ pkgs, config, lib, ... }:` at top
- **Lists**: Opening bracket on same line, items indented
- **Attribute sets**: Opening brace on same line, closing brace aligned with start
- **Imports**: Group related imports together
- **Comments**: Use `#` for single line comments

### Example Nix Style
```nix
{ pkgs, config, ... }:
{
  programs.example = {
    enable = true;
    settings = {
      key = "value";
      list = [
        "item1"
        "item2"
      ];
    };
  };
}
```

## Lua Files (Neovim, WezTerm, Yazi)
- **Formatter**: StyLua
- **Indentation**: 2 spaces
- **Line endings**: Unix (LF)
- **Column width**: 160 characters
- **Quotes**: Single quotes preferred (`AutoPreferSingle`)
- **Call parentheses**: None (omit when possible)

### StyLua Configuration (nvim/.stylua.toml)
```toml
column_width = 160
line_endings = "Unix"
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferSingle"
call_parentheses = "None"
```

## Git Configuration
- **Default branch**: `main`
- **Commits**: Signed with GPG (key: `AE206889199EC9E9`)
- **Commit style**: Verbose commits enabled
- **Diff algorithm**: Histogram
- **Merge style**: diff3 conflict markers

## General Conventions
- Keep configurations modular (separate files for shell, packages, etc.)
- Use Home Manager programs when available instead of raw file configuration
- Prefer declarative configuration over imperative setup
- Store secrets in SOPS-encrypted files, never in plain text
