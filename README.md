# home-manager
[![check](https://github.com/vaporif/home-manager/actions/workflows/check.yaml/badge.svg?branch=main)](https://github.com/vaporif/home-manager/actions/workflows/check.yaml)

This is my personal configuration for nix [home manager](https://github.com/nix-community/home-manager)

I'm using MacOs. This config could be easily migrated to anything nix supports.

# setup

1. Clone this repo
2. Install [homebrew](https://brew.sh/)
3. Install packages via brew
   
```shell
brew bundle
```

It's used only for karabiner and kitty as nix installation for them is either complicated/brittle.

4. Install [nix](https://nixos.org/download) with [flakes](https://github.com/mschwaig/howto-install-nix-with-flake-support)

6. Install [home-manager](https://github.com/nix-community/home-manager)

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
