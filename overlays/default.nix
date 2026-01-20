{vim-tidal}: final: prev: {
  unclog = final.callPackage ../pkgs/unclog.nix {};

  nomicfoundation_solidity_language_server =
    final.callPackage ../pkgs/nomicfoundation-solidity-language-server.nix {};

  claude_formatter = final.writeShellScriptBin "claude-formatter" ''
    file_path=$(${final.jaq}/bin/jaq -r '.tool_input.file_path // empty')
    [ -z "$file_path" ] || [ ! -f "$file_path" ] && exit 0

    case "$file_path" in
      *.nix) alejandra -q "$file_path" 2>/dev/null || true ;;
      *.go)  gofmt -w "$file_path" 2>/dev/null || true ;;
      *.rs)  rustfmt "$file_path" 2>/dev/null || true ;;
      *.lua) stylua "$file_path" 2>/dev/null || true ;;
    esac
  '';

  tidal_script = final.stdenv.mkDerivation {
    name = "tidal";
    src = "${vim-tidal}/bin/tidal";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/tidal
      chmod +x $out/bin/tidal
    '';
  };
}
