{ pkgs, mcp-nixos-package, ... }:
let
  # Tidal shell scripts (based on vim-tidal)
  tidal-script = pkgs.writeShellScriptBin "tidal" ''
    #!/usr/bin/env bash
    set -euf -o pipefail

    GHCI=''${GHCI:-"ghci"}
    TIDAL_BOOT_PATH=''${TIDAL_BOOT_PATH:-"$HOME/.config/tidal/Tidal.ghci"}

    # Run GHCI and load Tidal bootstrap file
    $GHCI -ghci-script $TIDAL_BOOT_PATH "$@"
  '';

  tidalvim-script = pkgs.writeShellScriptBin "tidalvim" ''
    #!/usr/bin/env bash
    set -euf -o pipefail

    VIM=''${VIM:-"nvim"}
    TMUX=''${TMUX:-"tmux"}

    FILE=''${FILE:-"$(date +%F).tidal"}
    SESSION=''${SESSION:-"tidal"}

    TIDAL_BOOT_PATH=''${TIDAL_BOOT_PATH:-"$HOME/.config/tidal/Tidal.ghci"}
    GHCI=''${GHCI:-"ghci"}

    args=''${@:-$FILE}

    # Check if tmux session "tidal" is running, attach only
    # else, create new session, split windows and run processes
    $TMUX -2 attach-session -t $SESSION || $TMUX -2 \
      new-session -s $SESSION   \; \
      split-window -v -t $SESSION   \; \
      send-keys -t 0 "$VIM $args" C-m   \; \
      send-keys -t 1 "TIDAL_BOOT_PATH=$TIDAL_BOOT_PATH GHCI=$GHCI tidal" C-m   \; \
      select-pane -t 0
  '';
in
{
  home.packages = with pkgs; [
    nixd
    nix-tree
    nix-diff
    nix-search

    du-dust
    dua

    bacon
    cargo-info
    rusty-man

    ncspot
    wiki-tui
    yt-dlp

    mprocs
    presenterm
    tokei
    httpie
    mermaid-cli
    tectonic
    just
    k9s

    (haskellPackages.ghcWithPackages (pkgs: with pkgs; [
      tidal
      cabal-install
    ]))
    tmux

    ueberzugpp
    imagemagick
    viu
    chafa
    tdf

    ghostscript
    wget
    delta
    tldr
    bottom
    hyperfine
    pango
    gnupg

    python312Full
    nodejs_22
    bun
    uv
    ruff
    glances

    claude-code
    mcp-nixos-package
    qdrant
    qdrant-web-ui
    
    # Tidal scripts
    tidal-script
    tidalvim-script
  ];
}
