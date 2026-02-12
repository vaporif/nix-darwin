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
      url = "github:vaporif/mcp-servers-nix/qdrant";
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
    # Host configurations
    hosts = {
      macbook = import ./hosts/macbook.nix;
      ubuntu-desktop = import ./hosts/ubuntu-desktop.nix;
    };

    # Apply custom overlays
    localPackages = import ./overlays {inherit vim-tidal;};

    # Helper: create pkgs for a given system
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        overlays = [localPackages];
      };

    # Helper: derive homeDir from system and user
    mkHomeDir = pkgs: user:
      if pkgs.stdenv.isDarwin
      then "/Users/${user}"
      else "/home/${user}";

    # Darwin-specific values (kept at top level for backward compat with checks/formatter)
    darwinConfig = hosts.macbook;
    pkgs = mkPkgs darwinConfig.system;
    inherit (darwinConfig) user system;
    homeDir = mkHomeDir pkgs user;

    mcp-nixos-package = mcp-nixos.packages.${system}.default;
    fzf-git-sh-package = pkgs.writeShellScriptBin "fzf-git.sh" (builtins.readFile fzf-git-sh);

    sharedLspPackages = with pkgs; [
      lua-language-server
      typescript-language-server
      basedpyright
      nixd
    ];

    # TODO: revert once nix rs is fixed https://github.com/oraios/serena/issues/800
    serenaPatched = mcp-servers-nix.packages.${system}.serena.overrideAttrs (_: {
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
      userConfig = darwinConfig;
    };

    mcpServersConfig = mcp-servers-nix.lib.mkConfig pkgs mcpConfig;
  in {
    formatter.${system} = pkgs.alejandra;

    checks.${system} =
      {
        formatting = pkgs.runCommand "check-formatting" {} ''
          ${pkgs.alejandra}/bin/alejandra -c ${./.} && touch $out
        '';
      }
      // pkgs.unclog.passthru.tests
      // pkgs.nomicfoundation_solidity_language_server.passthru.tests
      // pkgs.claude_formatter.passthru.tests
      // pkgs.tidal_script.passthru.tests;

    darwinConfigurations.${darwinConfig.hostname} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit user homeDir mcpServersConfig;
        userConfig = darwinConfig;
      };
      modules = [
        {
          nixpkgs.overlays = [localPackages];
          nixpkgs.config.allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "spacetimedb"
              "claude-code"
            ];
        }
        stylix.darwinModules.stylix
        sops-nix.darwinModules.sops
        ./system/darwin
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
              inherit fzf-git-sh-package yamb-yazi claude-code-plugins;
              inherit mcp-nixos-package;
              userConfig = darwinConfig;
            };
            users.${user} = {
              imports = [
                ./home/common
                ./home/darwin
              ];
            };
            backupFileExtension = "backup";
          };
        }
      ];
    };

    homeConfigurations."${hosts.ubuntu-desktop.user}@${hosts.ubuntu-desktop.hostname}" = let
      linuxConfig = hosts.ubuntu-desktop;
      linuxPkgs = mkPkgs linuxConfig.system;
      linuxHomeDir = mkHomeDir linuxPkgs linuxConfig.user;
      linuxMcpNixos = mcp-nixos.packages.${linuxConfig.system}.default;
      linuxSerena = mcp-servers-nix.packages.${linuxConfig.system}.serena.overrideAttrs (_: {
        version = "0.1.4-unstable-2025-12-28";
        src = linuxPkgs.fetchFromGitHub {
          owner = "vaporif";
          repo = "serena";
          rev = "0f65275856f14fbf4827e3327ee8f132ea58b156";
          hash = "sha256-fhlrO1mJYdevYVrJ02t5v3I2fiuclJRQSRinufwka+w=";
        };
      });
      linuxSharedLsp = with linuxPkgs; [
        lua-language-server
        typescript-language-server
        basedpyright
        nixd
      ];
      linuxMcpConfig = import ./mcp.nix {
        pkgs = linuxPkgs;
        homeDir = linuxHomeDir;
        serenaPatched = linuxSerena;
        inherit mcp-servers-nix;
        mcp-nixos-package = linuxMcpNixos;
        sharedLspPackages = linuxSharedLsp;
        userConfig = linuxConfig;
      };
      linuxMcpServersConfig = mcp-servers-nix.lib.mkConfig linuxPkgs linuxMcpConfig;
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        extraSpecialArgs = {
          inherit (linuxConfig) user;
          homeDir = linuxHomeDir;
          sharedLspPackages = linuxSharedLsp;
          mcpServersConfig = linuxMcpServersConfig;
          inherit nix-devshells yamb-yazi claude-code-plugins;
          fzf-git-sh-package = linuxPkgs.writeShellScriptBin "fzf-git.sh" (builtins.readFile fzf-git-sh);
          mcp-nixos-package = linuxMcpNixos;
          userConfig = linuxConfig;
        };
        modules = [
          {
            nixpkgs.overlays = [localPackages];
            nixpkgs.config.allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "spacetimedb"
                "claude-code"
              ];
          }
          stylix.homeManagerModules.stylix
          ./modules/theme.nix
          ./home/common
          ./home/linux
        ];
      };
  };
}
