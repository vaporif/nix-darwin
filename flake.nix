{
  description = "Nix darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-nixos.url = "github:utensils/mcp-nixos";
    sops-nix.url = "github:Mic92/sops-nix";
    fzf-git-sh = {
      url = "https://raw.githubusercontent.com/junegunn/fzf-git.sh/c823ffd521cb4a3a65a5cf87f1b1104ef651c3de/fzf-git.sh";
      flake = false;
    };
    yamb-yazi = {
      url = "github:h-hg/yamb.yazi/22af0033be18eead7b04c2768767d38ccfbaa05b";
      flake = false;
    };
    vim-tidal = {
      url = "github:tidalcycles/vim-tidal/e440fe5bdfe07f805e21e6872099685d38e8b761";
      flake = false;
    };
    claude-code-plugins = {
      url = "github:anthropics/claude-code/d213a74fc8e3b6efded52729196e0c2d4c3abb3e";
      flake = false;
    };
    nix-devshells.url = "github:vaporif/nix-devshells";
  };

  outputs = {
    nixpkgs,
    nix-darwin,
    mcp-nixos,
    home-manager,
    sops-nix,
    fzf-git-sh,
    yamb-yazi,
    vim-tidal,
    mcp-servers-nix,
    stylix,
    claude-code-plugins,
    nix-devshells,
    ...
  }: let
    system = "aarch64-darwin";
    user = "vaporif";
    pkgs = nixpkgs.legacyPackages.${system};
    homeDir =
      if pkgs.stdenv.isDarwin
      then "/Users/${user}"
      else "/home/${user}";

    mcp-nixos-package = mcp-nixos.packages.${system}.default;
    fzf-git-sh-package = pkgs.writeShellScriptBin "fzf-git.sh" (builtins.readFile fzf-git-sh);

    # Shared LSP packages used by both neovim and serena
    sharedLspPackages = with pkgs; [
      lua-language-server
      typescript-language-server
      basedpyright
      nixd
    ];

    # TODO: revert once nix rs is fixed https://github.com/oraios/serena/issues/800
    serenaPatched = mcp-servers-nix.packages.${system}.serena.overrideAttrs (old: {
      version = "0.1.4-unstable-2025-12-28";
      src = pkgs.fetchFromGitHub {
        owner = "vaporif";
        repo = "serena";
        rev = "0f65275856f14fbf4827e3327ee8f132ea58b156";
        hash = "sha256-fhlrO1mJYdevYVrJ02t5v3I2fiuclJRQSRinufwka+w=";
      };
    });

    mcpConfig = import ./mcp.nix {
      inherit pkgs homeDir serenaPatched mcp-servers-nix mcp-nixos-package sharedLspPackages;
    };

    mcpServersConfig = mcp-servers-nix.lib.mkConfig pkgs mcpConfig;
  in {
    formatter.${system} = pkgs.alejandra;

    checks.${system}.formatting = pkgs.runCommand "check-formatting" {} ''
      ${pkgs.alejandra}/bin/alejandra -c ${./.} && touch $out
    '';

    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit user homeDir mcpServersConfig;};
      modules = [
        {
          nixpkgs.config.allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "spacetimedb"
              "claude-code"
            ];
        }
        stylix.darwinModules.stylix
        sops-nix.darwinModules.sops
        ./system
        home-manager.darwinModules.home-manager
        {
          users.users.${user} = {
            name = user;
            home = homeDir;
          };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit user homeDir sharedLspPackages mcpServersConfig nix-devshells;
              inherit fzf-git-sh-package yamb-yazi vim-tidal claude-code-plugins;
              inherit mcp-nixos-package;
            };
            users.${user} = import ./home;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
