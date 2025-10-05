{
  description = "Nix darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # mcp-hub.url = "github:ravitemer/mcp-hub";
    mcp-nixos.url = "github:utensils/mcp-nixos";
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fzf-git-sh = {
      url = "https://raw.githubusercontent.com/junegunn/fzf-git.sh/28b544a7b6d284b8e46e227b36000089b45e9e00/fzf-git.sh";
      flake = false;
    };
    yamb-yazi = {
      url = "github:h-hg/yamb.yazi";
      flake = false;
    };
    vim-tidal = {
      url = "github:tidalcycles/vim-tidal";
      flake = false;
    };
  };

  outputs = { nixpkgs, nixpkgs-stable, nix-darwin, mcp-nixos, home-manager, sops-nix, fzf-git-sh, yamb-yazi, vim-tidal, mcp-servers-nix, stylix, ... }:
    let
      system = "aarch64-darwin";

      mcp-nixos-package = mcp-nixos.packages.${system}.default;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      fzf-git-sh-package = pkgs.writeShellScriptBin "fzf-git.sh" (builtins.readFile fzf-git-sh);
    in
    {
      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          {
            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              "spacetimedb"
              "claude-code"
            ];
            nixpkgs.overlays = [
              (import ./overlays/tectonic-fix.nix)
            ];
          }
          stylix.darwinModules.stylix
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
                inherit fzf-git-sh-package yamb-yazi vim-tidal;
                inherit mcp-servers-nix mcp-nixos-package pkgs-stable;
              };
              users.vaporif = import ./home;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
