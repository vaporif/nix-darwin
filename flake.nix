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
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-nixos.url = "github:utensils/mcp-nixos";
    mcp-servers-nix = {
      url = "github:vaporif/mcp-servers-nix/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fzf-git-sh = {
      url = "https://raw.githubusercontent.com/junegunn/fzf-git.sh/c823ffd521cb4a3a65a5cf87f1b1104ef651c3de/fzf-git.sh";
      flake = false;
    };
    yamb-yazi = {
      url = "github:h-hg/yamb.yazi/22af0033be18eead7b04c2768767d38ccfbaa05b";
      flake = false;
    };
    vim-tidal = {
      url = "github:tidalcycles/vim-tidal";
      flake = false;
    };
  };

  outputs = { nixpkgs, nix-darwin, mcp-nixos, home-manager, sops-nix, fzf-git-sh, yamb-yazi, vim-tidal, mcp-servers-nix, stylix, ... }:
    let
      system = "aarch64-darwin";

      mcp-nixos-package = mcp-nixos.packages.${system}.default;
      pkgs = nixpkgs.legacyPackages.${system};
      fzf-git-sh-package = pkgs.writeShellScriptBin "fzf-git.sh" (builtins.readFile fzf-git-sh);

      mcpConfig = {
        programs = {
          filesystem = {
            enable = true;
            args = [ "/Users/vaporif/Documents" ];
          };
          git.enable = true;
          sequential-thinking.enable = true;
          time = {
            enable = true;
            args = [ "--local-timezone" "Europe/Lisbon" ];
          };
          context7.enable = true;
          memory.enable = true;
          serena = {
            enable = true;
            extraPackages = with pkgs; [
              rust-analyzer
              gopls
              nixd
              typescript-language-server
              basedpyright
              lua-language-server
            ];
          };
          github = {
            enable = true;
            passwordCommand = {
              GITHUB_PERSONAL_ACCESS_TOKEN = [
                (pkgs.lib.getExe pkgs.gh)
                "auth"
                "token"
              ];
            };
          };
          deepl = {
            enable = true;
            passwordCommand = {
              DEEPL_API_KEY = [ "cat" "/run/secrets/deepl-key" ];
            };
          };
          # youtube = {
          #   enable = true;
          #   passwordCommand = {
          #     YOUTUBE_API_KEY = [
          #       "cat"
          #       "/run/secrets/youtube-key"
          #     ];
          #   };
          # };
        };
        settings.servers = {
          tavily = {
            command = "${pkgs.writeShellScript "tavily-mcp-wrapper" ''
              export TAVILY_API_KEY="$(cat /run/secrets/tavily-key)"
              exec ${mcp-servers-nix.packages.${system}.tavily-mcp}/bin/tavily-mcp
            ''}";
          };
          nixos = {
            command = "${mcp-nixos-package}/bin/mcp-nixos";
          };
        };
      };
    in
    {
      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit mcp-servers-nix mcpConfig; };
        modules = [
          {
            nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              "spacetimedb"
              "claude-code"
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
                inherit mcp-servers-nix mcp-nixos-package mcpConfig;
              };
              users.vaporif = import ./home;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
