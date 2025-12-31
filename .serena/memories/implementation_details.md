# Implementation Details

This document describes what's implemented in this nix-darwin configuration and how each component is structured.

---

## 1. Configuration Architecture

### Module Hierarchy
```
flake.nix (entry point)
├── Inputs: nixpkgs, nix-darwin, home-manager, sops-nix, stylix, mcp-servers-nix
├── Overlays: allowUnfreePredicate for spacetimedb, claude-code
│
├── system/ (Darwin system configuration)
│   ├── default.nix - Nix settings, system defaults, skhd hotkeys
│   ├── theme.nix - Stylix theming (Everforest Light)
│   ├── security.nix - SOPS secrets, firewall, TouchID
│   └── homebrew.nix - Homebrew casks
│
├── home/ (Home Manager user configuration)
│   ├── default.nix - Programs: git, neovim, wezterm, gh, lazygit
│   ├── packages.nix - User packages + custom derivations
│   └── shell.nix - Zsh, shell tools, aliases
│
└── config/ (Application dotfiles)
    ├── nvim/ - Neovim configuration
    ├── wezterm/ - Terminal configuration
    ├── yazi/ - File manager configuration
    ├── karabiner/ - Keyboard customization
    ├── claude/ - Claude Code settings
    └── ...
```

### Key Design Pattern
- **Separation of concerns**: System-level config in `system/`, user-level in `home/`, dotfiles in `config/`
- **Modular imports**: Each concern has its own file
- **XDG compliance**: Configs placed via `xdg.configFile`
- **Declarative dotfiles**: All configs managed through Nix, not manually

---

## 2. Theming System (Stylix)

**Location**: `system/theme.nix`

**Implementation**:
- Custom Everforest Light base16 color scheme
- Font: Hack Nerd Font Mono (sizes: terminal=16, apps=12, desktop=10)
- Polarity: light theme
- Auto-applies to all supported applications

```nix
stylix = {
  enable = true;
  base16Scheme = { ... };  # 16 custom colors
  fonts.monospace = { package = pkgs.nerd-fonts.hack; name = "Hack Nerd Font Mono"; };
  polarity = "light";
};
```

---

## 3. Secrets Management (SOPS)

**Location**: `system/security.nix`, `secrets/secrets.yaml`

**Implementation**:
- Encryption: Age (key at `~/.config/sops/age/key.txt`)
- Secrets stored in `secrets/secrets.yaml` (encrypted YAML)
- Decrypted at runtime to `/run/secrets/<name>`
- Exposed to shell via `initContent` in zsh config

**Managed Secrets**:
- `openrouter-key` - AI API access
- `tavily-key` - Search API
- `youtube-key` - YouTube API

**Usage pattern**:
```nix
sops.secrets.openrouter-key = { owner = "vaporif"; mode = "0400"; };
# Access in shell: $(cat /run/secrets/openrouter-key)
```

---

## 4. MCP Servers Integration

**Location**: `flake.nix` → `mcpPrograms`, `system.nix` → `mcpServersConfig`

**Implementation**:
- Uses `mcp-servers-nix` flake for declarative MCP config
- Config generated via `mcp-servers-nix.lib.mkConfig`
- Output written to multiple locations via activation script:
  - `/Library/Application Support/ClaudeCode/managed-mcp.json`
  - `~/Library/Application Support/Claude/claude_desktop_config.json`
  - `~/.config/mcphub/servers.json`

**Enabled Servers**:
| Server | Purpose | Config |
|--------|---------|--------|
| filesystem | File access | args: `/Users/vaporif/Documents` |
| git | Git operations | default |
| sequential-thinking | AI reasoning | default |
| time | Time utilities | local-timezone: Europe/Lisbon |
| context7 | Context management | default |
| memory | Persistent memory | default |
| serena | Code intelligence | extraPackages: LSPs (rust-analyzer, gopls, nixd, etc.) |

---

## 5. Neovim Configuration

**Location**: `config/nvim/` directory, managed via `xdg.configFile.nvim`

### Structure
```
config/nvim/
├── init.lua          # Bootstrap lazy.nvim, load core & plugins
├── lazy-lock.json    # Plugin version lockfile (committed)
├── .stylua.toml      # Lua formatter config
└── lua/
    ├── core/
    │   ├── init.lua      # Loads all core modules
    │   ├── options.lua   # Vim options
    │   ├── autocmds.lua  # Autocommands
    │   ├── mappings.lua  # Keymaps
    │   └── lsp.lua       # LSP configuration
    └── plugins/          # 34 plugin configs (lazy-loaded)
```

### LSP Setup (`core/lsp.lua`)
**Enabled LSPs**:
- `lua_ls` - Lua
- `ts_ls` - TypeScript/JavaScript
- `gopls` - Go
- `cairo_ls` - Cairo (Starknet)
- `nixd` - Nix (with flake-aware nixpkgs expression)
- `basedpyright` + `ruff` - Python
- `just_ls` - Justfiles
- `solidity_ls_nomicfoundation` - Solidity

**LSP Features**:
- Auto-show diagnostics on cursor hold
- Document highlighting
- Custom diagnostic signs with Nerd Font icons

### Key Plugins
| Plugin | Purpose | Key binding |
|--------|---------|-------------|
| fzf-lua | Fuzzy finder | `<leader>f*` |
| neo-tree | File explorer | `<leader>e` |
| blink.cmp | Completion | `<Tab>`, `<Enter>` |
| rustacean.nvim | Rust IDE | `<leader>c*` |
| grug-far | Find & replace | `<leader>q*` |
| harpoon | Quick file nav | (configured) |
| trouble.nvim | Diagnostics | (configured) |

### Colemak Adaptation
- hjkl keys are unbound (uses Karabiner extend layer)
- Navigation: n/e/i/u (Colemak arrow positions)
- `;` → `:` for command mode
- `ii` → `<Esc>` in insert mode

---

## 6. WezTerm Configuration

**Location**: `config/wezterm/init.lua`

### Features
- **Frontend**: WebGPU (120 FPS)
- **Leader key**: `Ctrl-b` (tmux-like)
- **Tab bar**: Bottom, hidden if single tab
- **Window**: No decorations except resize, auto-maximize on startup

### Key Bindings (Leader = Ctrl-b)
| Key | Action |
|-----|--------|
| `v` | Split vertical |
| `h` | Split horizontal |
| `x` | Close pane |
| `n/i/u/e` | Navigate panes (Colemak) |
| `f` | Toggle zoom |
| `1-9` | Switch tabs |
| `,` | Rename tab |
| `r` | Enter resize mode |
| `z` | Fuzzy workspace switcher |

### Special: Toggle Terminal (`Ctrl-t`)
Custom callback that:
1. Creates bottom pane if none exists
2. Toggles zoom if pane exists
3. Switches focus appropriately

---

## 7. Shell Environment (Zsh)

**Location**: `home/shell.nix`

### Enabled Programs
| Tool | Purpose |
|------|---------|
| zsh | Shell with autosuggestions, syntax highlighting |
| starship | Prompt (git status, cmd duration) |
| fzf | Fuzzy finder + fzf-git.sh integration |
| atuin | Shell history |
| zoxide | Smart cd |
| direnv | Per-directory environments |
| carapace | Completion engine |
| eza | Enhanced ls |
| bat | Enhanced cat |
| fd | Enhanced find |
| ripgrep | Enhanced grep |
| yazi | TUI file manager |

### Aliases
```nix
t = "yy";       # Yazi
lg/g = "lazygit";
a = "claude";
e = "nvim";
x = "exit";
ls = "eza -a";
cat = "bat";
```

### Environment Setup (`initContent`)
- Increases file descriptor limits
- Sources fzf-git.sh for git-aware fzf
- Exports API keys from SOPS secrets
- Adds Homebrew and Cargo to PATH

---

## 8. Yazi File Manager

**Location**: `config/yazi/`

### Plugins
- **yamb.yazi**: Bookmark manager (from flake input)

### Key Bindings
| Key | Action |
|-----|--------|
| `<Enter>` | Open in nvim |
| `br` | Go to ~/Repos |
| `bm` | Go to /etc/nix-darwin |
| `ua` | Add bookmark |
| `ug` | Jump by key |
| `uG` | Jump by fzf |

---

## 9. System Services

### skhd (Hotkey Daemon)
**Location**: `system/default.nix` → `services.skhd`

| Hotkey | Application |
|--------|-------------|
| `Cmd+1` | LibreWolf |
| `Cmd+2` | WezTerm |
| `Cmd+3` | Claude |
| `Cmd+4` | WhatsApp |
| `Cmd+5` | Slack |
| `Cmd+6` | Brave |
| `Cmd+7` | Ableton Live |
| `Cmd+8` | Signal |
| `Cmd+9` | Spotify |

### LibreWolf Auto-Updater
**Location**: `scripts/install-librewolf.sh`

**Implementation**:
- Fetches latest version from GitLab API
- Compares with installed version
- Downloads ARM64 DMG, mounts, copies to /Applications
- Removes quarantine attribute
- Runs on system activation

---

## 10. Custom Derivations

**Location**: `home/packages.nix`

### tidal-script
Wraps vim-tidal's tidal script for TidalCycles live coding.

### unclog
Builds `unclog` (changelog tool) from source with Rust 1.80+ compatibility patch.

### nomicfoundation-solidity-language-server
Builds Hardhat's Solidity LSP from npm with:
- Removes test workspaces (break build)
- Patches analytics requirement
- macOS-specific clang setup

---

## 11. Git Configuration

**Location**: `home/default.nix` → `programs.git`

### Features
- GPG signing (key: `AE206889199EC9E9`)
- Delta as pager (syntax highlighting)
- Histogram diff algorithm
- Auto-setup remote on push
- Autosquash/autostash for rebase

### Global Ignores
- `.serena/`
- `.claude/`
- `CLAUDE.md`

---

## 12. Homebrew Integration

**Location**: `system/homebrew.nix`

### Behavior
- Auto-update on activation
- Auto-upgrade packages
- `zap` cleanup (removes unmanaged casks)

### Notable Casks
- supercollider, blackhole-* (audio)
- orbstack (Docker alternative)
- karabiner-elements (keyboard)
- proton-mail, protonvpn, proton-drive (privacy)
- secretive (SSH key management)
