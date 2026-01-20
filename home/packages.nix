{
  pkgs,
  mcp-nixos-package,
  ...
}: {
  home.packages = with pkgs; [
    nixd
    alejandra
    statix
    deadnix
    nix-tree
    nix-diff
    nix-search

    dust
    dua
    sd
    jaq
    stylua
    selene
    typos
    taplo
    shellcheck
    actionlint
    cachix
    vulnix

    bacon
    cargo-info
    rusty-man

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
    btop
    procs
    sops

    (haskellPackages.ghcWithPackages (pkgs:
      with pkgs; [
        tidal
        cabal-install
      ]))
    tmux

    tdf

    ghostscript
    wget
    delta
    difftastic
    ouch
    hyperfine
    pango
    gnupg

    python312
    nodejs_22
    bun
    uv
    ruff

    claude-code
    mcp-nixos-package
    qdrant
    qdrant-web-ui

    tidal_script
    unclog
    nomicfoundation_solidity_language_server
    claude_formatter
  ];
}
