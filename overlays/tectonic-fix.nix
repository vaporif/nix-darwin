final: prev:
let
  # Use nixpkgs 24.05 stable where tectonic builds with older Rust
  oldPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
    sha256 = "0zydsqiaz8qi4zd63zsb2gij2p614cgkcaisnk11wjy3nmiq0x1s";
  }) {
    system = final.system;
  };
in {
  tectonic = oldPkgs.tectonic;
}
