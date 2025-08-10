{ pkgs, mcp-nixos-package, ... }:
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

    ghc
    tmux
    haskellPackages.tidal
    haskellPackages.cabal-install

    ueberzugpp
    imagemagick
    viu
    chafa

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
  ];
}
