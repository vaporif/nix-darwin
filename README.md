# home-manager
[![check](https://github.com/vaporif/nix-darwin/actions/workflows/check.yaml/badge.svg?branch=main)](https://github.com/vaporif/nix-darwin/actions/workflows/check.yaml)

This is my personal configuration for [nix-darwin](https://github.com/nix-darwin/nix-darwin) with  [home manager](https://github.com/nix-community/home-manager)

# setup

1. Clone this repo
2. Install [homebrew](https://brew.sh/)
3. Install 
4. Install [nix](https://nixos.org/download)

6. Install [nix-darwin]([https://github.com/nix-community/home-manager](https://github.com/nix-darwin/nix-darwin))

Run the initial setup which will build all the derivations which may take a while.

6. Override home manager dir with this repo

Make sure to update username & home path in `flake.nix`
```
users.users.vaporif = {
  name = "vaporif";
  home = "/Users/vaporif";
};
```
and nvim lazy-lock path in `nvim/init.lua`
```
  lockfile = '/etc/nix-darwin/nvim/lazy-lock.json',
```

```shell
darwin-rebuild switch
```

7. Allow direnv .envrc for default devshell


```shell
direnv allow ~
```
## Learning

- https://nix.dev/recommended-reading
