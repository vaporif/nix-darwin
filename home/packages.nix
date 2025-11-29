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

  unclog = pkgs.rustPlatform.buildRustPackage rec {
    pname = "unclog";
    version = "0.7.3";
    src = pkgs.fetchFromGitHub {
      owner = "informalsystems";
      repo = "unclog";
      rev = "v${version}";
      hash = "sha256-UebNRzPEhMPwbzlRIvrKl5sdjbwyo6nA6fJQeqM0I6g=";
    };
    cargoHash = "sha256-sHYdDhfkxDazKQjhho3q+dN2ylbPeSeBPJai1lgDeRk=";
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];
    # Patch to fix time crate Rust 1.80+ compatibility
    postPatch = ''
      find $cargoDepsCopy -name "mod.rs" -path "*time-*/format_description/parse/*" \
        -exec sed -i 's/\.collect::<Result<Box<_>, _>>()/.collect::<Result<Vec<_>, _>>().map(|v| v.into_boxed_slice())/g' {} \;
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
    unclog
  ];
}
