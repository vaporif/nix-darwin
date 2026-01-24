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
    nix-output-monitor
    nvd

    dust
    dua
    gnused
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
    just
    k9s
    lazydocker
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

    wget
    delta
    difftastic
    ouch
    hyperfine

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
