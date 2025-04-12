# home-manager
[![check](https://github.com/vaporif/nix-darwing/actions/workflows/check.yaml/badge.svg?branch=main)](https://github.com/vaporif/home-manager/actions/workflows/check.yaml)

This is my personal configuration for [nix-darwin](https://github.com/nix-darwin/nix-darwin) with  [home manager](https://github.com/nix-community/home-manager)

# setup

1. Clone this repo
2. Install [homebrew](https://brew.sh/)
3. Install 
4. Install [nix](https://nixos.org/download) with [flakes](https://github.com/mschwaig/howto-install-nix-with-flake-support)

6. Install [nix-darwin](https://github.com/nix-community/home-manager)

Run the initial setup which will build all the derivations which may take a while.

6. Override home manager dir with this repo

Make sure to update username & home path in `flake.nix`
```
      homeConfigurations.vaporif =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              home = {
                username = "vaporif";
                homeDirectory = "/Users/vaporif";
                stateVersion = "24.05";
              };
            }

```
and nvim lazy-lock path in `nvim/init.lua`
```
  lockfile = '/Users/vaporif/.config/home-manager/nvim/lazy-lock.json',
```

```shell
home-manager switch
```

7. Allow direnv .envrc for default devshell


```shell
direnv allow ~
```
## Learning

- https://nix.dev/recommended-reading
