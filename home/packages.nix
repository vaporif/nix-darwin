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

  nomicfoundation-solidity-language-server = pkgs.buildNpmPackage {
    pname = "nomicfoundation-solidity-language-server";
    version = "0.8.25";

    src = pkgs.fetchFromGitHub {
      owner = "NomicFoundation";
      repo = "hardhat-vscode";
      rev = "v0.8.25";
      hash = "sha256-DJm/qv5WMfjwLs8XBL2EfL11f5LR9MHfTT5eR2Ir37U=";
    };

    npmDepsHash = "sha256-bLP5kVpfRIvHPCutUvTz5MFal6g5fimzXGNdQEhB+Lw=";
    npmWorkspace = "server";

    postPatch = ''
      # Remove test workspaces that try to run npm install during build
      rm -rf test

      # Patch bundle.js to not require analytics secrets
      substituteInPlace server/scripts/bundle.js \
        --replace-fail 'if (!value || value === "")' 'if (false)'
    '';

    nativeBuildInputs = with pkgs; [ pkg-config ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ clang_20 ];

    buildInputs = [ pkgs.libsecret ];

    postInstall = ''
      # Remove dangling symlinks created by npm workspaces
      find -L $out -type l -print -delete
    '';

    meta = {
      description = "Language server for Solidity";
      homepage = "https://github.com/NomicFoundation/hardhat-vscode/tree/development/server";
      license = pkgs.lib.licenses.mit;
      mainProgram = "nomicfoundation-solidity-language-server";
    };
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
    nomicfoundation-solidity-language-server
  ];
}
