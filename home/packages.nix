{
  pkgs,
  mcp-nixos-package,
  vim-tidal,
  ...
}: let
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

  unclog = import ../pkgs/unclog.nix {inherit pkgs;};

  # Auto-formatter for Claude Code hooks
  claudeFormatter = pkgs.writeShellScriptBin "claude-formatter" ''
    file_path=$(${pkgs.jq}/bin/jq -r '.tool_input.file_path // empty')
    [ -z "$file_path" ] || [ ! -f "$file_path" ] && exit 0

    case "$file_path" in
      *.nix) alejandra -q "$file_path" 2>/dev/null || true ;;
      *.go)  gofmt -w "$file_path" 2>/dev/null || true ;;
      *.rs)  rustfmt "$file_path" 2>/dev/null || true ;;
    esac
  '';

  nomicfoundation-solidity-language-server = import ../pkgs/nomicfoundation-solidity-language-server.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    nixd
    alejandra
    nix-tree
    nix-diff
    nix-search

    dust
    dua

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
    sops

    (haskellPackages.ghcWithPackages (pkgs:
      with pkgs; [
        tidal
        cabal-install
      ]))
    tmux

    ueberzugpp
    imagemagick
    tdf

    ghostscript
    wget
    delta
    tldr
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

    tidal-script
    unclog
    nomicfoundation-solidity-language-server
    claudeFormatter
  ];
}
