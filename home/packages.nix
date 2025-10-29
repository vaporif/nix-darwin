{ pkgs, mcp-nixos-package, vim-tidal, ... }:
let
  tidal-script = pkgs.stdenv.mkDerivation {
    name = "tidal";
    src = "${vim-tidal}/bin/tidal";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/tidal
      chmod +x $out/bin/tidal
    '';
  };
in
{
  home.packages = with pkgs; [
    nixd
    nix-tree
    nix-diff
    nix-search

    dust
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
    btop

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

    python312
    nodejs_22
    bun
    uv
    ruff
    glances

    claude-code
    mcp-nixos-package
    qdrant
    qdrant-web-ui

    tidal-script
  ];
}
