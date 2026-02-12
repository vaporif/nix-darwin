let
  isDarwin = builtins.match ".*-darwin" builtins.currentSystem != null;
in
  if isDarwin
  then import ./hosts/macbook.nix
  else import ./hosts/ubuntu-desktop.nix
