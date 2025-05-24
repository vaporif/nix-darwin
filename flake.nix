{
  description = "Nix darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    mcp-hub.url = "github:ravitemer/mcp-hub";
    fzf-git-sh = {
      url = "https://raw.githubusercontent.com/junegunn/fzf-git.sh/28b544a7b6d284b8e46e227b36000089b45e9e00/fzf-git.sh";
      flake = false;
    };
    yamb-yazi = {
      url = "github:h-hg/yamb.yazi";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, nix-darwin, mcp-hub, home-manager, sops-nix, fzf-git-sh, yamb-yazi, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      mcp-hub-package = mcp-hub.packages.${system}.default;
      fzf-git-sh-package = pkgs.writeShellScriptBin "fzf-git.sh" (builtins.readFile fzf-git-sh);
    in
    {
      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          sops-nix.darwinModules.sops
          ./system.nix
          home-manager.darwinModules.home-manager
          {
            users.users.vaporif = {
              name = "vaporif";
              home = "/Users/vaporif";
            };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit mcp-hub-package fzf-git-sh-package yamb-yazi;
              };
              users.vaporif = import ./home.nix;
            };
          }
        ];
      };
    };
}
